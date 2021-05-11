Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08A7C43461
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 13:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C6ED6191D
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 13:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhEKNdt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhEKNdX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:33:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C927CC061760
        for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2021 06:32:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lgSUf-0002p1-9w; Tue, 11 May 2021 15:32:13 +0200
Date:   Tue, 11 May 2021 15:32:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, arturo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH nftables,v2 2/2] src: add set element catch-all support
Message-ID: <20210511133213.GT12403@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, arturo@netfilter.org, fw@strlen.de
References: <20210511130538.63450-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511130538.63450-1-pablo@netfilter.org>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 11, 2021 at 03:05:38PM +0200, Pablo Neira Ayuso wrote:
[...]
> diff --git a/src/expression.c b/src/expression.c
> index 9fdf23d98446..4d80e37a5bb6 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -1270,7 +1270,11 @@ static void set_elem_expr_print(const struct expr *expr,
>  {
>  	struct stmt *stmt;
>  
> -	expr_print(expr->key, octx);
> +	if (expr->key->etype == EXPR_SET_ELEM_CATCHALL)
> +		nft_print(octx, "*");
> +	else
> +		expr_print(expr->key, octx);
> +
>  	list_for_each_entry(stmt, &expr->stmt_list, list) {
>  		nft_print(octx, " ");
>  		stmt_print(stmt, octx);
> @@ -1299,7 +1303,9 @@ static void set_elem_expr_destroy(struct expr *expr)
[...]
> @@ -1328,6 +1334,24 @@ struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
>  	return expr;
>  }
>  
> +static void set_elem_catchall_expr_print(const struct expr *expr,
> +					 struct output_ctx *octx)
> +{
> +	nft_print(octx, "_");
> +}

This is a leftover from v1. Since this went unnoticed, maybe you could
drop the special casing in set_elem_expr_print() and rely on
expr_print(expr->key, octx) to call the above? Or am I (probably)
confusing things?

Cheers, Phil
