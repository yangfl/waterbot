(load "~/quicklisp/setup.lisp")

(ql:quickload :trivial-ircbot)
(ql:quickload :trivial-docker)
(ql:quickload :bordeaux-threads)
; (ql:quickload :cl+ssl)

(defpackage :waterbot
  (:use :common-lisp :trivial-docker :trivial-ircbot :bordeaux-threads :usocket))

(in-package :waterbot)

(load "config")
(load "docker")
(load "command")

(setf *docker* (docker-connect *host* *port*))

(defvar *waterbot* (new-bot :nickname *nickname* :server *server* :channels *channels* :asynchronous-p t))

(add-command *waterbot* "list" 'list-template)
(add-command *waterbot* "create" 'create)
(add-command *waterbot* "run" 'run)
(add-command *waterbot* "destory" 'destory)
(add-command *waterbot* "exam" 'exam)

(add-help-command *waterbot*)
; :help-message-format "commands: ~{~a~^ ~} 出于某种奇怪的原因，fork bomb会导致clisp的线程炸掉，基佬们自粽")

(add-command *waterbot* "echo" #'(lambda (m s) s))
(add-command *waterbot* "eval" 'eval-)

(read-message-loop *waterbot*)
