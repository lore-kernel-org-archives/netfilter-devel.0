Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24F7C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 09:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCJJRD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 04:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCJJQo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 04:16:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BB7D10975E
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 01:12:41 -0800 (PST)
Date:   Fri, 10 Mar 2023 10:12:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Reject invalid chain priority values in user space
Message-ID: <ZAr0hLGgIpc1Cg9o@salvia>
References: <20230310001314.16957-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230310001314.16957-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 10, 2023 at 01:13:14AM +0100, Phil Sutter wrote:
> The kernel doesn't accept nat type chains with a priority of -200 or
> below. Catch this and provide a better error message than the kernel's
> EOPNOTSUPP.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/evaluate.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index d24f8b66b0de8..af4844c1ef6cc 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -4842,6 +4842,8 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
>  	}
>  
>  	if (chain->flags & CHAIN_F_BASECHAIN) {
> +		int priority;
> +
>  		chain->hook.num = str2hooknum(chain->handle.family,
>  					      chain->hook.name);
>  		if (chain->hook.num == NF_INET_NUMHOOKS)
> @@ -4854,6 +4856,14 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
>  			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
>  						   "invalid priority expression %s in this context.",
>  						   expr_name(chain->priority.expr));
> +

maybe get this here to declutter the branch?

                mpz_export_data(&priority, chain->priority.expr->value,
                                BYTEORDER_HOST_ENDIAN, sizeof(int)));

this is in basechain context, so it should be fine.

> +		if (!strcmp(chain->type.str, "nat") &&
> +		    (mpz_export_data(&priority, chain->priority.expr->value,
> +				    BYTEORDER_HOST_ENDIAN, sizeof(int))) &&
> +		    priority <= -200)
> +			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
> +						   "Nat type chains must have a priority value above -200.");
                                                    ^^^

I'd suggest lower case 'nat' which is what the user specifies in the
chain declaration.

Thanks for addressing my feedback.

> +
>  		if (chain->policy) {
>  			expr_set_context(&ctx->ectx, &policy_type,
>  					 NFT_NAME_MAXLEN * BITS_PER_BYTE);
> -- 
> 2.38.0
> 
