From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCHv2] netfilter: nft: add queue module
Date: Wed, 04 Dec 2013 13:47:43 +0100
Message-ID: <1386161263.9597.23.camel@ice-age2.regit.org>
References: <20131130122657.GG2067@breakpoint.cc>
	 <1385824444-4506-1-git-send-email-eric@regit.org>
	 <20131204110021.GA11380@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:46403 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab3LDMrr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:47:47 -0500
In-Reply-To: <20131204110021.GA11380@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, 2013-12-04 at 12:00 +0100, Pablo Neira Ayuso wrote:
> Hi Eric,
> 
> First off, thanks for this patch. Some comments below.
> 
> On Sat, Nov 30, 2013 at 04:14:04PM +0100, Eric Leblond wrote:
> > This patch adds a new nft module named "nft_queue" which is a
> > nftables target sending packet to nfnetlink_queue subsystem. It has
> > the same level of functionnality as is iptables ancestor and share
> > some code with it.
> > 
> > Signed-off-by: Eric Leblond <eric@regit.org>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h |  20 ++++
...
> > +#include <linux/jhash.h>
> > +#include <linux/netfilter.h>
> > +#include <linux/netfilter/nf_tables.h>
> > +#include <net/netfilter/nf_tables.h>
> > +
> > +struct nft_queue {
> > +	u16			queuenum;
> > +	u16			queues_total;
> > +	u16			flags;
> > +	int			family;
>                                 ^
> This structure is very important that it doesn't have any hole (at its
> best) to reduce the size of the expression area in the rule. My
> proposal:

OK, fixing this.

> ...
> {
> 	u16			queue_num;
> 	u16			queue_total;
> 	u16			flags;
> 	u8			family;
> }
> 
> > +};
> > +
> > +static u32 jhash_initval __read_mostly;
> 
> From here:
> 
> > +static u32 hash_v4(const struct sk_buff *skb)
> > +{
> > +	const struct iphdr *iph = ip_hdr(skb);
> > +
> > +	/* packets in either direction go into same queue */
> > +	if ((__force u32)iph->saddr < (__force u32)iph->daddr)
> > +		return jhash_3words((__force u32)iph->saddr,
> > +			(__force u32)iph->daddr, iph->protocol, jhash_initval);
> > +
> > +	return jhash_3words((__force u32)iph->daddr,
> > +			(__force u32)iph->saddr, iph->protocol, jhash_initval);
> > +}
> > +
> > +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> > +static u32 hash_v6(const struct sk_buff *skb)
> > +{
> > +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> > +	u32 a, b, c;
> > +
> > +	if ((__force u32)ip6h->saddr.s6_addr32[3] <
> > +	    (__force u32)ip6h->daddr.s6_addr32[3]) {
> > +		a = (__force u32) ip6h->saddr.s6_addr32[3];
> > +		b = (__force u32) ip6h->daddr.s6_addr32[3];
> > +	} else {
> > +		b = (__force u32) ip6h->saddr.s6_addr32[3];
> > +		a = (__force u32) ip6h->daddr.s6_addr32[3];
> > +	}
> > +
> > +	if ((__force u32)ip6h->saddr.s6_addr32[1] <
> > +	    (__force u32)ip6h->daddr.s6_addr32[1])
> > +		c = (__force u32) ip6h->saddr.s6_addr32[1];
> > +	else
> > +		c = (__force u32) ip6h->daddr.s6_addr32[1];
> > +
> > +	return jhash_3words(a, b, c, jhash_initval);
> > +}
> > +#endif
> > +
> > +static u32
> > +nfqueue_hash(const struct nft_pktinfo *pkt, const struct nft_queue *priv)
> > +{
> > +	u32 queue = priv->queuenum;
> > +
> > +	if (priv->family == AF_INET)
> > +		queue += ((u64) hash_v4(pkt->skb) * priv->queues_total) >> 32;
> > +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
> > +	else if (priv->family == AF_INET6)
> > +		queue += ((u64) hash_v6(pkt->skb) * priv->queues_total) >> 32;
> > +#endif
> > +
> > +	return queue;
> > +}
> 
> to there, it looks very similar to NFQUEUE. You can move these
> functions to net/netfilter/nf_queue.h. You'll have to inline them and
> add the jhash_initval parameter. You'll need an initial patch to
> prepare this change and adapt xt_NFQUEUE.c

I'm ok with the two hash functions but the nfqueue_hash the second
argument is different. Do you want me to introduce a new common
structure for xt_NFQUEUE and nft_queue ?

> > +
> > +static void nft_queue_eval(const struct nft_expr *expr,
> > +			      struct nft_data data[NFT_REG_MAX + 1],
> > +			      const struct nft_pktinfo *pkt)
> > +{
> > +	struct nft_queue *priv = nft_expr_priv(expr);
...
> ret = NF_QUEUE_NR(queue);
> > +	if (priv->flags & NFT_QUEUE_FLAG_BYPASS)
> > +		ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
> > +
> > +	data[NFT_REG_VERDICT].verdict = ret;
> > +}
> > +
> > +static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
> > +	[NFTA_QUEUE_NUM]		= { .type = NLA_U16 },
> > +	[NFTA_QUEUE_TOTAL]		= { .type = NLA_U16 },
> > +	[NFTA_QUEUE_FLAGS]		= { .type = NLA_U16 },
>                           ^------------^
> Comestic: I think one tab should be fine.

OK.

> > +};
> > +
> > +static int nft_queue_init(const struct nft_ctx *ctx,
> > +			   const struct nft_expr *expr,
..
> > +}
> > +
> > +static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
> > +{
> > +	const struct nft_queue *priv = nft_expr_priv(expr);
> > +
> > +	if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)))
> > +		goto nla_put_failure;
> > +
> > +	if (nla_put_be16(skb, NFTA_QUEUE_TOTAL, htons(priv->queues_total)))
> > +		goto nla_put_failure;
> > +
> > +	if (nla_put_be16(skb, NFTA_QUEUE_FLAGS, htons(priv->flags)))
> > +		goto nla_put_failure;
> 
> Comestic: Perhaps you can squash these three put lines in one single
> if to save a couple of lines, the code will be still quite readable.

Done.

BR
-- 
Eric Leblond <eric@regit.org>

