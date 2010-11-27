From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Sat, 27 Nov 2010 18:35:57 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011271828270.28539@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu> <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262057450.18326@blackhole.kfki.hu> <alpine.LNX.2.01.1011262159310.4752@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011270951330.20431@blackhole.kfki.hu> <alpine.LNX.2.01.1011271319330.24289@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011271741030.21709@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60153 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0K0Rf6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Nov 2010 12:35:58 -0500
In-Reply-To: <alpine.DEB.2.00.1011271741030.21709@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-11-27 18:04, Jozsef Kadlecsik wrote:
>
>AFAIK when the kernel dumps and the skb is full, it's not returned 
>directly to the userspace but first enqueued.

I don't recognize that inside the code however.

In netlink_dump(), there is the cb->dump call. There are no loops
inside this function. Neither are there in the two parents,
netlink_dump_start() and netlink_recvmsg().

The queueing behavior you mention I only see when the kernel
autonomously sends packets that have not been explicitly
requested by userspace.


>* let there be a list of 6 entries of data, ABCDEF
>* proc A starts a dump, and kernel enqueues the messages, which
>  cover all entries.

Given a big enough ruleset, it won't cover all of them.


>And if the userspace listener is too slow/not ready to receive the netlink
>messages from the queue, then the queue can get full and messages will be
>lost.

If that was the case, we would have seen truncated ct dumps already.
Because the standard queue is just something like 124KB or so, that
would be a mere ~40 fully-stuffed packets in the queue, and people
certainly have more than 40, for safety, even more than 1000
connections live at a time, so somebody has already run into a
queue overflow, iff things were queued in the first place.
