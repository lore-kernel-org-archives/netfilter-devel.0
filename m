Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D29ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Sep 2022 21:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiISVbN convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Sep 2022 17:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiISVbM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Sep 2022 17:31:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C372C127
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Sep 2022 14:31:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oaOM9-0002X7-Li; Mon, 19 Sep 2022 23:31:09 +0200
Date:   Mon, 19 Sep 2022 23:31:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] iptables-nft: must withdraw PAYLOAD flag
 after parsing
Message-ID: <20220919213109.GD3498@breakpoint.cc>
References: <20220919201254.32253-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220919201254.32253-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> else, next payload is stacked via 'CTX_PREV_PAYLOAD'.
> 
> Example breakage:
> 
> ip saddr 1.2.3.4 meta l4proto tcp
> ... is dumped as
> -s 6.0.0.0 -p tcp
> 
> iptables-nft -s 1.2.3.4 -p tcp is dumped correctly, because
> the expressions are ordered like:
> meta l4proto tcp ip saddr 1.2.3.4
> 
> ... and 'meta l4proto' will clear the PAYLOAD flag.
> 
> Fixes: 250dce876d92 ("nft-shared: support native tcp port delinearize")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  iptables/nft-shared.c                         |  2 ++
>  .../ipt-restore/0018-multi-payload_0          | 27 +++++++++++++++++++
>  2 files changed, 29 insertions(+)
>  create mode 100755 iptables/tests/shell/testcases/ipt-restore/0018-multi-payload_0
> 
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 71e2f18dab92..66e09e8fd533 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -986,6 +986,8 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>  			nft_parse_transport(ctx, e, ctx->cs);
>  			break;
>  		}
> +
> +		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
>  	}

This isn't ideal either since this breaks dissection of '1-42' ranges
that use two compare operands, i.e.:

cmp reg1 gte 1
cmp reg1 lte 42

...as first cmp 'hides' reg1 again.

I'd propose to rework this context stuff:
no more payload/meta/whatever flags, instead 'mirror' the raw data
registers.

Other ideas/suggestions?
