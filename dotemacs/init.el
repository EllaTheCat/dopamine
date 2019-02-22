;;; -*- Mode: Emacs-Lisp -*-
;;;
;;; FSF Emacs Ubuntu 10.10,14.04,16.04,...
;;;

;;;
;;; Support for using emacslient:
;;;

(if t
    (progn
      (server-start)
      ))

;;;
;;; Bindings.
;;;

(defun my-global-keys ()
  "Apply global key bindings."
  (interactive)
  (global-set-key [(control x) (control k)]	'kill-rectangle)
  (global-set-key [(control x) (control y)]	'yank-rectangle)
  (global-set-key [(control x) (control z)]	'insert-quotes)
  (global-set-key [\M-down]	'my-scroll-up)
  (global-set-key [\M-up]	'my-scroll-down)
  (global-set-key "\M-n"	'my-other-window-scroll-up)
  (global-set-key "\M-p"	'my-other-window-scroll-down)
  (global-set-key "\M- "	'my-just-one-space)
  (global-set-key "\C-x&"	'find-name-dired)
  (global-set-key "\C-z"	'universal-argument)
  (global-set-key "\C-\\"	'my-match-paren)
  (global-set-key [f2]	        'undo)
  (global-set-key [f3]	        'my-autovoice-buffer)
  (global-set-key [f4]	        'my-scratch-buffer)
  (global-set-key [f5]	        'compile)
  (global-set-key "\C-x2"    'make-frame-command) ;  split-window-below
  (global-set-key "\C-x3"    'make-frame-command) ;  split-window-right
  )

(my-global-keys)

(add-hook
 'find-file-hooks
 '(lambda ()
    (local-set-key	"\M-\t"	'dabbrev-expand)
    ))

;;;
;;; Functions.
;;;

(defun my-scratch-buffer ()
  ""
  (interactive)
  (switch-to-buffer "*scratch*")
)

(defun my-autovoice-buffer ()
  ""
  (interactive)
  (switch-to-buffer "AutoVoice")
)

(defun my-make ()
  ""
  (interactive)
  (setq compile-command "make")
)

(defun my-just-one-space (arg)
  "Delete all spaces and tabs around point, leaving one space."
  (interactive "*P")
  (expand-abbrev)
  (if arg
      (skip-chars-backward " \t")
    (skip-chars-backward " \t\n"))
  (if (= (following-char) ? )
      (forward-char 1)
    (insert ? ))
  (delete-region (point) (progn
   (if arg
       (skip-chars-forward " \t")
     (skip-chars-forward " \t\n"))
   (point)))
  )

(defun my-match-paren ()
  "Go to the matching parenthesis when cursor is over a parenthesis."
  (interactive)
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	)
  )

(defun my-scroll-up ()
   "Scroll one line upwards."
   (interactive)
   (scroll-up 1))

(defun my-scroll-down ()
   "Scroll one line downwards."
   (interactive)
   (scroll-down 1))

(defun my-other-window-scroll-up ()
  "Scroll the other window one line upwards."
  (interactive)
  (scroll-other-window 1)
  )

(defun my-other-window-scroll-down ()
  "Scroll the other window one line downwards."
  (interactive)
  (scroll-other-window -1)
  )

(defun insert-quotes ()
  "Inserts quotes (\") around the current region or work."
  (interactive)
  (let (start end bounds)
    (if (and transient-mark-mode mark-active)
        (setq start (region-beginning)
              end (region-end))
      (progn
        (setq bounds (bounds-of-thing-at-point 'symbol))
        (setq start (car bounds)
              end (cdr bounds))))
    (goto-char start)
    (insert "\"")
    (goto-char (+ end 1))
    (insert "\"")))

;;;
;;; Paths.
;;;

;;; http://www.gnu.org/software/emacs/emacs-lisp-intro/html_node/Loading-Files.html

;;; Do this last so these are at the head of the list.
(setq load-path (append (list nil "~/.emacs.d/lisp") load-path))

;;;
;;; Syntax highlighting.
;;;

;;; http://www.emacswiki.org/emacs/InterpreterModeAlist
(add-to-list 'interpreter-mode-alist '("dash" . sh-mode))

;;; http://stackoverflow.com/questions/3312114/how-to-tell-emacs-to-open-h-file-in-c-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(if t
    (progn
      ;; http://emacswiki.org/emacs/Js2Mode
      (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
      ))

;;;
;;; Dired tweaks:
;;;

;;;
;;; Keep only one Dired buffer when changing up one level.
;;; http://www.emacswiki.org/emacs/DiredReuseDirectoryBuffer
;;;
(add-hook 'dired-mode-hook
 (lambda ()
   (define-key dired-mode-map (kbd "^")
     (lambda () (interactive) (find-alternate-file "..")))
 ))

;;;
;;; Keep only one Dired buffer when changing down one level.
;;; http://avizit.blogspot.com/2004/10/dired-to-open-new-directories-in-same.html
;;;
(add-hook
 'dired-mode-hook
 (lambda ()
   (local-set-key	"\C-m"	'dired-follow-file)))

(defun dired-follow-file () "In dired, visit the file or directory on
this line. If a directory is on the current line, replace the current
dired buffer with one containing the contents of the directory, else
invoke `dired-find-file' on the file."

 (interactive)
 (let ((filename (dired-get-filename)))
   ;; if the file is a directory, replace the buffer with the
   ;;  directory's contents
   (if (file-directory-p filename)
       (find-alternate-file filename)
     ;; otherwise simply perform a normal `dired-find-file'
     (dired-find-file))
   ))

;;;
;;; Recreate scratch buffer.
;;; http://stackoverflow.com/a/1042839
;;;
(if t
    (progn
      (run-with-idle-timer 1 t '(lambda ()
				  (get-buffer-create "*scratch*")))
  ))

;;;
;;; Place the buffer name in the window title. Note the prefix.
;;;
(setq frame-title-format "Emacs : %b")

;;;
;;; Kill ring.
;;; http://emacs-fu.blogspot.co.uk/2010/04/navigating-kill-ring.html
;;;
(if t
    (progn
      (when (require 'browse-kill-ring nil 'noerror)
	(browse-kill-ring-default-keybindings))
      ))

;;;
;;; Google C++ Style Guide:
;;;

(if t
    (progn
      (defun my-c-mode-hook ()
	(setq c-basic-offset 3)
	(c-set-offset 'innamespace 3)
	)
      (add-hook 'c-mode-common-hook 'my-c-mode-hook)
      ))

(if t
    (progn
      (require 'google-c-style)
      (add-hook 'c-mode-common-hook 'google-set-c-style)
      (add-hook 'c-mode-common-hook 'google-make-newline-indent)
      ))

;;;
;;; http://www.reddit.com/r/emacs/comments/299keu/emacs_very_slow_not_startup/
;;;
(setq font-lock-maximum-decoration 6)

;;;
;;; Bookmarks:
;;; http://emacs-fu.blogspot.co.uk/2009/11/bookmarks.html
;;;

(if t
    (progn
      (setq
       bookmark-default-file "~/.emacs.d/bookmarks"
       bookmark-save-flag 1)
      ))

;;;
;;; Tramp (work with remote machines):
;;; http://xemacs.org/Documentation/packages/html/tramp_5.html#SEC19
;;;

(if t
    (progn
      (require 'tramp)
      ))

;;;
;;; Tabs
;;;

(setq-default indent-tabs-mode nil)


;;;
;;; Detach the custom-file.
;;; http://emacsblog.org/2008/12/06/quick-tip-detaching-the-custom-file/
;;;

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;;;
;;; Tags.
;;; http://www.emacswiki.org/emacs/BuildTags
;;;

(setq path-to-ctags "~/ctags")1

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags-exuberant -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )

;;;
;;; Delete trailing whitespace.
;;; http://peterdowns.com/posts/strip-trailing-whitespace.html
;;;

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;
;;; Integrate the X clipboard.
;;; https://emacs.stackexchange.com/a/32115
;;;
(setq select-enable-primary t)
(setq select-enable-clipboard t)

;;;
;;; Key Chords
;;;

(if nil
  (progn
    (require 'key-chord)
    (key-chord-mode 1)
    (setq key-chord-one-key-delay 0.1)                ; default 0.2
    (setq key-chord-two-keys-delay 0.2)                ; default 0.1

  (defun my-global-key-chords ()
    "Apply global key chord bindings."
    (interactive)
    (key-chord-define-global "qz" 'undo)
    )

    (my-global-key-chords)
    ))

;;;
;;; Done.
;;;
