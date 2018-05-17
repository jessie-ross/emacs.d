;;; Syntax Management

;; Fly Check
;; This doesn't work when first loaded but when I reload it it works
(use-package flycheck
  :config (progn
	    (flycheck-define-checker javascript-eslint
	      "A Javascript syntax and style checker using eslint.

See URL `http://eslint.org/'."
	      :command ("npx" "eslint" "--format=json"
			(option-list "--rulesdir" flycheck-eslint-rules-directories)
			"--stdin" "--stdin-filename" source-original)
	      :standard-input t
	      :error-parser flycheck-parse-eslint
	      ; Hack: fix: (flycheck-eslint-config-exists-p)
	      :enabled (lambda () (quote t))
	      :modes (js-mode js-jsx-mode js2-mode js2-jsx-mode js3-mode rjsx-mode)
	      :working-directory flycheck-eslint--find-working-directory
	      :verify
	      (lambda (_)
		(let* ((default-directory
			 (flycheck-compute-working-directory 'javascript-eslint))
		       (have-config t))
		  (list
		   (flycheck-verification-result-new
		    :label "config file"
		    :message (if have-config "found" "missing or incorrect")
		    :face (if have-config 'success '(bold error)))))))
            (add-hook 'prog-mode-hook #'flycheck-mode)))

;;; Hippie Expand
(global-set-key (kbd "C-M-SPC") 'hippie-expand)

;;; Cycle spacing
(global-set-key (kbd "C-c C-SPC") 'cycle-spacing)

;;; Dealing with parens
(show-paren-mode 1)

(use-package flyspell
  :config
  (progn
    (setq ispell-program-name "aspell")
    ;; This seems unnessesary
    ; (setq ispell-list-command "list")
    (add-hook 'flyspell-mode-hook (lambda () (local-set-key [M-down-mouse-1] 'flyspell-correct-word)))))
