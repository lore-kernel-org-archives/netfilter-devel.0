Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DF7EB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 14:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjGEObR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjGEObQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 10:31:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF9212A;
        Wed,  5 Jul 2023 07:31:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qH3X9-0006o0-Jk; Wed, 05 Jul 2023 16:31:07 +0200
Date:   Wed, 5 Jul 2023 16:31:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.10 02/10] netfilter: nf_tables: add
 rescheduling points during loop detection walks
Message-ID: <20230705143107.GE3751@breakpoint.cc>
References: <20230705142213.53418-1-pablo@netfilter.org>
 <20230705142213.53418-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705142213.53418-3-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> [ 81ea010667417ef3f218dfd99b69769fe66c2b67 ]
> 
> Add explicit rescheduling points during ruleset walk.
> 
> Switching to a faster algorithm is possible but this is a much
> smaller change, suitable for nf tree.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1460
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index e3865f29ae83..3c9292d3f826 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3164,6 +3164,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
>  			if (err < 0)
>  				return err;
>  		}
> +
> +		cond_resched();
>  	}
>  
>  	return 0;
> @@ -8506,9 +8508,13 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
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

Nack, this is wrong.  Either drop this patch or also pick up
2024439bd5ceb145eeeb428b2a59e9b905153ac3
("netfilter: nf_tables: fix scheduling-while-atomic splat")
I suspect it will cherry-pick without problems.
