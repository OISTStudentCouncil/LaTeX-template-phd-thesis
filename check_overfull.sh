#!/usr/bin/env bash
#
# List every box that does not fit the text block, straight from the LaTeX log.
#
# Why this script exists: oist_thesis.cls sets \overfullrule so that overfull
# *paragraph* lines are marked with a thick black bar in the PDF.  TeX does not
# draw that bar for displayed mathematics:
#
#   * align, align*, gather, multline, split, alignat, flalign, eqnarray and
#     array/tabular are alignments, and TeX's alignment routine switches
#     \overfullrule off while it packs them.  They never get a bar.
#   * equation, equation* and \[...\] do get a bar, but TeX puts it at the end
#     of the formula, so an equation that is more than 2.5cm too wide draws its
#     bar past the edge of the paper, where you cannot see it.
#
# The .log always records the problem, so this is the reliable place to look.
#
# Usage: ./check_overfull.sh [Thesis.log]

set -uo pipefail

log="${1:-Thesis.log}"

if [[ ! -f "$log" ]]; then
	echo "check_overfull: no such log file: $log" >&2
	echo "Compile the thesis first, e.g. pdflatex Thesis.tex" >&2
	exit 2
fi

# TeX starts these warnings at the beginning of a line and nothing else in the
# log begins with "Overfull"/"Underfull".  The line after the warning shows the
# offending material, which is usually enough to recognise the culprit.
overfull=$(grep -n -A1 '^Overfull' "$log")
underfull=$(grep -n -A1 '^Underfull' "$log")

n_over=$(grep -c '^Overfull' "$log")
n_under=$(grep -c '^Underfull' "$log")

echo "Reading $log"
echo

if [[ -n "$overfull" ]]; then
	echo "=== $n_over overfull box(es): these stick out into the margins ==="
	echo "$overfull"
	echo
	cat <<'TIPS'
The three shapes of this message tell you what to fix:

  ... in paragraph at lines A--B
      A line of text. Reword it, or allow a break with \- inside a long word.

  ... detected at line A
      A display: equation, equation* or \[...\]. Display maths is never broken
      across lines automatically. Break it yourself with split or multline.

  ... in alignment at lines A--B
      An align/gather/eqnarray display, or a tabular. Break the offending row
      at a relation symbol, or make the columns narrower.

TIPS
fi

if [[ -n "$underfull" ]]; then
	echo "=== $n_under underfull box(es): loose spacing, cosmetic only ==="
	echo "$underfull"
	echo
fi

if (( n_over > 0 )); then
	echo "Result: $n_over overfull box(es) to fix before submission."
	exit 1
fi

echo "Result: no overfull boxes. Nothing sticks out into the margins."
exit 0
