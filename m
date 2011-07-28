From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c (updated yet again)
Date: Thu, 28 Jul 2011 20:57:36 +0100
Message-ID: <87bowech5b.fsf_-_@sapphire.mobileactivedefense.com>
References: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
	<20110718191956.GA2489@p183.telecom.by>
	<87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
	<20110718.124638.30010338187296272.davem@davemloft.net>
	<87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
	<alpine.LNX.2.01.1107182218170.9579@frira.zrqbmnf.qr>
	<878vruymq6.fsf@sapphire.mobileactivedefense.com>
	<87sjq1xab8.fsf_-_@sapphire.mobileactivedefense.com>
	<87y5zlgtmh.fsf_-_@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mss-uk.mssgmbh.com ([217.174.251.109]:47694 "EHLO
	mss-uk.mssgmbh.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1G1T5p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2011 15:57:45 -0400
In-Reply-To: <87y5zlgtmh.fsf_-_@sapphire.mobileactivedefense.com> (Rainer Weikusat's message of "Tue\, 26 Jul 2011 12\:37\:42 +0100")
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

The patch also removes the hash_init file scope variable because
that's not used for anything except that the existing init routine
initializes it.

Signed-Off-By: Rainer Weikusat <rweikusat@mobileactivedefense.com>
---
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2e7ccbb..2982315 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -39,6 +39,9 @@
 #include "../bridge/br_private.h"
 #endif
 
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
@@ -47,6 +50,15 @@
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
 
+#define INSTANCE_BUCKETS	16
+
+struct nfulnl_instances {
+	spinlock_t lock;
+	atomic_t global_seq;
+	struct hlist_head table[INSTANCE_BUCKETS];
+	struct net *net;
+};
+
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
@@ -67,14 +79,15 @@ struct nfulnl_instance {
 	u_int16_t flags;
 	u_int8_t copy_mode;
 	struct rcu_head rcu;
+	struct nfulnl_instances *instances;
 };
 
-static DEFINE_SPINLOCK(instances_lock);
-static atomic_t global_seq;
+static int nfulnl_net_id;
 
-#define INSTANCE_BUCKETS	16
-static struct hlist_head instance_table[INSTANCE_BUCKETS];
-static unsigned int hash_init;
+static inline struct nfulnl_instances *instances_for_net(struct net *net)
+{
+	return net_generic(net, nfulnl_net_id);
+}
 
 static inline u_int8_t instance_hashfn(u_int16_t group_num)
 {
@@ -82,13 +95,13 @@ static inline u_int8_t instance_hashfn(u_int16_t group_num)
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
@@ -103,12 +116,12 @@ instance_get(struct nfulnl_instance *inst)
 }
 
 static struct nfulnl_instance *
-instance_lookup_get(u_int16_t group_num)
+instance_lookup_get(struct nfulnl_instances *instances, u_int16_t group_num)
 {
 	struct nfulnl_instance *inst;
 
 	rcu_read_lock_bh();
-	inst = __instance_lookup(group_num);
+	inst = __instance_lookup(instances, group_num);
 	if (inst && !atomic_inc_not_zero(&inst->use))
 		inst = NULL;
 	rcu_read_unlock_bh();
@@ -132,13 +145,14 @@ instance_put(struct nfulnl_instance *inst)
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
@@ -171,15 +185,16 @@ instance_create(u_int16_t group_num, int pid)
 	inst->copy_mode 	= NFULNL_COPY_PACKET;
 	inst->copy_range 	= NFULNL_COPY_RANGE_MAX;
 
-	hlist_add_head_rcu(&inst->hlist,
-		       &instance_table[instance_hashfn(group_num)]);
+	inst->instances = instances;
 
-	spin_unlock_bh(&instances_lock);
+	hlist_add_head_rcu(&inst->hlist,
+			&instances->table[instance_hashfn(group_num)]);
 
+	spin_unlock_bh(&instances->lock);
 	return inst;
 
 out_unlock:
-	spin_unlock_bh(&instances_lock);
+	spin_unlock_bh(&instances->lock);
 	return ERR_PTR(err);
 }
 
@@ -208,11 +223,12 @@ __instance_destroy(struct nfulnl_instance *inst)
 }
 
 static inline void
-instance_destroy(struct nfulnl_instance *inst)
+instance_destroy(struct nfulnl_instances *instances,
+		struct nfulnl_instance *inst)
 {
-	spin_lock_bh(&instances_lock);
+	spin_lock_bh(&instances->lock);
 	__instance_destroy(inst);
-	spin_unlock_bh(&instances_lock);
+	spin_unlock_bh(&instances->lock);
 }
 
 static int
@@ -334,8 +350,9 @@ __nfulnl_send(struct nfulnl_instance *inst)
 			  NLMSG_DONE,
 			  sizeof(struct nfgenmsg));
 
-	status = nfnetlink_unicast(inst->skb, &init_net, inst->peer_pid,
-				   MSG_DONTWAIT);
+	status = nfnetlink_unicast(inst->skb, read_pnet(&inst->instances->net),
+				inst->peer_pid,
+				MSG_DONTWAIT);
 
 	inst->qlen = 0;
 	inst->skb = NULL;
