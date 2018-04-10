# RSA algorithm

# step 1 - random 2 prime numbers:
$range = 99;

$p = 2 + int rand($range);

$val = isPrime($p);
while($val == 0){
   $p = 2 + int rand($range);
   $val = isPrime($p);
}

$q = 2 + int rand($range);

$val = isPrime($q);
while($val == 0){
   $q = 2 + int rand($range);
   $val = isPrime($q);
}

sub isPrime{
    $num =  $_[0];
     for($i = 2; $i <= sqrt($num); $i++){
	if(($num % $i) == 0){
	    return 0;
	}
    }
    return 1;
}

# step 2 - get n and phi
$n = $p * $q;
$phi = ($p-1)*($q-1);

# step 3 - find smaller, relatively prime number to phi

$e = 1 + int rand($n-1); 
$val = relativelyPrime($e, $phi);
while($val != 1){
    $e = 1 + int rand($n-1);
    $val = relativelyPrime($e, $phi);
}

sub gcd{
    $num1 = $_[0]; 
    $num2 = $_[1]; 
    while($num2 != 0){
	$tmp = $num1;  
	$num1 = $num2; 
	$num2 = ($tmp % $num2); 
    }
    return $num1;
}

sub relativelyPrime{
    $num1 = $_[0]; $num2 = $_[1]; 
    $num = gcd($num1, $num2);
    if($num == 1){
	return 1;
    }
    return 0;
}


# step 4 - find d
sub modInverse{
    $num1 = $_[0]; $num2 = $_[1];
    for($i = 1; $i < $num1; $i++)
    {
	if(($num2*$i) % $num1 == 1)	
	{
	    return $i;	
	}
    }
}

$d = modInverse($phi, $e);

# private key = (d,n);
# public key = (e,n);

%numeric = ();
$number = 1;
foreach('a'..'z'){
    $numeric{$_} = $number;
    $number++;
}

sub modPow{
    $base = $_[0]; $exp = $_[1];
    $base %= $n;
    $res = 1;
    while($exp > 0){
	if($exp & 1){
	    $res = ($res * $base) % $n;
	    $base = ($base * $base) % $n;
	    $exp >>= 1;
	}
	return $res;
    }
}

sub encryption{
    $num = $_[0];
    return modPow($num, $e);
}

sub decryption{
    $num = $_[0];

    return modPow($num, $d);
}

print "Enter the value for RSA:\n";
chomp($getinfro  = <>);
@plaintxt = "$getinfro";
$size = @plaintxt;

for($i = 0; $i < $size; $i++){  # run on string to encrypt, word each time
    foreach $char (split //, $plaintxt[$i]){  # split word into chars
	foreach $key (keys %numeric){ 

	    if($key eq lc($char)) {
		$val = $numeric{$key};	
		push(@ciphertxt, encryption($val)); 
    	    }
	}
    }
}

print "cipher = @ciphertxt\n";

for($i = 0; $i < $size; $i++){ # run on ciphertxt
    foreach $num (@ciphertxt){ # for every num
	$char = decryption($num); 
	foreach $val (values %numeric){
	   if($val == $char){
		foreach $key (keys %numeric){
		    if($val == $numeric{$key}){
			push(@decryptxt, $key);
		    }
		}
	   }
	}
    }
}


print "plain = @decryptxt\n";
