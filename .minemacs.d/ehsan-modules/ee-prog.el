;;;;;;


;; Quarto with use-package:
(use-package quarto-mode
  :straight t)


(use-package eglot-jl
  :straight t)

;; (use-package julia-mode
;;   :straight t
;;   :mode "\\.jl$"
;;   :interpreter ("julia +1.9" . julia-mode)
;;   :init (setenv "JULIA_NUM_THREADS" "4")
;;   :config
;;   (add-hook 'julia-mode-hook 'eglot-jl-init)
;;   (add-hook 'julia-mode-hook 'eglot-ensure)
;;   (add-hook 'julia-mode-hook (lambda () (setq julia-repl-set-terminal-backend 'vterm)))
;;   (add-hook 'julia-mode-hook (lambda () (setq julia-repl-set-terminal-backend 'vterm)))
;;   (add-hook 'julia-mode-hook (lambda () (setq julia-repl-set-terminal-backend 'vterm))))

;; Add any specific configuration for julia-formatter here

(use-package julia-ts-mode
  :straight t
  :mode "\\.jl$"
 :interpreter ("julia +1.9" . julia-mode)
 :init (setenv "JULIA_NUM_THREADS" "4")
 :config
 (add-hook 'julia-mode-hook 'eglot-jl-init)
 (add-hook 'julia-mode-hook 'eglot-ensure)
 (add-hook 'julia-mode-hook (lambda () (setq julia-repl-set-terminal-backend 'vterm)))
 (add-hook 'julia-mode-hook (lambda () (setq julia-repl-set-terminal-backend 'vterm)))
 (add-hook 'julia-mode-hook (lambda () (setq julia-repl-set-terminal-backend 'vterm)))
 (add-hook 'julia-mode-hook #'julia-formatter-mode))

;; Julia Formatter
(use-package julia-formatter
  :straight (julia-formatter :type git :host codeberg :repo "FelipeLema/julia-formatter.el"
                             :files ("julia-formatter.el"
                                     "toml-respects-json.el"
                                     "formatter_service.jl"
                                     "Manifest.toml" "Project.toml")))


;(add-hook 'julia-formatter-mode-hook #'aggressive-indent)

(setq eglot-connect-timeout 1000)

(use-package vterm-toggle)

(use-package ob-julia-vterm)


(use-package julia-repl
  :straight t
  :interpreter ("julia +1.9" . julia-mode)
  :hook (julia-mode . julia-repl-mode)

  :init
  (setenv "JULIA_NUM_THREADS" "auto")

  :config
  ;; Set the terminal backend
  (julia-repl-set-terminal-backend 'vterm)

  ;; Keybindings for quickly sending code to the REPL
  (define-key julia-repl-mode-map (kbd "<C-RET>") 'my/julia-repl-send-cell)
  (define-key julia-repl-mode-map (kbd "<M-RET>") 'julia-repl-send-line)
  (define-key julia-repl-mode-map (kbd "<S-return>") 'julia-repl-send-buffer))

;; python

(use-package blacken
  :straight t)

;; (use-package poetry
;;   :straight t
;;   :defer t
;;   :config
;;   ;; Checks for the correct virtualenv. Better strategy IMO because the default
;;   ;; one is quite slow.
;;   ;(setq poetry-tracking-strategy 'switch-buffer)
;;   :hook (python-mode . poetry-tracking-mode))

;; Fix path
(use-package exec-path-from-shell
  :straight t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; (use-package treesit
;;   :commands (treesit-install-language-grammar nf/treesit-install-all-languages)
;;   :init
;;   (setq treesit-language-source-alist
;;    '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
;;      (c . ("https://github.com/tree-sitter/tree-sitter-c"))
;;      (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
;;      (css . ("https://github.com/tree-sitter/tree-sitter-css"))
;;      (go . ("https://github.com/tree-sitter/tree-sitter-go"))
;;      (html . ("https://github.com/tree-sitter/tree-sitter-html"))
;;      (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
;;      (json . ("https://github.com/tree-sitter/tree-sitter-json"))
;;      (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
;;      (make . ("https://github.com/alemuller/tree-sitter-make"))
;;      (python . ("https://github.com/tree-sitter/tree-sitter-python"))
;;      (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
;;      (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
;;      (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
;;      (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
;;      ;(julia-ts . ("https://github.com/tree-sitter/tree-sitter-julia"))
;;      (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
;;   :config
;;   (defun nf/treesit-install-all-languages ()
;;     "Install all languages specified by `treesit-language-source-alist'."
;;     (interactive)
;;     (let ((languages (mapcar 'car treesit-language-source-alist)))
;;       (dolist (lang languages)
;;         (treesit-install-language-grammar lang)
;;         (message "`%s' parser was installed." lang)
;;         (sit-for 0.75))))

;(unless (package-installed-p 'cider)
;  (package-install 'cider))
;K(use-package cider
;  :straight t)

(provide 'ee-prog)
