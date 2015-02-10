use Text::BibTeX;
use autodie;
use strict;
use warnings;

my $bibfile = Text::BibTeX::File->new("pubs.txt");
my $newfile = Text::BibTeX::File->new('> pubs.bib');

while (my $entry = Text::BibTeX::Entry->new($bibfile))
{
   die 'error in input' unless $entry->parse_ok;
   for my $field ($entry->fieldlist){
        # these fields
        if($field =~ /docURL|presURL|tags/i){
            $entry->delete($field);
        }
   }

   $entry->write ($newfile);
}

$newfile->close();

exit if(!@ARGV || $ARGV[0] ne '--biblatex');

# note: Text::BibTeX makes it impossible to use an in-memory file,
# so we have to write, read and write. We should rewrite that
# module as a ::Tiny module.

open my $fh, '<', 'pubs.bib';

my $bib_text;
{
    local $/;
    $bib_text = <$fh>;
    close $fh;
}
# month names have to be braceless for BibLaTeX
$bib_text =~ s/month = {([^}]+)}/month = $1/g;

open $fh, '>', 'pubs.bib';
print $fh $bib_text;

# print $bib_string;
