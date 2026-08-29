;;; plugins.el --- Aggregates plugin modules -*- lexical-binding: t; -*-

;;; Commentary:
;; Add new plugin areas as new lisp/plugins/*.el files and require them
;; here.  Order matters: evil-config defines the leader keymap that the
;; later modules bind into.  New files are prefixed `lemacs-` so their
;; feature names can't shadow built-in or third-party features (Emacs
;; ships e.g. completion.el and misc.el).

;;; Code:

(require 'evil-config)
(require 'theme)
(require 'lemacs-completion)
(require 'lemacs-search)
(require 'lemacs-lsp)
(require 'lemacs-snippets)
(require 'lemacs-ui)
(require 'lemacs-misc)

(provide 'plugins)
;;; plugins.el ends here
