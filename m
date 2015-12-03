From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 11/12] netfilter: hook up nfnetlink log/queue to register conntrack hooks
Date: Thu,  3 Dec 2015 10:49:44 +0100
Message-ID: <1449136185-4165-12-git-send-email-fw@strlen.de>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52616 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933004AbbLCJuc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:50:32 -0500
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If userspace using nfqueue or nflog requests conntrack info, make sure
that we register the conntrack netfilter hooks in the affected netns.

This is a one-shot scheme: There is no unregister equivalent (except when backend
conntrack l3proto module is unloaded or the network namespace is removed).

Once nflog/nfqueue wants conntrack, the hooks are activated without being
able to unregister the hooks again.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not part of v2 series.
 This is a seperate patch to ease review.

 include/linux/netfilter.h            |  1 +
 net/netfilter/nf_conntrack_netlink.c |  1 +
 net/netfilter/nfnetlink_log.c        | 28 ++++++++++++++++++----------
 net/netfilter/nfnetlink_queue.c      |  8 ++++++++
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9230f9a..c3cf796 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -396,6 +396,7 @@ struct nfnl_ct_hook {
 			     u32 portid, u32 report);
 	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo, s32 off);
+	int (*register_hooks)(struct net *);
 };
 extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b8a4067..0a9b1e9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2451,6 +2451,7 @@ static struct nfnl_ct_hook ctnetlink_glue_hook = {
 	.parse		= ctnetlink_glue_parse,
 	.attach_expect	= ctnetlink_glue_attach_expect,
 	.seq_adjust	= ctnetlink_glue_seqadj,
+	.register_hooks = ctnl_bind,
 };
 #endif /* CONFIG_NETFILTER_NETLINK_GLUE_CT */
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index dea4676..229685d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -853,19 +853,27 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	if (nfula[NFULA_CFG_FLAGS]) {
 		flags = ntohs(nla_get_be16(nfula[NFULA_CFG_FLAGS]));
 
-		if ((flags & NFULNL_CFG_F_CONNTRACK) &&
-		    !rcu_access_pointer(nfnl_ct_hook)) {
+		if (flags & NFULNL_CFG_F_CONNTRACK) {
+			struct nfnl_ct_hook *nfnl_ct;
+
+			nfnl_ct = rcu_dereference(nfnl_ct_hook);
+			if (!nfnl_ct) {
 #ifdef CONFIG_MODULES
-			nfnl_unlock(NFNL_SUBSYS_ULOG);
-			request_module("ip_conntrack_netlink");
-			nfnl_lock(NFNL_SUBSYS_ULOG);
-			if (rcu_access_pointer(nfnl_ct_hook)) {
-				ret = -EAGAIN;
+				nfnl_unlock(NFNL_SUBSYS_ULOG);
+				request_module("ip_conntrack_netlink");
+				nfnl_lock(NFNL_SUBSYS_ULOG);
+
+				if (rcu_access_pointer(nfnl_ct_hook)) {
+					ret = -EAGAIN;
+					goto out_put;
+				}
+#endif
+				ret = -EOPNOTSUPP;
 				goto out_put;
+
 			}
-#endif
-			ret = -EOPNOTSUPP;
-			goto out_put;
+
+			nfnl_ct->register_hooks(net);
 		}
 	}
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7d81d28..235f4c1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1222,6 +1222,14 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			goto err_out_unlock;
 		}
 #endif
+		if (flags & mask & NFQA_CFG_F_CONNTRACK) {
+			struct nfnl_ct_hook *nfnl_ct;
+
+			nfnl_ct = rcu_dereference(nfnl_ct_hook);
+			if (nfnl_ct)
+				nfnl_ct->register_hooks(net);
+		}
+
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
-- 
2.4.10

