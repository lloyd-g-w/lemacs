;;; config.el --- Aggregates core config modules -*- lexical-binding: t; -*-

;;; Commentary:
;; Add new config areas as new lisp/config/*.el files and require them
;; here.

;;; Code:

(require 'options)
(require 'keymaps)
(require 'autocmds)

(provide 'config)
;;; config.el ends here
