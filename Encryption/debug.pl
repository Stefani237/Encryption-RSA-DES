
sub convertToBinary{

print "content: $bits\n";
$binary = unpack('B*',"$bits");
return $binary;
}
sub backToString{
my $s = "$_";
my $b_str=@_[0];
$s=pack('B*',"$b_str");
return $s;

}

sub build_pc1_table{

$number=57;
@array=();
$start=$number;

for($i=0; $i<28; $i=$i+1){

$array[$i]=$number;

if(($number-8)<0){

$start=$start+1;
$number=$start;
}

else{

$number=$number-8;
}

}
        


$start=63;
$number2=$start;

for($i=28;$i<56;$i=$i+1){

$array[$i]=$number2;
if(($number2-8)<0){

if($number2==5){
$start=$number+1;
}
$start=$start-1;
$number2=$start;
}

else{

$number2=$number2-8;
}
}

return @array;

}

sub shiftLeft{

$s = @_[0];
my @arr = (@_)[1..29];
print "before shift \n";
print @arr;
print "\n";
print $s;
print "\n";

$first=@arr[0];
if($s==2){
$second=@arr[1];
}
for($i=0;$i<28-$s;$i=$i+1){
$temp=@arr[$i+$s];
@arr[$i]=$temp;
}

if($s==1){
@arr[27]=$first;
}
else{
@arr[27]=$second;
@arr[26]=$first;
}


return @arr;
}

sub create_key{

@pc_2=(14,17,11,24,1,5,3,28,15,6,21,10,23,19,12,4,26,8,16,7,27,20,13,2,41,52,31,37,47,55,30,40,51,45,33,48,44,49,39,56,34,53,46,42,50,36,29,32);

#convert fron string to binary

#$key_init="kerenlao";
#$b_key_init=unpack('B*',$key_init);
$b_key_init="0001001100110100010101110111100110011011101111001101111111110001";
print "\n key =  $b_key_init \n";
@init_key_arr=split('',$b_key_init);

#check if conversion done well

print "\n";

#create pc_1 table
@pc_1=build_pc1_table();

#create 56 bits binary number;

print "\n pc bits \n";

@fifty_six_key=();
for(my $i=0;$i<56;$i=$i+1){
$bit_index=@pc_1[$i]-1;
print " index = $bit_index ";
@fifty_six_key[$i]=@init_key_arr[$bit_index];
print " @fifty_six_key[$i] ";
}

print "\n";

#check new key array
#print "\n";
#print "\n";
#print scalar  @fifty_six_key;

@l_key=@fifty_six_key[0..27];
@r_key=@fifty_six_key[28..55];

#print "\n";
#print "\n";
#print scalar  @l_key;
#print "\n";
#print "\n";
#print scalar @r_key;
#print "\n";
#print "\n";
@keys=();

#create 16 sub keys
for($j=0;$j<16;$j=$j+1){
if($j==0||$j==1||$j==8||$j==15){
@l_key=shiftLeft(1,@l_key);
@r_key=shiftLeft(1,@r_key);
}
else{
@l_key=shiftLeft(2,@l_key);
@r_key=shiftLeft(2,@r_key);
}
#print "\n";
#print "\n left after shift:\n";
#print @l_key;
#print "\n";

#print "\n right after shift: \n";
#print @r_key;
#print "\n";
#temp_k=();
@mix_arr=();
for($i=0;$i<28; $i=$i+1){
@mix_arr[$i]= @l_key[$i];
}

for($i=0;$i<28; $i=$i+1){
@mix_arr[28+$i]= @r_key[$i];
}

#@mix_arr[0..28]=@l_key;
#@mix_arr[28..56]=@r_key;
#print "mix arr = @mix_arr \n";
for($i=0;$i<scalar @pc_2; $i=$i+1){
$index=@pc_2[$i]-1;
@temp_k[$i]=@mix_arr[$index];
}

#print "\n";
#print "48 bits key is : \n";
#print @temp_k;
#print "\n";

@keys[$j]=join("",@temp_k);
#print "\n";
#print "final key: \n";
#print @keys[$i];
}

}

