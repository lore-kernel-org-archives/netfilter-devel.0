From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/4] netfilter: conntrack: replace notify chain by function
	pointer
Date: Sat, 02 May 2009 16:20:04 +0200
Message-ID: <20090502142004.8067.1431.stgit@Decadence>
References: <20090502141522.8067.436.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632AbZEBOUN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2009 10:20:13 -0400
In-Reply-To: <20090502141522.8067.436.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes the notify chain infrastructure and replace it
by a simple function pointer. This issue has been mentioned in the
mailing list several times: the use of the notify chain adds
too much overhead for something that is only used by ctnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_ecache.h |   68 +++++++++++++-----
 net/netfilter/nf_conntrack_ecache.c         |  101 +++++++++++++++++++++++----
 net/netfilter/nf_conntrack_netlink.c        |   37 +++++-----
 3 files changed, 150 insertions(+), 56 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 2e17a2d..39efacb 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -6,7 +6,6 @@
 #define _NF_CONNTRACK_ECACHE_H
 #include <net/netfilter/nf_conntrack.h>
 
-#include <linux/notifier.h>
 #include <linux/interrupt.h>
 #include <net/net_namespace.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -69,9 +68,13 @@ struct nf_ct_event {
 	int report;
 };
 
-extern struct atomic_notifier_head nf_conntrack_chain;
-extern int nf_conntrack_register_notifier(struct notifier_block *nb);
-extern int nf_conntrack_unregister_notifier(struct notifier_block *nb);
+struct nf_ct_event_notifier {
+	int (*fcn)(unsigned int events, struct nf_ct_event *item);
+};
+
+extern struct nf_ct_event_notifier *nf_conntrack_event_cb;
+extern int nf_conntrack_register_notifier(struct nf_ct_event_notifier *nb);
+extern int nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *nb);
 
 extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
 extern void __nf_ct_event_cache_init(struct nf_conn *ct);
@@ -97,13 +100,23 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 			  u32 pid,
 			  int report)
 {
-	struct nf_ct_event item = {
-		.ct 	= ct,
-		.pid	= pid,
-		.report = report
-	};
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-		atomic_notifier_call_chain(&nf_conntrack_chain, event, &item);
+	struct nf_ct_event_notifier *notify;
+
+	rcu_read_lock();
+	notify = rcu_dereference(nf_conntrack_event_cb);
+	if (notify == NULL)
+		goto out_unlock;
+
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
+		struct nf_ct_event item = {
+			.ct 	= ct,
+			.pid	= pid,
+			.report = report
+		};
+		notify->fcn(event, &item);
+	}
+out_unlock:
+	rcu_read_unlock();
 }
 
 static inline void
@@ -118,9 +131,13 @@ struct nf_exp_event {
 	int report;
 };
 
-extern struct atomic_notifier_head nf_ct_expect_chain;
-extern int nf_ct_expect_register_notifier(struct notifier_block *nb);
-extern int nf_ct_expect_unregister_notifier(struct notifier_block *nb);
+struct nf_exp_event_notifier {
+	int (*fcn)(unsigned int events, struct nf_exp_event *item);
+};
+
+extern struct nf_exp_event_notifier *nf_expect_event_cb;
+extern int nf_ct_expect_register_notifier(struct nf_exp_event_notifier *nb);
+extern int nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *nb);
 
 static inline void
 nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
@@ -128,12 +145,23 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  u32 pid,
 			  int report)
 {
-	struct nf_exp_event item = {
-		.exp	= exp,
-		.pid	= pid,
-		.report = report
-	};
-	atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+	struct nf_exp_event_notifier *notify;
+
+	rcu_read_lock();
+	notify = rcu_dereference(nf_expect_event_cb);
+	if (notify == NULL)
+		goto out_unlock;
+
+	{
+		struct nf_exp_event item = {
+			.exp	= exp,
+			.pid	= pid,
+			.report = report
+		};
+		notify->fcn(event, &item);
+	}
+out_unlock:
+	rcu_read_unlock();
 }
 
 static inline void
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index dee4190..780278b 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -16,24 +16,32 @@
 #include <linux/stddef.h>
 #include <linux/err.h>
 #include <linux/percpu.h>
-#include <linux/notifier.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 
-ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
-EXPORT_SYMBOL_GPL(nf_conntrack_chain);
+static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
-ATOMIC_NOTIFIER_HEAD(nf_ct_expect_chain);
-EXPORT_SYMBOL_GPL(nf_ct_expect_chain);
+struct nf_ct_event_notifier *nf_conntrack_event_cb;
+EXPORT_SYMBOL_GPL(nf_conntrack_event_cb);
+
+struct nf_exp_event_notifier *nf_expect_event_cb;
+EXPORT_SYMBOL_GPL(nf_expect_event_cb);
 
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 static inline void
 __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
 {
+	struct nf_ct_event_notifier *notify;
+
+	rcu_read_lock();
+	notify = rcu_dereference(nf_conntrack_event_cb);
+	if (notify == NULL)
+		goto out_unlock;
+
 	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
 	    && ecache->events) {
 		struct nf_ct_event item = {
@@ -42,14 +50,15 @@ __nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
 			.report	= 0
 		};
 
-		atomic_notifier_call_chain(&nf_conntrack_chain,
-					   ecache->events,
-					   &item);
+		notify->fcn(ecache->events, &item);
 	}
 
 	ecache->events = 0;
 	nf_ct_put(ecache->ct);
 	ecache->ct = NULL;
