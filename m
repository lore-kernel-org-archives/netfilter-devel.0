From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Linux 4.2 build error in
 net/netfilter/ipset/ip_set_hash_netnet.c
Date: Tue, 14 Jul 2015 19:12:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1507141910280.28425@blackhole.kfki.hu>
References: <CAHTgTXUmreHAqPfgGEd+GJNb_OEzaCuytqBTjZsE2GDqiy3TCw@mail.gmail.com> <20150705153520.GA23589@roeck-us.net> <mo0o3b$g5d$1@ger.gmane.org> <20150713164122.GA26283@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Akemi Yagi <amyagi@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:44475 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbbGNRMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jul 2015 13:12:13 -0400
In-Reply-To: <20150713164122.GA26283@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 13 Jul 2015, Pablo Neira Ayuso wrote:

> On Mon, Jul 13, 2015 at 04:13:31PM +0000, Akemi Yagi wrote:
> > On Sun, 05 Jul 2015 08:35:20 -0700, Guenter Roeck wrote:
> > 
> > > On Sat, Jul 04, 2015 at 12:44:36AM -0700, Vinson Lee wrote:
> > >> Hi.
> > >> 
> > >> With the latest Linux 4.2-rc1, I am hitting this build error with GCC
> > >> 4.4.7 on CentOS 6.
> > >> 
> > >>   CC      net/netfilter/ipset/ip_set_hash_netnet.o
> > >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
> > >> ?hash_netnet4_uadt?:
> > >> net/netfilter/ipset/ip_set_hash_netnet.c:163: error: unknown field
> > >> ?cidr? specified in initializer
> > >> net/netfilter/ipset/ip_set_hash_netnet.c:163: warning: missing braces
> > >> around initializer net/netfilter/ipset/ip_set_hash_netnet.c:163:
> > >> warning: (near initialization for ?e.<anonymous>.ip?)
> > >> net/netfilter/ipset/ip_set_hash_netnet.c: In function
> > >> ?hash_netnet6_uadt?:
> > >> net/netfilter/ipset/ip_set_hash_netnet.c:388: error: unknown field
> > >> ?cidr? specified in initializer
> > >> net/netfilter/ipset/ip_set_hash_netnet.c:388: warning: missing braces
> > >> around initializer net/netfilter/ipset/ip_set_hash_netnet.c:388:
> > >> warning: (near initialization for ?e.ip[0]?)
> > >> 
> > > Previously fixed with commit 1a869205c75cb ("netfilter: ipset: The
> > > unnamed union initialization may lead to compilation error"),
> > > reintroduced with commit aff227581ed1a ("netfilter: ipset: Check CIDR
> > > value only when attribute is given").
> > > 
> > > Guenter
> > 
> > I wonder what can be done to get this issue fixed. This problem was seen 
> > in 4.2-rc1 and now in 4.2-rc2 on RHEL-6.6.
> > 
> > $ gcc --version
> > gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-11)
> 
> Could you please test this patch? Thank you.

As I mentioned at the workshop, the patch 
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch has been 
added to the -mm tree at Jun 17. My impression was that that way the bug 
was fixed and everything was all right.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
