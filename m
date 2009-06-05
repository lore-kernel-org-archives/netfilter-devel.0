From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: conntrack: move event cache to conntrack
 extension infrastructure
Date: Fri, 05 Jun 2009 16:13:47 +0200
Message-ID: <4A29281B.6010607@trash.net>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110818.6702.51833.stgit@Decadence> <4A28FBCB.4070100@trash.net> <4A291863.4090604@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58920 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZFEONt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:13:49 -0400
In-Reply-To: <4A291863.4090604@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>>>
>>> -    /* New conntrack */
>>> -    IPCT_NEW_BIT = 0,
>>> -    IPCT_NEW = (1 << IPCT_NEW_BIT),
>>> -
>>> -...
>>> +    IPCT_NEW        = 0,    /* new conntrack */
>>
>> Why this change? Further down, you change the code to use
>> (1 << IPCT_*), which isn't really an improvement.
>
> Oh, this is not intended to be an improvement. I needed to change this 
> to use bitopts operations, that's all. Or I could use IPCT_*_BIT and 
> change every reference to this in the whole conntrack table, but the 
> patch would be much bigger and noisy :).

The major part is in ctnetlink I think, and you do seem to touch every
one of them :) But OK, using _BIT for all the events doesn't seem too
appealing either.

>>> +
>>> +    e = nf_ct_ecache_find(ct);
>>> +    if (e == NULL)
>>> +        return;
>>> +
>>> +    set_bit(event, &e->cache);
>>
>> This looks quite expensive, given how often this operation is performed.
>> Did you benchmark this?
>
> I'll do that benchmark. I was initially using nf_conntrack_lock to 
> protect the per-conntrack event cache, I think that use bitops is a 
> bit better?

I actually meant the lookup done potentially multiple times per packet.
But I incorrectly thought that it was more expensive, that seems fine.

>>> @@ -8,12 +8,14 @@ enum nf_ct_ext_id
>>>      NF_CT_EXT_HELPER,
>>>      NF_CT_EXT_NAT,
>>>      NF_CT_EXT_ACCT,
>>> +    NF_CT_EXT_ECACHE,
>>>      NF_CT_EXT_NUM,
>>
>> Quoting nf_conntrack_extend.c:
>>
>> /* This assumes that extended areas in conntrack for the types
>>    whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
>>
>> Is that actually the case here? It might be beneficial to move
>> this before accounting if possible, I guess its used more often.
>
> I think that accounting information is updated more often. Events are 
> only updated for very few packet specifically the setup and the 
> tear-down packets of a flow.

No, events are only sent to userspace every seldom. But f.i. TCP
conntrack generates at least one event per packet.

But what I actually meant was that its used more often I think.
Never mind, also forget about the PREALLOC question, I should
have read what I pasted :) Of course you could add the PREALLOC
flag, when events are enabled you add the extension for every
conntrack anyways.

>>> @@ -738,6 +739,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, 
>>> unsigned int hooknum,
>>>  
>>>      NF_CT_ASSERT(skb->nfct);
>>>  
>>> +    /* We may have pending events, deliver them and clear the cache */
>>> +    nf_ct_deliver_cached_events(ct);
>>
>> How does this guarantee that an event will be delivered in time?
>> As far as I can see, it might never be delivered, or at least not
>> until a timeout occurs.
>
> Yes, that's the idea. In short, if we have cached events, we trigger a 
> delivery via ctnetlink. If the delivery fails, we keep the cached 
> events and the next packet will trigger a new delivery. We can lose 
> events but at worse case, the destroy will be delivered.

OK, so this is essentially replacing the delivery we did previously when
beginning to cache events for a different conntrack. Thats fine and 
necessary
in case a packet triggering an event didn't made it past POST_ROUTING.

>
> If we add a new conntrack extension to store the creation and 
> destruction time of the conntrack entries, we can have reliable 
> flow-accouting since, at least, the destroy event will be delivered. 
> In the case of the state synchronization, we aim to ensure that 
> long-standing flows survive failures, thus, under event loss, the 
> backup nodes would gett the state after some tries, specially for 
> long-standing flows since every packet would trigger another delivery 
> in case of problems.

*conntrackd* aims at that I think :) Anyways, on second - third thought, I
agree that this is fine, the previous guarantees weren't any stronger.

>
> BTW, I have removed that line locally. So the next delivery try for 
> pending events is done only in nf_conntrack_confirm(), not twice, one 
> in nf_conntrack_in() and nf_conntrack_confirm() as it happens in this 
> patch.

That means we're only delivering events if a packet actually made
it through. I guess this is fine too, ideally we wouldn't even have
state transistions.

>>> @@ -1123,6 +1123,8 @@ ctnetlink_change_conntrack(struct nf_conn *ct, 
>>> struct nlattr *cda[])
>>>          err = ctnetlink_change_helper(ct, cda);
>>>          if (err < 0)
>>>              return err;
>>> +
>>> +        nf_conntrack_event_cache(IPCT_HELPER, ct);
>>
>> Why are we suddenly caching a lot more events manually?
>
> Currently, in user-space triggered events, we are including in the 
> event message some fields that may not have been updated. Now we can 
> provide more accurante events by notifying only the conntrack object 
> fields that have been updated.
>
The patch is already pretty large, please seperate that part if
doesn't has to be in this patch to make it work.

