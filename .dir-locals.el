;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((org-mode
  ;; This is our master-thesis class that defines the mapping of org-levels to latex-sections
  (eval . (add-to-list 'org-latex-classes '("master-thesis"
                     "\\documentclass{report}"
                     ("\\chapter{%s}" . "\\chapter*{%s}")
                     ("\\section{%s}" . "\\section*{%s}")
                     ("\\subsection{%s}" . "\\subsection*{%s}")
                     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                     ("\\paragraph{%s}" . "\\paragraph*{%s}")
                     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
        )
  ;; A function to remove bbl files. This is only needed if you compile with latexmk
  (eval . (progn
            (defun remove-bbl-file (args) (progn
                                           (if (file-exists-p "README.bbl")
                                               (delete-file "README.bbl"))
                                           ))
            (require 'ox-extra)
            (ox-extras-activate ' (ignore-headlines))
            ;; Add Easy Templates
            (eval-after-load "org"
              '(progn
                 (add-to-list 'org-structure-template-alist
                              '("A" "#+AUTHOR: ?"))
                 (add-to-list 'org-structure-template-alist
                              '("~" "\nbsp{}"))
                 (add-to-list 'org-structure-template-alist
                              '("al" "#+ATTR_LATEX: ?"))
                 (add-to-list 'org-structure-template-alist
                              '("t" "#+TITLE: ?"))
                 (add-to-list 'org-structure-template-alist
                              '("n" "#+NAME: ?"))
                 (add-to-list 'org-structure-template-alist
                              '("cap" "#+NAME: ?\n#+CAPTION: "))
                 (add-to-list 'org-structure-template-alist
                              '("d" "#+DATE: \\today?"))
                 (add-to-list 'org-structure-template-alist
                              '("t" "#+TITLE: ?\n#+AUTHOR: Remko van Wagensveld\n#+DATE: \\today"))
                 (add-to-list 'org-structure-template-alist
                              '("de" "#+LANGUAGE: de\n#+LaTeX_HEADER: \\usepackage[ngerman]{babel}\n?"))
                 (add-to-list 'org-structure-template-alist
                              '("pb" "#+BEGIN_EXPORT latex\n\pagebreak\n#+END_EXPORT\n?"))
                 (add-to-list 'org-structure-template-alist
                              '("geo" "#+LaTeX_HEADER: \\usepackage[a4paper, margin=2cm?]{geometry}\n"))
                 (add-to-list 'org-structure-template-alist
                              '("toc" "#+TOC: headlines\n#+TOC: tables\n#+TOC: listings\n?"))
                 )
              )

            ;; Use Minted for Listings. Not neccessary.
            (setq org-latex-listings 'minted
                  org-latex-packages-alist '(("" "minted")))
            ;; Use latexmk to compile the Source
            (setq org-latex-pdf-process
                  ;; Uncomment the line below to use latexmk
                  ;; '("latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f' -pdf -bibtex -gg"))
                  ;; If using latexmk comment out this line
                  '("arara %f")
                  )
            ;; Load languages to execute from Org
            (org-babel-do-load-languages
             'org-babel-load-languages
             '((shell . t)
               (python . t)
               (plantuml . t)
               (ditaa .t)))
            (setq org-plantuml-jar-path '"/opt/plantuml/plantuml.jar")

            ;; Activate RefTeX in Org Mode
            (defun org-mode-reftex-setup ()
              (load-library "reftex")
              (and (buffer-file-name)
                   (file-exists-p (buffer-file-name))
                   (reftex-parse-all))
              (define-key org-mode-map (kbd "C-c R") 'reftex-citation)) ;; Use C-C R to start a citation
            (add-hook 'org-mode-hook 'org-mode-reftex-setup)
            )
        )
  ;; Our projects that we have in README.org
  (org-publish-project-alist
   ("thesis"
    :base-directory "."
    :base-extension "org"
    :publishing-directory "./output/thesis/"
    :publishing-function org-latex-publish-to-pdf
    :select-tags    ("thesis")
    :title "Thesis Document"
    :include    ("./README.org")
    :exclude "\\.org$"
    :latex-class "master-thesis"
    :latex-title-command "\\mytitle"  ;; Overwrite the title-command
    :latex-tables-booktabs t
    :with-footnotes t
    )
   ("notes"
    :base-directory "."
    :base-extension "org"
    :publishing-directory "./output/notes"
    :publishing-function org-latex-publish-to-pdf
    :select-tags   ("notes")
    :title "Notes for the Masterthesis"
    :include   ("README.org")
    :exclude "\\.org$"
    :latex-class "article"
    :latex-tables-booktabs t
    )
   ("expose"
    :base-directory "."
    :base-extension "org"
    :publishing-directory "./output/expose"
    :publishing-function org-latex-publish-to-pdf
    :preparation-function remove-bbl-file
    :select-tags    ("expose")
    :title "Expose"
    :include   ("README.org")
    :exclude "\\.org$"
    :latex-class "article"
    )
   ("schedule"
    :base-directory "."
    :base-extension "org"
    :publishing-directory "./output/schedule"
    :publishing-function org-latex-publish-to-pdf
    :select-tags ("schedule")
    :title "Schedule for the Masterthesis"
    :include ("README.org")
    :exclude "\\.org$"
    :latex-class "article"
    :with-planning t
    :with-priority t
    :with-tasks t
    :with-timestamps t
    :with-clocks t
    )
   )
  ))
