From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 14:27:21 +0200
Message-ID: <4A2FA6A9.2090709@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net> <4A2EE907.70609@netfilter.org> <4A2F09D9.7090507@gmail.com> <4A2F830C.9020403@trash.net> <4A2F8CC7.2010708@netfilter.org> <4A2F9120.9010904@trash.net> <4A2F9289.6000502@trash.net> <4A2F9BB8.8020701@trash.net> <4A2FA56D.4090105@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017AbZFJM1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:27:23 -0400
In-Reply-To: <4A2FA56D.4090105@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> This is a first attempt to replace some global locks by private
>> per conntrack locks. On 64 bit, it fits into a hole and doesn't
>> enlarge struct nf_conn.
>>
>> Wrt. to the event cache, we certainly don't want to take and release
>> the lock for every event. I was thinking about something like this:
>>
>> - add a new member to the event structure to hold undelivered events
>>   (named "missed" below)
>> - cache events in the existing member as you're doing currently
>> - on delivery, do something like this:
>>
>>     events = xchg(&e->cache, 0);
>>     missed = e->missed;
>                ^^^
> I think that we need to take the lock since we read e->missed, I see
> this possible issue:
> 
> CPU0 gets a copy of the missed events (without taking the lock)
> CPU1 has already delivered the missed events, it clears them
> CPU0 delivers missed events that were already delivered by CPU1.

Indeed, I forgot to mention that. Its harmless though, no?

>>     ret = notify->fcn(events | missed, &item);
>>     if (!success || missed) {
>>         spin_lock_bh(&ct->lock);
>>         if (!success)
>>             e->missed |= events;
>>         else
>>             e->missed &= ~missed;
>>         spin_unlock_bh(&ct->lock);
>>     }
>>
>> so if we failed to deliver the events, we add them to the missed
>> events for the next delivery attempt. Once we've delivered the
>> missed events, we clear them from the cache.
>>
>> Now is that really better - I'm not sure myself :) The per-conntrack
>> locking would be an improvement though. What do you think?
> 
> Indeed, I also think that the per-conntrack locking would be an
> improvement for the protocol helpers.
> 
> wrt. the event cache, the missed field can save us from doing the
> locking in every event caching at the cost of consuming a bit more of
> memory. I think this is more conservative but safer than my approach (no
> potential defering by calling cmpxchg forever, even if it's unlikely).
> Still, we would need to take the spin lock for the event delivery. Let
> me know what you think.

Would we really have to? The events are incremental anyways, so
it shouldn't matter if we very rarely deliver an event twice.


