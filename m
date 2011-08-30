From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] netfilter: nat: work around shared nfct struct in
 bridge case
Date: Tue, 30 Aug 2011 16:07:56 +0200
Message-ID: <4E5CEEBC.8090305@trash.net>
References: <1314710938-25342-1-git-send-email-fw@strlen.de> <4E5CE92B.2010006@trash.net> <20110830140013.GF7548@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1H3OID (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:08:03 -0400
In-Reply-To: <20110830140013.GF7548@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30.08.2011 16:00, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>> On 30.08.2011 15:28, Florian Westphal wrote:
>>> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
>>> index 9c71b27..bd89744 100644
>>> --- a/net/ipv4/netfilter/nf_nat_core.c
>>> +++ b/net/ipv4/netfilter/nf_nat_core.c
>>> @@ -265,6 +265,35 @@ out:
>>>  	rcu_read_unlock();
>>>  }
>>>  
>>> +/* bridge netfilter uses cloned skbs when forwarding to multiple bridge ports.
>>> + * when userspace queueing is involved, we might try to set up NAT bindings
>>> + * on the same conntrack simultaneoulsy.  Can happen e.g. when broadcast has
>>> + * to be forwarded by the bridge but is also passed up the stack.
>>> + *
>>> + * Thus, when bridge netfilter is enabled, we need to serialize and silently
>>> + * accept the packet in the collision case.
>>> + */
>>> +static inline bool nf_nat_bridge_lock(struct nf_conn *ct, enum nf_nat_manip_type maniptype)
>>> +{
>>> +#ifdef CONFIG_BRIDGE_NETFILTER
>>> +	spin_lock_bh(&ct->lock);
>>> +
>>> +	if (unlikely(nf_nat_initialized(ct, maniptype))) {
>>> +		pr_debug("race with cloned skb? Not adding NAT extension\n");
>>> +		spin_unlock_bh(&ct->lock);
>>> +		return false;
>>> +	}
>>> +#endif
>>> +	return true;
>>> +}
>>
>> Ugh, what beauty :) I can't see a much nicer way how to fix this right
>> now, but I really want to have another look for different possibilities
>> before applying this.
> 
> Sure.  In fact, I really hope that this patch isn't needed :)
> 
>> Unfortunately pushing this down to nf_nat_setup_info() could only fix
>> the BUG(), but we'd still have a possible memory leak when adding the
>> NAT extension simulaneously on multiple CPUs.
> 
> nf_ct_ext_add() is only invoked once due to the spinlock serialization,
> so I don't see why we can memleak here.

Yes, when using your patch, otherwise (when handling this case in
nf_nat_setup_info() we might invoke it multiple times simultaneously
though.

> In case nf_ct_ext_add() we already return NF_ACCEPT, so I think this
> part is OK.
> 
>> I also fear this is not
>> going to be the only problem caused by breaking the "unconfirmed means
>> non-shared nfct" assumption.
> 
> Agreed. Perhaps we can solve the module dependeny issue of the "unshare"
> approach.  In fact, if invalid state for the clones would be acceptable
> then the dependency should go away; AFAICS nf_conntrack_untracked is the
> only nf-related symbol required by br_netfilter.o not in netfilter/core.c.

I don't think the clones should have invalid state, even untracked is
very questionable since all packets should have NAT applied to them in
the same way, connmarks might be used etc.

We probably need to restore the above mentioned assumption somehow. One
way would be to serialize reinjection of packets belonging to
unconfirmed conntracks in nf_reinject or the queueing modules. Conntrack
related stuff doesn't really belong there, but it seems like the easiest
and safest fix to me.
