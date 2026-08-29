;;; lemacs-misc.el --- Grab-bag: git, motion, filesystem, AI -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity with lim2's misc.lua/snacks.lua/mini.lua/ai.lua leftovers that
;; don't fit lemacs-ui/lemacs-search/lemacs-lsp: magit (lazygit), avy
;; (flash.nvim), dired (oil.nvim), symbol-overlay (mini.cursorword),
;; ws-butler (mini.trailspace), electric-pair (mini.pairs), gptel/copilot
;; (avante/copilot.lua). Named `lemacs-misc' rather than `misc' so it
;; can't shadow Emacs's own built-in misc.el feature.

;;; Code:

(defvar lemacs-leader-map)

;; lazygit parity — the canonical Emacs answer to "TUI git porcelain".
(use-package magit
  :init
  (define-key lemacs-leader-map (kbd "g g") #'magit-status))

;; flash.nvim parity. lim2 rebinds `f' in normal/visual/operator to
;; flash.jump, trading evil's native find-char for tree-wide jump-to-char
;; — mirror that same tradeoff here with avy.
(use-package avy
  :config
  (with-eval-after-load 'evil
    (evil-define-key '(normal visual operator) 'global "f" #'avy-goto-char-timer)))

;; oil.nvim parity — dired IS the "edit your filesystem as a buffer" UI;
;; `wdired-change-to-wdired-mode' is the oil-like "edit filenames as
;; text" superpower (bound to C-x C-q by default).
(use-package dired
  :ensure nil
  :init
  (setq dired-listing-switches "-alh")
  (define-key lemacs-leader-map (kbd "f e") #'dired-jump))

;; mini.cursorword parity — idle-highlight all occurrences of the symbol
;; at point.
(use-package symbol-overlay
  :hook (prog-mode . symbol-overlay-mode))

;; mini.trailspace parity, but polite: only trims whitespace on lines you
;; actually touched, not the whole buffer on every save.
(use-package ws-butler
  :init
  (ws-butler-global-mode 1))

;; mini.pairs parity — built-in, no package needed (the file is
;; elec-pair.el, so that's the feature name).
(use-package elec-pair
  :ensure nil
  :init
  (electric-pair-mode 1))

;; avante.nvim parity (the common Emacs chat-with-LLM package). Backends
;; and API keys are left to the user to configure separately.
(use-package gptel)

;; copilot.lua parity — installed but deliberately left off: lim2 tears
;; copilot down immediately after setup() and only turns it on via
;; `:Copilot enable'. Enable per-buffer here with `M-x copilot-mode'.
;; The bundled language server runs via `nodejs' (see emacs.nix).
(use-package copilot
  :init
  (with-eval-after-load 'copilot
    (define-key copilot-completion-map (kbd "C-f") #'copilot-accept-completion)))

(provide 'lemacs-misc)
;;; lemacs-misc.el ends here
