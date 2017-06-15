From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] src: Pass stateless, numeric, ip2name and handle
 variables as structure members.
Date: Thu, 15 Jun 2017 21:34:48 +0200
Message-ID: <20170615193448.GA25403@salvia>
References: <5942c2bd.ca40620a.63e1d.3001@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbdFOTe6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2017 15:34:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27400DFF05
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 21:34:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 178F0FF6E1
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 21:34:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 626E4A6B3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2017 21:34:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5942c2bd.ca40620a.63e1d.3001@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Varsha,

Almost there, comments below.

On Thu, Jun 15, 2017 at 10:54:06PM +0530, Varsha Rao wrote:
> diff --git a/src/cli.c b/src/cli.c
> index a74411a..777b300 100644
> --- a/src/cli.c
> +++ b/src/cli.c
> @@ -39,6 +39,7 @@ static const struct input_descriptor indesc_cli = {
>  };
>  
>  static struct parser_state *state;
> +struct output_ctx octx;

Hm. I see...

We have to set this dummy to what we get from main.c, ie.

        dummy_octx = *octx;

somewhere in the code, so nft -i regards all options that has been
passed.

>  static void *scanner;
>  
>  static char histfile[PATH_MAX];
> @@ -129,7 +130,7 @@ static void cli_complete(char *line)
>  
>  	parser_init(state, &msgs);
>  	scanner_push_buffer(scanner, &indesc_cli, line);
> -	nft_run(scanner, state, &msgs);
> +	nft_run(scanner, state, &msgs, &octx);
>  	erec_print_list(stdout, &msgs);
>  	xfree(line);
>  	cache_release();
[...]
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 311c86c..ef7075b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -30,7 +30,8 @@
>  #include <utils.h>
>  #include <xt.h>
>  
> -static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
> +static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr,
> +			  struct output_ctx *octx);

Why do we need this in evaluate?

>  static const char *byteorder_names[] = {
>  	[BYTEORDER_INVALID]		= "invalid",
> @@ -130,7 +131,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
>  	else {
>  		op = byteorder_conversion_op(*expr, byteorder);
>  		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
> -		if (expr_evaluate(ctx, expr) < 0)
> +		if (expr_evaluate(ctx, expr, NULL) < 0)

This is all NULL. I guess this has to be with debug?

In such case, you can define a:

        static struct output_ctx octx_debug_dummy;

And use it from code under #ifdef DEBUG.

>  			return -1;
>  	}
>  	return 0;
