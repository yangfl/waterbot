#!/usr/bin/clisp
(load "~/quicklisp/setup.lisp")

(ql:quickload :trivial-ircbot)
(ql:quickload :bordeaux-threads)
(ql:quickload :trivial-http)
(ql:quickload :cl-json)
; (ql:quickload :cl+ssl)

(defpackage :waterbot
  (:use :common-lisp :trivial-ircbot :bordeaux-threads :trivial-http :cl-json))

(in-package :waterbot)

(load "config")

(defvar *waterbot* (new-bot :nickname *nickname* :server *server* :channels *channels* :asynchronous-p t :prefix #\!))

(defun sm (message form)
  (let ((result (third (shttp:http-get
          (format nil "http://xiaofengrobot.sinaapp.com/web.php?callback=jQuery191041205509454157474_1376842442554&para=~a&_=1376842442555" form)))))
    (loop for i to 4 do (read-char result))
    (json:decode-json result)))

(add-command *waterbot* "sm" 'sm)

(read-message-loop *waterbot*)