sub init_permutation{

@IP=();
#print "\n before permutation: \n";
#print @arr2;
#print "\n";

@IP[0]=58;
$count=0;
for(my $i=1;$i<32;$i=$i+1){
if((@IP[$i-1]-8)>0){
@IP[$i]=@IP[$i-1]-8;
}
else{
$count=$count+1;
@IP[$i]=@IP[0]+$count*2;

}
}

@IP[32]=57;
$count=0;

for(my $i=33;$i<64;$i=$i+1){
if((@IP[$i-1]-8)>0){
@IP[$i]=@IP[$i-1]-8;
}
else{
$count=$count+1;
@IP[$i]=@IP[32]+$count*2;
}
}

#print "\n";
for(my $i=0;$i<64;$i=$i+1){
 @bits[$i]=@arr2[@IP[$i]-1];
 }
 }

sub E{

my @arr =@_;
print "\n sub e : print input arr: \n";
print "\n @arr \n";
@e_r=();
@e=();
@e[0]=32;
@e[1]=1;
@e[47]=1;

for($i=2;$i<47;$i=$i+1){

if($i%6==0){
@e[$i]=@e[$i-2];
}

else{
@e[$i]=@e[$i-1]+1;
}
}

print "\n e sub \n";
for($i=0;$i<scalar @e; $i=$i+1){
@e_r[$i]=@arr[@e[$i]-1];
print " @e[$i] ";
}
}

sub xor2{

$b1=@_[0];
$b2=@_[1];
my $result=0;

if($b1==1 && $b2 ==1){
$result=0;
}

if($b1==1 && $b2 ==0){
$result=1;
}

if($b1==0 && $b2 ==1){
$result=1;
}

if($b1==0 && $b2 ==0){
$result=0;
}

return $result;
}

sub xorArrs{

$length=scalar @_;
$middle=$length/2;
my @arr1= @_[0..($middle-1)];
my @arr2= @_[$middle..($length-1)];
my @xor_res=();
print "\n";
print " arr1: \n";
print @arr1;
print "\n arr2: \n";
print @arr2;

for($i=0;$i<$middle;$i=$i+1){
@xor_res[$i]=xor2(@arr1[$i],@arr2[$i]);
}

return @xor_res;
}

sub toFormat{
my $str=@_[0];
my $remain_b=4-length($str);
my $new_format="$_";

for($i=0;$i<$remain_b;$i=$i+1){
$new_format=$new_format.'0';
}
$str=$new_format.$str;
return $str;
}

sub sBox{

my @b_arr=@_;
my $num=0;
my $s_count=0;
@s1=

(14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7,0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8,
 4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0,15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13);

@s2=

(15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10,3,13,4,7,15,2,8,14,12,0,1,10,6,

9,11,5,0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15,13,8,10,1,3,15,4,2,11,6,7

,12,0,5,14,9);

@s3=

(10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8,13,7,0,9,3,4,6,10,2,8,5,14,12,11,

15,1,13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7,1,10,13,0,6,9,8,7,4,15,14

,3,11,5,2,12);

@s4=

(7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15,13,8,11,5,6,15,0,3,4,7,2,12,1,10

,14,9,10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4,3,15,0,6,10,1,13,8,9,4,5,

11,12,7,2,14);

@s5=

(2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9,14,11,2,12,4,7,13,1,5,0,15,10,3

,9,8,6,4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14,11,8,12,7,1,14,2,13,6,15,

0,9,10,4,5,3);

@s6=

(12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11,10,15,4,2,7,12,9,5,6,1,13,14,0,

11,3,8,9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6,4,3,2,12,9,5,15,10,11,14,

1,7,6,0,8,13);

@s7=

(4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1,13,0,11,7,4,9,1,10,14,3,5,12,2,

15,8,6,1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2,6,11,13,8,1,4,10,7,9,5,0,

15,14,2,3,12);

@s8=

(13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7,1,15,13,8,10,3,7,4,12,5,6,11,0,

14,9,2,7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8,2,1,14,7,4,10,8,13,15,12,

9,0,3,5,6,11);

$s_count=0;
$new_r="$_";
for(my $i=0;$i<scalar @b_arr; $i=$i+6){

if($s_count==0){@s_table=@s1[0..63];}
if($s_count==1){@s_table=@s2[0..63];}
if($s_count==2){@s_table=@s3[0..63];}
if($s_count==3){@s_table=@s4[0..63];}
if($s_count==4){@s_table=@s5[0..63];}
if($s_count==5){@s_table=@s6[0..63];}
if($s_count==6){@s_table=@s7[0..63];}
if($s_count==7){@s_table=@s8[0..63];}

$b_row="$_";
$b_row=$b_row.(@b_arr[$i]);
$b_row=$b_row.(@b_arr[$i+5]);
#print " \n binary row = $b_row \n";
$bin_col=join('',@b_arr[($i+1)..($i+4)]);
$row=oct("0b$b_row");
#print " \n integer row = $row \n";
$col=oct("0b$bin_col");
#print "\n binary col = $bin_col \n";
#print " \n integer col = $col \n";
#print "\n";
#print  @s_table;
#print "\n";
$s_sum=$row*16+$col;
#print "\n sum = $s_sum \n";
$val=@s_table[$s_sum];
#print "\n new value = $val \n";
$s_count=$s_count+1;
$b_value2="$_";
$b_value=sprintf( "%B", $val);
$b_size=length($b_value);
#print "\n string size: $b_size \n";
$b_value2=$b_value;
for($j=0;$j<(4-length($b_value));$j=$j+1){
$b_value2='0'.$b_value2;
}
#print "\n binary: $b_value2 \n";
$new_r=$new_r.$b_value2;

}
}

