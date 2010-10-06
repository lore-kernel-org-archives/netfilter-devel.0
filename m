From: "Sven-Ola Tuecke" <sven-ola@gmx.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Wed, 6 Oct 2010 21:20:36 +0200
Message-ID: <201010062120.36885.sven-ola@gmx.de>
References: <201010061842.20142.sven-ola@gmx.de> <alpine.LNX.2.01.1010061910060.28431@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:44097 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755123Ab0JFTUl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:20:41 -0400
In-Reply-To: <alpine.LNX.2.01.1010061910060.28431@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Am Mittwoch, 6. Oktober 2010, um 20:01:11 schrieb Jan Engelhardt:

[...snip...]

> And.. I take it you want a review?

No - I'm only interested in a working solution. Of course, I take what I can 
get to make it better if required.

> - NAT, even if NAT66, still interferes with ETE connectivity. Think
> FTP-SSL connections. That may not be your problem, but it's the Working
> Group's and the Draft's.

Yes - there are protocols that rely on addresses such as SIP, active FTP etc. 
I don't plan to add NAT helpers for them, thats pointless somehow. 

> - I would recommend using Xtables-addons to unclutter the source code
> from the #ifdef hackery. Most if it can be removed, since it does not
> look like you tested with Linux kernels earlier than 2.6.22 anyway.
>
> - Conntrack will be confused because you change the packets' addresses
> while packets are in conntrack's domain. (In essence it will lead to
> state matching being nonfunctional if I am not mistaken because it sees
> two different tuples.)

Aha. Thanks for the tips. I'll try to dive in. This is my first netfilter addon 
and I don't think I'll write another in this live.

> - There are pointless casts from/to void*

That's for kernel-2.4: The target firmware uses that old kernel for Flash space 
reasons. Only 1.75 Mb Flash and 8 Mb RAM.

> - You should document what MAP66_lock is protecting.

OK. They lock printk()s on SMP. Unnecessary without #DEBUG

Again, thank you very much,
// Sven-Ola
