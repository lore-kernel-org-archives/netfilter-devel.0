From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c (updated again)
Date: Thu, 28 Jul 2011 20:56:03 +0100
Message-ID: <87fwlqch7w.fsf@sapphire.mobileactivedefense.com>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	<20110718191956.GA2489@p183.telecom.by>
	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
	<alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr>
	<878vruymq6.fsf@sapphire.mobileactivedefense.com>
	<87sjq1xab8.fsf_-_@sapphire.mobileactivedefense.com>
	<87y5zlgtmh.fsf_-_@sapphire.mobileactivedefense.com>
	<4E310918.2040504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rainer Weikusat <rweikusat@mobileactivedefense.com>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:46877 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1G1T4N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 15:56:13 -0400
In-Reply-To: <4E310918.2040504@trash.net> (Patrick McHardy's message of "Thu\, 28 Jul 2011 09\:00\:40 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> writes:
> On 26.07.2011 13:37, Rainer Weikusat wrote:

[...]

>> +static inline struct nfulnl_instances *instances_for_net(struct net *net)
>> +{
>> +	return net_generic(net, nfulnl_net_id);
>> +}
>> +#else
>> +static inline struct nfulnl_instances *instances_for_net(struct net *net)
>> +{
>> +	return instances;
>> +}
>> +#endif
>
> We use net_generic unconditionally everywhere else, there's no reason
> for nfnetlink_log not to.

I don't really care for the non-netns per-packet overhead, at least
not at the moment, so that's fine with me.

>>> +static struct nfulnl_instances *instances_via_skb(struct sk_buff const *skb)
>> +{
>> +	struct net *net;
>> +
>> +	net = skb->sk ? sock_net(skb->sk) :
>> +		(skb->dev ? dev_net(skb->dev) : &init_net);
>
> You don't need to manually handle init_net, the *_net functions will
> do the right thing.

The code of dev_net is

	static inline
	struct net *dev_net(const struct net_device *dev)
	{
	        return read_pnet(&dev->nd_net);
	}

and read_pnet is

	static inline struct net *read_pnet(struct net * const *pnet)
	{
	        return *pnet;
	}

consequently, this will happily derefences an invalid pointer (namely
0 + offsetof(struct net_device, nd_net).         

> I'd suggest to use dev_net(skb->dev ? skb->dev : skb_dst(skb)->dev).

I've checked that this should actually work and changed the code
accordingly.

> This function is also only used once and doesn't really make things
> easier to read, please get rid of it and open code.

Open-coded, this looks like this:

	inst = instance_lookup_get(instances_for_net(
					dev_net(skb->dev ?
						skb->dev : skb_dst(skb)->dev)),
				li->u.ulog.group);

and I disagree with the assessment that 'helper functions with
descriptive names' should be avoided, especially since they are free
(and I'm just quoting CodingStyle.txt because I happen to agree with
this opinion).

>>  static struct nfulnl_instance *
>> -instance_lookup_get(u_int16_t group_num)
>> +instance_lookup_get(struct nfulnl_instances *instances, u_int16_t group_num)
>
> I'd suggest to pass the net * pointer to this function instead of doing
> the lookup in the calling functions. Should save a bit of code and also
> is a more common pattern used with namespaces.

It actually requires more code because the instances_for_net/
net_generic code then needs to appear in __instance_lookup,
instance_create and instances_destroy while it is presently only once
in nfulnl_recv_config. The really ugly one would be _create which
would need to lookup the per-netns instances table and pass the struct
net * on to a function called by it so that this function can do the
same lookup again.

[...]

>> -static int __init nfnetlink_log_init(void)
>> +static int nfulnl_net_init(struct net *net)
>>  {
>> -	int i, status = -ENOMEM;
>> +	struct nfulnl_instances *insts;
>> +	int i;
>>  
>> -	for (i = 0; i < INSTANCE_BUCKETS; i++)
>> -		INIT_HLIST_HEAD(&instance_table[i]);
>> +	insts = net_generic(net, nfulnl_net_id);
>> +	insts->net = net;
>> +	spin_lock_init(&insts->lock);
>> +
>> +	i = INSTANCE_BUCKETS;
>> +	do INIT_HLIST_HEAD(insts->table + --i); while (i);
>
> Don't put this on one line and please choose a slightly
> more readable construct than + --i while (i).

I also disagree with the assessment that the clumsy

	for (i = 0; i < INSTANCE_BUCKETS; ++i)
		INIT_HLIST_HEAD(&insts->table[i]);

is inherently more 'readable' than a variant which uses features that
are available in C (but not in Pascal. Oh dear ...) in order to
express the algorithm which is actually needed in a more direct way.
But if in Rome ...

I've changed the code as you suggested, except distributing
net_generic/ instances_for_net calls all over the file instead of
doing this once in an upper layer function. Please feel to drop this
on the floor until someone with more 'Linux kernel street credibility'
reimplements it. I need this to work. I don't need my name in the
kernel changelog. I've made a copy of it available in order to be
'nice to others', since this seemed the right thing to do but I cannot
(and won't) spend an eternity on doing practical penance for the fact
that the way I use C (and structure code) is different from the way
you use C (and structure code).
