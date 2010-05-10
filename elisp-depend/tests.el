;;;_ elisp-depend/tests.el --- Tests for elisp-depend

;;;_. Headers
;;;_ , License
;; Copyright (C) 2010  Tom Breton (Tehom)

;; Author: Tom Breton (Tehom) <tehom@panix.com>
;; Keywords: lisp, maint, internal

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;;_ , Commentary:

;; elisp-depend is originally by Andy Stewart.  See the
;; elisp-depend.el comments.

;;;_ , Requires
(require 'elisp-depend)
(require 'emtest/testhelp/standard)
(require 'emtest/runner/define)
(require 'emtest/testhelp/eg)

;;;_. Body
;;;_ , Data
;;;_  . Mock load history

(defconst elisp-depend:th:load-history 
   '(
       ("/home/localuser/lisp/unused.elc")
       ("/home/localuser/lisp/foo.el"
	  (provide . foo-module)
	  (require . edebug))
       ("/home/localuser/lisp/bar.elc"
	  (defun . bar-a-fun)
	  (require . easymenu)
	  bar-a
	  bar-b
	  bar-c
	  (provide . bar-module)
	  (require . edebug))
       ("/home/localuser/lisp/entry/with/slashes.elc"
	  (provide . entry/with/slashes)))
   
   "Example load-history" )
;;;_  . Dir locations
(defconst elisp-depend:th:examples-dir
   (emt:expand-filename-by-load-file "examples") 
   "Directory where examples are" )

;;;_  . Examples
(defconst elisp-depend:td
   (emt:eg:define+ ()
      (group ((mapping module-name))
	 (group ((name foo-el))
	    (item ((role fullpath)) "/home/localuser/lisp/foo.el")
	    (item ((role expected)) "foo-module"))
	 (group ((name bar-elc))
	    (item ((role fullpath)) "/home/localuser/lisp/bar.elc")
	    (item ((role expected)) "bar-module"))
	 (group ((name not-in-load-history))
	    (item ((role fullpath)) "/usr/share/emacs/not-in-load-history.elc")
	    (item ((role expected)) "not-in-load-history"))
	 (group ((name with-slashes))
	    (item ((role fullpath)) "/home/localuser/lisp/entry/with/slashes.elc")
	    (item ((role expected)) "entry/with/slashes")))

      (group ((mapping syms-in-file))
	 (group ((name file0))
	    (item ((role filename)) "file0.el")
	    (item ((role expected)) '()))
	 (group ((name file1))
	    (item ((role filename)) "file1.el")
	    (item ((role expected)) '()))
	 (group ((name file2))
	    (item ((role filename)) "file2.el")
	    (item ((role expected)) '()))
	 ;;Finding variable names is not supported.
;; 	 (group ((name file3))
;; 	    (item ((role filename)) "file3.el")
;; 	    (item ((role expected)) 
;; 	       '(("/home/localuser/lisp/bar.elc" bar-a))))
	 (group ((name file4))
	    (item ((role filename)) "file4.el")
	    (item ((role expected)) 
	       '(("/home/localuser/lisp/bar.elc" bar-a-fun))))
	 (group ((name file5))
	    (item ((role filename)) "file5.el")
	    (item ((role expected)) 
	       ;;Also sees funcall but properly ignores it
	       '(("/home/localuser/lisp/bar.elc" bar-a-fun))))
	 )))


;;;_ , elisp-depend-filename
(emt:deftest-3 
   ((of 'elisp-depend-filename)
      (:surrounders
	 '(  (emt:eg:with elisp-depend:td ())
	     (flet ((bar-a-fun ()())))
	     (let
		(   bar-a bar-b bar-c
		   (load-history elisp-depend:th:load-history))
		(emt:doc "Situation: With a known load-history.")))))
   (nil
      (emt:eg:narrow ((mapping module-name))
	 (emt:eg:map name nil
	    (emt:doc "Response: We get the expected result.")
	    (assert
	       (string=
		  (elisp-depend-filename (emt:eg (role fullpath)))
		  (emt:eg (role expected)))
	       t))))
   )

(emt:deftest-3 
   ((of 'elisp-depend-map)
      (:surrounders
	 '(  (emt:eg:with elisp-depend:td ())
	     (flet ((bar-a-fun ()())))
	     (let
		(   bar-a bar-b bar-c
		   (load-history elisp-depend:th:load-history))
		(emt:doc "Situation: With all the relevant symbols bound.")))))
   (nil
      (emt:eg:narrow ((mapping syms-in-file))
	 (emt:eg:map name nil
	    (with-buffer-containing-object
	       (:file (emt:eg (role filename)) 
		  :dir elisp-depend:th:examples-dir)
	       (emt:doc "Operation: `elisp-depend-map'.")
	       (emt:doc "Response: Gets the expected result.")
	       (assert
		  (equal
		     (elisp-depend-map)
		     (emt:eg (role expected)))
		  t))))))

;;;_. Footers
;;;_ , Provides

(provide 'elisp-depend/tests)

;;;_ * Local emacs vars.
;;;_  + Local variables:
;;;_  + mode: allout
;;;_  + End:

;;;_ , End
;;; elisp-depend/tests.el ends here
