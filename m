Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6438DC77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 May 2023 07:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbjEXHuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 May 2023 03:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjEXHuH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2023 03:50:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 976C18F
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2023 00:50:05 -0700 (PDT)
Date:   Wed, 24 May 2023 09:50:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>, f@calendula
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables; key update with symbolic values/immediates
Message-ID: <ZG3Bqcz3Dru4xOBS@calendula>
References: <20230523172931.GB17561@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230523172931.GB17561@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Tue, May 23, 2023 at 07:29:31PM +0200, Florian Westphal wrote:
> Hello.
> 
> Consider following example:
> 
> table ip t {
> 	set s {
> 		type ipv4_addr . ipv4_addr . inet_service
> 		size 65535
> 		flags dynamic, timeout
> 		timeout 3h
> 	}
> 
> 	chain c1 {
> 		update @s { ip saddr . 10.180.0.4 . 80 }
> 	}
> 
> 	chain c2 {
> 		ip saddr . 1.2.3.4 . 80 @s goto c1
> 	}
> }
> 
> This doesn't work:
> :13:14-20: Error: Can't parse symbolic invalid expressions
> ip saddr . 1.2.3.4 . 80 @s goto c1
> 
> Problem is that expr_evaluate_relational() first evaluates
> the lhs, so by the time concat evaluation encounters '1.2.3.4'
> symbol there is nothing that would hint at what datatype that is.
> 
> For this specific case, its possible to first evaluate the rhs, i.e.:
> 
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2336,8 +2336,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
>         struct expr *range;
>         int ret;
>  
> +       right = rel->right;
> +       if (right->etype == EXPR_SYMBOL &&
> +           right->symtype == SYMBOL_SET &&
> +           expr_evaluate(ctx, &rel->right) < 0)
> +               return -1;
> +
> 
> This populates ectx->key and thus allows to infer the symbolic data
> type:
> 
> 1485                 if (key) {
> 1486                         tmp = key->dtype;
> 1487                         dsize = key->len;
> 1488                         bo = key->byteorder;
> 1489                         off--;
> 1490                 } else if (dtype == NULL || off == 0) {
> 1491                         tmp = datatype_lookup(TYPE_INVALID);
> 
> line 1486ff.  With unmodified nft, this hits the 'dtype == NULL' path
> and decoding "1.2.3.4" fails.
> 
> What do you think?  If you think this is fine I can work on this,
> above patch makes nft parse the example above, it needs more work on
> delinarization path.

If you have a use-case for this, go ahead.

Is there any other issue you can forecast on the delinearize path? Or
is it just that the code to handle this is missing?

Thanks.
