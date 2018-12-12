use warnings;
use Getopt::Long;
use File::Basename qw(basename fileparse dirname);
my ($structure,$num,$pep,$mask);
GetOptions(
	"h|?" => \&USAGE,
	"ds:s" => \$structure,
	"m:s" =>\$mask,
	"cutoff:s"=>\$num,
	"in:s" => \$pep,

) or &USAGE;
&USAGE unless(defined $structure or defined $num or defined $pep);
my $basename=basename($pep);
open(IN,"$pep") or die $!;
open(OUT,">$basename\.result");
$/=">";
while(<IN>){
	chomp;
	next if(/^$/);
	my ($mark,$seq)=split /\n+/,$_,2;
	my $real_gene_id=(split /::/,$mark)[1];
	$seq =~s/\n//g;
	my @array=split /$structure/,$seq;
	if(scalar@array >= $ARGV[1]){
		print OUT ">",$real_gene_id,"\n";
		print OUT $seq,"\n";
		$seq=~s/$structure/\*{$mark}/g;
		print OUT $seq,"\n";
	}
	
}
$/="\n";
close IN;

sub USAGE{
	my $usage=<<USAGE;
	usage:
	perl $0 -ds <TC[A-Za-z]> -m 3 -cutoff <num> -in <protein.fa>

USAGE
	print $usage,"\n";
	exit;
}
