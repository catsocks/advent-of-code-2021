(import (chicken io)
        (chicken format))

(define measurements
 (with-input-from-file "day-01-sonar-sweep/measurements.txt"
   (lambda ()
     (let loop ((nums '()))
       (define line (read-line))
       (if (eof-object? line)
           nums
           (loop (append nums (list (string->number line)))))))))

(printf "~a measurements are larger than the previous.~n"
  (let loop ((larger-count 0) (nums measurements))
    (if (or (null? nums) (null? (cdr nums)))
        larger-count
        (loop
          (if (< (car nums) (cadr nums)) (+ larger-count 1) larger-count)
          (cdr nums)))))

(printf "~a sums are larger than the previous.~n"
  (let loop ((larger-count 0) (nums measurements))
    (if (or (null? nums) (null? (cdddr nums)))
        larger-count
        (let ((first-sum (+ (car nums) (cadr nums) (caddr nums)))
              (second-sum (+ (cadr nums) (caddr nums) (cadddr nums))))
          (loop (if (< first-sum second-sum) (+ larger-count 1) larger-count)
                (cdr nums))))))
