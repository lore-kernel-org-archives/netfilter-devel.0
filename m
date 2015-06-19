From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next,v2] netfilter: nft_counter: convert it to use
 per-cpu counters
Date: Fri, 19 Jun 2015 11:39:37 +0200
Message-ID: <20150619093937.GD22946@acer.localdomain>
References: <1434706590-3560-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54544 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbbFSJjl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 05:39:41 -0400
Content-Disposition: inline
In-Reply-To: <1434706590-3560-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.06, Pablo Neira Ayuso wrote:
>  static void nft_counter_eval(const struct nft_expr *expr,
>  			     struct nft_regs *regs,
>  			     const struct nft_pktinfo *pkt)
>  {
> -	struct nft_counter *priv = nft_expr_priv(expr);
> +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> +	struct nft_counter_percpu *this_cpu;
>  
> -	write_seqlock_bh(&priv->lock);
> -	priv->bytes += pkt->skb->len;
> -	priv->packets++;
> -	write_sequnlock_bh(&priv->lock);
> +	this_cpu = this_cpu_ptr(priv->counter);
> +	this_cpu->counter.bytes += pkt->skb->len;
> +	this_cpu->counter.packets++;

u64_state_update_begin()/end()?

> @@ -67,23 +83,46 @@ static int nft_counter_init(const struct nft_ctx *ctx,
>  			    const struct nft_expr *expr,
>  			    const struct nlattr * const tb[])
>  {
> -	struct nft_counter *priv = nft_expr_priv(expr);
> -
> -	if (tb[NFTA_COUNTER_PACKETS])
> -	        priv->packets = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
> -	if (tb[NFTA_COUNTER_BYTES])
> -		priv->bytes = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
> +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> +	struct nft_counter_percpu __percpu *cpu_stats;
> +	struct nft_counter_percpu *this_cpu;
> +
> +	cpu_stats = netdev_alloc_pcpu_stats(struct nft_counter_percpu);
> +	if (cpu_stats == NULL)
> +		return ENOMEM;
> +
> +	preempt_disable();

Seems unnecessary, the stats are not active durign ->init().

> +	this_cpu = this_cpu_ptr(cpu_stats);
> +	if (tb[NFTA_COUNTER_PACKETS]) {
> +	        this_cpu->counter.packets =
> +			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
> +	}
> +	if (tb[NFTA_COUNTER_BYTES]) {
> +		this_cpu->counter.bytes =
> +			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
> +	}
> +	preempt_enable();
> +
> +	priv->counter = cpu_stats;
>  
> -	seqlock_init(&priv->lock);
>  	return 0;
>  }
