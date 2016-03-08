From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 3/3 v2] nftables: rule: Change the field "rule->comment"
 for an nftnl_attrbuf.
Date: Tue, 8 Mar 2016 10:58:19 +0100
Message-ID: <56DEA23B.80302@riseup.net>
References: <1456763140-15121-1-git-send-email-carlosfg@riseup.net>
 <1456763140-15121-3-git-send-email-carlosfg@riseup.net>
 <20160302183744.GB1351@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:58547 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbcCHJ6Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 04:58:24 -0500
In-Reply-To: <20160302183744.GB1351@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/03/16 19:37, Pablo Neira Ayuso wrote:
> On Mon, Feb 29, 2016 at 05:25:40PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>> diff --git a/src/rule.c b/src/rule.c
>> index 18ff592..499fa7b 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -23,6 +23,7 @@
>>
>>   #include <libnftnl/common.h>
>>   #include <libnftnl/ruleset.h>
>> +#include <libnftnl/attr.h>
>>   #include <netinet/ip.h>
>>   #include <linux/netfilter.h>
>>   #include <linux/netfilter_arp.h>
>> @@ -366,6 +367,7 @@ struct rule *rule_alloc(const struct location *l=
oc, const struct handle *h)
>>   	rule->location =3D *loc;
>>   	init_list_head(&rule->list);
>>   	init_list_head(&rule->stmts);
>> +	rule->udata =3D NULL;
>>   	if (h !=3D NULL)
>>   		rule->handle =3D *h;
>>   	return rule;
>> @@ -375,21 +377,53 @@ void rule_free(struct rule *rule)
>>   {
>>   	stmt_list_free(&rule->stmts);
>>   	handle_free(&rule->handle);
>> -	xfree(rule->comment);
>> +	nftnl_attrbuf_free(rule->udata);
>
> I would rename this function to:
>
>          nftnl_udata_free();
>
> So all functions that now refer to nftnl_attrbuf_* look like:
>
>          nftnl_udata_*()
>
> then, to push/retrieve attributes, I would use the prefix:
>
>          nftnl_udata_attr_*()

I renamed all functions following these rule except=20
"nftnl_udata_attr_put" which I changed to "nftnl_udata_put" because=20
functions like "nftnl_udata_attr_put_strz" would have very long name. I=
t=20
is ok?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
