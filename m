From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing
 infrastructure
Date: Thu, 26 Nov 2015 23:20:35 +0000
Message-ID: <20151126232035.GB10961@macbook.localdomain>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40369 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbbKZXUk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 18:20:40 -0500
Content-Disposition: inline
In-Reply-To: <1448560779-28989-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> nft monitor mode can then decode and display this trace data.

First round of comments below:

> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 101d7d7..59331ba 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
>  
> +int nft_verdict_dump(struct sk_buff *skb,
> +		     const struct nft_verdict *v, u16 type);

We usually use "struct sk_buff *skb, int attr, ...". I know int is actually
not the correct type but that's what all the nla_ functions use. Let's keep
it consistent please.

> +struct nft_traceinfo {
> +	const struct nft_chain *chain;
> +	const struct nft_rule *rule;
> +	const struct nft_verdict *verdict;
> +	enum nft_trace_types type;
> +
> +	bool packet_dumped;
> +};

Also consistent style please, all structs in that file indent the field
names neatly and they are usually also commented.

> +++ b/net/netfilter/nf_tables_core.c
> @@ -196,7 +214,8 @@ next_rule:
>  		goto next_rule;
>  	}
>  
> -	nft_trace_packet(pkt, basechain, -1, NFT_TRACE_POLICY);
> +	nft_trace_packet(&info, pkt, basechain, NULL, NULL, -1,
> +			 NFT_TRACETYPE_POLICY);

We unfortunately don't get the actual policy this way. I know we don't
have a verdict struct available, but would be nice to fix this.

> +++ b/net/netfilter/nf_tables_trace.c
> +static int nf_trace_fill_meta_info(struct sk_buff *nlskb,
> +				   const struct nft_pktinfo *pkt)
> +{
> +	if (pkt->in) {
> +		if (nla_put_be32(nlskb, NFTA_TRACE_IIF,
> +				 htonl(pkt->in->ifindex)))
> +			return -1;
> +
> +		/* needed for LL_HEADER decode */
> +		if (nla_put_be16(nlskb, NFTA_TRACE_IIFTYPE,
> +				 htons(pkt->in->type)))
> +			return -1;
> +	}
> +
> +	if (pkt->out &&
> +	    nla_put_be32(nlskb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
> +		return -1;

I think we might also need the OIFTYPE and the hook number for full coverage.
On the output path we don't have an iif but still might have an LL header.

> +static int nf_trace_fill_chain_info(struct sk_buff *nlskb,
> +				    const struct nft_chain *chain)
> +{
> +	if (nla_put_string(nlskb, NFTA_TRACE_TABLE, chain->table->name))
> +		return -1;
> +
> +	return nla_put_string(nlskb, NFTA_TRACE_CHAIN, chain->name);

I think we also need the netfilter family here. We get pkt->pf, but that
might differ from the table/chain family in case of NFPROTO_INET. Right
now we get IPv4/v6 and are unable to look up any objects since we're searching
in the wrong family.

> +void nft_trace_start(struct sk_buff *skb)
> +{
> +	u32 seq = atomic_inc_return(&trace_cnt) << NFT_ID_SKB_HASHBITS;
> +
> +	__this_cpu_write(trace_seq, seq);

So we're using a global counter to initialize the per CPU vars? That doesn't
seem to make sense. I was thinking about partitioning the ID space among
CPUs in advance, this global counter kind of defeats using per CPU at all.

Ok I think I see what you're doing here, you want a stable ID while the
packet is processed. The problem is we can not really guarantee that for
the output path with involuntary preemption, between different hook
invocations another packet might come along.

I actually didn't consider that we need to get the same ID multiple times
when I suggested the per CPU counter, I was only thinking about getting a
non-clashing ID *once*. I think we need to come up with a different idea,
sorry about that.

> +	skb->nf_trace = 1;
> +}
> +EXPORT_SYMBOL(nft_trace_start);
