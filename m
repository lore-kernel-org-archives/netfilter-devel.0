From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing
 infrastructure
Date: Fri, 27 Nov 2015 01:24:58 +0000
Message-ID: <20151127012457.GA4263@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-3-git-send-email-fw@strlen.de>
 <20151126232035.GB10961@macbook.localdomain>
 <20151127001054.GE32716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41208 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbbK0BZH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 20:25:07 -0500
Content-Disposition: inline
In-Reply-To: <20151127001054.GE32716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > @@ -196,7 +214,8 @@ next_rule:
> > >  		goto next_rule;
> > >  	}
> > >  
> > > -	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
> > > +	nft_trace_packet(&info, pkt, basechain, NULL, NULL, -1,
> > > +			 NFT_TRACETYPE_POLICY);
> > 
> > We unfortunately don't get the actual policy this way. I know we don't
> > have a verdict struct available, but would be nice to fix this.
> 
> Suggestions?  Should I add a new attribute or pretend policy was a
> verdict? (i.e., add fake verdict struct and set verdict code to policy)?

I don't see any other alternative right now.

> > > +	if (pkt->out &&
> > > +	    nla_put_be32(nlskb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
> > > +		return -1;
> > 
> > I think we might also need the OIFTYPE and the hook number for full coverage.
> > On the output path we don't have an iif but still might have an LL header.
> 
> Okay. Any preference on how to do this?
> I.e, should I include OIFTYPE only if no indev is available?
> 
> Alternatives would be to include both and let userspace decide
> or use more generic DEV_TYPE attr that is set to indev->type,
> and, if no indev is there, outdev->type?

One of both *seems* fine. If we have an iif, the header is still based
on the received packet. If we only have an oif, the header, if present,
will be based on that type, so I think that should work.

> > > +static int nf_trace_fill_chain_info(struct sk_buff *nlskb,
> > > +				    const struct nft_chain *chain)
> > > +{
> > > +	if (nla_put_string(nlskb, NFTA_TRACE_TABLE, chain->table->name))
> > > +		return -1;
> > > +
> > > +	return nla_put_string(nlskb, NFTA_TRACE_CHAIN, chain->name);
> > 
> > I think we also need the netfilter family here. We get pkt->pf, but that
> > might differ from the table/chain family in case of NFPROTO_INET.
> 
> Good point, will add NFTA_TRACE_FAMILY

Actually thinking about that, all the other nftables messages use the
netfilter family for nfgen_family, so for consistency we should do that
as well and put pkt->pf in the new attribute.

> > now we get IPv4/v6 and are unable to look up any objects since we're searching
> > in the wrong family.
> > 
> > > +void nft_trace_start(struct sk_buff *skb)
> > > +{
> > > +	u32 seq = atomic_inc_return(&trace_cnt) << NFT_ID_SKB_HASHBITS;
> > > +
> > > +	__this_cpu_write(trace_seq, seq);
> > 
> > So we're using a global counter to initialize the per CPU vars? That doesn't
> > seem to make sense. I was thinking about partitioning the ID space among
> > CPUs in advance, this global counter kind of defeats using per CPU at all.
> > 
> > Ok I think I see what you're doing here, you want a stable ID while the
> > packet is processed.
> 
> Yes, that was the idea -- which is why v1 used hash_ptr(skb)
> 
> > The problem is we can not really guarantee that for
> > the output path with involuntary preemption, between different hook
> > invocations another packet might come along.
> 
> Yes.
> 
> > I actually didn't consider that we need to get the same ID multiple times
> > when I suggested the per CPU counter, I was only thinking about getting a
> > non-clashing ID *once*.
> 
> Oh.  What would be the purpose of that?
> The idea was to allow to easily figure out which trace messages belong
> to the same packet. (i.e., don't make it difficult to dissect events
> from different packets being processed on other cpus...)

Yeah, I didn't consider that we need to get the same identifier in
multiple hook invocations. 

> > I think we need to come up with a different idea,
> > sorry about that.
> 
> Hmm, in that case I have no idea how to fix this, sorry.
> Only *stable* id is hashing skb address, but as you pointed out
> that causes fast id reuse
> 
> (I think that would be ok, since its good enough to tell
>  near-simultaneous trace events apart).

I also don't have a better suggestion right now. We could try to find
additional skb members that are stable within netfilter, but other than
that I have no better ideas.
