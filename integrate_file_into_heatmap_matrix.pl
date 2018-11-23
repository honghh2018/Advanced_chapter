#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use FindBin qw($Bin $Script);
my $dirname;
GetOptions(
	"h|?" => \&USAGE,
	"dn:s"=> \$dirname,
) or &USAGE;

if(!defined $dirname){
	&USAGE;	
}
#/share/nas1/honghh/New_analysis/DEG7540_result/1/Graph/integrate.list
open(OUT,">heatmap.list");
my @file=glob("/share/nas1/honghh/New_analysis/$dirname/*/Graph/integrate.list");
my %file=();
my $filenum=scalar @file;
print "File numbers:\t",$filenum,"\n";
while(<@file>){
	open(IN,"$_") or die $!;
	while(my $line=<IN>){
		chomp$line;
		my $id=(split /\t/,$line)[0];
		$file{$id}=[0];
	}
	close IN;
}

my %file1=();

while(<@file>){
	open(IN,"$_");
	while(my $line=<IN>){
		chomp $line;
		my ($id,$expected)=split /\t/,$line;
		$file1{$id}=$expected;
	}
	for my $key(sort keys %file){
		if(exists $file1{$key}){
			push @{$file{$key}},$file1{$key};
		}else{
			push @{$file{$key}},"0";
		}
	}
	%file1=();
	close IN;

}
#print title
print OUT "ID","\t";
for (my $i=1;$i<$filenum+1;$i++){
	print OUT "K$i","\t";
}
print OUT "\n";

for my $key(keys %file){
	print OUT $key,"\t";
	for(my $i=1;$i<$filenum+1;$i++){
		print OUT ${$file{$key}}[$i],"\t";
	}
	print OUT "\n";
	
}
close OUT;

my $heatmap="/share/nas1/honghh/personality/BMK180323-J141/New_analysis/$dirname/heatmap.list";
`head -n 31 $heatmap > $Bin/$dirname\_30_heatmap.list`;  #get 30 line to draw the plot

sub USAGE{
	my $usage=<<USAGE;
	Usage:
	perl $0 -dn <dirname>
	comment:dirname mean below the dir including the files you want
USAGE
	print $usage;
	exit;
}
