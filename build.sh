#!/bin/bash

# ==========================================
# Build Script (A Poor Man's Makefile)
# ==========================================
#
# Run to compile the sources to pdf.
# 
# One may also specify the --clean option, 
# which will remove all extraneous files 
# created by compiling the document.
# 
# ==========================================

tex_path='/usr/texbin'

trash_files='Thesis.run.xml Thesis.synctex.gz ImportantRefs.bib.bak'

if [ "$1" == '--clean' ]; then
	echo 'Cleanup requested.';
	$tex_path/latexmk --c;
	for file in $trash_files; do
		if [ -a $file ]; then
			trash -v "$file"
		fi
	done
	exit 0;
fi

# First, run knitr
Rscript -e "library(knitr); knit('Thesis.Rnw')";

# Since that isn't powerful enough to deal 
# with all the cross-referencing, run it 
# through pdflatex again.
$tex_path/latexmk -cd -pdflatex="$tex_path/pdflatex -interaction=nonstopmode -synctex=1" -f -pdf Thesis.tex
