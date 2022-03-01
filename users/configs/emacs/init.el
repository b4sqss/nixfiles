(setq gc-cons-threshold (* 50 1000 1000))

;; if not using dashboard
;; (setq inhibit-startup-message t)

(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq visible-bell nil)
(setq tab-width 4)
(setq indent-tabs-mode nil)
(setq standard-indent 4)
(setq evil-shift-width tab-width)
(setq comp-async-report-warnings-errors nil)
(setq history-length 25)
(setq use-dialog-box nil)
(setq global-auto-revert-non-file-buffers t)

(savehist-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(recentf-mode 1)
(save-place-mode 1)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-face-bold-p 'bold nil)
(set-face-attribute 'default nil
		    :family "Iosevka"
		    :height 140
		    :width 'normal)

(defalias 'yes-or-no-p 'y-or-n-p)

(dolist (mode '(org-mode-hook
		term-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(require 'package)

(setq package-archives '(("melpa" ."https://melpa.org/packages/")
			 ("org" . "https:/orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq warning-suppress-types '((use-package) (use-package)))
(setq use-package-always-ensure t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(defun evil-hook ()
  (dolist (mode '(custom-mode
		  vterm-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (add-hook 'evil-mode-hook 'evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (use-package ace-jump-mode)
  (evil-global-set-key 'motion ";" 'ace-jump-mode)
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :config
  (evil-collection-init))

(use-package undo-tree
  :after evil
  :init
  (global-undo-tree-mode 1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    ;; Files
    "d" 'dired
    ;; Bufffers
    "wc" 'evil-window-delete
    "ws" 'evil-window-split
    "wv" 'evil-window-vsplit
    "wl"  'evil-window-next
    "wh"  'evil-window-prev
    ;; Org mode
    "oc" 'org-edit-special
    "ol" 'org-latex-previw
    "oi" 'org-toggle-inline-images
    "oa" 'org-agenda
    "os" 'org-schedule
    "o." 'org-toggle-checkbox
    "ot" 'org-toggle-todo-and-fold
    ;; Export
    "oep" 'org-latex-export-to-pdf
    "oeh" 'org-html-export-to-html
    ;; Babel
    "obs" 'org-babel-execute-src-block
    "obb" 'org-babel-execute-buffer
    "obl" 'org-babel-load-file
    "obt" 'org-babel-tangle
    ;; Help
    "hh" 'help
    "hk" 'helpful-key
    "hv" 'helpful-variable
    "hf" 'helpful-function
    "hs" 'helpful-symbol
    "hm" 'describe-mode
    ;; Magit
    "gs"  'magit-status
    "gc"  'magit-commit
    "gb"  'magit-branch
    "gP"  'magit-push-current
    "gf"  'magit-fetch
    "gF"  'magit-fetch-all))

(use-package vertico
  :bind (:map vertico-map
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)
	      ("C-f" . vertico-exit))
  :custom
  (vertico-cicle t)
  :init
  (vertico-mode))

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.2))

(use-package helpful
  :commands helpful-mode)

(use-package consult
  :bind (("C-s" . consult-line)
	 ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
	 ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
	 ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
	 ("M-g e" . consult-compile-error)
	 ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
	 ("M-s G" . consult-git-grep)
	 ("M-s r" . consult-ripgrep))

  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  (setq register-preview-delay 0
	register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  :config
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep)

  (setq consult-narrow-key "<")) ;; (kbd "C-+")

(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package marginalia
  :custom
  (marginalia-annotators
   '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package orderless
  :custom (completion-styles '(orderless)))

(use-package vterm
  :custom (setq explicit-shell-file-name "zsh"
		term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  :bind (("C-c e" . vterm)))

(use-package vterm-toggle
  :bind (("C-M-'" . vterm-toggle)))

(setq eshell-prompt-regexp "^[^αλ\n]*[αλ] ")
(setq eshell-prompt-function
      (lambda nil
	(concat
	 (if (string= (eshell/pwd) (getenv "HOME"))
	     (propertize "~" 'face `(:foreground "#99CCFF"))
	   (replace-regexp-in-string
	    (getenv "HOME")
	    (propertize "~" 'face `(:foreground "#99CCFF"))
	    (propertize (eshell/pwd) 'face `(:foreground "#99CCFF"))))
	 (if (= (user-uid) 0)
	     (propertize " α " 'face `(:foreground "#FF6666"))
	   (propertize " λ " 'face `(:foreground "#A6E22E"))))))

(setq eshell-highlight-prompt nil) 

(defalias 'open 'find-file-other-window)
(defalias 'clean 'eshell/clear-scrollback)

(use-package gnus)

(setq user-mail-address "bequintao@gmail.com"
      user-full-name "Basques")

(add-to-list 'gnus-secondary-select-methods '(nnimap "gmail"
						     (nnimap-address "imap.gmail.com")  ; it could also be imap.googlemail.com if that's your server.
						     (nnimap-server-port "imaps")
						     (nnimap-stream ssl)
						     (nnmail-expiry-target "nnimap+gmail:[Gmail]/Trash")  ; Move expired messages to Gmail's trash.
						     (nnmail-expiry-wait immediate))) ; Mails marked as expired can be processed immediately.

(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")
	   (setq dired-omit-files "^\\.[^.].*")))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-git)

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package treemacs
  :bind (("C-c t" . treemacs)))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-all-the-icons
  :after (treemacs))

(use-package treemacs-all-the-icons
  :after treemacs
  :init
  (require 'treemacs-all-the-icons)
  (treemacs-load-theme 'all-the-icons))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package magit
  :bind ("C-M-;" . magit-status)
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package no-littering)

(use-package async
  :ensure t
  :init (dired-async-mode 1))

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package crux
  :bind (("C-c D" . crux-delete-file-and-buffer)))

(use-package bug-hunter)

(use-package olivetti
  :bind ("C-c o" . olivetti-mode))

;; (use-package quelpa-use-package)
;; ;; Don't forget to run M-x eaf-install-dependencies
;; (use-package eaf
;;   :demand t
;;   :quelpa (eaf :fetcher github
;;               :repo  "manateelazycat/emacs-application-framework"
;;               :files ("*"))
;;   :load-path "~/.emacs.d/site-lisp/emacs-application-framework" ; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
;;   :init
;;   (use-package epc      :defer t :ensure t)
;;   (use-package ctable   :defer t :ensure t)
;;   (use-package deferred :defer t :ensure t)
;;   (use-package s        :defer t :ensure t)
;;   (setq browse-url-browser-function 'eaf-open-browser))

(use-package dashboard
  :preface
  (defun create-scratch-buffer ()
    "Create a scratch buffer"
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))

  (defun config-visit()
    (interactive)
    (find-file "~/.config/emacs/emacs.org"))
  (global-set-key (kbd "C-c e") 'config-visit)

  (defun reload-config()
    (interactive)
    (org-babel-load-file "~/.config/emacs/emacs.org")
    (load-file "~/.config/emacs/init.el"))
  (global-set-key (kbd "C-c r") 'reload-config)

  :config (dashboard-setup-startup-hook))

(setq dashboard-startup-banner "./etc/nix.txt")
(setq dashboard-center-content t)
(setq dashboard-set-navigator t)
(setq dashboard-show-shortcuts t)
(setq dashboard-items '((recents  . 5)
			(bookmarks . 5)
			(agenda . 10)))
(setq dashboard-set-file-icons t)
(setq dashboard-set-navigator t)
(setq dashboard-navigator-buttons
      `(;; line1
	((,nil
	  "agenda"
	  "opens org-agenda"
	  (lambda (&rest _) (org-agenda))
	  'default)
	 (nil
	  "open the emacs.org"
	  "Opens the config file"
	  (lambda (&rest _) (config-visit))
	  'default)
	 (nil
	  "new scratch buffer"
	  "Opens a scratch buffer"
	  (lambda (&rest _) (create-scratch-buffer))
	  'default)
	 )))

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(use-package page-break-lines
  :requires dashboard)

(use-package all-the-icons)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

(use-package highlight-indent-guides
  ;; :custom (setq highlight-indent-guides-method 'bitmap)
  :hook (prog-mode . highlight-indent-guides-mode))

(setq highlight-indent-guides-method 'bitmap)

(setq display-time-format "%H:%M"
      display-time-default-load-average nil)

(use-package mood-line
  :init (mood-line-mode)(display-time-mode)(display-battery-mode))

(use-package doom-themes :defer t)
  (use-package spacemacs-theme :defer t)
  (use-package nano-theme :defer t)

  (consult-theme 'doom-solarized-dark-high-contrast)

(defun toggle-theme ()
  (interactive)
  (if (eq (car custom-enabled-themes) 'doom-solarized-dark-high-contrast)
      (consult-theme 'doom-solarized-light)
    (consult-theme 'doom-solarized-dark-high-contrast)))
(global-set-key [f5] 'toggle-theme)

(defun org-mode-setup ()
  (org-indent-mode)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq org-hide-emphasis-markers t)
  (setq truncate-lines t)
  (setq evil-auto-indent nil)
  (setq left-margin-width 2)
  (setq right-margin-width 2)
  (set-window-margins (selected-window) 1 1)
  (diminish org-indent-mode))

(defun org-toggle-todo-and-fold ()
  (interactive)
  (save-excursion
    (org-back-to-heading t) ;; Make sure command works even if point is
    ;; below target heading
    (cond ((looking-at "\*+ TODO")
           (org-todo "DONE")
           (hide-subtree))
          ((looking-at "\*+ DONE")
           (org-todo "TODO")
           (hide-subtree))
          (t (message "Can only toggle between TODO and DONE.")))))

;; (define-key org-mode-map (kbd "C-c C-d") 'org-toggle-todo-and-fold)

(use-package org
  :hook (org-mode . org-mode-setup))

(setq org-ellipsis " ▾"
      org-hide-emphasis-markers t
      org-special-ctrl-a/e t
      org-special-ctrl-k t
      org-src-fontify-natively t
      org-fontify-whole-heading-line t
      org-fontify-quote-and-verse-blocks t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 2
      org-hide-block-startup nil
      org-src-preserve-indentation nil
      org-startup-folded 'content
      org-cycle-separator-lines 2
      org-agenda-files '("~/Docs/org/org-agenda.org")
      org-directory  "~/Docs/org/"
      org-todo-keywords '((sequence "TODO" "|" "DONE")))


(defun my-org-archive-done-tasks ()
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file)
  (org-map-entries 'org-archive-subtree "/CANCELLED" 'file))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("scm" . "src scheme"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("tex" . "src latex"))
(add-to-list 'org-structure-template-alist '("go" . "src go"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(setq org-confirm-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp .t)
   (python . t)
   (scheme . t)
   (shell . t)))

(use-package org-pomodoro
  :bind (("C-c p s" . org-timer-set-timer)
         ("C-c p p" . org-timer-pause-or-continue)))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "●" "○" "•" "●" "○" "•")))

(let* ((base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces 'user
                          `(org-level-8 ((t (,@headline ))))
                          `(org-level-7 ((t (,@headline ))))
                          `(org-level-6 ((t (,@headline ))))
                          `(org-level-5 ((t (,@headline ))))
                          `(org-level-4 ((t (,@headline , :height 1.1))))
                          `(org-level-3 ((t (,@headline , :height 1.25))))
                          `(org-level-2 ((t (,@headline , :height 1.5))))
                          `(org-level-1 ((t (,@headline , :height 1.75))))
                          `(org-document-title ((t (,@headline , :height 1.5 :underline nil))))))

(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 60)

(use-package org-journal
  :config (setq org-journal-dir "~/Docs/org/journal/")
  :bind (("C-c j n" . org-journal-new-entry)
         ("C-c j s" . org-journal-search)))

(defun org-start-presentation ()
  (interactive)
  (org-tree-slide-mode 1)
  (setq text-scale-mode-amount 3)
  (text-scale-mode 1))

(defun org-end-presentation ()
  (interactive)
  (text-scale-mode 0)
  (org-tree-slide-mode 0))

(use-package org-tree-slide
  :defer t
  :after org
  :commands org-tree-slide-mode
  :config
  (evil-define-key 'normal org-tree-slide-mode-map
    (kbd "q") 'org-end-presentation
    (kbd "C-j") 'org-tree-slide-move-next-tree
    (kbd "C-k") 'org-tree-slide-move-previous-tree)
  (setq org-tree-slide-slide-in-effect nil
        org-tree-slide-activate-message "Presentation started."
        org-tree-slide-deactivate-message "Presentation ended."
        org-tree-slide-header t))

(use-package org-ql)

(use-package ox-reveal)

(use-package pandoc)
(use-package ox-pandoc)
(use-package pdf-tools
  :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (define-pdf-cache-function pagelabels))

(setq org-default-notes-file (concat org-directory "/notes.org"))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Docs/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/Docs/org/roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n d n" . org-roam-dailies-capture-today))
  :config (org-roam-setup))
(setq org-roam-v2-ack t)
(setq org-roam-dailies-directory "journal/")

(defun org/prettify-set ()
  (interactive)
  (setq prettify-symbols-alist
        '(("#+begin_src" . "→")
          ("#+BEGIN_SRC" . "→")
          ("#+end_src" . "←")
          ("#+END_SRC" . "←")
          ("#+begin_example" . "")
          ("#+BEGIN_EXAMPLE" . "")
          ("#+end_example" . "")
          ("#+END_EXAMPLE" . "")
          ("#+results:" . "")
          ("#+RESULTS:" . ""))))
(add-hook 'org-mode-hook 'org/prettify-set)

(global-prettify-symbols-mode)

(use-package lsp-mode
  :straight t
  :hook (typescript-mode js2-mode web-mode)
  :bind
  ("C-c l n" . lsp-ui-find-next-reference)
  ("C-c l p" . lsp-ui-find-prev-reference)
  ("C-c l s" . counsel-imenu)
  ("C-c l e" . lsp-ui-flycheck-list)
  ("C-c l S" . lsp-ui-sideline-mode))

(use-package lsp-ui
  :straight t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-doc-enable t
        lsp-ui-doc-delay 0.2
        lsp-ui-flycheck-enable t))

(use-package dap-mode
  :straight t
  :custom (lsp-enable-dap-auto-configure nil)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (dap-node-setup))

(use-package ccls
  :hook (lsp)
  :bind
  ("C-c c" . compile)
  :config

  (use-package irony
    :commands irony-mode
    :init (add-hooks '(((c++-mode c-mode objc-mode) . irony-mode))))

  (use-package c-eldoc
    :commands c-turn-on-eldoc-mode
    :init (add-hook 'c-mode-common-hook 'c-turn-on-eldoc-mode))

  (use-package irony-eldoc
    :commands irony-eldoc
    :init (add-hook 'irony-mode-hook 'irony-eldoc)))

(use-package go-mode
  :hook (go-mode . lsp-deferred))

(use-package flycheck-golangci-lint)

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (use-package dap-python))

(use-package pyvenv
  :config
  (pyvenv-mode 1))

(use-package js2-mode
  :custom
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  (setq js2-mode-show-strict-warnings nil))

(use-package apheleia
  :custom (apheleia-global-mode +1))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package geiser-mit)

(use-package lispy
  :hook ((emacs-lisp-mode scheme-mode) . lispy-mode))

(use-package lispyville
  :hook (lispy-mode . lispyville-mode))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package zig-mode
  :custom (setq lsp-zig-zls-executable "/usr/bin/env= zls")
  :hook (zig-mode . lsp-deferred)
  :mode "\\.zig\\'"
  :config
  (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "<path to zls>")
    :major-modes '(zig-mode)
    :server-id 'zls)))

(use-package auctex
  :hook
  (TeX-mode . TeX-PDF-mode)
  (TeX-mode . company-mode)
  :init
  (setq reftex-plug-into-AUCTeX t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)

  (setq TeX-open-quote  "<<")
  (setq TeX-close-quote ">>")
  (setq TeX-electric-sub-and-superscript t)
  (setq font-latex-fontify-script nil)
  (setq TeX-show-compilation nil)

  (setq preview-scale-function 1.5)
  (setq preview-gs-options
        '("-q" "-dNOSAFER" "-dNOPAUSE" "-DNOPLATFONTS"
          "-dPrinted" "-dTextAlphaBits=4" "-dGraphicsAlphaBits=4"))

  (setq reftex-label-alist '(AMSTeX)))

(use-package company-auctex
  :init
  (company-auctex-init))

(use-package company-math
  :init
  (add-to-list 'company-backends 'company-math))

(use-package company-reftex
  :init
  (add-to-list 'company-backends 'company-reftex-citations)
  (add-to-list 'company-backends 'company-reftex-labels))

(use-package rustic
  :init
  (setq rustic-lsp-server 'rust-analyzer)
  (setq rustic-flycheck-setup-mode-line-p nil)
  :hook ((rustic-mode . (lambda ()
                          (lsp-ui-doc-mode)
                          (company-mode))))
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  (setq rust-indent-method-chain t)
  (setq rustic-format-on-save t))

(use-package flycheck-rust)

(use-package haskell-mode
  :hook (haskell-mode . lsp-deferred)
  :mode "\\.hs\\'"
  :config
  (use-package lsp-haskell)
  (require 'lsp)
  (require 'lsp-haskell)
  (add-hook 'haskell-mode-hook #'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook #'yas-minor-mode)
  (add-hook 'haskell-mode-hook #'lsp)
  (setq haskell-stylish-on-save t))

(use-package aggressive-indent
  :hook ((emacs-lisp-mode
          inferior-emacs-lisp-mode
          scheme-mode
          ielm-mode
          python-mode
          lisp-mode
          inferior-lisp-mode
          isp-interaction-mode
          slime-repl-mode) . aggressive-indent-mode))

(setq company-format-margin-function nil)
(add-hook 'after-init-hook 'global-company-mode)

(use-package flycheck
  :diminish
  :hook (after-init . global-flycheck-mode)
  :custom
  (flycheck-check-syntax-automatically '(save mode-enabled)))

(use-package guess-language
  :config
  (setq guess-language-languages '(en pt))
  (setq guess-language-min-paragraph-length 10)
  :hook
  (text-mode . guess-language-mode))

(add-hook 'text-mode-hook 'flycheck-mode)
(add-hook 'org-mode-hook 'flycheck-mode)

(use-package company
  :diminish
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous))
  :config
  (setq company-dabbrev-other-buffers t
        company-dabbrev-code-other-buffers t)
  :hook ((prog-mode . company-mode)
         (org-mode . company-mode)
         (company-mode . yas-minor-mode)))

(use-package company-irony)

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package eldoc
  :custom (lsp-eldoc-render-all t))

(use-package yasnippet)

(setq gc-cons-threshold (* 50 1000 1000))
