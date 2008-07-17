From: Patrick McHardy <kaber@trash.net>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Thu, 17 Jul 2008 11:16:14 +0200
Message-ID: <487F0DDE.3050108@trash.net>
References: <487E24FC.60700@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49951 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYGQJQR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:16:17 -0400
In-Reply-To: <487E24FC.60700@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Hi,
> 
> I am writing a network application for a genuine wireless router (266Mhz 
> IXP4XX). I am capturing packets with ULOG and need connection tracking. 
> For performance reasons I planned to use connection tracking events 
> (NEW/DESTROY) to avoid doing the same work twice.
> 
> In a high load test case I stress the router with UDP packets with 
> random source ports (1000B payload, 1800pps). CPU usage is 100%, 10% of 
> packets and 80% ctevents are dropped. If I disable ctevents, the CPU 
> usage is just 24% and no packet drops occur.
> 
> My application is not very heavy and I expect most of the ctevent 
> overhead to be caused by passing events from kernel to user space. I 
> expect that performance could be increased by using multipart messages 
> for ctevents like it is done in ULOG/NFLOG.
> 
> Do you share my opinion, that multipart messages would lead to 
> significant performance improvements? (Actually, I doubt that I will be 
> more efficient than performing connection tracking in user space)

Quite possible, but some profiles would be useful to determine
whether this is actually the bottleneck.

> Do you think introducing multipart messages for connection tracking 
> events is feasible without breaking existing applications? Maybe with a 
> default setting of 1 bundled events, which can be increased by a 
> function call?

That sounds sane.

> Is someone intending to implement multipart messages for ctevents? ;-)

I don't think so.
