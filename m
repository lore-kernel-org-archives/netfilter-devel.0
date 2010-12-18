From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 16:43:33 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info> <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47377 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab0LRPnd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:43:33 -0500
In-Reply-To: <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-12-18 12:13, Jozsef Kadlecsik wrote:
>On Sat, 18 Dec 2010, Rob Sterenborg (lists) wrote:
>
>> On Fri, 2010-12-17 at 23:26 +0100, Jozsef Kadlecsik wrote:
>> > 
>> > I'm happy to announce the new branch of ipset and release it's first 
>> > element, ipset-5.0.
>> 
>> I'm not a C programmer. I just tried to make ipset compile which seems
>> to have worked partially. I have no clue if I did the right thing so the
>> below should be reviewed.
>> 
>> I'm on CentOS 5.5 with a custom 2.6.36.2 kernel, gcc version 4.1.2
>> 20080704 (Red Hat 4.1.2-48).
>> 
>> When running 'configure' I got this error:
>> 
>> ./configure: line 11510: syntax error near unexpected token `[libmnl],'
>> ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >= 1])'
>> 
>> CentOS' pkg-config is installed, so, for reference: I copied
>> '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.sh'
>> again and after that 'configure' had no problems.
>
>Autoconf has its own pitfalls... I can't reproduce it so I added
>'aclocal -I m4' to autogen.sh.

That is not necessary, because we already have ACLOCAL_AMFLAGS = -I m4
in Makefile.am.

>> Next, I got this:
>> 
>> session.c: In function 'attr2data':
>> session.c:566: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
>> this function)
>> session.c:566: error: (Each undeclared identifier is reported only once
>> session.c:566: error: for each function it appears in.)
>> session.c: In function 'decode_errmsg':
>> session.c:1216: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
>> this function)
>> session.c: In function 'attr_len':
>> session.c:1338: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in
>> this function)
>
>Your kernel header files at the default location is not recent enough.
>
>I'm undecided yet how to solve it: maybe it should be checked by configure 
>and fail immediately.

Since this popped up in another thread: 2.6.24 is the minimal version
for this.

And somehow, it feels like it would suck to add extra #ifndef-#define-#endif
to all projects (currently that would already be libmnl and ipset5)
just for CentOS.
If one does their own kernel, surely it's just a command away
from `make headers_install`.

A few years ago, I had a similar, though more extreme, issue as the
developer of pam_mount, redhat shipped some kernel 2.6, but headers
for 2.4. Tell ya _that_ sucks.

>> # lsmod|grep set
>> ip_set                 16790  0 
>> nfnetlink               3179  2 ip_set,nf_conntrack_netlink
>> 
>> So, I guess something must have gone wrong when compiling ipset anyhow.
>
>Please read the README file: you must patch your kernel source with 
>netlink.patch, compile and install it. Otherwise the new nfnetlink id 
>won't handled by the kernel and thus ipset can't work.

ipset could try using both nfnetlink and genetlink, in case
NFNL_SUBSYS_IPSET is not defined, couldn't it?
