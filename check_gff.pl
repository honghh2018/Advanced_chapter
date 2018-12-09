my %mRNA=();
my %cds=();
my %exon=();

while(<IN>){
        chomp;
        next if(/^\#/);
        my ($mark,$left)=split /\s+/,$_)[3,-1];
        if($mark=~m/gene/i){
                $left=~/ID=(.*);/;
                our $real_gene_id=$1;
                $mRNA{$real_gene_id}{mRNA}=1;
                $cds{$real_gene_id}{cds}=1;
                $exon{$real_gene_id}{exon}=1;
                }elsif($mark=~m/cds/i){
                         $cds{$real_gene_id}{cds}++;
                }elsif($mark =~m/exon/i){
                        $exon{$real_gene_id}{exon}++;
                }elsif($mark =~m/mRNA/){
                        $mRNA{$real_gene_id}{mRNA}++;
                }else{next;}
}


for my $key(sort{$a cmp $b} keys %mRNA){
        if($mRNA{$key}{mRNA}==1){
                print STDOUT "Gene $key miss mRNA\n";
        }
        if($cds{$key}{cds}==1){
                print STDOUT "Gene $key miss CDS\n";
        }
        if($exon{$key}{exon}==1){
                print STDOUT "Gene $key miss exon\n";
        }
}

