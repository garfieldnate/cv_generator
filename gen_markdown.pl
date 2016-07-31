use strict;
use warnings;
use IPC::Run3;

@ARGV == 2 or die "Usage: perl gen_markdown.pl bibtex_file output_file";
my ($bibtex_file, $output_file) = @ARGV;

my $stdin = <<"END";
---
bibliography: $bibtex_file
nocite: '\@*'
...

# Bibliography
END
my ( $stdout, $stderr ) = ( '', '' );

my @command = ('C:\Users\Nate\AppData\Local\Pandoc\pandoc',
  '--filter=pandoc-citeproc',
  '--standalone',
  '-t', 'markdown_strict', # don't just print out @* again
  '--columns=1000', # don't split lines
  # '--csl=apa-5th-edition.csl', # use a style from https://github.com/citation-style-language/styles
 '-o', $output_file
);

run3 \@command, \$stdin, \$stdout, \$stderr;

die "something went horribly wrong: $?" if $?;

print "STDOUT\n$stdout\n" if($stdout);
print "STDERR\n$stderr\n" if($stderr);
