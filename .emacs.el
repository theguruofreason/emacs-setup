;; Add el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get 'sync)

;; Standard Jedi.el setting
;(add-hook 'python-mode-hook 'jedi:setup)
;(setq jedi:complete-on-dot t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(flycheck-python-pycompile-executable "python3")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (yaml-mode tss py-yapf py-autopep8 ng2-mode markdown-mode js-format irony-eldoc groovy-mode flymd flycheck elpy dockerfile-mode cmake-mode bash-completion)))
 '(python-shell-interpreter "python"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(global-linum-mode 1)
(column-number-mode 1)
(tool-bar-mode -1)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(require 'package)
(add-to-list 'package-archives
	                  '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(elpy-enable)
(setq elpy-rpc-python-command "python3")
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq ac-auto-start nil)

(provide 'emacs)

;; flymd
(require 'flymd)

;; revert-all
(defun revert-all ()
    "Refresh all open file buffers without confirmation.
Buffers in modified (not yet saved) state in emacs will not be reverted. They
will be reverted though if they were modified outside emacs.
Buffers visiting files which do not exist any more or are no longer readable
will be killed."
    (interactive)
    (dolist (buf (buffer-list))
      (let ((filename (buffer-file-name buf)))
	;; Revert only buffers containing files, which are not modified;
	;; do not try to revert non-file buffers like *Messages*.
	(when (and filename
		   (not (buffer-modified-p buf)))
	  (if (file-readable-p filename)
	      ;; If the file exists and is readable, revert the buffer.
	      (with-current-buffer buf
		(revert-buffer :ignore-auto :noconfirm :preserve-modes))
	    ;; Otherwise, kill the buffer.
	    (let (kill-buffer-query-functions) ; No query done when killing buffer
	      (kill-buffer buf)
	      (message "Killed non-existing/unreadable file buffer: %s" filename))))))
    (message "Finished reverting buffers containing unmodified files."))

;; comment-region
(global-set-key (kbd "C-x ;") 'comment-region)
(global-set-key (kbd "C-x :") 'uncomment-region)

;; autopep8
;;(require 'py-autopep8)
;;(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;; py-yapf
(add-to-list 'load-path "~/.emacs.d/elpa/py-yapf-2016.1/py-yapf.el")
(require 'py-yapf)
(add-hook 'python-mode-hook 'py-yapf-enable-on-save)

(global-set-key (kbd "<f5>") 'revert-all)
(global-set-key (kbd "<f6>") 'sort-lines)

(setq typescript-indent-level 2)

;;; .emacs.el ends here
