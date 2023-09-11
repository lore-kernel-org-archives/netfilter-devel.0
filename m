Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390EFCA0ECB
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 02:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbjILCr3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240183AbjILCrS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 22:47:18 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586C5412E8
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2023 19:12:39 -0700 (PDT)
Received: from [31.221.198.239] (port=5816 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qfoco-009gqz-Rh; Mon, 11 Sep 2023 23:39:22 +0200
Date:   Mon, 11 Sep 2023 23:39:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] datatype: fix leak and cleanup reference counting
 for struct datatype
Message-ID: <ZP+JBMa83ArN1FQD@calendula>
References: <20230911090106.635361-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230911090106.635361-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

On Mon, Sep 11, 2023 at 11:01:02AM +0200, Thomas Haller wrote:
> Test `./tests/shell/run-tests.sh -V tests/shell/testcases/maps/nat_addr_port`
> fails:
> 
> ==118== 195 (112 direct, 83 indirect) bytes in 1 blocks are definitely lost in loss record 3 of 3
> ==118==    at 0x484682C: calloc (vg_replace_malloc.c:1554)
> ==118==    by 0x48A39DD: xmalloc (utils.c:37)
> ==118==    by 0x48A39DD: xzalloc (utils.c:76)
> ==118==    by 0x487BDFD: datatype_alloc (datatype.c:1205)
> ==118==    by 0x487BDFD: concat_type_alloc (datatype.c:1288)
> ==118==    by 0x488229D: stmt_evaluate_nat_map (evaluate.c:3786)
> ==118==    by 0x488229D: stmt_evaluate_nat (evaluate.c:3892)
> ==118==    by 0x488229D: stmt_evaluate (evaluate.c:4450)
> ==118==    by 0x488328E: rule_evaluate (evaluate.c:4956)
> ==118==    by 0x48ADC71: nft_evaluate (libnftables.c:552)
> ==118==    by 0x48AEC29: nft_run_cmd_from_buffer (libnftables.c:595)
> ==118==    by 0x402983: main (main.c:534)

Thanks, I didn't see this with ASAN.

