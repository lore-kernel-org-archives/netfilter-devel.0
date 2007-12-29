From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Sat, 29 Dec 2007 17:32:25 +0100
Message-ID: <47767699.2020302@trash.net>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net> <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr> <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr> <47752958.3010601@trash.net> <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: gpf <gpf@simm.ru>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59560 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbXL2Qcd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Dec 2007 11:32:33 -0500
In-Reply-To: <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 28 2007 17:50, Patrick McHardy wrote:
>   
>>> And my bigtime question would be: where is the other counter
>>> actually? struct xt_quota_info only has one counter! Does
>>> netfilter secretly allocate matchinfos per-cpu?
>>>       
>> Not secretly, but yes, the entire ruleset exists once per CPU. That
>> also seems to be the problem, at the time the master idea was thought
>> of we always dumped entries from CPU 0, today its from the current
>> CPU, but the only one that actually has correct counters is CPU 0.
>>
>> The easy fix would be to revert to that behaviour, but maybe someone
>> can come up with a better idea that doesn't involve walking over the
>> entire ruleset and resycing things or adding dump callbacks to
>> matches.
>>
>>     
> Well, the short term fix would be to turn
>
> 	q->master = q
>
> into
>
> 	q->master = percpu_get(0, q)
>
> or whatever is appropriate.
>   

That doesn't help, the problem is that we keep only the counters on
CPU0 up to date, but the data copied to userspace during iptables -L
is chosen by the CPU the iptables command is running on.

> In the long run, separating the rule from the matchinfo data would be
> beneficial. Or actually - why cannot the ruleset exists once for all
> CPUs? The write path is a slow path anyway / it is read-mostly anyway.
>   

Mainly because of the counters, we don't want to have all CPUs fighting
for the cachelines.


