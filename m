From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: wrap tracing with a
 static key
Date: Tue, 24 Nov 2015 11:19:26 +0100
Message-ID: <20151124101926.GC2683@salvia>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36538 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbKXKTa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:19:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 92294FEFA8
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:19:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C95BDA86A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:19:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2FC5EDA86A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 11:19:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448359331-12692-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 11:02:07AM +0100, Florian Westphal wrote:
> Only needed when meta nftrace rule(s) were added.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_tables_core.h |  1 +
>  include/net/netfilter/nft_meta.h       |  3 +++
>  net/bridge/netfilter/nft_meta_bridge.c |  1 +
>  net/netfilter/nf_tables_core.c         | 20 +++++++++++++++-----
>  net/netfilter/nft_meta.c               | 15 +++++++++++++++
>  5 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
> index c6f400c..8ad6240 100644
> --- a/include/net/netfilter/nf_tables_core.h
> +++ b/include/net/netfilter/nf_tables_core.h
> @@ -48,6 +48,7 @@ struct nft_payload {
>  };
>  
>  extern const struct nft_expr_ops nft_payload_fast_ops;
> +extern struct static_key nft_trace_enabled;
>  
>  int nft_payload_module_init(void);
>  void nft_payload_module_exit(void);
> diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
> index 711887a..d27588c 100644
> --- a/include/net/netfilter/nft_meta.h
> +++ b/include/net/netfilter/nft_meta.h
> @@ -33,4 +33,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
>  		       struct nft_regs *regs,
>  		       const struct nft_pktinfo *pkt);
>  
> +void nft_meta_set_destroy(const struct nft_ctx *ctx,
> +			  const struct nft_expr *expr);
> +
>  #endif
> diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
> index a21269b..4b901d9 100644
> --- a/net/bridge/netfilter/nft_meta_bridge.c
> +++ b/net/bridge/netfilter/nft_meta_bridge.c
> @@ -84,6 +84,7 @@ static const struct nft_expr_ops nft_meta_bridge_set_ops = {
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
>  	.eval		= nft_meta_set_eval,
>  	.init		= nft_meta_set_init,
> +	.destroy	= nft_meta_set_destroy,
>  	.dump		= nft_meta_set_dump,
>  };
>  
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index 29a6ca9..dabf5ed 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -16,6 +16,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
> +#include <linux/static_key.h>
>  #include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables_core.h>
> @@ -54,6 +55,9 @@ static void __nft_trace_packet(const struct nft_pktinfo *pkt,
>  		     rulenum);
>  }
>  
> +struct static_key nft_trace_enabled __read_mostly;
> +EXPORT_SYMBOL_GPL(nft_trace_enabled);
> +
>  static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
>  				    const struct nft_chain *chain,
>  				    const struct nft_rule *rule,
> @@ -61,7 +65,9 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
>  				    u32 verdict,
>  				    enum nft_trace_types type)
>  {
> -	if (unlikely(pkt->skb->nf_trace)) {
> +	if (static_key_false(&nft_trace_enabled)) {
> +		if (!pkt->skb->nf_trace)
> +			return;
>  		nf_tables_trace_notify(pkt, chain, rule, verdict, type);
>  		__nft_trace_packet(pkt, chain, rulenum, type);
>  	}
> @@ -138,7 +144,8 @@ next_rule:
>  		if (unlikely(rule->genmask & (1 << gencursor)))
>  			continue;
>  
> -		rulenum++;
> +		if (static_key_false(&nft_trace_enabled))
> +			rulenum++;

We can probably wrap this code to annotate rule number in a function?

>  
>  		nft_rule_for_each_expr(expr, last, rule) {
>  			if (expr->ops == &nft_cmp_fast_ops)
> @@ -178,7 +185,8 @@ next_rule:
>  		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
>  		jumpstack[stackptr].chain = chain;
>  		jumpstack[stackptr].rule  = rule;
> -		jumpstack[stackptr].rulenum = rulenum;
> +		if (static_key_false(&nft_trace_enabled))
> +			jumpstack[stackptr].rulenum = rulenum;
>  		stackptr++;
>  		/* fall through */
>  	case NFT_GOTO:
> @@ -188,7 +196,8 @@ next_rule:
>  		chain = regs.verdict.chain;
>  		goto do_chain;
>  	case NFT_CONTINUE:
> -		rulenum++;
> +		if (static_key_false(&nft_trace_enabled))
> +			rulenum++;

This happens again here.

>  		/* fall through */
>  	case NFT_RETURN:
>  		if (stackptr)
> @@ -204,7 +213,8 @@ next_rule:
>  		stackptr--;
>  		chain = jumpstack[stackptr].chain;
>  		rule  = jumpstack[stackptr].rule;
> -		rulenum = jumpstack[stackptr].rulenum;
> +		if (static_key_false(&nft_trace_enabled))
> +			rulenum = jumpstack[stackptr].rulenum;

This one is very similar to the one above.

>  		goto next_rule;
>  	}
>  
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index e94526a..c2a60ac 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -18,10 +18,12 @@
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
>  #include <linux/smp.h>
> +#include <linux/static_key.h>
>  #include <net/dst.h>
>  #include <net/sock.h>
>  #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
>  #include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
>  #include <net/netfilter/nft_meta.h>
>  
>  void nft_meta_get_eval(const struct nft_expr *expr,
> @@ -300,6 +302,9 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
>  	if (err < 0)
>  		return err;
>  
> +	if (priv->key == NFT_META_NFTRACE)
> +		static_key_slow_inc(&nft_trace_enabled);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(nft_meta_set_init);
> @@ -337,6 +342,15 @@ nla_put_failure:
>  }
>  EXPORT_SYMBOL_GPL(nft_meta_set_dump);
>  
> +void nft_meta_set_destroy(const struct nft_ctx *ctx,
> +			  const struct nft_expr *expr)
> +{
> +	const struct nft_meta *priv = nft_expr_priv(expr);
> +
> +	if (priv->key == NFT_META_NFTRACE)
> +		static_key_slow_dec(&nft_trace_enabled);
> +}
> +
>  static struct nft_expr_type nft_meta_type;
>  static const struct nft_expr_ops nft_meta_get_ops = {
>  	.type		= &nft_meta_type,
> @@ -351,6 +365,7 @@ static const struct nft_expr_ops nft_meta_set_ops = {
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
>  	.eval		= nft_meta_set_eval,
>  	.init		= nft_meta_set_init,
> +	.destroy	= nft_meta_set_destroy,
>  	.dump		= nft_meta_set_dump,
>  };
>  
> -- 
> 2.4.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
