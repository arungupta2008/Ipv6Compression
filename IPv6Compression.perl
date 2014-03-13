
sub ipv6_expand{
    local($_) = shift;
    #s/./:/;
    $_ = lc($_);
    $_ = Ipv4toIpv6($_);
    #s/\./:/g;
    s/^:/0:/;
    s/:$/:0/;
    s/(^|:)([^:]{1,3})(?=:|$)/$1.substr("0000$2", -4)/ge;
    my $c = tr/:/:/;
    s/::/":".("0000:" x (8-$c))/e;
    return $_;
}

sub compressIPv6{
	local($_) = shift;
	#thanx to http://golf.shinh.org/p.rb?IPv6+Compress
	#$_=~s/(:0{1,3})/:0/g;
	s/\b00?0?//g;s/\b[0:]+0/:/;
	#s/(:?0000)+/:/;s/\b0+\B//g;
	#s/\b00?0?//g,s/(^0|:0)+/:/;
	#s/\b00?0?//g;s/\b[0:]+0/:/;
	#s/\b0{1,3}//g;s/(^0|:0)+/:/;
	#s/\b0+\B//g;s/:?\b(0:)+/::/;
	#s/\b0+\B//g;s/\b[0:]+0/:/;
	s/:$/::/;
	return $_;
}
sub test_ipv6 {
        local($_) = shift;
        print "inpv6 ip : $_\n";
	if(eval '$_=~/^(([a-f0-9]){4}:){7}([a-f0-9]){4}$/' ){
		print "Correct Ipv6\n";
		return compressIPv6($_);
	}else {
		return $_;
		}
}
sub changetoipv6{
	$input = shift;
	print "at changetoipv6 :  ".$input."\n";
	my $num;
	@in = split('\.', $input);
	if($#in<3){
			return $input;
		}
	my $count=0;	
	for my $inp  (@in) {
		print "Parts of Ipv4  :  ".$inp."\n";
		if($count eq 2){
			$num = $num.":";
			}
		$num = $num.sprintf( "%02x","$inp");
		++$count;
	}
	print "Return at changetoipv6 :  ".$num."\n";
	return $num;
}
sub Ipv4toIpv6{
        local($_) = shift;
        if(eval '$_=~m/:([0-9]{1,3}(\.[0-9]{1,3}){3})$/'){
			s/([0-9]{1,3}(\.[0-9]{1,3}){3})/changetoipv6($1)/e;
			print "At Ipv4toIpv6 :  ".$_."\n";
			return $_;	
		}else{
			return $_;
		}
}
#$num= "0:0:0:0:0:0:13.1.68.3";
#$num =~ s/(\d{1,3}(\.\d{1,3}){3})/arun/e;
print $num."\n";
#print Ipv4toIpv6("1::1.2.300.4")."\n";
#test_ipv6("0000:0000:0000:0000:0000:0000:0000:0000");
@inputIpv6 = ("1:2:3:4:5::","::1","1::1","::12.1.1.1","100::001","ff02::1","::", "1:0:0:1:0:0:0:0","1:0:0:0:1:0:0:0","0:0:0:0:0:0:192.1.56.10", "1::1.2.300.4", "fe80::217:f2ff:254.7.237.98","::1.2.3.4:12", "0:0:0:0:0:0:13.1.68.3", "1.2.3.4:1111:2222:3333:4444::5555","FE80::","2001:0db8:0000:0000:0000:0000:1428:57ab" );
# Test script
foreach ( @inputIpv6) {
    ##$_ = sprintf("%x::%x", 0xffff-$i, $i);
    print "\n\ninput IPv6 : $_\n";
    #$expanedIPv6 = ;
    #print $expanedIPv6, "\n";
    if($_=~ m/./){
		print test_ipv6(ipv6_expand($_));
	}
}
