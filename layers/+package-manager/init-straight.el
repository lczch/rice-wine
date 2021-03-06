;;; TODO:
;; 把straight简化出一个我想要的? 现在的功能也太复杂了.

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; straight默认自动build的功能是我不需要的，我其实只需要它的下载功能. move to init.el
;; (defvar rw-straight-repos-dir (expand-file-name "straight/repos" rice-wine-dir))

;; let straight use ssh instead of https
(setq straight-vc-git-default-protocol 'ssh)

;; 定义一个wrapper
(defun rw-straight-use-package (repo origin fork)
  "ORIGIN and FORK are users in github, like \"lczch\". REPO is a name (symbol)"
  (let ((repo-name (symbol-name repo)))
    (straight-use-package
     `(,repo :type git :host github :repo ,(concat origin "/" repo-name)
                :no-build t
                :fork (:host github
                             :repo ,(concat fork "/" repo-name))
                ))
    ;; git clone and add the repo to load-path
    (rw-add-to-load-path (expand-file-name repo-name rw-straight-repos-dir)))
  )

(provide 'init-straight)

;;; example

;; (rw-straight-use-package 'swiper "abo-abo" "lczch")

;; (straight-use-package
;;  '(aweshell :type git :host github :repo "manateelazycat/aweshell"
;;             :no-build t
;;             :fork (:host github
;;                          :repo "lczch/aweshell")
;;             ))
