;;; lemacs-completion.el --- Completion (corfu/cape/orderless) -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity target: lim2 lua/plugins/completion.lua (blink.cmp).  corfu is the
;; idiomatic Emacs analog; cape supplies extra completion-at-point sources,
;; orderless gives blink's fuzzy matching feel.

;;; Code:

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))
                                         (eglot (styles orderless)))))

(use-package corfu
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t                ;; blink shows completions as you type
        corfu-cycle t
        corfu-preselect 'prompt)    ;; nothing selected until first Tab
  (corfu-popupinfo-mode)

  (define-key corfu-map (kbd "TAB") #'corfu-next)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous)
  (define-key corfu-map (kbd "S-TAB") #'corfu-previous)
  (define-key corfu-map (kbd "C-e") #'corfu-quit)
  ;; RET only accepts an explicitly-selected candidate; otherwise falls
  ;; through to newline, mirroring blink's { "accept", "fallback" }.
  (define-key corfu-map (kbd "RET")
    '(menu-item "" corfu-insert
                :filter (lambda (cmd) (when (>= corfu--index 0) cmd)))))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; C-SPC shows completion (blink's <C-space>); only shadows set-mark while
;; in evil insert state.
(with-eval-after-load 'evil
  (evil-define-key 'insert 'global (kbd "C-SPC") #'completion-at-point))

(provide 'lemacs-completion)
;;; lemacs-completion.el ends here
