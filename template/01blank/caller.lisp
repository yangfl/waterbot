(load "template/01blank/config")

(defun template-blank-create ()
  "blank playground"
  (let ((container-id (cdr (assoc :*ID (third (container-create *docker* *blank-config*))))))
    (container-start *docker* container-id)
    ;(container-pause *docker* container-id)
    ;(container-unpause *docker* container-id)
    container-id))

(defun template-blank-exam (container-id)
  "unavailable for blank template")

(defun template-blank-destory (container-id)
  (container-remove *docker* container-id))

(vector-push-extend
  (list #'template-blank-create #'container-exec #'template-blank-exam #'template-blank-destory)
  *templates*)