sub p_sbox{

my @s_arr=@_;
my @P= (16,7,20,21,29,12,28,17,1,15,23,26,5,18,31,10,2,8,24,14,32,27,3,9,19,13,
        30,6,22,11,4,25);
my @new_s_arr=();

for(my $i=0;$i<scalar @P;$i=$i+1){

@new_s_arr[$i]=@s_arr[@P[$i]-1];

}

return @new_s_arr;
}

sub inverse_p{

my @arr=@_;
my @P_inv=(9,17,23,31,13,28,2,18,24,16,30,6,26,20,10,1,8,14,25,3,4,29,11,19,32,
12,22,7,5,27,15,21);
my @new_s_arr=();

for(my $i=0;$i<scalar @P_inv;$i=$i+1){

@new_s_arr[$i]=@arr[@P_inv[$i]-1];

}
return @new_s_arr;

}

sub lastPermutation{

my $bin_string=@_[0];

my @IP_reverse=

(40,8,48,16,56,24,64,32,39,7,47,15,55,23,63,31,38,6,46,14,54,22,62,30,

37,5,45,13,53,21,61,29,36,4,44,12,52,20,60,28,35,3,43,11,51,19,59,27,34,

2,42,10,50,18,58,26,33,1,41,9,49,17,57,25);

my @bin_str_arr=split('',$bin_string);
my @new_arr=();

for(my $i=0; $i<scalar @bin_str_arr; $i=$i+1){
@new_arr[$i]=@bin_str_arr[@IP_reverse[$i]-1];
}

my $new_str= join('',@new_arr);
return $new_str;

}

