From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH libnftnl] set: Fix nftnl_set_set_str
Date: Fri, 1 Jul 2016 18:13:16 +0200
Message-ID: <5776969C.1060009@riseup.net>
References: <20160627162425.4376-1-carlosfg@riseup.net>
 <20160701142247.GA8806@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:54983 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbcGAQNT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 12:13:19 -0400
In-Reply-To: <20160701142247.GA8806@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/07/16 16:22, Pablo Neira Ayuso wrote:
> On Mon, Jun 27, 2016 at 06:24:25PM +0200, Carlos Falgueras Garc=EDa w=
rote:
>> We need the string length
>>
>> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
>> ---
>>   src/set.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/src/set.c b/src/set.c
>> index 879100c..edbcbe5 100644
>> --- a/src/set.c
>> +++ b/src/set.c
>> @@ -203,7 +203,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_a=
ttr_set_u64);
>>  =20
>>   int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const ch=
ar *str)
>>   {
>> -	return nftnl_set_set(s, attr, str);
>> +	return nftnl_set_set_data(s, attr, str, strlen(str));
> I think this should be strlen(str) + 1 so we make sure the string is
> nul-terminated.
Thanks Pablo. I have sent a v2 and another patch to fix this error in=20
other code parts.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
