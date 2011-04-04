From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter:ipset: References are protected by rwlock
 instead of mutex
Date: Mon, 04 Apr 2011 15:20:23 +0200
Message-ID: <4D99C597.20703@trash.net>
References: <1301049733-32160-1-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-2-git-send-email-kadlec@blackhole.kfki.hu> <1301049733-32160-3-git-send-email-kadlec@blackhole.kfki.hu> <4D908075.1010008@trash.net> <alpine.DEB.2.00.1103281438120.2069@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52108 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1DDNUf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:20:35 -0400
In-Reply-To: <alpine.DEB.2.00.1103281438120.2069@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28.03.2011 15:33, Jozsef Kadlecsik wrote:
> On Mon, 28 Mar 2011, Patrick McHardy wrote:
> 
>> Am 25.03.2011 11:42, schrieb Jozsef Kadlecsik:
>>> The timeout variant of the list:set type must reference the member sets.
>>> However, its garbage collector runs at timer interrupt so the mutex protection
>>> of the references is a no go. Therefore the reference protection
>>> is converted to rwlock.
>>>
>>
>>>  __ip_set_get(ip_set_id_t index)
>>>  {
>>> -	atomic_inc(&ip_set_list[index]->ref);
>>> +	write_lock_bh(&ip_set_ref_lock);
>>> +	ip_set_list[index]->ref++;
>>> +	write_unlock_bh(&ip_set_ref_lock);
>>>  }
>>>  
>>
>> I'm not sure I get this, why aren't regular atomic ops working
>> here?
> 
> A set can only be destroyed if it's not referenced. The reference counter 
> is incremented/decremented by the checkentry/destroy functions of the set 
> match and target, and when the set is added/deleted to/from a list:set 
> type of set. These operations are serialized by the nfnl mutex.
> 
> However sets get deleted from the timeout variant of a list:set types by 
> the garbage collector, too, which runs at timer interrupt. The set 
> destroying happens by first checking the reference counter, then 
> destroying the set without holding any lock. Because the garbage collector 
> only decrements the refcount, we could go without using any rwlock and 
> having atomic refcounts: if the counter is zero, we are safe and can 
> destroy the set.
> 
> But when swapping two sets, the operation swaps the names, reference 
> counters and the pointers of the sets. The values of two atomic counters 
> cannot safely be swapped without holding some kind of lock. So I could not 
> avoid introducing a rwlock to protect the refcounts, but then those are
> not needed to be atomic.

Thanks for the explanation, applied.
