From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Mon, 15 Feb 2010 18:29:43 +0100
Message-ID: <4B798487.6040304@trash.net>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65143 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0BOR3q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:29:46 -0500
In-Reply-To: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Afi Gjermund wrote:
> Hi all,
> 
> I am running into an odd issue where the kernel begins to drop packets
> because the connection tracking table is full. (I am running
> 2.6.26.5).
> 
> A 'cat /proc/sys/net/netfilter/nf_conntrack_count' says 4096.  But if
> I do a 'cat /proc/net/nf_conntrack | wc -l' then it says 4.
> 
> A tail on /var/log/messages has:
> 
> Feb 15 16:45:33 titan user.warn kernel: __ratelimit: 20 messages suppressed
> Feb 15 16:45:33 titan user.warn kernel: nf_conntrack: table full,
> dropping packet.
> 
> I have an interface that allows me to do a 'nf_conntrack_flush' in
> kernel, but that seems to only clear the table of
> /proc/net/nf_conntrack and not the count the kernel has.
> 
> I need a way to ensure that at say 95% there is a way to clear the
> "actual" table as well as the count...whichever that may be.  There
> seems to be a disconnect between the implementation versus my
> understanding of how the system is working. Any help is appreciated.

Conntracks might exist and not be in the global table anymore,
f.i. when referenced by a packet. The difference in your case
seems pretty extreme, so I'd guess that packets are leaked
somewhere.
