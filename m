From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables kernel PATCH v3] netfilter: nf_tables: nft_meta module
 get/set ops
Date: Thu, 26 Dec 2013 10:51:54 +0100
Message-ID: <20131226095154.GA10079@localhost>
References: <20131216151120.9694.2743.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58886 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab3LZJwB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Dec 2013 04:52:01 -0500
Content-Disposition: inline
In-Reply-To: <20131216151120.9694.2743.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Mon, Dec 16, 2013 at 04:14:08PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds kernel support for the meta expression in get/set flavour.
> The set operation indicates that a given packet has to be set with a property,
> currently one of mark, priority, nftrace or secmark.
> The get op is what was currently working: evaluate the given packet property.
> 
> In case of nftrace, the value is always 1. Such behaviour is copied
> from net/netfilter/xt_TRACE.c
> 
> In case of secmark, the intention is to make the translation between the
> security_ctx and security_id in userspace.
> Otherwise, a string is needed to be passed from the userpsace to kernel as
> part of the attribute set, breaking the KEY,VALUE pair approach.
> This is different from net/netfilter/xt_SECMARK.c. There, the context
> is translated in kernel side.
> 
> NFTA_META_DREG and NFTA_META_VALUE attributes are mutually exclusives.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> v1: initial release of the patch.
> v2: address comments by Tomasz and Pablo; meta in nft_meta.c with select_ops
> v3: address comments by Tomasz: replace match/target keywords with set/get.
>     Also, respect previous enum values.
> 
>  include/uapi/linux/netfilter/nf_tables.h |    2 
>  net/netfilter/nft_meta.c                 |  156 +++++++++++++++++++++++++-----
>  2 files changed, 132 insertions(+), 26 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 256d36b..29c26e2 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -553,11 +553,13 @@ enum nft_meta_keys {
>   *
>   * @NFTA_META_DREG: destination register (NLA_U32)
>   * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
> + * @NFTA_META_VALUE: data to be set (NLA_U32)

I know we already discussed to use this inlined value, but I noticed
that we need to replace this to NFTA_META_SREG here, so we can combine
it with the immediate expression and obtain things like:

add rule ip filter OUTPUT meta mark set tcp dport map { \
        22 => 1, \
        23 => 2, \
}

This basically allows conditional mark setting based in any selector.

> index 8c28220..541e0cc 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -21,12 +21,15 @@
>  
>  struct nft_meta {
>  	enum nft_meta_keys	key:8;
> -	enum nft_registers	dreg:8;
> +	union {
> +		enum nft_registers	dreg:8;
> +		u32			value;
> +	};
>  };
>  
> -static void nft_meta_eval(const struct nft_expr *expr,
> -			  struct nft_data data[NFT_REG_MAX + 1],
> -			  const struct nft_pktinfo *pkt)
> +static void nft_meta_get_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
>  {
>  	const struct nft_meta *priv = nft_expr_priv(expr);
>  	const struct sk_buff *skb = pkt->skb;
> @@ -132,23 +135,57 @@ err:
>  	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
>  }
>  
> +static void nft_meta_set_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_meta *meta = nft_expr_priv(expr);
> +	struct sk_buff *skb = pkt->skb;
> +
> +	switch (meta->key) {
> +	case NFT_META_MARK:
> +		skb->mark = meta->value;
> +		break;
> +	case NFT_META_PRIORITY:
> +		skb->priority = meta->value;
> +		break;
> +	case NFT_META_NFTRACE:
> +		skb->nf_trace = 1;
> +		break;
> +#ifdef CONFIG_NETWORK_SECMARK
> +	case NFT_META_SECMARK:
> +		skb->secmark = meta->value;

Please, remove secmark. AFAIK, the secmark is an internal
value, we have to use the secctx name, similarly to xt_SECMARK.c.
