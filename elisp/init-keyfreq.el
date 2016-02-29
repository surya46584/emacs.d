(use-package keyfreq
  :ensure t
  :config
  (progn
    (setq keyfreq-file      (locate-user-emacs-file "keyfreq"))
    (setq keyfreq-file-lock (locate-user-emacs-file "keyfreq.lock"))
    (keyfreq-mode 1)
    (keyfreq-autosave-mode 1)
    (setq keyfreq-excluded-commands
          '(evil-next-visual-line
            evil-previous-visual-line
            evil-insert
            evil-normal-state
            evil-forward-char
            evil-backward-char
            save-buffer
            abort-recursive-edit
            evil-next-line
            evil-previous-line
            previous-line
            next-line))

    (defun turnon-keyfreq-mode ()
      (interactive)
      (keyfreq-mode 1)
      (keyfreq-autosave-mode 1))

    (defun turnoff-keyfreq-mode ()
      (interactive)
      (keyfreq-mode -1)
      (keyfreq-autosave-mode -1))

    (defun my/keyfreq-save-html ()
      "Save the table of frequently used commands (and their associated bindings
to an html file in `user-emacs-directory'."
      (interactive)
      (keyfreq-html (locate-user-emacs-file "keyfreq.html")))

    ))

(provide 'init-keyfreq)
