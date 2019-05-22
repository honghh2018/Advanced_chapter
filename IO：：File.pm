#!/usr/bin/perl -w
use strict;
use warnings;
use IO::File; # import symbols
use Getopt::Long;

use vars qw($infile $outfile);

GetOptions(
	"h|?"=>\&USAGE,
	"i:s"=>\$infile,
	"o:s"=>\$outfile,
);



=cut

my $fname = ">testIO::File.txt";

sub main () {
	my $fd = IO::File->new($fname); #opening files to write 
	#$fd = new IO::File($fname);
	print $fd "this sentends;\n";  # write string into <$fd>
	#$fd->setpos($fd->getpos);
	$fd->close();
	undef $fd; # automatically close file handle
}

&main;
=cut

my $fout=IO::File->new(">$outfile");
my $fin=IO::File->new($infile);
while(<$fin>){
	chomp;
	next if($.==1);
	my $gene_id=(split /\t/,$_)[0];
	print $fout $gene_id,"\n";
}
$fin->close();
$fout->close();


sub USAGE{
	print "inputs failed...exit\n";
	exit(1);
}
