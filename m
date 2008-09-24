From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug with conntracks created arbitrarily through netlink
Date: Wed, 24 Sep 2008 20:00:53 +0200
Message-ID: <48DA8055.8070501@trash.net>
References: <1222278224.8300.87.camel@quasar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Luca Landi <l.landi@gif.it>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43967 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXSA4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:00:56 -0400
In-Reply-To: <1222278224.8300.87.camel@quasar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Landi wrote:
> Hello everybody,
> 
> I think I have found a bug with conntracks created by userspace through
> netlink. The bug resides in the kernel.
> 
> Basically, when you create a new conntrack through netlink, you normally
> do so in advance. That is, before any actual packet of that connection
> arrives (or goes out). (Sidenote: in fact honestly I can't think of
> situations where one would want to manually create a conntrack truly
> after the connection to be tracked was already in progress, and also I
> guess that that would be anyway impossible as such a conntrack would
> have been created automatically by the kernel).
> 
> Anyway, as such manual in-advance creation (through netlink) does not go
> through the L4 initialization normally done by l4proto->new() (as well
> as all the other things done by init_conntrack()), this at least in the
> case of a TCP connection does affect tcp_in_window() in that when it
> sees the first ever packet for that connection (normally the SYN),
> tcp_in_window() regardlessly goes through the
> "i-am-in-the-middle-of-a-connection" codepath, not syncing properly with
> the window. The outcome is that after some kbytes of data transferred,
> tcp_in_window() starts rejecting packets. In case of nat-ed connections
> this also means that packets won't be nat-ed any more. Seen all this
> happening live myself.
> 
> I already went through the analysis of the relevant kernel code, spotted
> what happens exactly at every stage, and found (and tested successfully)
> a possible fix. Just wondered whether you knew this already and had a
> good argument for it. I know about the "be-liberal-with-windows" flag,
> which might be considered as a ready workaround, but I thought we could
> and should do better for this case. What do you think?
> 
> PS: I'm using ubuntu 8.04 and working with its official kernel. At a
> superficial glance at the latest stable from kernel.org it seems to me
> that the problem is still there. Blame me if I am mistaken.

We're automatically enabling the be-liberal logic for picked up
connections nowadays, so you shouldn't get out of window packets.
Which kernel does ubuntu 8.04 use?
