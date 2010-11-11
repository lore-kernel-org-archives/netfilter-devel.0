From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] netfilter: nfnetlink: guard against undefined entries
Date: Thu, 11 Nov 2010 21:56:34 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011112156080.30863@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011100249390.23289@obet.zrqbmnf.qr> <4CDBC6A0.2000108@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37711 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab0KKU4f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:56:35 -0500
In-Reply-To: <4CDBC6A0.2000108@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-11-11 11:34, Patrick McHardy wrote:

>On 10.11.2010 02:50, Jan Engelhardt wrote:
>> parent a391d495f6082f6348b9074214e81c7e2dc1151c (v2.6.37-rc1-184-ga391d49)
>> commit 6e97eb121bc8e39c651645c3d937f468d2b3e7fe
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Sat Nov 6 21:19:16 2010 +0100
>> 
>> netfilter: nfnetlink: guard against undefined entries
>> 
>> Check for empty entries in struct nfnl_callback[] to avoid potential
>> NULL deference. (Because I have run into one during development.)
>
>It seems silly to add checks for easy to find bugs in users of
>this code. Finding the cause of -EINVAL is much harder than
>getting a nice oops.

But costs a reboot.
How about a printk?

>> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
>> index b4a4532..7012882 100644
>> --- a/net/netfilter/nfnetlink.c
>> +++ b/net/netfilter/nfnetlink.c
>> @@ -152,7 +152,7 @@ replay:
>>  	}
>>  
>>  	nc = nfnetlink_find_client(type, ss);
>> -	if (!nc)
>> +	if (nc == NULL || nc->call == NULL)
>>  		return -EINVAL;
>>  
>>  	{

