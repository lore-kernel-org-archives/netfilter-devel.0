Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0683C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 11:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiIULtz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 07:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiIULtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 07:49:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D35E923FE
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Sep 2022 04:48:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oayDL-0006y4-7n; Wed, 21 Sep 2022 13:48:27 +0200
Date:   Wed, 21 Sep 2022 13:48:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] segtree: fix decomposition of unclosed intervals
 containing address prefixes
Message-ID: <Yyr6C+IKMrCM0hQJ@strlen.de>
References: <20220918172212.3681553-1-jeremy@azazel.net>
 <20220918172212.3681553-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220918172212.3681553-3-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> @@ -619,24 +622,12 @@ void interval_map_decompose(struct expr *set)
>  
>  	if (!mpz_cmp(i->value, expr_value(low)->value)) {
>  		expr_free(i);
> -		i = low;
> +		compound_expr_add(set, low);
>  	} else {
> -		i = range_expr_alloc(&low->location,
> -				     expr_clone(expr_value(low)), i);
> -		i = set_elem_expr_alloc(&low->location, i);
> -		if (low->etype == EXPR_MAPPING) {
> -			i = mapping_expr_alloc(&i->location, i,
> -					       expr_clone(low->right));
> -			interval_expr_copy(i->left, low->left);
> -		} else {
> -			interval_expr_copy(i, low);
> -		}
> -		i->flags |= EXPR_F_KERNEL;
> -
> +		add_interval(set, low, i);
>  		expr_free(low);
>  	}
>  
> -	compound_expr_add(set, i);

This results in a memory leak:

__interceptor_malloc libsanitizer/asan/asan_malloc_linux.cpp:145
xmalloc src/utils.c:36
xzalloc src/utils.c:75
expr_alloc src/expression.c:46
constant_expr_alloc src/expression.c:420
interval_map_decompose src/segtree.c:619

Before, 'i' was assigned to the compund expr, but thats no longer the
case.

Does this look good to you?  If so, I will sqash this before applying:

diff --git a/src/segtree.c b/src/segtree.c
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -621,13 +621,14 @@ void interval_map_decompose(struct expr *set)
 	mpz_bitmask(i->value, i->len);
 
 	if (!mpz_cmp(i->value, expr_value(low)->value)) {
-		expr_free(i);
 		compound_expr_add(set, low);
 	} else {
 		add_interval(set, low, i);
 		expr_free(low);
 	}
 
+	expr_free(i);
+
 out:
 	if (catchall)
 		compound_expr_add(set, catchall);
