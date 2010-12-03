From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 3 Dec 2010 22:03:19 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012032156100.26825@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr>
 <4CEF6F12.7080601@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47236 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab0LCVDU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:03:20 -0500
In-Reply-To: <4CEF6F12.7080601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-11-26 09:25, Pablo Neira Ayuso wrote:
>
>> In fact, why don't we just use genetlink for new code instead?
>
>Genetlink is similar. The main difference is that the ID family number
>and multicast groups for each subsystem is not fixed, it's registered in
>runtime. This means that you have to make the "family name resolution",
>ie. to send a message to resolve the ID family number and multicast
>groups before doing any operation.
>
>Another reason is consistency, it's a good idea to use the mechanism
>that other netfilter subsystems already use.

"Look, iptables uses ioctl! Let's use ioctl again for xt2."

I am skeptical about shrinkfitting something onto an older
interface (nfnetlink) when there is genetlink..

>>> BTW, I didn't look at your protocol in deep yet but I'd suggest the 
>>> following basis to rework it: one netlink message, one rule operation.
>> 
>> I can agree with that suggestion, so I will be doing that.

Something else that came to mind -- if ordering of nlattrs is not
guaranteed inside nlmsg, we could just pack all the data into a
single attribute and mark it binary, which means potential relays (if
nl ever gets that far!) won't reorder it.
