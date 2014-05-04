From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Sun, 4 May 2014 13:15:17 +0200
Message-ID: <20140504111517.GA3591@localhost>
References: <20140430092905.GA4318@localhost>
 <5363BC86.6050608@parallels.com>
 <20140502225522.GA12404@breakpoint.cc>
 <20140503233908.GA6297@localhost>
 <20140504002317.GD3514@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vasily Averin <vvs@parallels.com>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36739 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaEDLPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 07:15:23 -0400
Content-Disposition: inline
In-Reply-To: <20140504002317.GD3514@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 04, 2014 at 02:23:17AM +0200, Florian Westphal wrote:
[...]
> > We also have the tproxy target and the socket match, they seem to
> > require defragmentation as well, I'm afraid the skb->nfct check will
> > not help for those cases. I think that we need some counter to know
> > how many clients we have that require the gathering + fragmentation
> > code, so if we have at least one, we have to enable it.
> 
> Last time I tried TPROXY on top of bridge it was a pain in the neck.
> 
> Essentially one has to build a 'brouter' and force packets
> upwards the stack (DROP via ebtables in broute table).
> 
> Such packets will not be seen by the bridge since they're routed
> normally via the ip stack for local delivery.
> 
> (-j TPROXY needs policy routing for the redirect to work).
> 
> It is also rather fragile in my experience (due to ebtables just
> seeing ethernet frames doing 'broute DROP only for tcp port 80' doesn't work
> universally since we don't see netfilter-defragmented packets at that stage).

All those bridge-nf-call-* were quite a hack IMO, I don't think this
is the only extension with problems.

> All things considered I think that just doing the re-fragmentation (aka
> just remove skb->nfct test) is really the least-sucky one of the options
> we have.

I see, and I think it's reasonable to assume that if nf_defrag_* is
loaded, the user expects that its bridge may fragment traffic. OK,
let's remove the skb->nfct check there.

> If you do IP NAT/TPROXY/conntrack on bridges you're already asking for varying
> degrees of layering violations, so I think it would at least be preferable to
> have one that "works" :-)

Perhaps it would be good to restrict extensions that we know that
don't work/have severe limitations to iptables/ip6tables, at least
those that we really know that don't work or need some more bits to
get them working.
