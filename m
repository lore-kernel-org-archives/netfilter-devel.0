From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix oob access
Date: Tue, 13 Dec 2016 16:29:04 +0100
Message-ID: <20161213152904.GA2813@salvia>
References: <1481633973-11621-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933579AbcLMPhp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2016 10:37:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6F1287FC2D
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 16:29:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C557DA814
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 16:29:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5C66DA808
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 16:29:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481633973-11621-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 13, 2016 at 01:59:33PM +0100, Florian Westphal wrote:
> BUG: KASAN: slab-out-of-bounds in nf_tables_rule_destroy+0xf1/0x130 at addr ffff88006a4c35c8
> Read of size 8 by task nft/1607
> 
> When we've destroyed last valid expr, nft_expr_next() returns an invalid expr.
> We must not dereference it unless it passes != nft_expr_last() check.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  I dislike nft_expr_last() naming, it doesn't return last
>  valid expression but an invalid address...

Sure, send a patch for this, or simply update this oneliner in v2,
your call.  Thanks.

>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a019a87e58ee..0db5f9782265 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2115,7 +2115,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
>  	 * is called on error from nf_tables_newrule().
>  	 */
>  	expr = nft_expr_first(rule);
> -	while (expr->ops && expr != nft_expr_last(rule)) {
> +	while (expr != nft_expr_last(rule) && expr->ops) {
>  		nf_tables_expr_destroy(ctx, expr);
>  		expr = nft_expr_next(expr);
>  	}
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
