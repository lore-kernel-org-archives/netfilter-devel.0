From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: BUG: NFLOG not working in the container.
Date: Wed, 19 Dec 2012 02:32:24 +0100
Message-ID: <20121219013224.GA20720@1984>
References: <50D0B6F5.1080408@guap.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Vitaly E. Lavrov" <lve@guap.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab2LSBcb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:32:31 -0500
Content-Disposition: inline
In-Reply-To: <50D0B6F5.1080408@guap.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 18, 2012 at 10:33:25PM +0400, Vitaly E. Lavrov wrote:
> Eighteen months ago, in linux-kernel@ discussed patch
> "[PATCH] netfilter: add per-namespace logging to nfnetlink_log.c"
> 
> Author: Rainer Weikusat <rweikusat [at] mobileactivedefense>
> 
> Why patch for nflog was not accepted in kernel ?

If a patch does not reach nf-devel / netdev, then it becomes very
likely to pass overlooked.

> After applying the patch "NFLOG" works in the container. Tested on
> kernel version 3.4.22.

Now it's on my radar. It seems good at quick glance apart from some
minor comestic issues.

The merge window is closed, I only take fixes at this stage, so I'll
check back this once it becomes open again.

Thanks.

> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 66b2c54..23a1c16 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -39,6 +39,10 @@
>  #include "../bridge/br_private.h"
>  #endif
>  
> +#include <net/net_namespace.h>
> +#include <net/netns/generic.h>
> +
> +
>  #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
>  #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
>  #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
> @@ -47,6 +51,16 @@
>  #define PRINTR(x, args...)	do { if (net_ratelimit()) \
>  				     printk(x, ## args); } while (0);
>  
> +#define INSTANCE_BUCKETS 16
> +
> +struct nfulnl_instances {
> +	spinlock_t lock;
> +	atomic_t global_seq;
> +	struct hlist_head table[INSTANCE_BUCKETS];
> +	struct net *net;
> +};
> +
> +
>  struct nfulnl_instance {
>  	struct hlist_node hlist;	/* global list of instances */
>  	spinlock_t lock;
> @@ -67,14 +81,45 @@ struct nfulnl_instance {
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
> +
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
> +
> +static struct nfulnl_instances *instances_via_skb(struct sk_buff const *skb)
> +{
> + static struct net *dummy_pnet __maybe_unused;
> + struct net *net;
> +
> + /*
> + * The multiway conditional needs to be inside the
> + * read_pnet argument list because that is a no-op for
> + * the 'no netns' case and gcc will then [hopefully]
> + * remove it as 'dead code' (at least 4.4.5 does).
> + */
> +	net = read_pnet(skb->sk ? &skb->sk->sk_net :
> +		(skb->dev ? &skb->dev->nd_net : &dummy_pnet));
> +	return net ? instances_for_net(net) : NULL;
> +}
> +
> +static inline struct net *inst_net(struct nfulnl_instance *inst)
> +{
> + return read_pnet(&inst->instances->net);
> +}
>  
>  static inline u_int8_t instance_hashfn(u_int16_t group_num)
>  {
> @@ -82,13 +127,13 @@ static inline u_int8_t instance_hashfn(u_int16_t group_num)
>  }
>  
>  static struct nfulnl_instance *
> -__instance_lookup(u_int16_t group_num)
> +__instance_lookup(struct nfulnl_instances *instances, u_int16_t group_num)
>  {
>  	struct hlist_head *head;
>  	struct hlist_node *pos;
>  	struct nfulnl_instance *inst;
>  
> -	head = &instance_table[instance_hashfn(group_num)];
> +	head = &instances->table[instance_hashfn(group_num)];
>  	hlist_for_each_entry_rcu(inst, pos, head, hlist) {
>  		if (inst->group_num == group_num)
>  			return inst;
> @@ -103,12 +148,14 @@ instance_get(struct nfulnl_instance *inst)
>  }
>  
>  static struct nfulnl_instance *
> -instance_lookup_get(u_int16_t group_num)
> +instance_lookup_get(struct nfulnl_instances *instances, u_int16_t group_num)
>  {
>  	struct nfulnl_instance *inst;
>  
> +	if(!instances)
> +		return NULL;
>  	rcu_read_lock_bh();
> -	inst = __instance_lookup(group_num);
> +	inst = __instance_lookup(instances,group_num);
>  	if (inst && !atomic_inc_not_zero(&inst->use))
>  		inst = NULL;
>  	rcu_read_unlock_bh();
> @@ -132,13 +179,13 @@ instance_put(struct nfulnl_instance *inst)
>  static void nfulnl_timer(unsigned long data);
>  
>  static struct nfulnl_instance *
> -instance_create(u_int16_t group_num, int pid)
> +instance_create(struct nfulnl_instances *instances, u_int16_t group_num, int pid)
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
> @@ -171,15 +218,16 @@ instance_create(u_int16_t group_num, int pid)
>  	inst->copy_mode 	= NFULNL_COPY_PACKET;
>  	inst->copy_range 	= NFULNL_COPY_RANGE_MAX;
>  
> -	hlist_add_head_rcu(&inst->hlist,
> -		       &instance_table[instance_hashfn(group_num)]);
> +	inst->instances = instances;
>  
> -	spin_unlock_bh(&instances_lock);
> +	hlist_add_head_rcu(&inst->hlist,
> +			&instances->table[instance_hashfn(group_num)]);
> +	spin_unlock_bh(&instances->lock);
>  
>  	return inst;
>  
>  out_unlock:
> -	spin_unlock_bh(&instances_lock);
> +	spin_unlock_bh(&instances->lock);
>  	return ERR_PTR(err);
>  }
>  
> @@ -208,11 +256,12 @@ __instance_destroy(struct nfulnl_instance *inst)
>  }
>  
>  static inline void
> -instance_destroy(struct nfulnl_instance *inst)
> +instance_destroy(struct nfulnl_instances *instances,
> +		struct nfulnl_instance *inst)
>  {
> -	spin_lock_bh(&instances_lock);
> +	spin_lock_bh(&instances->lock);
>  	__instance_destroy(inst);
> -	spin_unlock_bh(&instances_lock);
> +	spin_unlock_bh(&instances->lock);
>  }
>  
>  static int
> @@ -331,7 +380,7 @@ __nfulnl_send(struct nfulnl_instance *inst)
>  			  NLMSG_DONE,
>  			  sizeof(struct nfgenmsg));
>  
> -	status = nfnetlink_unicast(inst->skb, &init_net, inst->peer_pid,
> +	status = nfnetlink_unicast(inst->skb, inst_net(inst), inst->peer_pid,
>  				   MSG_DONTWAIT);
>  
>  	inst->qlen = 0;
> @@ -502,7 +551,7 @@ __build_packet_message(struct nfulnl_instance *inst,
>  	/* global sequence number */
>  	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
>  		NLA_PUT_BE32(inst->skb, NFULA_SEQ_GLOBAL,
> -			     htonl(atomic_inc_return(&global_seq)));
> +			     htonl(atomic_inc_return(&inst->instances->global_seq)));
>  
>  	if (data_len) {
>  		struct nlattr *nla;
> @@ -564,7 +613,7 @@ nfulnl_log_packet(u_int8_t pf,
>  	else
>  		li = &default_loginfo;
>  
> -	inst = instance_lookup_get(li->u.ulog.group);
> +	inst = instance_lookup_get(instances_via_skb(skb),li->u.ulog.group);
>  	if (!inst)
>  		return;
>  
> @@ -675,24 +724,25 @@ nfulnl_rcv_nl_event(struct notifier_block *this,
>  		   unsigned long event, void *ptr)
>  {
>  	struct netlink_notify *n = ptr;
> +	struct nfulnl_instances *instances;
>  
>  	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
>  		int i;
>  
> +		instances = instances_for_net(n->net);
>  		/* destroy all instances for this pid */
> -		spin_lock_bh(&instances_lock);
> +		spin_lock_bh(&instances->lock);
>  		for  (i = 0; i < INSTANCE_BUCKETS; i++) {
>  			struct hlist_node *tmp, *t2;
>  			struct nfulnl_instance *inst;
> -			struct hlist_head *head = &instance_table[i];
> +			struct hlist_head *head = &instances->table[i];
>  
>  			hlist_for_each_entry_safe(inst, tmp, t2, head, hlist) {
> -				if ((net_eq(n->net, &init_net)) &&
> -				    (n->pid == inst->peer_pid))
> +				if (n->pid == inst->peer_pid)
>  					__instance_destroy(inst);
>  			}
>  		}
> -		spin_unlock_bh(&instances_lock);
> +		spin_unlock_bh(&instances->lock);
>  	}
>  	return NOTIFY_DONE;
>  }
> @@ -731,6 +781,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  {
>  	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
>  	u_int16_t group_num = ntohs(nfmsg->res_id);
> +	struct nfulnl_instances *instances;
>  	struct nfulnl_instance *inst;
>  	struct nfulnl_msg_config_cmd *cmd = NULL;
>  	int ret = 0;
> @@ -748,8 +799,11 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  			return 0;
>  		}
>  	}
> +	instances = instances_via_skb(skb);
> +	if (!instances)
> +		return -ENODEV;
>  
> -	inst = instance_lookup_get(group_num);
> +	inst = instance_lookup_get(instances,group_num);
>  	if (inst && inst->peer_pid != NETLINK_CB(skb).pid) {
>  		ret = -EPERM;
>  		goto out_put;
> @@ -763,7 +817,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  				goto out_put;
>  			}
>  
> -			inst = instance_create(group_num,
> +			inst = instance_create(instances,group_num,
>  					       NETLINK_CB(skb).pid);
>  			if (IS_ERR(inst)) {
>  				ret = PTR_ERR(inst);
> @@ -776,7 +830,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  				goto out;
>  			}
>  
> -			instance_destroy(inst);
> +			instance_destroy(instances,inst);
>  			goto out_put;
>  		default:
>  			ret = -ENOTSUPP;
> @@ -860,16 +914,28 @@ static const struct nfnetlink_subsystem nfulnl_subsys = {
>  #ifdef CONFIG_PROC_FS
>  struct iter_state {
>  	unsigned int bucket;
> +	struct nfulnl_instances *instances;
>  };
>  
> +static inline struct nfulnl_instances *instances_for_seq(void)
> +{
> +	return instances_for_net(&init_net);
> +}
> +
> +
>  static struct hlist_node *get_first(struct iter_state *st)
>  {
>  	if (!st)
>  		return NULL;
>  
> +	st->instances = instances_for_seq();
> +
>  	for (st->bucket = 0; st->bucket < INSTANCE_BUCKETS; st->bucket++) {
> -		if (!hlist_empty(&instance_table[st->bucket]))
> -			return rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucket]));
> +		if (!hlist_empty(&st->instances->table[st->bucket]))
> +			return rcu_dereference_bh(
> +				hlist_first_rcu(
> +					&st->instances->table[st->bucket]));
> +
>  	}
>  	return NULL;
>  }
> @@ -881,7 +947,7 @@ static struct hlist_node *get_next(struct iter_state *st, struct hlist_node *h)
>  		if (++st->bucket >= INSTANCE_BUCKETS)
>  			return NULL;
>  
> -		h = rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucket]));
> +		h = rcu_dereference_bh(hlist_first_rcu(&st->instances->table[st->bucket]));
>  	}
>  	return h;
>  }
> @@ -950,17 +1016,42 @@ static const struct file_operations nful_file_ops = {
>  
>  #endif /* PROC_FS */
>  
> +
> +
> +static int nfulnl_net_init(struct net *net)
> +{
> +	struct nfulnl_instances *insts;
> +	int i;
> +
> +	insts = net_generic(net, nfulnl_net_id);
> +	insts->net = net;
> +	spin_lock_init(&insts->lock);
> +
> +	i = INSTANCE_BUCKETS;
> +	do INIT_HLIST_HEAD(insts->table + --i); while (i);
> +
> +	/* avoid 'runtime' net_generic for 'no netns' */
> +	instances = insts;
> +	return 0;
> +}
> +
> +static struct pernet_operations nfulnl_net_ops = {
> + .init = nfulnl_net_init,
> + .id = &nfulnl_net_id,
> + .size = sizeof(struct nfulnl_instances)
> +};
> +
>  static int __init nfnetlink_log_init(void)
>  {
> -	int i, status = -ENOMEM;
> +	int status = -ENOMEM;
> +	status = register_pernet_subsys(&nfulnl_net_ops);
> +	if (status)
> +		return status;
>  
> -	for (i = 0; i < INSTANCE_BUCKETS; i++)
> -		INIT_HLIST_HEAD(&instance_table[i]);
>  
>  	/* it's not really all that important to have a random value, so
>  	 * we can do this from the init function, even if there hasn't
>  	 * been that much entropy yet */
> -	get_random_bytes(&hash_init, sizeof(hash_init));
>  
>  	netlink_register_notifier(&nfulnl_rtnl_notifier);
>  	status = nfnetlink_subsys_register(&nfulnl_subsys);
> @@ -995,6 +1086,7 @@ cleanup_netlink_notifier:
>  
>  static void __exit nfnetlink_log_fini(void)
>  {
> +	unregister_pernet_subsys(&nfulnl_net_ops);
>  	nf_log_unregister(&nfulnl_logger);
>  #ifdef CONFIG_PROC_FS
>  	remove_proc_entry("nfnetlink_log", proc_net_netfilter);

