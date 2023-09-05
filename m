Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679F9CA0FFE
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 19:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbjIETAE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 15:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241696AbjIES7s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 14:59:48 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDF0A9
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:19 -0700 (PDT)
Received: from [78.30.34.192] (port=56356 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qdbFe-00Ds3j-8x; Tue, 05 Sep 2023 20:58:17 +0200
Date:   Tue, 5 Sep 2023 20:58:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: fix get element for concatenated set
Message-ID: <ZPd6RGiItVPcfGsi@calendula>
References: <20230905144141.9290-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230905144141.9290-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 05, 2023 at 04:41:38PM +0200, Florian Westphal wrote:
> given:
> table ip filter {
> 	set test {
> 		type ipv4_addr . ether_addr . mark
> 		flags interval
> 		elements = { 198.51.100.0/25 . 00:0b:0c:ca:cc:10-c1:a0:c1:cc:10:00 . 0x0000006f, }
> 	}
> }
> 
> We get lookup failure:
> 
> nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f }
> Error: Could not process rule: No such file or directory
> 
> Its possible to work around this via dummy range somewhere in the key, e.g.
> nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f-0x6f }
> 
> but that shouldn't be needed, so make sure the INTERVAL flag is enabled
> for the queried element if the set is of interval type.

LGTM, comment below:

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index ab3ec98739e9..b1fe7147c2e1 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -4500,11 +4500,14 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
>  		return -1;
>  
>  	cmd->elem.set = set_get(set);
> +	if (set_is_interval(ctx->set->flags)) {
> +		if (!(set->flags & NFT_SET_CONCAT) &&
> +		    interval_set_eval(ctx, ctx->set, cmd->expr) < 0)
> +			return -1;
>  
> -	if (set_is_interval(ctx->set->flags) &&
> -	    !(set->flags & NFT_SET_CONCAT) &&
> -	    interval_set_eval(ctx, ctx->set, cmd->expr) < 0)
> -		return -1;
> +		if (cmd->expr->etype == EXPR_SET)

setelem_evaluate() is always called for CMD_OBJ_ELEMENTS.

I think this branch always evaluates 'true'.

                if (cmd->expr->etype == EXPR_SET)


> +			cmd->expr->set_flags |= NFT_SET_INTERVAL;

so maybe set_flags inconditionally?

> +	}
>  
>  	ctx->set = NULL;
>  
> -- 
> 2.41.0
> 
