From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 12/12] netfilter: inform ctnetlink about new l3 protocol trackers
Date: Thu,  3 Dec 2015 10:49:45 +0100
Message-ID: <1449136185-4165-13-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52618 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933004AbbLCJug (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:36 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous patch made 'conntrack -E' (or other ctnetlink event tools)
register netfilter hooks of already-loaded conntrack l3 protocols, but this
fails when a new l3 protocol is loaded at a later point in time.

This informs ctnetlink about new module and also registers their hooks
if needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not part of v2.
 This is a seperate patch to ease review.

 include/linux/netfilter.h            |  1 +
 net/netfilter/nf_conntrack_netlink.c | 37 +++++++++++++++++++++++++++++++++++-
 net/netfilter/nf_conntrack_proto.c   |  6 ++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c3cf796..663832d 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -397,6 +397,7 @@ struct nfnl_ct_hook {
 	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo, s32 off);
 	int (*register_hooks)(struct net *);
+	void (*newproto)(void);
 };
 extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0a9b1e9..1350a28 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -61,6 +61,7 @@ static int ctnetlink_net_id __read_mostly;
 
 struct ctnl_net {
 	DECLARE_BITMAP(enabled, NFPROTO_NUMPROTO);
+	bool active;
 };
 
 static inline int
@@ -2138,7 +2139,7 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
-static int ctnl_bind(struct net *net)
+static void __ctnl_bind(struct net *net)
 {
 	struct ctnl_net *ctnet = net_generic(net, ctnetlink_net_id);
 	int i;
@@ -2178,11 +2179,43 @@ static int ctnl_bind(struct net *net)
 	}
 
 	rcu_read_unlock();
+}
+
+static int ctnl_bind(struct net *net)
+{
+	struct ctnl_net *ctnet = net_generic(net, ctnetlink_net_id);
+
+	__ctnl_bind(net);
+
+	if (!ctnet->active)
+		ctnet->active = true;
 
 	return 0;
 }
 
 #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
+/* called with RCU read lock held */
+static void ctnl_newproto(void)
+{
+	struct ctnl_net *ctnet;
+	struct net *net;
+
+	if (!try_module_get(THIS_MODULE))
+		return;
+
+	rcu_read_unlock();
+	rtnl_lock();
+	for_each_net(net) {
+		ctnet = net_generic(net, ctnetlink_net_id);
+		if (ctnet->active)
+			__ctnl_bind(net);
+	}
+	rtnl_unlock();
+	rcu_read_lock();
+
+	module_put(THIS_MODULE);
+}
+
 static size_t
 ctnetlink_glue_build_size(const struct nf_conn *ct)
 {
@@ -2452,6 +2485,7 @@ static struct nfnl_ct_hook ctnetlink_glue_hook = {
 	.attach_expect	= ctnetlink_glue_attach_expect,
 	.seq_adjust	= ctnetlink_glue_seqadj,
 	.register_hooks = ctnl_bind,
+	.newproto	= ctnl_newproto,
 };
 #endif /* CONFIG_NETFILTER_NETLINK_GLUE_CT */
 
@@ -3434,6 +3468,7 @@ static void ctnetlink_net_exit(struct net *net)
 		rcu_read_lock();
 	}
 
+	ctnet->active = false;
 	rcu_read_unlock();
 }
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 1fb11b6..20d51e4 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -259,6 +259,7 @@ int nf_ct_l3proto_register(struct nf_conntrack_l3proto *proto)
 {
 	int ret = 0;
 	struct nf_conntrack_l3proto *old;
+	struct nfnl_ct_hook *nfnl_ct;
 
 	if (proto->l3proto >= AF_MAX)
 		return -EBUSY;
@@ -279,6 +280,11 @@ int nf_ct_l3proto_register(struct nf_conntrack_l3proto *proto)
 
 	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto], proto);
 
+	rcu_read_lock();
+	nfnl_ct = rcu_dereference(nfnl_ct_hook);
+	if (nfnl_ct)
+		nfnl_ct->newproto();
+	rcu_read_unlock();
 out_unlock:
 	mutex_unlock(&nf_ct_proto_mutex);
 	return ret;
-- 
2.4.10

