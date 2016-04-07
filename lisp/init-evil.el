;;; evil-leader:
;; Bound frequently used commands to a short string.
;; For example, for line like `"ef" 'end-of-defun`
;;   You can either press `,ef` or `M-x end-of-defun` to execute it

;; (setq evil-leader/in-all-states t)
(require 'evil-leader)

(global-evil-leader-mode)

(setq evil-leader/leader ",")

(evil-leader/set-key
  "xb" 'switch-to-buffer)
;;; Package need
;; main package: evil
;; dependent package: undo-tree.el
(rice-wine/add-to-load-path (expand-file-name "evil/lib" rice-wine-package-dir))
(require 'undo-tree)

(require 'evil)
(evil-mode 1)


;;; Move back the cursor one position when exiting insert mode
(setq evil-move-cursor-back t)

;; minimal keymaps of evil mode
(setq rw-evil-map-minimal t)
;;; modify evil-insert-state-map to suit my habit

;;(define-key evil-insert-state-map (kbd "C-a") 'move-beginning-of-line)
;;(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
;;(define-key evil-insert-state-map (kbd "C-k") 'kill-line)
(when rw-evil-map-minimal
  (setq evil-insert-state-map (make-sparse-keymap))
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  (define-key evil-insert-state-map "\C-o" 'evil-execute-in-normal-state)
  (define-key evil-insert-state-map
    (read-kbd-macro evil-toggle-key) 'evil-emacs-state))

;;; modify evil-normal-state-map to suit my habit
(when rw-evil-map-minimal
  (setq evil-normal-state-map (make-sparse-keymap))
  (define-key evil-normal-state-map "a" 'evil-append)
  (define-key evil-normal-state-map "d" 'evil-delete)
  (define-key evil-normal-state-map "i" 'evil-insert)
  (define-key evil-normal-state-map "m" 'evil-set-marker)
  (define-key evil-normal-state-map "p" 'evil-paste-after)
  (define-key evil-normal-state-map "P" 'evil-paste-before)
  (define-key evil-normal-state-map "x" 'evil-delete-char)
  (define-key evil-normal-state-map "X" 'evil-delete-backward-char)
  (define-key evil-normal-state-map [deletechar] 'evil-delete-char)
  (define-key evil-normal-state-map "y" 'evil-yank)
  (define-key evil-normal-state-map "Y" 'evil-yank-line)
  (define-key evil-normal-state-map "gf" 'find-file-at-point)
  (define-key evil-normal-state-map [escape] 'evil-force-normal-state)
  (define-key evil-normal-state-map (kbd "DEL") 'evil-backward-char)
  (define-key evil-normal-state-map "u" 'undo)
  (define-key evil-normal-state-map [remap self-insert-command] 'undefined))

(when rw-evil-map-minimal
  (setq evil-motion-state-map (make-sparse-keymap))
  (define-key evil-motion-state-map "b" 'evil-backward-word-begin)
  (define-key evil-motion-state-map "B" 'evil-backward-WORD-begin)
  (define-key evil-motion-state-map "e" 'evil-forward-word-end)
  (define-key evil-motion-state-map "E" 'evil-forward-WORD-end)
  (define-key evil-motion-state-map "w" 'evil-forward-word-begin)
  (define-key evil-motion-state-map "W" 'evil-forward-WORD-begin)
  (define-key evil-motion-state-map "h" 'evil-backward-char)
  (define-key evil-motion-state-map "j" 'evil-next-line)
  (define-key evil-motion-state-map "k" 'evil-previous-line)
  (define-key evil-motion-state-map "l" 'evil-forward-char)
  (define-key evil-motion-state-map " " 'evil-forward-char)
  (define-key evil-motion-state-map "'" 'evil-goto-mark-line)
  (define-key evil-motion-state-map (kbd "RET") 'evil-ret)
  (define-key evil-motion-state-map "^" 'evil-first-non-blank)
  (define-key evil-motion-state-map "$" 'evil-end-of-line)
  (define-key evil-motion-state-map "+" 'evil-next-line-first-non-blank)
  (define-key evil-motion-state-map "-" 'evil-previous-line-first-non-blank)
  (define-key evil-motion-state-map "v" 'evil-visual-char)
  (define-key evil-motion-state-map "V" 'evil-visual-line)
  (define-key evil-motion-state-map "\C-v" 'evil-visual-block)
  (define-key evil-motion-state-map [left] 'evil-backward-char)
  (define-key evil-motion-state-map [right] 'evil-forward-char)
  (define-key evil-motion-state-map [up] 'evil-previous-line)
  (define-key evil-motion-state-map [down] 'evil-next-line)
  (define-key evil-motion-state-map "G" 'evil-goto-line)
  (define-key evil-motion-state-map "gg" 'evil-goto-first-line)
  (define-key evil-motion-state-map ":" 'evil-ex)
  (define-key evil-motion-state-map "!" 'evil-shell-command)
  (define-key evil-motion-state-map
    (read-kbd-macro evil-toggle-key) 'evil-emacs-state))



;; (define-key evil-normal-state-map (kbd "C-a") 'move-beginning-of-line)
;; (define-key evil-normal-state-map (kbd "C-e") 'move-end-of-line)
;; (define-key evil-normal-state-map (kbd "C-k") 'kill-line)

;;;
;; (defun rw/evil-change-read-only-file-initial-state ()
;;   (when (and  buffer-read-only
;;               (eq major-mode 'fundermental-mode))
;;     (evil-insert)))

;; (add-hook ')

;; (define-key evil-normal-state-map "q" nil)

;;; change mode-line color by evil state
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))


(provide 'init-evil)
