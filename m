From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v4 2/3] src: expose delinearize/linearize structures
 and stmt_error()
Date: Sat, 9 Jul 2016 13:40:40 +0200
Message-ID: <20160709114040.GC1357@salvia>
References: <20160709102454.2978-1-pablombg@gmail.com>
 <20160709102454.2978-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45632 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbcGILkp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2016 07:40:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 959F1C9EC8
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:40:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8772FADF2
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:40:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D05F6449F
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2016 13:40:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160709102454.2978-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 09, 2016 at 12:24:53PM +0200, Pablo M. Bermudo Garay wrote:
> diff --git a/src/evaluate.c b/src/evaluate.c
> index f24e5f3..1a02ecd 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -37,40 +37,18 @@ static const char *byteorder_names[] = {
>  	[BYTEORDER_BIG_ENDIAN]		= "big endian",
>  };
>  
> -static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
> -						 const struct location *l1,
> -						 const struct location *l2,
> -						 const char *fmt, ...)
> -{
> -	struct error_record *erec;
> -	va_list ap;
> -
> -	va_start(ap, fmt);
> -	erec = erec_vcreate(EREC_ERROR, l1, fmt, ap);
> -	if (l2 != NULL)
> -		erec_add_location(erec, l2);
> -	va_end(ap);
> -	erec_queue(erec, ctx->msgs);
> -	return -1;
> -
> -}
> -
> -#define stmt_error(ctx, s1, fmt, args...) \
> -	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
> -#define stmt_binary_error(ctx, s1, s2, fmt, args...) \
> -	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
>  #define chain_error(ctx, s1, fmt, args...) \
> -	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
> +	__binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
>  #define monitor_error(ctx, s1, fmt, args...) \
> -	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
> +	__binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
>  #define cmd_error(ctx, fmt, args...) \
> -	__stmt_binary_error(ctx, &(ctx->cmd)->location, NULL, fmt, ## args)
> +	__binary_error(ctx, &(ctx->cmd)->location, NULL, fmt, ## args)
>  #define handle_error(ctx, fmt, args...) \
> -	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, NULL, fmt, ## args)
> +	__binary_error(ctx, &ctx->cmd->handle.handle.location, NULL, fmt, ## args)
>  #define position_error(ctx, fmt, args...) \
> -	__stmt_binary_error(ctx, &ctx->cmd->handle.position.location, NULL, fmt, ## args)
> +	__binary_error(ctx, &ctx->cmd->handle.position.location, NULL, fmt, ## args)
>  #define handle_position_error(ctx, fmt, args...) \
> -	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, &ctx->cmd->handle.position.location, fmt, ## args)
> +	__binary_error(ctx, &ctx->cmd->handle.handle.location, &ctx->cmd->handle.position.location, fmt, ## args)
>  
>  static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
>  				       const struct set *set,

I think this rename from __stmt_binary_error() to __binary_error()
should come as a separated patch.
