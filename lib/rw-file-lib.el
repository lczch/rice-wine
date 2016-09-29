(defun rw-walk-directory-reg (directory &optional match-regexp)
  "Walk DIRECTORY recursively and return a list of file matching MATCH-REGEXP."
  (let ((match-regexp (or match-regexp "."))
        (files (directory-files directory t))
        (result nil))
    (dolist (file files result)
      (let ((file-name (file-name-nondirectory file)))
        (cond
         ((file-directory-p file)
          ;; if file is a directory
          (unless (or (string= file-name ".")
                      (string= file-name ".."))
            (let ((sub-result (rw-walk-directory-reg file match-regexp)))
              (setq result (append result sub-result)))))
         ((string-match-p match-regexp file-name)
          (setq result (append result (list file)))))))))

(provide 'rw-file-lib)
