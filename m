From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 10/12] netfilter: ctnetlink: make ctnetlink bind register conntrack hooks
Date: Thu,  3 Dec 2015 10:49:43 +0100
Message-ID: <1449136185-4165-11-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52613 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932858AbbLCJu3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:29 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

several problems remain even after this patch:

1. conntrack -E followed by a 'modprobe nf_conntrack_ipv4' will
*not* register ipv4 conntrack hooks (i.e., there will be no output) anymore.

2. since ctnetlink has no dependencies on nf_conntrack_xxx its possible
to rmmod nf_conntrack_xxx while event listener is running which means the
tracker has to remove hooks on netns destruction.

Both issues are addressed in followup patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not part of v2 series.
 This is a separate patch to ease review.

 include/linux/netfilter/nfnetlink.h            |  1 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 17 ++++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 17 ++++-
 net/netfilter/nf_conntrack_netlink.c           | 86 ++++++++++++++++++++++++++
 net/netfilter/nfnetlink.c                      | 35 ++++++++---
 5 files changed, 146 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 249d1bb..9049c6a 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -28,6 +28,7 @@ struct nfnetlink_subsystem {
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	int (*commit)(struct sk_buff *skb);
 	int (*abort)(struct sk_buff *skb);
+	int (*bind)(struct net *net);
 };
 
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 909681e..7fcccf3 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -401,12 +401,25 @@ static int ipv4_hooks_register(struct net *net)
 	return err;
 }
 
+static void ipv4_hooks_unregister_force(struct net *net)
+{
+	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
+
+	mutex_lock(&register_ipv4_hooks);
+	if (cnet->users) {
+		cnet->users = 0;
+		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
+					ARRAY_SIZE(ipv4_conntrack_ops));
+	}
+	mutex_unlock(&register_ipv4_hooks);
+}
+
 static void ipv4_hooks_unregister(struct net *net)
 {
 	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
 
 	mutex_lock(&register_ipv4_hooks);
-	if (--cnet->users == 0)
+	if (cnet->users > 0 && --cnet->users == 0)
 		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
 					ARRAY_SIZE(ipv4_conntrack_ops));
 	mutex_unlock(&register_ipv4_hooks);
@@ -478,6 +491,8 @@ out_tcp:
 
 static void ipv4_net_exit(struct net *net)
 {
+	ipv4_hooks_unregister_force(net);
+
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv4);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmp);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp4);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 1e6a5f4..f3b422b 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -340,12 +340,25 @@ static int ipv6_hooks_register(struct net *net)
 	return err;
 }
 
