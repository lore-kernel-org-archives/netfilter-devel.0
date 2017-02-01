From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: Always print range expressions numerically
Date: Wed, 1 Feb 2017 18:58:11 +0100
Message-ID: <20170201175811.GA7276@salvia>
References: <20170130140520.GA5818@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59546 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752890AbdBAR6R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2017 12:58:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC215180190
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:58:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A0F1DA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:58:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 672F4DA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Feb 2017 18:58:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170130140520.GA5818@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 30, 2017 at 12:05:20PM -0200, Elise Lennion wrote:
> Because the rules are more legible this way. Also, the parser doesn't
> accept strings on ranges, so, printing ranges numerically better match
> the rules definition.
> 
> Fixes(Bug 1046 - mobility header with range gives illegible rule).
> 
> A new NUMERIC constant was defined to fill the previous role of
> NUMERIC_ALL, so the option -nnn doesn't affect symbolic constants.
> 
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
>  include/nftables.h |  1 +
>  src/datatype.c     | 11 +++++++----
>  src/expression.c   |  2 ++
>  src/main.c         |  3 ++-
>  src/meta.c         |  4 ++--
>  5 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/include/nftables.h b/include/nftables.h
> index 6f54155..2730f65 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -9,6 +9,7 @@ enum numeric_level {
>  	NUMERIC_NONE,
>  	NUMERIC_ADDR,
>  	NUMERIC_PORT,
> +	NUMERIC_PROTO_UGID,

Do we need this necessarily?

>  	NUMERIC_ALL,
>  };
>  
> diff --git a/src/datatype.c b/src/datatype.c
> index 1518606..f9981a6 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -175,9 +175,12 @@ void symbolic_constant_print(const struct symbol_table *tbl,
>  		return expr_basetype(expr)->print(expr);
>  
>  	if (quotes)
> -		printf("\"%s\"", s->identifier);
> -	else
> -		printf("%s", s->identifier);
> +		printf("\"");
> +
> +	numeric_output >= NUMERIC_ALL ? printf("%lu", val) : printf("%s", s->identifier);

Use if () here instead.

We usually leave this syntax to use it from return statements.

> +
> +	if (quotes)
> +		printf("\"");
>  }
>  
>  static void switch_byteorder(void *data, unsigned int len)
> @@ -530,7 +533,7 @@ static void inet_protocol_type_print(const struct expr *expr)
>  {
>  	struct protoent *p;
>  
> -	if (numeric_output < NUMERIC_ALL) {
> +	if (numeric_output < NUMERIC_PROTO_UGID) {
>  		p = getprotobynumber(mpz_get_uint8(expr->value));
>  		if (p != NULL) {
>  			printf("%s", p->p_name);
> diff --git a/src/expression.c b/src/expression.c
> index 1567870..bdbbd45 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -597,9 +597,11 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
>  
>  static void range_expr_print(const struct expr *expr)
>  {
> +	numeric_output += NUMERIC_ALL;
>  	expr_print(expr->left);
>  	printf("-");
>  	expr_print(expr->right);
> +	numeric_output -= NUMERIC_ALL;
>  }
>  
>  static void range_expr_clone(struct expr *new, const struct expr *expr)
> diff --git a/src/main.c b/src/main.c
> index 6ba752b..1b28836 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -288,7 +288,8 @@ int main(int argc, char * const *argv)
>  			include_paths[num_include_paths++] = optarg;
>  			break;
>  		case OPT_NUMERIC:
> -			numeric_output++;
> +			if (numeric_output + 1 < NUMERIC_ALL)
> +				numeric_output++;

This is catching a different problem, right? Makes sure we validate
the number of -n. I'd suggest a separated patch to this fix.

I suggest we print an error here if the number of -n is exceeded.

>  			break;
>  		case OPT_STATELESS:
>  			stateless_output++;
> diff --git a/src/meta.c b/src/meta.c
> index cb7c136..9e8a987 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -226,7 +226,7 @@ static void uid_type_print(const struct expr *expr)
>  {
>  	struct passwd *pw;
>  
> -	if (numeric_output < NUMERIC_ALL) {
> +	if (numeric_output < NUMERIC_PROTO_UGID) {
>  		uint32_t uid = mpz_get_uint32(expr->value);
>  
>  		pw = getpwuid(uid);
> @@ -278,7 +278,7 @@ static void gid_type_print(const struct expr *expr)
>  {
>  	struct group *gr;
>  
> -	if (numeric_output < NUMERIC_ALL) {
> +	if (numeric_output < NUMERIC_PROTO_UGID) {
>  		uint32_t gid = mpz_get_uint32(expr->value);
>  
>  		gr = getgrgid(gid);
> -- 
> 2.7.4
> 
