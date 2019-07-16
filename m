Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE172C76192
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5F3206C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 18:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbfGPSGw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 14:06:52 -0400
Received: from mail.us.es ([193.147.175.20]:51934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfGPSGw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 14:06:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ADF40C04A5
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 20:06:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C1291150B9
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 20:06:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91C061150CB; Tue, 16 Jul 2019 20:06:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80E99D190F;
        Tue, 16 Jul 2019 20:06:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 20:06:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5F6EA4265A32;
        Tue, 16 Jul 2019 20:06:47 +0200 (CEST)
Date:   Tue, 16 Jul 2019 20:06:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 nft WIP] src: introduce prio_expr in chain priority
Message-ID: <20190716180646.ajihkibvox4nkd2c@salvia>
References: <20190716090812.873-1-ffmancera@riseup.net>
 <20190716090812.873-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716090812.873-2-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 16, 2019 at 11:08:12AM +0200, Fernando Fernandez Mancera wrote:
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/rule.h     |  8 ++++----
>  src/evaluate.c     | 29 +++++++++++++++++++----------
>  src/parser_bison.y | 25 +++++++++++++++++--------
>  src/rule.c         |  4 ++--
>  4 files changed, 42 insertions(+), 24 deletions(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index aefb24d..4d7cec8 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -173,13 +173,13 @@ enum chain_flags {
>   * struct prio_spec - extendend priority specification for mixed
>   *                    textual/numerical parsing.
>   *
> - * @str:  name of the standard priority value
> - * @num:  Numerical value. This MUST contain the parsed value of str after
> + * @prio_expr:  expr of the standard priority value
> + * @num:  Numerical value. This MUST contain the parsed value of prio_expr after
>   *        evaluation.
>   */
>  struct prio_spec {
> -	const char  *str;
> -	int          num;
> +	struct expr	*prio_expr;

Use:

        struct expr     *expr;

instead.

> +	int		num;

You could just store this in the expression, no need for this num
field.

>  	struct location loc;
>  };
>  
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8086f75..cee65cd 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3181,15 +3181,24 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>  	return 0;
>  }
>  
> -static bool evaluate_priority(struct prio_spec *prio, int family, int hook)
> +static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
> +			      int family, int hook)
>  {
>  	int priority;
> +	char prio_str[NFT_NAME_MAXLEN];
>  
>  	/* A numeric value has been used to specify priority. */
> -	if (prio->str == NULL)
> +	if (prio->prio_expr == NULL)

prio_expr == NULL never happens.

>  		return true;
>  
> -	priority = std_prio_lookup(prio->str, family, hook);
> +	if (expr_evaluate(ctx, &prio->prio_expr) < 0)
> +		return false;
> +	if (prio->prio_expr->etype == EXPR_VALUE)

You should bail out here with expr_error() is this is not an EXPR_VALUE.

> +		mpz_export_data(prio_str, prio->prio_expr->value,
> +				BYTEORDER_HOST_ENDIAN,
> +				NFT_NAME_MAXLEN);

Remove the branch above, expr_evalute() already deals with
transforming the symbol to value expression.

> +
> +	priority = std_prio_lookup(prio_str, family, hook);
>  	if (priority == NF_IP_PRI_LAST)
>  		return false;
>  	prio->num += priority;
> @@ -3211,10 +3220,10 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
>  	if (ft->hooknum == NF_INET_NUMHOOKS)
>  		return chain_error(ctx, ft, "invalid hook %s", ft->hookstr);
>  
> -	if (!evaluate_priority(&ft->priority, NFPROTO_NETDEV, ft->hooknum))
> +	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hooknum))
>  		return __stmt_binary_error(ctx, &ft->priority.loc, NULL,

Better use expr_error() here?

> -					   "'%s' is invalid priority.",
> -					   ft->priority.str);
> +					   "invalid priority expression %s.",

> +					   expr_name(ft->priority.prio_expr));
>  
>  	if (!ft->dev_expr)
>  		return chain_error(ctx, ft, "Unbound flowtable not allowed (must specify devices)");
> @@ -3410,11 +3419,11 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
>  			return chain_error(ctx, chain, "invalid hook %s",
>  					   chain->hookstr);
>  
> -		if (!evaluate_priority(&chain->priority, chain->handle.family,
> -				       chain->hooknum))
> +		if (!evaluate_priority(ctx, &chain->priority,
> +				       chain->handle.family, chain->hooknum))
>  			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
> -						   "'%s' is invalid priority in this context.",
> -						   chain->priority.str);
> +						   "invalid priority expression %s in this context.",
> +						   expr_name(chain->priority.prio_expr));
>  	}
>  
>  	list_for_each_entry(rule, &chain->rules, list) {
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index a4905f2..c6a43cf 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -626,8 +626,8 @@ int nft_lex(void *, void *, void *);
>  %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
>  %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
>  
> -%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr
> -%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr
> +%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
> +%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
>  %type <expr>			primary_expr shift_expr and_expr
>  %destructor { expr_free($$); }	primary_expr shift_expr and_expr
>  %type <expr>			exclusive_or_expr inclusive_or_expr
> @@ -1926,30 +1926,39 @@ extended_prio_name	:	OUT
>  			|	STRING
>  			;
>  
> +prio_expr		:	extended_prio_name
> +			{
> +				$$ = constant_expr_alloc(&@$, &string_type,
> +							 BYTEORDER_HOST_ENDIAN,
> +							 NFT_NAME_MAXLEN *

this should be strlen($1) * BITS_PER_BYTE

> +							 BITS_PER_BYTE, $1);
> +			}
> +			;
