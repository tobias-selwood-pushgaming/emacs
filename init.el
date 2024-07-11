(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t)
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages
   '(elpy cmake-mode yaml-mode company ag magit counsel counsel-projectile ivy projectile org-roam))
 '(safe-local-variable-values
   '((projectile-project-test-cmd . "cmake --build build -j 16 && cd build/src/land-tech-test/ && ctest --output-on-failure")
     (projectile-project-test-cmd . "cd build/src/land-tech-test/ && ctest --output-on-failure")
     (projectile-project-run-cmd . "cd build/Debug/ && ./land-tech")
     (projectile-project-compilation-cmd . "cmake --build build -j 16"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-indentation-face ((t nil))))


;; Basic config
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(setq inhibit-startup-screen t)
(setq column-number-mode t)
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))


;; Add packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Org Mode
(add-hook 'org-mode-hook 'turn-on-flyspell)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-log-done 'time)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory  (file-truename "~/Dropbox/org-roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
)

;; Ivy
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)

;; Projectile
(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-indexing-method 'alien)

;; C++ settings
(add-hook 'c++-mode-hook
          (lambda()
            (setq tab-width 4)
	    (setq c-basic-offset 4)))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(use-package eglot :ensure t)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(eldoc-add-command 'c-electric-paren)

(global-set-key (kbd "C->") 'xref-find-definitions-other-window)
(global-set-key (kbd "C-.") 'xref-find-definitions)

;; Auto complete while typing.
(add-hook 'after-init-hook 'global-company-mode)


;; auto revert mode
(global-auto-revert-mode 1)
(add-hook 'dired-mode-hook 'auto-revert-mode)


;; Seplcheck
(add-hook 'markdown-mode-hook 'turn-on-flyspell)
(add-hook 'text-mode-hook 'turn-on-flyspell)

;; (defun risky-local-variable-p (sym &optional _ignored) nil)


;; Python. (Should look at porting to eglot.
(elpy-enable)
(define-key elpy-refactor-map (kbd "e") (cons (format "function %sxtraction"
                                                      (propertize "e" 'face 'bold))
                                              'elpy-refactor-extract-function))
(define-key elpy-refactor-map (kbd "f") (cons (format "%sormat code"
                                                      (propertize "f" 'face 'bold))
                                              'elpy-format-code))
(setq elpy-rpc-python-command "python")