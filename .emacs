(add-to-list 'load-path "~/.emacs.d/site-lisp/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fringe-mode (quote (0)) nil (fringe))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

(setq backup-by-copying-when-linked t)

(when window-system
  ;; prepare python environment
  (require 'ipython)
  (require 'pymacs)
  (pymacs-load "ropemacs" "rope-")
  (setq ropemacs-enable-autoimport 't))

(when window-system
  ;; mustache mode
  (require 'mustache-mode))

(when window-system
  ;; load nxhtml
  (load "~/.emacs.d/nxhtml/autostart.el")
  (setq mumamo-background-colors nil)
  (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))
  ;; bugfix for particular emacs version
  (when (and (equal emacs-major-version 24)
	     (equal emacs-minor-version 1))
    (eval-after-load "bytecomp"
      '(add-to-list 'byte-compile-not-obsolete-vars
		    'font-lock-beginning-of-syntax-function))
    (eval-after-load "bytecomp"
      '(add-to-list 'byte-compile-not-obsolete-vars
		    'font-lock-syntactic-keywords))
    ;; tramp-compat.el clobbers this variable!
    (eval-after-load "tramp-compat"
      '(add-to-list 'byte-compile-not-obsolete-vars
		    'font-lock-beginning-of-syntax-function))
    (eval-after-load "tramp-compat"
      '(add-to-list 'byte-compile-not-obsolete-vars
		    'font-lock-syntactic-keywords)))
  )

(when window-system
  ;; js2-mode
  (autoload 'js2-mode "js2-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  )

;; load color theme
(when window-system
  (load-library "color-theme")
  (color-theme-initialize)
  (color-theme-calm-forest))

;; lisp
(when window-system
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (require 'slime)
  (slime-setup))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking
   FILE-NAME. This is a replacement for
   `flymake-create-temp-inplace'. The difference is that it gives
   a file name in `temporary-file-directory' instead of the same
   directory as FILE-NAME.

   For the use of PREFIX see that function.

   Note that not making the temporary file in another directory
   \(like here) will not if the file you are checking depends on
   relative paths to other files \(for the type of checks flymake
   makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))

(setq temporary-file-directory "/tmp/")

(when (load "flymake" t)
  (defun flymake-create-relative-temp-file ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       ;;'flymake-create-temp-inplace))
		       'flymake-create-temp-intemp)))
      (file-relative-name
       temp-file (file-name-directory
		  buffer-file-name))))
  (defun flymake-checker-init (checker-name)
    (let* ((local-file (flymake-create-relative-temp-file))
	   (checker-dir (locate-dominating-file
			 (concat "./" local-file)
			 checker-name)))
      (if checker-dir
	  (list (file-truename (concat
				checker-dir checker-name))
		(list local-file))
	())))

  (global-set-key (kbd "M-p") 'flymake-goto-prev-error)
  (global-set-key (kbd "M-n") 'flymake-goto-next-error)

  (defun flymake-python-init ()
    (flymake-checker-init "pychecker"))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-python-init))

  (defun flymake-js-init ()
    (flymake-checker-init "jschecker"))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.js\\'" flymake-js-init))
)

(when window-system
  ;;(add-hook 'find-file-hook 'flymake-find-file-hook)
  (load-library "flymake-cursor")

  ;; (add-hook 'python-mode-hook 'flymake-find-file-hook)
  (add-hook 'python-mode-hook
	    (lambda ()
	      (unless (eq buffer-file-name nil) (flymake-mode t))
	      ))
  (add-hook 'js2-mode-hook 'flymake-find-file-hook)

)
