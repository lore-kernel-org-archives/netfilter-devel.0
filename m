From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2 nft RFC] expression: default to print binary
 operations using nominal representation
Date: Wed, 15 Jan 2014 11:18:04 +0000
Message-ID: <20140115111803.GA17728@macbook.localnet>
References: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43738 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaAOLSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:18:08 -0500
Content-Disposition: inline
In-Reply-To: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 12:09:26PM +0100, Pablo Neira Ayuso wrote:
> Since b59e65c ("scanner: add aliases to symbols for easier
> interaction with most shells") we have nominal aliases, default to
> these for the output representation.

I was thinking about this before, but didn't mention it since you
hadn't included it in your first patch. I'd prefer to stick to the
IMO more readable existing form. Since we don't support deleting
rules by rule specification, there should be no reason to copy and
paste the output to the command line again.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/expression.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/src/expression.c b/src/expression.c
> index 71154cc..6da5c10 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -351,17 +351,17 @@ const char *expr_op_symbols[] = {
>  	[OP_INVALID]	= "invalid",
>  	[OP_HTON]	= "hton",
>  	[OP_NTOH]	= "ntoh",
> -	[OP_AND]	= "&",
> -	[OP_OR]		= "|",
> -	[OP_XOR]	= "^",
> -	[OP_LSHIFT]	= "<<",
> -	[OP_RSHIFT]	= ">>",
> +	[OP_AND]	= "and",
> +	[OP_OR]		= "or",
> +	[OP_XOR]	= "xor",
> +	[OP_LSHIFT]	= "lshift",
> +	[OP_RSHIFT]	= "rshift",
>  	[OP_EQ]		= NULL,
> -	[OP_NEQ]	= "!=",
> -	[OP_LT]		= "<",
> -	[OP_GT]		= ">",
> -	[OP_LTE]	= "<=",
> -	[OP_GTE]	= ">=",
> +	[OP_NEQ]	= "ne",
> +	[OP_LT]		= "lt",
> +	[OP_GT]		= "gt",
> +	[OP_LTE]	= "le",
> +	[OP_GTE]	= "ge",
>  	[OP_RANGE]	= "within range",
>  	[OP_LOOKUP]	= NULL,
>  };
> -- 
> 1.7.10.4
