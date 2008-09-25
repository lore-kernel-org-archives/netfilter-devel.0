From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: been a while...what happened to NFC_ALTERED?
Date: Thu, 25 Sep 2008 19:38:28 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dave Horton <dhorton@pactolus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37084 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYIYXia (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:38:30 -0400
In-Reply-To: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-09-25 18:38, Dave Horton wrote:

> Here's my situation: I wrote a simple netfilter target a couple of
> years back, been running it on Redhat 3, 2.4 kernel successfully
> for quite a while.  I install it on the PREROUTING chain, and I
> mangle UDP packets; modifiying the source and destination
> addresses.

Modifying it in which way? Maybe what you are trying to achieve is
already solved by other modules.

> My code was then setting the NFC_ALTERED bit in the
> nf_cache of the sk_buff so that it would get re-processed by
> netfilter. Everything fine.  Now I simply want to update my code to
> run on Centos 5, kernel 2.6.18 and iptables 1.4.  Whoa, now I find
> my kernel module doesn't compile because that data structure has
> changed.  If I remove that line of code, it compiles, but the
> packet forwarding does not work (and it seems like I stop getting
> packets routed to my target at all once I mangle the first one).
>
> Can someone help me out?  What is the new improved way of
> indicating that I've changed a packet's header or body so that
> netfilter re-examines it?

The funny thing is, even in Linux 2.5.0, only the IPv6 code ever
examines for NFC_ALTERED. It's like the thing was never used.
See http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
if you need any assistance for moving your extension forward
in time (though 2.6.18 is now so old again...)
