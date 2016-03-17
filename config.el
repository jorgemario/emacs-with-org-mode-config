(setq user-full-name "Jorge M Gomez Cardona"
      user-mail-address "jorgemario@gmail.com")

;; These functions are useful. Activate them.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep all backup and auto-save files in one directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; UTF-8 please
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top
(setq-default indent-tabs-mode nil)

;; Turn off the blinking cursor
;; (blink-cursor-mode -1)

(setq-default indent-tabs-mode nil)
(setq-default indicate-empty-lines t)

;; Don't count two spaces after a period as the end of a sentence.
;; Just one space is needed.
(setq sentence-end-double-space nil)

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

(show-paren-mode t)

(column-number-mode t)

(global-visual-line-mode)
(diminish 'visual-line-mode)

(setq uniquify-buffer-name-style 'forward)

;; -i gets alias definitions from .bash_profile
(setq shell-command-switch "-ic")

;; Don't beep at me
(setq visible-bell t)
;;(setq ring-bell-function 'ignore)

;; Show line numbers
(global-linum-mode)

;; full path in title bar
(setq-default frame-title-format "%b (%f)")

;; don't pop up font menu
(global-set-key (kbd "s-t") '(lambda () (interactive)))

;; No need for ~ files when editing
(setq create-lockfiles nil)

;; Go straight to scratch buffer on startup
(setq inhibit-startup-message t)

;; Don't show native OS scroll bars for buffers because they're redundant
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  ;; These settings relate to how emacs interacts with your operating system
  (setq ;; makes killing/yanking interact with the clipboard
        x-select-enable-clipboard t

        ;; I'm actually not sure what this does but it's recommended?
        x-select-enable-primary t

        ;; Save clipboard strings into kill ring before replacing them.
        ;; When one selects something in another program to paste it into Emacs,
        ;; but kills something in Emacs before actually pasting it,
        ;; this selection is gone unless this variable is non-nil
        save-interprogram-paste-before-kill t

        ;; Shows all options when running apropos. For more info,
        ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Apropos.html
        apropos-do-all t

        ;; Mouse yank commands yank at point instead of at click.
        mouse-yank-at-point t)

  ;; exec-path-from-shell makes the command-line path with Emacs’s shell match the same one on OS 
  (use-package exec-path-from-shell
    :if (memq window-system '(mac ns))
    :ensure t
    :init
    (exec-path-from-shell-initialize))

;; Mac integration
  (let ((is-mac (string-equal system-type "darwin")))
    (when is-mac
      ;; delete files by moving them to the trash
      (setq delete-by-moving-to-trash t)
      (setq trash-directory "~/.Trash")

      ;; Don't make new frames when opening a new file with Emacs
      (setq ns-pop-up-frames nil)

      ;; set the Fn key as the hyper key
      (setq ns-function-modifier 'hyper)

      ;; Use Command-` to switch between Emacs windows (not frames)
      (bind-key "s-`" 'other-window)
  
      ;; Use Command-Shift-` to switch Emacs frames in reverse
      (bind-key "s-~" (lambda() () (interactive) (other-window -1)))

      ;; Because of the keybindings above, set one for `other-frame'
      (bind-key "s-1" 'other-frame)

      ;; Fullscreen!
      (setq ns-use-native-fullscreen nil) ; Not Lion style
      (bind-key "<s-return>" 'toggle-frame-fullscreen)

      ;; buffer switching
      (bind-key "s-{" 'previous-buffer)
      (bind-key "s-}" 'next-buffer)

      ;; Compiling
      (bind-key "H-c" 'compile)
      (bind-key "H-r" 'recompile)
      (bind-key "H-s" (defun save-and-recompile () (interactive) (save-buffer) (recompile)))

      ;; disable the key that minimizes emacs to the dock because I don't
      ;; minimize my windows
      ;; (global-unset-key (kbd "C-z"))

      (defun open-dir-in-finder ()
        "Open a new Finder window to the path of the current buffer"
        (interactive)
        (shell-command "open ."))
      (bind-key "s-/" 'open-dir-in-finder)

      (defun open-dir-in-iterm ()
        "Open the current directory of the buffer in iTerm."
        (interactive)
        (let* ((iterm-app-path "/Applications/iTerm.app")
               (iterm-brew-path "/opt/homebrew-cask/Caskroom/iterm2/1.0.0/iTerm.app")
               (iterm-path (if (file-directory-p iterm-app-path)
                               iterm-app-path
                             iterm-brew-path)))
          (shell-command (concat "open -a " iterm-path " ."))))
      (bind-key "s-=" 'open-dir-in-iterm)

      ;; Not going to use these commands
      (put 'ns-print-buffer 'disabled t)
      (put 'suspend-frame 'disabled t)))

(use-package cyberpunk-theme
  :if (window-system)
  :ensure t
  :init
  (progn
    (load-theme 'cyberpunk t)
    (set-face-attribute `mode-line nil
                        :box nil)
    (set-face-attribute `mode-line-inactive nil
                        :box nil)))

(add-to-list 'default-frame-alist
             '(font . "Inconsolata-14"))

(use-package recentf
  :commands ido-recentf-open
  :init
  (progn
    (recentf-mode t)
    (setq recentf-max-saved-items 200)

    (defun ido-recentf-open ()
      "Use `ido-completing-read' to \\[find-file] a recent file"
      (interactive)
      (if (find-file (ido-completing-read "Find recent file: " recentf-list))
          (message "Opening file...")
        (message "Aborting")))

    (bind-key "C-x C-r" 'ido-recentf-open)))

;; make ibuffer the default buffer lister.
(defalias 'list-buffers 'ibuffer)

(use-package ido
  :init
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode t)
  (use-package ido-vertical-mode
    :ensure t
    :init (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)))

;; Convenient keybindings to resize windows.

(bind-key "s-C-<left>"  'shrink-window-horizontally)
(bind-key "s-C-<right>" 'enlarge-window-horizontally)
(bind-key "s-C-<down>"  'shrink-window)
(bind-key "s-C-<up>"    'enlarge-window)

;; Whenever I split windows, I usually do so and also switch to the other window as well,
;; so might as well rebind the splitting key bindings to do just that to reduce the repetition.

(defun vsplit-other-window ()
  "Splits the window vertically and switches to that window."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil))
(defun hsplit-other-window ()
  "Splits the window horizontally and switches to that window."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil))

(bind-key "C-x 2" 'vsplit-other-window)
(bind-key "C-x 3" 'hsplit-other-window)

(use-package smex
  :if (not (featurep 'helm-mode))
  :ensure t
  :bind ("M-x" . smex))

(use-package undo-tree
  :defer t
  :ensure t
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package paredit
  :ensure t
  :config
  ;; Automatically load paredit when editing a lisp file
  ;; More at http://www.emacswiki.org/emacs/ParEdit
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
  ;; eldoc-mode shows documentation in the minibuffer when writing code
  ;; http://www.emacswiki.org/emacs/ElDoc
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode))

(use-package clojure-mode
  :ensure t
  :config
  ;; Enable paredit for Clojure
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)

  ;; This is useful for working with camel-case tokens, like names of
  ;; Java classes (e.g. JavaClassName)
  (add-hook 'clojure-mode-hook 'subword-mode)

  ;; syntax hilighting for midje
  (add-hook 'clojure-mode-hook
            (lambda ()
              (setq inferior-lisp-program "lein repl")
              (font-lock-add-keywords
               nil
               '(("(\\(facts?\\)"
                  (1 font-lock-keyword-face))
                 ("(\\(background?\\)"
                  (1 font-lock-keyword-face))))
              (define-clojure-indent (fact 1))
              (define-clojure-indent (facts 1))))

  ;; Use clojure mode for other extensions
  (add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode)))


;; A little more syntax highlighting
(use-package clojure-mode-extra-font-locking
  :ensure t)

(use-package clj-refactor
  :ensure t)

(use-package cider
  :ensure t
  :config
  ;; provides minibuffer documentation for the code you're typing into the repl
  (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

  ;; go right to the REPL buffer when it's finished connecting
  (setq cider-repl-pop-to-buffer-on-connect t)

  ;; disable cider message
  (setq cider-repl-display-help-banner nil)

  ;; When there's a cider error, show its buffer and switch to it
  (setq cider-show-error-buffer t)
  (setq cider-auto-select-error-buffer t)

  ;; Where to store the cider history.
  (setq cider-repl-history-file "~/.emacs.d/cider-history")

  ;; Wrap when navigating history.
  (setq cider-repl-wrap-history t)

  ;; enable paredit in your REPL
  (add-hook 'cider-repl-mode-hook 'paredit-mode)

  (eval-after-load 'cider
  '(progn
     ;;(define-key clojure-mode-map (kbd "C-c C-v") 'cider-start-http-server)
     ;;(define-key clojure-mode-map (kbd "C-M-r") 'cider-refresh)
     (define-key clojure-mode-map (kbd "C-c u") 'cider-user-ns)
     (define-key cider-mode-map (kbd "C-c u") 'cider-user-ns)))
  )

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session))

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :commands projectile-mode
  :config
  (progn
    (projectile-global-mode t)
    (setq projectile-enable-caching t)
    (use-package ag
      :commands ag
      :ensure t)))
