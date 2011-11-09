From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ipset: usage of unitialized variable ip_to in
 ip_set_hash_ipportnet.c
Date: Wed, 9 Nov 2011 15:37:12 +0100
Message-ID: <20111109143712.GB24174@1984>
References: <20111107221823.GH18221@smp.if.uj.edu.pl>
 <alpine.DEB.2.00.1111080848040.29308@blackhole.kfki.hu>
 <20111108120000.GJ18221@smp.if.uj.edu.pl>
 <alpine.DEB.2.00.1111090040170.32599@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1KIOhT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:37:19 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111090040170.32599@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 09, 2011 at 12:47:05AM +0100, Jozsef Kadlecsik wrote:
> On Tue, 8 Nov 2011, Witold Baryluk wrote:
> 
> > On 11-08 08:56, Jozsef Kadlecsik wrote:
> > > 
> > > On Mon, 7 Nov 2011, Witold Baryluk wrote:
> > > 
> > > > in file et/netfilter/ipset/ip_set_hash_ipportnet.c
> > > > in functionhash_ipportnet4_uadt(...)
> > > > variable u32 ip_to, can be used uninitialized
> > > > in line 283
> > > > 	for (; !before(ip_to, ip); ip++) {
> > > > 
> > > > because, if both tb[IPSET_ATTR_IP_TO] and tb[IPSET_ATTR_CIDR]
> > > > are false, then there is no initialization of ip_to.
> > > > 
> > > >   CC [M]  net/netfilter/ipset/ip_set_hash_ipportnet.o
> > > > net/netfilter/ipset/ip_set_hash_ipportnet.c: In function ?hash_ipportnet4_uadt?:
> > > > include/net/tcp.h:266:28: warning: ?ip_to? may be used uninitialized in this function [-Wuninitialized]
> > > > net/netfilter/ipset/ip_set_hash_ipportnet.c:187:10: note: ?ip_to? was declared here
> > > 
> > > Which ipset version you are looking at? What gcc version are you running?
> > 
> > sorry to not mention it.
> > 
> > I'm compiling on 32-bit Intel x86, using gcc 4.6.2-4 with -march=pentium-m.
> > I'm using current/today mainline Linus' tree.
> > Last significant ipset change in this tree is from Jul 21, 2011.
> 
> Oops, that patch was not submitted to kernel inclusion. The merge window 
> has just opened up, I'm going to send it in the next day.

I'll be happy to take that patch.