@@ -505,7 +522,8 @@ __build_packet_message(struct nfulnl_instance *inst,
 	/* global sequence number */
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
 		NLA_PUT_BE32(inst->skb, NFULA_SEQ_GLOBAL,
-			     htonl(atomic_inc_return(&global_seq)));
+			     htonl(atomic_inc_return(
+				       &inst->instances->global_seq)));
 
 	if (data_len) {
 		struct nlattr *nla;
@@ -567,7 +585,10 @@ nfulnl_log_packet(u_int8_t pf,
 	else
 		li = &default_loginfo;
 
-	inst = instance_lookup_get(li->u.ulog.group);
+	inst = instance_lookup_get(instances_for_net(
+					dev_net(skb->dev ?
+						skb->dev : skb_dst(skb)->dev)),
+				li->u.ulog.group);
 	if (!inst)
 		return;
 
@@ -678,24 +699,26 @@ nfulnl_rcv_nl_event(struct notifier_block *this,
 		   unsigned long event, void *ptr)
 {
 	struct netlink_notify *n = ptr;
+	struct nfulnl_instances *instances;
 
 	if (event == NETLINK_URELEASE && n->protocol == NETLINK_NETFILTER) {
 		int i;
 
+		instances = instances_for_net(n->net);
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
@@ -734,6 +757,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
 	u_int16_t group_num = ntohs(nfmsg->res_id);
+	struct nfulnl_instances *instances;
 	struct nfulnl_instance *inst;
 	struct nfulnl_msg_config_cmd *cmd = NULL;
 	int ret = 0;
@@ -752,7 +776,11 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	inst = instance_lookup_get(group_num);
+	instances = instances_for_net(sock_net(ctnl));
+	if (!instances)
+		return -ENODEV;
+
+	inst = instance_lookup_get(instances, group_num);
 	if (inst && inst->peer_pid != NETLINK_CB(skb).pid) {
 		ret = -EPERM;
 		goto out_put;
@@ -766,7 +794,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 				goto out_put;
 			}
 
-			inst = instance_create(group_num,
+			inst = instance_create(instances, group_num,
 					       NETLINK_CB(skb).pid);
 			if (IS_ERR(inst)) {
 				ret = PTR_ERR(inst);
@@ -779,7 +807,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 				goto out;
 			}
 
-			instance_destroy(inst);
+			instance_destroy(instances, inst);
 			goto out_put;
 		default:
 			ret = -ENOTSUPP;
@@ -862,6 +890,7 @@ static const struct nfnetlink_subsystem nfulnl_subsys = {
 
 #ifdef CONFIG_PROC_FS
 struct iter_state {
+	struct nfulnl_instances *instances;
 	unsigned int bucket;
 };
 
@@ -870,9 +899,13 @@ static struct hlist_node *get_first(struct iter_state *st)
 	if (!st)
 		return NULL;
 
+	st->instances = instances_for_net(&init_net);
+
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
@@ -884,7 +917,8 @@ static struct hlist_node *get_next(struct iter_state *st, struct hlist_node *h)
 		if (++st->bucket >= INSTANCE_BUCKETS)
 			return NULL;
 
-		h = rcu_dereference_bh(hlist_first_rcu(&instance_table[st->bucket]));
+		h = rcu_dereference_bh(hlist_first_rcu(
+					&st->instances->table[st->bucket]));
 	}
 	return h;
 }
@@ -953,17 +987,34 @@ static const struct file_operations nful_file_ops = {
 
 #endif /* PROC_FS */
 
-static int __init nfnetlink_log_init(void)
+static int nfulnl_net_init(struct net *net)
 {
-	int i, status = -ENOMEM;
+	struct nfulnl_instances *insts;
+	int i;
+
+	insts = net_generic(net, nfulnl_net_id);
+	insts->net = net;
+	spin_lock_init(&insts->lock);
+
+	for (i = 0; i < INSTANCE_BUCKETS; ++i)
+		INIT_HLIST_HEAD(&insts->table[i]);
+
+	return 0;
+}
+
+static struct pernet_operations nfulnl_net_ops = {
+	.init =		nfulnl_net_init,
+	.id =		&nfulnl_net_id,
+	.size =		sizeof(struct nfulnl_instances)
+};
 
-	for (i = 0; i < INSTANCE_BUCKETS; i++)
-		INIT_HLIST_HEAD(&instance_table[i]);
+static int __init nfnetlink_log_init(void)
+{
+	int status = -ENOMEM;
 
-	/* it's not really all that important to have a random value, so
-	 * we can do this from the init function, even if there hasn't
-	 * been that much entropy yet */
-	get_random_bytes(&hash_init, sizeof(hash_init));
+	status = register_pernet_subsys(&nfulnl_net_ops);
+	if (status)
+		return status;
 
 	netlink_register_notifier(&nfulnl_rtnl_notifier);
 	status = nfnetlink_subsys_register(&nfulnl_subsys);
@@ -1004,6 +1055,7 @@ static void __exit nfnetlink_log_fini(void)
 #endif
 	nfnetlink_subsys_unregister(&nfulnl_subsys);
 	netlink_unregister_notifier(&nfulnl_rtnl_notifier);
+	unregister_pernet_subsys(&nfulnl_net_ops);
 }
 
 MODULE_DESCRIPTION("netfilter userspace logging");
