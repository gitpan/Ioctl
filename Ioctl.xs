#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* These includes will probably needs lots of system-dependent ifdef's */

#include <sys/ioctl.h>
#include <sys/filio.h>
#include <sys/sockio.h>

#include <sys/socket.h>        /* for sockaddr & socknewproto & etc */
#include <net/route.h>         /* for rtentry */
#include <net/if.h>            /* for ifreq */
#include <netinet/if_ether.h>  /* for ether_addr */

static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(char *name, int arg)
{
    errno = 0;
    switch (*name) {
    case 'F':
	if (strEQ(name, "FIOASYNC")) /*EXPORT*/
#ifdef FIOASYNC
	    return FIOASYNC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "FIOCLEX")) /*EXPORT*/
#ifdef FIOCLEX
	    return FIOCLEX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "FIOGETOWN")) /*EXPORT*/
#ifdef FIOGETOWN
	    return FIOGETOWN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "FIONBIO")) /*EXPORT*/
#ifdef FIONBIO
	    return FIONBIO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "FIONCLEX")) /*EXPORT*/
#ifdef FIONCLEX
	    return FIONCLEX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "FIONREAD")) /*EXPORT*/
#ifdef FIONREAD
	    return FIONREAD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "FIOSETOWN")) /*EXPORT*/
#ifdef FIOSETOWN
	    return FIOSETOWN;
#else
	    goto not_there;
#endif
	break;
    case 'S':
	if (strEQ(name, "SIOCADDMULTI"))
#ifdef SIOCADDMULTI
	    return SIOCADDMULTI;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCADDRT")) /*EXPORT*/
#ifdef SIOCADDRT
	    return SIOCADDRT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCATMARK"))
#ifdef SIOCATMARK
	    return SIOCATMARK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCDARP")) /*EXPORT*/
#ifdef SIOCDARP
	    return SIOCDARP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCDELMULTI"))
#ifdef SIOCDELMULTI
	    return SIOCDELMULTI;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCDELRT")) /*EXPORT*/
#ifdef SIOCDELRT
	    return SIOCDELRT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGARP")) /*EXPORT*/
#ifdef SIOCGARP
	    return SIOCGARP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGENADDR"))
#ifdef SIOCGENADDR
	    return SIOCGENADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGENPSTATS"))
#ifdef SIOCGENPSTATS
	    return SIOCGENPSTATS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGETNAME"))
#ifdef SIOCGETNAME
	    return SIOCGETNAME;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGETPEER"))
#ifdef SIOCGETPEER
	    return SIOCGETPEER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGETSYNC"))
#ifdef SIOCGETSYNC
	    return SIOCGETSYNC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGHIWAT")) /*EXPORT*/
#ifdef SIOCGHIWAT
	    return SIOCGHIWAT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFADDR")) /*EXPORT*/
#ifdef SIOCGIFADDR
	    return SIOCGIFADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFBRDADDR")) /*EXPORT*/
#ifdef SIOCGIFBRDADDR
	    return SIOCGIFBRDADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFCONF")) /*EXPORT*/
#ifdef SIOCGIFCONF
	    return SIOCGIFCONF;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFDSTADDR")) /*EXPORT*/
#ifdef SIOCGIFDSTADDR
	    return SIOCGIFDSTADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFFLAGS")) /*EXPORT*/
#ifdef SIOCGIFFLAGS
	    return SIOCGIFFLAGS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFINDEX"))
#ifdef SIOCGIFINDEX
	    return SIOCGIFINDEX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFMEM"))
#ifdef SIOCGIFMEM
	    return SIOCGIFMEM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFMETRIC")) /*EXPORT*/
#ifdef SIOCGIFMETRIC
	    return SIOCGIFMETRIC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFMTU"))
#ifdef SIOCGIFMTU
	    return SIOCGIFMTU;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFMUXID"))
