;;; lemacs-snippets.el --- Snippets (yasnippet/laas) -*- lexical-binding: t; -*-

;;; Commentary:
;; Parity target: lim2 lua/plugins/snippets.lua (LuaSnip + friendly-snippets,
;; plus hand-written LaTeX/Typst autosnippets).  yasnippet + yasnippet-snippets
;; is the community-collection analog; laas gives auto-activating LaTeX math
;; snippets (mk/dm/beg/bf/bb-style) without hand-porting each one.

;;; Code:

(use-package yasnippet
  :init
  ;; yas's default dir lives inside user-emacs-directory, which is a
  ;; read-only store path under `nix run` — yas-global-mode would try to
  ;; create it and die.  Personal snippets go in a writable cache dir;
  ;; a repo-local snippets/ dir is picked up read-only when present.
  (let ((cache-snippets (expand-file-name "lemacs/snippets"
                                          (or (getenv "XDG_CACHE_HOME") "~/.cache")))
        (repo-snippets (expand-file-name "snippets" user-emacs-directory)))
    (make-directory cache-snippets t)
    (setq yas-snippet-dirs
          (delq nil (list cache-snippets
                          (and (file-directory-p repo-snippets) repo-snippets)))))
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
