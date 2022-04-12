Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6442C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiDLXtz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiDLXto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 19:49:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B22E2648
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 16:46:25 -0700 (PDT)
Date:   Wed, 13 Apr 2022 01:46:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 5/9] src: make interval sets work with string
 datatypes
Message-ID: <YlYPTq23jx41dZDE@salvia>
References: <20220409135832.17401-1-fw@strlen.de>
 <20220409135832.17401-6-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220409135832.17401-6-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 09, 2022 at 03:58:28PM +0200, Florian Westphal wrote:
> Allows to interface names in interval sets:
> 
> table inet filter {
>         set s {
>                 type ifname
>                 flags interval
>                 elements = { eth*, foo }
>         }
> 
> Concatenations are not yet supported, also, listing is broken,
> those strings will not be printed back because the values will remain
> in big-endian order.  Followup patch will extend segtree to translate
> this back to host byte order.

I think this is the only patch that will clash with the new
src/intervals.c infrastructure (set automerge deletion):

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=294779

Most of the segtree.c code, including seg_tree_init() is gone after it.

I can have a look and rebase after you push this.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expression.c |  8 ++++++--
>  src/segtree.c    | 30 ++++++++++++++++++++++++++----
>  2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/src/expression.c b/src/expression.c
> index deb649e1847b..5d879b535990 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -1442,7 +1442,11 @@ void range_expr_value_low(mpz_t rop, const struct expr *expr)
>  {
>  	switch (expr->etype) {
>  	case EXPR_VALUE:
> -		return mpz_set(rop, expr->value);
> +		mpz_set(rop, expr->value);
> +		if (expr->byteorder == BYTEORDER_HOST_ENDIAN &&
> +		    expr_basetype(expr)->type == TYPE_STRING)
> +			mpz_switch_byteorder(rop, expr->len / BITS_PER_BYTE);
> +		return;
>  	case EXPR_PREFIX:
>  		return range_expr_value_low(rop, expr->prefix);
>  	case EXPR_RANGE:
> @@ -1462,7 +1466,7 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
>  
>  	switch (expr->etype) {
>  	case EXPR_VALUE:
> -		return mpz_set(rop, expr->value);
> +		return range_expr_value_low(rop, expr);
>  	case EXPR_PREFIX:
>  		range_expr_value_low(rop, expr->prefix);
>  		assert(expr->len >= expr->prefix_len);
> diff --git a/src/segtree.c b/src/segtree.c
> index 188cafedce45..b4e76bf530d6 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -70,12 +70,30 @@ struct elementary_interval {
>  	struct expr			*expr;
>  };
>  
> +static enum byteorder get_key_byteorder(const struct expr *e)
> +{
> +	enum datatypes basetype = expr_basetype(e)->type;
> +
> +	switch (basetype) {
> +	case TYPE_INTEGER:
> +		/* For ranges, integers MUST be in BYTEORDER_BIG_ENDIAN.
> +		 * If the LHS (lookup key, e.g. 'meta mark', is host endian,
> +		 * a byteorder expression is injected to convert the register
> +		 * content before lookup.
> +		 */
> +		return BYTEORDER_BIG_ENDIAN;
> +	case TYPE_STRING:
> +		return BYTEORDER_HOST_ENDIAN;
> +	default:
> +		break;
> +	}
> +
> +	return BYTEORDER_INVALID;
> +}
> +
>  static void seg_tree_init(struct seg_tree *tree, const struct set *set,
>  			  struct expr *init, unsigned int debug_mask)
>  {
> -	struct expr *first;
> -
> -	first = list_entry(init->expressions.next, struct expr, list);
>  	tree->root	= RB_ROOT;
>  	tree->keytype	= set->key->dtype;
>  	tree->keylen	= set->key->len;
> @@ -85,7 +103,8 @@ static void seg_tree_init(struct seg_tree *tree, const struct set *set,
>  		tree->datatype	= set->data->dtype;
>  		tree->datalen	= set->data->len;
>  	}
> -	tree->byteorder	= first->byteorder;
> +
> +	tree->byteorder = get_key_byteorder(set->key);
>  	tree->debug_mask = debug_mask;
>  }
>  
> @@ -608,6 +627,9 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
>  	expr = constant_expr_alloc(&internal_location, tree->keytype,
>  				   tree->byteorder, tree->keylen, NULL);
>  	mpz_set(expr->value, ei->left);
> +	if (tree->byteorder == BYTEORDER_HOST_ENDIAN)
> +		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
> +
>  	expr = set_elem_expr_alloc(&internal_location, expr);
>  
>  	if (ei->expr != NULL) {
> -- 
> 2.35.1
> 
