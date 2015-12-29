From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/5] ct: add support for directional keys
Date: Wed, 30 Dec 2015 00:49:41 +0100
Message-ID: <20151229234941.GB1386@salvia>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
 <1450472883-19743-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44124 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbbL2Xtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 18:49:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 947E51022A5
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:49:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 844D0DA7E0
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:49:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 99203DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:49:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1450472883-19743-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2015 at 10:07:59PM +0100, Florian Westphal wrote:
> A few keys in the ct expression are directional, i.e.
> we need to tell kernel if it should fetch REPLY or ORIGINAL direction.
> 
> Split ct_keys into ct_keys & ct_keys_dir, the latter are those keys
> that the kernel rejects unless also given a direction.
> 
> During postprocessing we also need to invoke ct_expr_update_type,
> problem is that e.g. ct saddr can be any family (ip, ipv6) so we need
> to update the expected data type based on the network base.

I think this is the way to go. My original proposal will not allow
things like:

        ct direction reply ct daddr original 2.2.2.2

which seems to me like a valid matching, specifically when NAT comes
into place (where original and reply tuples are not the same). This is
kind of corner case, but I think we shouldn't reduce the expressiveness.

Several comments below:

> diff --git a/include/expression.h b/include/expression.h
> index 010cb95..130cc1f 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -273,6 +273,7 @@ struct expr {
>  		struct {
>  			/* EXPR_CT */
>  			enum nft_ct_keys	key;
> +			struct expr		*dir_expr;

I think you can store the direction as a value.

>  		} ct;
>  	};
>  };
[...]
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 7aab6aa..8dd1373 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -471,10 +471,24 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
>   */
>  static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
>  {
> +	struct expr *direction = NULL;
> +	struct error_record *erec;
>  	struct expr *ct = *expr;
>  
>  	ct_expr_update_type(&ctx->pctx, ct);
>  
> +	if (ct->ct.dir_expr &&
> +	    ct->ct.dir_expr->ops->type == EXPR_SYMBOL) {
> +		erec = symbol_parse(ct->ct.dir_expr, &direction);
> +		if (erec != NULL) {
> +			erec_queue(erec, ctx->msgs);
> +			return -1;
> +		}
> +
> +		expr_free(ct->ct.dir_expr);
> +		ct->ct.dir_expr = direction;
> +	}

I'd suggest you parse the direction from the parser, I don't find any
good reason to postpone this error handling. This should also simplify
the delinearize step since we'll get a value when parsing the netlink
attributes.

> +
>  	return expr_evaluate_primary(ctx, expr);
>  }
>  
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index f68fca0..306d1b8 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -536,12 +536,19 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
>  				  const struct location *loc,
>  				  const struct nftnl_expr *nle)
>  {
> +	struct expr *expr = NULL;
>  	enum nft_registers dreg;
>  	uint32_t key;
> -	struct expr *expr;
> +
> +	if (nftnl_expr_is_set(nle, NFTNL_EXPR_CT_DIR)) {
> +		uint8_t dir = nftnl_expr_get_u8(nle, NFTNL_EXPR_CT_DIR);
> +
> +		expr = constant_expr_alloc(loc, &integer_type,
> +					   BYTEORDER_HOST_ENDIAN, 8, &dir);
> +	}
>  
>  	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
> -	expr = ct_expr_alloc(loc, key);
> +	expr = ct_expr_alloc(loc, key, expr);
>  
>  	dreg = netlink_parse_register(nle, NFTNL_EXPR_CT_DREG);
>  	netlink_set_register(ctx, dreg, expr);
> @@ -1117,6 +1124,12 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
>  	}
>  }
>  
> +static void ct_match_postprocess(struct rule_pp_ctx *ctx,
> +				 const struct expr *expr)
> +{
> +	return meta_match_postprocess(ctx, expr);
> +}
> +
>  /* Convert a bitmask to a prefix length */
>  static unsigned int expr_mask_to_prefix(const struct expr *expr)
>  {
> @@ -1394,6 +1407,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
>  		expr_postprocess(ctx, &expr->right);
>  
>  		switch (expr->left->ops->type) {
> +		case EXPR_CT:
> +			ct_match_postprocess(ctx, expr);
> +			break;
>  		case EXPR_META:
>  			meta_match_postprocess(ctx, expr);
>  			break;
> @@ -1431,9 +1447,11 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
>  	case EXPR_SET_REF:
>  	case EXPR_EXTHDR:
>  	case EXPR_META:
> -	case EXPR_CT:
>  	case EXPR_VERDICT:
>  		break;
> +	case EXPR_CT:
> +		ct_expr_update_type(&ctx->pctx, expr);
> +		break;
>  	default:
>  		BUG("unknown expression type %s\n", expr->ops->name);
>  	}
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 131c3f9..81fe754 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -209,6 +209,10 @@ static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
>  	nle = alloc_nft_expr("ct");
>  	netlink_put_register(nle, NFTNL_EXPR_CT_DREG, dreg);
>  	nftnl_expr_set_u32(nle, NFTNL_EXPR_CT_KEY, expr->ct.key);
> +	if (expr->ct.dir_expr)
> +		nftnl_expr_set_u8(nle, NFTNL_EXPR_CT_DIR,
> +			mpz_get_uint8(expr->ct.dir_expr->value));
> +
>  	nftnl_rule_add_expr(ctx->nlr, nle);
>  }
>  
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index fbfe7ea..93fa7d3 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -555,7 +555,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  
>  %type <expr>			ct_expr
>  %destructor { expr_free($$); }	ct_expr
> -%type <val>			ct_key
> +%type <val>			ct_key		ct_key_dir
>  
>  %type <val>			export_format
>  %type <string>			monitor_event
> @@ -2037,9 +2037,18 @@ meta_stmt		:	META	meta_key	SET	expr
>  			}
>  			;
>  
> -ct_expr			:	CT	ct_key
> +ct_expr			: 	CT	ct_key
>  			{
> -				$$ = ct_expr_alloc(&@$, $2);
> +				$$ = ct_expr_alloc(&@$, $2, NULL);
> +			}
> +			|	CT	ct_key_dir 	STRING
> +			{
> +				struct expr *e = NULL;
> +
> +				e = symbol_expr_alloc(&@$, SYMBOL_VALUE,
> +							       current_scope(state), $3);

ie. parse the string and obtain the value from here.

> +
> +				$$ = ct_expr_alloc(&@$, $2, e);
>  			}
>  			;
>  
