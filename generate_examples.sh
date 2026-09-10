#!/usr/bin/env bash
set -euox pipefail

# Rebuilds Examples/Thesis_example.pdf, the compiled example that ships with the
# repository, and keeps the class file in step with the template.
#
# Run this from the top level of the repository after changing anything in
# Template/ or Examples/.

# Template/oist_thesis.cls is the single source of truth for the formatting
# rules; Examples/ just gets a copy of it.
cp Template/oist_thesis.cls Examples/oist_thesis.cls

cd Examples

pdflatex -interaction=nonstopmode Thesis.tex
bibtex Thesis.aux
pdflatex -interaction=nonstopmode Thesis.tex
pdflatex -interaction=nonstopmode Thesis.tex
mv Thesis.pdf Thesis_example.pdf

# remove the auxiliary files, keeping the sources and the PDF
rm -f Thesis.aux Thesis.bbl Thesis.blg Thesis.lof Thesis.log Thesis.lot \
      Thesis.out Thesis.toc

cd ..
