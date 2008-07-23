From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: 07/13 [NETFILTER]: Introduce NFPROTO_* constants
Date: Wed, 23 Jul 2008 11:34:27 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807142115580.13215@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101526050.27323@fbirervta.pbzchgretzou.qr> <487B554B.1000109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36478 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbYGWJe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:34:28 -0400
In-Reply-To: <487B554B.1000109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-07-14 15:31, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> commit ffffffffffffffffffffffffffffffffffffffff
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Apr 10 10:50:33 2008 +0200
>> 
>> [NETFILTER]: Introduce NFPROTO_* constants
>> 
>> The netfilter subsystem only supports a handful of protocols (much
>> less than PF_*) and even non-PF protocols like ARP and
>> pseudo-protocols like PF_BRIDGE. By creating NFPROTO_*, we can earn a
>> few memory savings on arrays that previously were always PF_MAX-sized
>> and keep the pseudo-protocols to ourselves.
>> 
>> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
>> index 8c83d2e..0f37245 100644
>> --- a/include/linux/netfilter.h
>> +++ b/include/linux/netfilter.h
>> @@ -52,6 +52,15 @@ enum nf_inet_hooks {
>>  	NF_INET_NUMHOOKS
>>  };
>>  
>> +enum {
>> +	NFPROTO_UNSPEC =  0,
>> +	NFPROTO_IPV4   =  2,
>> +	NFPROTO_ARP    =  3,
>> +	NFPROTO_BRIDGE =  7,
>> +	NFPROTO_IPV6   = 10,
>> +	NFPROTO_NUMPROTO,
>> +};
>
> What about DECnet?

Is it seriously used?
