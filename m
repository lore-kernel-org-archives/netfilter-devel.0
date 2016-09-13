From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and
 _SRGE_TO to select the queue numbers
Date: Tue, 13 Sep 2016 11:19:17 +0200
Message-ID: <20160913091917.GA4051@salvia>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
 <1473602728-33502-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756709AbcIMJT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 05:19:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAB661E0DC4
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:19:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA7EE1150D5
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:19:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F78F100A6C
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 11:19:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473602728-33502-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Liping,

A bit more comments on top of Florian's suggestion to use one single
_SREG.

On Sun, Sep 11, 2016 at 10:05:28PM +0800, Liping Zhang wrote:
> diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
> index d16d599..6557118 100644
> --- a/net/netfilter/nft_queue.c
> +++ b/net/netfilter/nft_queue.c
> @@ -22,9 +22,11 @@
>  static u32 jhash_initval __read_mostly;
>  
>  struct nft_queue {
> -	u16	queuenum;
> -	u16	queues_total;
> -	u16	flags;
> +	enum nft_registers	sreg_from:8;
> +	enum nft_registers	sreg_to:8;
> +	u16			queuenum;
> +	u16			queues_total;
> +	u16			flags;
>  };
>  
>  static void nft_queue_eval(const struct nft_expr *expr,
> @@ -32,17 +34,30 @@ static void nft_queue_eval(const struct nft_expr *expr,
>  			   const struct nft_pktinfo *pkt)
>  {
>  	struct nft_queue *priv = nft_expr_priv(expr);
> -	u32 queue = priv->queuenum;
> +	u32 queue, queues_total, queue_end;
>  	u32 ret;
>  
> -	if (priv->queues_total > 1) {
> +	if (priv->sreg_from) {
> +		queue = (u16)regs->data[priv->sreg_from];
> +		queue_end = (u16)regs->data[priv->sreg_to];
> +
> +		if (queue_end > queue)
> +			queues_total = queue_end - queue + 1;
> +		else
> +			queues_total = 1;
> +	} else {
> +		queue = priv->queuenum;
> +		queues_total = priv->queues_total;
> +	}

I suggest you use .select_ops to use a specific _eval function if
_SREG is set. This would disentangle this code a bit.

> +
> +	if (queues_total > 1) {
>  		if (priv->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
>  			int cpu = smp_processor_id();
>  
> -			queue = priv->queuenum + cpu % priv->queues_total;
> +			queue += cpu % queues_total;
>  		} else {
>  			queue = nfqueue_hash(pkt->skb, queue,
> -					     priv->queues_total, pkt->pf,
> +					     queues_total, pkt->pf,
>  					     jhash_initval);
>  		}
>  	}
> @@ -58,6 +73,8 @@ static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
>  	[NFTA_QUEUE_NUM]	= { .type = NLA_U16 },
>  	[NFTA_QUEUE_TOTAL]	= { .type = NLA_U16 },
>  	[NFTA_QUEUE_FLAGS]	= { .type = NLA_U16 },
> +	[NFTA_QUEUE_SREG_FROM]	= { .type = NLA_U32 },
> +	[NFTA_QUEUE_SREG_TO]	= { .type = NLA_U32 },
>  };
>  
>  static int nft_queue_init(const struct nft_ctx *ctx,
> @@ -66,30 +83,58 @@ static int nft_queue_init(const struct nft_ctx *ctx,
>  {
>  	struct nft_queue *priv = nft_expr_priv(expr);
>  	u32 maxid;
> +	int err;
>  
> -	if (tb[NFTA_QUEUE_NUM] == NULL)
> +	if (!tb[NFTA_QUEUE_NUM] && !tb[NFTA_QUEUE_SREG_FROM])
>  		return -EINVAL;
>  
>  	init_hashrandom(&jhash_initval);
> -	priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
>  
> -	if (tb[NFTA_QUEUE_TOTAL] != NULL)
> -		priv->queues_total = ntohs(nla_get_be16(tb[NFTA_QUEUE_TOTAL]));
> -	else
> -		priv->queues_total = 1;
> +	/* nftables has no idea whether the kernel supports _SREG_FROM or not,
> +	 * so for compatibility reason, it may specify the _SREG_FROM and
> +	 * _QUEUE_NUM attributes at the same time. We prefer to use _SREG_FROM,
> +	 * it is more flexible and has less restriction, for example, queue
> +	 * range 0-65535 is ok when use _SREG_FROM and _SREG_TO.
> +	 */

No need for this large comment, look.

>From userspace, we have to modify the nft parser to take an expression
as 'num'. Then, from the netlink_linearize path, we can check the
expression type:

* If it's a value expression, we can simply use NFTA_QUEUE_NUM.
* If it's a range expression, we have to set up NFTA_QUEUE_NUM and
  NFTA_QUEUE_TOTAL.
* If it's a mapping, then we only use _SREG.

Old kernels will bail out if the mapping is used, as this is not
supported, which is what we expect. This should be fine by now, until
I finish the patchset to provide a VM description that userspace can
use to generate bytecode depending on the features available in the
kernel.

> +	if (tb[NFTA_QUEUE_SREG_FROM]) {
> +		priv->sreg_from = nft_parse_register(tb[NFTA_QUEUE_SREG_FROM]);
> +		err = nft_validate_register_load(priv->sreg_from, sizeof(u16));
> +		if (err < 0)
> +			return err;
> +
> +		if (tb[NFTA_QUEUE_SREG_TO]) {
> +			priv->sreg_to =
> +				nft_parse_register(tb[NFTA_QUEUE_SREG_TO]);
> +			err = nft_validate_register_load(priv->sreg_to,
> +							 sizeof(u16));
> +			if (err < 0)
> +				return err;
> +		} else {
> +			priv->sreg_to = priv->sreg_from;
> +		}
> +	} else if (tb[NFTA_QUEUE_NUM]) {
> +		priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
>  
> -	if (priv->queues_total == 0)
> -		return -EINVAL;
> +		if (tb[NFTA_QUEUE_TOTAL])
> +			priv->queues_total =
> +				ntohs(nla_get_be16(tb[NFTA_QUEUE_TOTAL]));
> +		else
> +			priv->queues_total = 1;
>  
> -	maxid = priv->queues_total - 1 + priv->queuenum;
> -	if (maxid > U16_MAX)
> -		return -ERANGE;
> +		if (priv->queues_total == 0)
> +			return -EINVAL;
> +
> +		maxid = priv->queues_total - 1 + priv->queuenum;
> +		if (maxid > U16_MAX)
> +			return -ERANGE;
> +	}
>  
>  	if (tb[NFTA_QUEUE_FLAGS] != NULL) {
>  		priv->flags = ntohs(nla_get_be16(tb[NFTA_QUEUE_FLAGS]));
>  		if (priv->flags & ~NFT_QUEUE_FLAG_MASK)
>  			return -EINVAL;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -97,9 +142,21 @@ static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  {
>  	const struct nft_queue *priv = nft_expr_priv(expr);
>  
> -	if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)) ||
> -	    nla_put_be16(skb, NFTA_QUEUE_TOTAL, htons(priv->queues_total)) ||
> -	    nla_put_be16(skb, NFTA_QUEUE_FLAGS, htons(priv->flags)))
> +	if (priv->sreg_from) {
> +		if (nft_dump_register(skb, NFTA_QUEUE_SREG_FROM,
> +				      priv->sreg_from))
> +			goto nla_put_failure;
> +		if (nft_dump_register(skb, NFTA_QUEUE_SREG_TO,
> +				      priv->sreg_to))
> +			goto nla_put_failure;
> +	} else {
> +		if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)) ||
> +		    nla_put_be16(skb, NFTA_QUEUE_TOTAL,
> +				 htons(priv->queues_total)))
> +			goto nla_put_failure;
> +	}

Looking at this, the code will look better if we should use
.select_ops indeed.

Thanks for resolving existing nft_queue limitations!
