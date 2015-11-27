From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing
 infrastructure
Date: Fri, 27 Nov 2015 01:10:54 +0100
Message-ID: <20151127001054.GE32716@breakpoint.cc>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-3-git-send-email-fw@strlen.de>
 <20151126232035.GB10961@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37921 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502AbbK0AK4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 19:10:56 -0500
Content-Disposition: inline
In-Reply-To: <20151126232035.GB10961@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 26.11, Florian Westphal wrote:
> > +int nft_verdict_dump(struct sk_buff *skb,
> > +		     const struct nft_verdict *v, u16 type);
> 
> We usually use "struct sk_buff *skb, int attr, ...". I know int is actually
> not the correct type but that's what all the nla_ functions use. Let's keep
> it consistent please.

OK.

> > +struct nft_traceinfo {
> > +	const struct nft_chain *chain;
> > +	const struct nft_rule *rule;
> > +	const struct nft_verdict *verdict;
> > +	enum nft_trace_types type;
> > +
> > +	bool packet_dumped;
> > +};
> 
> Also consistent style please, all structs in that file indent the field
> names neatly and they are usually also commented.

Fair enough.

> > +++ b/net/netfilter/nf_tables_core.c
> > @@ -196,7 +214,8 @@ next_rule:
> >  		goto next_rule;
> >  	}
> >  
> > -	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
> > +	nft_trace_packet(&info, pkt, basechain, NULL, NULL, -1,
> > +			 NFT_TRACETYPE_POLICY);
> 
> We unfortunately don't get the actual policy this way. I know we don't
> have a verdict struct available, but would be nice to fix this.

Suggestions?  Should I add a new attribute or pretend policy was a
verdict? (i.e., add fake verdict struct and set verdict code to policy)?

> > +	if (pkt->out &&
> > +	    nla_put_be32(nlskb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
> > +		return -1;
> 
> I think we might also need the OIFTYPE and the hook number for full coverage.
> On the output path we don't have an iif but still might have an LL header.

Okay. Any preference on how to do this?
I.e, should I include OIFTYPE only if no indev is available?

Alternatives would be to include both and let userspace decide
or use more generic DEV_TYPE attr that is set to indev->type,
and, if no indev is there, outdev->type?

> > +static int nf_trace_fill_chain_info(struct sk_buff *nlskb,
> > +				    const struct nft_chain *chain)
> > +{
> > +	if (nla_put_string(nlskb, NFTA_TRACE_TABLE, chain->table->name))
> > +		return -1;
> > +
> > +	return nla_put_string(nlskb, NFTA_TRACE_CHAIN, chain->name);
> 
> I think we also need the netfilter family here. We get pkt->pf, but that
> might differ from the table/chain family in case of NFPROTO_INET.

Good point, will add NFTA_TRACE_FAMILY

> now we get IPv4/v6 and are unable to look up any objects since we're searching
> in the wrong family.
> 
> > +void nft_trace_start(struct sk_buff *skb)
> > +{
> > +	u32 seq = atomic_inc_return(&trace_cnt) << NFT_ID_SKB_HASHBITS;
> > +
> > +	__this_cpu_write(trace_seq, seq);
> 
> So we're using a global counter to initialize the per CPU vars? That doesn't
> seem to make sense. I was thinking about partitioning the ID space among
> CPUs in advance, this global counter kind of defeats using per CPU at all.
> 
> Ok I think I see what you're doing here, you want a stable ID while the
> packet is processed.

Yes, that was the idea -- which is why v1 used hash_ptr(skb)

> The problem is we can not really guarantee that for
> the output path with involuntary preemption, between different hook
> invocations another packet might come along.

Yes.

> I actually didn't consider that we need to get the same ID multiple times
> when I suggested the per CPU counter, I was only thinking about getting a
> non-clashing ID *once*.

Oh.  What would be the purpose of that?
The idea was to allow to easily figure out which trace messages belong
to the same packet. (i.e., don't make it difficult to dissect events
from different packets being processed on other cpus...)

> I think we need to come up with a different idea,
> sorry about that.

Hmm, in that case I have no idea how to fix this, sorry.
Only *stable* id is hashing skb address, but as you pointed out
that causes fast id reuse

(I think that would be ok, since its good enough to tell
 near-simultaneous trace events apart).

