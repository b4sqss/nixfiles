;;; dired-git-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dired-git" "dired-git.el" (0 0 0 0))
;;; Generated autoloads from dired-git.el

(autoload 'dired-git-refresh-using-cache "dired-git" "\
Refresh git overlays using cache." t nil)

(autoload 'dired-git-status "dired-git" "\
Status with for marked directories in dired buffer." t nil)

(autoload 'dired-git-commit "dired-git" "\
Commit with MSG for marked directories in dired buffer.

\(fn MSG)" t nil)

(autoload 'dired-git-stage "dired-git" "\
Stage all for marked directories in dired buffer." t nil)

(autoload 'dired-git-unstage "dired-git" "\
Unstage all for marked directories in dired buffer." t nil)

(autoload 'dired-git-stash "dired-git" "\
Stash all for marked directories in dired buffer." t nil)

(autoload 'dired-git-stash-pop "dired-git" "\
Stash pop all for marked directories in dired buffer." t nil)

(autoload 'dired-git-reset-hard "dired-git" "\
Reset --hard all for marked directories in dired buffer." t nil)

(autoload 'dired-git-branch "dired-git" "\
Checkout to BRANCH all for marked directories in dired buffer.

\(fn BRANCH)" t nil)

(autoload 'dired-git-tag "dired-git" "\
Tag current HEAD to TAG all for marked directories in dired buffer.

\(fn TAG)" t nil)

(autoload 'dired-git-fetch "dired-git" "\
Fetch all for marked directories in dired buffer." t nil)

(autoload 'dired-git-pull "dired-git" "\
Pull for marked directories in dired buffer." t nil)

(autoload 'dired-git-merge "dired-git" "\
Merge BRANCH for marked directories in dired buffer.

\(fn BRANCH)" t nil)

(autoload 'dired-git-push "dired-git" "\
Push for marked directories in dired buffer." t nil)

(autoload 'dired-git-run "dired-git" "\
Invoke COMMAND for marked directories in dired buffer.

\(fn COMMAND)" t nil)

(autoload 'dired-git-mode "dired-git" "\
Minor mode to add git information for dired.

This is a minor mode.  If called interactively, toggle the
`Dired-git mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `dired-git-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "dired-git" '("dired-git-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dired-git-autoloads.el ends here
