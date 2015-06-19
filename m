From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next, v4] netfilter: nft_counter: convert it to use
 per-cpu counters
Date: Fri, 19 Jun 2015 07:00:31 -0700
Message-ID: <1434722431.31511.20.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1434710457-2823-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36666 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbFSOAf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 10:00:35 -0400
Received: by wicnd19 with SMTP id nd19so20006259wic.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2015 07:00:34 -0700 (PDT)
In-Reply-To: <1434710457-2823-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2015-06-19 at 12:40 +0200, Pablo Neira Ayuso wrote:
> This patch converts the existing seqlock to per-cpu counters.
> 
> Suggested-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_counter.c |   97 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 69 insertions(+), 28 deletions(-)
> 
> diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
> index 1759123..84b22d8 100644
> --- a/net/netfilter/nft_counter.c
> +++ b/net/netfilter/nft_counter.c
> @@ -18,40 +18,58 @@
>  #include <net/netfilter/nf_tables.h>
>  
>  struct nft_counter {
> -	seqlock_t	lock;
>  	u64		bytes;
>  	u64		packets;
>  };
>  
> +struct nft_counter_percpu {
> +	struct nft_counter	counter;
> +	struct u64_stats_sync	syncp;
> +};
> +
> +struct nft_counter_percpu_priv {
> +	struct nft_counter_percpu __percpu *counter;
> +};
> +
>  static void nft_counter_eval(const struct nft_expr *expr,
>  			     struct nft_regs *regs,
>  			     const struct nft_pktinfo *pkt)
>  {
> -	struct nft_counter *priv = nft_expr_priv(expr);
> -
> -	write_seqlock_bh(&priv->lock);
> -	priv->bytes += pkt->skb->len;
> -	priv->packets++;
> -	write_sequnlock_bh(&priv->lock);
> +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> +	struct nft_counter_percpu *this_cpu;
> +
> +	this_cpu = this_cpu_ptr(priv->counter);
> +	u64_stats_update_begin(&this_cpu->syncp);

This is suspect : You had _bh() before this patch, so are you sure BH
are disabled at this point ?

Otherwise you could have reentrancy problem and lose a syncp update and
hang a reader forever.

> +	this_cpu->counter.bytes += pkt->skb->len;
> +	this_cpu->counter.packets++;
> +	u64_stats_update_end(&this_cpu->syncp);
>  }
>  
>  static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  {
> -	struct nft_counter *priv = nft_expr_priv(expr);
> +	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
> +	struct nft_counter_percpu *cpu_stats;
> +	struct nft_counter total;
> +	u64 bytes, packets;
>  	unsigned int seq;
> -	u64 bytes;
> -	u64 packets;
> -
> -	do {
> -		seq = read_seqbegin(&priv->lock);
> -		bytes	= priv->bytes;
> -		packets	= priv->packets;
> -	} while (read_seqretry(&priv->lock, seq));
> -
> -	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(bytes)))
> -		goto nla_put_failure;
> -	if (nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(packets)))
> +	int cpu;
> +
> +	memset(&total, 0, sizeof(total));
> +	for_each_possible_cpu(cpu) {
> +		cpu_stats = per_cpu_ptr(priv->counter, cpu);
> +		do {
		
			seq = u64_stats_fetch_begin_irq(&cpu_stats->syncp);

> +			bytes	= cpu_stats->counter.bytes;
> +			packets	= cpu_stats->counter.packets;
> +		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
> +
> +		total.packets += packets;
> +		total.bytes += bytes;
> +	}
> +

--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
