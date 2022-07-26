Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E788BC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 13:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiGZN3o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 09:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbiGZN3n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 09:29:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B8925C78
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2022 06:29:42 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:29:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: add rescheduling points during
 loop detection walks
Message-ID: <Yt/sQtZHB9Fs3uB7@salvia>
References: <20220726104435.2209-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220726104435.2209-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 26, 2022 at 12:44:35PM +0200, Florian Westphal wrote:
> Add explicit rescheduling points during ruleset walk.
> 
> Switching to a faster algorithm is possible but this is a much
> smaller change, suitable for nf tree.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1460

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_api.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 646d5fd53604..9f976b11d896 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3340,6 +3340,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
>  			if (err < 0)
>  				return err;
>  		}
> +
> +		cond_resched();
>  	}
>  
>  	return 0;
> @@ -9367,9 +9369,13 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
>  				break;
>  			}
>  		}
> +
> +		cond_resched();
>  	}
>  
>  	list_for_each_entry(set, &ctx->table->sets, list) {
> +		cond_resched();
> +
>  		if (!nft_is_active_next(ctx->net, set))
>  			continue;
>  		if (!(set->flags & NFT_SET_MAP) ||
> -- 
> 2.35.1
> 
