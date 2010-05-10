;;Example file for testing elisp-depend

(defun baz1 ()
   "Dummy example function binding variables"
   (let
      (a)
      a)
   (let 
      ((b 13))
      b)
   (let* 
      ((c 13))
      c)
   (let
      (bar-a)
      bar-a)
   (let 
      ((bar-b 13))
      bar-b)
   (let* 
      ((bar-c 13))
      bar-c))

