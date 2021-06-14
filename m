Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4AC9C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 13:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F5276128A
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 13:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhFNNGZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 09:06:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41526 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbhFNNGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 09:06:24 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 14F20641CC;
        Mon, 14 Jun 2021 15:03:04 +0200 (CEST)
Date:   Mon, 14 Jun 2021 15:04:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: Re: [PATCH nftables] src: use opencoded NFT_SET_ANONYMOUS set flag
 check by set_is_anonymous()
Message-ID: <20210614130418.GA28343@salvia>
References: <20210614125919.47217-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210614125919.47217-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Proposed patch subject should be instead:

src: replace opencoded NFT_SET_ANONYMOUS set flag check by set_is_anonymous()

On Mon, Jun 14, 2021 at 02:59:19PM +0200, Pablo Neira Ayuso wrote:
> Use set_is_anonymous() to check for the NFT_SET_ANONYMOUS set flag
> instead.
> 
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/evaluate.c            | 2 +-
>  src/mnl.c                 | 2 +-
>  src/netlink_delinearize.c | 2 +-
>  src/segtree.c             | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 4397bacf662b..aa7ec9bee4ae 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3781,7 +3781,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  	struct stmt *stmt;
>  	const char *type;
>  
> -	if (!(set->flags & NFT_SET_ANONYMOUS)) {
> +	if (!set_is_anonymous(set->flags)) {
>  		table = table_cache_find(&ctx->nft->cache.table_cache,
>  					 set->handle.table.name,
>  					 set->handle.family);
> diff --git a/src/mnl.c b/src/mnl.c
> index ce58ae7219ec..f28d6605835f 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -1045,7 +1045,7 @@ static void set_key_expression(struct netlink_ctx *ctx,
>  	struct nftnl_udata *nest1, *nest2;
>  
>  	if (expr->flags & EXPR_F_CONSTANT ||
> -	    set_flags & NFT_SET_ANONYMOUS ||
> +	    set_is_anonymous(set_flags) ||
>  	    !expr_ops(expr)->build_udata)
>  		return;
>  
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 57af71a75609..5c80397db26c 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -1591,7 +1591,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
>  				 &stmt->map.stmt_list);
>  	} else {
>  		if (!list_empty(&dynset_parse_ctx.stmt_list) &&
> -		    set->flags & NFT_SET_ANONYMOUS) {
> +		    set_is_anonymous(set->flags)) {
>  			stmt = meter_stmt_alloc(loc);
>  			stmt->meter.set  = set_ref_expr_alloc(loc, set);
>  			stmt->meter.key  = expr;
> diff --git a/src/segtree.c b/src/segtree.c
> index 9de5422c7d7f..5eaf684578bf 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -537,7 +537,7 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
>  			 */
>  			mpz_add_ui(p, prev->right, 1);
>  			if (mpz_cmp(p, ei->left) < 0 ||
> -			    (!(set->flags & NFT_SET_ANONYMOUS) && !merge)) {
> +			    (!set_is_anonymous(set->flags) && !merge)) {
>  				mpz_sub_ui(q, ei->left, 1);
>  				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
>  				list_add_tail(&nei->list, list);
> -- 
> 2.30.2
> 
