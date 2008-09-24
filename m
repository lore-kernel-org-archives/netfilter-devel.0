From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: add locking for counters zeroing
Date: Wed, 24 Sep 2008 12:27:46 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809241226020.16193@fbirervta.pbzchgretzou.qr>
References: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl> <48DA643C.5000702@trash.net> <alpine.LNX.1.10.0809241206030.16193@fbirervta.pbzchgretzou.qr> <48DA66BE.6090209@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44938 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYIXQ1r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:27:47 -0400
In-Reply-To: <48DA66BE.6090209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-09-24 12:11, Patrick McHardy wrote:
>> On Wednesday 2008-09-24 12:01, Patrick McHardy wrote:
>> > > @@ -545,6 +545,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct
>> > > netlink_callback *cb)
>> > >   u_int8_t l3proto = nfmsg->nfgen_family;
>> > >  
>> > > 	rcu_read_lock();
>> > > +	spin_lock_bh(&nf_conntrack_lock);
>> > We only need the spinlock. I'm not so happy about taking it
>> > unconditionally even though we might not be zeroing the
>> > counters. Moving it in the inner loop will greatly increase
>> > the amount of locks/unlocks on the other hand.
>> >
>> > How about moving the inner loop to a new function and adding
>> > back the ctnetlink_dump_counterzero (or whatever it was called)
>> > function? It would take the spinlock, while normal dumping
>> > would only use rcu_read_lock().
>> 
>> Perhaps this might work?
>> 
>> +	if (cb->args[0] >= nf_conntrack_htable_size) {
>> +		nf_ct_put(cb->args[1]);
>> +		return skb->len;
>> +	}
>
> I'm not sure what you're trying to fix here.

If the for() loop never runs because cb->args<nf_conntrack_htable_size is not
fulfilled, no counter changes, and no locking is needed, hence the early
return.

> Any patch that doesn't include a spin_lock
> can't really fix the problem :)

Of course. You still have to add the spin_lock, preferably outside of the loop
so it does not get necessarily dropped/re-picked-up. But in the case that the
loop never runs, the lock does not need to be taken at all as I see it, 
does it?
