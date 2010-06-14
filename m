From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: ip_conntrack fails to track Windows Vista TCP connection
Date: Mon, 14 Jun 2010 19:43:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006141941160.23197@obet.zrqbmnf.qr>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net> <4C165596.8020700@trash.net> <alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr> <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55053 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0FNRnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:43:45 -0400
In-Reply-To: <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-06-14 19:34, Fischer, Anna wrote:

>>>> [something about Vista and TCP Delayed ACK]
>>>>
>>>> Is this a known issue?
>>>
>>> You're mentioning ip_conntrack, which is obsoleted for multiple
>>> years now. Which kernel version are you using?
>> 
>> By definition of ip_conntrack, that must be older than 2.6.20.
>
>Yes, this is a 2.6.18 Xen kernel that I am using. Even if it is obsolete, can you let me know if you are aware of such a problem ever having caused any issues? I just want to get a feeling if I am at least roughly on the right track while figuring out what the problem is.

The 2.6.18 has a known problem with DSACK even when both
endpoints are Linux.
