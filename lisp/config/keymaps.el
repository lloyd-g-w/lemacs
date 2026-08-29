;;; keymaps.el --- Global keymaps -*- lexical-binding: t; -*-

;;; Commentary:
;; Mirrors lim2's lua/config/keymaps.lua for binds not owned by a plugin
;; module.  This file loads before evil/evil-config, so anything touching
;; evil or `lemacs-leader-map' must be deferred with `with-eval-after-load'.

;;; Code:

;; Defined in lisp/plugins/evil-config.el; declare to silence the byte
;; compiler since this file loads first.
(defvar lemacs-leader-map)

;; nvim: nop S-J (join-lines-with-comment-leader is more annoying than useful).
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global "J" #'ignore))

;; tmux-navigator parity: C-h/j/k/l move between windows in normal state.
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "C-h") #'evil-window-left)
  (evil-define-key 'normal 'global (kbd "C-j") #'evil-window-down)
  (evil-define-key 'normal 'global (kbd "C-k") #'evil-window-up)
  (evil-define-key 'normal 'global (kbd "C-l") #'evil-window-right))

;; Quickfix-list parity via flymake's diagnostics buffer + next-error.
(with-eval-after-load 'evil-config
  (define-key lemacs-leader-map (kbd "c o") #'flymake-show-buffer-diagnostics)
  (define-key lemacs-leader-map (kbd "c c")
    (lambda ()
      ;; Flymake names its list buffer "*Flymake diagnostics for BUF*",
      ;; so match by major mode rather than exact buffer name.
      (interactive)
      (dolist (win (window-list))
        (when (with-current-buffer (window-buffer win)
                (derived-mode-p 'flymake-diagnostics-buffer-mode))
          (delete-window win)))))
  (define-key lemacs-leader-map (kbd "c n") #'next-error)
  (define-key lemacs-leader-map (kbd "c p") #'previous-error)

  (define-key lemacs-leader-map (kbd "?") #'which-key-show-top-level))

(provide 'keymaps)
;;; keymaps.el ends here
