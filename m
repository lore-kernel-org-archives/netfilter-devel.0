From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Tue, 21 Feb 2017 15:40:19 +0100
Message-ID: <20170221144019.GD9708@breakpoint.cc>
References: <20170208221429.3555-1-fw@strlen.de>
 <20170221140909.GA3286@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60708 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752728AbdBUOla (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2017 09:41:30 -0500
Content-Disposition: inline
In-Reply-To: <20170221140909.GA3286@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Feb 08, 2017 at 11:14:29PM +0100, Florian Westphal wrote:
> > The comment is incorrect, this function does see fragments when
> > IP_NODEFRAG is used.  Remove the wrong assertion.
> > 
> > As conntrack doesn't track fragments skb->nfct will be null
> > and no nat is performed.
> 
> With IP_NODEFRAG, ipv4_conntrack_defrag() will just accept the packet.
> 
> So the first fragment will get into nf_conntrack_in(), and I think, if
> enough information is there in place, it will get a ct object.

ipv4_get_l4proto():
       if (iph->frag_off & htons(IP_OFFSET))
              return -NF_ACCEPT;

so yes, you are right, first packet will be tracked in this case.

> up fragments with offset != 0 which doesn't contain headers will
> definitely not get a ct object.
> 
> Shouldn't handle case this by attaching a template conntrack?
> Currently this IP_NODEFRAG case is going through as invalid traffic.
> 
> My impression is that we're handling this case in a sloppy way, am I
> missing anything?

What would you do instead?

We currently have a suboptimal handling of such cases, but I don't see
how we can change it without (possibly) breaking existing setups.
I also don't see how alternative handling is 'better'.

Tagging it as UNTRACKED seems wrong because its used for cases where
we could track but decide against it, e.g. due to -j NOTRACK or explicit
tracker whitelist (icmpv6 neigh for instance).

Documentation says (iptables-extensions):

  INVALID The packet is associated with no known connection.
  UNTRACKED  The packet is not tracked at all, which happens if  you
  explictly untrack it by using -j CT --notrack in the raw table.

(XXX: needs a sentence wrt. icmpv6...)

So current behaviour at least appears consistent with documentation.

> > diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> > ick_inndex f8aad03d674b..6f5e8d01b876 100644
> > --- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> > +++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> > @@ -255,11 +255,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
> >  	/* maniptype == SRC for postrouting. */
> >  	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
> >  
> > -	/* We never see fragments: conntrack defrags on pre-routing
> > -	 * and local-out, and nf_nat_out protects post-routing.
> > -	 */
> > -	NF_CT_ASSERT(!ip_is_fragment(ip_hdr(skb)));
> > -

We could make this a explicit test+return but that seems weird too,
we would track the first fragment but would not nat.

However, changing test to if (iph->frag_off) return -NF_ACCEPT seems
wrong too because we have enough info to track. OTOH, this only happens
with HDRINCL+raw socket so perhaps we shouldn't care about this and
just change ipv4 l3 tracker to ignore all packets w. iph->frag_off set.
