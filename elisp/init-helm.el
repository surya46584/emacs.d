(use-package helm
  :ensure t
  :defer t
  :diminish helm-mode
  :init
  (setq helm-buffers-fuzzy-matching t)
  :config
  (setq helm-autoresize-mode t)
  (setq helm-buffer-max-length 40)
  (helm-mode 1)
  (define-key helm-map (kbd "S-SPC") 'helm-toggle-visible-mark)
  (define-key helm-find-files-map (kbd "C-k") 'helm-find-files-up-one-level)
  ;;(define-key helm-map (kbd "C-j") 'helm-next-line)
  ;;(define-key helm-map (kbd "C-k") 'helm-previous-line)
  )

(use-package helm-descbinds )
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


(provide 'init-helm)
