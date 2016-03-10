From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 4/4 v3] nftables: rule: Change the field "rule->comment"
 for an nftnl_udata_buf MIME-Version: 1.0
Date: Thu, 10 Mar 2016 22:36:16 +0100
Message-ID: <56E1E8D0.3040106@riseup.net>
References: <1457370643-14408-1-git-send-email-carlosfg@riseup.net>
 <1457370643-14408-2-git-send-email-carlosfg@riseup.net>
 <20160308131351.GC5125@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:44722 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbcCJVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 16:36:20 -0500
In-Reply-To: <20160308131351.GC5125@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the feedback;

On 08/03/16 14:13, Pablo Neira Ayuso wrote:
> On Mon, Mar 07, 2016 at 06:10:41PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>> diff --git a/src/parser_bison.y b/src/parser_bison.y
>> index 05ade0f..ed1b63a 100644
>> --- a/src/parser_bison.y
>> +++ b/src/parser_bison.y
>> @@ -24,6 +24,7 @@
>>   #include <netinet/icmp6.h>
>>   #include <libnftnl/common.h>
>>   #include <libnftnl/set.h>
>> +#include <libnftnl/attr.h>
>>
>>   #include <rule.h>
>>   #include <statement.h>
>> @@ -1304,7 +1305,19 @@ rule			:	stmt_list	comment_spec
>>   				struct stmt *i;
>>
>>   				$$ =3D rule_alloc(&@$, NULL);
>> -				$$->comment =3D $2;
>> +
>> +				if ($2) {
>> +					if (!($$->udata =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN)))
>> +						memory_allocation_error();
>> +
>> +					if (!nftnl_udata_put_strz($$->udata,
>> +						UDATA_TYPE_COMMENT, $2)) {
>
> Mind coding style:
> 					if (!nftnl_udata_put_strz($$->udata,
>                                                                    DA=
TA_TYPE_COMMENT, $2)) {
>
> You have to align the parameters to the parens.
>

I will put it in a single line because it exceeds 80 columns anyway. Is=
=20
it better?

>> diff --git a/src/rule.c b/src/rule.c
>> index 18ff592..60d9b38 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -23,6 +23,7 @@
>>
>>   #include <libnftnl/common.h>
>>   #include <libnftnl/ruleset.h>
>> +#include <libnftnl/udata.h>
>>   #include <netinet/ip.h>
>>   #include <linux/netfilter.h>
>>   #include <linux/netfilter_arp.h>
>> @@ -366,6 +367,7 @@ struct rule *rule_alloc(const struct location *l=
oc, const struct handle *h)
>>   	rule->location =3D *loc;
>>   	init_list_head(&rule->list);
>>   	init_list_head(&rule->stmts);
>> +	rule->udata =3D NULL;
>
> No need to set this to null. IIRC the rule object is already allocate=
d
> in an already initialized memory area, right?

Yes, I'll remove this.

>> @@ -375,21 +377,54 @@ void rule_free(struct rule *rule)
>>   {
>>   	stmt_list_free(&rule->stmts);
>>   	handle_free(&rule->handle);
>> -	xfree(rule->comment);
>> +	nftnl_udata_free(rule->udata);
>>   	xfree(rule);
>>   }
>>
>> +static int rule_parse_userdata_cb(const struct nftnl_udata *attr,
>> +				  void *data)
>> +{
>> +	const struct nftnl_udata **tb =3D data;
>> +	uint8_t type =3D nftnl_udata_attr_type(attr);
>> +	uint8_t len =3D nftnl_udata_attr_len(attr);
>> +	unsigned char *value =3D nftnl_udata_attr_value(attr);
>
> It is prefered to define variables in this way:
>
> 	unsigned char *value =3D nftnl_udata_attr_value(attr);
> 	uint8_t type =3D nftnl_udata_attr_type(attr);
> 	uint8_t len =3D nftnl_udata_attr_len(attr);
> 	const struct nftnl_udata **tb =3D data;
>
> ie. longest line first. It's easier to read the code in this way.
>

I'll change it in this function and in other places too.

>> +
>> +	/* Validation */
>
> Remove this comment, it's obvious what this is doing ;-)
>

Done.

>> +	switch (type) {
>> +	case UDATA_TYPE_COMMENT:
>> +		if (value[len-1] !=3D '\0')
>> +			return NFTNL_CB_ERROR;
>
> You can remove the NFTNL_CB_* definitions.
>
> I know you're based on libmnl, but in this case I think it's fine to
> return the values.
>

Ok.

>> +		break;
>> +	default:
>> +		break;
>> +	};
>> +
>> +	tb[type] =3D attr;
>> +	return NFTNL_CB_OK;
>> +}
>> +
>> +
>>   void rule_print(const struct rule *rule)
>>   {
>>   	const struct stmt *stmt;
>> +	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
>> +	const struct nftnl_udata *attr;
>>
>>   	list_for_each_entry(stmt, &rule->stmts, list) {
>>   		stmt->ops->print(stmt);
>>   		printf(" ");
>>   	}
>>
>> -	if (rule->comment)
>> -		printf("comment \"%s\" ", rule->comment);
>> +	if (rule->udata) {
>> +		if (nftnl_udata_parse(rule->udata, rule_parse_userdata_cb, tb)
>> +			!=3D NFTNL_CB_ERROR
>> +		) {
>                  ^^^
>
> This coding style is not correct.
>
>> +			attr =3D tb[UDATA_TYPE_COMMENT];
>> +			if (attr)
>
> You can do this instead:
>
>                          if (tb[UDATA_TYPE_COMMENT]) {
>                                  printf("comment \"%s\" ",
>                                          (char *)nftnl_udata_attr_val=
ue(tb[UDATA_TYPE_COMMENT]));
>

When I'm appling these corrections, I've realized the code is not very=20
readable and it has too many indentation levels. So I create an=20
auxiliary function to print user data. What do you think about this?


static void rule_print_udata(const struct nftnl_udata *tb[], uint8_t ty=
pe)
{
	if (!tb[type])
		return;

	switch(type) {
	case UDATA_TYPE_COMMENT:
		printf("comment \"%s\" ",
		       (char *)nftnl_udata_attr_value(tb[type]));
		break;
	default:
		break;
	}
}

void rule_print(const struct rule *rule)
{
	const struct stmt *stmt;
	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};

	list_for_each_entry(stmt, &rule->stmts, list) {
		stmt->ops->print(stmt);
		printf(" ");
	}

	if (rule->udata) {
		if (nftnl_udata_parse(rule->udata, rule_parse_udata_cb, tb) > 0)
			rule_print_udata(tb, UDATA_TYPE_COMMENT);
	}

	if (handle_output > 0)
		printf("# handle %" PRIu64, rule->handle.handle);
}
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
