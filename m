From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] ctnetlink: optional reliable event delivery
Date: Fri, 27 Mar 2009 11:12:17 +0100
Message-ID: <49CCA681.2090704@trash.net>
References: <20090327093822.8259.50902.stgit@Decadence> <20090327094031.8259.81782.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56585 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZC0KM1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:12:27 -0400
In-Reply-To: <20090327094031.8259.81782.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch improves ctnetlink event reliability if one broadcast
> listener has set the NETLINK_BROADCAST_ERROR socket option.
> 
> The logic is the following: if the event delivery fails, ctnetlink
> sets IPCT_DELIVERY_FAILED event bit and keep the undelivered
> events in the conntrack event cache. Thus, once the next packet
> arrives, we trigger another event delivery in nf_conntrack_in(). If
> things don't go well in this second try, we accumulate the pending
> events in the cache but we try to deliver the current state as soon
> as possible. Therefore, we may lost state transitions but the
> userspace process gets in sync at some point.

Sounds good so far. Except - this won't work without per-conntrack
events I guess. And those would need (quite a lot of) atomic operations
again.

> At worst case, if no events were delivered to userspace, we make
> sure that destroy events are successfully delivered. This happens
> because if ctnetlink fails to deliver the destroy event, we re-add
> the conntrack timer with an extra grace timeout of 15 seconds to
> trigger the event again (this grace timeout is tunable via /proc).
> 
> If a packet closing the flow (like a TCP RST) kills the conntrack
> entry but the event delivery fails, we drop the packet and keep
> the entry in the kernel. This is the only case in which we may drop
> a packets.

This last two points don't seem like good behaviour at all. The
timeouts are supposed to have a meaning, so they should *at least*
deactivate the conntrack. Explicit removal of the conntrack should
*never* fail. TCP conntrack needs it for connection reopening,
handling out of sync sessions etc.

> For expectations, the logic is more simple, if the event delivery
> fails, we drop the packet.

.. while restoring the expectation to an active state I hope?
