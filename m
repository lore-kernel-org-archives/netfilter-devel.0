Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DCCC6FA82
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Sep 2022 14:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIWOHF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Sep 2022 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIWOHE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2022 10:07:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D485013D1E7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2022 07:07:02 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1objKW-0002Ws-Hj; Fri, 23 Sep 2022 16:07:00 +0200
Date:   Fri, 23 Sep 2022 16:07:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] nft: track each register individually
Message-ID: <Yy29hCuiKtr9Rnap@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220923121708.839-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923121708.839-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 23, 2022 at 02:17:08PM +0200, Florian Westphal wrote:
> Instead of assuming only one register is used, track all 16 regs
> individually.
> 
> This avoids need for the 'PREV_PAYLOAD' hack and also avoids the need to
> clear out old flags:
> 
> When we see that register 'x' will be written to, that register state is
> reset automatically.
> 
> Existing dissector decodes
> ip saddr 1.2.3.4 meta l4proto tcp
> ... as
> -s 6.0.0.0 -p tcp
> 
> iptables-nft -s 1.2.3.4 -p tcp is decoded correctly because the expressions
> are ordered like:
> 
> meta l4proto tcp ip saddr 1.2.3.4
>                                                                                                                                                                                                                    |
> ... and 'meta l4proto' did clear the PAYLOAD flag.
> 
> The simpler fix is:
> 		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
> 
> in nft_parse_cmp(), but that breaks dissection of '1-42', because
> the second compare ('cmp lte 42') will not find the
> payload expression anymore.
> 
> Link: https://lore.kernel.org/netfilter-devel/20220922143544.GA22541@breakpoint.cc/T/#t
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Phil Sutter <phil@nwl.cc>

Just a typo spotted:

[...]
> @@ -883,7 +933,17 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
>  	nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len);
>  	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
>  
> -	switch(ctx->payload.offset) {
> +	reg = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_SREG);
> +	sreg = nft_xt_ctx_get_sreg(ctx, reg);
> +	if (!sreg)
> +		return;
> +
> +	if (sreg->type != NFT_XT_REG_PAYLOAD) {
> +		ctx->errmsg = "sgreg not payload";
                               ^^^^^
> +		return;
> +	}
> +
> +	switch(sreg->payload.offset) {
>  	case 0: /* th->sport */
>  		switch (len) {
>  		case 2: /* load sport only */
