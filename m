Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59367C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 12:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1407F229F3
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 12:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="nMFUqlwV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfGYMWI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 08:22:08 -0400
Received: from mx1.riseup.net ([198.252.153.129]:37438 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfGYMWI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 08:22:08 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id A2A911A1234;
        Thu, 25 Jul 2019 05:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1564057327; bh=3cdKi1uW77RTb4WkvZl+TM60Y6O7Fo2Y+HJRe6PIDIs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=nMFUqlwVIy2787z3y5acbTggxVqIHQUrwL3GDGDNnvoODqlDp8Ol3kzRa/BppCW3Y
         6tbUgwe42TCwkG11Nwz3tGmWXffocvnMCl0XYlMlSdEGqxQeouAylN0EGEmO1HGT/J
         WwmmJdRZRwBoDP+3J4JJQn5ifLWtUPUbJSmaTTUk=
X-Riseup-User-ID: B8CED900D8A94BA524B106686013AFB393944BF129C0919BAB5B6FBE0A0D3026
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 0A6E212051B;
        Thu, 25 Jul 2019 05:22:06 -0700 (PDT)
Subject: Re: [PATCH 1/2 nft] src: allow variables in the chain priority
 specification
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190722160236.12516-1-ffmancera@riseup.net>
 <20190722160236.12516-2-ffmancera@riseup.net>
 <20190725103934.r4lv3bjn5j5fnbuz@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <d5500a5d-f10b-1068-b677-90b8a6ddc14e@riseup.net>
Date:   Thu, 25 Jul 2019 14:22:19 +0200
MIME-Version: 1.0
In-Reply-To: <20190725103934.r4lv3bjn5j5fnbuz@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo, I have a few comments below.

On 7/25/19 12:39 PM, Pablo Neira Ayuso wrote:
> On Mon, Jul 22, 2019 at 06:02:37PM +0200, Fernando Fernandez Mancera wrote:
>> diff --git a/include/rule.h b/include/rule.h
>> index 67c3d33..c6e8716 100644
> [...]
>> +const struct datatype priority_type = {
> 
> Please, add here something like on top of the definition:
> 
> /* This datatype is not registered via datatype_register()
>  * since this datatype should not ever be used from either
>  * rules or elements.
>  */
> 
> or alike, so we don't forget that missing datatype_register() is not a
> bug.
> 
> [...]
>> --- a/include/rule.h
>> +++ b/include/rule.h
>> @@ -174,13 +174,13 @@ enum chain_flags {
>>   * struct prio_spec - extendend priority specification for mixed
>>   *                    textual/numerical parsing.
>>   *
>> - * @str:  name of the standard priority value
>> - * @num:  Numerical value. This MUST contain the parsed value of str after
>> + * @expr:  expr of the standard priority value
>> + * @num:  Numerical value. This MUST contain the parsed value of expr after
>>   *        evaluation.
> 
> There must be a way to avoid this num field.
> 

I have been thinking about that for a while. Right now it is needed
because we are supporting the following priorities:

0 /* only numbers */
filter /* only string */
filter + 10 /* combination of a string plus a number */
filter - 10 /* combination of a string minus a number */

The proposed design will allow us to continue supporting that. Having
said that, the only way to get rid of this num field is to parse the
string in parsing time and then store the resulting number as a symbol
expression in my opinion. Maybe I am missing something here. Have you
any idea? Thanks!



>>   */
>>  struct prio_spec {
>> -	const char  *str;
>> -	int          num;
>> +	struct expr	*expr;
>> +	int		num;
>>  	struct location loc;
>>  };
>>  
>> diff --git a/src/datatype.c b/src/datatype.c
>> index 6d6826e..b7418e7 100644
>> --- a/src/datatype.c
>> +++ b/src/datatype.c
>> @@ -1246,3 +1246,29 @@ const struct datatype boolean_type = {
>>  	.sym_tbl	= &boolean_tbl,
>>  	.json		= boolean_type_json,
>>  };
>> +
>> +static struct error_record *priority_type_parse(const struct expr *sym,
>> +						struct expr **res)
>> +{
>> +	int num;
>> +
>> +	if (isdigit(sym->identifier[0])) {
>> +		num = atoi(sym->identifier);
>> +		*res = constant_expr_alloc(&sym->location, &integer_type,
>> +					   BYTEORDER_HOST_ENDIAN,
>> +					   sizeof(int) * BITS_PER_BYTE,
>> +					   &num);
>> +	} else
>> +		*res = constant_expr_alloc(&sym->location, &string_type,
>> +					   BYTEORDER_HOST_ENDIAN,
>> +					   strlen(sym->identifier) *
>> +					   BITS_PER_BYTE, sym->identifier);
> 
> I'd suggest you call integer_datatype_parse() first, check if erec ==
> NULL, then all good, this is an integer. Otherwise, release erec
> object and parse this as a string via string_datatype_parse().
> >> +	return NULL;
>> +}
>> +
>> +const struct datatype priority_type = {
>> +	.type		= TYPE_STRING,
>> +	.name		= "priority",
>> +	.desc		= "priority type",
>> +	.parse		= priority_type_parse,
>> +};
>> diff --git a/src/evaluate.c b/src/evaluate.c
>> old mode 100644
>> new mode 100755
>> index 69b853f..d2faee8
>> --- a/src/evaluate.c
>> +++ b/src/evaluate.c
>> @@ -3193,15 +3193,36 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>>  	return 0;
>>  }
>>  
>> -static bool evaluate_priority(struct prio_spec *prio, int family, int hook)
>> +static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
>> +			      int family, int hook)
>>  {
>>  	int priority;
>> +	char prio_str[NFT_NAME_MAXLEN];
>>  
>>  	/* A numeric value has been used to specify priority. */
>> -	if (prio->str == NULL)
>> +	if (prio->expr == NULL)
> 
> If we always use an expression, as described below, this won't be
> needed.
> 
>>  		return true;
>>  
>> -	priority = std_prio_lookup(prio->str, family, hook);
>> +	ctx->ectx.dtype = &priority_type;
>> +	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
>> +	if (expr_evaluate(ctx, &prio->expr) < 0)
>> +		return false;
>> +	if (prio->expr->etype != EXPR_VALUE) {
>> +		expr_error(ctx->msgs, prio->expr, "%s is not a valid "
>> +			   "priority expression", expr_name(prio->expr));
>> +		return false;
>> +	}
>> +
>> +	if (prio->expr->dtype->type == TYPE_INTEGER) {
>> +		mpz_export_data(&prio->num, prio->expr->value,
>> +				BYTEORDER_HOST_ENDIAN, sizeof(int));
>> +		return true;
>> +	}
>> +	mpz_export_data(prio_str, prio->expr->value,
> 
> If you use symbol expression, as I describe below. You don't need to
> convert this constant expression back to string again. You can just
> use the symbol identify sym->identifier.
> 
>> +			BYTEORDER_HOST_ENDIAN,
>> +			NFT_NAME_MAXLEN);
>> +
>> +	priority = std_prio_lookup(prio_str, family, hook);
>>  	if (priority == NF_IP_PRI_LAST)
>>  		return false;
>>  	prio->num += priority;
>> @@ -3223,10 +3244,10 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
>>  	if (ft->hooknum == NF_INET_NUMHOOKS)
>>  		return chain_error(ctx, ft, "invalid hook %s", ft->hookstr);
>>  
>> -	if (!evaluate_priority(&ft->priority, NFPROTO_NETDEV, ft->hooknum))
>> +	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hooknum))
>>  		return __stmt_binary_error(ctx, &ft->priority.loc, NULL,
>> -					   "'%s' is invalid priority.",
>> -					   ft->priority.str);
>> +					   "invalid priority expression %s.",
>> +					   expr_name(ft->priority.expr));
>>  
>>  	if (!ft->dev_expr)
>>  		return chain_error(ctx, ft, "Unbound flowtable not allowed (must specify devices)");
>> @@ -3422,11 +3443,11 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
>>  			return chain_error(ctx, chain, "invalid hook %s",
>>  					   chain->hookstr);
>>  
>> -		if (!evaluate_priority(&chain->priority, chain->handle.family,
>> -				       chain->hooknum))
>> +		if (!evaluate_priority(ctx, &chain->priority,
>> +				       chain->handle.family, chain->hooknum))
>>  			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
>> -						   "'%s' is invalid priority in this context.",
>> -						   chain->priority.str);
>> +						   "invalid priority expression %s in this context.",
>> +						   expr_name(chain->priority.expr));
>>  	}
>>  
>>  	list_for_each_entry(rule, &chain->rules, list) {
>> diff --git a/src/parser_bison.y b/src/parser_bison.y
>> index 53e6695..ed7bd89 100644
>> --- a/src/parser_bison.y
>> +++ b/src/parser_bison.y
>> @@ -636,8 +636,8 @@ int nft_lex(void *, void *, void *);
>>  %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
>>  %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
>>  
>> -%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr
>> -%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr
>> +%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
>> +%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
>>  %type <expr>			primary_expr shift_expr and_expr
>>  %destructor { expr_free($$); }	primary_expr shift_expr and_expr
>>  %type <expr>			exclusive_or_expr inclusive_or_expr
>> @@ -1969,30 +1969,44 @@ extended_prio_name	:	OUT
>>  			|	STRING
>>  			;
>>  
>> +prio_expr		:	variable_expr
>> +			{
>> +				datatype_set($1->sym->expr, &priority_type);
> 
> Can you use symbol_expr_alloc() here, both for variable_expr and
> extended_prio_name.
> 
> Then, from the evaluation phase you can turn this symbol expression
> into a constant using the priority_type_parse() function.
> > I think this will allow you to skip the num field in prio_spec.

Do you mean to store "filter + 10" in the symbol and parse the string
manually using priority_type_parse() function? Thanks and sorry if I am
making a big mess out of this.

> Thanks!
> 
