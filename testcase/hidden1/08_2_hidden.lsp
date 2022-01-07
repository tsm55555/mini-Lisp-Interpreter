(define foo (fun (y) (+ y 12)))

(define foo-z (fun () 10))

(print-num (foo (foo-z)))
