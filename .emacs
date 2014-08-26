;****************************************
;utils 
;(Copyright © 2014 - Bozhidar Batsov)
;****************************************
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(global-set-key (kbd "C-x C-r") 'sudo-edit)

; ****************************************
; general 
; ****************************************
(setenv "LANG" "C.UTF-8")
(global-set-key "\M-n" 'next-buffer)
(global-set-key "\M-p" 'previous-buffer)
(global-set-key (kbd "<f2> RET") 'make-frame-command)

;navigation
(global-set-key (kbd "<S-s-iso-lefttab>") 'other-window)

;org-mode
(global-set-key (kbd "<s-f1>") 'org-mobile-push)

; programming
(global-set-key (kbd "C-{") 'comment-region)
(global-set-key (kbd "C-}") 'uncomment-region)


; FONT
;(set-default-font "-unknown-Inconsolata-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
;(set-default-font "-microsoft-Consolas-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")

; avoid backup (~) temp file
(setq make-backup-files nil)

; enable clipboard
(setq x-select-enable-clipboard t )

;; ***************************************
;; color-theme (make emacs look better)
;; ****************************************
(add-to-list 'load-path "~/.emacs.d/common/color-theme-6.6.0")
(load "~/.emacs.d/color-theme-tomorrow-night.el")
(load "~/.emacs.d/common/color-theme-6.6.0/themes/color-theme-solarized.el")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-kmels)))

;; ****************************************
;; org-mode 
;; ****************************************
(setq load-path (cons "~/.emacs.d/common/org-7.8.03/lisp/" load-path))
(setq load-path (cons "~/.emacs.d/common/org-7.8.03/contrib/lisp/" load-path))
    
(require 'org)
(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(transient-mark-mode 1)

; automatically org-mobile-push on save of a file
(add-hook 
 'after-save-hook 
 (lambda ()
   (let (
         (org-filenames (mapcar 'file-name-nondirectory org-agenda-files)) ; list of org file names (not paths)
         (filename (file-name-nondirectory buffer-file-name)) ; list of the buffers filename (not path)
         )
     (if (find filename org-filenames :test #'string=)
         (org-mobile-push)        
       )
     )
   )
)


;; Location of org files
(setq org-directory "~/Dropbox/org")
;; MobileOrg, where to pull new notes
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; MobileOrg, what to push
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; ****************************************
;; ledger (accounting)
;; ****************************************
(defun ledger-add-entry (title in amount out)
      (interactive
       (let ((accounts (mapcar 'list (ledger-accounts))))
         (list (read-string "Entry: " (format-time-string "%Y-%m-%d " (current-time)))
               (let ((completion-regexp-list "^Ausgaben:"))
                 (completing-read "What did you pay for? " accounts))
               (read-string "How much did you pay? " "Q ")
               (let ((completion-regexp-list "^VermÃ¶gen:"))
                 (completing-read "Where did the money come from? " accounts)))))
      (insert title)
      (newline)
      (indent-to 4)
      (insert in "  " amount)
      (newline)
      (indent-to 4)
      (insert out))


; ****************************************
; scala-mode (DEACTIVATED)
; ****************************************
; (add-to-list 'load-path (expand-file-name "~/.emacs.d/prog-lang/scala-mode"))
; (load "scala-mode-auto.el")

; (require 'scala-mode-auto)

; (add-hook 'scala-mode-hook
;           '(lambda ()
;              (yas/minor-mode-on)))

;****************************************
; MELPA (Milkypostman’s Emacs Lisp Package Archive)
;****************************************
(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

; ****************************************
; ensime
; ****************************************

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

; 
;; ;****************************************
;; ; Nxhtml-mode (DEACTIVATED)
;; ;****************************************
; (load "~/.emacs.d/webdev/nxhtml/autostart.el")
 ;;(setq mumamo-background-colors nil) 
; (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))

;; ;****************************************
;; ; Espresso mode for javascript (DEACTIVATED)
;; ;****************************************
;(load "~/.emacs.d/webdev/espresso.el")
;(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
;(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
;(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;; ****************************************
;; haskell-mode, ghc-mod, stylish-haskell
;; https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md 
;; ****************************************
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;(add-hook 'haskell-mode-hook 'structured-haskell-mode)

(eval-after-load 'haskell-mode
          '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))
(setenv "PATH" (concat "~/.cabal/bin:" (getenv "PATH")))
(add-to-list 'exec-path "~/.cabal/bin")
(custom-set-variables '(haskell-tags-on-save t))

(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t))

(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-ode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(custom-set-variables '(haskell-process-type 'cabal-repl))

;; initialize ghc-mod when opening haskell files
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; haskell autocompletion
(require 'company)
(add-hook 'haskell-mode-hook 'company-mode)
(add-to-list 'company-backends 'company-ghc)
(custom-set-variables '(company-ghc-show-info t))

;; The first one is rainbow-delimiters. Its goal is very simple: show each level of parenthesis or braces in a different color. In that way, you can easily spot until from point some expression scopes. Furthermore, if the delimiters do not match, the extra ones are shown in a warning, red col
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;NOTE: the three indendation modules are mutually exclusive (at most 1 can be used).

; ****************************************
; r-mode, http://ess.r-project.org (DEACTIVATED)
; ****************************************
;(add-to-list 'load-path "~/.emacs.d/statistics/ess-5.14/lisp")
;(require 'ess-site)

;****************************************
; octave-mode (DEACTIVATED)
;****************************************
;(autoload 'octave-mode "octave-mod" nil t)
;(setq auto-mode-alist
;      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;****************************************
; Set 4 Space Indent http://stackoverflow.com/questions/69934/set-4-space-indent-in-emacs-in-text-mode
;****************************************
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;****************************************
; custom variables
;****************************************
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Dropbox/org/rezepte.org" "~/code/tautologer/doc/reduced-sentences-list.org" "~/Dropbox/org/dudas-aleman.org" "~/Dropbox/org/comprar.org" "~/Dropbox/org/kmels.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;****************************************
; tools
;****************************************
(defun count-words (start end)
    "Print number of words in the region."
    (interactive "r")
    (save-excursion
      (save-restriction
        (narrow-to-region start end)
        (goto-char (point-min))
        (count-matches "\\sw+"))))

;****************************************
;autocomplete
;****************************************
;(add-to-list 'load-path "~/.emacs.d/")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
;(ac-config-default)

;****************************************
; hamlet-mode
;****************************************
;(add-to-list 'load-path "~/.emacs.d/meta-lang/hamlet-mode.el")
;(require 'hamlet-mode)


;****************************************
;markdown-mode
;****************************************
(add-to-list 'load-path "~/.emacs.d/meta-lang/markdown-mode.el")
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;****************************************
;php
;****************************************
(add-to-list 'load-path "/home/kmels/.emacs.d/prog-lang/")
(require 'php-mode)

