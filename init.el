;;; Begin initialization
;; Turn off mouse interface early in startup to avoid momentary display
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

;; melpa
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

(when (< emacs-major-version 24)
  
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(setq package-pinned-packages
      '((cider . "melpa-stable")))

(package-initialize)

;; Boostrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; From use-package README
(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)

;;; Load the config
(org-babel-load-file (concat user-emacs-directory "config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("235dc2dd925f492667232ead701c450d5c6fce978d5676e54ef9ca6dd37f6ceb" default)))
 '(magit-dispatch-arguments nil)
 '(package-selected-packages
   (quote
    (gruvbox-theme powerline expand-region iedit hungry-delete-mode solarized-theme zenburn-theme ace-jump-mode discover which-key web-mode use-package super-save spacemacs-theme smex smartscan rainbow-delimiters persistent-soft org magit inf-clojure ido-vertical-mode helm-projectile helm-ag goto-chg geiser exec-path-from-shell ensime diff-hl crux clojure-mode-extra-font-locking clj-refactor cider-eval-sexp-fu ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
