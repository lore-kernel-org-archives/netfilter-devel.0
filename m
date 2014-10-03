From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] src: add masquerade support
Date: Fri, 3 Oct 2014 15:10:25 +0200
Message-ID: <20141003131025.GA31587@salvia>
References: <20141003124641.9409.9789.stgit@nfdev.cica.es>
 <20141003124646.9409.50292.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34965 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaJCNJW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:09:22 -0400
Content-Disposition: inline
In-Reply-To: <20141003124646.9409.50292.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 03, 2014 at 02:46:46PM +0200, Arturo Borrero Gonzalez wrote:
> +
>  struct queue_stmt {
>  	struct expr		*queue;
>  	uint16_t		flags;
> @@ -100,6 +106,7 @@ extern struct stmt *ct_stmt_alloc(const struct location *loc,
>   * @STMT_LOG:		log statement
>   * @STMT_REJECT:	REJECT statement
>   * @STMT_NAT:		NAT statement
> + * @STMT_NAT:		masquerade statement
       ^
      typo

>   * @STMT_QUEUE:		QUEUE statement
>   * @STMT_CT:		conntrack statement
>   */
> @@ -113,6 +120,7 @@ enum stmt_types {
>  	STMT_LOG,
>  	STMT_REJECT,
>  	STMT_NAT,
> +	STMT_MASQ,
>  	STMT_QUEUE,
>  	STMT_CT,
>  };
> @@ -160,6 +168,7 @@ struct stmt {
>  		struct limit_stmt	limit;
>  		struct reject_stmt	reject;
>  		struct nat_stmt		nat;
> +		struct masq_stmt	masq;
>  		struct queue_stmt	queue;
>  		struct ct_stmt		ct;
>  	};
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 284ee72..0afbe8d 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1171,6 +1171,21 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
>  	return 0;
>  }
>  
> +static int stmt_evaluate_masq(struct eval_ctx *ctx, struct stmt *stmt)
> +{
> +	struct proto_ctx *pctx = &ctx->pctx;
> +
> +	if (pctx && (pctx->family == AF_INET))
> +		expr_set_context(&ctx->ectx, &ipaddr_type,
> +				4 * BITS_PER_BYTE);
> +	else
> +		expr_set_context(&ctx->ectx, &ip6addr_type,
> +				 16 * BITS_PER_BYTE);

Could you use a switch to check pctx->family?

Spot an error for unsupported family, so we don't crash badly if
someone tries to use this from a different context.

> +	stmt->flags |= STMT_F_TERMINAL;
> +	return 0;
> +}
> +
