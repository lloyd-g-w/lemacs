;;; evil-config.el --- Evil mode -*- lexical-binding: t; -*-

;;; Commentary:
;; Evil + companion packages, plus the SPC-leader keymap contract that all
;; other lemacs modules bind into.

;;; Code:
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo
        evil-ex-search-persistent-highlight nil) ;; lim2 sets hlsearch=false
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

(use-package undo-fu-session
  :after evil
  :config
  (setq undo-fu-session-directory
        (expand-file-name "lemacs/undo-fu-session" (or (getenv "XDG_CACHE_HOME") "~/.cache")))
  (undo-fu-session-global-mode 1))

(use-package which-key
  :ensure nil
  :config
  (which-key-mode 1))

(defvar lemacs-leader-map (make-sparse-keymap)
  "Keymap for SPC-leader bindings, mirroring lim2's <leader> maps.")

(with-eval-after-load 'evil
  (evil-define-key '(normal visual) 'global (kbd "SPC") lemacs-leader-map)

  ;; Named prefixes so which-key shows groups; other modules bind into these.
  (define-key lemacs-leader-map (kbd "c") (cons "Code" (make-sparse-keymap)))
  (define-key lemacs-leader-map (kbd "d") (cons "Diagnostics" (make-sparse-keymap)))
  (define-key lemacs-leader-map (kbd "f") (cons "Find" (make-sparse-keymap)))
  (define-key lemacs-leader-map (kbd "g") (cons "Git" (make-sparse-keymap))))

(provide 'evil-config)   ; avoid clashing with the `evil` package's own feature name
;;; evil-config.el ends here
