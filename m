From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2 1/4] bridge: detect NAT66 correctly and change MAC
 address
Date: Mon, 23 Mar 2015 13:41:58 +0100
Message-ID: <20150323124158.GA6203@breakpoint.cc>
References: <54AF1B47.7020601@wvnet.at>
 <1426715531-16862-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150323120748.GA6300@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bernhard Thaler <bernhard.thaler@wvnet.at>,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de, Sven Eckelmann <sven@open-mesh.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43787 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbbCWMmC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 08:42:02 -0400
Content-Disposition: inline
In-Reply-To: <20150323120748.GA6300@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Florian Westphal is currently exploring alternative solutions so
> br_netfilter can stop (ab)using the layer 3 infrastructure from the
> bridge code (this layering violation has been causing problems for
> quite some time, eg. some users don't expect a bridge to modify alter
> the fragmented traffic).
> 
> Although IPv6 support in br_netfilter is fairly incomplete, let me put
> these patches in a hold until Florian comes back to us with some
> feedback, we'll integrate them in some way or another at some point.

TBH I am not too sure abut this.

IPv4 DNAT doesn't work 100% either, see

http://marc.info/?l=linux-netdev&m=136627779125382&w=2

[ btw, thanks that the crap patch referenced above didn't end up in the kernel ;) ]

So I think we first need to _clearly_ define how DNAT should work on a
bridge, rather than inherit all the weird corner cases that we have
with ipv4.

F.e. I think we wouldn't have all of these issues if we wouldn't care
about the l2 mac address (and would always route in NAT case).

But I'll have to think about this some more.

In any case, I understand that not being able to e.g. REDIRECT is bad,
and perhaps it would be preferable to first fix ipv6 fragment
handling and then make REDIRECT work (and defer handling/supporting arbitrary DNAT
until we think we know how it should work).

One small comment on the patch below.

> > @@ -57,6 +58,7 @@ static inline unsigned int nf_bridge_pad(const struct sk_buff *skb)
> >  struct bridge_skb_cb {
> >  	union {
> >  		__be32 ipv4;
> > +		struct in6_addr ipv6;
> >  	} daddr;

This is gone, dnat_took_place() should work without further changes if
you call it in the ipv6 prerouting finish hook.

> > +/* This requires some explaining. If DNAT has taken place,
> > + * we will need to fix up the destination Ethernet address.
> > + *

I really think this novel^W comment should not be copied, just add a
reference to the ipv4 one.
