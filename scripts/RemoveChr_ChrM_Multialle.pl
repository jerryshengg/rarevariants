# Remove Chr in the Chr column, any ChrM rows, and any multialleles in the VCF file.
# We do this due to the input requirements by cocoRV, because it uses "," to split data

# Change inputs as necessary
open(INFILE, "merged.vcf")||die"";
open(OUTFILE, ">merged.nochrnoChrM_removemultialle.vcf")||die"";
for($ii=0; $ii<35; $ii++){
	$line=<INFILE>;
	print OUTFILE $line;
}
$line=<INFILE>;
#print OUTFILE "Must delete" . $line;
for($ii=36; $ii<64; $ii++){
	$line=<INFILE>;
	$line =~ s/chr//g;
	print OUTFILE $line;
}
while($line=<INFILE>){
	@items=split("\t", $line);
	@items1=split(",", @items[4]);
	if(@items[0] ne "chrM"){
		if(scalar(@items1)==1){
			print OUTFILE substr($line,3);
		}
	}
}
close(INFILE);
close(OUTFILE);
