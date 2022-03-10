Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25F7C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 22:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbiCJWnU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiCJWnT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 17:43:19 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C4AC182BF0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 14:42:18 -0800 (PST)
Received: from netfilter.org (unknown [46.222.150.172])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6890760022;
        Thu, 10 Mar 2022 23:40:15 +0100 (CET)
Date:   Thu, 10 Mar 2022 23:42:12 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nf_tables: cancel register tracking if
 .reduce is not defined
Message-ID: <Yip+xOb4KfpbvfTq@salvia>
References: <20220310223737.5261-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220310223737.5261-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 10, 2022 at 11:37:37PM +0100, Pablo Neira Ayuso wrote:
> Cancel all register tracking if the the reduce function is not defined.
> Add missing reduce function to cmp since this is a read-only operation.
> 
> This unbreaks selftests/netfilter/nft_nat_zones.sh.
> 
> Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Actually intended to nf-next.

>  net/netfilter/nf_tables_api.c | 2 ++
>  net/netfilter/nft_cmp.c       | 8 ++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c86748b3873b..861a3a36024a 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8311,6 +8311,8 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
>  			    expr->ops->reduce(&track, expr)) {
>  				expr = track.cur;
>  				continue;
> +			} else if (expr->ops->reduce == NULL) {
> +				memset(track.regs, 0, sizeof(track.regs));
>  			}
>  
>  			if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
> diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
> index 47b6d05f1ae6..23bef7df48f1 100644
> --- a/net/netfilter/nft_cmp.c
> +++ b/net/netfilter/nft_cmp.c
> @@ -187,12 +187,19 @@ static int nft_cmp_offload(struct nft_offload_ctx *ctx,
>  	return __nft_cmp_offload(ctx, flow, priv);
>  }
>  
> +static bool nft_cmp_reduce(struct nft_regs_track *track,
> +			   const struct nft_expr *expr)
> +{
> +	return false;
> +}
> +
>  static const struct nft_expr_ops nft_cmp_ops = {
>  	.type		= &nft_cmp_type,
>  	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_expr)),
>  	.eval		= nft_cmp_eval,
>  	.init		= nft_cmp_init,
>  	.dump		= nft_cmp_dump,
> +	.reduce		= nft_cmp_reduce,
>  	.offload	= nft_cmp_offload,
>  };
>  
> @@ -269,6 +276,7 @@ const struct nft_expr_ops nft_cmp_fast_ops = {
>  	.eval		= NULL,	/* inlined */
>  	.init		= nft_cmp_fast_init,
>  	.dump		= nft_cmp_fast_dump,
> +	.reduce		= nft_cmp_reduce,
>  	.offload	= nft_cmp_fast_offload,
>  };
>  
> -- 
> 2.30.2
> 
