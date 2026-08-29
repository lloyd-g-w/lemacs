;;; lemacs-ui.el --- UI dressing -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity with lim2's lua/plugins/ui.lua (lualine, alpha, nvim-colorizer,
;; todo-comments, nvim-treesitter, mini.diff) minus telescope/oil/flash,
;; which live elsewhere (lemacs-search / lemacs-misc).

;;; Code:

;; lualine.nvim parity.
(use-package nerd-icons
  ;; One-time manual step per machine: `M-x nerd-icons-install-fonts'.
  :ensure t)

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

;; alpha-nvim parity: a start screen with recent files / project shortcuts.
;; alpha's manual buttons (new file / find file / recent / quit) are
;; covered by dashboard's own item shortcuts (jump keys per section).
(use-package dashboard
  :init
  (setq dashboard-banner-logo-title "lemacs"
        dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-display-icons-p t
        dashboard-icon-type 'nerd-icons
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        ;; project.el, not projectile (dashboard's default), supplies the
        ;; projects list — we don't install projectile.
        dashboard-projects-backend 'project-el
        dashboard-items '((recents  . 5)
                           (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; todo-comments.nvim parity — highlight TODO/FIX/HACK/... in comments.
(use-package hl-todo
  :init
  (global-hl-todo-mode 1)
  (setq hl-todo-keyword-faces
        '(("FIX"     . "#e16d77")
          ("FIXME"   . "#e16d77")
          ("BUG"     . "#e16d77")
          ("ISSUE"   . "#e16d77")
          ("TODO"    . "#68aee8")
          ("HACK"    . "#dfbe81")
          ("WARN"    . "#dfbe81")
          ("WARNING" . "#dfbe81")
          ("XXX"     . "#dfbe81")
          ("PERF"    . "#c27fd7")
          ("OPTIM"   . "#c27fd7")
          ("OPTIMIZE" . "#c27fd7")
          ("NOTE"    . "#99bc80")
          ("INFO"    . "#99bc80")
          ("TEST"    . "magenta"))))

;; nvim-colorizer.lua parity. Everywhere is noisy for general prog-mode
;; buffers, so only hook the modes where literal color codes are common.
(use-package rainbow-mode
  :hook ((css-mode scss-mode html-mode conf-mode) . rainbow-mode))

;; nvim-treesitter parity: built-in `treesit' does the highlighting,
;; treesit-auto installs grammars on demand and remaps `foo-mode' to
;; `foo-ts-mode' when a grammar is available. Compiling grammars needs a
;; C compiler — see `gcc' in emacs.nix's extraPackages.
(use-package treesit-auto
  :init
  (setq treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode 1))

;; mini.diff / gitsigns parity — sign-column diff markers against git.
(use-package diff-hl
  :init
  (global-diff-hl-mode 1)
  :hook (dired-mode . diff-hl-dired-mode)
  :config
  (add-hook 'magit-pre-refresh-hook #'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))

(provide 'lemacs-ui)
;;; lemacs-ui.el ends here
