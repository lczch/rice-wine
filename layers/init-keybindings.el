
(defun aweshell-toggle--no-prefix ()
  (interactive)
  (aweshell-toggle 4))

(global-set-key (kbd "<f1>") 'aweshell-toggle--no-prefix)

;; find a tag 
(global-set-key (kbd "C-\\") 'counsel-etags-find-tag-at-point)
(global-set-key (kbd "C-t") 'pop-tag-mark)

;; debug on
(global-set-key (kbd "<f12>") 'toggle-debug-on-error)

;; comment:: replaceed by "ci"
;; (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)

;; switch frame and buffer
(global-set-key (kbd "C-M-<next>") 'rw/switch-to-next-frame-in-same-monitor)
(global-set-key (kbd "C-M-<prior>") 'rw/switch-to-previous-frame-in-same-monitor)

(global-set-key (kbd "C-<next>") 'next-buffer)
(global-set-key (kbd "C-<prior>") 'previous-buffer)


;; "Delete other windows in frame if any, or restore previous window config."
(global-set-key (kbd "C-x 1") 'sanityinc/toggle-delete-other-windows)
(global-set-key (kbd "C-x 2") (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key (kbd "C-x 3") (split-window-func-with-other-buffer 'split-window-horizontally))


;; 如果在emacs是启动了server的时候(我保证全局只有一个server), 那么"C-x C-s"不会杀掉这个emacs,
;; 需要手动执行`kill-emacs', 才会杀掉最后一个emacs.
(global-set-key (kbd "C-x C-c") 'rw-save-buffers-kill-terminal)
;; ---------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------
(global-set-key (kbd "C-x C-;") 'comment-line)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c d") 'counsel-descbinds)
(global-set-key (kbd "M-y") 'browse-kill-ring)

;; window
(my-space-leader-def
  "x0" 'delete-window
  "x1" 'sanityinc/toggle-delete-other-windows
  "x2" 'split-window-vertically
  "x3" 'split-window-horizontally
  "oo" 'delete-other-windows
  ;; interesting 
  "xr" 'rotate-windows
  ;; "xt" 'toggle-two-split-window
  ;; window numbering
  "0" 'select-window-0
  "1" 'select-window-1
  "2" 'select-window-2
  "3" 'select-window-3
  "4" 'select-window-4
  "5" 'select-window-5
  "6" 'select-window-6
  "7" 'select-window-7
  "8" 'select-window-8
  "9" 'select-window-9
  "xc" 'rw-save-buffers-kill-terminal
  "xb" 'ivy-switch-buffer
  "xk" 'kill-buffer
  "xs" 'save-buffer
  ;; buffer
  "xh" 'mark-whole-buffer
  "do" 'rw-display-current-buffer-other-frame
  "eb" 'eval-buffer
  "rb" 'revert-buffer
  ;; org-roam
  "rff" 'org-roam-find-file-immediate
  "roff" 'org-roam-find-file-other-window
  "rll" 'org-roam-insert
  "rtt" 'my-org-roam-capture-new-task
  "cq" 'counsel-org-tag
  "cde" 'org-cdlatex-environment-indent
  ;; find-file-in-progject
  "kk" 'find-file-in-project-by-selected
  "jj" 'find-file-in-project-at-point
  ;; swiper
  "ss" 'swiper
  ;; counsel
  "xr" 'counsel-recentf 
  "xf" 'counsel-find-file
  "off"  'counsel-find-file-other-window
  ;; help
  "?"   'counsel-descbinds
  "hdf" 'counsel-describe-function
  "hdv" 'counsel-describe-variable
  ;; replace
  "lq" 'vr/query-replace
  ;; test
  "rwt" 'rw-test-new-config
  ;; comment
  "ci" 'evilnc-comment-or-uncomment-lines
  ;; magit 
  "gs"  'magit-status
  "cc"  'org-capture-finalize   
  ;; tex 
  "ca" 'TeX-command-run-all
  "ce" 'LaTeX-environment

  ;; bookmark
  "mm" 'counsel-bookmark
  ;; other
  "ll" 'evilmi-jump-items 
  "vf" 'vc-rename-file-and-buffer
  "ee" 'eval-last-sexp
 )

;; tricky use: for a specific purpose 
;; (my-space-leader-def
;;   "ap" 'lzh/coq-trans)

;; improve pg's *goals* and *respons* display
;; coq's layout in multi frames.
;; (my-space-leader-def
;;   "cl" 'rw/pg-show-goals-and-responds-in-other-frame)


(my-space-leader-def
   "wl" 'winner-undo
   "wr" 'winner-redo
  )

(my-space-leader-def
  "cl" 'org-insert-link
  "cs" 'org-store-link)


(my-space-leader-def
  "rwi" 'rw/org-insert-picture-clipboard)

(global-set-key (kbd "<f5>") 'org-redisplay-inline-images)

(my-space-leader-def
  "pin" 'sanityinc/toggle-current-window-dedication)

(provide 'init-keybindings)
