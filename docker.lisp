;;; error ;;;

(define-condition no-such-template (error) (
  (id
    :initarg :id)))

(defmethod print-object ((object no-such-template) stream)
  (format stream "~a: ~a" 'no-such-template (slot-value object 'id)))

;;; getter ;;;

(defun template-find (id)
  (or
    (and (plusp id) (<= id (length *templates*)) (aref *templates* (1- id)))
    (error 'no-such-template :id id)))

(defun template-create (id)
  (cons id (funcall (first (template-find id)))))

(defun template-exec (token cmd)
  (funcall (second (template-find (car token))) (cdr token) cmd))

(defun template-exam (token)
  (funcall (third (template-find (car token))) (cdr token)))

(defun template-destory (token)
  (funcall (fourth (template-find (car token))) (cdr token)))

;;; attach ;;;

(defun container-top-num (container-id)
  (length (cdr (assoc :*PROCESSES (third (container-top *docker* container-id))))))

(defconstant +interval+ 0.3)

(defun container-exec (container-id cmd)
  (with-connected-socket (socket (third (container-attach *docker* container-id)))
    (let ((timeout-p nil)
          (stream (socket-stream socket)))
      (trivial-docker::write-all cmd stream)
      (handler-case
        (with-timeout (*blank-timeout*)
          (loop
            until (dotimes (i 2)
              (sleep +interval+)
              (if (= (container-top-num container-id) 1) (return t)))))
        (timeout (ex) (setf timeout-p t)))
      (read-line stream)
      (let* ((echo (trivial-docker::read-all stream))
             (end (position #\Newline echo :from-end t))
             (echo (if end (subseq echo 0 end) echo))
             (info (concatenate 'string
               (if timeout-p "[timeout]" "")
               (if (> (container-top-num container-id) *blank-threads*)
                 (progn
                   (container-stop *docker* container-id)
                   "[killed due to thread limit]")
                 "")
                (if (string= echo "") "[no output]" "")))
              (echo (if (string/= info "") (format nil "~a~%~a" info echo) echo)))
        echo))))

;;; template ;;;

(setf *templates* (make-array 5 :fill-pointer 0 :adjustable t :element-type 'function))

(load "template/01blank/caller")
;(load "template/02recovery/caller")
