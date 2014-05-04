From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Sun, 4 May 2014 02:23:17 +0200
Message-ID: <20140504002317.GD3514@breakpoint.cc>
References: <20140430092905.GA4318@localhost>
 <5363BC86.6050608@parallels.com>
 <20140502225522.GA12404@breakpoint.cc>
 <20140503233908.GA6297@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Vasily Averin <vvs@parallels.com>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60017 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbaEDAXV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 May 2014 20:23:21 -0400
Content-Disposition: inline
In-Reply-To: <20140503233908.GA6297@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > ---[patch rfc]---
> > > Currently bridge can silently drop ipv4 fragments.
> > > If node have loaded nf_defrag_ipv4 module but have no nf_conntrack_ipv4,
> > > br_nf_pre_routing defragments incoming ipv4 fragments, but skb->nfct check
> > > in br_nf_dev_queue_xmit does not allow to re-fragment combined packet back,
> > > and therefore it is dropped in br_dev_queue_push_xmit without incrementing
> > > of any failcounters.
> > > 
> > > According to Patrick McHardy, bridge should not defragment and fragment
> > > packets unless conntrack is enabled.
> > > 
> > > This patch adds per network namespace flag to manage ipv4 defragmentation
> > > in bridge.
> > > 
> > > Signed-off-by: Vasily Averin <vvs@openvz.org>
> > 
> > Are we sure this is required rather than just removing the skb->nfct
> > test in br_nf_dev_queue_xmit() and be done with it?
> > 
> > Because that seems a lot saner to me, I fail to see how
> > 
> > if (skb->protocol == htons(ETH_P_IP) &&
> >            skb->len + nf_bridge_mtu_reduction(skb) >
> > 		    skb->dev->mtu && !skb_is_gso(skb)) {
> > 
> > Would evaluate as 'true' without nf_defrag_ipv4 module loaded.
> > 
> > [ its from br_nf_dev_queue_xmit function ]
> 
> I think we still may see IP packets larger than the mtu in that path.
> It would be a rare case since we need that the bridge has different
> (smaller) mtu than the sender, but still possible. The is_skb_forwardable()
> check in the current tree snapshot comes just a bit later, so if we
> remove that skb->nfct, the bridge will fragment large packets.

I have to confess that I never tried that out; I assumed the nic
would toss the over-mtu frame.

> In general, I believe bridges should silently drop packets that are
> larger than the mtu and they should perform no fragmentation handling,
> no gathering and no [re]fragmentation. They are transparent devices
> that operate at layer 2.

Not sure I agree.  Silent drops are bad (or perhaps I misunderstand you,
if we do 'silent drop' in br_nf_dev_queue_xmit there should at least be
a mib counter of some sort).

The last part stands of course, I agree that bridges should be
transparent and not do frag handling etc.

> The conntrack case is a special case that forces us to enable
> fragmentation handling since we get sort of a bridge that inspects
> layer 3 and 4 packet information. So we have sort of, let's call it, a
> mutant bridge.

Yes 8-/

> We also have the tproxy target and the socket match, they seem to
> require defragmentation as well, I'm afraid the skb->nfct check will
> not help for those cases. I think that we need some counter to know
> how many clients we have that require the gathering + fragmentation
> code, so if we have at least one, we have to enable it.

Last time I tried TPROXY on top of bridge it was a pain in the neck.

Essentially one has to build a 'brouter' and force packets
upwards the stack (DROP via ebtables in broute table).

Such packets will not be seen by the bridge since they're routed
normally via the ip stack for local delivery.

(-j TPROXY needs policy routing for the redirect to work).

It is also rather fragile in my experience (due to ebtables just
seeing ethernet frames doing 'broute DROP only for tcp port 80' doesn't work
universally since we don't see netfilter-defragmented packets at that stage).

All things considered I think that just doing the re-fragmentation (aka
just remove skb->nfct test) is really the least-sucky one of the options
we have.

If you do IP NAT/TPROXY/conntrack on bridges you're already asking for varying
degrees of layering violations, so I think it would at least be preferable to
have one that "works" :-)


