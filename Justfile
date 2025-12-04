# Justfile to generate resume.pdf from resume_short.md using Pandoc and xelatex
# Assumes RHEL 8/9
# Input: resume_short.md (Markdown resume content)
# Template: resume_template.tex (Pandoc LaTeX template)
# Output: resume.pdf

typst:
	echo "Generating resume.pdf using Typst..."
	typst compile perpetual_calendar.typ perpetual_calendar.pdf

watch:
	echo "Recompiling after change detection..."
	typst watch perpetual_calendar.typ perpetual_calendar.pdf

booklet:
	echo "Imposing PDF into 2up booklet..."
	pdfbook2 --paper letterpaper perpetual_calendar.pdf

