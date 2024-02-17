;;simple pretty printer for sexp's
(import scheme (chicken pretty-print) (chicken process-context))

(define (copy-line-comment)
  (let ((char (read-char)))
    (if (not (eof-object? char))
      (if (eq? char #\newline)
        (newline)
        (begin (write-char char) (copy-line-comment))))))

(define (maintain-empty-lines)
  (let ((char1 (read-char)) (char2 (peek-char)))
    (if (and (eq? char1 #\newline) (eq? char2 #\newline))
      (write-char (read-char)))))

;; The main method. This reads from and writes to stdin/stdout.
(define (scmfmt)
  (let ((char (peek-char)))
    (if (not (eof-object? char))
      (begin
        (cond ((eq? char #\;) (copy-line-comment))
              ((eq? char #\newline) (maintain-empty-lines))
              ((char-whitespace? char) (read-char))
              (#t (pretty-print (read))))
        (scmfmt)))))

(define (help) (print "Usage: scmfmt [-w width]") (exit 1))

(define (set-max-width)
  (let [(max-width 80) (args (command-line-arguments))]
    (pretty-print-width (cond ((null? args) max-width)
                 ((equal? (car args) "-w")
                  (if (null? (cdr args))
                    (help)
                    (let ((width (string->number (car (cdr args)))))
                      (cond ((and (number? width) (> width 0)) width)
                            (else (help))))))
                 (else (help))))))

(set-max-width)
(scmfmt)
