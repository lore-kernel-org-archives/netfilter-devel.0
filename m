Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF9BC7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 16:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248B72064B
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 16:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbfGPQrN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 12:47:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50928 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbfGPQrN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 12:47:13 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hnQbf-0004BR-Cd; Tue, 16 Jul 2019 18:47:11 +0200
Date:   Tue, 16 Jul 2019 18:47:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, charles@ccxtechnologies.com,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nft] evaluate: bogus error when refering to existing
 non-base chain
Message-ID: <20190716164711.GF1628@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, charles@ccxtechnologies.com,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
References: <20190716115120.21710-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716115120.21710-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jul 16, 2019 at 01:51:20PM +0200, Pablo Neira Ayuso wrote:
[...]
> diff --git a/src/evaluate.c b/src/evaluate.c
> index f95f42e1067a..cd566e856a11 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1984,17 +1984,9 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
>  	case EXPR_VERDICT:
>  		if (stmt->expr->verdict != NFT_CONTINUE)
>  			stmt->flags |= STMT_F_TERMINAL;
> -		if (stmt->expr->chain != NULL) {
> -			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
> -				return -1;
> -			if ((stmt->expr->chain->etype != EXPR_SYMBOL &&
> -			    stmt->expr->chain->etype != EXPR_VALUE) ||
> -			    stmt->expr->chain->symtype != SYMBOL_VALUE) {
> -				return stmt_error(ctx, stmt,
> -						  "invalid verdict chain expression %s\n",
> -						  expr_name(stmt->expr->chain));
> -			}
> -		}

According to my logs, this bit was added by Fernando to cover for
invalid variable values[1]. So I fear we can't just drop this check.

Cheers, Phil

[1] I didn't check with current sources, but back then the following
    variable contents were problematic:

    * define foo = @set1 (a set named 'set1' must exist)
    * define foo = { 1024 }
    * define foo = *
