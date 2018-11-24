#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use Getopt::Long;

my ($infile,$num);
GetOptions(
	"h|?" => \&USAGE,
	"-s:s" => \$num,
	"-in:s" => \$infile,
);

if(!defined $num or !defined $infile){
	&USAGE;
}
$num ||=0.01;
my $basename=basename($infile);
open(OUT,">$basename\_result");

while(<IN>){
	chomp;
	if(/id||\#||ID/){
		print OUT $_,"\n";
		next;
	}
	my @array=split /\s+/,$_;
	for(my $i=0;$i<=$#array;$i++){
		if($array[$i] eq '0'){
			if($i==$#array){ #delete end tab key
				$array[$i]=$num;
				print OUT $array[$i];
			}else{
				$array[$i]=$num;
				print OUT $array[$i],"\t";
			}
		}else{
			if($i==$#array){
				print OUT $array[$i];		
			}else{
				print OUT $array[$i],"\t";
			}
		}
	}
	print OUT "\n";
	
}
close IN;
close OUT;


sub USAGE{
	my $usage=<<USAGE;
	Contact:939869915\@qq.com
	Usage:
	perl $0 --s [number] --in FPKM_file
	Number Default:0.01
	The file that was output default with name infile name added _result
USAGE
	print $usage;	
	exit;
}
