From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Fri, 01 Jul 2011 15:44:35 +0100
Message-ID: <87sjqqawmk.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:52004 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1GAOty (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:49:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Rainer Weikusat <rweikusat@mobileactivedefense.com>

Presently, the nfnetlink_log.c file contains only very nominal support
for network namespaces: While it is possible to create sockets which
should theoretically receive NFLOG originated messages in arbitrary
network namespaces, there is only one table of nfulnl_instance
structures in the kernel and all log messages sent via __nfulnl_send
are forced into the init_net namespace so that only sockets created
in this namespace will ever actually receive log data. Likewise, the
nfulnl_rcv_nl_event notification callback won't destroy logging
instances created by processes in other network namespace upon process
death. The patch included below changes the code to use a logging
instance table per network namespace, to send messages generated from
within a specific namespace to sockets also belonging to this
namespace and to destroy logging instances created from other network
namespaces than init_net when cleaning up after a logging process
terminated. It doesn't touch the code dealing with nfnetlink_log /proc
files which thus remain restricted to the init_net namespace because
this isn't really needed in order to get per-namespace logging and
would require changes to other files, in particular, nf_log.c

Signed-Off-By: Rainer Weikusat <rweikusat@mobileactivedefense.com>
---
This is a feature needed for the main product of my present employer
and the patch is published here in the hope that it is more generally
useful as well. A more thorough change of the logging infrastructure
is unforunately way beyond the amount of time I'm allowed to spend on
this.

diff -prNu nf-2.6/net/netfilter/nfnetlink_log.c nf-2.6.patched//net/netfilter/nfnetlink_log.c
--- nf-2.6/net/netfilter/nfnetlink_log.c	2011-07-01 14:08:21.833369919 +0100
+++ nf-2.6.patched//net/netfilter/nfnetlink_log.c	2011-07-01 14:57:01.277536330 +0100
@@ -39,6 +39,12 @@
 #include "../bridge/br_private.h"
 #endif
 
+#ifdef CONFIG_NET_NS
+#define NET_NS 1
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+#endif
+
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
@@ -47,6 +53,18 @@
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
 
+#define INSTANCE_BUCKETS	16
+
+struct nfulnl_instances {
+	spinlock_t lock;
+	atomic_t global_seq;
+	struct hlist_head table[INSTANCE_BUCKETS];
+	unsigned hash_init;
+#ifdef NET_NS
+	struct net *net;
+#endif
+};
+
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
@@ -67,14 +85,92 @@ struct nfulnl_instance {
 	u_int16_t flags;
 	u_int8_t copy_mode;
 	struct rcu_head rcu;
+#ifdef NET_NS
+	struct nfulnl_instances *instances;
+#endif
 };
 
-static DEFINE_SPINLOCK(instances_lock);
-static atomic_t global_seq;
+#ifndef NET_NS
+static struct nfulnl_instances instances;
 
-#define INSTANCE_BUCKETS	16
-static struct hlist_head instance_table[INSTANCE_BUCKETS];
-static unsigned int hash_init;
+static inline struct nfulnl_instances *
+instances_via_inst(struct nfulnl_instance *inst)
+{
+	(void)inst;
+	return &instances;
+}
+
+static inline struct nfulnl_instances *
+instances_via_netlink_notify(struct netlink_notify *n)
+{
+	(void)n;
+	return &instances;
+}
+
+static inline struct nfulnl_instances *
+instances_via_skb(struct sk_buff const *skb)
+{
+	(void)skb;
+	return &instances;
+}
+
+static inline struct net *inst_net(struct nfulnl_instance *inst)
+{
+	(void)inst;
+	return &init_net;
+}
+#else
+static int nfulnl_net_id;
+
+static inline struct nfulnl_instances *instances_via_net(struct net *net)
+{
+	return net_generic(net, nfulnl_net_id);
+}
+
+static inline struct nfulnl_instances *
+instances_via_inst(struct nfulnl_instance *inst)
+{
+	return inst->instances;
+}
+
+static inline struct nfulnl_instances *
+instances_via_netlink_notify(struct netlink_notify *n)
+{
+	return instances_via_net(n->net);
+}
+
+static struct nfulnl_instances *instances_via_skb(struct sk_buff const *skb)
+{
+	struct sock *sk;
+	struct net_device *dev;
+	struct net *net;
+
+	net = NULL;
+
+	sk = skb->sk;
+	if (sk)
+		net = sock_net(sk);
+
+	if (!net) {
+		dev = skb->dev;
+		if (dev)
+			net = dev_net(dev);
+	}
+
+	if (!net) {
+		PRINTR(KERN_WARNING "%s: could determine net ns for %p\n",
+		       __func__, skb);
+		return NULL;
+	}
+
+	return instances_via_net(net);
+}
+
+static inline struct net *inst_net(struct nfulnl_instance *inst)
+{
+	return instances_via_inst(inst)->net;
+}
+#endif
 
 static inline u_int8_t instance_hashfn(u_int16_t group_num)
 {
@@ -82,13 +178,13 @@ static inline u_int8_t instance_hashfn(u
 }
 
 static struct nfulnl_instance *
-__instance_lookup(u_int16_t group_num)
+__instance_lookup(struct nfulnl_instances *instances, u_int16_t group_num)
 {
 	struct hlist_head *head;
 	struct hlist_node *pos;
 	struct nfulnl_instance *inst;
 
-	head = &instance_table[instance_hashfn(group_num)];
+	head = &instances->table[instance_hashfn(group_num)];
 	hlist_for_each_entry_rcu(inst, pos, head, hlist) {
 		if (inst->group_num == group_num)
 			return inst;
@@ -103,12 +199,15 @@ instance_get(struct nfulnl_instance *ins
 }
 
 static struct nfulnl_instance *
-instance_lookup_get(u_int16_t group_num)
+instance_lookup_get(struct nfulnl_instances *instances, u_int16_t group_num)
 {
 	struct nfulnl_instance *inst;
 
+	if (!instances)
+		return NULL;
+
 	rcu_read_lock_bh();
-	inst = __instance_lookup(group_num);
+	inst = __instance_lookup(instances, group_num);
 	if (inst && !atomic_inc_not_zero(&inst->use))
 		inst = NULL;
 	rcu_read_unlock_bh();
@@ -132,13 +231,14 @@ instance_put(struct nfulnl_instance *ins
 static void nfulnl_timer(unsigned long data);
 
 static struct nfulnl_instance *
-instance_create(u_int16_t group_num, int pid)
+instance_create(struct nfulnl_instances *instances,
+		u_int16_t group_num, int pid)
 {
 	struct nfulnl_instance *inst;
 	int err;
 
-	spin_lock_bh(&instances_lock);
-	if (__instance_lookup(group_num)) {
+	spin_lock_bh(&instances->lock);
+	if (__instance_lookup(instances, group_num)) {
 		err = -EEXIST;
 		goto out_unlock;
 	}
@@ -172,14 +272,17 @@ instance_create(u_int16_t group_num, int
 	inst->copy_range 	= NFULNL_COPY_RANGE_MAX;
 
 	hlist_add_head_rcu(&inst->hlist,
-		       &instance_table[instance_hashfn(group_num)]);
+			   &instances->table[instance_hashfn(group_num)]);
 
-	spin_unlock_bh(&instances_lock);
+#ifdef NET_NS
+	inst->instances = instances;
+#endif
+	spin_unlock_bh(&instances->lock);
 
 	return inst;
 
 out_unlock:
-	spin_unlock_bh(&instances_lock);
+	spin_unlock_bh(&instances->lock);
 	return ERR_PTR(err);
 }
 
@@ -208,16 +311,17 @@ __instance_destroy(struct nfulnl_instanc
 }
 
 static inline void
-instance_destroy(struct nfulnl_instance *inst)
+instance_destroy(struct nfulnl_instances *instances,
+		 struct nfulnl_instance *inst)
 {
-	spin_lock_bh(&instances_lock);
+	spin_lock_bh(&instances->lock);
 	__instance_destroy(inst);
-	spin_unlock_bh(&instances_lock);
+	spin_unlock_bh(&instances->lock);
 }
 
 static int
 nfulnl_set_mode(struct nfulnl_instance *inst, u_int8_t mode,
-		  unsigned int range)
+		unsigned int range)
 {
 	int status = 0;
 
@@ -308,7 +412,7 @@ nfulnl_alloc_skb(unsigned int inst_size,
 	skb = alloc_skb(n, GFP_ATOMIC);
 	if (!skb) {
 		pr_notice("nfnetlink_log: can't alloc whole buffer (%u bytes)\n",
-			inst_size);
+			  inst_size);
 
 		if (n > pkt_size) {
 			/* try to allocate only as much as we need for current
@@ -334,7 +438,7 @@ __nfulnl_send(struct nfulnl_instance *in
 			  NLMSG_DONE,
 			  sizeof(struct nfgenmsg));
 
-	status = nfnetlink_unicast(inst->skb, &init_net, inst->peer_pid,
+	status = nfnetlink_unicast(inst->skb, inst_net(inst), inst->peer_pid,
 				   MSG_DONTWAIT);
 
 	inst->qlen = 0;
@@ -368,6 +472,11 @@ nfulnl_timer(unsigned long data)
 
 /* This is an inline function, we don't really care about a long
  * list of arguments */
+static inline atomic_t *global_seq_for(nfulnl_instances *inst)
+{
+	return &instances_via_inst(inst)->global_seq;
+}
+
 static inline int
 __build_packet_message(struct nfulnl_instance *inst,
 			const struct sk_buff *skb,
@@ -505,7 +614,7 @@ __build_packet_message(struct nfulnl_ins
 	/* global sequence number */
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
 		NLA_PUT_BE32(inst->skb, NFULA_SEQ_GLOBAL,
-			     htonl(atomic_inc_return(&global_seq)));
+			     htonl(atomic_inc_return(global_seq_for(inst)));
 
 	if (data_len) {
 		struct nlattr *nla;
@@ -567,7 +676,8 @@ nfulnl_log_packet(u_int8_t pf,
 	else
 		li = &default_loginfo;
 
-	inst = instance_lookup_get(li->u.ulog.group);
+	inst = instance_lookup_get(instances_via_skb(skb),
+				   li->u.ulog.group);
 	if (!inst)
 		return;
 
@@ -675,27 +785,29 @@ EXPORT_SYMBOL_GPL(nfulnl_log_packet);
 
 static int
 nfulnl_rcv_nl_event(struct notifier_block *this,
-		   unsigned long event, void *ptr)
+		    unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
+	struct nfulnl_instances *instances;
 
 	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
 		int i;
 
+		instances = instances_via_netlink_notify(n);
+
 		/* destroy all instances for this pid */
-		spin_lock_bh(&instances_lock);
+		spin_lock_bh(&instances->lock);
 		for  (i = 0; i < INSTANCE_BUCKETS; i++) {
 			struct hlist_node *tmp, *t2;
 			struct nfulnl_instance *inst;
-			struct hlist_head *head = &instance_table[i];
+			struct hlist_head *head = &instances->table[i];
 
 			hlist_for_each_entry_safe(inst, tmp, t2, head, hlist) {
-				if ((net_eq(n->net, &init_net)) &&
-				    (n->pid == inst->peer_pid))
+				if (n->pid == inst->peer_pid)
 					__instance_destroy(inst);
 			}
 		}
-		spin_unlock_bh(&instances_lock);
+		spin_unlock_bh(&instances->lock);
 	}
 	return NOTIFY_DONE;
 }
@@ -734,6 +846,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t group_num = ntohs(nfmsg->res_id);
+	struct nfulnl_instances *instances;
 	struct nfulnl_instance *inst;
 	struct nfulnl_msg_config_cmd *cmd = NULL;
 	int ret = 0;
@@ -752,7 +865,11 @@ nfulnl_recv_config(struct sock *ctnl, st
 		}
 	}
 
-	inst = instance_lookup_get(group_num);
+	instances = instances_via_skb(skb);
+	if (!instances)
+		return -ENODEV;
+
+	inst = instance_lookup_get(instances, group_num);
 	if (inst && inst->peer_pid != NETLINK_CB(skb).pid) {
 		ret = -EPERM;
 		goto out_put;
@@ -766,7 +883,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 				goto out_put;
 			}
 
-			inst = instance_create(group_num,
+			inst = instance_create(instances, group_num,
 					       NETLINK_CB(skb).pid);
 			if (IS_ERR(inst)) {
 				ret = PTR_ERR(inst);
@@ -779,7 +896,7 @@ nfulnl_recv_config(struct sock *ctnl, st
 				goto out;
 			}
 
-			instance_destroy(inst);
+			instance_destroy(instances, inst);
 			goto out_put;
 		default:
 			ret = -ENOTSUPP;
@@ -862,17 +979,30 @@ static const struct nfnetlink_subsystem
 
 #ifdef CONFIG_PROC_FS
 struct iter_state {
+	struct nfulnl_instances *instances;
 	unsigned int bucket;
 };
 
+static inline struct nfulnl_instances *instances_for_seq(void)
+{
+#ifdef NET_NS
+	return instances_via_net(&init_net);
+#else
+	return &instances;
+#endif
+}
+
 static struct hlist_node *get_first(struct iter_state *st)
 {
 	if (!st)
 		return NULL;
 
+	st->instances = instances_for_seq();
 	for (st->bucket = 0; st->bucket < INSTANCE_BUCKETS; st->bucket++) {
-		if (!hlist_empty(&instance_table[st->bucket]))
-			return rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucket]));
+		if (!hlist_empty(&st->instances->table[st->bucket]))
+			return rcu_dereference_bh(
+				hlist_first_rcu(
+					&st->instances->table[st->bucket]));
 	}
 	return NULL;
 }
@@ -884,7 +1014,8 @@ static struct hlist_node *get_next(struc
 		if (++st->bucket >= INSTANCE_BUCKETS)
 			return NULL;
 
-		h = rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucket]));
+		h = rcu_dereference_bh(
+			hlist_first_rcu(&st->instances->table[st->bucket]));
 	}
 	return h;
 }
@@ -953,17 +1084,69 @@ static const struct file_operations nful
 
 #endif /* PROC_FS */
 
+#ifdef NET_NS
+static int nfulnl_net_init(struct net *net)
+{
+	struct nfulnl_instances *instances;
+	int i;
+
+	instances = instances_via_net(net);
+	instances->net = net;
+	spin_lock_init(&instances->lock);
+
+	i = 0;
+	while (i < INSTANCE_BUCKETS) {
+		INIT_HLIST_HEAD(instances->table + i);
+		++i;
+	}
+
+	return 0;
+}
+
+static void nfulnl_net_exit(struct net *net)
+{
+	struct nfulnl_instances *instances;
+	int i;
+
+	instances = instances_via_net(net);
+
+	i = 0;
+	while (i < INSTANCE_BUCKETS) {
+		if (!hlist_empty(instances->table + i))
+			printk(KERN_WARNING "%s: slot %d not empty\n",
+			       __func__, i);
+		++i;
+	}
+}
+
+static struct pernet_operations nfulnl_net_ops = {
+	.init =		nfulnl_net_init,
+	.exit =		nfulnl_net_exit,
+	.id =		&nfulnl_net_id,
+	.size =		sizeof(struct nfulnl_instances)
+};
+#endif /* NET_NS */
+
 static int __init nfnetlink_log_init(void)
 {
-	int i, status = -ENOMEM;
+	int status = -ENOMEM;
+
+#ifndef NET_NS
+	int i;
 
+	spin_lock_init(&instances.lock);
 	for (i = 0; i < INSTANCE_BUCKETS; i++)
-		INIT_HLIST_HEAD(&instance_table[i]);
+		INIT_HLIST_HEAD(&instances.table[i]);
 
 	/* it's not really all that important to have a random value, so
 	 * we can do this from the init function, even if there hasn't
 	 * been that much entropy yet */
-	get_random_bytes(&hash_init, sizeof(hash_init));
+	get_random_bytes(&instances.hash_init, sizeof(instances.hash_init));
+#else
+	status = register_pernet_subsys(&nfulnl_net_ops);
+	if (status)
+		return status;
+#endif
 
 	netlink_register_notifier(&nfulnl_rtnl_notifier);
 	status = nfnetlink_subsys_register(&nfulnl_subsys);
@@ -998,6 +1181,10 @@ cleanup_netlink_notifier:
 
 static void __exit nfnetlink_log_fini(void)
 {
+#ifdef NET_NS
+	unregister_pernet_subsys(&nfulnl_net_ops);
+#endif
+
 	nf_log_unregister(&nfulnl_logger);
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", proc_net_netfilter);
