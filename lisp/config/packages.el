;; Under `nix run` user-emacs-directory is a read-only store path, so
;; everything Emacs wants to WRITE must live elsewhere.  One writable
;; state dir for all of it.
(defvar lemacs-state-dir
  (expand-file-name "lemacs" (or (getenv "XDG_CACHE_HOME") "~/.cache"))
  "Writable directory for package installs and Emacs state files.")
(make-directory lemacs-state-dir t)

(setq savehist-file (expand-file-name "history" lemacs-state-dir)
      recentf-save-file (expand-file-name "recentf" lemacs-state-dir)
      transient-history-file (expand-file-name "transient/history.el" lemacs-state-dir)
      transient-levels-file (expand-file-name "transient/levels.el" lemacs-state-dir)
      transient-values-file (expand-file-name "transient/values.el" lemacs-state-dir)
      bookmark-default-file (expand-file-name "bookmarks" lemacs-state-dir)
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" lemacs-state-dir)
      custom-file (expand-file-name "custom.el" lemacs-state-dir))
(when (file-exists-p custom-file)
  (load custom-file))

(setq package-user-dir (expand-file-name "elpa" "~/.cache/lemacs"))
(setq package-quickstart-file
      (expand-file-name "package-quickstart.el" "~/.cache/lemacs"))
;; or: (expand-file-name "elpa" (or (getenv "XDG_CACHE_HOME") "~/.cache"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; MELPA rebuilds package tars continuously; a stale local archive index
;; makes installs 404 ("doom-modeline-...tar: Not found").  Refresh the
;; index when it's missing or older than a day so first-time installs of
;; newly-added packages don't hit dead links.
(let ((archive (expand-file-name "archives/melpa/archive-contents" package-user-dir)))
  (when (or (not (file-exists-p archive))
            (> (float-time (time-subtract (current-time)
                                          (file-attribute-modification-time
                                           (file-attributes archive))))
               86400))
    (ignore-errors (package-refresh-contents))))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(provide 'packages)
