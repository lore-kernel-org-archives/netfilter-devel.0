From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nf_tables: Check for overflow of u8 fields
 from u32 netlink attributes
Date: Wed, 17 Aug 2016 17:53:59 +0200
Message-ID: <20160817155359.GA16128@salvia>
References: <20160814145933.GA22849@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48016 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbcHQQFC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 12:05:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1698DD164D
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:54:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0A34BFC61A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:54:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC59DDA800
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:54:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160814145933.GA22849@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 14, 2016 at 04:59:36PM +0200, Laura Garcia Liebana wrote:
> diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
> index e25b35d..ca247e5 100644
> --- a/net/netfilter/nft_cmp.c
> +++ b/net/netfilter/nft_cmp.c
> @@ -84,8 +84,11 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  	if (err < 0)
>  		return err;
>  
> -	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
> +	if (desc.len > U8_MAX)
> +		return -EINVAL;

I suggest we use return -ERANGE instead of -EINVAL.

>  	priv->len = desc.len;
> +	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));

Hm, I just noticed this priv->op is not validated either?

If so, we should add NFT_CMP_MAX to enum nft_cmp_ops and check if this
is:

        if (priv->op >= NFT_CMP_MAX)
                return -ERANGE;

You can send this in a follow up patch given that this doesn't match
the description, or you rework the title and description to make this
all fit in one logical change.

> diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
> index db3b746..6de590c 100644
> --- a/net/netfilter/nft_immediate.c
> +++ b/net/netfilter/nft_immediate.c
> @@ -53,6 +53,9 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
>  			    tb[NFTA_IMMEDIATE_DATA]);
>  	if (err < 0)
>  		return err;
> +
> +	if (desc.len > U8_MAX)
> +		return -EINVAL;
>  	priv->dlen = desc.len;
>  
>  	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
> diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
> index ee2d717..74f8293 100644
> --- a/net/netfilter/nft_nat.c
> +++ b/net/netfilter/nft_nat.c
> @@ -148,6 +148,8 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  	family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
>  	if (family != ctx->afi->family)
>  		return -EOPNOTSUPP;
> +	if (family > U8_MAX)
> +		return -EINVAL;

I think we don't need this, because we check later on:

        switch (family) {
        case NFPROTO_IPV4:
                ...
        case NFPROTO_IPV6:
                ...
        default:
                return -EAFNOSUPPORT;
        }

So this check is superfluous, you can remove it.
