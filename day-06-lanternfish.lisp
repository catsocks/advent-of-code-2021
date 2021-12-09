(defparameter *spawn-cycle-begin-day* 6)
(defparameter *total-days* 8)

(defun parse-input (file-path)
  "Convert comma-separated integers to a list of integers."
  (with-open-file (stream file-path)
    (let ((string (read-line stream)))
      (loop for i = 0 then (1+ j)
            as j = (position #\, string :start i)
            collect (parse-integer string :start i :end j)
            while j))))

(defun make-lanternfish-state (timers)
  (let ((state (make-list (1+ *total-days*) :initial-element 0)))
    (dolist (timer timers) (setf (nth timer state) (1+ (nth timer state))))
    state))

(defun simulate-lanternfish (state days)
  (if (= days 0)
      state
      (simulate-lanternfish
        (let ((new (pop state)))
          (setf (nth *spawn-cycle-begin-day* state)
                (+ (nth *spawn-cycle-begin-day* state) new))
          (append state (list new)))
        (1- days))))

(defun count-lanternfish (state) (reduce '+ state))

(defparameter *lanternfish*
  (make-lanternfish-state (parse-input "day-06-lanternfish/input")))

(format t "There would be ~a laternfish after 80 days.~%"
        (count-lanternfish (simulate-lanternfish *lanternfish* 80)))

(format t "There would be ~a laternfish after 256 days.~%"
        (count-lanternfish (simulate-lanternfish *lanternfish* 256)))
