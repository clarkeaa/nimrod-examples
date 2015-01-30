;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is a simple nim language emacs major mode, not 100% functional but good 
;; enough for some cases.  I'd recommend using someone else's.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq nim-keywords
 '(("^proc\\|[^a-zA-Z]proc\\|var\\|type\\|ref\\|object\\|generic\\|^import\\| import \\|from\\|let\\|if\\|for\\|return\\|else\\| in \\|elif\\|while\\|echo" . font-lock-keyword-face)
   ("[0-9]+" . font-lock-constant-face)
   ("proc \\([a-zA-Z]+\\)" 1 font-lock-function-name-face)
   ("[^a-zA-Z]\\(int\\)" 1 font-lock-type-face)
   ("[^a-zA-Z]\\(string\\)" 1 font-lock-type-face)
   ("type[ ]+\\([a-zA-Z]+\\)" 1 font-lock-type-face)
   ("var \\([a-zA-Z]+\\)" 1 font-lock-variable-name-face)
   ("^[ ]+\\([a-zA-Z]+\\)[ ]+=" 1 font-lock-variable-name-face)
   ("{[.]\\|[.]}" . font-lock-preprocessor-face)
   ("\\([a-zA-Z]+\\)[ ]+:[ ]+[a-zA-Z]+[ ]+=" 1 font-lock-variable-name-face)
  )
)

(define-derived-mode nim-mode python-mode
  (setq font-lock-defaults '(nim-keywords))
  (setq mode-name "nim lang")
)

(provide 'nim-mode)
