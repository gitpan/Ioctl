use Cwd;

$name = $ARGV[0];

$cwd = getcwd();

# These are the standard constants. If you need to add any constants for
# your local machine, it is better to put then in the .def file.

@c=grep(!/^$/,split(/[,\s]+/,join(" ",grep(!/^\s*#/,split(/\n/,<<'End of constants')))));

# Constants go here

# Ioctl

:Termio

#TABDLY B38400 CRTSCTS TAB0 TAB1 TAB2 IXANY TAB3 TIOCPKT_START
#IOC_VOID CLOCAL B75  IUCLC TIOCGWINSZ B200 B600 TCGETA _LOFF_T
#TCSBRKP VREPRINT ISTRIP BSDLY  VLNEXT TIOCM_RNG TIOCCONS
#_POSIX_SOURCE VSTART TIOCNXCL TIOCM_CTS BRKINT TCGETS TIOCGPGRP FLUSHO
#XCASE FFDLY OPOST TCSADRAIN PARODD B134 IOCCMD_MASK NULL TIOCSPGRP N_PPP
#CRDLY TCSANOW TIOCLINUX _SSIZE_T IGNPAR TCOON TIOCM_DSR TIOCSERGSTRUCT
#_BSD_SOURCE TIOCGSOFTCAR IOCCMD_SHIFT TCSAFLUSH TCXONC VDISCARD B300
#TIOCINQ ICRNL _LINUX_TERMIOS_H VQUIT TIOCSLCKTRMIOS TIOCPKT_FLUSHREAD
#FIOASYNC OCRNL TIOCSETD ONOCR VSUSP VKILL TCFLSH N_SLIP TIOCM_DTR
#_FEATURES_H VERASE FIOCLEX TCSETAF CSTOPB B1800 ISIG ECHOKE
#TIOCSERCONFIG _LINUX_IOCTL_H IGNCR TIOCM_RI TIOCPKT_DOSTOP B150 FIONCLEX
#TCSETAW IXOFF IXON CBAUD _SYS_IOCTL_H _TIME_T TIOCM_CD ECHOCTL XTABS
#IMAXBEL NLDLY FIONBIO NCCS VEOL2 _SYS_CDEFS_H TIOCPKT_FLUSHWRITE IEXTEN
#PARMRK B4800 VEOF TCIOFLUSH EXTA EXTB VTDLY IOCSIZE_SHIFT ECHOPRT INPCK
#VEOL ICANON INLCR TCIOFF VSTOP TIOCSWINSZ _CLOCK_T PENDIN CSIZE ONLCR
#TIOCSTI TIOCM_SR _PTRDIFF_T IOCSIZE_MASK TIOCM_ST TIOCPKT_STOP TCSETA
#BS0 BS1 TCOFLUSH CIBAUD IOC_INOUT TCSBRK _LINUX_TYPES_H NOFLSH TIOCM_LE
#TIOCSERGWILD TIOCM_CAR NCC TCSETS TIOCGSERIAL TIOCPKT_DATA _SYS_TYPES_H
#TIOCEXCL HUPCL TCSETSF TIOCMGET TIOCSERSWILD TCION TIOCPKT ECHO
#TIOCPKT_NOSTOP TIOCSSERIAL CR0 _SVID_SOURCE CR1 B50 CR2 B2400 CR3
#FIONREAD TIOCMSET _TERMIOS_H NL0 OFDEL NL1 _SIZE_T TCSETSW N_TTY
#TIOCGLCKTRMIOS IOC_OUT TIOCGETD ONLRET TIOCSSOFTCAR N_MOUSE OLCUC
#ECHONL _GNU_SOURCE VT0 VMIN VT1 VWERASE IGNBRK B19200 TCOOFF TCIFLUSH
#ECHOE _POSIX_C_SOURCE B1200 VTIME TIOCSCTTY TOSTOP ECHOK TIOCMBIC CS5
#CS6 CS7 TIOCNOTTY CS8 B9600 IOC_IN VINTR TIOCM_RTS B110 OFILL VSWTC
#PARENB TIOCOUTQ TIOCMBIS FF0 FF1

:CDROM

CDROMEJECT
CDROMREADTOCHDR
CDROMSUBCHNL

End of constants


$h = <<'End of header'; 

/* This is the standard header information. If you need to add anything
to deal with new constants, it should likewise be included in the .def file */

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

#include <linux/cdrom.h>

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
	s/<Constants>/join("\n\t",map("$_",@c))/ge;
	s/<Tags>/join("",map("   \"$_\" => [".join(",",map("\"$_\"",@{$ctag{$_}}))."],\n",keys %ctag))/ge;
	s/<Name>/$name/g;
	print OUT;
}
close(IN);
close(OUT);


