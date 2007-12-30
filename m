From: Patrick McHardy <kaber@trash.net>
Subject: Re: Quota on SMP AGAIN
Date: Sun, 30 Dec 2007 18:36:52 +0100
Message-ID: <4777D734.7090405@trash.net>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net> <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr> <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr> <47752958.3010601@trash.net> <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr> <47767699.2020302@trash.net> <Pine.LNX.4.64.0712291952430.8994@bizon.gios.gov.pl> <Pine.LNX.4.64.0712292052240.23321@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>, gpf <gpf@simm.ru>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Eric Dumazet <dada1@cosmosbay.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXL3RhH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:37:07 -0500
In-Reply-To: <Pine.LNX.4.64.0712292052240.23321@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 29 2007 19:54, Krzysztof Oledzki wrote:
>   
>>> That doesn't help, the problem is that we keep only the counters on
>>> CPU0 up to date, but the data copied to userspace during iptables -L
>>> is chosen by the CPU the iptables command is running on.
>>>       
>> As a short-term workaround one can use taskset to force running iptables on
>> CPU#0.
>>
>>     
>
> Actually, on one (but fixed) arbitrary core.

Indeed, what a mess. I was just about to commit a patch to
always use first_cpu(cpu_possible_map) for copy_entries_to_user,
but thats no enough, we also need to force ruleset replacement
to choose the same CPU. This effectively eliminates all performance
improvements of the NUMA optimizations during ruleset updates.

Its ugly (not much more than other parts of iptables though),
but we should be able to keep half the improvement by using
raw_smp_processor_id() for ruleset replacements and storing
that number for the next copy_entries_to_user operations.

Alternatively we could flag the matches and targets requiring
this and fix them up during the second pass (counter fixup).
Most of them are rather rarely used I guess (limit, hashlimit,
quota and statistic).

Eric, do you have any better suggestions how to fix this?

