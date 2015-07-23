From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH nf-next] netfilter: nf_queue: fix deadlock in nf_queue_nf_hook_drop()
Date: Thu, 23 Jul 2015 07:11:31 -0500
Message-ID: <87io9baxak.fsf@x220.int.ebiederm.org>
References: <1437391024-3141-1-git-send-email-pablo@netfilter.org>
	<871tg0ez4b.fsf@x220.int.ebiederm.org> <20150723103452.GA3740@salvia>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:56060 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbGWMSC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2015 08:18:02 -0400
In-Reply-To: <20150723103452.GA3740@salvia> (Pablo Neira Ayuso's message of
	"Thu, 23 Jul 2015 12:34:52 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Wed, Jul 22, 2015 at 03:06:12PM -0500, Eric W. Biederman wrote:
> [...]
>> This  code can be simplifed to:
>> 
>> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
>> index 4ab256824f5f..d002284e443b 100644
>> --- a/net/netfilter/nf_queue.c
>> +++ b/net/netfilter/nf_queue.c
>> @@ -113,8 +113,7 @@ void nf_queue_nf_hook_drop(struct nf_hook_ops *ops)
>>  	rcu_read_lock();
>>  	qh = rcu_dereference(queue_handler);
>>  	if (qh) {
>> 		for_each_net_rcu(net)
>>  			qh->nf_hook_drop(net, ops);
>>  	}
>>  	rcu_read_unlock();
>> 
>> In this particular case for_each_net_rcu is safe because:
>> 
>> - We don't care about new network namespaces that are added to the list
>>   as it is walked as the nf_hook_ops are no longer registered, so 
>>   they will not accumulate.
>> 
>> - We don't care about about network namespaces leaving the list as it
>>   is walked as they ultimately call instance_destroy_rcu and clean
>>   up their queues even if the drop hook is not called.
>> 
>> This matters as nf_unregister_net_hook can call nf_queue_nf_hook_drop
>> without the rtnl_lock held when it is called from say nftables directly
>> instead of from nf_unregister_hook.
>
> Just noticed, nf_unregister_net_hook() should only destroy the queue
> for this netns, not for every netns. I'm going to send a v2 to fix
> nf_queue_nf_hook_drop().

Good point, and that really cleans things up.

> BTW, on a different front, I don't see at this moment an easy way to
> get rid of the rtnl_lock dependency through for_each_net_rcu() from
> nf_register_hook(). We may skip new netns instances that are just
> being added as the list is walked. Unless you have any better idea, we
> will have to go back to the patches that propagate the complexity to
> hook clients at some point if we need to skip the rtnl_lock
> dependency.

At this point I don't see anything that suggests we need to get rid of
the rtnl_lock.  We just don't want to take it twice!

With the nf_hook_drop change all of the logic except for the
compatibility code is rtnl_lock free, and ought to stay that way.  So I
think we are good.

If it comes up later that taking the rtnl_lock is a problem we can
convert everything to use nf_register_net_hook and
nf_unregister_net_hook.  With the structure allocation performed in
those two functions the change is mostly code motion.

Eric
