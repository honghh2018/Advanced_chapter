The scripts named above comprised bp_genebank2gff3.pl for transferring genebank file from genome into gff3. 

Linux system installed fllowing below step:
tar zxf  BioPerl-1.007001.tar.gz
cd  BioPerl-1.007001
less INSTALL.md and read the installation instructions, then comply with this tip to install the module.
sudo perl -MCPAN -e shell
cpan>install Module::Build
cpan>o conf commit
cpan>exit
$ perl scripts/Bio-DB-GFF/bp_genbank2gff3.pl 
it done.

https://metacpan.org/pod/release/CJFIELDS/BioPerl-1.007001/scripts/Bio-DB-GFF/bp_genbank2gff3.pl
