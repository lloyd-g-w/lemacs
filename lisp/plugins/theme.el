;;; theme.el --- Theme configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Install Atom One Dark and enable it with the OneDark warm palette.

;;; Code:

(use-package atom-one-dark-theme
  :init
  (setq atom-one-dark-colors-alist
        '(("atom-one-dark-accent"        . "#79b7eb")
          ("atom-one-dark-fg"            . "#b1b4b9")
          ("atom-one-dark-bg"            . "#2c2d30")
          ("atom-one-dark-bg-1"          . "#191a1c")
          ("atom-one-dark-bg-hl"         . "#35373b")
          ("atom-one-dark-gutter"        . "#646568")
          ("atom-one-dark-insert"        . "#99bc80")
          ("atom-one-dark-change"        . "#dfbe81")
          ("atom-one-dark-delete"        . "#e16d77")
          ("atom-one-dark-info"          . "#68aee8")
          ("atom-one-dark-success"       . "#99bc80")
          ("atom-one-dark-warning"       . "#dfbe81")
          ("atom-one-dark-error"         . "#e16d77")
          ("atom-one-dark-mono-1"        . "#b1b4b9")
          ("atom-one-dark-mono-2"        . "#8b8d91")
          ("atom-one-dark-mono-3"        . "#646568")
          ("atom-one-dark-cyan"          . "#5fafb9")
          ("atom-one-dark-blue"          . "#68aee8")
          ("atom-one-dark-purple"        . "#c27fd7")
          ("atom-one-dark-green"         . "#99bc80")
          ("atom-one-dark-red-1"         . "#e16d77")
          ("atom-one-dark-red-2"         . "#914141")
          ("atom-one-dark-orange-1"      . "#c99a6e")
          ("atom-one-dark-orange-2"      . "#dfbe81")
          ("atom-one-dark-magenta"       . "#c27fd7")
          ("atom-one-dark-gray"          . "#3e4045")
          ("atom-one-dark-silver"        . "#8b8d91")
          ("atom-one-dark-black"         . "#242628")
          ("atom-one-dark-ui-fg"         . "#8b8d91")
          ("atom-one-dark-level-3-color" . "#242628")
          ("atom-one-dark-border"        . "#191a1c")))
  :config
  (load-theme 'atom-one-dark t))

(provide 'theme)
;;; theme.el ends here
