From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next] netfilter: meta: add support for setting
 skb->pkttype
Date: Thu, 10 Dec 2015 02:41:18 +0100
Message-ID: <20151210014118.GA5665@breakpoint.cc>
References: <1449158201-23868-1-git-send-email-fw@strlen.de>
 <20151209225408.GA3086@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46002 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbbLJBlU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 20:41:20 -0500
Content-Disposition: inline
In-Reply-To: <20151209225408.GA3086@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 03, 2015 at 04:56:41PM +0100, Florian Westphal wrote:
> > This allows to redirect bridged packets to local machine.
> > 
> > ether type ip ether daddr set aa:53:08:12:34:56 meta pkttype set unicast
> > 
> > Without 'set unicast', ip stack discards PACKET_OTHERHOST skbs.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  Hi Patrick,
> > 
> >  as discussed this adds meta set support for pkttype.
> > 
> >  I'm not sure how restricted it should be; this only allows
> >  changing PACKET_OTHERHOST to something else, but I'm not sure
> >  if this should do more checks on value (e.g. only allow
> >  PACKET_HOST?) or even less (e.g. also allow mangling
> >  mcast and the like?).
> >
> >  It only allows NETDEV and BRIDGE families but thats mainly
> >  because the other ones make no sense (PACKET_OTHERHOST
> >  cannot happen w. IPV4, 6, INET since stack already drops them earlier).
> 
> With a 'hash' expression and this mangling, we can emulate the cluster
> match (hence its CLUSTERIP target predecesor too).

I forgot about -m cluster, so we definitely want to be able to change
MULTICAST to HOST.

So the only question is wheter we should allow setting it to arbitrary
value (e.g. PACKET_LOOPBACK).  I'm reasonably sure HOST/BROAD/MULTICAST
are okay.

I'll dig if that might cause any problems (esp. when considering
mangling happens in a netns).

> If mangling doesn't crash the kernel, ie. nonsense configuration just
> results in a drop, then I would make no restrictions.

Makes sense.

An updated patch to also permit MCAST will arrive in any case,
moved patchwork state to 'changes requested'.

Thanks!
