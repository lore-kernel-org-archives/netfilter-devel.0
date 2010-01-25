From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/09]: netfilter: xtables: add CT target
Date: Mon, 25 Jan 2010 17:57:18 +0100
Message-ID: <4B5DCD6E.4070103@trash.net>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <20100125153740.15305.76374.sendpatchset@x2.localnet> <alpine.LSU.2.01.1001251745350.20906@obet.zrqbmnf.qr> <4B5DCB63.7020704@trash.net> <alpine.LSU.2.01.1001251753170.20906@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47581 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0AYQ5V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:57:21 -0500
In-Reply-To: <alpine.LSU.2.01.1001251753170.20906@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2010-01-25 17:48, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> On Monday 2010-01-25 16:37, Patrick McHardy wrote:
>>>
>>>>    netfilter: xtables: add CT target
>>>>    
>>>>    Add a new target for the raw table, which can be used to specify conntrack
>>>>    parameters for specific connections, f.i. the conntrack helper.
>>>>    
>>>>    The target attaches a "template" connection tracking entry to the skb, which
>>>>    is used by the conntrack core when initializing the new conntrack.
>>>> include/linux/netfilter/xt_CT.h             |   13 ++
>>>> include/net/netfilter/nf_conntrack_helper.h |    3 
>>>> net/netfilter/Kconfig                       |    6 +
>>>> net/netfilter/Makefile                      |    1 
>>>> net/netfilter/nf_conntrack_helper.c         |   19 +++
>>>> net/netfilter/xt_CT.c                       |  142 ++++++++++++++++++++++++++++
>>>> 6 files changed, 184 insertions(+)
>>> Is it perhaps feasible to put the xt_CT code into an already existing
>>> .c file (e.g. xt_conntrack.c) to cut on module overhead?
>> They're quite different, so those two don't fit together very well.
>> We could add NOTRACK support to xt_CT and deprecate the NOTRACK module.
>>
> Sounds like a plan. Will you take care of that, or should I add it
> to my list?

I'll take care of it and will include it in the next submission.

Does anyone have an opinion on supporting specifying helper parameters?
I'm considering adding something like 5 generically usable u32s and have
helpers initialize parameters like FTP "loose" or SIP "direct_media"
based on those.

