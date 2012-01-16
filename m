From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/8] ipset patches
Date: Tue, 17 Jan 2012 00:08:34 +0100
Message-ID: <20120116230834.GA18052@1984>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
 <20120116124559.GB13131@1984>
 <alpine.DEB.2.00.1201161650330.32599@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2APXIl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:08:41 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201161650330.32599@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2012 at 04:52:21PM +0100, Jozsef Kadlecsik wrote:
> On Mon, 16 Jan 2012, Pablo Neira Ayuso wrote:
> 
> > On Sat, Jan 14, 2012 at 05:38:53PM +0100, Jozsef Kadlecsik wrote:
> > > 
> > > Here follow the patches which bring the kernel in sync with the current
> > > ipset release. I included the patches which was sent in September but was
> > > forgotten due to the kernel.org issues. Please consider applying them.
> > > 
> > > Jan Engelhardt (3):
> > >   netfilter: ipset: use NFPROTO_ constants
> > >   netfilter: ipset: avoid use of kernel-only types
> > >   netfilter: ipset: expose userspace-relevant parts in ip_set.h
> > > 
> > > Jozsef Kadlecsik (5):
> > >   netfilter: ipset: Autoload set type modules safely
> > >   netfilter: ipset: Dumping error triggered removing references twice
> > >   netfilter: ipset: Log warning when a hash type of set gets full
> > >   netfilter: ipset: Exceptions support added to hash:*net* types
> > >   netfilter: ipset: hash:net,iface timeout bug fixed
> > 
> > Thanks Jozsef. I'll take this once. net-next becomes active again
> > (after -rc1 is released).
> > 
> > It would *really* great if you can set some git tree I can pull
> > your changes from.
> 
> Here you are, you can pull the changes from
> 
> 	git://blackhole.kfki.hu/git/net-next ipset

Thanks Jozsef.

I have put these into one ipset branch in my net-next tree. I'll merge
your changes and pass it to davem once net-next becomes active again.
