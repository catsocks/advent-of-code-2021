#lang racket

(define commands
  (with-input-from-file
   "day-02-dive/commands.txt"
   (lambda ()
     (for/list ([line (in-lines)] #:when (non-empty-string? line))
       (match-let ([(list direction distance) (string-split line)])
                  (cons (string->symbol direction)
                        (string->number distance)))))))

(define (process-commands commands [position 0] [depth 0])
  (cond
    [(empty? commands) (values position depth)]
    [else
     (match-define (cons direction distance) (first commands))
     (case direction
       ['forward (process-commands (rest commands) (+ position distance) depth)]
       ['up (process-commands (rest commands) position (- depth distance))]
       ['down
        (process-commands (rest commands) position (+ depth distance))])]))

(let-values ([(position depth) (process-commands commands)])
  (printf "The final horizontal position multiplied by the final depth is ~a.~%"
          (* position depth)))

(define (new-process-commands commands [position 0] [depth 0] [aim 0])
  (cond
    [(empty? commands) (values position depth)]
    [else
     (match-define (cons direction distance) (first commands))
     (case direction
       ['forward (new-process-commands (rest commands)
                                       (+ position distance)
                                       (+ depth (* aim distance))
                                       aim)]
       ['up
        (new-process-commands (rest commands) position depth (- aim distance))]
       ['down (new-process-commands (rest commands)
                                    position
                                    depth
                                    (+ aim distance))])]))

(let-values ([(position depth) (new-process-commands commands)])
  (printf (~a "The (correct) final horizontal position multiplied by the final "
              "depth is ~a.~%")
          (* position depth)))
