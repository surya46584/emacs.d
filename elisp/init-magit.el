(use-package magit
  :ensure t
  :commands (magit-status
             magit-log
             magit-commit
             magit-stage-file)
  :config
  (progn
    (add-hook 'magit-mode-hook 'xah-fly-insert-mode-activate)
    (add-hook 'magit-status-mode-hook 'xah-fly-insert-mode-activate)

    (dolist (map (list magit-status-mode-map
                       magit-log-mode-map
                       magit-diff-mode-map
                       magit-staged-section-map))
      (define-key map "j" 'magit-section-forward)
      (define-key map "k" 'magit-section-backward)
      (define-key map "n" nil)
      (define-key map "p" nil)
      (define-key map "v" 'recenter-top-bottom)
      (define-key map "i" 'magit-section-toggle))

    (eval-after-load 'magit-blame
      '(progn
         (define-key magit-blame-mode-map "n" nil)
         (define-key magit-blame-mode-map "p" nil)
         (define-key magit-blame-mode-map "j" 'magit-blame-next-chunk)
         (define-key magit-blame-mode-map "k" 'magit-blame-previous-chunk)))

    (define-key magit-refs-mode-map "j" 'magit-section-forward)
    (define-key magit-refs-mode-map "k" 'magit-section-backward)
    (define-key magit-refs-mode-map "i" 'magit-section-toggle)

    (ora-move-key "k" "C-k" magit-file-section-map)
    (ora-move-key "k" "C-k" magit-untracked-section-map)
    (ora-move-key "k" "C-k" magit-tag-section-map)
    (ora-move-key "k" "C-k" magit-stash-section-map)
    (ora-move-key "k" "C-k" magit-stashes-section-map)
    (ora-move-key "k" "C-k" magit-unstaged-section-map)
    (ora-move-key "k" "C-k" magit-hunk-section-map)
    (ora-move-key "k" "C-k" magit-branch-section-map)
    (ora-move-key "<C-tab>" nil magit-log-mode-map)
    (ora-move-key "<C-tab>" nil magit-revision-mode-map)
    (ora-move-key "<C-tab>" nil magit-status-mode-map)
    (define-key magit-hunk-section-map (kbd "RET") 'magit-diff-visit-file-worktree)
    (define-key magit-status-mode-map (kbd "M-m") 'lispy-mark-symbol)
    (define-key magit-mode-map "q" '(lambda () (interactive)
                                      (progn
                                        (quit-window)
                                        (xah-fly-command-mode-activate))))

    (csetq magit-status-sections-hook
           '(magit-insert-status-headers
             magit-insert-merge-log
             magit-insert-rebase-sequence
             magit-insert-am-sequence
             magit-insert-sequencer-sequence
             magit-insert-bisect-output
             magit-insert-bisect-rest
             magit-insert-bisect-log
             magit-insert-stashes
             magit-insert-untracked-files
             magit-insert-unstaged-changes
             magit-insert-staged-changes
             magit-insert-unpulled-from-upstream
             magit-insert-unpushed-to-upstream))

    (validate-setq magit-status-headers-hook
                   '(magit-insert-repo-header
                     magit-insert-remote-header
                     ;; magit-insert-head-headers
                     magit-insert-tags-header))

    ;; Use Ivy
    (validate-setq magit-completing-read-function 'ivy-completing-read)

    (defun magit-set-repo-dirs-from-projectile ()
      "Set `magit-repository-directories' with known Projectile projects."
      (setq magit-repository-directories
            (mapcar
             (lambda (dir)
               (substring dir 0 -1))
             (cl-remove-if-not
              (lambda (project)
                (unless (file-remote-p project)
                  (file-directory-p (concat project "/.git/"))))
              (projectile-relevant-known-projects)))))

    (with-eval-after-load 'projectile
      (magit-set-repo-dirs-from-projectile))

    (add-hook 'projectile-switch-project-hook
              #'magit-set-repo-dirs-from-projectile)

    (add-to-list 'magit-repository-directories (concat "/Users/" (getenv "USER") "/Projects/"))
    (add-to-list 'magit-repository-directories "~/.emacs.d")
    (add-to-list 'magit-repository-directories "~/.dotfiles")
    ;; ;;* Maps
    ;; magit-status-mode-map
    ;; magit-log-mode-map
    ;; magit-commit-mode-map
    ;; magit-diff-mode-map

    ))

(provide 'init-magit)
