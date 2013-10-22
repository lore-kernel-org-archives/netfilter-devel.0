From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ordering of jumpstack allocation and
 table update
Date: Tue, 22 Oct 2013 10:21:59 +0200
Message-ID: <20131022082159.GA20713@localhost>
References: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
 <20131018111536.GA11132@localhost>
 <20131018165749.GI3296@mudshark.cambridge.arm.com>
 <1382116693.3284.21.camel@edumazet-glaptop.roam.corp.google.com>
 <20131021121452.GA29250@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54429 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab3JVIWF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:22:05 -0400
Content-Disposition: inline
In-Reply-To: <20131021121452.GA29250@mudshark.cambridge.arm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 21, 2013 at 01:14:53PM +0100, Will Deacon wrote:
> On Fri, Oct 18, 2013 at 06:18:13PM +0100, Eric Dumazet wrote:
> > On Fri, 2013-10-18 at 17:57 +0100, Will Deacon wrote:
> > > Hi Pablo,
> > > 
> > 
> > > > We also need fixes for net/ipv6/netfilter/ip6_tables.c and
> > > > net/ipv4/netfilter/arp_tables.c as well. Could you extend this patch
> > > > and resend?
> > > 
> > > Sure, I can try, but that's going to require a bit of time to sit down and
> > > look at the shared data, access order, dependencies etc. I'm currently
> > > preparing for Edinburgh, so it might be a while before I get a chance to
> > > extend this.
> > 
> > That's basically same code copy/pasted, so it should be relatively easy.
> 
> Ok, I took a look and I think I see what you mean: there are just some
> additional consumers of the tables, so there aren't any additional writers
> afaict (at least, net/bridge/netfilter/ebtables.c uses rw locks so we don't
> have an issue there).
> 
> Attempt at an updated patch below.

Applied, thanks Will.
