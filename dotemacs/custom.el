(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(browse-kill-ring-quit-action (quote save-and-restore))
 '(column-number-mode t)
 '(compilation-read-command nil)
 '(compilation-scroll-output (quote first-error))
 '(compilation-window-height 8)
 '(compile-command
   "find . -name '*.c' -or -name '*.h' -or -name '*.cpp' | etags - ")
 '(custom-enabled-themes nil)
 '(dired-listing-switches "-lB --group-directories-first")
 '(inhibit-startup-screen t)
 '(js2-highlight-external-variables nil)
 '(js2-mode-show-parse-errors nil)
 '(mouse-yank-at-point t)
 '(remote-compile-host "")
 '(remote-compile-prompt-for-host t)
 '(remote-compile-prompt-for-user t)
 '(remote-compile-user "")
 '(sh-indent-for-case-alt (quote +))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans" :foundry "unknown" :slant normal :weight normal :height 113 :width normal))))
 '(fringe ((t (:background "rgb:1f/00/1f"))))
 '(isearch ((((class color) (min-colors 8)) (:background "unspecified-bg" :foreground "magenta"))))
 '(isearch-fail ((((class color) (min-colors 8)) (:foreground "magenta"))))
 '(lazy-highlight ((((class color) (min-colors 8)) (:background "undefined-bg" :foreground "magenta"))))
 '(region ((t (:background "undefined-bg" :foreground "green yellow"))))
 '(show-paren-match ((t (:background "blue")))))
