(use-package symon
  :ensure t
  :defer 20
  :config
  (validate-setq symon-refresh-rate 5
                 symon-delay 45)
  (validate-setq symon-sparkline-type 'bounded)
  (symon-mode 1))

(use-package vlf
  :ensure t
  :config (progn
            (require 'vlf-setup)))

;; profile emacs startup time
(use-package esup
  :ensure t)

(use-package typit
  :ensure t
  :defer 20
  )

(use-package define-word
  :ensure t)

(use-package chess
  :ensure t
  :defer 20
  :commands chess
  :config
  (setq chess-images-default-size 70
        chess-images-separate-frame nil))

(use-package lorem-ipsum
  :ensure t
  :defer 20
  :commands lorem-ipsum-insert-paragraphs)

(use-package boxquote
  :ensure t
  :disabled t
  :config
  (setq-default  boxquote-bottom-corner "╰"      ; U+2570
                 boxquote-side          "│ "     ; U+2572 + space
                 boxquote-top-and-tail  "────"   ; U+2500 (×4)
                 boxquote-top-corner    "╭")     ; U+256F
  (defhydra hydra-boxquote (:color blue :hint nil)
    "
                                                                    ╭──────────┐
  Text           External           Apropos         Do              │ Boxquote │
╭───────────────────────────────────────────────────────────────────┴──────────╯
  [_r_] region        [_f_] file      [_K_] describe-key        [_t_] title
  [_p_] paragraph     [_b_] buffer    [_F_] describe-function   [_u_] unbox
  [_a_] buffer        [_s_] shell     [_V_] describe-variable   [_w_] fill-paragraph
  [_e_] text           ^ ^            [_W_] where-is            [_n_] narrow
  [_d_] defun         [_y_] yank       ^ ^                      [_c_] narrow to content
  [_q_] boxquote      [_Y_] yanked     ^ ^                      [_x_] kill
--------------------------------------------------------------------------------
       "
    ("<esc>" nil "quit")
    ("x" boxquote-kill)
    ("Y" boxquote-yank)
    ("e" boxquote-text)
    ("u" boxquote-unbox)
    ("d" boxquote-defun)
    ("t" boxquote-title)
    ("r" boxquote-region)
    ("a" boxquote-buffer)
    ("q" boxquote-boxquote)
    ("W" boxquote-where-is)
    ("p" boxquote-paragraph)
    ("f" boxquote-insert-file)
    ("K" boxquote-describe-key)
    ("s" boxquote-shell-command)
    ("b" boxquote-insert-buffer)
    ("y" boxquote-kill-ring-save)
    ("w" boxquote-fill-paragraph)
    ("F" boxquote-describe-function)
    ("V" boxquote-describe-variable)
    ("n" boxquote-narrow-to-boxquote)
    ("c" boxquote-narrow-to-boxquote-content)))

(use-package back-button
  :commands back-button-mode
  :diminish back-button-mode
  :ensure t
  :defer t
  :bind (
         ("<f2>" . back-button-push-mark-local-and-global)
         ("M-u" . back-button-global-backward)
         ("M-l" . back-button-global-forward)
         ("M-p" . back-button-local-backward)
         ("M-n" . back-button-local-forward))
  :config
  (progn
    (validate-setq back-button-show-index 'echo)
    (validate-setq back-button-show-toolbar-buttons nil)
    (validate-setq back-button-local-keystrokes nil)
    ;; (validate-setq back-button-smartrep-prefix 'nil)
    (define-key back-button-mode-map (kbd "C-x SPC") nil)
    (back-button-mode 1)))

(use-package col-highlight
  :ensure t
  :disabled t
  :config
  (set-face-background 'col-highlight "#ddd")
  (column-highlight-mode))

(use-package elpa-mirror
  :ensure t
  :commands (elpamr-create-mirror-for-installed)
  :config
  (progn
    (setq elpamr-default-output-directory "~/.emacs.d/myelpa")))

(use-package sublimity
  :ensure t
  :disabled t
  :init
  (setq sublimity-auto-hscroll-mode nil
        auto-hscroll-mode t)
  (require 'sublimity-scroll)
  ;; (require 'sublimity-map)
  ;; (setq sublimity-map-size 20)
  ;; (setq sublimity-map-fraction 0.3)
  ;; (setq sublimity-map-text-scale -7)
  :config
  (setq sublimity-auto-hscroll-mode nil
        auto-hscroll-mode t)
  (use-package sublimity-scroll
    :config
    (setq sublimity-scroll-weight 5
          sublimity-scroll-drift-length 10))
  (sublimity-mode 1))

(use-package centered-cursor-mode
  :ensure t
  :disabled t
  :config (progn
            (global-centered-cursor-mode t)
            (setq ccm-recenter-at-end-of-file t)))

;; Once icons are installed, their fonts:
;; (https://github.com/domtronn/all-the-icons.el/tree/master/fonts)
;; must be installed to system fonts and then:
;; $ sudo fc-cache -f -v
(use-package all-the-icons
  :ensure t
  :commands (all-the-icons-for-buffer all-the-icons-alltheicon))

(use-package startscreen
  :config
  (setup-startscreen-hook))

(use-package spray
  :commands spray-mode
  :ensure t
  :init
  (progn
    (defun speed-reading/start-spray ()
      "Start spray speed reading on current buffer at current point."
      (interactive)
      (spray-mode t)
      (internal-show-cursor (selected-window) nil))

    (defadvice spray-quit (after speed-reading//quit-spray activate)
      "Correctly quit spray."
      (internal-show-cursor (selected-window) t)))
  :config
  (progn
    (validate-setq spray-margin-left 20)
    (validate-setq spray-margin-top 10)

    (define-key spray-mode-map (kbd "h") 'spray-backward-word)
    (define-key spray-mode-map (kbd "l") 'spray-forward-word)
    (define-key spray-mode-map (kbd "q") 'spray-quit)))

(use-package restart-emacs
  :ensure t
  :bind* (("C-x M-c" . restart-emacs)))

(use-package auto-compile
  :demand t
  :ensure t
  :config
  (progn
    (auto-compile-on-load-mode)
    (auto-compile-on-save-mode)))

(use-package shut-up
  :ensure t
  :config
  (defun shut-up-around (function &rest args)
    (shut-up (apply function args))))

;; (advice-add 'recentf-cleanup :around 'imalison:shut-up-around)
;; (shut-up (helm-projectile-on))

(use-package xah-find
  :ensure t
  :disabled t)

(use-package stripe-buffer
  :ensure t
  :config (progn
            (add-hook 'dired-mode-hook 'turn-on-stripe-buffer-mode)
            (add-hook 'org-mode-hook 'turn-on-stripe-table-mode)
            ;; (set-face-attribute 'stripe-highlight nil :background "#38394c")
            (set-face-attribute 'stripe-highlight nil :background "#22252c")
            ))

(use-package beginend                   ; Redefine M-< and M-> for some modes
  :ensure t
  :config (beginend-global-mode)
  :diminish (beginend-global-mode
             beginend-dired-mode
             beginend-elfeed-search-mode
             beginend-ibuffer-mode
             beginend-magit-status-mode
             beginend-prog-mode
             beginend-vc-dir-mode))

(provide 'init-utils)
