From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/13] libxt_rateest: avoid optional arguments
Date: Tue, 24 May 2011 10:14:19 +0200
Message-ID: <4DDB68DB.4040000@trash.net>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de> <1306161564-4370-11-git-send-email-jengelh@medozas.de> <4DDB542D.5060006@trash.net> <alpine.LNX.2.01.1105240943200.13058@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50199 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab1EXIOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:14:53 -0400
In-Reply-To: <alpine.LNX.2.01.1105240943200.13058@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.05.2011 10:03, Jan Engelhardt wrote:
> On Tuesday 2011-05-24 08:46, Patrick McHardy wrote:
> 
>> On 23.05.2011 16:39, Jan Engelhardt wrote:
>>> Optional arguments make parsing unnecessarily harder - even more so
>>> than two-args. Right now, rateest even crashes because of it.
>>>
>>>  static const struct option rateest_opts[] = {
> [...]
>>> -	{.name = "rateest-bps1",  .has_arg = false, .val = OPT_RATEEST_BPS1},
>>> +	{.name = "rateest-bps1",  .has_arg = true, .val = OPT_RATEEST_BPS1},
> [...]
>>
>> This appears to be breaking backwards compatibility.
> 
> Admittedly yes, though the fact that this has remained unseen for so
> long suggests that the potential user base is very small or not yet
> existing.

I'm pretty sure this used to work at some point. Let me check history.

> In my time with users in IRC, I notice that they in particular prefer
> hard stops in parsing over silent upgrades of rules[1], so as to
> actually become aware of the change upfront. As such, I believe the
> impact is well justified.

Well, if it really was broken from the beginning I'm fine of course,
but I don't think that's case.

> [1] i.e. `diff -u rules <(xtables-main save6)` is supposed to yield
> no diff except for counters
> 

