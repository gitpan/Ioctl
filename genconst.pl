use Cwd;

$VERSION = '0.81';

$name = $ARGV[0];

$cwd = getcwd();

# These are the standard constants. If you need to add any constants for
# your local machine, it is better to put then in the .def file.

@c=grep(!/^$/,split(/[,\s]+/,join(" ",grep(!/^\s*#/,split(/\n/,<<'End of constants')))));

# Constants go here

# Ioctl

:File

FIOCLEX FIONCLEX FIONBIO FIOASYNC FIONREAD FIOSETOWN FIOGETOWN

:Socket

SIOCATMARK SIOCSPGRP SIOCGPGRP

:CDROM

CDROMEJECT
CDROMREADTOCHDR
CDROMSUBCHNL

:Interface

#SIOCGIFCONF SIOCSIFADDR SIOCGIFADDR SIOCSIFFLAGS SIOCGIFFLAGS SIOCSIFDSTADDR
#SIOCGIFDSTADDR SIOCGIFBRDADDR SIOCSIFBRDADDR SIOCGIFNETMASK SIOCSIFNETMASK
#SIOCGIFMETRIC SIOCSIFMETRIC

:ARP

#SIOCSARP SIOCGARP SIOCDARP

:Routing

# SIOCADDRT SIOCDELRT

:Term

VINTR VQUIT VERASE VKILL VEOF VEOL VEOL2 VSWTCH VSTART VSTOP VSUSP
VDSUSP VREPRINT VDISCARD VWERASE VLNEXT

BRKINT IGNPAR PARMRK INPCK ISTRIP INLCR IGNCR ICRNL IUCLC IXON
IXANY IXOFF IMAXBEL

OLCUC ONLCR OCRNL ONOCR ONLRET OFILL OFDEL NLDLY NL0 NL1
CRDLY CR0 CR1 CR2 CR3 TABDLY TAB0 TAB1 TAB2 TAB3 XTABS
BSDLY BS0 BS1 VTDLY VT0 VT1 FFDLY FF0 FF1
B0 B50 B75 B110 B134 B150 B200 B300 B600 B1800 B2400 B4800
B9600 B19200 B38400 B57600 B76800 B115200 B153600 B230400
B307200 B460800 CSIZE CS5 CS6 CS7 CS8 CSTOPB CREAD PARENB
PARODD HUPCL CLOCAL CIBAUD PAREXT CRTSXOFF CRTSCTS
CBAUDEXT CIBAUDEXT ICANON XCASE ECHO ECHOE ECHOK ECHONL
NOFLSH TOSTOP ECHOCTL ECHOPRT ECHOKE FLUSHO PENDIN IEXTEN

TCGETS TCSETS TCSETSW TCSETSF TCGETA TCSETA TCSETAW TCSETAF TCSBRK
TCXONC TCFLSH TIOCGPGRP TIOCSPGRP TIOCGSID TIOCGWINSZ TIOCSWINSZ
TIOCMBIS TIOCMBIC TIOCMGET TIOCMSET TIOCSPPS TIOCGPPS TIOCGPPSEV

End of constants


$h = <<'End of header'; 

/* This will probably needs lots of system-dependent ifdef's.  If you
need to add anything for new constants, put them in the .def file. */

#ifdef I_SYS_IOCTL
# include <sys/ioctl.h>
#endif

#ifdef I_TERMIOS
# include <termios.h>
#else
# ifdef I_TERMIO
#  include <termio.h>
# else
#  ifdef I_SGTTY
#   include <sgtty.h>
#  endif
# endif
#endif

#ifdef sun
# include <sys/filio.h>
# include <sys/sockio.h>
#endif

#ifdef LINUX
# include <linux/cdrom.h>
#endif

End of header


foreach (@c) {
	if(/^:/) {
		$tag = $_;
		$ctag{$tag} = [];
	} elsif( $tag ) {
		push(@{$ctag{$tag}},$_);
	}
}

@c = grep(!/^:/,@c);

open(C,"<$name.def");

while(<C>) {
	last if /^--------/;
	$h .= $_;
}

map( $c2{$_}=1, @c);
@c = sort keys %c2;   # Strip out duplicate entries

while(<C>) {
	next if /^#/;
	push(@c,split(/[,\s]+/,$_));
}

map(s/^\+//,@c);
@notc = map((s/^-//,$notc{$_}=1),grep(/^-(.*)$/,@c));
@c = grep(!/^-/,@c);
map($unique{$_}=1,@c);
@c=keys %unique;

foreach (sort @c) {
	$f{substr($_,0,1)} .= "
        if(strEQ(name,\"$_\"))
#       ifdef $_               ".($notc{$_}?"
            goto disabled;     ":"
            return ((double)($_));         ")."
#       else
            goto not_there;
#       endif
";
}

close(C);

open(IN,"<xsproto");
open(OUT,">$name.xs");

print OUT <<'DONE';
/**********************************************************

 Warning! Don't edit this file ($name.xs). Any changes made
 will be lost. Edit xsproto, instead.

**********************************************************/
DONE
  

while(<IN>) {
	s/<Directory>/$cwd/g;
	s/<Constants>/join("",map("    case '$_':\n".$f{$_}.
"        break;\n" ,sort keys %f))/ge;
	s/<Headers>/$h/g;
	s/<Name>/$name/g;
	s/<Version>/$VERSION/g;
	print OUT;
}
close(IN);
close(OUT);

open(IN,"<pmproto");
open(OUT,">$name.pm");

print OUT <<DONE;
##################################################################
#
#  Warning! Don't edit this file ($name.pm). Any changes will
#  be lost. Edit pmproto instead.
#
##################################################################
DONE

while(<IN>) {
	s/<Directory>/$cwd/g;
	s/<Constants>/join("\n\t",map("$_",sort @c))/ge;
	s/<Tags>/join("",map("   \"$_\" => [".join(",",map("\"$_\"",@{$ctag{$_}}))."],\n",keys %ctag))/ge;
	s/<Name>/$name/g;
	s/<Version>/$VERSION/g;
	print OUT;
}
close(IN);
close(OUT);


