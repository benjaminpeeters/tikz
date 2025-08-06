%% timeline.cls
%% A LaTeX class for creating dynamic timelines with TikZ
%% Author: Benjamin Peeters
%% Version: 1.0

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{timeline}[2025/08/06 v1.0 Dynamic Timeline Class]

% Base class
\LoadClass{standalone}

% Required packages
\RequirePackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{shapes.geometric}

% Default configuration parameters - can be overridden by user
\def\startYear{1979}
\def\endYear{1992} 
\def\unitsPerYear{2}
\def\timeStep{3}  % Step between year markers (1=every year, 2=every 2 years, 3=every 3 years, etc.)
\def\nodeLineSpacing{0.8}  % Line spacing multiplier for multi-line node text (0.8 = tighter, 1.2 = looser)

% Define coordinate transformation command
\newcommand{\yearToCoord}[1]{%
  \pgfmathparse{(#1-1979)*2-13}%
  \pgfmathresult%
}

% Short version: x{year} returns the x-coordinate using expandable calc syntax
% Centers the timeline so x=0 is at the middle of the timeline
\newcommand{\x}[1]{(#1-\startYear)*\unitsPerYear - (\endYear-\startYear)*\unitsPerYear/2}

% Define colors for timeline elements
\definecolor{col_trigger}{RGB}{200,100,0}
\definecolor{col_event}{RGB}{0,100,180}
\definecolor{col_superstructure}{RGB}{0,150,50}
\definecolor{col_crisis}{RGB}{180,0,0}

% Define TikZ styles for event types - fully adaptive to content with configurable line spacing
\tikzset{
    trigger/.style={
        regular polygon,
        regular polygon sides=6,
        align=center,
        draw=col_trigger!40, fill=col_trigger!20,
        line width=0.8pt,
        inner sep=-8pt,
        rounded corners=3pt,
        execute at begin node={\linespread{\nodeLineSpacing}\selectfont}
    },
    event/.style={
        ellipse, align=center,
        draw=col_event!40, fill=col_event!20,
        line width=0.8pt,
        inner sep=2pt,
        rounded corners=3pt,
        execute at begin node={\linespread{\nodeLineSpacing}\selectfont}
    },
    superstructure/.style={
        rectangle, align=center,
        draw=col_superstructure!40, fill=col_superstructure!20,
        line width=0.8pt,
        inner sep=2pt,
        rounded corners=3pt,
        execute at begin node={\linespread{\nodeLineSpacing}\selectfont}
    },
    crisis/.style={
        star,
        star points=7,
        align=center,
        draw=col_crisis!40, fill=col_crisis!15,
        line width=0.8pt,
        inner sep=-6pt,
        rounded corners=3pt,
        execute at begin node={\linespread{\nodeLineSpacing}\selectfont}
    }
}

% Command to draw the complete timeline
\newcommand{\drawTimeline}{%
    % Calculate timeline bounds dynamically - centered on x=0
    \pgfmathsetmacro{\timelineStart}{(\startYear-\startYear)*\unitsPerYear - (\endYear-\startYear)*\unitsPerYear/2}%
    \pgfmathsetmacro{\timelineEnd}{(\endYear-\startYear)*\unitsPerYear - (\endYear-\startYear)*\unitsPerYear/2}%
    
    % Timeline using dynamic coordinates
    \draw[gray,thick] (\timelineStart,0) -- (\timelineEnd,0);
    
    % Year markers - automatically generated based on timeStep
    \foreach \year in {\startYear,\the\numexpr\startYear+\timeStep\relax,...,\endYear} {
        \draw[gray] ({\x{\year}},-0.2) -- ({\x{\year}},0.2); 
        \node[below,font=\tiny] at ({\x{\year}},-0.3) {\year};
    }
    % Always include endYear marker if not already covered
    \pgfmathtruncatemacro{\lastRegularYear}{\startYear + \timeStep*floor((\endYear-\startYear)/\timeStep)}%
    \ifnum\lastRegularYear<\endYear
        \draw[gray] ({\x{\endYear}},-0.2) -- ({\x{\endYear}},0.2); 
        \node[below,font=\tiny] at ({\x{\endYear}},-0.3) {\endYear};
    \fi
}

% Command to draw legend - positioned below timeline
\newcommand{\drawLegend}{%
    \begin{scope}[shift={(0,-2)}]
        % Event type legend - properly spaced horizontally
        \node[trigger, minimum height=0.4cm, inner sep=-3] at (-6,0) {\scriptsize Triggers};
        
        \node[event, minimum height=0.4cm] at (-3,0) {\scriptsize Events};
        
        \node[superstructure, minimum height=0.4cm] at (0,0) {\scriptsize Policy\\ \scriptsize Responses};
        
        \node[crisis, minimum height=0.4cm, inner sep=-2] at (3,0) {\scriptsize Crises};
        
        % Arrow types legend
        \draw[->, thick, color=col_trigger] (-7,-.9) -- (-5.8,-.9);
        \node[anchor=west, font=\scriptsize] at (-5.7,-.9) {External Causation};
        
        \draw[->, thick, color=col_event] (-2.5,-.9) -- (-1.3,-.9);
        \node[anchor=west, font=\scriptsize] at (-1.2,-.9) {Financial Transmission};
        
        \draw[->, thick, color=col_superstructure] (2.5,-.9) -- (3.7,-.9);
        \node[anchor=west, font=\scriptsize] at (3.8,-.9) {Policy Impact};
    \end{scope}
}

% End of class file
