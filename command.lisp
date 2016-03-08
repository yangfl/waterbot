(defvar *user-container* (make-hash-table :test 'equal))

;;; error ;;;

(define-condition user-container-error (error)
  ((text :initarg :text)))

(defmethod print-object ((object user-container-error) stream)
  (format stream "~a" (slot-value object 'text)))

;;; getter ;;;

(defun user-container (user)
  (let ((container-token (gethash user *user-container*)))
    (if container-token
      container-token
      (error 'user-container-error :text "Would you please create a container first?"))))

;;; commands ;;;

(defun list-template (message str-template-id)
  (if (string= str-template-id "")
    (format nil "I have ~a template~1:*~p. Use `list [num] to see description." (fill-pointer *templates*))
    (or (documentation (first (template-find (parse-integer str-template-id))) t) "[no documentation]")))

(defun create (message str-template-id)
  (let ((user (source message)))
    (if (gethash user *user-container*)
      "Sorry, but you already have a container."
      (progn
        (setf (gethash user *user-container*) (template-create (parse-integer str-template-id)))
        (format nil "Created, template ~a" str-template-id)))))

(defun run (message cmd)
  (template-exec (user-container (source message)) cmd))

(defun exam (message args)
  (template-exam (user-container (source message))))

(defun destory (message args)
  (let* ((user (source message))
         (token (user-container user)))
    (remhash user *user-container*)
    (template-destory token)
    (format nil "Removed")))

;;; management ;;;

(defun eval- (message form)
  (in-package :waterbot)
  (format t "~a~%" form)
  (if (string= (source message) *owner*)
    (princ (eval (read-from-string form)))))

(defun emergency (&optional message args)
  (loop for token being the hash-values of *user-container* do (template-destory token))
  (clrhash *user-container*)
  "OK")

(defun dead (&optional message args)
  (emergency)
  (setf *user-container* nil)
  "Locked")
