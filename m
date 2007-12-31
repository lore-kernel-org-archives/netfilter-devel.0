From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Mon, 31 Dec 2007 01:19:26 +0100
Message-ID: <4778358E.2070506@trash.net>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net> <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr> <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr> <47752958.3010601@trash.net> <Pine.LNX.4.64.0712302228490.15993@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>, gpf <gpf@simm.ru>,
	netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60021 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbXLaATm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:19:42 -0500
In-Reply-To: <Pine.LNX.4.64.0712302228490.15993@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>
>
> On Fri, 28 Dec 2007, Patrick McHardy wrote:
> <CUT>
>>> And my bigtime question would be: where is the other counter 
>>> actually? struct xt_quota_info only has one counter! Does netfilter 
>>> secretly allocate matchinfos per-cpu?
>>>
>>
>> Not secretly, but yes, the entire ruleset exists once per CPU. That
>> also seems to be the problem, at the time the master idea was thought
>> of we always dumped entries from CPU 0, today its from the current
>> CPU, but the only one that actually has correct counters is CPU 0.
>
> What happens when CPU#0 is disabled (CPU hotplug)?

Nothing, its simply unused except for counter synchronization and
the ->master thing this thread is about.