> I think the reference handling for datatype is wrong. It was introduced
> by commit 01a13882bb59 ('src: add reference counter for dynamic
> datatypes').
> 
> We don't notice it most of the time, because instances are statically
> allocated, where datatype_get()/datatype_free() is a NOP.
> 
> Fix and rework.
> 
> - Commit 01a13882bb59 comments "The reference counter of any newly
>   allocated datatype is set to zero". That seems not workable.
>   Previously, functions like datatype_clone() would have returned the
>   refcnt set to zero. Some callers would then then set the refcnt to one, but
>   some wouldn't (set_datatype_alloc()). Calling datatype_free() with a
>   refcnt of zero will overflow to UINT_MAX and leak:
> 
>        if (--dtype->refcnt > 0)
>           return;
> 
>   While there could be schemes with such asymetric counting, juggle the
>   appropriate number of datatype_get() and datatype_free() calls, this is
>   confusing and error prone. The common pattern is that every
>   alloc/clone/get/ref is paired with exactly one unref/free.
> 
>   Let datatype_clone() return references with refcnt set 1 and in
>   general be always clear about where we transfer ownership (take a
>   reference) and where we need to release it.
> 
> - set_datatype_alloc() needs to consistently return ownership to the
>   reference. Previously, some code paths would and others wouldn't.
> 
> - Replace
> 
>     datatype_set(key, set_datatype_alloc(dtype, key->byteorder))
> 
>   with a datatype_set_take() (for "take" ownership).

See comments below.

> Signed-off-by: Thomas Haller <thaller@redhat.com>
> 
> Fixes: 01a13882bb59 ('src: add reference counter for dynamic datatypes')
> ---
>  include/datatype.h        |   1 +
>  include/expression.h      |   3 +
>  src/datatype.c            |  24 ++++++--
>  src/evaluate.c            | 120 ++++++++++++++++++++++++--------------
>  src/expression.c          |   2 +-
>  src/netlink.c             |  33 ++++++-----
>  src/netlink_delinearize.c |   2 +-
>  src/payload.c             |   3 +-
>  8 files changed, 120 insertions(+), 68 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 6146eda1d2ec..dc11b8331043 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -176,6 +176,7 @@ extern const struct datatype *datatype_lookup(enum datatypes type);
>  extern const struct datatype *datatype_lookup_byname(const char *name);
>  extern struct datatype *datatype_get(const struct datatype *dtype);
>  extern void datatype_set(struct expr *expr, const struct datatype *dtype);
> +extern void datatype_set_take(struct expr *expr, const struct datatype *dtype);
>  extern void datatype_free(const struct datatype *dtype);
>  struct datatype *datatype_clone(const struct datatype *orig_dtype);
>  
> diff --git a/include/expression.h b/include/expression.h
> index 733dd3cfc89c..9a12c4c260b1 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -120,7 +120,10 @@ enum symbol_types {
>   * @maxval:	expected maximum value
>   */
>  struct expr_ctx {
> +	/* expr_ctx does not own the refrence to dtype. The caller must
> +	 * ensure the valid lifetime. */
>  	const struct datatype	*dtype;
> +
>  	enum byteorder		byteorder;
>  	unsigned int		len;
>  	unsigned int		maxval;
> diff --git a/src/datatype.c b/src/datatype.c
> index 1531a5d2a601..6dcf7f972e27 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -1205,6 +1205,7 @@ static struct datatype *datatype_alloc(void)
>  
>  	dtype = xzalloc(sizeof(*dtype));
>  	dtype->flags = DTYPE_F_ALLOC;
> +	dtype->refcnt = 1;
>  
>  	return dtype;
>  }
> @@ -1222,12 +1223,22 @@ struct datatype *datatype_get(const struct datatype *ptr)
>  	return dtype;
>  }
>  
> +void datatype_set_take(struct expr *expr, const struct datatype *dtype)
> +{
> +	const struct datatype *dtype_free;
> +
> +	dtype_free = expr->dtype;
> +	expr->dtype = dtype;
> +	datatype_free(dtype_free);
> +}
> +
>  void datatype_set(struct expr *expr, const struct datatype *dtype)
>  {
> -	if (dtype == expr->dtype)
> -		return;
> -	datatype_free(expr->dtype);
> +	const struct datatype *dtype_free;
> +
> +	dtype_free = expr->dtype;
>  	expr->dtype = datatype_get(dtype);
> +	datatype_free(dtype_free);
>  }

I'd suggest:

void __datatype_set(struct expr *expr, const struct datatype *dtype)
{
	const struct datatype *dtype_free;

	dtype_free = expr->dtype;
	expr->dtype = dtype;
	datatype_free(dtype_free);
}

void datatype_set(struct expr *expr, const struct datatype *dtype)
{
        __datatype_set(expr, datatype_get(dtype));
}

There is similar notation with underscore in the kernel code, I would
prefer to use the __ for those cases where the datatype refcnt is not
touched.

>  struct datatype *datatype_clone(const struct datatype *orig_dtype)
> @@ -1239,7 +1250,7 @@ struct datatype *datatype_clone(const struct datatype *orig_dtype)
>  	dtype->name = xstrdup(orig_dtype->name);
>  	dtype->desc = xstrdup(orig_dtype->desc);
>  	dtype->flags = DTYPE_F_ALLOC | orig_dtype->flags;
> -	dtype->refcnt = 0;
> +	dtype->refcnt = 1;
>  
>  	return dtype;
>  }
> @@ -1252,6 +1263,9 @@ void datatype_free(const struct datatype *ptr)
>  		return;
>  	if (!(dtype->flags & DTYPE_F_ALLOC))
>  		return;
> +
> +	assert(dtype->refcnt != 0);
> +
>  	if (--dtype->refcnt > 0)
>  		return;
>  
> @@ -1304,7 +1318,7 @@ const struct datatype *set_datatype_alloc(const struct datatype *orig_dtype,
>  
>  	/* Restrict dynamic datatype allocation to generic integer datatype. */
>  	if (orig_dtype != &integer_type)
> -		return orig_dtype;
> +		return datatype_get(orig_dtype);
>  
>  	dtype = datatype_clone(orig_dtype);
>  	dtype->byteorder = byteorder;
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 922ce42114a5..8a7b076d96f5 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -83,7 +83,7 @@ static void key_fix_dtype_byteorder(struct expr *key)
>  	if (dtype->byteorder == key->byteorder)
>  		return;
>  
> -	datatype_set(key, set_datatype_alloc(dtype, key->byteorder));
> +	datatype_set_take(key, set_datatype_alloc(dtype, key->byteorder));
>  }
>  
>  static int set_evaluate(struct eval_ctx *ctx, struct set *set);
> @@ -1522,8 +1522,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  			clone = datatype_clone(i->dtype);
>  			clone->size = i->len;
>  			clone->byteorder = i->byteorder;
> -			clone->refcnt = 1;
> -			i->dtype = clone;
> +			datatype_set_take(i, clone);
>  		}
>  
>  		if (dtype == NULL && i->dtype->size == 0)
> @@ -1551,7 +1550,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  	}
>  
>  	(*expr)->flags |= flags;
> -	datatype_set(*expr, concat_type_alloc(ntype));
> +	datatype_set_take(*expr, concat_type_alloc(ntype));
>  	(*expr)->len   = size;
>  
>  	if (off > 0)
> @@ -1887,10 +1886,11 @@ static int mapping_expr_expand(struct eval_ctx *ctx)
>  
>  static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
>  {

The update here in expr_evaluate_map() seems to be related to this
chunk:

                dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
                if (dtype->type == TYPE_VERDICT)
                        data = verdict_expr_alloc(&netlink_location, 0, NULL);
                else
                        data = constant_expr_alloc(&netlink_location, dtype,
                                                   dtype->byteorder, ectx.len, NULL);

turn this into:

                if (ectx.dtype->type == TYPE_VERDICT) {
                        data = verdict_expr_alloc(&netlink_location, 0, NULL);
                } else {
                        dtype = set_datatype_alloc(ectx.dtype, ectx.byteorder);
                        data = constant_expr_alloc(&netlink_location, dtype,
                                                   dtype->byteorder, ectx.len, NULL);
                }

to disentangle this.

dtype is now attached to the constant expression, so there is no need
to handle for datatype_free() case anymore in this function (this will
significantly reduce the size of this patch).

> +	const struct datatype *dtype = NULL;
>  	struct expr *map = *expr, *mappings;
>  	struct expr_ctx ectx = ctx->ectx;
> -	const struct datatype *dtype;
>  	struct expr *key, *data;
> +	int r;
>  
>  	if (map->map->etype == EXPR_CT &&
>  	    (map->map->ct.key == NFT_CT_SRC ||
> @@ -1948,23 +1948,31 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
>  		map->mappings = mappings;
>  
>  		ctx->set = mappings->set;
> -		if (expr_evaluate(ctx, &map->mappings->set->init) < 0)
> -			return -1;
> +		if (expr_evaluate(ctx, &map->mappings->set->init) < 0) {
> +			r = -1;
> +			goto out;
> +		}
>  
>  		if (set_is_interval(map->mappings->set->init->set_flags) &&
>  		    !(map->mappings->set->init->set_flags & NFT_SET_CONCAT) &&
> -		    interval_set_eval(ctx, ctx->set, map->mappings->set->init) < 0)
> -			return -1;
> +		    interval_set_eval(ctx, ctx->set, map->mappings->set->init) < 0) {
> +			r = -1;
> +			goto out;
> +		}
>  
>  		expr_set_context(&ctx->ectx, ctx->set->key->dtype, ctx->set->key->len);
> -		if (binop_transfer(ctx, expr) < 0)
> -			return -1;
> +		if (binop_transfer(ctx, expr) < 0) {
> +			r = -1;
> +			goto out;
> +		}
>  
>  		if (ctx->set->data->flags & EXPR_F_INTERVAL) {
>  			ctx->set->data->len *= 2;
>  
> -			if (mapping_expr_expand(ctx))
> -				return -1;
> +			if (mapping_expr_expand(ctx)) {
> +				r = -1;
> +				goto out;
> +			}
>  		}
>  
>  		ctx->set->key->len = ctx->ectx.len;
> @@ -1974,12 +1982,16 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
>  		map_set_concat_info(map);
>  		break;
>  	case EXPR_SYMBOL:
> -		if (expr_evaluate(ctx, &map->mappings) < 0)
> -			return -1;
> +		if (expr_evaluate(ctx, &map->mappings) < 0) {
> +			r = -1;
> +			goto out;
> +		}
>  		if (map->mappings->etype != EXPR_SET_REF ||
> -		    !set_is_datamap(map->mappings->set->flags))
> -			return expr_error(ctx->msgs, map->mappings,
> +		    !set_is_datamap(map->mappings->set->flags)) {
> +			r = expr_error(ctx->msgs, map->mappings,
>  					  "Expression is not a map");
> +			goto out;
> +		}
>  		break;
>  	case EXPR_SET_REF:
>  		/* symbol has been already evaluated to set reference */
> @@ -1989,22 +2001,30 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
>  		    expr_name(map->mappings));
>  	}
>  
> -	if (!datatype_equal(map->map->dtype, map->mappings->set->key->dtype))
> -		return expr_binary_error(ctx->msgs, map->mappings, map->map,
> +	if (!datatype_equal(map->map->dtype, map->mappings->set->key->dtype)) {
> +		r = expr_binary_error(ctx->msgs, map->mappings, map->map,
>  					 "datatype mismatch, map expects %s, "
>  					 "mapping expression has type %s",
>  					 map->mappings->set->key->dtype->desc,
>  					 map->map->dtype->desc);
> +		goto out;
> +	}
>  
>  	datatype_set(map, map->mappings->set->data->dtype);
>  	map->flags |= EXPR_F_CONSTANT;
>  
>  	/* Data for range lookups needs to be in big endian order */
>  	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
> -	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0)
> -		return -1;
> +	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0) {
> +		r = -1;
> +		goto out;
> +	}
>  
> -	return 0;
> +	r = 0;
> +
> +out:
> +	datatype_free(dtype);
> +	return r;
>  }
>  
>  static bool data_mapping_has_interval(struct expr *data)
> @@ -3766,8 +3786,10 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	struct proto_ctx *pctx = eval_proto_ctx(ctx);
>  	struct expr *one, *two, *data, *tmp;
> -	const struct datatype *dtype;
> -	int addr_type, err;
> +	const struct datatype *dtype = NULL;
> +	const struct datatype *dtype2;
> +	int addr_type;
> +	int r;
>  
>  	if (stmt->nat.family == NFPROTO_INET)
>  		expr_family_infer(pctx, stmt->nat.addr, &stmt->nat.family);
> @@ -3787,18 +3809,23 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
>  	dtype = concat_type_alloc((addr_type << TYPE_BITS) | TYPE_INET_SERVICE);
>
>  	expr_set_context(&ctx->ectx, dtype, dtype->size);
> -	if (expr_evaluate(ctx, &stmt->nat.addr))
> -		return -1;
> +	if (expr_evaluate(ctx, &stmt->nat.addr)) {
> +		r = -1;

Could you use something larger that `r' ? I use pattern matching when
searching for variables in my editor, and this is too short. If you
dislike 'err' and 'ret' just pick something else, please.

> +		goto out;
> +	}
>  
>  	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
>  	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr)) {
> -		return stmt_binary_error(ctx, stmt->nat.addr, stmt,
> +		r = stmt_binary_error(ctx, stmt->nat.addr, stmt,
>  					 "transport protocol mapping is only "
>  					 "valid after transport protocol match");
> +		goto out;
>  	}
>  
> -	if (stmt->nat.addr->etype != EXPR_MAP)
> -		return 0;
> +	if (stmt->nat.addr->etype != EXPR_MAP) {
> +		r = 0;
> +		goto out;
> +	}
>  
>  	data = stmt->nat.addr->mappings->set->data;
>  	if (data->flags & EXPR_F_INTERVAL)
> @@ -3806,37 +3833,43 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
>  
>  	datatype_set(data, dtype);

Note here above, dtype is set to data expression, then...

>  
> -	if (expr_ops(data)->type != EXPR_CONCAT)
> -		return __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
> +	if (expr_ops(data)->type != EXPR_CONCAT) {
> +		r = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
>  					   BYTEORDER_BIG_ENDIAN,
>  					   &stmt->nat.addr);
> +		goto out;

... this goto is not needed anymore? dtype has been already set to data.
So this patch can be simplified. Same things for goto below in the
scope of this function.

> +	}
>  
>  	one = list_first_entry(&data->expressions, struct expr, list);
>  	two = list_entry(one->list.next, struct expr, list);
>  
> -	if (one == two || !list_is_last(&two->list, &data->expressions))
> -		return __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
> +	if (one == two || !list_is_last(&two->list, &data->expressions)) {
> +		r = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
>  					   BYTEORDER_BIG_ENDIAN,
>  					   &stmt->nat.addr);
> +		goto out;
> +	}
>  
> -	dtype = get_addr_dtype(stmt->nat.family);
> +	dtype2 = get_addr_dtype(stmt->nat.family);
>  	tmp = one;
> -	err = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
> +	r = __stmt_evaluate_arg(ctx, stmt, dtype2, dtype2->size,
>  				  BYTEORDER_BIG_ENDIAN,
>  				  &tmp);
> -	if (err < 0)
> -		return err;
> +	if (r < 0)
> +		goto out;
>  	if (tmp != one)
>  		BUG("Internal error: Unexpected alteration of l3 expression");
>  
>  	tmp = two;
> -	err = nat_evaluate_transport(ctx, stmt, &tmp);
> -	if (err < 0)
> -		return err;
> +	r = nat_evaluate_transport(ctx, stmt, &tmp);
> +	if (r < 0)
> +		goto out;
>  	if (tmp != two)
>  		BUG("Internal error: Unexpected alteration of l4 expression");
>  
> -	return err;
> +out:
> +	datatype_free(dtype);
> +	return r;
>  }
>  
>  static bool nat_concat_map(struct eval_ctx *ctx, struct stmt *stmt)
> @@ -4550,8 +4583,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  			dtype = datatype_clone(i->dtype);
>  			dtype->size = i->len;
>  			dtype->byteorder = i->byteorder;
> -			dtype->refcnt = 1;
> -			i->dtype = dtype;
> +			datatype_set_take(i, dtype);
>  		}
>  
>  		if (i->dtype->size == 0 && i->len == 0)
> @@ -4574,7 +4606,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>  	}
>  
>  	(*expr)->flags |= flags;
> -	datatype_set(*expr, concat_type_alloc(ntype));
> +	datatype_set_take(*expr, concat_type_alloc(ntype));
>  	(*expr)->len   = size;
>  
>  	expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->len);
> diff --git a/src/expression.c b/src/expression.c
> index 147320f08937..232f48a16f7f 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -1014,7 +1014,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
>  	if (!dtype)
>  		goto err_free;
>  
> -	concat_expr->dtype = datatype_get(dtype);
> +	datatype_set_take(concat_expr, dtype);
>  	concat_expr->len = len;
>  
>  	return concat_expr;
> diff --git a/src/netlink.c b/src/netlink.c
> index af6fd427bd57..eb559cf33abe 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -799,6 +799,9 @@ enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype)
>  
>  static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
>  {
> +	/* The function always returns ownership of a reference. But for
> +	 * &verdict_Type and datatype_lookup(), those are static instances,
> +	 * we can omit the datatype_get() call. */

Please:

        /* xxx
         * yyy
         */

netdev comment style is preferred.

>  	switch (type) {
>  	case NFT_DATA_VERDICT:
>  		return &verdict_type;
> @@ -934,12 +937,14 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1] = {};
>  	enum byteorder keybyteorder = BYTEORDER_INVALID;
>  	enum byteorder databyteorder = BYTEORDER_INVALID;
> -	const struct datatype *keytype, *datatype = NULL;
>  	struct expr *typeof_expr_key, *typeof_expr_data;
>  	struct setelem_parse_ctx set_parse_ctx;
> +	const struct datatype *datatype = NULL;
> +	const struct datatype *keytype = NULL;
> +	const struct datatype *dtype2 = NULL;
> +	const struct datatype *dtype = NULL;
>  	const char *udata, *comment = NULL;
>  	uint32_t flags, key, objtype = 0;
> -	const struct datatype *dtype;
>  	uint32_t data_interval = 0;
>  	bool automerge = false;
>  	struct set *set;
> @@ -978,7 +983,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  	if (keytype == NULL) {
>  		netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
>  				 key);
> -		return NULL;
> +		set = NULL;
> +		goto out;

Why this goto out? Not really needed.

>  	}
>  
>  	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
> @@ -991,8 +997,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  			netlink_io_error(ctx, NULL,
>  					 "Unknown data type in set key %u",
>  					 data);
> -			datatype_free(keytype);
> -			return NULL;
> +			set = NULL;
> +			goto out;
>  		}
>  	}
>  
> @@ -1030,19 +1036,18 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  	if (datatype) {

Move this code under this if (datatype) branch into function in a
preparation patch.

Please, call it:

        netlink_delinearize_set_typeof()

or pick a better name if you like so there is no need for dtype2.

It will help clean up this chunk that you are passing by here.

Thanks!

>  		uint32_t dlen;
>  
> -		dtype = set_datatype_alloc(datatype, databyteorder);
> +		dtype2 = set_datatype_alloc(datatype, databyteorder);
>  		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
>  
>  		dlen = data_interval ?  klen / 2 : klen;
>  
>  		if (set_udata_key_valid(typeof_expr_data, dlen)) {
>  			typeof_expr_data->len = klen;
> -			datatype_free(datatype_get(dtype));
>  			set->data = typeof_expr_data;
>  		} else {
>  			expr_free(typeof_expr_data);
>  			set->data = constant_expr_alloc(&netlink_location,
> -							dtype,
> +							dtype2,
>  							databyteorder, klen,
>  							NULL);
>  
> @@ -1053,16 +1058,12 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  
>  		if (data_interval)
>  			set->data->flags |= EXPR_F_INTERVAL;
> -
> -		if (dtype != datatype)
> -			datatype_free(datatype);
>  	}
>  
>  	dtype = set_datatype_alloc(keytype, keybyteorder);
>  	klen = nftnl_set_get_u32(nls, NFTNL_SET_KEY_LEN) * BITS_PER_BYTE;
>  
>  	if (set_udata_key_valid(typeof_expr_key, klen)) {
> -		datatype_free(datatype_get(dtype));
>  		set->key = typeof_expr_key;
>  		set->key_typeof_valid = true;
>  	} else {
> @@ -1072,9 +1073,6 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  					       NULL);
>  	}
>  
> -	if (dtype != keytype)
> -		datatype_free(keytype);
> -
>  	set->flags   = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
>  	set->handle.handle.id = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
>  
> @@ -1102,6 +1100,11 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  		}
>  	}
>  
> +out:
> +	datatype_free(datatype);
> +	datatype_free(keytype);
> +	datatype_free(dtype2);
> +	datatype_free(dtype);
>  	return set;
>  }
>  
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index bde783bdf4ad..f4e9dda473c9 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -2769,7 +2769,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
>  		}
>  		ctx->flags &= ~RULE_PP_IN_CONCATENATION;
>  		list_splice(&tmp, &expr->expressions);
> -		datatype_set(expr, concat_type_alloc(ntype));
> +		datatype_set_take(expr, concat_type_alloc(ntype));
>  		break;
>  	}
>  	case EXPR_UNARY:
> diff --git a/src/payload.c b/src/payload.c
> index 179ddcbdd3fe..03aa552dec77 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -254,8 +254,7 @@ static struct expr *payload_expr_parse_udata(const struct nftnl_udata *attr)
>  		dtype = datatype_clone(&xinteger_type);
>  		dtype->size = len;
>  		dtype->byteorder = BYTEORDER_BIG_ENDIAN;
> -		dtype->refcnt = 1;
> -		expr->dtype = dtype;
> +		datatype_set_take(expr, dtype);
>  	}
>  
>  	if (ud[NFTNL_UDATA_SET_KEY_PAYLOAD_INNER_DESC]) {
> -- 
> 2.41.0
> 
