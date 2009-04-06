From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: stream-like interface by netfilter?
Date: Mon, 6 Apr 2009 12:59:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904061254410.28277@fbirervta.pbzchgretzou.qr>
References: <741894ea0903311503j1ac8aebbt3b2767d6e18173eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Haibin Wang <haibin123us@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35846 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbZDFK7Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:59:16 -0400
In-Reply-To: <741894ea0903311503j1ac8aebbt3b2767d6e18173eb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-04-01 00:03, Haibin Wang wrote:
>
>First, Does netfilter provide a stream-like interface in kernel space,
>in addition to packets?

Even STREAMS is quite message-based and you need to collect 
packets/messages before you can linearize them to form a stream of 
sorts.

>Second, if not, is there a way that netfilter provides packets of a
>TCP connection in right order ( maybe also duplications free)?

No.

>Third, if so, what would be the best place to put in TCP reassembly
>code to collect packets and present a stream-like interface? I used
>NAT helper and CONNTRACK helper before, but not sure that is the right
>place to fulfill such a function.

A hyphothetical tcp "defrag" or "ordering" module should be run after 
nf_defrag_ipv4.

>Essentially we are doing a project that requires inspecting contents
>of TCP connections, our current approach requires patch to kernel
>TCP/IP stack, which isn't that convenient to end users. So we want to
>explore the idea whether we could do it using Netfilter. But so far I
>haven't found such an interface from Netfilter documentation.
>

You could be using libnetfilter_queue to do it in userspace instead.