+
+out_unlock:
+	rcu_read_unlock();
 }
 
 /* Deliver all cached events for a particular conntrack. This is called
@@ -111,26 +120,86 @@ void nf_conntrack_ecache_fini(struct net *net)
 	free_percpu(net->ct.ecache);
 }
 
-int nf_conntrack_register_notifier(struct notifier_block *nb)
+int nf_conntrack_register_notifier(struct nf_ct_event_notifier *new)
 {
-	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
+	int ret = 0;
+	struct nf_ct_event_notifier *notify;
+
+	mutex_lock(&nf_ct_ecache_mutex);
+	notify = rcu_dereference(nf_conntrack_event_cb);
+	if (notify != NULL) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	rcu_assign_pointer(nf_conntrack_event_cb, new);
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
+
+out_unlock:
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
-int nf_conntrack_unregister_notifier(struct notifier_block *nb)
+int nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *new)
 {
-	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
+	int ret = 0;
+	struct nf_ct_event_notifier *notify;
+
+	mutex_lock(&nf_ct_ecache_mutex);
+	notify = rcu_dereference(nf_conntrack_event_cb);
+	if (notify != new) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	rcu_assign_pointer(nf_conntrack_event_cb, NULL);
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
+
+out_unlock:
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
-int nf_ct_expect_register_notifier(struct notifier_block *nb)
+int nf_ct_expect_register_notifier(struct nf_exp_event_notifier *new)
 {
-	return atomic_notifier_chain_register(&nf_ct_expect_chain, nb);
+	int ret = 0;
+	struct nf_exp_event_notifier *notify;
+
+	mutex_lock(&nf_ct_ecache_mutex);
+	notify = rcu_dereference(nf_expect_event_cb);
+	if (notify != NULL) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	rcu_assign_pointer(nf_expect_event_cb, new);
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
+
+out_unlock:
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
 
-int nf_ct_expect_unregister_notifier(struct notifier_block *nb)
+int nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *new)
 {
-	return atomic_notifier_chain_unregister(&nf_ct_expect_chain, nb);
+	int ret = 0;
+	struct nf_exp_event_notifier *notify;
+
+	mutex_lock(&nf_ct_ecache_mutex);
+	notify = rcu_dereference(nf_expect_event_cb);
+	if (notify != new) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	rcu_assign_pointer(nf_expect_event_cb, NULL);
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
+
+out_unlock:
+	mutex_unlock(&nf_ct_ecache_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 18ee471..addd6e5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -27,7 +27,6 @@
 #include <linux/netlink.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/notifier.h>
 
 #include <linux/netfilter.h>
 #include <net/netlink.h>
@@ -477,13 +476,12 @@ ctnetlink_alloc_skb(const struct nf_conntrack_tuple *tuple, gfp_t gfp)
 	return alloc_skb(len, gfp);
 }
 
-static int ctnetlink_conntrack_event(struct notifier_block *this,
-				     unsigned long events, void *ptr)
+static int
+ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	struct nf_ct_event *item = (struct nf_ct_event *)ptr;
 	struct nf_conn *ct = item->ct;
 	struct sk_buff *skb;
 	unsigned int type;
@@ -492,7 +490,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
-		return NOTIFY_DONE;
+		return 0;
 
 	if (events & IPCT_DESTROY) {
 		type = IPCTNL_MSG_CT_DELETE;
@@ -505,10 +503,10 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
-		return NOTIFY_DONE;
+		return 0;
 
 	if (!item->report && !nfnetlink_has_listeners(group))
-		return NOTIFY_DONE;
+		return 0;
 
 	skb = ctnetlink_alloc_skb(tuple(ct, IP_CT_DIR_ORIGINAL), GFP_ATOMIC);
 	if (!skb)
@@ -586,7 +584,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, item->pid, group, item->report);
-	return NOTIFY_DONE;
+	return 0;
 
 nla_put_failure:
 	rcu_read_unlock();
@@ -594,7 +592,7 @@ nlmsg_failure:
 	kfree_skb(skb);
 errout:
 	nfnetlink_set_err(0, group, -ENOBUFS);
-	return NOTIFY_DONE;
+	return 0;
 }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
@@ -1540,12 +1538,11 @@ nla_put_failure:
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-static int ctnetlink_expect_event(struct notifier_block *this,
-				  unsigned long events, void *ptr)
+static int
+ctnetlink_expect_event(unsigned int events, struct nf_exp_event *item)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
-	struct nf_exp_event *item = (struct nf_exp_event *)ptr;
 	struct nf_conntrack_expect *exp = item->exp;
 	struct sk_buff *skb;
 	unsigned int type;
@@ -1556,11 +1553,11 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 		type = IPCTNL_MSG_EXP_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 	} else
-		return NOTIFY_DONE;
+		return 0;
 
 	if (!item->report &&
 	    !nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
-		return NOTIFY_DONE;
+		return 0;
 
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
@@ -1584,7 +1581,7 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, item->pid, NFNLGRP_CONNTRACK_EXP_NEW, item->report);
-	return NOTIFY_DONE;
+	return 0;
 
 nla_put_failure:
 	rcu_read_unlock();
@@ -1592,7 +1589,7 @@ nlmsg_failure:
 	kfree_skb(skb);
 errout:
 	nfnetlink_set_err(0, 0, -ENOBUFS);
-	return NOTIFY_DONE;
+	return 0;
 }
 #endif
 static int ctnetlink_exp_done(struct netlink_callback *cb)
@@ -1898,12 +1895,12 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-static struct notifier_block ctnl_notifier = {
-	.notifier_call	= ctnetlink_conntrack_event,
+static struct nf_ct_event_notifier ctnl_notifier = {
+	.fcn = ctnetlink_conntrack_event,
 };
 
-static struct notifier_block ctnl_notifier_exp = {
-	.notifier_call	= ctnetlink_expect_event,
+static struct nf_exp_event_notifier ctnl_notifier_exp = {
+	.fcn = ctnetlink_expect_event,
 };
 #endif
 

