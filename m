From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/2 libnftnl] utils: Fix out of bound access in
 nftnl_family2str
Date: Mon, 15 Aug 2016 13:45:55 +0200
Message-ID: <b6dda63e-66d2-0fdc-4eb6-24f66da630b5@riseup.net>
References: <20160815103256.GB5883@salvia>
 <20160815105103.22319-1-carlosfg@riseup.net> <20160815110339.GA8028@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:37092 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbcHOLp7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 07:45:59 -0400
In-Reply-To: <20160815110339.GA8028@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/15/2016 01:03 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 15, 2016 at 12:51:02PM +0200, Carlos Falgueras García wrote:
>> Checks array limits before access it and adds a missed translation.
>>
>> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
>> ---
>>  src/utils.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/utils.c b/src/utils.c
>> index e2715a2..7264d1f 100644
>> --- a/src/utils.c
>> +++ b/src/utils.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/netfilter/nf_tables.h>
>>
>>  static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
>> +	[NFPROTO_UNSPEC]	= "unknown",
>
> You don't need this line above, right? I can mangle the patch here
> before applying it.

Yes, sorry. Do you get rid of it or must I send another version?

>>  	[NFPROTO_INET]		= "inet",
>>  	[NFPROTO_IPV4]		= "ip",
>>  	[NFPROTO_ARP]		= "arp",
>> @@ -33,7 +34,7 @@ static const char *const nftnl_family_str[NFPROTO_NUMPROTO] = {
>>
>>  const char *nftnl_family2str(uint32_t family)
>>  {
>> -	if (nftnl_family_str[family] == NULL)
>> +	if (family >= NFPROTO_NUMPROTO || !nftnl_family_str[family])
>>  		return "unknown";
>>
>>  	return nftnl_family_str[family];
>> --
>> 2.8.3
>>
