;;; lemacs-lsp.el --- LSP, diagnostics, formatting -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity target: lim2 lua/plugins/lsp.lua, which drives Neovim's native LSP
;; client.  Eglot is Emacs's built-in analog; flymake is its diagnostics
;; backend, apheleia is the conform.nvim analog for formatting.

;;; Code:

(defvar lemacs-leader-map)

(use-package eglot
  :ensure nil
  :hook (((c-mode c-ts-mode c++-mode c++-ts-mode) . eglot-ensure)
         ((python-mode python-ts-mode) . eglot-ensure)
         ((rust-mode rust-ts-mode) . eglot-ensure)
         (zig-mode . eglot-ensure)
         (haskell-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         (lua-mode . eglot-ensure)
         ((js-mode js-ts-mode typescript-mode typescript-ts-mode) . eglot-ensure)
         ((tex-mode latex-mode LaTeX-mode) . eglot-ensure)
         ((typst-mode typst-ts-mode) . eglot-ensure)
         ((csharp-mode csharp-ts-mode) . eglot-ensure)
         ((cmake-mode cmake-ts-mode) . eglot-ensure)
         (tuareg-mode . eglot-ensure))
  :config
  ;; Servers eglot doesn't already know about.  Mode symbols don't need to
  ;; exist for the alist entries to be harmless.
  (add-to-list 'eglot-server-programs '(nix-mode . ("nixd")))
  (add-to-list 'eglot-server-programs '((typst-mode typst-ts-mode) . ("tinymist")))

  (evil-define-key 'normal eglot-mode-map
    (kbd "gD") #'eglot-find-declaration
    (kbd "gr") #'xref-find-references
    (kbd "gi") #'eglot-find-implementation
    (kbd "K")  #'eldoc-box-help-at-point))

(use-package eldoc-box
  :after eglot)

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode))

;; Leader binds live at top level (plain define-key: the leader map is a
;; plain prefix keymap, evil state-aware bindings don't apply inside it),
;; not inside deferred use-package :config blocks — otherwise they'd only
;; appear after the first LSP attach.
(define-key lemacs-leader-map (kbd "r") (cons "Refactor" (make-sparse-keymap)))
(define-key lemacs-leader-map (kbd "r n") #'eglot-rename)
(define-key lemacs-leader-map (kbd "c a") #'eglot-code-actions)
(define-key lemacs-leader-map (kbd "d o") #'eldoc-box-help-at-point)
(define-key lemacs-leader-map (kbd "d n") #'flymake-goto-next-error)
(define-key lemacs-leader-map (kbd "d p") #'flymake-goto-prev-error)

(use-package apheleia
  :config
  ;; Only add entries apheleia lacks good defaults for; the rest (stylua,
  ;; black, prettier, jq, alejandra, rustfmt, clang-format) ship built in.
  (setf (alist-get 'yaml-mode apheleia-mode-alist) 'yq)
  (setf (alist-get 'yaml-ts-mode apheleia-mode-alist) 'yq)
  ;; ocamlformat/tuareg ship with apheleia's defaults already.
  (setf (alist-get 'tex-mode apheleia-mode-alist) 'tex-fmt)
  (setf (alist-get 'latex-mode apheleia-mode-alist) 'tex-fmt)
  (setf (alist-get 'LaTeX-mode apheleia-mode-alist) 'tex-fmt)
  (setf (alist-get 'yq apheleia-formatters) '("yq" "-P" "eval" "."))
  (setf (alist-get 'tex-fmt apheleia-formatters) '("tex-fmt" "--stdin"))

  (apheleia-global-mode +1)

  (defun lemacs-format-buffer ()
    "Format via apheleia if configured, else fall back to eglot (lsp_format=fallback parity)."
    (interactive)
    (if (alist-get major-mode apheleia-mode-alist)
        (apheleia-format-buffer (alist-get major-mode apheleia-mode-alist))
      (when (bound-and-true-p eglot--managed-mode)
        (eglot-format-buffer))))

  (define-key lemacs-leader-map (kbd "c f") #'lemacs-format-buffer))

(provide 'lemacs-lsp)
;;; lemacs-lsp.el ends here
