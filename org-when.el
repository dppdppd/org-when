;;; org-when.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Ido Magal
;;
;; Author: Ido Magal <https://github.com/dppdppd>
;; Maintainer: Ido Magal <1166577+dppdppd@users.noreply.github.com>
;; Created: December 10, 2021
;; Modified: December 14, 2021
;; (insert (concat "\n;; version: " (format-time-string "%Y.%m%d.%H" (current-time))))
;; version: 2021.1214.22
;; Keywords: time org agenda
;; Homepage: https://github.com/dppdppd/org-when
;; Package-Requires: ((emacs "27.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

(defcustom org-when-time-entries
  `((6  "@weekend"      6       0)
   ( 2  "@evening"      17      23 )
   ( 2  "@morning"      05      10 )
   ( 6  "@weekday"      1       5 ))
  "list of tags and the times during which they are to be seen in agenda.
The form is (TYPE TAG START END) where
TYPE is the integer that represents the unit of decode-time output to compare e.g. 6 for day of the week.
TAG is the org tag that is applied to the heading
START is the start of the time block as represented by decode-time e.g., 6 for Saturday if TYPE is 6
END is the end of the time block as represented by decode-time e.g., 0 for Sunday if TYPE is 6."
  :group 'org-when
  :type `(repeat
          (list :tag "entry"
                (choice :tag "TYPE"
                        (integer :tag "Hour" 2)
                        (integer :tag "Day of the month" 3))
                        (integer :tag "Month" 4)
                        (integer :tag "Year" 5)
                        (integer :tag "Day of the Week" 6)
                (string :tag "TAG")
                (integer :tag "START")
                (integer :tag "END"))))


(defun org-when-get-type (entry)
  "get the type"
  (nth 0 entry))

(defun org-when-get-tag (entry)
  "get the tag"
  (nth 1 entry))

(defun org-when-get-start (entry)
  "get the start"
  (nth 2 entry))

(defun org-when-get-end (entry)
  "get the end"
  (nth 3 entry))

(defun org-when-recursive-test (when-list alltags)
  ""
  (if when-list
      (let*
          ((entry (car when-list))
           (type (org-when-get-type entry))
           (tag (org-when-get-tag entry))
           (start (org-when-get-start entry))
           (end (org-when-get-end entry))
           (cur-val (nth type (decode-time))))
        (and
         (not (and (member tag alltags)
                   (if (< start end) ; we need to flip the logic if e.g., sat-sun (6-0)
                       (and (>= cur-val start) (<= cur-val end)) ; between start and end
                     (or (>= cur-val start) (<= cur-val end))))) ; after start or before end
         (org-when-recursive-test (cdr when-list) alltags)))
    t))


(defun org-when-list-of-tags ()
  "Create a list of the tags specified in org-when-time-entries."
  (mapcar (lambda(x) (nth 1 x)) org-when-time-entries))

(org-when-list-of-tags)

(defun org-when-filter ( entries )
  ""
  (org-back-to-heading t)
  (let ((end (org-entry-end-position)))
    (and
     (let* ((alltags (split-string
                      (or (org-entry-get (point) "ALLTAGS" t) "")
                      ":"))
            (matchtags (seq-intersection (org-when-list-of-tags) alltags)))
       (if matchtags
           (org-when-recursive-test entries alltags)
         nil))
     end)))

(defun org-when-skip-if (subtree conditions)
  "Replacement for (org-agenda-skip-if SUBTREE CONDITIONS).
Will do that plus filter out untimely org-when-time-entries."
    (or
   (org-when-skip-filter)
   (org-agenda-skip-if subtree conditions)))

(defun org-when-skip-filter ()
  ""
  (org-when-filter org-when-time-entries))


(provide 'org-when)
;;; org-when.el ends here
