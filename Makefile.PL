use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

$name = "Ioctl";

WriteMakefile(
    'NAME'	=> $name,
    'VERSION'	=> '0.7',
    'LIBS'	=> [''],   # e.g., '-lm' 
    'DEFINE'	=> '',     # e.g., '-DHAVE_SOMETHING' 
    'OBJECT' => 'Ioctl.o',
    'INC'	=> '',     # e.g., '-I/usr/include/other' 
    #'XS' => { "$name.xs" => "$name.c"},
    'PM' => { "$name.pm" => "\$(INST_LIB)/$name.pm" },
    clean => { FILES => "$name.xs $name.pm $name.c" },
    MAN3PODS => {},
    C => ["$name.c"],
);

sub MY::postamble {
	return "
	
$name.def:
	\$(CP) cdproto $name.def
		
$name.xs $name.pm: genconst.pl $name.def xsproto pmproto
	\$(PERL) -I\$(PERL_LIB) genconst.pl $name
";
}
