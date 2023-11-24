(use-package ligature
  :straight t
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; (use-package ligature
;;   :straight t
;;   ;:load-path "path-to-ligature-repo"
;;   :config

;;   ;; JuliaMono (https://juliamono.netlify.app/) supports the following small set of ligatures
;;   (let ((ligs '("->" "=>" "|>" "<|" "::" "<--" "-->" "<-->")))
;;     (ligature-set-ligatures 'prog-mode ligs)
;;     (ligature-set-ligatures 'org-mode ligs))

;;   ;; Enables ligature checks globally in all buffers. You can also do it
;;   ;; per mode with `ligature-mode'.
;;   (global-ligature-mode t))


(use-package vterm
  :straight t
  :commands vterm
  :config
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(use-package vterm-toggle
  :straight t)


(global-set-key [f2] 'vterm-toggle)
(global-set-key [C-f2] 'vterm-toggle-cd)

;; you can cd to the directory where your previous buffer file exists
;; after you have toggle to the vterm buffer with `vterm-toggle'.



;; Dashboard
; (use-package dashboard
;   :straight t
;   :config
;   (dashboard-setup-startup-hook)
;  (setq dashboard-center-content t))


;(load "~/.emacs.d/local/org-agenda-dashboard/org-agenda-dashboard.el")

;; set up windmove bindings
;;   (when (fboundp 'windmove-default-keybindings)
;;    (windmove-default-keybindings 'meta))
;;
;;   ;; move up/down with ALT+up/down arrow
;;   (global-set-key (kbd "<M-w-up>") 'windmove-up)
;;   (global-set-key (kbd "<M-w-down>") 'windmove-down)
;;
;;   ;; move left/right with ALT+left/right arrow
;;   (global-set-key (kbd "<M-w-left>") 'windmove-left)
;;   (global-set-key (kbd "<M-w-right>") 'windmove-right)


;; (defun my/magit-display-buffer (buffer)
;;   (if (and git-commit-mode
;;            (with-current-buffer buffer
;;              (derived-mode-p 'magit-diff-mode)
;;       (display-buffer buffer '((display-buffer-pop-up-window
;;                                 display-buffer-use-some-window
;;                                 display-buffer-below-selected
;;                                (inhibit-same-window . t)
;;     (magit-display-buffer-traditional buffer))
;;
;; (setq magit-display-buffer-function #'my/magit-display-buffer)


(provide 'ee-uitools)
