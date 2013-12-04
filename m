From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] netfilter: nft: add queue module
Date: Wed, 4 Dec 2013 12:00:21 +0100
Message-ID: <20131204110021.GA11380@localhost>
References: <20131130122657.GG2067@breakpoint.cc>
 <1385824444-4506-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34062 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3LDLAc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:00:32 -0500
Content-Disposition: inline
In-Reply-To: <1385824444-4506-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

First off, thanks for this patch. Some comments below.

On Sat, Nov 30, 2013 at 04:14:04PM +0100, Eric Leblond wrote:
> This patch adds a new nft module named "nft_queue" which is a
> nftables target sending packet to nfnetlink_queue subsystem. It has
> the same level of functionnality as is iptables ancestor and share
> some code with it.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  20 ++++
>  net/netfilter/Kconfig                    |   9 ++
>  net/netfilter/Makefile                   |   1 +
>  net/netfilter/nft_queue.c                | 192 +++++++++++++++++++++++++++++++
>  4 files changed, 222 insertions(+)
>  create mode 100644 net/netfilter/nft_queue.c
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index fbfd229..256d36b 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -658,6 +658,26 @@ enum nft_log_attributes {
>  #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
>  
>  /**
> + * enum nft_queue_attributes - nf_tables queue expression netlink attributes
> + *
> + * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
> + * @NFTA_QUEUE_TOTAL: number of queues to load balance packets on (NLA_U16)
> + * @NFTA_QUEUE_FLAGS: various flags (NLA_U16)
> + */
> +enum nft_queue_attributes {
> +	NFTA_QUEUE_UNSPEC,
> +	NFTA_QUEUE_NUM,
> +	NFTA_QUEUE_TOTAL,
> +	NFTA_QUEUE_FLAGS,
> +	__NFTA_QUEUE_MAX
> +};
> +#define NFTA_QUEUE_MAX		(__NFTA_QUEUE_MAX - 1)
> +
> +#define NFT_QUEUE_FLAG_BYPASS		0x01 /* for compatibility with v2 */
> +#define NFT_QUEUE_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
> +#define NFT_QUEUE_FLAG_MASK		0x03
> +
> +/**
>   * enum nft_reject_types - nf_tables reject expression reject types
>   *
>   * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index c3398cd..cf0872d 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -456,6 +456,15 @@ config NFT_NAT
>  	depends on NF_NAT
>  	tristate "Netfilter nf_tables nat module"
>  
> +config NFT_QUEUE
> +	depends on NF_TABLES
> +	depends on NETFILTER_XTABLES
> +	depends on NETFILTER_NETLINK_QUEUE
> +	tristate "Netfilter nf_tables queue module"
> +	help
> +	  This is required if you intend to use nfnetlink queue
> +	  on more than the default queue 0 or with the other features
> +
>  config NFT_COMPAT
>  	depends on NF_TABLES
>  	depends on NETFILTER_XTABLES
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 394483b..e763746 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -76,6 +76,7 @@ obj-$(CONFIG_NFT_META)		+= nft_meta.o
>  obj-$(CONFIG_NFT_CT)		+= nft_ct.o
>  obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
>  obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
> +obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
>  #nf_tables-objs			+= nft_meta_target.o
>  obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
>  obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
> diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
> new file mode 100644
> index 0000000..88cdf16
> --- /dev/null
> +++ b/net/netfilter/nft_queue.c
> @@ -0,0 +1,192 @@
> +/*
> + * Copyright (c) 2013 Eric Leblond <eric@regit.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/jhash.h>
> +
> +#include <linux/jhash.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables.h>
> +
> +struct nft_queue {
> +	u16			queuenum;
> +	u16			queues_total;
> +	u16			flags;
> +	int			family;
                                ^
This structure is very important that it doesn't have any hole (at its
best) to reduce the size of the expression area in the rule. My
proposal:

...
{
	u16			queue_num;
	u16			queue_total;
	u16			flags;
	u8			family;
}

> +};
> +
> +static u32 jhash_initval __read_mostly;

>From here:

> +static u32 hash_v4(const struct sk_buff *skb)
> +{
> +	const struct iphdr *iph = ip_hdr(skb);
> +
> +	/* packets in either direction go into same queue */
> +	if ((__force u32)iph->saddr < (__force u32)iph->daddr)
> +		return jhash_3words((__force u32)iph->saddr,
> +			(__force u32)iph->daddr, iph->protocol, jhash_initval);
> +
> +	return jhash_3words((__force u32)iph->daddr,
> +			(__force u32)iph->saddr, iph->protocol, jhash_initval);
> +}
> +
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +static u32 hash_v6(const struct sk_buff *skb)
> +{
> +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> +	u32 a, b, c;
> +
> +	if ((__force u32)ip6h->saddr.s6_addr32[3] <
> +	    (__force u32)ip6h->daddr.s6_addr32[3]) {
> +		a = (__force u32) ip6h->saddr.s6_addr32[3];
> +		b = (__force u32) ip6h->daddr.s6_addr32[3];
> +	} else {
> +		b = (__force u32) ip6h->saddr.s6_addr32[3];
> +		a = (__force u32) ip6h->daddr.s6_addr32[3];
> +	}
> +
> +	if ((__force u32)ip6h->saddr.s6_addr32[1] <
> +	    (__force u32)ip6h->daddr.s6_addr32[1])
> +		c = (__force u32) ip6h->saddr.s6_addr32[1];
> +	else
> +		c = (__force u32) ip6h->daddr.s6_addr32[1];
> +
> +	return jhash_3words(a, b, c, jhash_initval);
> +}
> +#endif
> +
> +static u32
> +nfqueue_hash(const struct nft_pktinfo *pkt, const struct nft_queue *priv)
> +{
> +	u32 queue = priv->queuenum;
> +
> +	if (priv->family == AF_INET)
> +		queue += ((u64) hash_v4(pkt->skb) * priv->queues_total) >> 32;
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> +	else if (priv->family == AF_INET6)
> +		queue += ((u64) hash_v6(pkt->skb) * priv->queues_total) >> 32;
> +#endif
> +
> +	return queue;
> +}