+static void ipv6_hooks_unregister_force(struct net *net)
+{
+	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
+
+	mutex_lock(&register_ipv6_hooks);
+	if (cnet->users) {
+		cnet->users = 0;
+		nf_unregister_net_hooks(net, ipv6_conntrack_ops,
+					ARRAY_SIZE(ipv6_conntrack_ops));
+	}
+	mutex_unlock(&register_ipv6_hooks);
+}
+
 static void ipv6_hooks_unregister(struct net *net)
 {
 	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
 
 	mutex_lock(&register_ipv6_hooks);
-	if (--cnet->users == 0)
+	if (cnet->users > 0 && --cnet->users == 0)
 		nf_unregister_net_hooks(net, ipv6_conntrack_ops,
 					ARRAY_SIZE(ipv6_conntrack_ops));
 	mutex_unlock(&register_ipv6_hooks);
@@ -418,6 +431,8 @@ static int ipv6_net_init(struct net *net)
 
 static void ipv6_net_exit(struct net *net)
 {
+	ipv6_hooks_unregister_force(net);
+
 	nf_ct_l3proto_pernet_unregister(net, &nf_conntrack_l3proto_ipv6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_icmpv6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_udp6);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9f52729..b8a4067 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -57,6 +57,11 @@
 MODULE_LICENSE("GPL");
 
 static char __initdata version[] = "0.93";
+static int ctnetlink_net_id __read_mostly;
+
+struct ctnl_net {
+	DECLARE_BITMAP(enabled, NFPROTO_NUMPROTO);
+};
 
 static inline int
 ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -2133,6 +2138,50 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
+static int ctnl_bind(struct net *net)
+{
+	struct ctnl_net *ctnet = net_generic(net, ctnetlink_net_id);
+	int i;
+
+	might_sleep();
+
+	rcu_read_lock();
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		struct nf_conntrack_l3proto *l3proto;
+		int ret;
+
+		/* don't autoload modules; only ensure those present have
+		 * their hooks registered.
+		 */
+		l3proto = __nf_ct_l3proto_find(i);
+		if (!l3proto || !l3proto->net_ns_get)
+			continue;
+
+		if (test_and_set_bit(i, ctnet->enabled))
+			continue;
+
+		if (!try_module_get(l3proto->me))
+			continue;
+
+		rcu_read_unlock();
+
+		/* might sleep, l3proto can't go away, module ref held */
+		ret = l3proto->net_ns_get(net);
+
+		module_put(l3proto->me);
+
+		if (ret < 0)
+			clear_bit(i, ctnet->enabled);
+
+		rcu_read_lock();
+	}
+
+	rcu_read_unlock();
+
+	return 0;
+}
+
 #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
 static size_t
 ctnetlink_glue_build_size(const struct nf_conn *ct)
@@ -3304,6 +3353,7 @@ static const struct nfnetlink_subsystem ctnl_subsys = {
 	.subsys_id			= NFNL_SUBSYS_CTNETLINK,
 	.cb_count			= IPCTNL_MSG_MAX,
 	.cb				= ctnl_cb,
+	.bind				= ctnl_bind,
 };
 
 static const struct nfnetlink_subsystem ctnl_exp_subsys = {
@@ -3311,6 +3361,7 @@ static const struct nfnetlink_subsystem ctnl_exp_subsys = {
 	.subsys_id			= NFNL_SUBSYS_CTNETLINK_EXP,
 	.cb_count			= IPCTNL_MSG_EXP_MAX,
 	.cb				= ctnl_exp_cb,
+	.bind				= ctnl_bind,
 };
 
 MODULE_ALIAS("ip_conntrack_netlink");
@@ -3346,10 +3397,43 @@ err_out:
 
 static void ctnetlink_net_exit(struct net *net)
 {
+	struct ctnl_net *ctnet = net_generic(net, ctnetlink_net_id);
+	int i;
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	nf_ct_expect_unregister_notifier(net, &ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(net, &ctnl_notifier);
 #endif
+
+	might_sleep();
+
+	rcu_read_lock();
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		struct nf_conntrack_l3proto *l3proto;
+
+		if (!test_bit(i, ctnet->enabled))
+			continue;
+
+		l3proto = __nf_ct_l3proto_find(i);
+		/* module might have been unloaded, l3proto->net_ns_put
+		 * must have been called by that modules' netns exit handler.
+		 */
+		if (!l3proto)
+			continue;
+
+		if (!try_module_get(l3proto->me))
+			continue;
+
+		rcu_read_unlock();
+
+		l3proto->net_ns_put(net);
+		module_put(l3proto->me);
+
+		rcu_read_lock();
+	}
+
+	rcu_read_unlock();
 }
 
 static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
@@ -3363,6 +3447,8 @@ static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
 static struct pernet_operations ctnetlink_net_ops = {
 	.init		= ctnetlink_net_init,
 	.exit_batch	= ctnetlink_net_exit_batch,
+	.id   = &ctnetlink_net_id,
+	.size = sizeof(struct ctnl_net),
 };
 
 static int __init ctnetlink_init(void)
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 197b2c6..63a16e6 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -481,11 +481,11 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 	}
 }
 
-#ifdef CONFIG_MODULES
 static int nfnetlink_bind(struct net *net, int group)
 {
 	const struct nfnetlink_subsystem *ss;
-	int type;
+	int type, ret;
+	u8 subsys_id;
 
 	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
 		return 0;
@@ -494,12 +494,33 @@ static int nfnetlink_bind(struct net *net, int group)
 
 	rcu_read_lock();
 	ss = nfnetlink_get_subsys(type << 8);
-	rcu_read_unlock();
-	if (!ss)
+	ret = -EINVAL;
+#ifdef CONFIG_MODULES
+	if (!ss) {
+		rcu_read_unlock();
 		request_module("nfnetlink-subsys-%d", type);
-	return 0;
-}
+		rcu_read_lock();
+		ss = nfnetlink_get_subsys(type << 8);
+	}
 #endif
+	if (!ss) {
+		rcu_read_unlock();
+		return ret;
+	}
+
+	subsys_id = ss->subsys_id;
+	rcu_read_unlock();
+
+	if (!ss->bind)
+		return 0;
+
+	nfnl_lock(subsys_id);
+	if (nfnl_dereference_protected(subsys_id) == ss)
+		ret = ss->bind(net);
+	nfnl_unlock(subsys_id);
+
+	return ret;
+}
 
 static int __net_init nfnetlink_net_init(struct net *net)
 {
@@ -507,9 +528,7 @@ static int __net_init nfnetlink_net_init(struct net *net)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= NFNLGRP_MAX,
 		.input	= nfnetlink_rcv,
-#ifdef CONFIG_MODULES
 		.bind	= nfnetlink_bind,
-#endif
 	};
 
 	nfnl = netlink_kernel_create(net, NETLINK_NETFILTER, &cfg);
-- 
2.4.10

