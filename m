From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 10/13] libxt_rateest: avoid optional arguments
Date: Tue, 24 May 2011 10:03:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105240943200.13058@frira.zrqbmnf.qr>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de> <1306161564-4370-11-git-send-email-jengelh@medozas.de> <4DDB542D.5060006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47589 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab1EXIDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:03:13 -0400
In-Reply-To: <4DDB542D.5060006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-05-24 08:46, Patrick McHardy wrote:

>On 23.05.2011 16:39, Jan Engelhardt wrote:
>> Optional arguments make parsing unnecessarily harder - even more so
>> than two-args. Right now, rateest even crashes because of it.
>> 
>>  static const struct option rateest_opts[] = {
[...]
>> -	{.name = "rateest-bps1",  .has_arg = false, .val = OPT_RATEEST_BPS1},
>> +	{.name = "rateest-bps1",  .has_arg = true, .val = OPT_RATEEST_BPS1},
[...]
>
>This appears to be breaking backwards compatibility.

Admittedly yes, though the fact that this has remained unseen for so
long suggests that the potential user base is very small or not yet
existing.

In my time with users in IRC, I notice that they in particular prefer
hard stops in parsing over silent upgrades of rules[1], so as to
actually become aware of the change upfront. As such, I believe the
impact is well justified.

[1] i.e. `diff -u rules <(xtables-main save6)` is supposed to yield
no diff except for counters
