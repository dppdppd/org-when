# org-when
Hide items that aren't time-relevant by creating and using time-based tags e.g., @weekend
 
Agendas can get filled with tasks that can't be completed in the current time context. org-when will hide tasks that aren't doable right now.

For example

* Clean the yard        :@weekend:

With org-when, this heading will only show up in org agenda on Saturday or Sunday.

## INSTALLATION

```(package org-when)```
```(use-package org-when)```

## CONFIGURATION

1. OPTIONALLY, modify org-when-list-tags. This is a list of tags and times. It can be customized or set.
The default tags (and their times) are

@weekend (Sat-Sun)
@weekday (Mon-Fr)
@morning (5am-10am)
@evening (5pm-11pm)

2. In your org agenda configuration, use __org-when-skip-if__ instead of __org-agenda-skip-if__.
e.g.

```
(setq org-agenda-custom-commands
        '(("d" "Daily agenda"
            ((agenda ""
                (org-agenda-skip-function '(org-when-skip-if '(todo done))))))))

```
                      
3. tag your headings with one of the specified tags.

