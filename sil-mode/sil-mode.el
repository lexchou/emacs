;;; sil-mode.el --- Major mode for the Swift intermediate language.

;; Maintainer:  Lex Chou, https://github.com/lexchou/swallow

;;; Commentary:
;; Shamelessly changed from llvm-mode.el
;; URL: https://github.com/llvm-mirror/llvm/tree/master/utils/emacs

;; Major mode for editing Swift SIL files.

;;; Code:

(defvar sil-mode-syntax-table nil
  "Syntax table used while in SIL mode.")
(defvar sil-font-lock-keywords
  (list
   ;; Comments
   '("//.*" . font-lock-comment-face)
   ;; Variables
   '("%[a-zA-Z0-9_$]+" . font-lock-variable-name-face)
   ;; Symbols
   '("@[-a-zA-Z$\._][-a-zA-Z$\._0-9]*" . font-lock-variable-name-face)
   ;; Types
   '("$[-a-zA-Z$\._][-a-zA-Z$\._0-9]*" . font-lock-type-face)
   ;; Labels
   '("[-a-zA-Z$\._0-9]+:" . font-lock-variable-name-face)
   ;; annotation
   '("\[[a-zA-Z_0-9]+\]" . font-lock-string-face)
   ;; Strings
   '("\"[^\"]+\"" . font-lock-string-face)
   ;; Integer literals
   '("\\b[-]?[0-9]+\\b" . font-lock-preprocessor-face)
   ;; Heximal constants
   '("\\b0x[0-9a-fA-F]+\\b" . font-lock-preprocessor-face)
   ;; Keywords
   `(,(regexp-opt '("sil" "sil_global" "private" "import" "sil_stage" "sil_vtable"
                    "method" "public_external" "module" "base_protocol" "sil_witness_table") 'symbols) . font-lock-keyword-face)
   ;; Instructions
   `(,(regexp-opt '("sil_global_addr" "function_ref" "metatype" "integer_literal"
                    "apply" "mark_function_escape" "tuple" "return" "debug_value"
                    "mark_uninitialized" "assign" "ref_element_addr" "alloc_ref"
                    "class_method" "strong_retain" "strong_release" "load"
                    "unchecked_ref_cast" "address_to_pointer" "alloc_box"
                    "string_literal" "alloc_array" "index_addr" "dealloc_stack"
					"alloc_stack" "struct" "struct_extract" "builtin_function_ref"
					"float_literal" "cond_br" "switch_enum" "to" "tuple_extract" "cond_fail"
					"tuple_element_addr" "copy_addr" "enum" "inject_enum_addr" "init_enum_data_addr"
					"cond_br" "switch_enum_addr" "unchecked_take_enum_data_addr" "witness_method"
					"destroy_addr" "br" "unreachable" "store" "case") 'symbols) . font-lock-keyword-face)
   )
  "Syntax highlighting for SIL."
  )

;; ---------------------- Syntax table ---------------------------
;; Shamelessly ripped from jasmin.el
;; URL: http://www.neilvandyke.org/jasmin-emacs/jasmin.el.html

(if (not sil-mode-syntax-table)
    (progn
      (setq sil-mode-syntax-table (make-syntax-table))
      (mapc (function (lambda (n)
                        (modify-syntax-entry (aref n 0)
                                             (aref n 1)
                                             sil-mode-syntax-table)))
            '(
              ;; whitespace (` ')
              [?\^m " "]
              [?\f  " "]
              [?\n  " "]
              [?\t  " "]
              [?\   " "]
              ;; word constituents (`w')
              ;;[?<  "w"]
              ;;[?>  "w"]
              [?%  "w"]
              ;;[?_  "w  "]
              ;; comments
              [?\;  "< "]
              [?\n  "> "]
              ;;[?\r  "> "]
              ;;[?\^m "> "]
              ;; symbol constituents (`_')
              ;; punctuation (`.')
              ;; open paren (`(')
              ;; close paren (`)')
              ;; string quote ('"')
              [?\" "\""]))))

;; --------------------- Abbrev table -----------------------------

(defvar sil-mode-abbrev-table nil
  "Abbrev table used while in SIL mode.")
(define-abbrev-table 'sil-mode-abbrev-table ())

(defvar sil-mode-hook nil)
(defvar sil-mode-map nil)   ; Create a mode-specific keymap.

(if (not sil-mode-map)
    ()  ; Do not change the keymap if it is already set up.
  (setq sil-mode-map (make-sparse-keymap))
  (define-key sil-mode-map "\t" 'tab-to-tab-stop)
  (define-key sil-mode-map "\es" 'center-line)
  (define-key sil-mode-map "\eS" 'center-paragraph))

;;;###autoload
(defun sil-mode ()
  "Major mode for editing Swift intermediate language source files.
\\{sil-mode-map}
  Runs `sil-mode-hook' on startup."
  (interactive)
  (kill-all-local-variables)
  (use-local-map sil-mode-map)         ; Provides the local keymap.
  (setq major-mode 'sil-mode)

  (make-local-variable 'font-lock-defaults)
  (setq major-mode 'sil-mode           ; This is how describe-mode
                                        ;   finds the doc string to print.
  mode-name "SIL"                      ; This name goes into the modeline.
  font-lock-defaults `(sil-font-lock-keywords))

  (setq local-abbrev-table sil-mode-abbrev-table)
  (set-syntax-table sil-mode-syntax-table)
  (setq comment-start "//")
  (run-hooks 'sil-mode-hook))          ; Finally, this permits the user to
                                        ;   customize the mode with a hook.

;; Associate .sil files with sil-mode
;;;###autoload
(add-to-list 'auto-mode-alist (cons (purecopy "\\.sil\\'")  'sil-mode))

(provide 'sil-mode)

;;; sil-mode.el ends here
