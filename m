From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 12:13:28 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:45830 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0LRLNa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 06:13:30 -0500
In-Reply-To: <1292657351.2371.73.camel@kushiel.sterenborg.info>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Rob,

On Sat, 18 Dec 2010, Rob Sterenborg (lists) wrote:

> On Fri, 2010-12-17 at 23:26 +0100, Jozsef Kadlecsik wrote:
> > 
> > I'm happy to announce the new branch of ipset and release it's first 
> > element, ipset-5.0.
> 
> I'm not a C programmer. I just tried to make ipset compile which seems
> to have worked partially. I have no clue if I did the right thing so the
> below should be reviewed.
> 
> I'm on CentOS 5.5 with a custom 2.6.36.2 kernel, gcc version 4.1.2
> 20080704 (Red Hat 4.1.2-48).
> 
> When running 'configure' I got this error:
> 
> ./configure: line 11510: syntax error near unexpected token `[libmnl],'
> ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'
> 
> CentOS' pkg-config is installed, so, for reference: I copied
> '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
> again and after that 'configure' had no problems.

Autoconf has its own pitfalls... I can't reproduce it so I added
'aclocal -I m4' to autogen.sh. After checking out the git tree, could you 
give it a try whether it solves the issue?
 
> Running 'make', I got this :
> 
> cc1: error: unrecognized command line option "-Woverlength-strings"
> 
> If I remove '-Woverlength-strings' from all Makefiles then of course
> there's no complaining about that anymore, but I'm not sure if that's
> the way to go.

It's mentioned in the README file: you should simply re-run `configure'
with the additional flag '--disable-extra-flags' :-)

> Next, I got this:
> 
> session.c: In function 'attr2data':
> session.c:566: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
> this function)
> session.c:566: error: (Each undeclared identifier is reported only once
> session.c:566: error: for each function it appears in.)
> session.c: In function 'decode_errmsg':
> session.c:1216: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
> this function)
> session.c: In function 'attr_len':
> session.c:1338: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
> this function)

Your kernel header files at the default location is not recent enough.

I'm undecided yet how to solve it: maybe it should be checked by configure 
and fail immediately.
 
> To make it compile I did the following.
> New file 'include/libipset/nla.h':
> 
> /*
> * nla_type (16 bits)
> * +---+---+-------------------------------+
> * | N | O | Attribute Type                |
> * +---+---+-------------------------------+
> * N := Carries nested attributes
> * O := Payload stored in network byte order
> *
> * Note: The N and O flag are mutually exclusive.
> */
> 
> #define NLA_F_NESTED            (1 << 15)
> #define NLA_F_NET_BYTEORDER     (1 << 14)
> #define NLA_TYPE_MASK           ~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)
> 
> Change in 'lib/session.c':
> 
> --- session.c.orig      2010-12-18 08:00:31.000000000 +0100
> +++ session.c   2010-12-18 07:59:48.000000000 +0100
> @@ -23,6 +23,9 @@
>  #include <libipset/utils.h>                    /* STREQ */
>  #include <libipset/ui.h>                       /* IPSET_ENV_* */
>  #include <libipset/session.h>                  /* prototypes */
> +#ifndef NLA_TYPE_MASK
> +#include <libipset/nla.h>
> +#endif

That's a possible solution but I'm uneasy about it.
  
>  #define IPSET_NEST_MAX 4
> 
> After that 'make' runs without errors.
> Running 'make modules' gives:
> 
> /usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c: In function
> 'start_msg':
> /usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:735: error:
> 'NFNL_SUBSYS_IPSET' undeclared (first use in this function)
> /usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:735: error: (Each
> undeclared identifier is reported only once
> /usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:735: error: for each
> function it appears in.)
> /usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c: At top level:
> /usr/local/src/netfilter/ipset-5.0/kernel/ip_set.c:1701: error:
> 'NFNL_SUBSYS_IPSET' undeclared here (not in a function)
> make[2]: *** [/usr/local/src/netfilter/ipset-5.0/kernel/ip_set.o] Error
> 1
> make[1]: *** [_module_/usr/local/src/netfilter/ipset-5.0/kernel] Error 2
> make[1]: Leaving directory `/usr/local/src/kernel/linux-2.6.36.2'
> make: *** [modules] Error 2
> 
> I noticed there was a 'netlink.patch' file that I tried to apply to
> '/usr/include/linux/netfilter/nfnetlink.h', but it wouldn't: it looks
> like your nfnetlink.h is different from mine (can send a copy of the
> original if you need it) so I applied manually. Still no go, same error,
> probably wrong location? I copied 'nfnetlink.h' into
> 'kernel/include/linux/netfilter' because ip_set.c seems to look there(?)
> but it wasn't there. Still no go. To get around this I dit this:

The netlink.patch file must be applied against the kernel tree with which 
you compile ipset. That is in your case the kernel tree at 
/usr/local/src/kernel/linux-2.6.36.2.
 
> Finally, when trying the new ipset it seems that except for 'version',
> every command I tried returns 'Invalid argument':
> 
> (Yes I know this is incorrect syntax, but now I know it's trying to do
> something besides giving me 'Invalid argument'.)
> # ipset create TEST hash   
> ipset v5.0: Syntax error: typename 'hash' is unkown
> 
> (As per ipset.8 example.)
> # ipset create foo bitmap:ip range 192.168.0.0/16
> ipset v5.0: Kernel error received: Invalid argument
> 
> # ipset list               
> ipset v5.0: Kernel error received: Invalid argument
> 
> # lsmod|grep set
> ip_set                 16790  0 
> nfnetlink               3179  2 ip_set,nf_conntrack_netlink
> 
> So, I guess something must have gone wrong when compiling ipset anyhow.

Please read the README file: you must patch your kernel source with 
netlink.patch, compile and install it. Otherwise the new nfnetlink id 
won't handled by the kernel and thus ipset can't work.

Thanks for tests and the reporting!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
