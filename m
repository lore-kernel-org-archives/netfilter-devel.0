From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 26 Nov 2010 16:27:43 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011261620110.25399@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr>
 <4CEF6F12.7080601@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53586 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab0KZP1o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:27:44 -0500
In-Reply-To: <4CEF6F12.7080601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-11-26 09:25, Pablo Neira Ayuso wrote:

>>> BTW, I didn't look at your protocol in deep yet but I'd suggest the 
>>> following basis to rework it: one netlink message, one rule operation.
v>> 
>> I can agree with that suggestion, so I will be doing that.
>
>Great, this approach requires more memory because you spend one netlink
>header for every rule, but the cost is worth since it provides flexibility.

Hm, I remembered a problem with that. With "allow same attribute type
multiple times", it is possible to send a single TABLE_REPLACE
request message (even if it is 150 MB in size) that the kernel part
can then work on. Without it, and instead using per-rule ops, it
would mean that I would have to keep a per-fd state (which seems not
possible) and make use of the NETLINK_URELEASE notification handler
to kill said state when the client goes away unexpectedly.
