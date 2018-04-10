#!/usr/bin/perl

($my_dir) = @ARGV;
chomp $my_dir;
print "$my_dir\n";

opendir (DIR, "$my_dir") or die "Couldn't open directory, $!";
while ($file = readdir DIR) {
    print "$file\n";
}
closedir DIR;