to there, it looks very similar to NFQUEUE. You can move these
functions to net/netfilter/nf_queue.h. You'll have to inline them and
add the jhash_initval parameter. You'll need an initial patch to
prepare this change and adapt xt_NFQUEUE.c

> +
> +static void nft_queue_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
> +{
> +	struct nft_queue *priv = nft_expr_priv(expr);
> +	u32 queue = priv->queuenum;
> +	u32 ret;
> +
> +	if (priv->queues_total > 1) {
> +		if (priv->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
> +			int cpu = smp_processor_id();
> +
> +			queue = priv->queuenum + cpu % priv->queues_total;
> +		} else
> +			queue = nfqueue_hash(pkt, priv);
> +	}
> +
> +	ret = NF_QUEUE_NR(queue);
> +	if (priv->flags & NFT_QUEUE_FLAG_BYPASS)
> +		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
> +
> +	data[NFT_REG_VERDICT].verdict = ret;
> +}
> +
> +static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
> +	[NFTA_QUEUE_NUM]		= { .type = NLA_U16 },
> +	[NFTA_QUEUE_TOTAL]		= { .type = NLA_U16 },
> +	[NFTA_QUEUE_FLAGS]		= { .type = NLA_U16 },
                          ^------------^
Comestic: I think one tab should be fine.

> +};
> +
> +static int nft_queue_init(const struct nft_ctx *ctx,
> +			   const struct nft_expr *expr,
> +			   const struct nlattr * const tb[])
> +{
> +	struct nft_queue *priv = nft_expr_priv(expr);
> +
> +	while (jhash_initval == 0)
> +		jhash_initval = prandom_u32();

Different initialization approach with regards to xt_NFQUEUE, any
reason for that change?

> +
> +	priv->family = ctx->afi->family;
> +
> +	if (tb[NFTA_QUEUE_NUM] == NULL)
> +		return -EINVAL;
> +	priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
> +
> +	if (tb[NFTA_QUEUE_TOTAL] != NULL)
> +		priv->queues_total = ntohs(nla_get_be16(tb[NFTA_QUEUE_TOTAL]));
> +	if (tb[NFTA_QUEUE_FLAGS] != NULL) {
> +		priv->flags = ntohs(nla_get_be16(tb[NFTA_QUEUE_FLAGS]));
> +		if (priv->flags & ~NFT_QUEUE_FLAG_MASK)
> +			return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_queue *priv = nft_expr_priv(expr);
> +
> +	if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)))
> +		goto nla_put_failure;
> +
> +	if (nla_put_be16(skb, NFTA_QUEUE_TOTAL, htons(priv->queues_total)))
> +		goto nla_put_failure;
> +
> +	if (nla_put_be16(skb, NFTA_QUEUE_FLAGS, htons(priv->flags)))
> +		goto nla_put_failure;

Comestic: Perhaps you can squash these three put lines in one single
if to save a couple of lines, the code will be still quite readable.

> +
> +	return 0;
> +
> +nla_put_failure:
> +	return -1;
> +}
> +
> +static struct nft_expr_type nft_queue_type;
> +static const struct nft_expr_ops nft_queue_ops = {
> +	.type		= &nft_queue_type,
> +	.size		= NFT_EXPR_SIZE(sizeof(struct nft_queue)),
> +	.eval		= nft_queue_eval,
> +	.init		= nft_queue_init,
> +	.dump		= nft_queue_dump,
> +};
> +
> +static struct nft_expr_type nft_queue_type __read_mostly = {
> +	.name		= "queue",
> +	.ops		= &nft_queue_ops,
> +	.policy		= nft_queue_policy,
> +	.maxattr	= NFTA_QUEUE_MAX,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int __init nft_queue_module_init(void)
> +{
> +	return nft_register_expr(&nft_queue_type);
> +}
> +
> +static void __exit nft_queue_module_exit(void)
> +{
> +	nft_unregister_expr(&nft_queue_type);
> +}
> +
> +module_init(nft_queue_module_init);
> +module_exit(nft_queue_module_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
> +MODULE_ALIAS_NFT_EXPR("queue");
> -- 
> 1.8.4.4
> 
