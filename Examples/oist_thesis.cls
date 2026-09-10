
% A LaTeX2e class for thesis submissions to
% Okinawa Institute of Science and Technology (OIST):
%
% Tadashi Kozuno (tadashi.kozuno@gmail.com)
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{oist_thesis}[2019/3/17 OIST thesis submission class]

\newif\if@final\@finaltrue
\DeclareOption{temporary}{\@finalfalse}
\DeclareOption{final}{\@finaltrue}

% Draft aid: draw the boundary of the text block on every page, so that
% anything spilling into the 2.5cm margins (long equations in particular) is
% impossible to miss.  Purely visual, changes no dimension.  Use it while you
% write, remove it before you submit:
%     \documentclass[temporary,showframe]{oist_thesis}
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
\titleformat{\chapter}[display]{\normalfont\huge\bfseries\raggedright}{\chaptertitlename\ \thechapter}{20pt}{\LARGE}
% 0 left, -35pt top, 20pt bottom.
%
% The top value is negative on purpose. With 0pt the first line of a chapter
% heading still sat about 1.4cm below where body text starts on an ordinary
% page, because titlesec measures from the first baseline and a \huge line
% reserves far more headroom than a 12pt one. Chapter pages therefore looked
% like they had a much bigger top margin than every other page.
%
% -35pt lines an unnumbered chapter (Abstract, Introduction, Table of Contents)
% up exactly with body text. A numbered chapter still starts about 2mm lower,
% because its first line is the \huge "Chapter N" rather than the \LARGE title
% and a single spacing value has to serve both. Do not push this further: at
% -40pt the unnumbered chapters rise above the 2.4cm top margin.
\titlespacing{\chapter}{0pt}{-35pt}{20pt}

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

\if@final
    \RequirePackage[font={footnotesize}, labelfont=bf, singlelinecheck=no]{caption} % caption: FIG in bold
	\newcommand{\thesisspacing}{\singlespacing}
\else
	\RequirePackage[font={onehalfspacing, footnotesize}, labelfont=bf, singlelinecheck=no]{caption} % caption: FIG in bold, 1.5 line spacing in figure and table captions
	\newcommand{\thesisspacing}{\doublespacing}
\fi

\newcommand{\unnumberedchapter}[1]{ % Preparation for unnumbered chapters
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
