From: Luca Landi <l.landi@gif.it>
Subject: Bug with conntracks created arbitrarily through netlink
Date: Wed, 24 Sep 2008 19:43:44 +0200
Message-ID: <1222278224.8300.87.camel@quasar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpauth.interhost.it ([194.242.61.185]:41539 "EHLO
	smtpauth.interhost.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYIXRxE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:53:04 -0400
Received: from [192.9.200.32] (unknown [192.9.200.32])
	by smtpauth.interhost.it (Postfix) with ESMTPA id 6E0D3C421A
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Sep 2008 19:43:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everybody,

I think I have found a bug with conntracks created by userspace through
netlink. The bug resides in the kernel.

Basically, when you create a new conntrack through netlink, you normally
do so in advance. That is, before any actual packet of that connection
arrives (or goes out). (Sidenote: in fact honestly I can't think of
situations where one would want to manually create a conntrack truly
after the connection to be tracked was already in progress, and also I
guess that that would be anyway impossible as such a conntrack would
have been created automatically by the kernel).

Anyway, as such manual in-advance creation (through netlink) does not go
through the L4 initialization normally done by l4proto->new() (as well
as all the other things done by init_conntrack()), this at least in the
case of a TCP connection does affect tcp_in_window() in that when it
sees the first ever packet for that connection (normally the SYN),
tcp_in_window() regardlessly goes through the
"i-am-in-the-middle-of-a-connection" codepath, not syncing properly with
the window. The outcome is that after some kbytes of data transferred,
tcp_in_window() starts rejecting packets. In case of nat-ed connections
this also means that packets won't be nat-ed any more. Seen all this
happening live myself.

I already went through the analysis of the relevant kernel code, spotted
what happens exactly at every stage, and found (and tested successfully)
a possible fix. Just wondered whether you knew this already and had a
good argument for it. I know about the "be-liberal-with-windows" flag,
which might be considered as a ready workaround, but I thought we could
and should do better for this case. What do you think?

PS: I'm using ubuntu 8.04 and working with its official kernel. At a
superficial glance at the latest stable from kernel.org it seems to me
that the problem is still there. Blame me if I am mistaken.


