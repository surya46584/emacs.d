(use-package helm-flx
  :ensure t
  :init
  (helm-flx-mode +1))

(use-package helm
  :ensure helm-flx
  :defer t
  :diminish helm-mode
  :init
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-locate-fuzzy-match nil ;; locate fuzzy is worthless
        helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-semantic-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-lisp-fuzzy-completion t
        helm-completion-in-region-fuzzy-match t)

  :config
  (setq helm-autoresize-mode t)
  (setq helm-buffer-max-length 40)
  (helm-mode 1)
  (define-key helm-map (kbd "S-SPC") 'helm-toggle-visible-mark)
  (define-key helm-find-files-map (kbd "C-k") 'helm-find-files-up-one-level)
  )

(use-package helm-descbinds )
;; (use-package helm-mu)
(use-package helm-gtags )
(use-package helm-projectile)
(use-package helm-swoop)
(use-package helm-company
  :ensure t
  :config
  (eval-after-load 'company
    '(progn
       (define-key company-mode-map (kbd "C-:") 'helm-company)
       (define-key company-active-map (kbd "C-:") 'helm-company)))
  )

(use-package helm-ag
  :ensure helm-ag
  :commands (helm-ag helm-projectile-ag))

(use-package helm-backup
  :bind ("C-c b" . helm-backup)
  :config
  (add-hook 'after-save-hook 'helm-backup-versioning))

(provide 'init-helm)
