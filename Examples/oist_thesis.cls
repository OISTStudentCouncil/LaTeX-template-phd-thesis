
% A LaTeX2e class for thesis submissions to
% Okinawa Institute of Science and Technology (OIST):
%
% Tadashi Kozuno (tadashi.kozuno@gmail.com)
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{oist_thesis}[2019/3/17 OIST thesis submission class]

% Line spacing of the thesis. There is a single version of the thesis. Pick the
% spacing your field requires with one of these options:
%     \documentclass[singlespacing]{oist_thesis}
%     \documentclass[onehalfspacing]{oist_thesis}   (the default)
%     \documentclass[doublespacing]{oist_thesis}
\def\oist@spacing{onehalf}
\DeclareOption{singlespacing}{\def\oist@spacing{single}}
\DeclareOption{onehalfspacing}{\def\oist@spacing{onehalf}}
\DeclareOption{doublespacing}{\def\oist@spacing{double}}
% Older versions of this class had a "temporary" (double spaced) and a "final"
% (single spaced) version. Both options are still accepted, so that a thesis
% started with an older Thesis.tex compiles unchanged, but they only set the
% line spacing.
\DeclareOption{temporary}{\def\oist@spacing{double}%
	\ClassWarningNoLine{oist_thesis}{Option `temporary' is obsolete,
		use `doublespacing' instead}}
\DeclareOption{final}{\def\oist@spacing{single}%
	\ClassWarningNoLine{oist_thesis}{Option `final' is obsolete,
		use `singlespacing' instead}}

% Draft aid: draw the boundary of the text block on every page, so that
% anything spilling into the 2.5cm margins (long equations in particular) is
% impossible to miss.  Purely visual, changes no dimension.  Use it while you
% write, remove it before you submit:
%     \documentclass[onehalfspacing,showframe]{oist_thesis}
\newif\if@drawframe\@drawframefalse
\DeclareOption{showframe}{\@drawframetrue}

\ProcessOptions\relax

%-------------------------------------------------------------------------------
%	HANDLING THE STYLE OF THE THESIS
%-------------------------------------------------------------------------------

\LoadClass[12pt, oneside]{book} % 12 pt font, one-sided book style

\if@drawframe\PassOptionsToPackage{showframe}{geometry}\fi
\RequirePackage[a4paper, inner=2.5cm ,outer=2.5cm, top=2.4cm, bottom=2.5cm]{geometry}  % Changing size of document

\usepackage{titlesec} % To move the chapter title up
% \linespread{1} keeps the heading itself single spaced whatever line spacing
% the thesis uses. setspace stretches the baseline of every font size, the
% \huge heading included, so without it the position of the heading depended on
% the spacing option: an offset that was right for double spacing put the
% heading of a single-spaced thesis about 6mm into the top margin, and links
% from the Contents, which point at the top of the text block, then cut off
% the top of the heading. With it, the offsets below hold for every option.
%
% The \vspace*{-2.7pt} sits in the *label*, which titlesec only typesets for a
% numbered chapter. A numbered chapter opens with the \huge "Chapter N" while an
% unnumbered one (Abstract, Introduction, Table of Contents) opens with the
% \LARGE title, and the taller first line pushed numbered chapters further down
% the page. Correcting it here rather than in \titlespacing means \chapter and
% \chapter* both start at the same height as ordinary body text.
\titleformat{\chapter}[display]{\normalfont\linespread{1}\huge\bfseries\raggedright}{\vspace*{-2.7pt}\chaptertitlename\ \thechapter}{20pt}{\LARGE}
% 0 left, -18.7pt top, 20pt bottom.
%
% The top value is negative on purpose. With 0pt the first line of a chapter
% heading sat well below where body text starts on an ordinary page, because
% titlesec measures from the first baseline and a \huge line reserves far more
% headroom than a 12pt one. Chapter pages therefore looked like they had a much
% bigger top margin than every other page.
%
% -18.7pt lines the first line of every chapter heading up with body text,
% measured in the PDF for single, one-and-a-half and double spacing. Do not
% push it further: a more negative value lifts the heading above the 2.4cm top
% margin.
\titlespacing{\chapter}{0pt}{-18.7pt}{20pt}

% Headings are set ragged right rather than justified.
%
% A justified heading has very few possible break points, because the words are
% large, so TeX often prefers to overshoot the right margin rather than open up
% an ugly gap. A long chapter title then runs into the 2.5cm margin: the title
% "Cavity Mediated Two-Photon Processes in Two Qubits Circuit QED" overflowed by
% 16.8pt before this change. Ragged right simply breaks at the last word that
% fits, so a heading can never overflow. The sizes and spacing below are the
% ones the book class already uses, only the justification changes.
\titleformat{\section}{\normalfont\Large\bfseries\raggedright}{\thesection}{1em}{}
\titleformat{\subsection}{\normalfont\large\bfseries\raggedright}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\normalfont\normalsize\bfseries\raggedright}{\thesubsubsection}{1em}{}

% \thesisspacing applies the chosen line spacing (setspace is loaded in
% Thesis.tex). Captions are one-and-a-half spaced unless the whole thesis is
% single spaced.
\def\oist@tmp{single}
\ifx\oist@spacing\oist@tmp
	\RequirePackage[font={footnotesize}, labelfont=bf, singlelinecheck=no]{caption} % caption: FIG in bold
	\newcommand{\thesisspacing}{\singlespacing}
\else
	\RequirePackage[font={onehalfspacing, footnotesize}, labelfont=bf, singlelinecheck=no]{caption} % caption: FIG in bold, 1.5 line spacing in figure and table captions
	\def\oist@tmp{double}
	\ifx\oist@spacing\oist@tmp
		\newcommand{\thesisspacing}{\doublespacing}
	\else
		\newcommand{\thesisspacing}{\onehalfspacing}
	\fi
\fi

% A page that holds only figures and tables (a "float page") is filled from the
% top, with the usual space between floats. LaTeX's default centres the floats
% vertically and spreads them apart with stretchable space, which left large
% white gaps above, between and below them.
\setlength{\@fptop}{0pt}
\setlength{\@fpsep}{\floatsep}
\setlength{\@fpbot}{0pt plus 1fil}

% The book class puts an extra 1em above every chapter-level line of the Table
% of Contents (the bold entries: front matter, chapters, Reference List,
% appendices). Combined with the thesis line spacing this made the bold entries
% look further apart than the rest of the Contents. Removing it gives every
% line of the Contents the same spacing as the body text.
\RequirePackage{etoolbox}
\patchcmd{\l@chapter}{\vskip 1.0em \@plus\p@}{}{}%
	{\ClassWarningNoLine{oist_thesis}{Could not remove the extra space above
		chapter entries in the Table of Contents}}

% \unnumberedchapter goes right before \chapter*, which starts a new page. The
% Contents entry and the hyperref anchor have to be placed on that new page, so
% the page is cleared here first. Without the \clearpage both were recorded on
% the previous page: the Contents showed the wrong page number for every
% unnumbered chapter, and clicking an entry jumped to the end of the previous
% section. The \clearpage inside the following \chapter* then does nothing.
\newcommand{\unnumberedchapter}[1]{ % Preparation for unnumbered chapters
	\clearpage % Start the new page now, so the entry and anchor land on it
	\phantomsection % To help hyperref link to the right page
	\addcontentsline{toc}{chapter}{#1} % Also adds the chapter name to the Contents
}

\newcommand{\startpreamble}{
	\frontmatter % Use roman page numbering style (i, ii, iii, iv...) for the preamble pages
	\pagestyle{plain} % plain page number
	\setcounter{page}{2} % Include the title page in page counting
	\thesisspacing % Double or single spacing
}

%-------------------------------------------------------------------------------
%	CATCHING CONTENT THAT SPILLS INTO THE MARGINS
%-------------------------------------------------------------------------------

% Be strict about what counts as "overfull": report even a 0.1pt overshoot,
% so that nothing sneaks into the 2.5cm margins unnoticed.
\hfuzz=0pt
\vfuzz=0pt

% Mark overfull *paragraph* lines with a thick black bar in the margin
% (set to 0pt to disable).
%
% Note the deliberate wording "paragraph lines".  TeX only ever draws this bar
% when it packs a box to a width you asked for, and it goes out of its way not
% to draw it for displayed mathematics:
%
%   * Alignment-based displays -- align, align*, gather, multline, split,
%     alignat, flalign, eqnarray, and also array/tabular -- NEVER get the bar.
%     TeX's alignment routine saves \overfullrule, sets it to 0pt while it
%     packs the alignment and restores it afterwards; the comment in tex.web
%     (section 804, "Package the preamble list") reads "prevent rule from
%     being packaged".  No package or class can change this, it is in the
%     engine.
%
%   * A plain display -- equation, equation*, \[...\] -- does get a bar (see
%     tex.web section 1201, "Squeeze the equation as much as possible"), but
%     TeX appends it at the *end* of the formula rather than at the edge of the
%     text block.  An equation that overshoots by more than 2.5cm therefore
%     puts its bar past the edge of the paper, where you cannot see it.
%
% Both cases are still reported in Thesis.log as "Overfull \hbox (...)", so the
% log is the reliable place to look; ./check_overfull.sh collects them for you.
% The showframe class option draws the text block on every page, which makes an
% over-wide equation obvious at a glance.
%
% Display maths is never broken across lines automatically: if a formula does
% not fit you have to break it yourself with split, multline or align.
\overfullrule=5pt

%-------------------------------------------------------------------------------
%	BUILDING THE TITLE PAGE
%-------------------------------------------------------------------------------

\newcommand\BackgroundPic{% Adding background picture
	\put(-250,-160){%
		\parbox[b][\paperheight]{\paperwidth}{%
			\vfill
			\centering
			\includegraphics[width=\paperwidth]{./Images/symbol.jpg}%
			\vfill
}}}

\RequirePackage{xkeyval} % Handling keyword options.

\newif\if@cosupervisorexist\@cosupervisorexistfalse
\define@key[OIST]{title}{title}{\def\thesistitle{#1}}
\define@key[OIST]{title}{name}{\def\name{#1}}
\define@key[OIST]{title}{supervisor}{\def\supervisor{#1}}
\define@key[OIST]{title}{cosupervisor}{\def\cosupervisor{#1}\@cosupervisorexisttrue}
\define@key[OIST]{title}{submissiondate}{\def\submissiondate{#1}}

\providecommand{\puttitle}{}
\renewcommand{\puttitle}[1]{
	\@puttitle{}{#1}
}

\providecommand{\@puttitle}{}
\renewcommand{\@puttitle}[2]{%
	\setkeys[OIST]{title}{#2}

	\begin{titlepage}
		\AddToShipoutPicture*{\BackgroundPic}
		\begin{center}
			\vfill
			{\large \scshape Okinawa Institute of Science and Technology\\Graduate University}\\[0.7cm]
			{\large Thesis submitted for the degree }\\[0.7cm]
			{\Large Doctor of Philosophy}\\[0.5cm]
			\rule{\textwidth}{1.5pt}\\[0cm]
			{\huge \bfseries \thesistitle \par \ }\\[-0.5cm]
			\rule{\textwidth}{1.5pt}\\[2.5cm]
			\hfill  by\\[1cm]
			\hfill  {\large \bfseries\name}\\
			\vfill
			{\hfill \large Supervisor: \textbf{\supervisor}} \\
			\if@cosupervisorexist{\hfill \large Co-Supervisor: \textbf{\cosupervisor} \\}\else\fi
			\vspace{1cm}
			\hfill  \submissiondate
		\end{center}
	\end{titlepage}
}
