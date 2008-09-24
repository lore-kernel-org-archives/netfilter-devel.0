From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add locking for counters zeroing
Date: Wed, 24 Sep 2008 18:42:41 +0200
Message-ID: <48DA6E01.2020101@trash.net>
References: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl> <48DA643C.5000702@trash.net> <alpine.LNX.1.10.0809241206030.16193@fbirervta.pbzchgretzou.qr> <48DA66BE.6090209@trash.net> <alpine.LNX.1.10.0809241226020.16193@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42075 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXQnG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:43:06 -0400
In-Reply-To: <alpine.LNX.1.10.0809241226020.16193@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-09-24 12:11, Patrick McHardy wrote:
>   
>>> On Wednesday 2008-09-24 12:01, Patrick McHardy wrote:
>>>       
>>>>> @@ -545,6 +545,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct
>>>>> netlink_callback *cb)
>>>>>   u_int8_t l3proto = nfmsg->nfgen_family;
>>>>>  
>>>>> 	rcu_read_lock();
>>>>> +	spin_lock_bh(&nf_conntrack_lock);
>>>>>           
>>>> We only need the spinlock. I'm not so happy about taking it
>>>> unconditionally even though we might not be zeroing the
>>>> counters. Moving it in the inner loop will greatly increase
>>>> the amount of locks/unlocks on the other hand.
>>>>
>>>> How about moving the inner loop to a new function and adding
>>>> back the ctnetlink_dump_counterzero (or whatever it was called)
>>>> function? It would take the spinlock, while normal dumping
>>>> would only use rcu_read_lock().
>>>>         
>>> Perhaps this might work?
>>>
>>> +	if (cb->args[0] >= nf_conntrack_htable_size) {
>>> +		nf_ct_put(cb->args[1]);
>>> +		return skb->len;
>>> +	}
>>>       
>> I'm not sure what you're trying to fix here.
>>     
>
> If the for() loop never runs because cb->args<nf_conntrack_htable_size is not
> fulfilled, no counter changes, and no locking is needed, hence the early
> return.
>   
Thats a very rare condition and not something worth optimizing for.


>> Any patch that doesn't include a spin_lock
>> can't really fix the problem :)
>>     
>
> Of course. You still have to add the spin_lock, preferably outside of the loop
> so it does not get necessarily dropped/re-picked-up.

Yes, but even more preferrably is don't huring normal dumps for counter 
zeroing.
So I think we should split the operations.
