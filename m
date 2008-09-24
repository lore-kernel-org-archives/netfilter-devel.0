From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add locking for counters zeroing
Date: Wed, 24 Sep 2008 18:11:42 +0200
Message-ID: <48DA66BE.6090209@trash.net>
References: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl> <48DA643C.5000702@trash.net> <alpine.LNX.1.10.0809241206030.16193@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41315 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYIXQLr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:11:47 -0400
In-Reply-To: <alpine.LNX.1.10.0809241206030.16193@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-09-24 12:01, Patrick McHardy wrote:
>>> @@ -545,6 +545,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct
>>> netlink_callback *cb)
>>>   u_int8_t l3proto = nfmsg->nfgen_family;
>>>  
>>> 	rcu_read_lock();
>>> +	spin_lock_bh(&nf_conntrack_lock);
>> We only need the spinlock. I'm not so happy about taking it
>> unconditionally even though we might not be zeroing the
>> counters. Moving it in the inner loop will greatly increase
>> the amount of locks/unlocks on the other hand.
>>
>> How about moving the inner loop to a new function and adding
>> back the ctnetlink_dump_counterzero (or whatever it was called)
>> function? It would take the spinlock, while normal dumping
>> would only use rcu_read_lock().
> 
> Perhaps this might work?
> 
> +	if (cb->args[0] >= nf_conntrack_htable_size) {
> +		nf_ct_put(cb->args[1]);
> +		return skb->len;
> +	}

I'm not sure what you're trying to fix here. Its a race
between counter zeroing and changing them during packet
processing. Any patch that doesn't include a spin_lock
can't really fix the problem :)
