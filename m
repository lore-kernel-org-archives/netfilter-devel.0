Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE181EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 08:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjFSIxb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjFSIxU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 04:53:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 166A919B2
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 01:52:13 -0700 (PDT)
Date:   Mon, 19 Jun 2023 10:52:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] cache: include set elements in "nft set list"
Message-ID: <ZJAXOt+gyRssyayb@calendula>
References: <20230618163951.408565-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230618163951.408565-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 18, 2023 at 06:39:45PM +0200, Florian Westphal wrote:
> Make "nft list sets" include set elements in listing by default.
> In nftables 1.0.0, "nft list sets" did not include the set elements,
> but with "--json" they were included.
> 
> 1.0.1 and newer never include them.
> This causes a problem for people updating from 1.0.0 and relying
> on the presence of the set elements.
> 
> Change nftables to always include the set elements.
> The "--terse" option is honored to get the "no elements" behaviour.

LGTM.

> Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")
> Link: https://marc.info/?l=netfilter&m=168704941828372&w=2
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/cache.c | 2 ++
>  src/rule.c  | 3 +--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/src/cache.c b/src/cache.c
> index 95adee7f8ac1..becfa57fc335 100644
> --- a/src/cache.c
> +++ b/src/cache.c
> @@ -235,6 +235,8 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
>  	case CMD_OBJ_SETS:
>  	case CMD_OBJ_MAPS:
>  		flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
> +		if (!nft_output_terse(&nft->output))
> +			flags |= NFT_CACHE_SETELEM;
>  		break;
>  	case CMD_OBJ_FLOWTABLE:
>  		if (filter &&
> diff --git a/src/rule.c b/src/rule.c
> index 633a5a12486d..305322ea7cc3 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1601,8 +1601,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
>  			if (cmd->obj == CMD_OBJ_MAPS &&
>  			    !map_is_literal(set->flags))
>  				continue;
> -			set_print_declaration(set, &opts, &ctx->nft->output);
> -			nft_print(&ctx->nft->output, "%s}%s", opts.tab, opts.nl);
> +			set_print(set, &ctx->nft->output);
>  		}
>  
>  		nft_print(&ctx->nft->output, "}\n");
> -- 
> 2.41.0
> 
