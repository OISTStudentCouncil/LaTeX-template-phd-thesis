# Thesis-LaTeX-template

LaTeX Template for OIST Thesis

All instructions are specified within the templates themselves.
Please refer to the Academic Program Policy for specifics regarding the format. While this is the final template, it is not technically supported by the Graduate School.
For questions on how to use LaTeX, please reach out to your Student Council.
For questions regarding the format of the thesis, please reach out to the Examinations Team (examination[at]oist.jp)

## building the thesis

If you want to build the thesis by hand, you may use the series of commands

```bash
pdflatex Thesis.tex
bibtex Thesis.aux
pdflatex Thesis.tex
pdflatex Thesis.tex
```

## checking that nothing spills into the margins

The class marks overfull *lines of text* with a thick black bar in the margin.
TeX does not draw that bar for displayed mathematics: `align`, `gather`,
`multline`, `split`, `eqnarray` and tables never get one, and an `equation`
that is more than 2.5 cm too wide draws its bar off the edge of the paper.
Long equations are also never broken across lines automatically, so they run
into the margins silently.

Everything is still recorded in `Thesis.log`. After compiling, run

```bash
./check_overfull.sh
```

to list every overfull box with its line numbers. It exits non-zero if there is
anything left to fix. The PowerShell equivalent is

```powershell
Select-String -Path Thesis.log -Pattern '^Overfull' -Context 0,1
```

While writing, compiling with `\documentclass[temporary,showframe]{oist_thesis}`
draws the outline of the text block on every page, which makes an over-wide
equation obvious at a glance. Remove the option before submitting.

## updating the template

If you are updating the template, you can run `./generate_examples.sh` to generate both example thesis in `Examples`.
