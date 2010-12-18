From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 20:50:14 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012182024240.11577@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info> <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu> <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47077 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab0LRTuQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 14:50:16 -0500
In-Reply-To: <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 18 Dec 2010, Jan Engelhardt wrote:

> On Saturday 2010-12-18 12:13, Jozsef Kadlecsik wrote:
> >On Sat, 18 Dec 2010, Rob Sterenborg (lists) wrote:
> >
> >> On Fri, 2010-12-17 at 23:26 +0100, Jozsef Kadlecsik wrote:
> >> > 
> >> > I'm happy to announce the new branch of ipset and release it's first 
> >> > element, ipset-5.0.
> >> 
> >> I'm not a C programmer. I just tried to make ipset compile which seems
> >> to have worked partially. I have no clue if I did the right thing so the
> >> below should be reviewed.
> >> 
> >> I'm on CentOS 5.5 with a custom 2.6.36.2 kernel, gcc version 4.1.2
> >> 20080704 (Red Hat 4.1.2-48).
> >> 
> >> When running 'configure' I got this error:
> >> 
> >> ./configure: line 11510: syntax error near unexpected token `[libmnl],'
> >> ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'
> >> 
> >> CentOS' pkg-config is installed, so, for reference: I copied
> >> '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
> >> again and after that 'configure' had no problems.
> >
> >Autoconf has its own pitfalls... I can't reproduce it so I added
> >'aclocal -I m4' to autogen.sh.
> 
> That is not necessary, because we already have ACLOCAL_AMFLAGS = -I m4
> in Makefile.am.

Yes, I know. Still I had a little hope that that'd fix the issue.
Do you have another idea? Should for example /usr/share/aclocal/pkg.m4 be 
unconditionally copied into m4/ by autogen.sh?
 
> >> Next, I got this:
> >> 
> >> session.c: In function 'attr2data':
> >> session.c:566: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
> >> this function)
> >> session.c:566: error: (Each undeclared identifier is reported only once
> >> session.c:566: error: for each function it appears in.)
> >> session.c: In function 'decode_errmsg':
> >> session.c:1216: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
> >> this function)
> >> session.c: In function 'attr_len':
> >> session.c:1338: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
> >> this function)
> >
> >Your kernel header files at the default location is not recent enough.
> >
> >I'm undecided yet how to solve it: maybe it should be checked by configure 
> >and fail immediately.
> 
> Since this popped up in another thread: 2.6.24 is the minimal version
> for this.
> 
> And somehow, it feels like it would suck to add extra 
> #ifndef-#define-#endif to all projects (currently that would already be 
> libmnl and ipset5) just for CentOS. If one does their own kernel, surely 
> it's just a command away from `make headers_install`.

Yes, exactly. I'm going to add checks to configure so it'll fail if the 
definitions are missing from the header file. Also, I'll add just the 
compiler warning flags which are supported by the actual compiler and thus
--disable-extra-flags can be eliminated.
 
> >Please read the README file: you must patch your kernel source with 
> >netlink.patch, compile and install it. Otherwise the new nfnetlink id 
> >won't handled by the kernel and thus ipset can't work.
> 
> ipset could try using both nfnetlink and genetlink, in case
> NFNL_SUBSYS_IPSET is not defined, couldn't it?

Yes, it could. It's unfortunate that old ipset modules could be compiled 
without any kernel patching while new one needs it. But we are on the 
right track: Dave accepted my jhash.h patch in net-next-2.6 and as it is 
propagated into Patrick's tree, I'll be able to submit the ipset 5.x 
kernel patches. But there's no need to rush: I hope I can get feedback 
from other architectures, like Sparc or ARM too. (On Wednesday I'll be 
able to dust off a Sparc machine and run the compilation and testsuite.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
