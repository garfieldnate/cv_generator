use strict;
use warnings;
use Text::BibTeX;
use Path::Tiny;
use autodie;
use Capture::Tiny qw(capture);
my $bibfile = Text::BibTeX::File->new("pubs.bib");

my $bib_template = <<'END';
\documentclass{article}
\usepackage{biblatex}
\bibliography{mybib}
\begin{document}
CITATIONS
\printbibliography
\end{document}
END

my @keys;
while (my $entry = Text::BibTeX::Entry->new($bibfile))
{
    die 'error in input' unless $entry->parse_ok;
    push @keys, $entry->key;
}

my $cite_string = join "\n", map {"\t\\nocite{$_}"} @keys;
$bib_template =~ s/CITATIONS/$cite_string/;
my $temp = path('bibtemp.tex');
my $fh = $temp->openw_utf8;
print $fh $bib_template;
close $fh;
my ($stdout, $stderr) =
    capture {
      system('C:\Users\Nate\AppData\Local\Pandoc\pandoc',
          '--bibliography', 'pubs.bib',
          '-t', 'markdown_strict', # don't just print pandoc citations like [@my_citation]
          '--columns=1000', # don't split lines
          # '--csl=apa-5th-edition.csl', # use a style from https://github.com/citation-style-language/styles
          "$temp")
    };

$temp->remove;



print $stdout;
