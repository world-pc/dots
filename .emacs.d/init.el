;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(go-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun my/unspecified-bg (&rest _)
  (set-face-background 'default "unspecified-bg" nil)
  (set-face-background 'fringe "unspecified-bg" nil))

(advice-add 'load-theme :after #'my/unspecified-bg)

(load-theme 'misterioso t)

;; get rid of the menu bar
(menu-bar-mode -1)

;; building go source
(defun my/go-build-current-file ()
  "Build the current Go file with go build."
  (interactive)
  (compile (concat "go build " (shell-quote-argument buffer-file-name))))

(global-set-key (kbd "C-c b") #'my/go-build-current-file)

;; running built go source
(defun my/go-run-current-file ()
  "Run the built current Go file with go run."
  (interactive)
  (compile (concat "go run " (shell-quote-argument buffer-file-name))))

(global-set-key (kbd "C-c x") #'my/go-build-current-file)
