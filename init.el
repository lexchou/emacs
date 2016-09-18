(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(require 'yasnippet)
(yas-global-mode 1)
(tool-bar-mode 0)
(ac-config-default)
(add-hook 'after-init-hook 'global-company-mode)
;;(desktop-save-mode 1)

;;perl
(defalias 'perl-mode 'cperl-mode)

;;python
(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)

;;sql
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))


;;helm and helm-gtags
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setenv "GTAGSLIBPATH" "~/project/.gtags/")
(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-c g s") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "C-c g u") 'helm-gtags-find-rtag)
(define-key helm-gtags-mode-map (kbd "C-c g r") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "C-c g f") 'helm-imenu)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
(define-key global-map (kbd "C-c p f") 'helm-projectile)
(require 'projectile)
(define-key global-map (kbd "C-c b") 'projectile-compile-project)

(setq exec-path (append exec-path '("/usr/local/bin")))

(setq sr-speedbar-max-width 70)
(setq sr-speedbar-right-side nil)
(setq sr-speedbar-skip-other-window-p t)
;(sr-speedbar-open)

;Fix bug for iedit in Mac
(define-key global-map (kbd "C-c ;") 'iedit-mode)

;;Configure evil mode
;(add-to-list 'load-path "~/.emacs.d/evil") ; only without ELPA/el-get
;(require 'evil)
(evil-mode 1)

;;sil mode
(add-to-list 'load-path "~/.emacs.d/sil-mode")
(require 'sil-mode)

;;Configure color
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-jonadabian-slate)
(require 'rainbow-identifiers)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)

;;Configure Emacs
(global-linum-mode 1)
(setq-default
    indent-tabs-mode nil
    tab-width 4
    c-basic-offset 4)
;(set-default-font "Monaco-14")





;;Configure markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.ir\\'" . llvm-mode))


;;company mode
(require 'cc-mode)
(require 'company-c-headers)
(with-eval-after-load 'company
    (define-key c-mode-map  [(tab)] 'company-complete)
    (define-key c++-mode-map  [(tab)] 'company-complete)
    (setq company-backends (delete 'company-semantic company-backends))
    (add-to-list 'company-backends 'company-c-headers)
    (add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8/")
    )
;; code styles
(setq c-default-style "ellemtel")
(global-set-key (kbd "RET") 'newline-and-indent)
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))
;;debug
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t
 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;;c++ editor
(defun string-replace (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))
(defun cpp-get-other-file ()
  (let* ((filename (buffer-file-name))
         (ext (car (last (split-string filename "\\."))))
         )
    (if (string= "h" ext)
        (string-replace ".h" ".cpp" (string-replace "/includes/" "/src/" filename))
        (string-replace ".cpp" ".h" (string-replace "/src/" "/includes/" filename))
        )))
(defun cpp-switch-file()
    (interactive)
    (if (buffer-file-name)
        (let ((filename (cpp-get-other-file)))
          (if (file-readable-p filename)
            (find-file filename)))))
(add-hook 'c-mode-common-hook
          (lambda()
            (define-key c++-mode-map (kbd "C-c o") 'cpp-switch-file)
            (define-key c-mode-map (kbd "C-c o") 'cpp-switch-file)
            ))


;;project management



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-backends
   (quote
    (company-bbdb company-nxml company-css company-clang company-xcode company-cmake company-capf
                  (company-dabbrev-code company-gtags company-etags company-keywords)
                  company-oddmuse company-files company-dabbrev)))
 '(irony-additional-clang-options
   (quote
    ("-I/usr/local/include" "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/6.1.0/include" "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include" "-I/usr/include" "-I~/project/swallow/swallow/includes")))
 '(package-selected-packages
   (quote
    (eshell-did-you-mean eshell-git-prompt eshell-prompt-extras shader-mode yatemplate yaml-mode w3m utop tuareg term+ swift-mode sr-speedbar rainbow-identifiers rainbow-delimiters rainbow-blocks projectile-speedbar powerline-evil pos-tip php-mode perl-completion org-projectile org-ac org nginx-mode names markdown-toc markdown-mode+ llvm-mode iedit helm-projectile helm-perldoc helm-gtags helm-git helm-company graphviz-dot-mode google-c-style glsl-mode git-gutter git gh-md flymake-yaml flymake-shell flymake-php flymake-google-cpplint flymake-cursor flycheck-pyflakes flycheck-ocaml evil-smartparens epc dash-at-point css-eldoc csharp-mode cperl-mode company-irony company-c-headers cmake-font-lock auto-complete-c-headers)))
 '(safe-local-variable-values
   (quote
    ((company-c-headers-path-system "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1" "/usr/include" "/Users/lexchou/project/swallow/swallow/includes")
     (company-c-headers-path-system "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1" "/usr/include" "~/project/swallow/swallow/includes")
     (company-clang-arguments "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1" "-I/usr/include" "-I~/project/swallow/swallow/includes"))))
 '(sql-postgres-login-params
   (quote
    ((user :default "lexchou")
     password
     (server :default "10.0.0.1")
     (database :default "lexchou"))))
 '(tool-bar-mode nil)
 '(tuareg-default-indent 4)
 '(tuareg-do-indent 4)
 '(tuareg-let-indent 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "adobe" :slant normal :weight normal :height 120 :width normal)))))
