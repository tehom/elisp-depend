;;;_ tests.el --- Tests for elisp-depend

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

;; elisp-depend is by Andy Stewart, not by me.


;;;_ , Requires
(require 'elisp-depend)
(require 'emtest/testhelp/standard)
(require 'emtest/runner/define)
(require 'emtest/testhelp/eg)

;;;_. Body
;;;_ , Mock load history

(defconst elisp-depend:th:load-history 
   '(
       ("/usr/share/emacs/22.2/lisp/unused.elc")
       ("/usr/share/emacs/22.2/lisp/foo.el"
	  (provide . foo-module)
	  (require . edebug))
       ("/usr/share/emacs/22.2/lisp/bar.elc"
	  (defun . bar-toggle)
	  (require . easymenu)
	  bar-mode-menus
	  (provide . bar-module)
	  (require . edebug))
       ("/usr/share/emacs/22.2/lisp/entry/with/slashes.elc"
	  (provide . entry/with/slashes)))
   
   "Example load-history" )

;;;_ , Examples
(defconst elisp-depend:td
   (emt:eg:define+ ()
      (group ((name foo-el))
	 (item ((role filename)) "/usr/share/emacs/22.2/lisp/foo.el")
	 (item ((role expected)) "foo-module"))
      (group ((name bar-elc))
	 (item ((role filename)) "/usr/share/emacs/22.2/lisp/bar.elc")
	 (item ((role expected)) "bar-module"))
      (group ((name not-in-load-history))
	 (item ((role filename)) "/usr/share/emacs/not-in-load-history.elc")
	 (item ((role expected)) "not-in-load-history"))
      (group ((name with-slashes))
	 (item ((role filename)) "/usr/share/emacs/22.2/lisp/entry/with/slashes.elc")
	 (item ((role expected)) "entry/with/slashes"))
      ))


;;;_ , elisp-depend-filename
(emt:deftest-3 
   ((of 'elisp-depend-filename)
      (:surrounders
	 '(  (emt:eg:with elisp-depend:td ())
	     (emt:eg:map name nil)
	     (let
		((load-history elisp-depend:th:load-history))
		(emt:doc "Situation: With a known load-history.")))))
   (nil
      (progn
	 (emt:doc "Response: We get the expected result.")
	 (assert
	    (string=
	       (elisp-depend-filename (emt:eg (role filename)))
	       (emt:eg (role expected)))
	    t))))

;;;_. Footers
;;;_ , Provides

(provide 'tests)

;;;_ * Local emacs vars.
;;;_  + Local variables:
;;;_  + mode: allout
;;;_  + End:

;;;_ , End
;;; tests.el ends here
