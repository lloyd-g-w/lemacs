;;; init.el --- Entry point -*- lexical-binding: t; -*-

;;; Commentary:
;; Entry point for lemacs.  Adds lisp/ to the load-path and loads the
;; config and plugins aggregators.  Intentionally minimal for now.

;;; Code:

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/config" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/plugins" user-emacs-directory))

(require 'config)
(require 'plugins)

;;; init.el ends here
