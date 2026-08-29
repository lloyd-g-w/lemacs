;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Runs before init.el, before package.el and the UI are initialized.
;; Configure frame geometry before the initial graphical frame is created.

;;; Code:

;; Native-comp writes .eln files under user-emacs-directory by default,
;; which is a read-only store path under `nix run` — redirect early,
;; before any compilation is queued.
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "lemacs/eln-cache"
                     (or (getenv "XDG_CACHE_HOME") "~/.cache"))))

(setq frame-resize-pixelwise t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;; early-init.el ends here
