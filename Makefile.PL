use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

$name = "Ioctl";

WriteMakefile(
    'NAME'	=> $name,
    'VERSION'	=> '0.5',
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    'PM' => { "$name.pm" => "\$(INST_LIB)/$name.pm" }
);

sub MY::top_targets {
	$_ = MM->top_targets();
	$_ .= "
	
$name.def:
	\$(CP) cdproto $name.def
		
$name.xs $name.pm: genconst.pl $name.def xsproto pmproto
	\$(PERL) -I\$(PERL_LIB) genconst.pl $name
";
	$_;
}

sub MY::clean {
	$_ = MM->clean();
	$_ .= "	rm -f $name.xs $name.pm $name.c\n";
	$_;
	
};

sub MY::distclean {
	$_ = MM->distclean();
	$_ =~ s/\@:/rm -f $name.def Makefile.old/;
	$_ .= " 

shdistclean:     clean
	\@:
	rm -f ./Makefile ./Makefile.old
	rm -f $name.def
	shar * > ../\$(DISTNAME)-\$(VERSION).sh 
	\@:
";
	$_;
}                                        
