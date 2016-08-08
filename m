From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 2/4, libnfntl] Implement rule comparison
Date: Mon, 8 Aug 2016 13:49:09 +0200
Message-ID: <05d3e122-0950-2c75-47a3-b823a4d71b44@riseup.net>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808111758.4062-2-carlosfg@riseup.net> <20160808113239.GB11574@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:57302 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbcHHLtM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 07:49:12 -0400
In-Reply-To: <20160808113239.GB11574@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/08/2016 01:32 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 08, 2016 at 01:17:56PM +0200, Carlos Falgueras García wrote:
>> diff --git a/src/expr/dynset.c b/src/expr/dynset.c
>> index 0eaa409..fa8b8d5 100644
>> --- a/src/expr/dynset.c
>> +++ b/src/expr/dynset.c
>> @@ -370,6 +370,23 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
>>  	xfree(dynset->set_name);
>>  }
>>
>> +static bool nftnl_expr_dynset_cmp(const struct nftnl_expr *e1,
>> +				  const struct nftnl_expr *e2)
>> +{
>> +	struct nftnl_expr_dynset *d1, *d2;
>> +
>> +	d1 = nftnl_expr_data(e1);
>> +	d2 = nftnl_expr_data(e2);
>
> Probably this?
>
>         struct nftnl_expr_dynset *d1 = nftnl_expr_data(e1);
>         struct nftnl_expr_dynset *d2 = nftnl_expr_data(e2);
>

Ok.

>>  struct expr_ops expr_ops_immediate = {
>>  	.name		= "immediate",
>>  	.alloc_len	= sizeof(struct nftnl_expr_immediate),
>> @@ -332,4 +350,5 @@ struct expr_ops expr_ops_immediate = {
>>  	.snprintf	= nftnl_expr_immediate_snprintf,
>>  	.xml_parse	= nftnl_expr_immediate_xml_parse,
>>  	.json_parse	= nftnl_expr_immediate_json_parse,
>> +	.cmp		= nftnl_expr_immediate_cmp,
>
> Please, place this after free() as in the structure definition for
> consistency.
>

Ok.

>> diff --git a/src/libnftnl.map b/src/libnftnl.map
>> index c38e081..748a2c6 100644
>> --- a/src/libnftnl.map
>> +++ b/src/libnftnl.map
>> @@ -528,3 +528,8 @@ LIBNFTNL_4.1 {
>>  	nftnl_udata_next;
>>  	nftnl_udata_parse;
>>  } LIBNFTNL_4;
>> +
>> +LIBNFTNL_4.2 {
>> +	nftnl_rule_cmp;
>> +	nftnl_expr_cmp;
>> +} LIBNFTNL_4;
>
> This should be LIBNFTNL_4.1 instead.
>

Ok.

>> diff --git a/src/rule.c b/src/rule.c
>> index 0cfddf2..27e753b 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -331,6 +331,36 @@ void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr)
>>  }
>>  EXPORT_SYMBOL_ALIAS(nftnl_rule_add_expr, nft_rule_add_expr);
>>
>> +bool nftnl_rule_cmp(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
>> +{
>> +	unsigned int eq = 1;
>> +	struct nftnl_expr *e1, *e2;
>> +	struct nftnl_expr_iter it1, it2;
>
> Just a comestic comment, we usually prefer this:
>
> 	struct nftnl_expr_iter it1, it2;
> 	struct nftnl_expr *e1, *e2;
> 	unsigned int eq = 1;
>
> So larger lines in variable declarations go first, if there are no
> dependencies of course.
>

I'll check all of them.

>> +	if (r1->flags & r1->flags & (1 << NFTNL_RULE_TABLE))
>> +		eq &= !strcmp(r1->table, r2->table);
>> +	if (r1->flags & r1->flags & (1 << NFTNL_RULE_CHAIN))
>> +		eq &= !strcmp(r1->chain, r2->chain);
>> +	if (r1->flags & r1->flags & (1 << NFTNL_RULE_COMPAT_FLAGS))
>> +		eq &= r1->compat.flags == r2->compat.flags;
>> +	if (r1->flags & r1->flags & (1 << NFTNL_RULE_COMPAT_PROTO))
>> +		eq &= r1->compat.proto == r2->compat.proto;
>> +
>> +	nftnl_expr_iter_init(r1, &it1);
>> +	nftnl_expr_iter_init(r2, &it2);
>> +	e1 = nftnl_expr_iter_next(&it1);
>> +	e2 = nftnl_expr_iter_next(&it2);
>> +	while (eq && e1 && e2) {
>> +		eq = nftnl_expr_cmp(e1, e2);
>> +
>> +		e1 = nftnl_expr_iter_next(&it1);
>> +		e2 = nftnl_expr_iter_next(&it2);
>> +	}
>
> Probably you can use:
>
>         do {
>                 ...
>         while (...);
>
> to simplify this?

I think it is not possible, 'nftnl_expr_iter_next' can return NULL at 
first if there is no expressions, so this structure could call 
'nftnl_expr_cmp' with NULL pointers:

	do {
		e1 = nftnl_expr_iter_next(&it1);
		e2 = nftnl_expr_iter_next(&it2);
		eq = nftnl_expr_cmp(e1, e2);
	} while (eq && e1 && e2);
