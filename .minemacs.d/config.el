;;; config.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022-2023 Abdelhak Bougouffa

;; Personal info
(setq user-full-name "Ehsan Irani"
      user-mail-address "ehsan.irani@protonmail.com")

;; Set the default GPG key ID, see "gpg --list-secret-keys"
;; (setq-default epa-file-encrypt-to '("XXXX"))

;; Set a theme for MinEmacs, supported themes include these from `doom-themes'
;; or built-in themes
;(setq minemacs-theme 'doom-vibrant) ; `doom-one' is a dark theme, `doom-one-light' is the light one
(setq minemacs-theme 'doom-material-dark) ; `doom-one' is a dark theme, `doom-one-light' is the light one

;; MinEmacs defines the variable `minemacs-fonts-plist' that is used by the
;; `+setup-fonts' function. The function checks and enables the first available
;; font from these defined in `minemacs-fonts-plist'. This variable can be
;; customized to set font specs for specific Emacs faces or to enable some
;; language-specific fonts.

;; You can set a list of fonts to be used, like the snippet below. The first
;; font found on the system will be used:
(plist-put minemacs-fonts-plist
           :default ;; <- applies to the `default' face usig `custom-theme-set-faces'
           '((:family "Fira Code" :height 120 :weight regular) ; <- priority 1
             (:family "JuliaMono" :height 110 :weight light) ; <- priority 2
             (:family "Cascadia Code" :height 120 :weight semi-light))) ; <- priority 3
;; (plist-put minemacs-fonts-plist
;;            :default ;; <- applies to the `default' face usig `custom-theme-set-faces'
;;            '((:family "Iosevka Fixed Curly Slab" :height 130) ; <- priority 1
;;              (:family "JetBrains Mono" :height 110 :weight light) ; <- priority 2
;;              (:family "Cascadia Code" :height 120 :weight semi-light))) ; <- priority 3

;; To set font for arbitrary Emacs face, you need just to write the face name as
;; a keyword. For example `variable-pitch' -> `:variable-pitch':
(plist-put minemacs-fonts-plist
           :variable-pitch ;; <- applies to the `variable-pitch' face usig `custom-theme-set-faces'
           '("Lato"
             "Roboto"
             "Inter"
             "Helvetica"))

;; For example to set custom font for `mode-line' -> `:mode-line':
(plist-put minemacs-fonts-plist
           :mode-line ;; <- applies to the `mode-line' face usig `custom-theme-set-faces'
           '((:family "JuliaMono" :weight regular)
             (:family "Roboto" :weight light)))

(plist-put minemacs-fonts-plist
           :mode-line-inactive ;; <- applies to the `mode-line-inactive'
           '((:family "JuliaMono" :weight light)
             (:family "Roboto" :weight light)))

;; You can also setup some language-specific fonts. For example, to use "Amiri"
;; or "KacstOne" for Arabic script (the first to be found). All scripts
;; supported by Emacs can be found in `+known-scripts'. The value of the extra
;; `:prepend' is passed the last argument to `set-fontset-font'. The extra
;; `:scale' parameter can be used to set a scaling factor for the font in Emacs'
;; `face-font-rescale-alist'.
(plist-put minemacs-fonts-plist
           :arabic ;; <- applies to arabic script using `set-fontset-font'
           '((:family "Vazirmatn" :scale 0.9)))

;; set font for Farsi/Arabic text
(set-fontset-font
   "fontset-default"
   (cons (decode-char 'ucs #x0600) (decode-char 'ucs #x06ff)) ; arabic
   "Vazirmatn 11")

;; When `me-daemon' and `me-email' are enabled, MinEmacs will try to start
;; `mu4e' in background at startup. To disable this behavior, you can set
;; `+mu4e-auto-start' to nil here.
;; (setq +mu4e-auto-start nil)

(+deferred!
 ;; Auto enable Eglot in modes `+eglot-auto-enable-modes' using
 ;; `+eglot-auto-enable' (from the `me-prog' module). You can use
 ;; `+lsp-auto-enable' instead to automatically enable LSP mode in supported
 ;; modes (from the `me-lsp' module).
 (+eglot-auto-enable)

 ;; Add `ocaml-mode' to `eglot' auto-enable modes
 (add-to-list '+eglot-auto-enable-modes 'ocaml-mode)

 (with-eval-after-load 'eglot
   ;; You can use this to fill `+eglot-auto-enable-modes' with all supported
   ;; modes from `eglot-server-programs'
   (+eglot-use-on-all-supported-modes eglot-server-programs)))

;; If you installed Emacs from source, you can add the source code
;; directory to enable jumping to symbols defined in Emacs' C code.
;; (setq source-directory "~/Sources/emacs-git/")

;; I use Brave, and never use Chrome, so I replace chrome program with "brave"
(setq browse-url-chrome-program (or (executable-find "brave") (executable-find "chromium")))

;; Install some third-party packages. MinEmacs uses `use-package' and `straight'
;; for package management. It is recommended to use the same to install
;; additional packages. For example, to install `devdocs' you can use something
;; like:
(use-package devdocs
  ;; The installation recipe (from Github)
  :straight (:host github :repo "astoff/devdocs.el" :files ("*.el"))
  ;; Autoload the package when invoking these commands, note that if the
  ;; commands are already autoloaded (defined with `autoload'), this is not
  ;; needed.
  :commands devdocs-install
  ;; MinEmacs sets the `use-package-always-defer' to t, so by default, packages
  ;; are deferred to save startup time. If you want to load a package
  ;; immediately, you need to explicitly use `:demand t'.
  ;; :demand t
  ;; Set some custom variables, using the `:custom' block is recommended over
  ;; using `setq'. This will ensure calling the right setter function if it is
  ;; defined for the custom variable.
  :custom
  (devdocs-data-dir (concat minemacs-local-dir "devdocs/")))

