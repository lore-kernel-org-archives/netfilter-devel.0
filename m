From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ctnetlink: optional packet drop to make event delivery
 reliable
Date: Tue, 24 Mar 2009 14:50:12 +0100
Message-ID: <49C8E514.2010205@trash.net>
References: <20090324110706.13981.24167.stgit@Decadence> <49C8DE75.1050109@trash.net> <49C8E312.5060005@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34398 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZCXNuV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:50:21 -0400
In-Reply-To: <49C8E312.5060005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Pablo Neira Ayuso wrote:
>>> diff --git a/include/net/netfilter/nf_conntrack_core.h
>>> b/include/net/netfilter/nf_conntrack_core.h
>>> index 5a449b4..98078b2 100644
>>> --- a/include/net/netfilter/nf_conntrack_core.h
>>> +++ b/include/net/netfilter/nf_conntrack_core.h
>>> @@ -62,8 +62,11 @@ static inline int nf_conntrack_confirm(struct
>>> sk_buff *skb)
>> What tree is this against? I get reject in my nf-next tree.
> 
> net-next.git with some patches that you passed to 2.6.29 which are not
> in your tree yet. I was aware of this but I didn't know how to proceed
> exactly in this situation.

Patches should always apply cleanly to the tree they're submitted
against. If conflicts occur, they're best handled during merging
(IOW: myself or Dave will take care of them). Alternatively you
can ask me to pull in Dave's latest tree before diffing against mine
in case the patch causing the conflict is already present there.

>>>      if (ct && ct != &nf_conntrack_untracked) {
>>>          if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
>>>              ret = __nf_conntrack_confirm(skb);
>>> -        if (likely(ret == NF_ACCEPT))
>>> -            nf_ct_deliver_cached_events(ct);
>>> +        if (likely(ret == NF_ACCEPT) &&
>>> +            nf_ct_deliver_cached_events(ct) < 0) {
>> The combined condition is unlikely I'd say. My main question though:
>> how does this make event delivery reliable? It will drop the packet,
>> fine, but all state changes have already been performed, new connections
>> have been confirmed, etc.
> 
> Indeed. This is patch is missing some flag in the conntrack that I could
> set to send the event once the packet is retransmitted.

But it seems rather pointless to add it in this state, it doesn't
increase reliability one bit. Additionally reversing the order of
state transitions and event delivery seems like a highly intrusive
change since event delivery obviously already needs to know the
new state, meaning we'd need to record all state changes, then
deliver the event, then "commit" them. So I'd like to see what
we're engaging in before merging this half finished patch.

