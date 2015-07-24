;;;;; init --- Summary

;;;; Emacs Init file

;;;; Commentary:

;;;; Code:

;;; Setting the path
(let* ((extra '("/usr/texbin" "/usr/local/bin" "/Applications/ghc-7.8.4.app/Contents/bin"))
       (extra-path-form (mapconcat (lambda (x) (concat ":" x)) extra "")))
  (setenv "PATH" (concat (getenv "PATH") extra-path-form))
  (setq exec-path (append exec-path extra)))

;;;; Packages

;;; Set sources
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(menu-bar-mode nil)
 '(org-agenda-files (quote ("~/.org/tasks.org" "~/.org//notes.org")))
 '(package-archives
   (quote
    (("melpa" . "http://melpa.org/packages/")
     ("melpa-stable" . "http://stable.melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/")))))

(package-initialize)

;;; Use package Setup
(package-install 'use-package)
(package-install 'diminish)
(package-install 'bind-key)
(eval-when-compile
  (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant


;;; Haskell
(use-package haskell-mode
  :config (progn
	    (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
	    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)))

;;; Amber theme
(use-package ample-theme
  :config (progn (load-theme 'ample t t)
	       (load-theme 'ample-flat t t)
	       (load-theme 'ample-light t t)
	       (enable-theme 'ample-flat))
  :ensure t)

;;; Winner Mode
(use-package winner
  :config (winner-mode 1))

;;; Undo Tree
(use-package undo-tree
  :config (undo-tree-mode t)
  :diminish undo-tree-mode
  :ensure t)

;;; Evil Mode
(use-package evil
  :if 'ample-theme
  :config (progn
	    ;; Evil Mode Switcher
	    (defun toggle-evil-mode ()
	      (interactive)
	      (if (not evil-mode)
		  (progn
		    (evil-mode 1)
		    (enable-theme 'ample))
		(progn
		  (evil-mode 0)
		  (enable-theme 'ample-flat))))
	    (global-set-key (kbd "<C-escape>") 'toggle-evil-mode)

	    ;; Redefining Keys
	    (evil-declare-key 'normal global-map (kbd "C-e") 'evil-end-of-line)
	    (evil-declare-key 'insert global-map (kbd "C-e") 'end-of-line)
	    (mapc (lambda (state)	; For some reason this only works with mapcar
			(evil-declare-key state global-map (kbd "C-f") 'evil-forward-char)
			(evil-declare-key state global-map (kbd "C-b") 'evil-backward-char)
			(evil-declare-key state global-map (kbd "C-d") 'evil-delete-char)
			(evil-declare-key state global-map (kbd "C-n") 'evil-next-line)
			(evil-declare-key state global-map (kbd "C-p") 'evil-previous-line)
			(evil-declare-key state global-map (kbd "C-w") 'evil-delete)
			(evil-declare-key state global-map (kbd "C-y") 'yank)
			(evil-declare-key state global-map (kbd "C-k") 'kill-line))
		    '(normal insert visual))

	    (define-key evil-normal-state-map (kbd "q") nil)

	    ;; Fixing up certain states
					; Not currently working...
	    (evil-set-initial-state 'MagitPopup 'emacs))
  :ensure t)

;;; Rainbow Delimiters
(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  :ensure t
  :pin melpa-stable)

;;; Magit
(use-package magit
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch-popup))
  :ensure t
  :pin melpa-stable)

;; ;;; Flx
;; (use-package flx
;;   :ensure t)

;; (use-package flx-ido
;;   :if 'flx
;;   :config (progn
;;	   (ido-mode 1)
;;	   (ido-everywhere 1)
;;	   (flx-ido-mode 1)
;;	   ;; disable ido faces to see flx highlights.
;;	   (setq ido-enable-flex-matching t)
;;	   (setq ido-use-faces nil))
;;   :ensure t)

;;; Helm
(use-package helm
  :bind (("M-x" . helm-M-x)
	 ("C-c h" . helm-command-prefix))
  :ensure t)

(use-package helm-config
  :if 'helm
  :config (progn
	    (require 'helm-config)
	    (setq helm-split-window-in-side-p           t
		  helm-move-to-line-cycle-in-source     t
		  helm-ff-search-library-in-sexp        t
		  helm-scroll-amount                    8
		  helm-ff-file-name-history-use-recentf t)
					; rebind tab to run persistent action
	    (define-key helm-command-map (kbd "<tab>")
	      'helm-execute-persistent-action)
					; make TAB works in terminal
	    (define-key helm-command-map (kbd "C-i")
	      'helm-execute-persistent-action)
					; list actions using C-z
	    (define-key helm-command-map (kbd "C-z")
	      'helm-select-action)

	    (when (executable-find "curl")
	      (setq helm-google-suggest-use-curl-p t))

	    (helm-mode t)))

(use-package helm-dash
  :if 'helm-config
  :config '()
  :ensure t)

;;; Fly Check
(use-package flycheck
  :config (add-hook 'after-init-hook #'global-flycheck-mode)
  :ensure t)

;;; Agressive Indent
(use-package aggressive-indent
  :ensure t)

;;; AucTex
(use-package tex-site
  :config (progn
	    (add-hook 'TeX-mode-hook
		      (lambda () (TeX-fold-mode 1))))
  :ensure auctex)

;;; Whitespace Cleanup
(use-package whitespace-cleanup-mode
  :config (global-whitespace-cleanup-mode t)
  :diminish whitespace-cleanup-mode
  :ensure t)

;;; Smart Mode Line
;; (use-package smart-mode-line
;;   :config (progn
;;	    (setq sml/theme 'respectful)
;;	    (sml/setup))
;;   :ensure t)

;;; Org Mode
(use-package org
  :config (progn
	    (setq org-directory "~/.org/")
	    (let ((notes (concat org-directory "/notes.org")))
	      (setq org-default-notes-file notes
		    org-agenda-files (list notes)))
	    (setq org-log-done 'time
		  org-todo-keywords
		  '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)"))
		  org-startup-indented t
		  org-special-ctrl-a/e t
		  org-capture-templates
		  '(("t" "Todo" entry
		     (file+headline "~/.org/tasks.org" "Tasks")
		     "* TODO %?")
		    ("T" "Referenced Todo" entry
		     (file+headline "~/.org/tasks.org" "Tasks")
		     "* TODO %?\n  %i\n  %a")
		    ("b" "Buy something" entry
		     (file+headline "~/.org/tasks.org" "Shopping")
		     "* TODO %?")
		    ("e" "Emacs useful thing" entry
		     (file+headline "~/.org/emacs.org" "Captured")
		     "* %?")
		    ("j" "Journal" entry (file+datetree "~/.org/journal.org")
		     "* %?\nEntered on %U\n  %i\n  %a"))))
  :bind (("C-c l" . org-store-link)
	 ("C-c c" . org-capture)
	 ("C-c a" . org-agenda)
	 ("C-c b" . org-iswitchb))
  :ensure t)

;; (use-package sublimity
;;   :config (progn
;;	    (sublimity-mode 1)
;;	    (require 'sublimity-scroll))
;;   :ensure t)

;; (use-package smooth-scroll
;;   :config (smooth-scroll-mode t)
;;   :diminish smooth-scroll-mode
;;   :ensure t)

(use-package tea-time
  :config (setq tea-time-sound-command "afplay %s")
  :ensure t)

;;; Clojure
(use-package clojure-mode
  :config (progn
	    (add-hook 'clojure-mode-hook #'subword-mode))
  :ensure t)

(use-package cider
  :ensure t
  :pin melpa-stable)

;;; Bongo
(use-package bongo
  :ensure t)

(use-package writeroom-mode
  :ensure t)

;;; YaSnippet
(use-package yasnippet
;;  :config (progn (add-hook 'prog-mode-hook #'yas-minor-mode))
  :ensure t)

;;; EShell

(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

;;;; Misc

;;; Fix scrolling and bells
(global-set-key [wheel-right] 'ignore)	; This is because wheel-right
					; takes me off screen too easily
(global-set-key [wheel-left] 'scroll-right)

(defun my-bell-function ()
  "This bell function doesn't ring on certian occasions."
  (unless (memq this-command
	'(isearch-abort abort-recursive-edit exit-minibuffer
	      keyboard-quit mwheel-scroll down up next-line previous-line
	      backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

;;; Removing the tool bar
(tool-bar-mode -1)

;;; Edit this config
(global-set-key (kbd "<f12>")
		(lambda ()
		  (interactive)
		  (find-file-other-window user-init-file)))

;;; Hippie Expand
(global-set-key "\M- " 'hippie-expand)

;;; Cycle spacing
(global-set-key (kbd "C-c C-SPC") 'cycle-spacing)

;;; Dealing with parens
(show-paren-mode 1)

;;; Better Scrolling
(setq redisplay-dont-pause t
      scroll-margin 7
      scroll-step 1
      scroll-conservatively 10
      scroll-preserve-screen-position 1
      mouse-wheel-scroll-amount '(1 ((shift) . 1))  ; one line at a time
      mouse-wheel-progressive-speed nil)            ; don't accelerate

;;; C Code
(setq c-default-style "linux"
      c-basic-offset 4)

(provide 'init)

;;; Fixing Re-builder
(setq reb-re-syntax 'string)

;;; Renaming Current file
;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
	  (message "A buffer named '%s' already exists!" new-name)
	(progn
	  (rename-file name new-name 1)
	  (rename-buffer new-name)
	  (set-visited-file-name new-name)
	  (set-buffer-modified-p nil))))))

;;; Flyspell fixing
(setq ispell-program-name "aspell")
(setq ispell-list-command "list")

(global-set-key [M-down-mouse-1] 'flyspell-correct-word)

;;; OSX Tricks

;; Use spotlight for locating
(setq locate-command "mdfind")

;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(region ((t (:background "selectedTextBackgroundColor")))))
