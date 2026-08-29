;;; options.el --- Core options -*- lexical-binding: t; -*-

;;; Commentary:
;; Mirrors lim2's lua/config/options.lua where an Emacs equivalent exists.

;;; Code:
(tooltip-mode -1)
(setq window-resize-pixelwise t)
(custom-set-faces
 '(default ((t (:height 110)))))

;; Line numbers: relative, with the current line shown absolute.
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; cursorline
(global-hl-line-mode 1)

;; Indentation: spaces, not tabs.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Case-insensitive search; evil/isearch layer on smartcase when the
;; pattern contains capitals.
(setq case-fold-search t)

;; Share the kill-ring with the system clipboard.
(setq select-enable-clipboard t)

;; scrolloff 8
(setq scroll-margin 8)
(setq scroll-conservatively 101)

;; Mouse support inside a terminal.
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; Small sane defaults.
(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)

(provide 'options)
;;; options.el ends here