#ifdef SIOCGIFMUXID
	    return SIOCGIFMUXID;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFNETMASK")) /*EXPORT*/
#ifdef SIOCGIFNETMASK
	    return SIOCGIFNETMASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGIFNUM"))
#ifdef SIOCGIFNUM
	    return SIOCGIFNUM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGLOWAT")) /*EXPORT*/
#ifdef SIOCGLOWAT
	    return SIOCGLOWAT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGPGRP")) /*EXPORT*/
#ifdef SIOCGPGRP
	    return SIOCGPGRP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCIFDETACH"))
#ifdef SIOCIFDETACH
	    return SIOCIFDETACH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCLOWER"))
#ifdef SIOCLOWER
	    return SIOCLOWER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCPROTO"))
#ifdef SIOCPROTO
	    return SIOCPROTO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSARP")) /*EXPORT*/
#ifdef SIOCSARP
	    return SIOCSARP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSETSYNC"))
#ifdef SIOCSETSYNC
	    return SIOCSETSYNC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSHIWAT")) /*EXPORT*/
#ifdef SIOCSHIWAT
	    return SIOCSHIWAT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFADDR")) /*EXPORT*/
#ifdef SIOCSIFADDR
	    return SIOCSIFADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFBRDADDR")) /*EXPORT*/
#ifdef SIOCSIFBRDADDR
	    return SIOCSIFBRDADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFDSTADDR")) /*EXPORT*/
#ifdef SIOCSIFDSTADDR
	    return SIOCSIFDSTADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFFLAGS")) /*EXPORT*/
#ifdef SIOCSIFFLAGS
	    return SIOCSIFFLAGS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFINDEX"))
#ifdef SIOCSIFINDEX
	    return SIOCSIFINDEX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFMEM"))
#ifdef SIOCSIFMEM
	    return SIOCSIFMEM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFMETRIC")) /*EXPORT*/
#ifdef SIOCSIFMETRIC
	    return SIOCSIFMETRIC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFMTU"))
#ifdef SIOCSIFMTU
	    return SIOCSIFMTU;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFMUXID"))
#ifdef SIOCSIFMUXID
	    return SIOCSIFMUXID;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFNAME"))
#ifdef SIOCSIFNAME
	    return SIOCSIFNAME;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSIFNETMASK")) /*EXPORT*/
#ifdef SIOCSIFNETMASK
	    return SIOCSIFNETMASK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSLGETREQ"))
#ifdef SIOCSLGETREQ
	    return SIOCSLGETREQ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSLOWAT")) /*EXPORT*/
#ifdef SIOCSLOWAT
	    return SIOCSLOWAT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSLSTAT"))
#ifdef SIOCSLSTAT
	    return SIOCSLSTAT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSOCKSYS"))
#ifdef SIOCSOCKSYS
	    return SIOCSOCKSYS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSPGRP")) /*EXPORT*/
#ifdef SIOCSPGRP
	    return SIOCSPGRP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSPROMISC"))
#ifdef SIOCSPROMISC
	    return SIOCSPROMISC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSSDSTATS"))
#ifdef SIOCSSDSTATS
	    return SIOCSSDSTATS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSSESTATS"))
#ifdef SIOCSSESTATS
	    return SIOCSSESTATS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCUPPER"))
#ifdef SIOCUPPER
	    return SIOCUPPER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCX25RCV"))
#ifdef SIOCX25RCV
	    return SIOCX25RCV;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCX25TBL"))
#ifdef SIOCX25TBL
	    return SIOCX25TBL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCX25XMT"))
#ifdef SIOCX25XMT
	    return SIOCX25XMT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCXPROTO"))
#ifdef SIOCXPROTO
	    return SIOCXPROTO;
#else
	    goto not_there;
#endif
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}


MODULE = Ioctl		PACKAGE = Ioctl

PROTOTYPES: DISABLE

double
constant(name,arg)
	char *		name
	int		arg

