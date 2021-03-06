;;; company-coq-tg.el --- Parser for the output of [Print Grammar tactic] -*- lexical-binding: t -*-

;; Copyright (C) 2015  Clément Pit--Claudel
;; Author: Clément Pit--Claudel <clement.pitclaudel@live.com>
;; URL: https://github.com/cpitclaudel/company-coq

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A collection of facilities to parse the output of Print Grammar Tactic and
;; learn abbrevs from it.  Parsing is implemented by tweaking the syntax to make
;; it understandable by the Lisp reader, and manually going through the
;; resulting S-exps.

;;; Code:

(require 'cl-lib)

(defconst company-coq-tg--preprocessor-substitutions '(("\n"  . " ") ("[ "  . "( OR-GROUP ") (" ]"  . " )")
                                                       (" | " . " OR ") ("; "  . " AND "))
  "List of replacements to facilitate parsing.")

(defun company-coq--split-seq (seq sep)
  "Partition SEQ, splitting on SEP."
  (cl-loop for elem in seq with acc with splits
           if      (eq elem sep)
           do      (push (reverse acc) splits)
           and do  (setq acc nil)
           else do (push elem acc)
           finally return (reverse (cons (reverse acc) splits))))

(defun company-coq--list-to-table (seq)
  "Convert SEQ to a hashtable."
  (let ((tbl (make-hash-table :test #'equal)))
    (cl-loop for k in seq
             do (puthash k t tbl))
    tbl))

(defvar company-coq-tg--useless nil
  "Tactic notations to ignore while parsing the output of `company-coq-all-notations-cmd'.")

(defun company-coq--filter-using-table (seq table)
  "Filter out elements of SEQ present in TABLE."
  (cl-delete-if (lambda (x) (gethash x table)) seq))

(defun company-coq-tg--parse-list (sexp)
  "The OR-GROUP symbol at the head of SEXP is an artefact due to the preprocessing."
  (pcase sexp
    (`(OR-GROUP . ,rest) (company-coq-tg--parse-tactic-subs rest))
    (_                   (company-coq-tg--parse-tactic-part sexp))))

(defun company-coq-tg--parse-tactic-part (sexp)
  "Parse a single tactic component SEXP."
  (pcase sexp
    (`(IDENT ,str)        str)
    (`(OPT ,sub)          (list 'OPT (company-coq-tg--parse-list sub)))
    (`(LIST0 ,sub)        (list 'LIST0 "" (company-coq-tg--parse-list sub)))
    (`(LIST1 ,sub)        (list 'LIST1 "" (company-coq-tg--parse-list sub)))
    (`(LIST0 ,sub SEP ,s) (list 'LIST0 s (company-coq-tg--parse-list sub)))
    (`(LIST1 ,sub SEP ,s) (list 'LIST1 s (company-coq-tg--parse-list sub)))
    (`(OR-GROUP . ,sub)   (cons 'OR-GROUP (cl-loop for alt in (company-coq--split-seq sub 'OR)
                                                   collect (company-coq-tg--parse-tactic-subs alt))))
    (`(,x LEVEL . ,_tl)   (company-coq-tg--parse-tactic-part x))
    (`(,other)            (company-coq-tg--parse-tactic-part other))
    (`(METAIDENT ,s)      (company-coq-tg--parse-tactic-part s))
    (`(STRING ,s)         (symbol-name s))
    (`(,_h . ,_t)         (error "Tactic parsing failure [%s]" sexp))
    (_                    sexp)))

(defun company-coq-tg--parse-tactic-subs (sexp)
  "Parse a single tactic SEXP."
  (mapcar #'company-coq-tg--parse-tactic-part (company-coq--split-seq sexp 'AND)))

(defun company-coq-tg--parse-tactic (sexp)
  "Parse a single tactic SEXP."
  (cons 'TACTIC (company-coq-tg--parse-tactic-subs sexp)))

(defun company-coq-tg--parse-group (sexp cont)
  "Turn a group SEXP into tactic abbrevs using CONT."
  (pcase sexp
    (`(OR-GROUP . ,rest) (mapcar cont (company-coq--split-seq rest 'OR)))
    (_ (error "Group parsing failure [%s]" sexp))))

(defun company-coq-tg--parse-entry (sexp)
  "Turn a single entry SEXP into tactic abbrevs."
  (pcase sexp
    (`(LEFTA ,rest)      (cons 'TACLIST (company-coq-tg--parse-group rest #'company-coq-tg--parse-tactic)))
    (`(RIGHTA ,rest)     (cons 'TACLIST (company-coq-tg--parse-group rest #'company-coq-tg--parse-tactic)))
    (`(,_s LEFTA ,rest)  (cons 'TACLIST (company-coq-tg--parse-group rest #'company-coq-tg--parse-tactic)))
    (`(,_s RIGHTA ,rest) (cons 'TACLIST (company-coq-tg--parse-group rest #'company-coq-tg--parse-tactic)))
    (_ (error "Subentry parsing failure [%s]" sexp))))

(defun company-coq-tg--parse-toplevel-helper (name entries rest)
  "Turn top level ENTRIES filed under NAME into tactic abbrevs.
Then, process REST."
  (cons (cons 'ENTRY (cons name (company-coq-tg--parse-group entries #'company-coq-tg--parse-entry)))
        (company-coq-tg--parse-toplevel rest)))

(defun company-coq-tg--parse-toplevel (sexp)
  "Turn a top level SEXP into tactic abbrevs."
  (pcase sexp
    (`nil nil)
    (`(Entry ,name is ,(and entries (pred listp))     . ,rest) (company-coq-tg--parse-toplevel-helper name entries rest))
    (`(Entry ,name is ,_s ,(and entries (pred listp)) . ,rest) (company-coq-tg--parse-toplevel-helper name entries rest))
    (_ (error "Top level parsing failure [%s]" sexp))))

(defun company-coq-tg--mk-placeholder (symbol sep)
  "Create a placeholder for SYMBOL, using SEP as the repetition marker."
  (concat "@{" (car (last (split-string (symbol-name symbol) ":"))) sep (if sep "+" "") "}"))

(defun company-coq-tg--format-tactic-rec (tac sep)
  "Format individual components of TAC as tactic abbrev components.
SEP is used to separate repeating patterns."
  (pcase tac
    (`(OPT . ,rest) (cons nil (company-coq-tg--format-tactic-rec rest sep)))
    (`(LIST1 ,sepb . ,rest) (company-coq-tg--format-tactic-rec rest (concat (or sep "") sepb)))
    (`(LIST0 ,sepb . ,rest) (cons nil (company-coq-tg--format-tactic-rec rest (concat (or sep "") sepb))))
    (`(OR-GROUP . ,rest) (apply #'append (mapcar (lambda (x) (company-coq-tg--format-tactic-rec x sep)) rest)))
    (`(,th . ,tt) (let ((hds (company-coq-tg--format-tactic-rec th sep)))
                    (cl-loop for tl in (company-coq-tg--format-tactic-rec tt sep)
                             append (cl-loop for hd in hds collect (append hd tl)))))
    (`nil (list nil))
    (_ (cond ((symbolp tac) (list (list (company-coq-tg--mk-placeholder tac sep))))
             ((stringp tac) (list (list tac)))
             (t (warn "Unexpected value [%s]" tac))))))

(defun company-coq-tg--format-tactic (sexp)
  "Format individual components of SEXP as tactic abbrev components."
  (when (and (consp sexp) (not (symbolp (car sexp))))
    (company-coq-tg--format-tactic-rec sexp nil)))

(defun company-coq-tg--find-tactics (parse-tree)
  "Extract tactic abbrevs from PARSE-TREE."
  (pcase parse-tree
    (`(TACTIC . ,tac) (list tac))
    (`(TACLIST . ,tactics) (apply #'append (mapcar #'company-coq-tg--find-tactics tactics)))
    (`(ENTRY simple_tactic . ,taclists) (apply #'append (mapcar #'company-coq-tg--find-tactics taclists)))
    (`(,hd . ,_tl) (when (consp hd) (apply #'append (mapcar #'company-coq-tg--find-tactics parse-tree))))
    (_ (warn "Ignoring [%s]" parse-tree))))

(defun company-coq-tg--preprocess-tactics-grammar (grammar-str)
  "Convert GRAMMAR-STR into a parse tree."
  (with-temp-buffer
    (insert grammar-str)
    (cl-loop for  (from . to) in company-coq-tg--preprocessor-substitutions
             do   (goto-char (point-min))
             do   (while (search-forward from nil t)
                    (replace-match to t t)))
    (goto-char (point-min))
    (cl-loop for sexp = (ignore-errors (read (current-buffer)))
             while sexp collect sexp)))

(defun company-coq-tg--extract-notations (grammar-str)
  "Turn GRAMMAR-STR into a list of abbrevs.
GRAMMAR-STR should be the output of a Print Grammar Tactic call."
  (let* ((sexp (company-coq-tg--preprocess-tactics-grammar grammar-str)))
    ;; Swallow errors to work around bug #94 (‘Time’ commands produce spurious output)
    (condition-case-unless-debug err
        (cl-loop for s-tac in (company-coq-tg--find-tactics (company-coq-tg--parse-toplevel sexp))
                 append (cl-loop for tac in (company-coq-tg--format-tactic s-tac)
                                 collect (mapconcat #'identity tac " ")))
      (error (ignore (message "company-coq: Parsing of tactic grammar failed with error %S." err))))))

;; Local Variables:
;; checkdoc-arguments-in-order-flag: nil
;; End:

(provide 'company-coq-tg)
;;; company-coq-tg.el ends here
