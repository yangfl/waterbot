(load "~/quicklisp/setup.lisp")

(ql:quickload :bordeaux-threads)

(in-package :bordeaux-threads)

;(make-two-way-stream *stream1* *stream2*)

(make-thread (lambda () (sleep 3) (write-string "aaaa")))
(write-string "bbb")
;(read-char-no-hang *stream1*)
