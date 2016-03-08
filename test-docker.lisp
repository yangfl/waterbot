(load "~/quicklisp/setup.lisp")

(ql:quickload :trivial-docker)

(in-package :trivial-docker)

(load "config")

(setf *docker* (docker-connect *host* *port*))

(setf id (cdr (assoc :*id (third (container-create *docker* *blank-config*)))))

(container-start *docker* id)

(setf id "0580")

(setf socket (third (container-attach *docker* id)))

(setf stream (socket-stream socket))

(setf socket1 (third (container-attach *docker* id)))

(setf stream1 (socket-stream socket1))

(write-all "free -m" stream)

; (print (container-list *docker*))

; (container-attach-exec *docker* id "echo 23")

;(print (container-remove *docker* "1c023b"))

; (loop for i = (read-line stream) do (print i))

;  *standard-output*

; POST /containers/699/attach?logs=0&stream=1&stdin=1&stdout=1&stderr=1 HTTP/1.1
