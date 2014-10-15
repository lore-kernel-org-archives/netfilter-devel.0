From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src: add redirect support
Date: Wed, 15 Oct 2014 12:08:29 +0200
Message-ID: <20141015100829.GD4885@salvia>
References: <20141015074756.30515.90161.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44420 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbaJOKHG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:07:06 -0400
Content-Disposition: inline
In-Reply-To: <20141015074756.30515.90161.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 15, 2014 at 09:47:56AM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds redirect support for nft.
> 
> The syntax is:
> 
>  % nft add rule nat prerouting redirect [port|nat_flags]
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/statement.h       |   10 +++++++++
>  src/evaluate.c            |   42 ++++++++++++++++++++++++++++++++++++
>  src/netlink_delinearize.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
>  src/netlink_linearize.c   |   49 ++++++++++++++++++++++++++++++++++++++++++
>  src/parser.y              |   23 ++++++++++++++++++--
>  src/scanner.l             |    1 +
>  src/statement.c           |   29 +++++++++++++++++++++++++
>  7 files changed, 204 insertions(+), 2 deletions(-)
> 
> diff --git a/include/statement.h b/include/statement.h
> index 35c1b7a..d143121 100644
> --- a/include/statement.h
> +++ b/include/statement.h
> @@ -79,6 +79,13 @@ struct masq_stmt {
>  
>  extern struct stmt *masq_stmt_alloc(const struct location *loc);
>  
> +struct redir_stmt {
> +	struct expr		*proto;
> +	uint32_t		flags;
> +};
> +
> +extern struct stmt *redir_stmt_alloc(const struct location *loc);
> +
>  struct queue_stmt {
>  	struct expr		*queue;
>  	uint16_t		flags;
> @@ -110,6 +117,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
>   * @STMT_REJECT:	REJECT statement
>   * @STMT_NAT:		NAT statement
>   * @STMT_MASQ:		masquerade statement
> + * @STMT_REDIR:		redirect statement
>   * @STMT_QUEUE:		QUEUE statement
>   * @STMT_CT:		conntrack statement
>   */
> @@ -124,6 +132,7 @@ enum stmt_types {
>  	STMT_REJECT,
>  	STMT_NAT,
>  	STMT_MASQ,
> +	STMT_REDIR,
>  	STMT_QUEUE,
>  	STMT_CT,
>  };
> @@ -172,6 +181,7 @@ struct stmt {
>  		struct reject_stmt	reject;
>  		struct nat_stmt		nat;
>  		struct masq_stmt	masq;
> +		struct redir_stmt	redir;
>  		struct queue_stmt	queue;
>  		struct ct_stmt		ct;
>  	};
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 108248a..6a2c724 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1375,6 +1375,46 @@ out:
>  	return 0;
>  }
>  
> +static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
> +{
> +	int err;
> +	struct proto_ctx *pctx = &ctx->pctx;
> +
> +	if (!pctx)
> +		goto out;
> +
> +	switch (pctx->family) {
> +	case AF_INET:
> +		expr_set_context(&ctx->ectx, &ipaddr_type,
> +				4 * BITS_PER_BYTE);
> +		break;
> +	case AF_INET6:
> +		expr_set_context(&ctx->ectx, &ip6addr_type,
> +				 16 * BITS_PER_BYTE);
> +		break;
> +	default:
> +		return stmt_error(ctx, stmt, "ip and ip6 support only");
> +	}
> +
> +	if (stmt->redir.proto != NULL) {
> +		if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
> +			return stmt_binary_error(ctx, stmt->redir.proto, stmt,
> +						 "transport protocol mapping "
> +						 "is only valid after "
> +						 "transport protocol match");

Errors have to fit in one line, preferably.

> +
> +		expr_set_context(&ctx->ectx, &inet_service_type,
> +				 2 * BITS_PER_BYTE);
> +		err = expr_evaluate(ctx, &stmt->redir.proto);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +out:
> +	stmt->flags |= STMT_F_TERMINAL;
> +	return 0;
> +}
> +
>  static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	expr_set_context(&ctx->ectx, stmt->ct.tmpl->dtype,
> @@ -1437,6 +1477,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
>  		return stmt_evaluate_nat(ctx, stmt);
>  	case STMT_MASQ:
>  		return stmt_evaluate_masq(ctx, stmt);
> +	case STMT_REDIR:
> +		return stmt_evaluate_redir(ctx, stmt);
>  	case STMT_QUEUE:
>  		return stmt_evaluate_queue(ctx, stmt);
>  	case STMT_CT:
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 38618ee..2d104db 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -583,6 +583,52 @@ static void netlink_parse_masq(struct netlink_parse_ctx *ctx,
>  	list_add_tail(&stmt->list, &ctx->rule->stmts);
>  }
>  
> +static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
> +				const struct location *loc,
> +				const struct nft_rule_expr *nle)
> +{
> +	struct stmt *stmt;
> +	struct expr *proto;
> +	enum nft_registers reg1, reg2;
> +	uint32_t flags;
> +
> +	stmt = redir_stmt_alloc(loc);
> +
> +	if (nft_rule_expr_is_set(nle, NFT_EXPR_REDIR_FLAGS)) {
> +		flags = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_FLAGS);
> +		stmt->redir.flags = flags;
> +	}
> +
> +	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_REG_PROTO_MIN);
> +	if (reg1) {
> +		proto = netlink_get_register(ctx, loc, reg1);
> +		if (proto == NULL)
> +			return netlink_error(ctx, loc,
> +					     "REDIRECT statement has no proto "
> +					     "expression");

Is this error similar to other errors that we already have in the
code? We should try to report them consistently.

