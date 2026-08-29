;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Runs before init.el, before package.el and the UI are initialized.
;; Configure frame geometry before the initial graphical frame is created.

;;; Code:

(setq frame-resize-pixelwise t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;; early-init.el ends here
