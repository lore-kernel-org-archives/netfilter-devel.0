From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Fri, 28 Dec 2007 17:13:55 +0100
Message-ID: <477520C3.8040501@trash.net>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net> <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: gpf <gpf@simm.ru>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33645 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbXL1QOJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:14:09 -0500
In-Reply-To: <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 28 2007 16:26, Patrick McHardy wrote:
>   
>> gpf wrote:
>>     
>>> hi
>>>
>>> iptables, iptables-save not working properly
>>>
>>> [root@ns bind] iptables -L quot |grep devel
>>> RETURN     0    --  anywhere             developer.simm.ru   quota:
>>> 226620450 bytes
>>> [root@ns bind] dpkg -l |grep iptables
>>> ii  iptables                   1.3.6.0debian1-5
>>>   
>>>       
>> The quota extension in old iptables releases is incompatible with the
>> version merged upstream.
>>     
>
> I am seeing this too on 2.6.23.10 with iptables-1.4.0svn7097.
> No incompatibilities obvious to me, both kernel and iptables use
> the same xt_quota.h.

Gpf's report didn't include an actual description of the problem, so
I can only assume its an incorrect value of the quota. What exactly
are the effects you're seeing?


