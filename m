From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/27] xt_connmark match, revision 1
Date: Fri, 04 Jan 2008 16:05:56 +0100
Message-ID: <477E4B54.4030203@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022127380.14900@fbirervta.pbzchgretzou.qr> <477E4926.9070103@trash.net> <Pine.LNX.4.64.0801041602530.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYADPI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:08:59 -0500
In-Reply-To: <Pine.LNX.4.64.0801041602530.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 4 2008 15:56, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> commit 375972a6ff3579f150bf916621b6fe752d29f25a
>>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>>> Date:   Wed Jan 2 17:52:04 2008 +0100
>>>
>>>     [NETFILTER]: xt_connmark match, revision 1
>>>     
>>>   {
>>> 		.name		= "connmark",
>>> +		.revision	= 0,
>>> 		.family		= AF_INET6,
>>> -		.checkentry	= connmark_mt_check,
>>> -		.match		= connmark_mt,
>>> +		.checkentry	= connmark_mt_check_v0,
>>> +		.match		= connmark_mt_v0,
>>>    .destroy	= connmark_mt_destroy,
>>>    .matchsize	= sizeof(struct xt_connmark_info),
>>>  #ifdef CONFIG_COMPAT
>> This did not compile BTW because you forgot to update the compat
>> functions for IPv6. Please always test compilation for all affected
>> cases, if you don't have a machine which needs the compat code,
>> simply defining CONFIG_COMPAT yourself should work.
>>
> 
> Have you fixed it during cherrypick? (If so, thanks!)

Yes, I fixed it.

> Well at least I tested CONFIG_IPV6=n ;-)

Thats at least as important since this is what regulary made
compilation fail for Linus :)
