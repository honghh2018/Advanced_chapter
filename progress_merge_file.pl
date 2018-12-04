#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;


my ($gff,$anno,$fa,$deg,$out);
GetOptions(
	"h|?" => \&USAGE,
	"gff:s" => \$gff,
	"ann:s" => \$anno,
	"fa:s" => \$fa,
	"deg:s" => \$deg,
	"o:s" => \$out,
) or &USAGE;

&USAGE unless(defined $gff or defined $anno or defined $fa);

open(IN,"$gff") or die $!;
my %gff=();
while(<IN>){
	chomp;		
	next if(/^\#/);
	my $mark=(split /\s+/,$_)[2];
	if($mark =~/gene/i){
		my ($chro,$start,$end,$left)=(split /\s+/)[0,3,4,-1];
		my $real_gene_name=(split /\;/,(split /\=/,$left)[1])[0];
		$gff{$chro}{$real_gene_name}=[$start,$end];
	}
}
close IN;
my %anno=();
my $head="";
open(IN,"$anno") or die $!;
while(<IN>){
	chomp;
	if(/^GeneID/){
		$head=$_;
		next;	
	}
	my ($gene_name,$left)=split /\s+/,$_,2;
	$anno{$gene_name}=$left;
}
close IN;


$/=">";
my %fa=();
open(IN,"$fa") or die $!;
while(<IN>){
	chomp;
	next if(/^$/);
	my ($gene,$seq)=split /\n+/,$_,2;
	my $real_gene=(split /\s+/,$gene)[0];
	$seq=~s/\n+//g;
	$fa{$real_gene}=$seq;
}
$/="\n";
close IN;

open(IN,"$deg") or die $!;
open(OUT,">$out");
while(<IN>){
	chomp;
	my ($gene,$left)=split /\s+/,$_,2; 	
	if(/\#ID/){
		print OUT $_,"\t","chr","\t","start","\t","end","\t","$head","\t","fa","\n";
		next;
	}
	for my $chro(sort {$a cmp $b} keys %gff){
		if(exists $gff{$chro}{$gene}){
			if(exists $anno{$gene}){
  				if(exists $fa{$gene}){
					print OUT $_,"\t",$chro,"\t",${$gff{$chro}{$gene}}[0],"\t",${$gff{$chro}{$gene}}[1],"\t",$anno{$gene},"\t",$fa{$gene},"\n";
                		}
        		 }
                }

	}	
}

close IN;
close OUT;

sub USAGE{
	my $usage=<<"USAGE";
	Usage:
	perl $0 -gff <gff3> -ann <anno> -fa <fa> -deg <deg> -o <outname>
USAGE
	print $usage;
	exit;
}
