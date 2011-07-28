From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
 (updated again)
Date: Thu, 28 Jul 2011 09:00:40 +0200
Message-ID: <4E310918.2040504@trash.net>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>	<20110718191956.GA2489@p183.telecom.by>	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>	<20110718.124638.30010338187296272.davem@davemloft.net>	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>	<alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr>	<878vruymq6.fsf@sapphire.mobileactivedefense.com>	<87sjq1xab8.fsf_-_@sapphire.mobileactivedefense.com> <87y5zlgtmh.fsf_-_@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57814 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1G1HAn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 03:00:43 -0400
In-Reply-To: <87y5zlgtmh.fsf_-_@sapphire.mobileactivedefense.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.07.2011 13:37, Rainer Weikusat wrote:
> --- nf-2.6/net/netfilter/nfnetlink_log.c	2011-07-25 16:53:41.693829768 +0100
> +++ nf-2.6.patched//net/netfilter/nfnetlink_log.c	2011-07-26 12:06:46.543418699 +0100
> @@ -39,6 +39,9 @@
>  #include "../bridge/br_private.h"
>  #endif
>  
> +#include <net/net_namespace.h>
> +#include <net/netns/generic.h>
> +
>  #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
>  #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
>  #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
> @@ -47,6 +50,15 @@
>  #define PRINTR(x, args...)	do { if (net_ratelimit()) \
>  				     printk(x, ## args); } while (0);
>  
> +#define INSTANCE_BUCKETS	16
> +
> +struct nfulnl_instances {
> +	spinlock_t lock;
> +	atomic_t global_seq;
> +	struct hlist_head table[INSTANCE_BUCKETS];
> +	struct net *net;
> +};
> +
>  struct nfulnl_instance {
>  	struct hlist_node hlist;	/* global list of instances */
>  	spinlock_t lock;
> @@ -67,14 +79,39 @@ struct nfulnl_instance {
>  	u_int16_t flags;
>  	u_int8_t copy_mode;
>  	struct rcu_head rcu;
> +	struct nfulnl_instances *instances;
>  };
>  
> -static DEFINE_SPINLOCK(instances_lock);
> -static atomic_t global_seq;
> +static struct nfulnl_instances *instances;
> +static int nfulnl_net_id;
>  
> -#define INSTANCE_BUCKETS	16
> -static struct hlist_head instance_table[INSTANCE_BUCKETS];
> -static unsigned int hash_init;
> +#ifdef CONFIG_NET_NS
> +static inline struct nfulnl_instances *instances_for_net(struct net *net)
> +{
> +	return net_generic(net, nfulnl_net_id);
> +}
> +#else
> +static inline struct nfulnl_instances *instances_for_net(struct net *net)
> +{
> +	return instances;
> +}
> +#endif

We use net_generic unconditionally everywhere else, there's no reason
for nfnetlink_log not to.

> +static struct nfulnl_instances *instances_via_skb(struct sk_buff const *skb)
> +{
> +	struct net *net;
> +
> +	net = skb->sk ? sock_net(skb->sk) :
> +		(skb->dev ? dev_net(skb->dev) : &init_net);

You don't need to manually handle init_net, the *_net functions will
do the right thing. Also the common case is that skb->dev is non-NULL,
I'd suggest to use dev_net(skb->dev ? skb->dev : skb_dst(skb)->dev).

This function is also only used once and doesn't really make things
easier to read, please get rid of it and open code.

> +
> +	return instances_for_net(net);
> +}
> +
> +static inline struct net *inst_net(struct nfulnl_instance *inst)
> +{
> +	return read_pnet(&inst->instances->net);
> +
> +}

Only used once, please get rid of it.


>  static struct nfulnl_instance *
> -instance_lookup_get(u_int16_t group_num)
> +instance_lookup_get(struct nfulnl_instances *instances, u_int16_t group_num)

I'd suggest to pass the net * pointer to this function instead of doing
the lookup in the calling functions. Should save a bit of code and also
is a more common pattern used with namespaces.

>  {
>  	struct nfulnl_instance *inst;
>  
> +	if (!instances)
> +		return NULL;
> +
>  	rcu_read_lock_bh();
> -	inst = __instance_lookup(group_num);
> +	inst = __instance_lookup(instances, group_num);
>  	if (inst && !atomic_inc_not_zero(&inst->use))
>  		inst = NULL;
>  	rcu_read_unlock_bh();
> @@ -132,13 +172,14 @@ instance_put(struct nfulnl_instance *ins
>  static void nfulnl_timer(unsigned long data);
>  
>  static struct nfulnl_instance *
> -instance_create(u_int16_t group_num, int pid)
> +instance_create(struct nfulnl_instances *instances,
> +		u_int16_t group_num, int pid)

Same here.

>  {
>  	struct nfulnl_instance *inst;
>  	int err;
>  
> -	spin_lock_bh(&instances_lock);
> -	if (__instance_lookup(group_num)) {
> +	spin_lock_bh(&instances->lock);
> +	if (__instance_lookup(instances, group_num)) {
>  		err = -EEXIST;
>  		goto out_unlock;
>  	}
>  
> @@ -208,11 +250,12 @@ __instance_destroy(struct nfulnl_instanc
>  }
>  
>  static inline void
> -instance_destroy(struct nfulnl_instance *inst)
> +instance_destroy(struct nfulnl_instances *instances,
> +		struct nfulnl_instance *inst)

And here.

>  {
> -	spin_lock_bh(&instances_lock);
> +	spin_lock_bh(&instances->lock);
>  	__instance_destroy(inst);
> -	spin_unlock_bh(&instances_lock);
> +	spin_unlock_bh(&instances->lock);
>  }
>  
>  static int

> @@ -862,17 +914,27 @@ static const struct nfnetlink_subsystem
>  
>  #ifdef CONFIG_PROC_FS
>  struct iter_state {
> +	struct nfulnl_instances *instances;
>  	unsigned int bucket;
>  };
>  
> +static inline struct nfulnl_instances *instances_for_seq(void)
> +{
> +	return instances_for_net(&init_net);
> +}

Also used only once and hides the fact that we're only handling
init_net. Please remove and open code.

> -static int __init nfnetlink_log_init(void)
> +static int nfulnl_net_init(struct net *net)
>  {
> -	int i, status = -ENOMEM;
> +	struct nfulnl_instances *insts;
> +	int i;
>  
> -	for (i = 0; i < INSTANCE_BUCKETS; i++)
> -		INIT_HLIST_HEAD(&instance_table[i]);
> +	insts = net_generic(net, nfulnl_net_id);
> +	insts->net = net;
> +	spin_lock_init(&insts->lock);
> +
> +	i = INSTANCE_BUCKETS;
> +	do INIT_HLIST_HEAD(insts->table + --i); while (i);

Don't put this on one line and please choose a slightly
more readable construct than + --i while (i).

> +
> +	/* avoid 'runtime' net_generic for 'no netns' */
> +	instances = insts;
> +	return 0;
> +}

