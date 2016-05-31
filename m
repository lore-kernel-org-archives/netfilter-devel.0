From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH libnfntl] Check all strdup
Date: Tue, 31 May 2016 12:07:11 +0200
Message-ID: <afd1014f-6221-b9ec-9d92-10077d3cb3d1@riseup.net>
References: <1464627822-6173-1-git-send-email-carlosfg@riseup.net>
 <20160530171634.GA1017@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49714 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbcEaKHP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 06:07:15 -0400
In-Reply-To: <20160530171634.GA1017@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/30/2016 07:16 PM, Pablo Neira Ayuso wrote:
> On Mon, May 30, 2016 at 07:03:42PM +0200, Carlos Falgueras Garc=EDa w=
rote:
>> diff --git a/src/set.c b/src/set.c
>> index dbea93b..65b8f1e 100644
>> --- a/src/set.c
>> +++ b/src/set.c
>> @@ -291,10 +295,16 @@ struct nftnl_set *nftnl_set_clone(const struct=
 nftnl_set *set)
>>
>>  	memcpy(newset, set, sizeof(*set));
>>
>> -	if (set->flags & (1 << NFTNL_SET_TABLE))
>> +	if (set->flags & (1 << NFTNL_SET_TABLE)) {
>>  		newset->table =3D strdup(set->table);
>> -	if (set->flags & (1 << NFTNL_SET_NAME))
>> +		if (!newset->table)
>> +			return NULL;
>> +	}
>> +	if (set->flags & (1 << NFTNL_SET_NAME)) {
>>  		newset->name =3D strdup(set->name);
>> +		if (!newset->name)
>> +			return NULL;
>> +	}
>
> This is leaking the clone object.
>

Thanks. I have fixed it and nfntl_set_elem_clone().
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
