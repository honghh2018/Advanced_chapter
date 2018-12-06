#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use List::Util;

my ($fa,$gff3,$out);

GetOptions(
	"h|?" => \&USAGE,
	"fa:s" => \$fa,
	"gff:s" => \$gff3,
	"o:s" => \$out,
) or &USAGE;

&USAGE unless(defined $fa or defined $gff3);
my %gff3=();
my %gene=();
my $gene_name="";
my $mRNA_name="";
open(IN,"$gff3") or die $!;
while(<IN>){
	chomp;
	next if(/^\#/);
	my ($chro,$mark,$start,$end,$strand,$left)=(split /\s+/,$_)[0,2,3,4,6,-1];
	if($mark =~/Gene/i){
		$gene{$mark} +=1; #statistic the gene numbers
		$gene_name=(split /\;/,(split /\=/,$left)[1])[0];
	}elsif($mark =~/mRNA/i){
		$mRNA_name=(split /\;/,(split /\=/,$left)[1])[0];
                	$gene{$mark} +=1;
	}elsif($mark =~ /CDS/i){
		my $cds_name=(split /\;/,(split /\=/,$left)[1])[0];
		$gff3{$chro}{$gene_name}{$mRNA_name}{$mark}{$cds_name}=[$start,$end];
		
	}else{
		my $parent_name=(split /\=/,$left)[2];
		if($mark =~/exon/i && $parent_name eq $mRNA_name){
			$gene{$mark} +=1;
		}
	}
	

}
close IN;


open(IN,"$fa") or die $!;
$/=">";
my %fa=();
while(<IN>){
	chomp;
	next if(/^$/);
	my ($chro_id,$seq)=split /\n+/,$_,2;
	my $real_chro=(split /\s+/,$chro_id)[0];
	$seq=~s/\n//g;
	$fa{$real_chro}=$seq;
}
close IN;
$/="\n";


open(OUT,">$out");
foreach my $fa_chro(sort {$a cmp $b||$a<=>$b} keys %fa){
        if(exists $gff3{$fa_chro}){
                for my $gene_name(keys %{$gff3{$fa_chro}}){
                        for my $mRNA_name(keys %{$gff3{$fa_chro}{$gene_name}}){
				for my $cds_name(keys %{$gff3{$fa_chro}{$gene_name}{$mRNA_name}}){
					my $seq="";
					for my $cds_id(sort {$a cmp $b||$a<=>$b} keys %{$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}}){
						my $length=abs(${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[1]-${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[0]);
						$seq .=substr($fa{$fa_chro},${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[0],$length+1);
						
					}
					print OUT ">",$gene_name,"\t",$mRNA_name,"\n";
                                	print OUT $seq,"\n"
				}
                        }

                }
        }

}

close OUT;


sub USAGE{
	my $usage=<<USAGE;
	Contact:honghh\@biomarker.com.cn
	perl $0 -fa <fa> -gff <gff3> -o outname
USAGE
	print $usage;
	exit;
}

＃＃＃modify
#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use List::Util;
my $begin_time=time();

my ($fa,$gff3,$out);

GetOptions(
	"h|?" => \&USAGE,
	"fa:s" => \$fa,
	"gff:s" => \$gff3,
	"o:s" => \$out,
) or &USAGE;

&USAGE unless(defined $fa or defined $gff3);
my %gff3=();
my %gene=();
my %gene1=();
my $gene_name="";
my $mRNA_name="";
my $gene_count=0;
my $mRNA_count=0;

#condition to judgement with gene,  mRNA, cds or exon






open(IN,"$gff3") or die $!;
while(<IN>){
	chomp;
	next if(/^\#/);
	my ($chro,$mark,$start,$end,$strand,$left)=(split /\s+/,$_)[0,2,3,4,6,-1];
	if($mark =~m/gene/i){
		$gene{$mark} +=1; #statistic the gene numbers
		$gene_name=(split /\;/,(split /\=/,$left)[1])[0];
		$gene_count++;
	}elsif($mark =~m/mRNA/i){
		$mRNA_name=(split /\;/,(split /\=/,$left)[1])[0];
                $gene{$mark} +=1;
		$mRNA_count++;
	}elsif($mark =~m/CDS/i){
		my $cds_name=(split /\;/,(split /\=/,$left)[1])[0];
		$gff3{$chro}{$gene_name}{$mRNA_name}{$mark}{$cds_name}=[$start,$end];
		$gene1{$gene_name}{$mark} +=1;
		
	}elsif($mark =~m/exon/i){
			$gene1{$gene_name}{$mark} +=1;
	}else{
		next;
	}
	

}
close IN;
open(IN,"$fa") or die $!;
$/=">";
my %fa=();
while(<IN>){
	chomp;
	next if(/^$/);
	my ($chro_id,$seq)=split /\n+/,$_,2;
	my $real_chro=(split /\s+/,$chro_id)[0];
	$seq=~s/\n//g;
	$fa{$real_chro}=$seq;
}
close IN;
$/="\n";


open(OUT,">$out"); #output paste CDS through gene gff3 annotation
open(LOG,">gff3.statistic.list"); #output statistic file

for my $fa_chro(sort {$a cmp $b} keys %fa){
        if(exists $gff3{$fa_chro}){
		print $fa_chro,"\n";
                for my $gene_name(keys %{$gff3{$fa_chro}}){
                        for my $mRNA_name(keys %{$gff3{$fa_chro}{$gene_name}}){
				for my $cds_name(keys %{$gff3{$fa_chro}{$gene_name}{$mRNA_name}}){
					my $seq="";
					for my $cds_id(sort {$a cmp $b} keys %{$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}}){
						my $length=abs(${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[1]-${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[0]);
						$seq .=substr($fa{$fa_chro},${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[0],$length+1);
						
					}
					print OUT ">",$gene_name,"\t",$mRNA_name,"\n";
                                	print OUT $seq,"\n";
				}
                        }

                }
        }

}
close OUT;
print LOG "Gff3 statistic below:\n";
print LOG "Genenumber:\t",$gene_count,"\t";
print LOG "mRNAnumber:\t",$mRNA_count,"\n";
print LOG "Gene_ID\tCDS_num\texon_num\n";

for my $gene(sort {$a cmp $b} keys %gene1){
	for my $mark(sort {$a cmp $b} keys %{$gene1{$gene}}){
		if($mark =~m/exon/i){
			print LOG "\t","Exon_number:",$gene1{$gene}{$mark},"\t";
		}elsif($mark =~m/cds/i){
			print LOG $gene,"\t","Cds_number:",$gene1{$gene}{$mark},"\t";
		}
	}
	print LOG "\n";
}
close LOG;

my $end_time=time();
my $elapse=$end_time-$begin_time;

print STDOUT "Total elapse time:","$elapse\n";
print STDOUT "All works downed\n";

sub USAGE{
	my $usage=<<USAGE;
	Contact:honghh\@biomarker.com.cn
	perl $0 -fa <fa> -gff <gff3> -o outname
USAGE
	print $usage;
	exit;
}


#end



#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use List::Util;
my $begin_time=time();

my ($fa,$gff3,$out);

GetOptions(
	"h|?" => \&USAGE,
	"fa:s" => \$fa,
	"gff:s" => \$gff3,
	"o:s" => \$out,
) or &USAGE;

&USAGE unless(defined $fa or defined $gff3);
my %gff3=();
my %gene=();
my %gene1=();
my $gene_name="";
my $mRNA_name="";
my $gene_count=0;
my $mRNA_count=0;

#condition to judgement with gene,  mRNA, cds or exon






open(IN,"$gff3") or die $!;
while(<IN>){
	chomp;
	next if(/^\#/);
	my ($chro,$mark,$start,$end,$strand,$left)=(split /\s+/,$_)[0,2,3,4,6,-1];
	if($mark =~m/gene/i){
		$gene{$mark} +=1; #statistic the gene numbers
		$gene_name=(split /\;/,(split /\=/,$left)[1])[0];
		$gene_count++;
	}elsif($mark =~m/mRNA/i){
		$mRNA_name=(split /\;/,(split /\=/,$left)[1])[0];
                $gene{$mark} +=1;
		$mRNA_count++;
	}elsif($mark =~m/CDS/i){
		my $cds_name=(split /\;/,(split /\=/,$left)[1])[0];
		$gff3{$chro}{$gene_name}{$mRNA_name}{$mark}{$cds_name}=[$start,$end];
		$gene1{$gene_name}{$mark} +=1;
		
	}elsif($mark =~m/exon/i){
			$gene1{$gene_name}{$mark} +=1;
	}else{
		next;
	}
	

}
close IN;
open(IN,"$fa") or die $!;
$/=">";
my %fa=();
while(<IN>){
	chomp;
	next if(/^$/);
	my ($chro_id,$seq)=split /\n+/,$_,2;
	my $real_chro=(split /\s+/,$chro_id)[0];
	$seq=~s/\n//g;
	$fa{$real_chro}=$seq;
}
close IN;
$/="\n";


open(OUT,">$out"); #output paste CDS through gene gff3 annotation
open(LOG,">gff3.statistic.list"); #output statistic file

for my $fa_chro(sort {$a cmp $b} keys %fa){
        if(exists $gff3{$fa_chro}){
		print $fa_chro,"\n";
                for my $gene_name(keys %{$gff3{$fa_chro}}){
                        for my $mRNA_name(keys %{$gff3{$fa_chro}{$gene_name}}){
				for my $cds_name(keys %{$gff3{$fa_chro}{$gene_name}{$mRNA_name}}){
					my $seq="";
					for my $cds_id(sort {$a cmp $b} keys %{$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}}){
						my $length=abs(${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[1]-${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[0]);
						$seq .=substr($fa{$fa_chro},${$gff3{$fa_chro}{$gene_name}{$mRNA_name}{$cds_name}{$cds_id}}[0],$length+1);
						
					}
					print OUT ">",$gene_name,"\t",$mRNA_name,"\n";
                                	print OUT $seq,"\n";
				}
                        }

                }
        }

}
close OUT;
print LOG "Gff3 statistic below:\n";
print LOG "Genenumber:\t",$gene_count,"\t";
print LOG "mRNAnumber:\t",$mRNA_count,"\n";
print LOG "Gene_ID\tCDS_num\texon_num\n";

for my $gene(sort {$a cmp $b} keys %gene1){
	for my $mark(sort {$a cmp $b} keys %{$gene1{$gene}}){
		if($mark =~m/exon/i){
			print LOG "\t","Exon_number:",$gene1{$gene}{$mark},"\t";
		}elsif($mark =~m/cds/i){
			print LOG $gene,"\t","Cds_number:",$gene1{$gene}{$mark},"\t";
		}
	}
	print LOG "\n";
}
close LOG;

my $end_time=time();
my $elapse=$end_time-$begin_time;

print STDOUT "Total elapse time:","$elapse\n";
print STDOUT "All works downed\n";

sub USAGE{
	my $usage=<<USAGE;
	Contact:honghh\@biomarker.com.cn
	perl $0 -fa <fa> -gff <gff3> -o outname
USAGE
	print $usage;
	exit;
}


#end


