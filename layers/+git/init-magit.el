(use-package magit
  :ensure t
  :defer t
  :init
  ;; 从melpa上安装的目录结构和git上的目录结构有差别.
  ;; 这个autoloads没有provide feature, 所以只能这样load
  (load-library "magit-autoloads")
  
  :config
  ;; from redguardtoo
  (ivy-mode 1)
  ;; from space
  (setq magit-completing-read-function 'ivy-completing-read)
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  ;; On Windows, we must use Git GUI to enter username and password
  ;; See: https://github.com/magit/magit/wiki/FAQ#windows-cannot-push-via-https
  (when (eq window-system 'w32)
    (setenv "GIT_ASKPASS" "git-gui--askpass"))

  (use-package evil-magit
    ;; 有两个问题: 1. ALT+[1..9]的快捷键被莫名其妙占用了; 2. help buffer显示的信息和keymap不符, 并没有修改.
    :disabled
    ;; 这个包会导致安装evil, 而evil是我可能做了略微魔改的陈年stable版本, 不知道会不会出问题...
    ;; 先试试吧. 如果出问题, 那就用straight安装这个包.
    :ensure t
    :init
    ;; optional: this is the evil state that evil-magit will use
    (setq evil-magit-state 'normal)
    ;; optional: disable additional bindings for yanking text
    ;; (setq evil-magit-use-y-for-yank nil)
    :config
    )
  )

(provide 'init-magit)
