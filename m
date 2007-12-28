From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Quota on SMP AGAIN
Date: Fri, 28 Dec 2007 18:00:25 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
 <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
 <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr>
 <47752958.3010601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: gpf <gpf@simm.ru>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44892 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbXL1RA0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2007 12:00:26 -0500
In-Reply-To: <47752958.3010601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 28 2007 17:50, Patrick McHardy wrote:
>>
>> And my bigtime question would be: where is the other counter
>> actually? struct xt_quota_info only has one counter! Does
>> netfilter secretly allocate matchinfos per-cpu?
>
> Not secretly, but yes, the entire ruleset exists once per CPU. That
> also seems to be the problem, at the time the master idea was thought
> of we always dumped entries from CPU 0, today its from the current
> CPU, but the only one that actually has correct counters is CPU 0.
>
> The easy fix would be to revert to that behaviour, but maybe someone
> can come up with a better idea that doesn't involve walking over the
> entire ruleset and resycing things or adding dump callbacks to
> matches.
>
Well, the short term fix would be to turn

	q->master = q

into

	q->master = percpu_get(0, q)

or whatever is appropriate.

In the long run, separating the rule from the matchinfo data would be
beneficial. Or actually - why cannot the ruleset exists once for all
CPUs? The write path is a slow path anyway / it is read-mostly anyway.
