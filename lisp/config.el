;;; config.el --- Aggregates core config modules -*- lexical-binding: t; -*-

;;; Commentary:
;; Add new config areas as new lisp/config/*.el files and require them
;; here.

;;; Code:

;; packages first: it bootstraps use-package, which everything after
;; (including lisp/plugins/*) depends on.
(require 'packages)
(require 'options)
(require 'keymaps)
(require 'autocmds)

(provide 'config)
;;; config.el ends here
