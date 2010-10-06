From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Wed, 6 Oct 2010 20:01:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010061910060.28431@obet.zrqbmnf.qr>
References: <201010061842.20142.sven-ola@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven-Ola Tuecke <sven-ola@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59681 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862Ab0JFSBN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:01:13 -0400
In-Reply-To: <201010061842.20142.sven-ola@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-10-06 18:42, Sven-Ola Tuecke wrote:
>
>Re: Announcement: MAP66 extension for ip6tables

For a moment that read like a Doom2 extension... ;-)


>Hey,
>
>FYI: just finished the readme for a netfilter IPv6-to-IPv6 address mapping 
>target - time to say hello. Netfilter extension should compile from 
>iptables-1.3.3++ and the kernel module with kernel-2.4.30 until kernel-2.6.32. 
>Extension module status is beta, that is: a first test installation works fine. 
>License is GPL2. Project and Readme are here:
>
>http://map66.sf.net
>http://map66.svn.sourceforge.net/viewvc/map66/README.html

And.. I take it you want a review?

- NAT, even if NAT66, still interferes with ETE connectivity. Think 
FTP-SSL connections. That may not be your problem, but it's the Working 
Group's and the Draft's.

- I would recommend using Xtables-addons to unclutter the source code 
from the #ifdef hackery. Most if it can be removed, since it does not 
look like you tested with Linux kernels earlier than 2.6.22 anyway.

- Conntrack will be confused because you change the packets' addresses 
while packets are in conntrack's domain. (In essence it will lead to 
state matching being nonfunctional if I am not mistaken because it sees 
two different tuples.)

- There are pointless casts from/to void*

- You should document what MAP66_lock is protecting.
