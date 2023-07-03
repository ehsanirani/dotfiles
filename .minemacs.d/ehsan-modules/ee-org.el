;; Org-modern
(use-package org-indent-mode
  :hook org-mode) ; add late to hook


(use-package org-modern-indent
  ;:load-path "~/code/emacs/org-modern-indent/"
  ; or
  :straight (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :config ; add late to hook
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars nil)                                                                                                                                                   ; adds extra indentation
  (org-modern-table nil)
  (org-modern-list
   '((?- . "◆")
     (?* . "⚫")
     (?+ . "▶")))
  :hook
  (org-mode . org-modern-mode)
  (org-mode . org-modern-indent-mode)
  (org-agenda-finalize . org-modern-agenda))

(setq org-startup-indented t)

(use-package org-transclution)
(define-key global-map (kbd "<f12>") #'org-transclusion-add)
(define-key global-map (kbd "<C-n t>") #'org-transclusion-mode)

(provide 'ee-org)