sub perform_des{

my $per_type=@_[0];
#$r_str="0000000100100011010001010110011110001001101010111100110111101111";
#@bits=split('',$r_str);
#@arr2=@bits;
#print "\n text befor enc: \n";
#print "\n @bits \n";
#init_permutation();
#print "after permutation: \n";
#print @bits;

#print "\n";
#@l=@bits[0..31];
#print "left: \n";
#print @l;
#print "\n";
#@r=@bits[32..63];
#@new_r_arr=@r;

#$key_help="000110110000001011101111111111000111000001110010";

if($per_type==0){
#$r_str="11110000101010101111000010101010";
#$r_str="0000000100100011010001010110011110001001101010111100110111101111";
#@bits=split('',$r_str);
#@arr2=@bits;
print "\n text befor enc: \n";
print "\n @arr2 \n";
init_permutation();
print "after permutation: \n";
print @bits;

print "\n";
@l=@bits[0..31];
print "left: \n";
print @l;
print "\n";
@r=@bits[32..63];
@new_r_arr=@r;

for($index_d=0;$index_d<16;$index_d=$index_d+1){
#print "\n right string: \n";
#print "\n $r_str \n";
#@new_r_arr=split('',$r_str);
print "\n right: \n";
print @new_r_arr;
print "\n key: $index_d \n";
print "\n @keys[$index_d] \n";
@temp=@new_r_arr;
E(@new_r_arr);
print "\n after expention \n";
print @e_r;
#@bits_key=split('',@keys[$index_d]);
@bits_key=split('',@keys[$index_d]);
@x_results=xorArrs(@e_r,@bits_key);
print "\n";
print "xor right with key: \n";
print @x_results;
print "\n sbox : \n";
sBox(@x_results);
@s_arr=split('',$new_r);
print "\n right after sbox \n";
print "\n @s_arr \n";
@new_r_arr=p_sbox(@s_arr);
print "\n right after p \n";
print "\n @new_r_arr \n";
print "\n left: \n";
print "\n @l \n";
@new_r_arr=xorArrs(@new_r_arr,@l);
print "\n new right $index_d \n";
print "\n @new_r_arr \n";
@l=@temp;
print "\n temp = \n";
print @temp;
print "\n";
print "\n new left $index_d \n";
print "\n @l \n";

#}
 }
}

else{

print "\n text befor enc: \n";
print "\n @arr2 \n";
init_permutation();
print "after permutation: \n";
print @bits;

print "\n";
@l=@bits[0..31];
print "left: \n";
print @l;
print "\n";
@r=@bits[32..63];
@new_r_arr=@r;

for($index_d=15;$index_d>=0;$index_d=$index_d-1){
#print "\n right string: \n";
#print "\n $r_str \n";
#@new_r_arr=split('',$r_str);
print "\n right: \n";
print @new_r_arr;
print "\n key: $index_d \n";
print "\n @keys[$index_d] \n";
@temp=@new_r_arr;
E(@new_r_arr);
print "\n after expention \n";
print @e_r;
#@bits_key=split('',@keys[$index_d]);
@bits_key=split('',@keys[$index_d]);
@x_results=xorArrs(@e_r,@bits_key);
print "\n";
print "xor right with key: \n";
print @x_results;
print "\n sbox : \n";
sBox(@x_results);
@s_arr=split('',$new_r);
print "\n right after sbox \n";
print "\n @s_arr \n";
@new_r_arr=p_sbox(@s_arr);
print "\n right after p \n";
print "\n @new_r_arr \n";
print "\n left: \n";
print "\n @l \n";
@new_r_arr=xorArrs(@new_r_arr,@l);
print "\n new right $index_d \n";
print "\n @new_r_arr \n";
@l=@temp;
print "\n temp = \n";
print @temp;
print "\n";
print "\n new left $index_d \n";
print "\n @l \n";

#}
 }
#

#@arr2=split('',"1001010010001010010000111111100110001010100000110100111101111110");
#print "\n text befor enc: \n";
#print "\n @arr2 \n";
#init_permutation();
#print "after permutation: \n";
#print @bits;

#print "\n";
#@l=@bits[0..31];
#print "left: \n";
#print @l;
#print "\n";
#@r=@bits[32..63];
#@new_r_arr=@r;

#for($index_d=15;$index_d>=0;$index_d=$index_d-1){
#print "\n right string: \n";
#print "\n $r_str \n";
#@new_r_arr=split('',$r_str);
#print "\n right: \n";
#print @new_r_arr;
#print "\n key: $index_d \n";
#print "\n @keys[$index_d] \n";
#@temp=@new_r_arr;
#E(@new_r_arr);
#print "\n after expention \n";
#print @e_r;
##@bits_key=split('',@keys[$index_d]);
#@bits_key=split('',@keys[$index_d]);
#@x_results=xorArrs(@e_r,@bits_key);
#print "\n";
#print "xor right with key: \n";
#print @x_results;
#print "\n sbox : \n";
#sBox(@x_results);
#@s_arr=split('',$new_r);
#print "\n right after sbox \n";
#print "\n @s_arr \n";
#@new_r_arr=p_sbox(@s_arr);
#print "\n right after p \n";
#print "\n @new_r_arr \n";
#print "\n left: \n";
#print "\n @l \n";
#@new_r_arr=xorArrs(@new_r_arr,@l);
#print "\n new right $index_d \n";
#print "\n @new_r_arr \n";
#@l=@temp;
#print "\n temp = \n";
#print @temp;
#print "\n";
#print "\n new left $index_d \n";
#print "\n @l \n";

#}

}

$final_l=join('',@l);
$final_r=join('',@new_r_arr);
$mix_bits=$final_r.$final_l;
print "\n mixed string: $mix_bits \n";
$final_bits=lastPermutation($mix_bits);
}

