
require "./Configure.pm";

@hlist = ("termios.h","termio.h","sgtty.h","ioctl.h","sys/ioctl.h");

foreach (@hlist) {
	if( ref($_) eq "ARRAY") {
		@headers = @{$_};
	} else {
		@headers = ($_);
	}
	@defs = grep(!defined($bad{$_})
	 &&  !/(_[tThH]$)|(^__)|^NULL$/
	 ,Configure::GetConstants(@headers));
	@defs = getdefs(findgooddefs(@defs));
	foreach (@defs) {
		($l,$r) = /^(.*)\|(.*)$/;
		$const{$headers[0]."|".$l} = $r;
		if(!defined($fconst{$l})) { $fconst{$l} = $r; }
		#print "const{".$headers[0]."|".$l."} = $r;\n";
		print "$l=$r ($headers[0])\n";
	}
	#print join("\n",@defs,"\n");
}

#@headers = ("termios.h");
#
#@defs = Configure::GetConstants(@headers);


sub findgooddefs {
	my(@defs) = sort @_;
	
	@defs = grep(!/^\s*$/,@defs);
	
	if(!@defs) {
		return ();
	}

$code = join("",map("#include \"$_\"\n",@headers));

#$code .= "\n" x 230;
$code .= "

main () {
	double d;
";

foreach (@defs) {
$code .= "
#ifdef $_
		d=((double)($_ + 0));
#endif
";
}

$code .= "

}

";

#print "Testing ",join(":",@defs),"\n\n";

@result = Configure::Execute($code);

#print join(",",@result),"\n";

if($result[0]==0) {
#	print "Errors: $result[2]\n";
#	@errs = map(/[^p\d](\d+)[^\d]/ ? ($1 >230) ? int(($1-237)/8) : () : (),split(/\n/,$result[2]));
#	
#	print "Errors: ",join(",",@errs),"\n";
#	
#	print "Discarding: ",join(",",map($defs[$_],@errs)),"\n";
	
	if(@defs==1) {
		print "Discarding `$defs[0]'\n";
		$bad{$defs[0]}=1;
		return ();
	}
	#Compile error
	my(@half1) = @defs[0..int($#defs/2)];
	my(@half2) = @defs[int($#defs/2)+1..$#defs];
	if(@half1) {
		my(@ret) = (findgooddefs(@half1),findgooddefs(@half2));
#		print "Returning ",join(":",@ret),"\n\n";
		return @ret;
	} else {
		return ();
	}
} else {
#	print "No errors: $result[2]\n";
	return @defs;
}
#print "Returning ",join(":",@defs),"\n\n";
}


sub findstringdefs {
	my(@defs) = sort @_;
$code = join("",map("#include \"$_\"\n",@headers));
$code .= "
main () {
";
foreach (@defs) {
$code .= "
#ifdef $_
#if (($_)-($_))==0
		printf(\"$_|%d\\n\",(int)(sizeof(($_)[0])));
#endif
#else
		/*printf(\"$_|\\n\");*/
#endif
";
}
$code .= "
}
";

@result = Configure::Execute($code);
if($result[0]==0) {
	if(@defs==1) { print STDERR "`$defs[0]' is not a character array\n"; return (); }
	#Compile error
	my(@half1) = @defs[0..int($#defs/2)];
	my(@half2) = @defs[int($#defs/2)+1..$#defs];
	if(@half1) {
		my(@ret) = (findstringdefs(@half1),findstringdefs(@half2));
		return @ret;
	} else {
		return ();
	}
} else {
	return @defs;
}
}

sub getdefs {
	my(@defs) = sort @_;

$code = join("",map("#include \"$_\"\n",@headers));

$code .= "

main () {
";

foreach (@defs) {

#$code .= "
##ifdef $_
##if (($_)-($_))==0
#		printf(\"$_|%g\\n\",((double)($_)));
##endif
##else
#		/*printf(\"$_|\\n\");*/
##endif
#";

$code .= "
{
#ifdef $_
   long test[] = {0,$_};
   if(sizeof(test) != sizeof(test[0])) {
		printf(\"$_|%.17g\\n\",((double)($_ + 0)));
   }
#else
   /*printf(\"Bad: $_\\n\");*/
#endif
}
";
}

$code .= "

}

";

#print "Testing ",join(":",@defs),"\n\n";

@result = Configure::Execute($code);

#print join(",",@result),"\n";

if($result[0]==0) {
	if(@defs==1) { print STDERR "Discarding `$defs[0]'\n"; return (); }
	#Compile error
	my(@half1) = @defs[0..int($#defs/2)];
	my(@half2) = @defs[int($#defs/2)+1..$#defs];
	if(@half1) {
		my(@ret) = (findgooddefs(@half1),findgooddefs(@half2));
#		print "Returning ",join(":",@ret),"\n\n";
		return @ret;
	} else {
		return ();
	}
} else {
	return grep(/\|/,split(/\n/,$result[2]));
}
#print "Returning ",join(":",@defs),"\n\n";
}

