;;; config.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Abdelhak Bougouffa

;; Personal info
(setq user-full-name "Ehsan Irani"
      user-mail-address "ehsan.irani@protonmail.com")

;; Set the default GPG key ID, see "gpg --list-secret-keys"
;; (setq-default epa-file-encrypt-to '("XXXX"))

(setq
 ;; Set a theme for MinEmacs, supported themes include these from `doom-themes'
 ;; and `modus-themes'.
 minemacs-theme 'modus-vivendi-tritanopia ; `doom-one' is a dark theme, `doom-one-light' is the light one
 ;; Set Emacs fonts, some good choices include:
 ;; - Cascadia Code
 ;; - Fira Code, FiraCode Nerd Font
 ;; - Iosevka, Iosevka Fixed Curly Slab
 ;; - IBM Plex Mono
 ;; - JetBrains Mono
 minemacs-fonts
 '(:font-family "Fira Code Retina"
   :font-size 12
   ;:variable-pitch-font-family "IBM Plex Serif"
   :variable-pitch-font-size 12))


(+deferred!
 ;; Auto enable Eglot in supported modes using `+eglot-auto-enable' (from the
 ;; `me-prog' module). You can use `+lsp-auto-enable' instead to automatically
 ;; enable LSP mode in supported modes (from the `me-lsp' module).
 (+eglot-auto-enable)

 (with-eval-after-load 'eglot
   ;; You can use this to fill `+eglot-auto-enable-modes' with all supported
   ;; modes from `eglot-server-programs'
   (+eglot-use-on-all-supported-modes eglot-server-programs)))

;; If you installed Emacs from source, you can add the source code
;; directory to enable jumping to symbols defined in Emacs' C code.
(setq source-directory "~/softwares/emacs/")

;; I use Brave, and never use Chrome, so I replace chrome program with "brave"
(setq browse-url-chrome-program (or (executable-find "brave") (executable-find "chromium")))


;; Module: `me-natural-langs' -- Package: `spell-fu'
(with-eval-after-load 'spell-fu
  ;; We can use MinEmacs' helper macro `+spell-fu-register-dictionaries'
  ;; to enable multi-language spell checking.
  (+spell-fu-register-dictionaries! "en" "de"))

;; Module: `me-org' -- Package: `org'
(with-eval-after-load 'org
  ;; Set Org-mode directory
  (setq org-directory "~/org/" ; let's put files here
        org-default-notes-file (concat org-directory "inbox.org"))
  ;; Customize Org stuff
;   (setq org-todo-keywords
;         '((sequence "IDEA(i)" "TODO(t)" "NEXT(n)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "KILL(k)")
;;           (sequence "[ ](T)" "[-](S)" "|" "[X](D)")
;;           (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

  (setq org-export-headline-levels 5)

  ;; Your Org files to include in the agenda
  (setq org-agenda-files
        (mapcar
         (lambda (f) (concat org-directory f))
         '("inbox.org"
           "agenda.org"
           "work.org"
           "projects.org"))))

;; Module: `me-notes' -- Package: `org-roam'
(with-eval-after-load 'org-roam
  (setq org-roam-directory (concat org-directory "slip-box/")
        org-roam-db-location (concat org-roam-directory "org-roam.db"))

  ;; Register capture template (via Org-Protocol)
  ;; Add this as bookmarklet in your browser
  ;; javascript:location.href='org-protocol://roam-ref?template=r&ref=%27+encodeURIComponent(location.href)+%27&title=%27+encodeURIComponent(document.title)+%27&body=%27+encodeURIComponent(window.getSelection())
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain "%?"
           :if-new (file+head "web/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+created: %U\n\n${body}\n")
           :unnarrowed t))))

(setq doom-modeline-height 60)
;;(use-package doom-modeline)
;;  :straight t
;;  :hook (minemacs-after-startup . doom-modeline-mode)
;;  :custom
;;  (doom-modeline-height 55)
;;  (doom-modeline-bar-width 8)
;;  (doom-modeline-time-icon nil)
;;  (doom-modeline-buffer-encoding 'nondefault)
;;  (doom-modeline-unicode-fallback t)
;;  :config
;;  ;; HACK: Add some padding to the right
;;  (doom-modeline-def-modeline 'main
;;    '(bar workspace-name window-number modals matches follow buffer-info
;;      remote-host buffer-position word-count parrot selection-info
;;    '(compilation objed-state misc-info persp-name battery grip irc mu4e gnus
;;      github debug repl lsp minor-modes input-method indent-info buffer-encoding
;;      major-mode process vcs checker time "  ")
