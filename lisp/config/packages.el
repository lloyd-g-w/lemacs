(setq package-user-dir (expand-file-name "elpa" "~/.cache/lemacs"))
;; or: (expand-file-name "elpa" (or (getenv "XDG_CACHE_HOME") "~/.cache"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(provide 'packages)
