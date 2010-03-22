From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: debugging kernel during packet drops
Date: Mon, 22 Mar 2010 18:53:43 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003221849050.2821@obet.zrqbmnf.qr>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jorrit Kronjee <j.kronjee@infopact.nl>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58104 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0CVRxp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:53:45 -0400
In-Reply-To: <4BA7A5D8.5080101@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-03-22 18:16, Patrick McHardy wrote:
>>
>> I used brctl to build the bridge. The DoS machine has a custom built
>> tool that allows me to send small packets at very fast rates. I've
>> discovered that bridging still works reliably at around 300 kpackets/s
>> (notice the 'k' in there). However, as said before, I was trying to
>> limit the amount of packets/s, so I used netfilter's hashlimit module.
>> This is when packet drops started to appear. 
>>
>> At around 300 kpps, the amount of packet drops is 40 kpps. For me, this
>> amount is too significant to ignore. I see the load average go from a
>> comfortable 0.00 to 1.78, mainly caused by ksoftirqd processes. At 200
>> kpps, the average amount of packet drops is 23 kpps. At 100 kpps, it's
>> still 2 kpps. 

>A couple of suggestions:
>
>- try the limit module in case you don't actually need per-source/dest etc.
>  limiting but just a global limit

The token-per-jiffy math logic used in xt_limit and some other
modules is known to be inaccurate at high speeds.

My suggestion is therefore to try xt_rateest instead which has
a somewhat different logic.
