From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 8/27] xt_connmark match, revision 1
Date: Fri, 4 Jan 2008 16:03:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041602530.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022127380.14900@fbirervta.pbzchgretzou.qr>
 <477E4926.9070103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39432 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYADPDl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:03:41 -0500
In-Reply-To: <477E4926.9070103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 15:56, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 375972a6ff3579f150bf916621b6fe752d29f25a
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 17:52:04 2008 +0100
>> 
>>     [NETFILTER]: xt_connmark match, revision 1
>>     
>>   {
>> 		.name		= "connmark",
>> +		.revision	= 0,
>> 		.family		= AF_INET6,
>> -		.checkentry	= connmark_mt_check,
>> -		.match		= connmark_mt,
>> +		.checkentry	= connmark_mt_check_v0,
>> +		.match		= connmark_mt_v0,
>>    .destroy	= connmark_mt_destroy,
>>    .matchsize	= sizeof(struct xt_connmark_info),
>>  #ifdef CONFIG_COMPAT
>
> This did not compile BTW because you forgot to update the compat
> functions for IPv6. Please always test compilation for all affected
> cases, if you don't have a machine which needs the compat code,
> simply defining CONFIG_COMPAT yourself should work.
>

Have you fixed it during cherrypick? (If so, thanks!)

Well at least I tested CONFIG_IPV6=n ;-)
