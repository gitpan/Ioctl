package Ioctl;

=head1 NAME

Ioctl - load the C ioctl defines

=head1 SYNOPSIS

    use Ioctl;

=head1 DESCRIPTION

This module makes available many ioctl constants.

=head1 EXPORTED SYMBOLS

Please refer to your native ioctl() documentation to see what
constants are implemented in your system.

=head1 COPYRIGHT

Copyright (c) 1999 Joshua Nathaniel Pritikin.

All rights reserved.  This program is free software; you can
redistribute it and/or modify it under the same terms as Perl itself.

=cut

use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS $AUTOLOAD);

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);
$VERSION = "0.02";

# Here is everything listed in the 1990 edition of Unix Network
# Programming (Stevens).

@EXPORT_OK =
    (qw(
     FIOCLEX
     FIONCLEX
     FIONBIO
     FIOASYNC
     FIONREAD
     FIOSETOWN
     FIOGETOWN

     SIOCSHIWAT
     SIOCGHIWAT
     SIOCSLOWAT
     SIOCGLOWAT
     SIOCSPGRP
     SIOCGPGRP

     SIOCADDRT
     SIOCDELRT

     SIOCSIFADDR
     SIOCGIFADDR
     SIOCSIFFLAGS
     SIOCGIFFLAGS
     SIOCGIFCONF
     SIOCSIFDSTADDR
     SIOCGIFDSTADDR
     SIOCGIFBRDADDR
     SIOCSIFBRDADDR
     SIOCGIFNETMASK
     SIOCSIFNETMASK
     SIOCGIFMETRIC
     SIOCSIFMETRIC
     SIOCSARP
     SIOCGARP
     SIOCDARP
     ),

# Other items we are prepared to export if requested
    qw(
       SIOCADDMULTI
       SIOCATMARK
       SIOCDELMULTI
       SIOCGENADDR
       SIOCGENPSTATS
       SIOCGETNAME
       SIOCGETPEER
       SIOCGETSYNC
       SIOCGIFINDEX
       SIOCGIFMEM
       SIOCGIFMTU
       SIOCGIFMUXID
       SIOCGIFNUM
       SIOCIFDETACH
       SIOCLOWER
       SIOCPROTO
       SIOCSETSYNC
       SIOCSIFINDEX
       SIOCSIFMEM
       SIOCSIFMTU
       SIOCSIFMUXID
       SIOCSIFNAME
       SIOCSLGETREQ
       SIOCSLSTAT
       SIOCSOCKSYS
       SIOCSPROMISC
       SIOCSSDSTATS
       SIOCSSESTATS
       SIOCUPPER
       SIOCX25RCV
       SIOCX25TBL
       SIOCX25XMT
       SIOCXPROTO
      ));

sub AUTOLOAD {
    (my $constname = $AUTOLOAD) =~ s/.*:://;
    my $val = constant($constname, 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    my ($pack,$file,$line) = caller;
	    die "Your vendor has not defined Ioctl constant $constname, used at $file line $line.
";
	}
    }
    *$AUTOLOAD = sub { $val };
    goto &$AUTOLOAD;
}

Ioctl->bootstrap($VERSION);

1;
