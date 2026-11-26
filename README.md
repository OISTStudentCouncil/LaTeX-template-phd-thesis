# Thesis-LaTeX-template

LaTeX Template for OIST Thesis

All instructions are specified within the templates themselves.
Please refer to the Academic Program Policy for specifics regarding the format. While this is the final template, it is not technically supported by the Graduate School.
For questions on how to use LaTeX, please reach out to your Student Council.
For questions regarding the format of the thesis, please reach out to the Examinations Team (examination[at]oist.jp)

## layout

| Folder | What it is |
|---|---|
| `Template/` | The empty starting point. **Copy this one** and write your thesis in it. |
| `Examples/` | A complete thesis, kept so you can look up how something was done and copy the code across. |

Both share the same `oist_thesis.cls`. `Template/oist_thesis.cls` is the source
of truth; `generate_examples.sh` copies it into `Examples/` so the two can never
drift apart.

`Template/MainText/chapter2.tex` is the guide to using the template, and it is
part of the template itself — so the PDF you get from a first compile explains
how the rest works.

## building the thesis

If you want to build the thesis by hand, from inside `Template/` (or
`Examples/`) use the series of commands

```bash
pdflatex Thesis.tex
bibtex Thesis.aux
pdflatex Thesis.tex
pdflatex Thesis.tex
```

If the log still ends with "Rerun to get cross-references right", run
`pdflatex Thesis.tex` once more. This happens when the citation numbers move a
heading onto the next page, so the Contents needs one more run to catch up.

## line spacing

There is one version of the thesis. Set the line spacing your field requires
with the class option in the first line of `Thesis.tex`:

```latex
\documentclass[onehalfspacing]{oist_thesis}   % the default
\documentclass[singlespacing]{oist_thesis}
\documentclass[doublespacing]{oist_thesis}
```

The older options `temporary` (double spacing) and `final` (single spacing)
still compile, with a warning, so a thesis started from an earlier version of
the template keeps working.

## checking that nothing spills into the margins

The class marks overfull *lines of text* with a thick black bar in the margin.
TeX does not draw that bar for displayed mathematics: `align`, `gather`,
`multline`, `split`, `eqnarray` and tables never get one, and an `equation`
that is more than 2.5 cm too wide draws its bar off the edge of the paper.
Long equations are also never broken across lines automatically, so they run
into the margins silently.

Everything is still recorded in `Thesis.log`. After compiling, run

```bash
./check_overfull.sh Template/Thesis.log
```

to list every overfull box with its line numbers. It exits non-zero if there is
anything left to fix. `Examples/` builds with none at all. `Template/` has
exactly one, put there on purpose in the "Overfull Lines" section of chapter 2
to show what the black bar looks like. Anything else it reports is something you
introduced. The PowerShell equivalent is

```powershell
Select-String -Path Thesis.log -Pattern '^Overfull' -Context 0,1
```

While writing, compiling with `\documentclass[onehalfspacing,showframe]{oist_thesis}`
draws the outline of the text block on every page, which makes an over-wide
equation obvious at a glance. Remove the option before submitting.

## updating the template

If you are updating the template, you can run `./generate_examples.sh` to generate both example thesis in `Examples`.