sub encript_des{
open(DATA, "<$file_name") or die "Couldn't open file file.txt, $!";
$str="$_";
$word="$_";
while(<DATA>){

$bits="$_";
$binaryForm=convertToBinary();
#$binaryForm=$binaryForm;
@bitsArr=split('',$binaryForm);
$b_size=scalar @bitsArr;
# if($b_size<63){
#   @new_bitsArr=();
#   @new_bitsArr[0]=1;
#   $b_size=$b_size+1;
#   $newSize=1;
#   for($itr=63;$itr>63-$bsize;$itr=$itr-1){
#       @new_bitsArr[$newSize]=0;
#       $newSize=$newSize+1;
#       }
#   $new_binaryForm=join('', @new_bitsArr);
#   $binaryForm=$binaryForm.$new_binaryForm;
#  }
 
print("\n binary : $binaryForm \n");
$str=$str.$binaryForm;
$word=$word.$backToString;
 }
 print "\n binary str : \n";
 print "\n $str \n";
#print "\n new binary form \n";
 #print "\n $new_binaryForm \n";
 print "\n text content: \n";
 $content=pack('B*',$str);
 print "\n $content \n";
 @debug_arr=split('',$str);
 $file_size=scalar @debug_arr;
 print "\n file size: \n";
 print $file_size;
 print "\n";
 $num_iterations=int($file_size/64);
 $bit_enc="$_";
 #create_key();
 print "\n keys : \n";
 for($j=0;$j<16;$j=$j+1){
 print "\n";
 print @keys[$j];
 print "\n";
  }
  $bit_enc="$_";
#  open(my $fh, '>', 'encripted_data') or die "Couldn't open file file.txt, $!";
  for(my $i_bit=0;$i_bit<=$num_iterations; $i_bit=$i_bit+1){
  $end=($i_bit+1)*64-1;

@arr2=@debug_arr[$i_bit*64..$end];
$first_str=join('',@arr2);
print "\n iteration = $i_bit \n";
print "\n first bits = $first_str \n";
#  print scalar @arr2;
  #$check2 = join('',@arr2);
  #print "\n $check2 \n";
  perform_des(0);
  print "\n finat string : $final_bits \n";
  $bit_enc=$bit_enc.$final_bits;
  $enc_block=pack('B*',"$final_bits");
  $encription_str=$encription_str.$enc_block;
 # print $fh $enc_block;
  }
  print "\n num iter : $num_iterations \n";
  $remain_bits=$file_size-$num_iterations*64;
  if($remain_bits>0){
    print "\n remain $remain_bits bits \n";
    $end=$i_bit*64+$remain_bits-1;
    @arr2=@debug_arr[$i_bit*64..$end];
  #$remain_bits_str=join('',@arr2);
    print "\n iteration = $i_bit : $remain_bits_str \n";
    @arr2[$end+1]=1;
    $end=$end+1;
    for($n_bit=1;$n_bit<64-$remain_bits;$n_bit=$n_bit+1){
    @arr2[$end+$n_bit]=0;
    }
  # }
  #$st_temp=join('',@arr2);
  #@arr2=split('',$st_temp);
  ##print "\n start: \n";
  print "\n change last block to 64 bits \n";
  print @arr2;
  ##print "\n";
 perform_des(0);
 #print "\n finat string : $final_bits \n";
 $bit_enc=$bit_enc.$final_bits;
 $enc_block=pack('B*',"$final_bits");
 $encription_str=$encription_str.$enc_block;
## print $fh $enc_block;
}

print "\n final bits to file: \n";
print length($bit_enc);
print "\n";

######################################################

#  close $fh;
#  print "done \n"; 

 #print "\n encripted bits: \n";
 #print "\n $bit_enc \n";

 #$encription_str=pack('B*',"$bit_enc");
 #print "\n encription string \n";
 #print "\n $encription_str \n";
 #print "\n check binary: \n";
 #$check_binary=unpack('B*',$encription_str);
 #print "\n $check_binary \n";

############### writing encription results to file #################################

 open(my $fh, '>', $file_name) or die "Couldn't open file file.txt, $!";
 print $fh $encription_str;
#  print $fh $bit_enc;
 close $fh;
 print "done \n"; 

######################################################################################

}

