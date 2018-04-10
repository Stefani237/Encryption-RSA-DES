#!/usr/bin/perl -w

$numArgs = $#ARGV + 1;

my @words = split /\\\//, $ARGV[0];
my $newword = $ARGV[0];
$newword =~  s/\\\//%/g;
print "$newword\n";

# Print the value of the command line arguments
@words = split /\//, $ARGV[0];
if ($words[0] eq 's'){

   if ($numArgs == 3){

      open INPUTFILE, "<", $ARGV[1] or die $!;
      open OUTPUTFILE, ">", $ARGV[2] or die $!;
   
      if (0+@words == 4){
         if  ($words[3] eq 'g'){ 
            my @lines = <INPUTFILE>;
            my @newlines;
   
            foreach(@lines) {
               $_ =~ s/$words[1]/$words[2]/g;
               push(@newlines,$_);
            }
            print OUTPUTFILE @newlines;
         }
      }else{
            my @lines = <INPUTFILE>;
            my @newlines;
   
            foreach(@lines) {
               $_ =~ s/$words[1]/$words[2]/;
               push(@newlines,$_);
            }
            print OUTPUTFILE @newlines;
      }
      close(INPUTFILE);
      close(OUTPUTFILE);
   } elsif ($numArgs == 2) {
      open INPUTFILE, "<", $ARGV[1] or die $!;
      if (0+@words == 4){
         if  ($words[3] eq 'g'){
            my @lines = <INPUTFILE>;
            my @newlines;

            foreach(@lines) {
               $_ =~ s/$words[1]/$words[2]/g;
               push(@newlines,$_);
            }
            print OUTPUTFILE @newlines;
         }
      }else{
            my @lines = <INPUTFILE>;
            my @newlines;

            foreach(@lines) {
               $_ =~ s/$words[1]/$words[2]/;
               push(@newlines,$_);
            }
            print OUTPUTFILE @newlines;
      }
      

   }
}else{
   print("sed: -e expression #1, char 2: extra characters after command\n");
}
