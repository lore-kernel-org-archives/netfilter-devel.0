From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 v2] netfilter: nf_tables: fix oops when using gotos
Date: Fri, 7 Feb 2014 16:34:33 +0000
Message-ID: <20140207163432.GB24391@macbook.localnet>
References: <1391790598-5390-1-git-send-email-pablo@netfilter.org>
 <1391790598-5390-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGQel (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:34:41 -0500
Content-Disposition: inline
In-Reply-To: <1391790598-5390-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 07, 2014 at 05:29:58PM +0100, Pablo Neira Ayuso wrote:
> Fix an oops if you use the "goto" operation, you will end up in
> non-base chain with no counters and no default policy.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: recover inline to nft_chain_stats.
> 
>  net/netfilter/nf_tables_core.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index 0d879fc..13fecde 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -67,18 +67,24 @@ struct nft_jumpstack {
>  	int			rulenum;
>  };
>  
> -static inline void
> +static inline int
>  nft_chain_stats(const struct nft_chain *this, const struct nft_pktinfo *pkt,
>  		struct nft_jumpstack *jumpstack, unsigned int stackptr)
>  {
>  	struct nft_stats __percpu *stats;
>  	const struct nft_chain *chain = stackptr ? jumpstack[0].chain : this;
>  
> +	/* You can reach this through goto chain */
> +	if (!(chain->flags & NFT_BASE_CHAIN))
> +		return NF_ACCEPT;
> +
>  	rcu_read_lock_bh();
>  	stats = rcu_dereference(nft_base_chain(chain)->stats);
>  	__this_cpu_inc(stats->pkts);
>  	__this_cpu_add(stats->bytes, pkt->skb->len);
>  	rcu_read_unlock_bh();
> +
> +	return nft_base_chain(chain)->policy;
>  }
>  
>  enum nft_trace {
> @@ -209,12 +215,11 @@ next_rule:
>  		rulenum = jumpstack[stackptr].rulenum;
>  		goto next_rule;
>  	}
> -	nft_chain_stats(chain, pkt, jumpstack, stackptr);
>  
>  	if (unlikely(pkt->skb->nf_trace))
>  		nft_trace_packet(pkt, chain, ++rulenum, NFT_TRACE_POLICY);
>  
> -	return nft_base_chain(chain)->policy;
> +	return nft_chain_stats(chain, pkt, jumpstack, stackptr);

I think we should just inline the function manually, it doesn't help
readability to have it take care of goto-specific cases and handle
verdicts/policies.

Also, what about NFT_TRACE_POLICY for the goto case? Should be generate
a message even through there is no policy?
