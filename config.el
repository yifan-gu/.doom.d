;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yifan Gu"
      user-mail-address "guyifan1121@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Monaco" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Monaco" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;


;;
;; ==== UI/UX ====
;;

(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(set-frame-parameter (selected-frame) 'alpha 100)

;; metakey for macos
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq echo-keystrokes 0.1)

(setq scroll-margin 3
      scroll-conservatively 10000)
(setq scroll-step 0)

;; move 4 line
(global-set-key "\M-n"  (lambda () (interactive) (next-line   4)) )
(global-set-key "\M-p"  (lambda () (interactive) (previous-line 4)) )

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; quick shortcut for recet open file
;; (setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; bind window move key
(global-set-key "\M-k" 'windmove-up)
(global-set-key "\M-j" 'windmove-down)
(global-set-key "\M-h" 'windmove-left)
(global-set-key "\M-l" 'windmove-right)

(global-set-key "\M-\S-k" 'buf-move-up)
(global-set-key "\M-\S-j" 'buf-move-down)
(global-set-key "\M-\S-h" 'buf-move-left)
(global-set-key "\M-\S-l" 'buf-move-right)

;; behave like vi's o command
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
  See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

(global-set-key (kbd "C-o") 'open-next-line)

;; behave like vi's O command
(defun open-previous-line (arg)
  "Open a new line before the current one.
  See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

(global-set-key (kbd "M-o") 'open-previous-line)

;; autoindent open-*-lines
(defvar newline-and-indent t
  "Modify the behavior of the open-*-line functions to cause them to autoindent.")

;; override DOOM emacs "C-a" and "C-e"
(global-set-key (kbd "C-a") 'move-beginning-of-line)
(global-set-key (kbd "C-e") 'move-end-of-line)

;; disable smartparens mode
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; open recentf in new window
(defun open-recentf-in-new-window ()
  (interactive)
  (if (= (length (window-list)) 1)
      (split-window-horizontally))
  (other-window 1)
  (recentf-open-files))

(global-set-key (kbd "C-x 4 C-r") 'open-recentf-in-new-window)

;; avy jump
;;(define-key global-map (kbd "C-c SPC") 'avy-goto-char)
(global-set-key (kbd "C-c SPC") 'avy-goto-char)


;;
;; ==== lang ====
;;

;; go mode
(gofmt-before-save)
(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key (kbd "M-*") 'pop-tag-mark)))

;; org
(setq +org-roam-open-buffer-on-find-file nil)

(defun org-open-link-in-other-window ()
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (org-open-at-point))

(defun org-meta-return-with-store-link ()
  (interactive)
  (org-meta-return)
  (org-id-store-link))

;; Create roam links for all level 1 headers.
(defun org-create-links-for-all-headers ()
  (org-map-entries (lambda () (org-id-store-link) "LEVEL=1")))

;; Create roam links for the title plus all level 1 headers.
(defun org-create-all-links ()
  (interactive)
  (beginning-of-buffer)
  (org-id-store-link)
  (org-create-links-for-all-headers))

(defun load-org-theme()
  (interactive)
  (load-theme 'doom-homage-white))

(defun load-default-theme()
  (interactive)
  (load-theme 'doom-one))

(defun org-roam-add-tag ()
  (interactive)
  (end-of-line)
  (if (equal (string (preceding-char)) ":")
      (insert ":")
    (insert " ::"))
  (backward-char))

(add-hook 'org-mode-hook
          (lambda()
            (local-set-key (kbd "C-t") 'org-roam-add-tag)
            (local-set-key (kbd "M-*") 'org-mark-ring-goto)
            (local-set-key (kbd "C-c C-j") 'org-open-at-point)
            (local-set-key (kbd "C-x 4 C-c C-j") 'org-open-link-in-other-window)
            (local-set-key (kbd "C-c <C-return>") 'org-meta-return-with-store-link)
            (load-theme 'org-leuven)))

(org-roam-db-autosync-mode)

(require 'org-bullets)
(setq org-bullets-bullet-list '(" " " " " " " " " "))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; roam-ui
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;; deft
(setq deft-directory "~/org"
      deft-default-extension "org"
      deft-use-filter-string-for-filename t
      deft-recursive t)

;; Partially fix Chinese line wrapping
(setq word-wrap-by-category t)

;; TODO
;; highlight, grammar check
;; jsonnet?
;; Remap M-n and M-p for markdown
