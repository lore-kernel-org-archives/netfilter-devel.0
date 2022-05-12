Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAB2C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 12:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353845AbiELMeY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 08:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353848AbiELMeU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 08:34:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C5B1663CA
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 05:34:14 -0700 (PDT)
Date:   Thu, 12 May 2022 14:34:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2 1/2] netfilter: nf_tables: Introduce
 expression flags
Message-ID: <Ynz+wzEIfokNqi0B@salvia>
References: <20220512123003.29903-1-phil@nwl.cc>
 <20220512123003.29903-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512123003.29903-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 12, 2022 at 02:30:02PM +0200, Phil Sutter wrote:
> Allow dumping some info bits about expressions to user space.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/net/netfilter/nf_tables.h        | 1 +
>  include/uapi/linux/netfilter/nf_tables.h | 1 +
>  net/netfilter/nf_tables_api.c            | 4 ++++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 20af9d3557b9d..78db54737de00 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -346,6 +346,7 @@ struct nft_set_estimate {
>   */
>  struct nft_expr {
>  	const struct nft_expr_ops	*ops;
> +	u32				flags;

Could you add a new structure? Add struct nft_expr_dp and use it from
nft_rule_dp, so it is only the control plan representation that stores
this flag.

It will be a bit more work, but I think it is worth to keep the size
of the datapath representation as small as possible.

>  	unsigned char			data[]
>  		__attribute__((aligned(__alignof__(u64))));
>  };
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 466fd3f4447c2..36bf019322a44 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -518,6 +518,7 @@ enum nft_expr_attributes {
>  	NFTA_EXPR_UNSPEC,
>  	NFTA_EXPR_NAME,
>  	NFTA_EXPR_DATA,
> +	NFTA_EXPR_FLAGS,
>  	__NFTA_EXPR_MAX
>  };
>  #define NFTA_EXPR_MAX		(__NFTA_EXPR_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f3ad02a399f8a..fddc557983119 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2731,6 +2731,7 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
>  static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
>  	[NFTA_EXPR_NAME]	= { .type = NLA_STRING,
>  				    .len = NFT_MODULE_AUTOLOAD_LIMIT },
> +	[NFTA_EXPR_FLAGS]	= { .type = NLA_U32 },
>  	[NFTA_EXPR_DATA]	= { .type = NLA_NESTED },
>  };
>  
> @@ -2740,6 +2741,9 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
>  	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(skb, NFTA_EXPR_FLAGS, expr->flags))
> +		goto nla_put_failure;
> +
>  	if (expr->ops->dump) {
>  		struct nlattr *data = nla_nest_start_noflag(skb,
>  							    NFTA_EXPR_DATA);
> -- 
> 2.34.1
> 
