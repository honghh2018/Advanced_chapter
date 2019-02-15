#!/usr/bin/perl -w
use strict;
use warnings;
use Cwd qw(abs_path);
use FindBin qw($Bin);
use File::Basename qw(dirname basename fileparse);

if(!defined $ARGV[0]){
        &USAGE;
        exit;
}

my $type=&svg2png($ARGV[1]);
my $achievement=0;


if($type == 0){
        $type=&decompress($ARGV[0]);
        if($type == 1){
                print STDOUT "decompress zip file completedly!\nstart getting substitute...\n";
                my $mark=&substitueAforB($ARGV[1]);
                if($mark == 0){
                        print STDOUT "substitute finished!\n";
                        $achievement=1;
                }else{
                        print STDOUT "substitue failure!\n";
                }
        }
        if($type == 2){
                print STDOUT "decompress tar zxf file completedly!\nstart getting substitute...\n";
                my $mark=&substitueAforB($ARGV[1]);
                if($mark == 0){
                        print STDOUT "substitute finished!\n";
                        $achievement=2;
                }else{
                        print STDOUT "substitue failure!\n";
                }

        }

        if($achievement == 1){
                my $dir="$Bin/.temp";
                &compress($dir,$achievement);
                print STDOUT "All works done!\n";
        }
        if($achievement == 2){
                my $dir="$Bin/.temp";
                &compress($dir,$achievement);
                print STDOUT "All works done!\n";
        }
        `rm -r $Bin/.temp`;

}


sub compress{
        my ($dir,$mark)=@_;
        chdir $dir;
        my $wd=`pwd`;
        print "$wd\n";
        my $basename=basename($ARGV[0]); #prevent to avoid producing result on input dir
        if($mark == 1){
                my $cmd="zip -r $basename.new * && mv $basename.new $Bin/$basename";
                `$cmd`;
        }
        if($mark == 2){
                my $cmd1="tar -czf $basename.new * && mv $basename.new $Bin/$basename";
                `$cmd1`;
        }

}


sub substitueAforB{
        my $file=shift@_;
        my $abs_path=abs_path($file);
        my $wdir="$Bin/.temp";
        my @target=`find $Bin/.temp/ -name $ARGV[1]`;
        while(<@target>){
                if(defined $_){
                        my $dir=dirname($_);
                        `cp $Bin/$ARGV[1] $dir`;
                }else{
                        print STDOUT "your zip file never have $_,please check carefully!\n";
                        return 1;
                }
        }
        return 0;
}

sub svg2png{
        my $file=shift@_;
        my $cmd="/share/nas2/genome/tool/svg2xxx/v1.0/svg2xxx $file -t $ARGV[2]";
        `$cmd`;
        my $png=glob("./*.png");
        $ARGV[1]=$png; #$replace built-in array element with $png
        return 0;
}





sub decompress{
        my $file=shift@_;
        my $abs_path=abs_path($file);
        `mkdir -p "$Bin/.temp"` unless (-d "$Bin/.temp");
        if($abs_path=~m/\.zip/i){
                my $unzip="unzip $abs_path -d $Bin/.temp";
                `$unzip`;
                return(1);
        }
        if($abs_path=~m/\.tgz||\.tar\.gz/i){
                my $tar="tar zxf $abs_path -C $Bin/.temp";
                `$tar`;
                return(2)
        }

}

sub USAGE{
        my $usage=<<"USAGE";
        perl $0 <zipfile> <replacefile> <pictype>
USAGE
        print $usage;
}
