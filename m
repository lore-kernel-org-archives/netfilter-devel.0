From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: iptables performance and alternatives
Date: Mon, 19 May 2008 12:00:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805191154030.20401@tyr.diku.dk>
References: <200805151421.23862.anton.vazir@gmail.com>
 <200805151535.31933.anton.vazir@gmail.com>
 <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
 <200805151557.28368.anton.vazir@gmail.com>
 <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
 <1210857556.24732.10.camel@enterprise.ims-firmen.de>
 <Pine.LNX.4.64.0805182253160.10481@tyr.diku.dk> <1211183506.15125.6.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:54552 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYESKAP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 06:00:15 -0400
In-Reply-To: <1211183506.15125.6.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 19 May 2008, Thomas Jacob wrote:

>> If doing a lot of rule changes, you should definitly use iptables-restore
>> or CPAN perl module IPTables::libiptc.
>
> Incidentally, what happens during the time changes are being processed
> by iptables-restore/the kernel. More specifically, do I need to
> worry about packets being blocked/dropped when I would do a lot of
> rule updates?

Packet will not get dropped while userspace (iptables/libiptc) is making 
changes to the ruleset. Its allowed to make many many changes in userspace 
before commiting it to the kernel.

When commiting the ruleset to the kernel, the kernel will have both the 
old and new ruleset before it swaps the two.  I have not measured the 
performance hit of swaping the rulesets, but it should be insignificant.

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
