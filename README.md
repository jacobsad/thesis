Thesis
======

Yes, my undergraduate thesis is under version control. It helps me think. Note: sadly this is not, at least for the time being, an open-source project. All rights reserved.

Building
--------
To compile to `.pdf` you will need a suitable LaTeX installation; the automated `build.sh` script is targeted at Unix-like installation with `latexmk` available. I have only tested the build script on OS X Mountain Lion, but with some fiddling it should compile on any system where R and LaTeX are available (i.e. all of them).

Each chapter can also be built individually by invoking some variant of

```bash
$ Rscript -e "library(knitr); knit('$FILENAME.Rnw')"
```

and then 

```bash
$ /usr/texbin/latexmk -cd -pdflatex="/usr/texbin/pdflatex -interaction=nonstopmode -synctex=1" -f -pdf $FILENAME.tex
```

in a Unix-like console (provided you have the appropriate dependencies, see below).

Dependencies
------------
My workspace (see `setup_env.sh`) involves both tmux and Sublime Text, although this is mostly because I kept having memory issues with RStudio. Those tools are not required to build the project itself, however. In addition, the project makes use of many, many LaTeX packages, they are all (to my knowledge) available on any standard LaTeX installation. What are really relevant here are the R packages that do not come with default installation.


### Required R Packages

The following R packages are used in the project; these are required for building the `.tex` files from the `.Rnw` sources, including the generation of figures, and in some cases to run the actual experiment itself.

For general S-weave/knitr compiling:

* [knitr](http://yihui.name/knitr/) (also on CRAN)
* [tikzDevice](http://r-forge.r-project.org/R/?group_id=440) (which is _not_ on CRAN)

For graphics (all on CRAN):
	
* ggplot2, grid, gridextra, lattice, vcd, and extrafont
	
For statistical distributions (all on CRAN):

* MCMCpack