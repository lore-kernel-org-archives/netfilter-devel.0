From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] ctnetlink: optional reliable event delivery
Date: Mon, 30 Mar 2009 13:22:17 +0200
Message-ID: <49D0AB69.20205@netfilter.org>
References: <20090327093822.8259.50902.stgit@Decadence> <20090327094031.8259.81782.stgit@Decadence> <49CCA681.2090704@trash.net> <49CCC776.9060206@netfilter.org> <49CCCBDD.9060301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50126 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758012AbZC3LW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:22:27 -0400
In-Reply-To: <49CCCBDD.9060301@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
>>>> At worst case, if no events were delivered to userspace, we make
>>>> sure that destroy events are successfully delivered. This happens
>>>> because if ctnetlink fails to deliver the destroy event, we re-add
>>>> the conntrack timer with an extra grace timeout of 15 seconds to
>>>> trigger the event again (this grace timeout is tunable via /proc).
>>>>
>>>> If a packet closing the flow (like a TCP RST) kills the conntrack
>>>> entry but the event delivery fails, we drop the packet and keep
>>>> the entry in the kernel. This is the only case in which we may drop
>>>> a packets.
>>> This last two points don't seem like good behaviour at all. The
>>> timeouts are supposed to have a meaning, so they should *at least*
>>> deactivate the conntrack.
>>
>> With "deactivate" you mean that we can keep the conntrack in the hash
>> with the timer disabled? I've been thinking about adding a timer to the
>> per-conntrack cache extension to trigger event resends instead of using
>> the conntrack timer, what do you think about this?
>>
>> Another choice can be to set some conntrack flag that tells that this
>> entry is deactivated, meaning that is pending for its events to be
>> delivered, but it still seem a bit hackish.
> 
> Thats what I had in mind. Stopping the timer itself is not really
> important, but after it expires, I think we should treat the connection
> as gone, meaning we don't associate packets to it. Thats what the user
> expects and otherwise we'd also have a (probably mostly theoretical)
> case where a connection lives on forever because it always fails to
> deliver its events.

I'm going to send you another patchset including these changes.
Basically, I added the "dying list" which contains inactive conntracks
whose destroy event was not delivered. Thus, we keep them out of the
hashes but the nf_conntrack_count applies to them to limit the number of
conntrack entries.

> There will always be failure cases. Which implies that we shouldn't
> treat our packets and connections too badly because of this.

Hm, I think I'm getting your point, you don't want any packet drop :)

>>>> For expectations, the logic is more simple, if the event delivery
>>>> fails, we drop the packet.
>>> .. while restoring the expectation to an active state I hope?
>>
>> By now, with my patch the packet is dropped and we destroy the
>> expectation, thus, we trigger a packet retransmission to retry the
>> expectation creation.
> 
> But the expectation is unlinked from the hash at arrival of
> the first packet, unless it is persistent. So it won't exist
> when the retransmission arrives.

I think you're refering to the related connection. If the packet is drop
for the master connection that creates the expectation (and we destroy
the expectation whose event was not delivered), the retry will create
the expectation again. Anyway, I get your point, we have to avoid packet
drops.

I'm going to send you another patchset so we can discuss on it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
