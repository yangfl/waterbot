(load "template/01blank/config")

(defun template-recovery-create ()
  "blank playground"
  (let ((container-id (cdr (assoc :*ID (third (container-create *docker* *blank-config*))))))
    (container-start *docker* container-id)
    ;(container-pause *docker* container-id)
    ;(container-unpause *docker* container-id)
    container-id))

(defun template-recovery-exec (container-id cmd)
  (usocket:with-connected-socket (socket (third (container-attach *docker* container-id)))
    (let ((timeout-p nil)
          (error-p nil)
          (stream (socket-stream socket)))
      (trivial-docker::write-all cmd stream)
      (handler-case
        (bordeaux-threads:with-timeout (*blank-timeout*)
          (loop
            do (sleep 0.3)
            until (=
              (length (cdr (assoc :*PROCESSES (third (container-top *docker* container-id)))))
              1)))
        (bordeaux-threads:timeout (ex) (setf timeout-p t)))
      (read-line stream)
      (let* ((echo (trivial-docker::read-all stream))
             (end (position #\Newline echo :from-end t)))
        (concatenate 'string
          (if end (subseq echo 0 end) echo)
          (format nil "~%")
          (if timeout-p "[timeout]" "")
          (if error-p "[thread error]" "")
          (if (>
              (length (cdr (assoc :*PROCESSES (third (container-top *docker* container-id)))))
              *blank-threads*)
            (progn
              (container-stop *docker* container-id)
              "[killed due to thread limit]")
            ""))))))

(defun template-recovery-exam (container-id)
  "unavailable for blank template")

(defun template-recovery-destory (container-id)
  (container-remove *docker* container-id))

(vector-push-extend
  (list #'template-recovery-create #'template-recovery-exec #'template-recovery-exam #'template-recovery-destory)
  *templates*)