;; Module: `me-tools' -- Package: `vterm'
;; When the libvterm present in the system is too old, you can face VTERM_COLOR
;; related compilation errors. Thil parameter tells `vterm' to download libvterm
;; for you, see the FAQ at: github.com/akermu/emacs-libvterm.
;; (with-eval-after-load 'vterm
;;   (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=Off"))

;; Module: `me-rss' -- Package: `elfeed'
(with-eval-after-load 'elfeed
  ;; Add news feeds for `elfeed'
  (setq elfeed-feeds
        '("https://itsfoss.com/feed"
          "https://lwn.net/headlines/rss"
          "https://linuxhandbook.com/feed"
          "https://www.omgubuntu.co.uk/feed"
          "https://this-week-in-rust.org/rss.xml"
          "https://planet.emacslife.com/atom.xml")))


;; Module: `me-org' -- Package: `org'
(with-eval-after-load 'org
  ;; Set Org-mode directory
  (setq org-directory "~/org/" ; let's put files here
        org-default-notes-file (concat org-directory "inbox.org"))
  ;; Customize Org stuff
  ;; (setq org-todo-keywords
  ;;       '((sequence "IDEA(i)" "TODO(t)" "NEXT(n)" "PROJ(p)" "STRT(s)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "KILL(k)")
  ;;         (sequence "[ ](T)" "[-](S)" "|" "[X](D)")
  ;;         (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))

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
;; For better integration with other packages (like `citar-org-roam'), it is
;; recommended to set the `org-roam-directory' before loading the package.
(setq org-roam-directory "~/org/slip-box/")

(with-eval-after-load 'org-roam
  (setq org-roam-db-location (concat org-roam-directory "org-roam.db"))

  ;; Register capture template (via Org-Protocol)
  ;; Add this as bookmarklet in your browser
  ;; javascript:location.href='org-protocol://roam-ref?template=r&ref=%27+encodeURIComponent(location.href)+%27&title=%27+encodeURIComponent(document.title)+%27&body=%27+encodeURIComponent(window.getSelection())
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain "%?"
           :if-new (file+head "web/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+created: %U\n\n${body}\n")
           :unnarrowed t))))


;; Module: `me-ros' -- Package: `ros'
(with-eval-after-load 'ros
  (setq ros-workspaces
        (list
         (ros-dump-workspace
          :tramp-prefix "/docker:ros@ros-machine:"
          :workspace "~/ros_ws"
          :extends '("/opt/ros/noetic/"))
         (ros-dump-workspace
          :tramp-prefix "/docker:ros@ros-machine:"
          :workspace "~/ros2_ws"
          :extends '("/opt/ros/foxy/")))))


(setq doom-modeline-height 60)
