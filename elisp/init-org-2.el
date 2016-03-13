(defun my/org-mode-hook ()
  (interactive)
  (turn-on-auto-fill)
  (turn-on-flyspell)
  (when (fboundp 'yas-minor-mode)
    (yas-minor-mode 1)))

(defun set-org-mode-app-defaults ()
  (setq org-file-apps
        '(((auto-mode . emacs)
           ("\\.mm\\'" . default)
           ("\\.x?html?\\'" . system)
           ("\\.pdf\\'" . system)))))

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))
  (add-to-list 'auto-mode-alist '(".*/[0-9]*$" . org-mode)) ;; Journal entries
  (add-hook 'org-mode-hook #'hl-line-mode)
  (add-hook 'org-mode-hook #'my/org-mode-hook)
  (add-hook 'org-mode-hook
            (lambda ()
              (evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
              (auto-fill-mode)
              (org-indent-mode)))
  (add-hook 'org-mode-hook 'yas-minor-mode-on)
  (add-hook 'org-mode-hook 'company-mode)
  (add-hook 'org-mode-hook 'set-org-mode-app-defaults)

  (setq org-directory (file-truename "~/org"))
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  (setq org-replace-disputed-keys t)
  (setq org-startup-folded t)
  (setq org-startup-indented t)
  (setq org-startup-with-inline-images t)
  (setq org-startup-truncated t)

  ;; follow links by pressing ENTER on them
  (setq org-return-follows-link t)
  ;; don't adapt indentation
  (setq  org-adapt-indentation nil)
  ;; Imenu should use 3 depth instead of 2
  (setq  org-imenu-depth 3)
  ;; special begin/end of line to skip tags and stars
  (setq  org-special-ctrl-a/e t)
  ;; special keys for killing a headline
  (setq  org-special-ctrl-k t)
  ;; don't adjust subtrees that I copy
  (setq  org-yank-adjusted-subtrees nil)
  ;; try to be smart when editing hidden things
  (setq  org-catch-invisible-edits 'smart)

  (setq org-hide-leading-stars t)
  (setq org-odd-levels-only nil)
  (setq org-list-allow-alphabetical t)
  (setq org-cycle-include-plain-lists t)
  (setq org-cycle-separator-lines 0)
  (setq org-cycle-include-plain-lists t)
  (setq org-blank-before-new-entry (quote ((heading)
                                           (plain-list-item . auto))))
  (setq org-use-speed-commands t)
  (setq org-hide-emphasis-markers t)
  (setq org-reverse-note-order nil)
  (setq org-tags-column 0)
  ;; Block entries from changing state to DONE while they have children
  ;; that are not DONE
  (setq org-enforce-todo-dependencies t)
  (setq org-use-fast-todo-selection t)
  ;; put state change log messages into a drawer
  (setq org-log-into-drawer t)
  (setq org-log-done (quote time))
  (setq org-log-redeadline (quote time))
  (setq org-log-reschedule (quote time))

  ;; Org todo keywords
  (setq org-todo-keywords
        '((sequence "TODO(t)" "|" "DONE(d)")
          (sequence "TODO(t)"
                    "SOMEDAY(s)"
                    "INPROGRESS(i)"
                    "HOLD(h)"
                    "WAITING(w@/!)"
                    "NEEDSREVIEW(n@/!)"
                    "|" "DONE(d)" "CANCELLED(c@/!)")))

  ;; Org faces
  (setq org-todo-keyword-faces
        '(("TODO" :foreground "red" :weight bold)
          ("INPROGRESS" :foreground "deep sky blue" :weight bold)
          ("SOMEDAY" :foreground "purple" :weight bold)
          ("NEEDSREVIEW" :foreground "#edd400" :weight bold)
          ("DONE" :foreground "forest green" :weight bold)
          ("WAITING" :foreground "orange" :weight bold)
          ("HOLD" :foreground "magenta" :weight bold)
          ("CANCELLED" :foreground "forest green" :weight bold)))

  ;; add or remove tags on state change
  (setq org-todo-state-tags-triggers
        '(("CANCELLED" ("CANCELLED" . t))
          ("WAITING" ("WAITING" . t))
          ("HOLD" ("WAITING") ("HOLD" . t))
          (done ("WAITING") ("HOLD"))
          ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
          ("INPROGRESS" ("WAITING") ("CANCELLED") ("HOLD"))
          ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))

  ;; quick access to common tags
  (setq org-tag-alist
        '(("oss" . ?o)
          ("home" . ?h)
          ("work" . ?w)
          ("book" . ?b)
          ("support" . ?s)
          ("docs" . ?d)
          ("emacs" . ?e)
          ("noexport" . ?n)
          ("recurring" . ?r)))

  ;; refile targets all level 1 and 2 headers in current file and agenda files
  (setq org-refile-targets '((nil :maxlevel . 2)
                             (org-agenda-files :maxlevel . 2)))
  (setq org-refile-use-outline-path 'file)

  (require 'ox-org)
  (require 'ox-md)

  (add-to-list 'org-modules 'org-habit)

  (setq org-habit-graph-column 60)

  (add-to-list 'org-structure-template-alist
               '("E" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC\n"))
  (add-to-list 'org-structure-template-alist
               '("S" "#+BEGIN_SRC shell-script\n?\n#+END_SRC\n"))

  ;; Don't use the same TODO state as the current heading for new heading
  (defun my-org-insert-todo-heading ()
    (interactive)
    (org-insert-todo-heading t))
  (define-key org-mode-map (kbd "<M-S-return>") 'my-org-insert-todo-heading)

  (defun meeting-notes ()
    "Call this after creating an org-mode heading for where the notes for the meeting
     should be. After calling this function, call 'meeting-done' to reset the environment."
    (interactive)
    (outline-mark-subtree) ;; Select org-mode section
    (narrow-to-region (region-beginning) (region-end)) ;; Only show that region
    (deactivate-mark)
    (delete-other-windows) ;; Get rid of other windows
    (text-scale-set 2)     ;; Text is now readable by others
    (fringe-mode 0)
    (message "When finished taking your notes, run meeting-done."))

  (defun meeting-done ()
    "Attempt to 'undo' the effects of taking meeting notes."
    (interactive)
    (widen)            ;; Opposite of narrow-to-region
    (text-scale-set 0) ;; Reset the font size increase
    (fringe-mode 1)
    (winner-undo))

  (defun org-text-bold () "Wraps the region with asterisks."
         (interactive)
         (surround-text "*"))
  (defun org-text-italics () "Wraps the region with slashes."
         (interactive)
         (surround-text "/"))
  (defun org-text-code () "Wraps the region with equal signs."
         (interactive)
         (surround-text "="))

  (use-package org-src
    :config
    ;; Let's have pretty source code blocks
    (setq org-edit-src-content-indentation 0
          org-src-tab-acts-natively t
          org-src-fontify-natively t
          org-confirm-babel-evaluate nil)
    (setq org-src-tab-acts-natively t)
    ;; preserve the indentation inside of source blocks
    (setq org-src-preserve-indentation t)
    (setq org-confirm-babel-evaluate nil)
    ;; how org-src windows are set up when hitting C-c '
    (setq org-src-window-setup 'current-window)
    ;; blank lines are removed when exiting the code edit buffer
    (setq org-src-strip-leading-and-trailing-blank-lines t)
    (setq org-src-fontify-natively t)
    )

  (use-package org
    :config
    (setq org-html-postamble nil)
    (setq org-export-with-section-numbers nil)
    (setq org-export-coding-system 'utf-8)
    (setq org-export-with-toc nil)
    (setq org-export-with-timestamps nil)
    (setq org-html-head-extra "
     <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,400italic,700italic&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
     <link href='http://fonts.googleapis.com/css?family=Source+Code+Pro:400,700' rel='stylesheet' type='text/css'>
     <style type='text/css'>
        body {
           font-family: 'Source Sans Pro', sans-serif;
        }
        pre, code {
           font-family: 'Source Code Pro', monospace;
        }
     </style>")

    (defun my/org-inline-css-hook (exporter)
      "Insert custom inline css to automatically set the
   background of code to whatever theme I'm using's background"
      (when (eq exporter 'html)
        (let* ((my-pre-bg (face-background 'default))
               (my-pre-fg (face-foreground 'default)))
          ;;(setq org-html-head-include-default-style nil)
          (setq
           org-html-head-extra
           (concat
            org-html-head-extra
            (format
             "<style type=\"text/css\">\n pre.src {background-color: %s; color: %s;}</style>\n"
             my-pre-bg my-pre-fg))))))

    ;; (add-hook 'org-export-before-processing-hook #'my/org-inline-css-hook)

    )

  (use-package org-indent
    :init)
  (use-package org-table
    :init)
  (use-package org-install)
  (use-package ob-core)
  ;; org-export
  (use-package ox)
  ;; Enable archiving things
  (use-package org-archive)

  (use-package org
    :ensure t
    :config
    (progn
      (setq org-startup-indented t)
      (setq org-latex-pdf-process
            '("latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))
      (evil-leader/set-key-for-mode 'org-mode
        "m E" 'org-export-dispatch
        "m p l" 'org-preview-latex-fragment
        "m p i" 'org-toggle-inline-images))
    (progn
      (org-load-modules-maybe)))

  ;; org-agenda
  (use-package org-agenda
    :config
    (progn
      (setq org-agenda-start-with-log-mode t)
      (setq org-agenda-dim-blocked-tasks t)
      ;;(setqorg-agenda-todo-ignore-scheduled'future);don'tshowfuturescheduled
      ;;(setqorg-agenda-todo-ignore-deadlines'far);showonlyneardeadlines
      (setq org-agenda-include-all-todo t)
      (setq org-agenda-include-diary t)
      ;;(setqorg-agenda-ndays7)
      (setq org-agenda-show-all-dates t)
      (setq org-agenda-skip-deadline-if-done t)
      (setq org-agenda-skip-scheduled-if-done t)
      ;;addstatetothesortingstrategyoftodo
      (setcdr (assq 'todo org-agenda-sorting-strategy)
              '(todo-state-up priority-down category-keep))
      (setq
       ;; Sorting order for tasks on the agenda
       org-agenda-sorting-strategy
       '((agenda habit-down
                 time-up
                 priority-down
                 user-defined-up
                 effort-up
                 category-keep)
         (todo priority-down category-up effort-up)
         (tags priority-down category-up effort-up)
         (search priority-down category-up))

       ;; Enable display of the time grid so we can see the marker for the
       ;; current time
       org-agenda-time-grid
       '((daily today remove-match)
         #("----------------" 0 16 (org-heading t))
         (0900 1100 1300 1500 1700))
       ;; keep the agenda filter until manually removed
       org-agenda-persistent-filter t
       ;; show all occurrences of repeating tasks
       org-agenda-repeating-timestamp-show-all t
       ;; always start the agenda on today
       org-agenda-start-on-weekday nil
       ;; Use sticky agenda's so they persist
       org-agenda-sticky t
       ;; show 4 agenda days
       org-agenda-span 4
       ;; Do not dim blocked tasks
       org-agenda-dim-blocked-tasks nil
       ;; Compact the block agenda view
       org-agenda-compact-blocks t
       ;; Show all agenda dates - even if they are empty
       org-agenda-show-all-dates t
       ;; Agenda org-mode files
       org-agenda-files `(,(file-truename "~/org/refile.org")
                          ,(file-truename "~/org/todo.org")
                          ,(file-truename "~/org/bibliography.org")
                          ,(file-truename "~/org/notes.org")
                          ,(file-truename "~/org/journal.org")))

      ;;Custom agenda command definitions
      (setq org-agenda-custom-commands
            '(("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              (" " "Agenda"
               ((agenda "" nil)
                ;; All items with the "REFILE" tag, everything in refile.org
                ;; automatically gets that applied
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                ;; All "INPROGRESS" todo items
                (todo "INPROGRESS"
                      ((org-agenda-overriding-header "Current work")))
                ;; All headings with the "support" tag
                (tags "support/!"
                      ((org-agenda-overriding-header "Support cases")))
                ;; All "NEESREVIEW" todo items
                (todo "NEEDSREVIEW"
                      ((org-agenda-overriding-header "Waiting on reviews")))
                ;; All "WAITING" items without a "support" tag
                (tags "WAITING-support"
                      ((org-agenda-overriding-header "Waiting for something")))
                ;; All TODO items
                (todo "TODO"
                      ((org-agenda-overriding-header "Task list")
                       (org-agenda-sorting-strategy
                        '(time-up priority-down category-keep))))
                ;; Everything on hold
                (todo "HOLD"
                      ((org-agenda-overriding-header "On-hold")))
                ;; All headings with the "recurring" tag
                (tags "recurring/!"
                      ((org-agenda-overriding-header "Recurring"))))
               nil)))

      ;;add new appointments when saving the org buffer, use'refresh argument todo it properly
      (defun my-org-agenda-to-appt-refresh () (org-agenda-to-appt 'refresh))
      (defun my-org-mode-hook ()
        (add-hook 'after-save-hook 'my-org-agenda-to-appt-refresh nil 'make-it-local))
      (add-hook 'org-mode-hook 'my-org-mode-hook)

      (defun my/save-all-agenda-buffers ()
        "Function used to save all agenda buffers that are
         currently open, based on `org-agenda-files'."
        (interactive)
        (save-current-buffer
          (dolist (buffer (buffer-list t))
            (set-buffer buffer)
            (when (member (buffer-file-name)
                          (mapcar 'expand-file-name (org-agenda-files t)))
              (save-buffer)))))

      ;; save all the agenda files after each capture
      (add-hook 'org-capture-after-finalize-hook 'my/save-all-agenda-buffers)
      ))
  )

;; org-capture
(use-package org
  :config
  ;; capture templates
  (setq org-capture-templates
        '(("t" "Todo" entry (file "~/org/refile.org")
           "* TODO %?\n%U\n")
          ("m" "Email" entry (file "~/org/refile.org")
           "* TODO [#B] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
          ("n" "Notes" entry (file+headline "~/org/notes.org" "Notes")
           "* %? :NOTE:\n%U\n")
          ;;capture bookmarks
          ("b" "Bookmark" plain (file "~/notes/bookmarks.org" "Bookmarks"))
          ("e" "Emacs note" entry
           (file+headline "~/org/notes.org" "Emacs Links")
           "* %? :NOTE:\n%U\n")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\n%U\n")
          ("B" "Book/Bibliography" entry
           (file+headline "~/org/bibliography.org" "Refile")
           "* %?%^{TITLE}p%^{AUTHOR}p%^{TYPE}p")))

  (add-hook 'org-capture-mode-hook
            (lambda ()
              (evil-insert-state)))
  )

(use-package org-journal
  :ensure t
  :config
  (progn
    (evil-leader/set-key
      "+" 'org-journal-new-entry
      "=" '(lambda () (interactive) (org-journal-new-entry t)))
    (which-key-add-key-based-replacements
      "SPC +" "Add entry to journal"
      "SPC =" "View today's journal")
    (setq org-journal-dir (expand-file-name "~/journal/")
          org-journal-file-format "%Y-%m-%d.org"
          org-journal-date-format "%A, %d-%m-%Y"
          org-journal-enable-encryption nil)
    (evil-leader/set-key-for-mode 'calendar-mode
      "m j j" 'org-journal-read-entry
      "m j i" 'org-journal-new-date-entry
      "m j [" 'org-journal-previous-entry
      "m j ]" 'org-journal-next-entry
      "m j f f" 'org-journal-search-forever
      "m j f m" 'org-journal-search-calendar-month
      "m j f w" 'org-journal-search-calender-week
      "m j f y" 'org-journal-search-calendar-year)
    (evil-leader/set-key-for-mode 'org-journal-mode
      "m j [" 'org-journal-open-previous-entry
      "m j ]" 'org-journal-open-next-entry))
  (defun get-journal-file-today ()
    "Return filename for today's journal entry."
    (let ((daily-name (format-time-string "%Y%m%d")))
      (expand-file-name (concat org-journal-dir daily-name))))

  (defun journal-file-today ()
    "Create and load a journal file based on today's date."
    (interactive)
    (find-file (get-journal-file-today)))

  (defun get-journal-file-yesterday ()
    "Return filename for yesterday's journal entry."
    (let ((daily-name (format-time-string "%Y%m%d" (time-subtract (current-time) (days-to-time 1)))))
      (expand-file-name (concat org-journal-dir daily-name))))

  (defun journal-file-yesterday ()
    "Creates and load a file based on yesterday's date."
    (interactive)
    (find-file (get-journal-file-yesterday)))
  )



(use-package org-research
  :disabled t
  :config
  (progn
    (setq org-research-root "~/research")
    (evil-leader/set-key-for-mode 'org-research-mode
      "m r o" 'org-research-open-paper
      "m r a" 'org-research-add-reference)))


(use-package org-pomodoro
  :commands (org-pomodoro)
  :ensure t
  :config
  (setq pomodoro-break-time 2)
  (setq pomodoro-long-break-time 5)
  (setq pomodoro-work-time 15)
  ;; (setq-default mode-line-format
  ;;               (cons '(pomodoro-mode-line-string pomodoro-mode-line-string)
  ;;                     mode-line-format))
  )

(use-package notifications
  :config
  (defun my-appt-disp-window-function (min-to-app new-time msg)
    (notifications-notify :title (format "Appointment in %s min" min-to-app) :body msg))
  (setq appt-disp-window-function 'my-appt-disp-window-function)
  (setq appt-delete-window-function (lambda (&rest args))))

;; org-clock
(use-package org-clock
  :config
  (setq org-clock-idle-time 15)
  (setq org-clock-in-resume t)
  (setq org-clock-persist t)
  (setq org-clock-persist-query-resume nil)
  (setq org-clock-clocked-in-display 'both)
  (setq org-clock-frame-title-format
        (append '((t org-mode-line-string)) '(" ") frame-title-format))
  (setq org-clock-history-length 23
        ;; Resume clocking task on clock-in if the clock is open
        org-clock-in-resume t
        ;; Separate drawers for clocking and logs
        org-drawers '("PROPERTIES" "CLOCK" "LOGBOOK" "RESULTS" "HIDDEN")
        ;; Save clock data and state changes and notes in the LOGBOOK drawer
        org-clock-into-drawer t
        ;; Sometimes I change tasks I'm clocking quickly -
        ;; this removes clocked tasks with 0:00 duration
        org-clock-out-remove-zero-time-clocks t
        ;; Clock out when moving task to a done state
        org-clock-out-when-done t
        ;; Save the running clock and all clock history when exiting Emacs, load it on startup
        org-clock-persist t
        ;; Prompt to resume an active clock
        org-clock-persist-query-resume t
        ;; Enable auto clock resolution for finding open clocks
        org-clock-auto-clock-resolution #'when-no-clock-is-running
        ;; Include current clocking task in clock reports
        org-clock-report-include-clocking-task t
        ;; don't use pretty things for the clocktable
        org-pretty-entities nil
        ;; some default parameters for the clock report
        org-agenda-clockreport-parameter-plist
        '(:maxlevel 10 :fileskip0 t :score agenda :block thismonth :compact t :narrow 60))
  (when (executable-find "xprintidle")
    (setq org-x11idle-exists-p t)
    (setq org-clock-x11idle-program-name "xprintidle"))
  (org-clock-persistence-insinuate))

;; ob-clojure
(use-package ob-clojure
  :config
  (setq org-babel-clojure-backend 'cider)
  ;; Clojure-specific org-babel stuff
  (defvar org-babel-default-header-args:clojure
    '((:results . "silent")))
  (defun org-babel-execute:clojure (body params)
    "Execute a block of Clojure code with Babel."
    (let ((result-plist
           (nrepl-send-string-sync
            (org-babel-expand-body:clojure body params) nrepl-buffer-ns))
          (result-type  (cdr (assoc :result-type params))))
      (org-babel-script-escape
       (cond ((eq result-type 'value) (plist-get result-plist :value))
             ((eq result-type 'output) (plist-get result-plist :value))
             (t (message "Unknown :results type!"))))))
  )

(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh         . t)
     (js         . t)
     (emacs-lisp . t)
     (perl       . t)
     (scala      . t)
     (clojure    . t)
     (python     . t)
     (ruby       . t)
     (dot        . t)
     (css        . t)
     (plantuml   . t)))

  ;;thisiswhereFedorainstallsit,YMMV
  (setq org-plantuml-jar-path "/usr/share/java/plantuml.jar")
  ;;ensurethisvariableisdefined
  (unless (boundp 'org-babel-default-header-args:sh)
    (setq org-babel-default-header-args:sh '()))

  ;;addadefaultshebangheaderargumentshellscripts
  (add-to-list 'org-babel-default-header-args:sh
               '(:shebang . "#!/usr/bin/env bash"))

  ;;addadefaultshebangheaderargumentforpython
  (add-to-list 'org-babel-default-header-args:python
               '(:shebang . "#!/usr/bin/env python")))

(use-package ox-latex
  :config
  (setq org-latex-listings 'minted)
  (setq org-latex-pdf-process
        '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (add-to-list 'org-latex-packages-alist '("" "minted")))

(use-package ox-reveal
  :disabled t
  :config
  (setq org-reveal-root (concat "file://" (getenv "HOME") "/Public/js/reveal.js"))
  (setq org-reveal-postamble "ox reveal presentation"))

(use-package org-present
  :disabled t
  :defer 20
  :config
  (add-hook 'org-present-mode-hook
            (lambda ()
              (org-present-big)
              (org-display-inline-images)
              (org-present-hide-cursor)
              (org-present-read-only)))
  (add-hook 'org-present-mode-quit-hook
            (lambda ()
              (org-present-small)
              (org-remove-inline-images)
              (org-present-show-cursor)
              (org-present-read-write))))

(use-package org-mobile
  :disabled t
  :config
  (progn
    (setq org-mobile-directory "~/Documents/mobileorg"
          org-mobile-files (list
                            "~/Documents/org"
                            "~/Documents/Work/org")
          org-mobile-inbox-for-pull "~/Documents/org/inbox.org")
    ))

(use-package org-crypt
  :commands (org-decrypt-entries
             org-encrypt-entries
             org-crypt-use-before-save-magic)
  :config
  (progn
    ;; GPG key to use for encryption
    ;; Either the Key ID or set to nil to use symmetric encryption.
    (setq org-crypt-key nil)
    )
  (progn
    (org-crypt-use-before-save-magic)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))
    ))

(use-package org-protocol)


(provide 'init-org-2)
