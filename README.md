# org-when
Filter agenda items using tags, e.g. @weekend
 
Agendas can get filled with tasks that can't be done in the current time context. org-when will hide tasks that aren't doable right now.

For example

* Clean the yard        :@weekend:

With org-when, this heading will only show up in org agenda on Saturday or Sunday.

## INSTALLATION
Doom:
#### packages.el
```(package! org-when)```

#### config.el
```(use-package! org-when)```

## CONFIGURATION

- OPTIONALLY, modify org-when-list-tags. This is a list of tags and times. It can be customized or set.
The default tags (and their times) are

@weekend (Sat-Sun)
@weekday (Mon-Fr)
@morning (5am-10am)
@evening (5pm-11pm)

- Set up your agenda to use org-when-skip-entry-if and org-when-skip-subtree-if, instead of org-agenda-skip-entry-if and org-agenda-skip-subtree-if, respectively.
- tag your headings with one of the specified tags.

