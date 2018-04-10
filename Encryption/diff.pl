#!/usr/bin/perl


sub mydiff {
my($file01,$file02) = @ARGV;
my @file1 = readFile($file01);
my @file2 = readFile($file02);
my $i = 0;
my @buffer;
my @diffrence;
if(scalar@file1 == scalar@file2 && checkSimilar(@file1,@file2))
{
	return @diffrence = ("#endrevision");
}
while($i < scalar@file1 && $i < scalar@file2)
{
	if($file1[$i] eq $file2[$i])
	{
		if(scalar@buffer > 0)
		{
			$buffer[0] = "$buffer[0]c".($i-1);
			push(@diffrence,@buffer);
			@buffer = ();
		}
	}else{
		if(scalar@buffer == 0)
		{
			push(@buffer,$i);
		}
		push(@buffer,@file2[$i]);
	}
	$i++;
}
if(scalar@file1 <= scalar@file2)
{
	if(scalar@buffer == 0)
	{
		push (@buffer,$i);
	}
	$buffer[0] = "$buffer[0]c".(scalar@file2-1);
	for($i;$i<=$#file2;$i++)
	{
		push(@buffer,$file2[$i]);
	}
	push(@diffrence,@buffer);
}
elsif(scalar@file1 > scalar@file2)
{
	if(scalar@buffer > 0)
	{
		$buffer[0] = "$buffer[0]c".(scalar@file2-1);
		push(@diffrence,@buffer);
	}
	push(@diffrence,"$i\d".(scalar@file1-1));
}
push(@diffrence,"#endrevision");
return @diffrence;
}
1;

sub readFile {
	local($file) = @_[0];
	local(@list);
	open(FILE,$file);
	while(<FILE>)
	{
		chomp();
		push(@list,$_);
	}
	close(FILE);
	return @list;
}

sub checkSimilar {
	local(@listA,@listB) = @_;
	for($j=0;$j<=$#listA;$j++)
	{
		if((@listA[$j] cmp @listB[$j]) != 0)
		{
			return false;
		}
	}
	return true;
}

