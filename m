From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: 02/13 [NETFILTER]: Use unsigned types for hooknum and pf vars
Date: Tue, 15 Jul 2008 10:17:32 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807151010030.13215@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101524070.27323@fbirervta.pbzchgretzou.qr> <487B53F8.5080006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYGOIRd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:17:33 -0400
In-Reply-To: <487B53F8.5080006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-07-14 15:26, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> commit ffffffffffffffffffffffffffffffffffffffff
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Sat Apr 12 08:24:12 2008 +0200
>> 
>> [NETFILTER]: Use unsigned types for hooknum and pf vars
>>     and (try to) consistently use u_int8_t for the L3 family.
>> 
>
>> +extern struct xt_match *xt_find_match(u_int8_t af, const char *name,
>> +				      u8 revision);
>
> It would have been cleaner to at least consistently use u_int8_t/u8
> within one function. Alternatively I'd prefer the u8 type since
> people usually use that in new patches, so over time we'd get rid
> of the type inconsistencies.

If you really want to get rid of type inconsistencies in the source,
the C99 stdint types should be used. In retrospect, defining our own
types like [us](8|16|32) are not really needed, much less for new code.

>> --- a/include/net/netfilter/nf_conntrack_tuple.h
>> +++ b/include/net/netfilter/nf_conntrack_tuple.h
>> @@ -37,7 +37,12 @@ union nf_conntrack_man_proto
>>   	__be16 port;
>>   } udp;
>>   struct {
>> -		__be16 id;
>> +		union {
>> +			__be16 id;
>> +			struct {
>> +				__u8 type, code;
>
> This is not exposed to userspace, so there's no need to
> use the __ types.
>
>>   /* These are the parts of the tuple which are fixed. */
>>   struct {
>> 		union nf_inet_addr u3;
>> -		union {
>> -			/* Add other protocols here. */
>> -			__be16 all;
>> -
>> -			struct {
>> -				__be16 port;
>> -			} tcp;
>> -			struct {
>> -				__be16 port;
>> -			} udp;
>> -			struct {
>> -				u_int8_t type, code;
>> -			} icmp;
>> -			struct {
>> -				__be16 port;
>> -			} dccp;
>> -			struct {
>> -				__be16 port;
>> -			} sctp;
>> -			struct {
>> -				__be16 key;
>> -			} gre;
>> -		} u;
>> +		union nf_conntrack_man_proto u;
>
> This is an unrelated change that doesn't belong in this patch.

Oops,

> Not that I'm opposed to the change, but the "man" part in the
> name stands for manipulable, which doesn't fit here.

I was just using existing names, aiming for a minimal patch,
since people are so sensitive to having names changed and 'wrong'
types being used.
