;;; autocmds.el --- Autocommands / hooks -*- lexical-binding: t; -*-

;;; Commentary:
;; Mirrors lim2's lua/config/autocmds.lua: spellcheck for prose-adjacent
;; filetypes (LaTeX, Typst).

;;; Code:
(add-hook 'tex-mode-hook #'flyspell-mode)
(add-hook 'latex-mode-hook #'flyspell-mode)

;; typst-ts-mode isn't necessarily installed/loaded yet; hooking a
;; not-yet-defined hook variable is harmless and fires once it is.
(add-hook 'typst-ts-mode-hook #'flyspell-mode)

(provide 'autocmds)
;;; autocmds.el ends here