sub decript_des{

$str="$_";
$bits="$_";
open(DATA, "$file_name") or die "Couldn't open file file.txt, $!";

while(<DATA>){

$bits="$_";
 print "\n bits: \n";
 print "\n $bits \n";
 $binaryForm=unpack('B*',$bits);
 print "\n binary form: $binaryForm \n";
 #$binaryForm=$bits;
 @bitsArr=split('',$binaryForm);
 $b_size=scalar @bitsArr;
 $str=$str.$binaryForm;
 $word=$word.$backToString;
 #if($b_size<63){
  # @new_bitsArr=();
  #@new_bitsArr[0]=1;
  # $b_size=$b_size+1;
  # $newSize=1;
  # for($itr=63;$itr>63-$bsize;$itr=$itr-1){
  #     @new_bitsArr[$newSize]=0;
  #     $newSize=$newSize+1;
  #     }
  # $new_binaryForm=join('', @new_bitsArr);
  # $binaryForm=$binaryForm.$new_binaryForm;
#  }
}


 #print("\n binary : $binaryForm \n");
 #$str=$str.$binaryForm;
 #$word=$word.$backToString;
  print "\n binary str : \n";
 print "\n $str \n";
 #print "\n $new_binaryForm \n";
 print "\n text content: \n";
 @debug_arr=split('',$str);
 $file_size=scalar @debug_arr;
 print "\n file size: \n";
 print $file_size;
 print "\n";
 $num_iterations=int($file_size/64);
 $bit_enc="$_";

for($i_bit=0;$i_bit<=$num_iterations-2;$i_bit=$i_bit+1){
  $end=($i_bit+1)*64-1;

@arr2=@debug_arr[$i_bit*64..$end];
  $first_str=join('',@arr2);
  print "\n iteration = $i_bit \n";
  print "\n first bits = $first_str \n";
  print scalar @arr2;
  #$check2 = join('',@arr2);
  #print "\n $check2 \n";
  perform_des(1);
  print "\n finat string : $final_bits \n";
  $bit_enc=$bit_enc.$final_bits;
 # $enc_block=pack('B*',"$final_bits");
 # $encription_str=$encription_str.$enc_block;
  # print $fh $enc_block;
  }

################# orgenize bits for ECB ###############

@decrypted_data=split('',$bit_enc);
print "\n decripted bits: \n";
print "\n @decrypted_data \n";
$d_size=scalar @decrypted_data;
print "\n decripted size= $d_size \n";
#$d_count=0;
$d_bit=@decrypted_data[$d_size-1];

while($d_bit==0){
#$d_count=$d_count+1;
$d_size=$d_size-1;
$d_bit=@decrypted_data[$d_size-1];
}

$d_size=$d_size-1;
@decrypted_data=@decrypted_data[0..$d_size];
$bit_enc = join('',@decrypted_data);
$encription_str=pack('B*',$bit_enc);
#print "\n final bits! \n";
#print "\n $bit_enc \n";
print "\n results : \n";
print "\n $encription_str \n";
 open(my $fh, '>', $file_name) or die "Couldn't open file file.txt, $!";
 print $fh $encription_str;
#  print $fh $bit_enc;
   close $fh;
   print "done \n";
    
               
}

#open file and read content data
@shl_input=@ARGV;
$option=@ARGV[0];
$file_name=@ARGV[1];
create_key();

if($option eq "e"){
encript_des();
print "\n option = $option \n";
}

else{
if($option eq "d"){
decript_des();
for($j=0;$j<16;$j=$j+1){
 print "\n";
 print @keys[$j];
 print "\n";
  }
print "\n option = $option \n";
}

else{
print "\n invalid input, please try again \n";
}
}

