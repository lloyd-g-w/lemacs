;;; lemacs-search.el --- Fuzzy finding (vertico/consult) -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity target: lim2 lua/plugins/ui.lua telescope section.  The idiomatic
;; Emacs stack for this is vertico + savehist + marginalia + consult.

;;; Code:

(defvar lemacs-leader-map)

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :config
  (define-key lemacs-leader-map (kbd "f f") #'consult-fd)
  (define-key lemacs-leader-map (kbd "f g") #'consult-ripgrep)
  (define-key lemacs-leader-map (kbd "f b") #'consult-buffer)
  (define-key lemacs-leader-map (kbd "f h") #'describe-symbol))

(provide 'lemacs-search)
;;; lemacs-search.el ends here
