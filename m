From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Mon, 31 Dec 2007 15:15:32 +0100
Message-ID: <4778F984.2010201@trash.net>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net> <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr> <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr> <47752958.3010601@trash.net> <Pine.LNX.4.64.0712302228490.15993@bizon.gios.gov.pl> <4778358E.2070506@trash.net> <Pine.LNX.4.64.0712310151110.2093@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>, gpf <gpf@simm.ru>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41504 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXLaOPy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Dec 2007 09:15:54 -0500
In-Reply-To: <Pine.LNX.4.64.0712310151110.2093@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 31 2007 01:19, Patrick McHardy wrote:
>   
>>>
>>> What happens when CPU#0 is disabled (CPU hotplug)?
>>>       
>> Nothing, its simply unused except for counter synchronization and
>> the ->master thing this thread is about.
>>
>>     
>
> 01:57 ccgmbh:~ # taskset 1 iptables -I OUTPUT -m quota --quota 123456
>
> Now suppose CPU#0 was deactivated (taskset only to show what's meant).
> Then iptables would always show the wrong quota.
>   

Sure, because taskset is a workaround and not a fix for the problem.
Its still the exact same bug.

