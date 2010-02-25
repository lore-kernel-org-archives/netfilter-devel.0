From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_tables: foreachs and reentrancy
Date: Thu, 25 Feb 2010 11:24:04 +0100
Message-ID: <4B864FC4.3000201@trash.net>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de> <4B856498.9040202@trash.net> <alpine.LSU.2.01.1002241952410.3301@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63503 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983Ab0BYKYI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:24:08 -0500
In-Reply-To: <alpine.LSU.2.01.1002241952410.3301@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2010-02-24 18:40, Patrick McHardy wrote:
>>> Jan Engelhardt (6):
>>>       netfilter: xtables: replace XT_ENTRY_ITERATE macro
>>>       netfilter: xtables: optimize call flow around xt_entry_foreach
>>>       netfilter: xtables: replace XT_MATCH_ITERATE macro
>>>       netfilter: xtables: optimize call flow around xt_ematch_foreach
>>>       netfilter: xtables: reduce arguments to translate_table
>>>       netfilter: xtables2: make ip_tables reentrant
>> I've applied patch 1-5 for now. Patch 6 doesn't add any value
>> so far, so it should go in a series that actually makes use of
>> this
> 
> Rusty left a note "must return absolute verdict" in ipt_REJECT
> and ip6t_REJECT, so maybe he thought of something.
> 
> Irrespective of that however, there is xt_TEE in Xtables-addons which
> would greatly benefit in the 6th patch (which is standalone, nothing
> else is needed in the kernel to get it done), as it could then track
> both the original copy and the tee'd copy through the tables, instead
> of having to forget one.

There's no benefit to the kernel at this point, just the risk of
breakage. Anyways, its too late now.

> My intention was to have the entire set merged by 2.6.32, only
> delayed by my own tinkering around with the get_cycle measurement of
> the data collapse. But it was ready on-time for the 2.6.34 window!
> What went wrong? Do we need to begin the merge-into-kabernext window
> much earlier?

Yes, you should begin submitting patches when net-next opens,
usually at -rc1.
