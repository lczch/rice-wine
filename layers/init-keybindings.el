

;; find a tag 
(global-set-key (kbd "C-\\") 'counsel-etags-find-tag-at-point)


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
(global-set-key "\C-x1" 'sanityinc/toggle-delete-other-windows)
(global-set-key "\C-x2" (split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key "\C-x3" (split-window-func-with-other-buffer 'split-window-horizontally))


;; 如果在emacs是启动了server的时候(我保证全局只有一个server), 那么"C-x C-s"不会杀掉这个emacs,
;; 需要手动执行`kill-emacs', 才会杀掉最后一个emacs.
(global-set-key (kbd "C-x C-c") 'rw-save-buffers-kill-terminal)
;; ---------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------

;; window
(evil-leader/set-key
  "x0" 'delete-window
  "x1" 'delete-other-windows
  "x2" 'split-window-vertically
  "x3" 'split-window-horizontally
  "xq" 'delete-window
  "xa" 'split-window-vertically
  "xd" 'split-window-horizontally
  "s0" 'delete-window
  "s1" 'delete-other-windows
  "s2" 'split-window-vertically
  "s3" 'split-window-horizontally
  "sq" 'delete-window
  "sa" 'split-window-vertically
  "sd" 'split-window-horizontally
  "oo" 'delete-other-windows
  ;; interesting 
  ;; "xr" 'rotate-windows
  ;; "xt" 'toggle-two-split-window
  )

;; find and grep files 
(evil-leader/set-key
  ;; counsel-etags 
  "rt" 'counsel-etags-recent-tag
  "ft" 'counsel-etags-find-tag
  ;; find-file-in-project
  "kk" 'find-file-in-project-by-selected
  "jj" 'find-file-in-project-at-point
  ;; grep-dired 
  "gd" 'grep-dired
  "tt" 'grep-dired-dwim
  )

;; search: `swiper'
(evil-leader/set-key
  "ss" 'swiper
  "sb" 'swiper-all)


;; counsel 
(evil-leader/set-key
  ;; files
  "ff"  'counsel-find-file
  "fL"  'counsel-locate
  ;; help
  "?"   'counsel-descbinds
  "hdf" 'counsel-describe-function
  "hdv" 'counsel-describe-variable
  ;; insert
  "iu"  'counsel-unicode-char
  ;; jump
  ;; register/ring
  "ry"  'counsel-yank-pop
  ;; jumping
  "sj"  'counsel-imenu
  ;; themes
  "Ts"  'counsel-load-theme
  )

;; edit: replace
(evil-leader/set-key
  "rr" 'vr/query-replace
  "xx" 'er/expand-region
  ;; "vm" 'vr/mc-mark
  )

;; org 
(evil-leader/set-key
  "oa" 'org-archive-subtree-default
  "oci" 'org-clock-in
  "oco" 'org-clock-out)

;; test: create a new emacs
(evil-leader/set-key
  "rwt" 'rw-test-new-config)

;; tricky use: for a specific purpose 
;; (evil-leader/set-key
;;   "ap" 'lzh/coq-trans)

;; improve pg's *goals* and *respons* display
;; coq's layout in multi frames.
(evil-leader/set-key
  "cl" 'rw/pg-show-goals-and-responds-in-other-frame)

;; buffer 
(evil-leader/set-key
  "xh" 'mark-whole-buffer
  "do" 'rw-display-current-buffer-other-frame
  "eb" 'eval-buffer
  "rb" 'revert-buffer
  )

;; comment a line 
(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  ;; "cc" 'evilnc-copy-and-comment-lines
  ;; "cp" 'evilnc-comment-or-uncomment-paragraphs
  ;; "cr" 'comment-or-uncomment-region
  ;; "cv" 'evilnc-toggle-invert-comment-line-by-line
  ;; "\\" 'evilnc-comment-operator       ; if you prefer backslash key
  )

;; magit
(evil-leader/set-key
  ;; "gb"  'spacemacs/git-blame-micro-state
  "gfh" 'magit-log-buffer-file
  "gm"  'magit-dispatch-popup
  "gs"  'magit-status
  "gS"  'magit-stage-file
  "gU"  'magit-unstage-file)

;; profiler: like "top" in linux 
(evil-leader/set-key
  "ps" 'rw-profiler-toggle
  "pr" 'profiler-report)

;; save/read desktop (emacs的工作区概念)
(evil-leader/set-key
  "ds" 'rw-desktop-save
  "dr" 'rw-desktop-read)

;; clipboard: usually not used in windows...
(evil-leader/set-key
  "aa" 'copy-to-x-clipboard
  "zz" 'paste-from-x-clipboard)


(provide 'init-keybindings)
