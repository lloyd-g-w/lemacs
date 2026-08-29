;;; lemacs-snippets.el --- Snippets (yasnippet/laas) -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity target: lim2 lua/plugins/snippets.lua (LuaSnip + friendly-snippets,
;; plus hand-written LaTeX/Typst autosnippets).  yasnippet + yasnippet-snippets
;; is the community-collection analog; laas gives auto-activating LaTeX math
;; snippets (mk/dm/beg/bf/bb-style) without hand-porting each one.

;;; Code:

(use-package yasnippet
  :init
  (let ((local-snippets (expand-file-name "snippets" user-emacs-directory)))
    (when (file-directory-p local-snippets)
      (setq yas-snippet-dirs (list local-snippets))))
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; corfu owns TAB only inside its own popup map; yas's TAB expansion outside
;; the popup is unaffected, so no extra keymap surgery is needed here.

(use-package laas
  :hook ((LaTeX-mode latex-mode tex-mode) . laas-mode))

(provide 'lemacs-snippets)
;;; lemacs-snippets.el ends here
