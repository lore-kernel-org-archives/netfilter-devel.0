From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] ctnetlink: optional reliable event delivery
Date: Fri, 27 Mar 2009 13:51:41 +0100
Message-ID: <49CCCBDD.9060301@trash.net>
References: <20090327093822.8259.50902.stgit@Decadence> <20090327094031.8259.81782.stgit@Decadence> <49CCA681.2090704@trash.net> <49CCC776.9060206@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZC0Mvu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:51:50 -0400
In-Reply-To: <49CCC776.9060206@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> This patch improves ctnetlink event reliability if one broadcast
>>> listener has set the NETLINK_BROADCAST_ERROR socket option.
>>>
>>> The logic is the following: if the event delivery fails, ctnetlink
>>> sets IPCT_DELIVERY_FAILED event bit and keep the undelivered
>>> events in the conntrack event cache. Thus, once the next packet
>>> arrives, we trigger another event delivery in nf_conntrack_in(). If
>>> things don't go well in this second try, we accumulate the pending
>>> events in the cache but we try to deliver the current state as soon
>>> as possible. Therefore, we may lost state transitions but the
>>> userspace process gets in sync at some point.
>> Sounds good so far. Except - this won't work without per-conntrack
>> events I guess. And those would need (quite a lot of) atomic operations
>> again.
> 
> Right, we need those extra atomic operations due to the
> nf_conntrack_event_cache() calls. Not a very strong argument but looking
> at the code (with my patch), this function is only called if:
> 
> a) we set the status bits SEEN_REPLY and ASSURED.
> b) we change the connmark or consecmark.
> c) ctnetlink changes some conntrack.
> d) we fail to deliver an event.
> 
> so the extra overhead is only added in those situations. Anyway, do you
> have any clue on how to improve this? I don't see any in this fuzzy
> morning yet.

OK, so its not as bad as I thought. For short-lived connections it
will still be quite significant since we have state transistion at
almost every packet.

I don't have a suggestion for improvement right now.

>>> At worst case, if no events were delivered to userspace, we make
>>> sure that destroy events are successfully delivered. This happens
>>> because if ctnetlink fails to deliver the destroy event, we re-add
>>> the conntrack timer with an extra grace timeout of 15 seconds to
>>> trigger the event again (this grace timeout is tunable via /proc).
>>>
>>> If a packet closing the flow (like a TCP RST) kills the conntrack
>>> entry but the event delivery fails, we drop the packet and keep
>>> the entry in the kernel. This is the only case in which we may drop
>>> a packets.
>> This last two points don't seem like good behaviour at all. The
>> timeouts are supposed to have a meaning, so they should *at least*
>> deactivate the conntrack.
> 
> With "deactivate" you mean that we can keep the conntrack in the hash
> with the timer disabled? I've been thinking about adding a timer to the
> per-conntrack cache extension to trigger event resends instead of using
> the conntrack timer, what do you think about this?
> 
> Another choice can be to set some conntrack flag that tells that this
> entry is deactivated, meaning that is pending for its events to be
> delivered, but it still seem a bit hackish.

Thats what I had in mind. Stopping the timer itself is not really
important, but after it expires, I think we should treat the connection
as gone, meaning we don't associate packets to it. Thats what the user
expects and otherwise we'd also have a (probably mostly theoretical)
case where a connection lives on forever because it always fails to
deliver its events.

OTOH, before we have delivered the DESTROY event, it would be valid
to expect the connection to still be "usable". So we have a bit of
a clash in expectations here.

>> Explicit removal of the conntrack should
>> *never* fail. TCP conntrack needs it for connection reopening,
>> handling out of sync sessions etc.
> 
> Yes, I was aware of that. During my tests - I massively created HTTP
> connections with reliable delivery enabled and setting a very small
> netlink buffer, packets were dropped during connection reopening due to
> failures in the event delivery, thus, reducing performance in this
> situation.

Its not just performance, its usability. If we can't kill the
connection, reopening is not going to work.

> However, I don't see a way to ensure reliable event delivery of destroy
> events without dropping packets to trigger a retransmission in this
> situation.

I think even that doesn't really help. We might never see another packet
and the timer might also fail to deliver the event.

There will always be failure cases. Which implies that we shouldn't
treat our packets and connections too badly because of this.

> Just a wild thought, I don't even look at the netlink code to see how
> feasible this may be, if netlink allows some out-of-band mechanisms for
> "important" messages (like these destroy events), we may prioritize this
> messages over normal create and update messages and the chances to drop
> packets would be reduced.

That would affect message ordering, so in the worst case, you'd see
a DESTROY event before the corresponding CREATE event.

>>> For expectations, the logic is more simple, if the event delivery
>>> fails, we drop the packet.
>> .. while restoring the expectation to an active state I hope?
> 
> By now, with my patch the packet is dropped and we destroy the
> expectation, thus, we trigger a packet retransmission to retry the
> expectation creation.

But the expectation is unlinked from the hash at arrival of
the first packet, unless it is persistent. So it won't exist
when the retransmission arrives.

> This is the best I have done by now, my head has been spinning for the
> last 72 hours (I think that I smell the smoke in here) looking for a
> good solution while getting the reliable event delivery :).

Don't worry, there's a lot of time to get this in shape since the
networking merge window is already closed :)
