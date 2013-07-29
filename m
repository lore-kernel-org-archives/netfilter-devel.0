From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 7/7] netfilter: conntrack: remove timer from ecache extension
Date: Mon, 29 Jul 2013 15:41:56 +0200
Message-ID: <1375105316-13216-8-git-send-email-fw@strlen.de>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52402 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180Ab3G2Nkc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:40:32 -0400
In-Reply-To: <1375105316-13216-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This brings the (per-conntrack) ecache extension back to 24 bytes in size
(was 112 byte on x86_64 with lockdep on).

When event delivery fails, re-delivery is attempted via work queue.
As long as the work queue has events to deliver, and at least one
delivery succeeded, it is rescheduled without delay,  if no
pending event was delivered after 0.1 seconds to avoid hogging cpu.

As the dying list also contains entries that do not need event
redelivery, a new status bit is added to identify these conntracks.

We cannot use !IPS_DYING_BIT, as entries whose event was already
sent can be recycled at any time due to SLAB_DESTROY_BY_RCU.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h               |    7 ++
 include/net/netfilter/nf_conntrack_ecache.h        |    9 ++-
 include/net/netns/conntrack.h                      |    5 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |    8 ++-
 net/netfilter/nf_conntrack_core.c                  |   68 ++------------------
 net/netfilter/nf_conntrack_ecache.c                |   63 +++++++++++++++---
 6 files changed, 85 insertions(+), 75 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 61767dc..9e56299 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -71,6 +71,13 @@ struct nf_conn_help {
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
+/*
+ * We need to use special "null" values, not used in hash table
+ */
+#define NFCT_UNCONFIRMED_NULLS_VAL	((1<<30)+0)
+#define NFCT_DYING_NULLS_VAL		((1<<30)+1)
+#define NFCT_TEMPLATE_NULLS_VAL		((1<<30)+2)
+
 struct nf_conn {
 	/* Usage count in here is 1 for hash table/destruct timer, 1 per skb,
            plus 1 for any connection(s) we are `master' for */
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 092dc65..1435245 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,7 +18,6 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 portid;		/* netlink portid of destroyer */
-	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
@@ -212,6 +211,12 @@ extern void nf_conntrack_ecache_pernet_fini(struct net *net);
 
 extern int nf_conntrack_ecache_init(void);
 extern void nf_conntrack_ecache_fini(void);
+
+static inline void nf_conntrack_ecache_work(struct net *net)
+{
+	if (!delayed_work_pending(&net->ct.ecache_dwork))
+		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
+}
 #else /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
@@ -251,6 +256,8 @@ static inline int nf_conntrack_ecache_init(void)
 static inline void nf_conntrack_ecache_fini(void)
 {
 }
+
+static inline void nf_conntrack_ecache_work(struct net *net) { }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 #endif /*_NF_CONNTRACK_ECACHE_H*/
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index c9c0c53..ae58be0 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/list_nulls.h>
 #include <linux/atomic.h>
+#include <linux/workqueue.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 
 struct ctl_table_header;
@@ -72,11 +73,13 @@ struct netns_ct {
 	struct hlist_nulls_head	unconfirmed;
 	struct hlist_nulls_head	dying;
 	struct hlist_nulls_head tmpl;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	struct delayed_work ecache_dwork;
+#endif
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 	int			sysctl_events;
-	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index d69483f..4269a8b 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -68,7 +68,9 @@ enum ip_conntrack_status {
 	/* Both together */
 	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
 
-	/* Connection is dying (removed from lists), can not be unset. */
+	/* Connection is dying (removed from hash), DESTROY event delivered.
+	 * cannot be unset.
+	 */
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
 
@@ -87,6 +89,10 @@ enum ip_conntrack_status {
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Conntrack removed from hash, but ecache must re-deliver destroy event */
+	IPS_ECACHE_REDELIVER_BIT = 14,
+	IPS_ECACHE_REDELIVER = (1 << IPS_ECACHE_REDELIVER_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0161f83..4f3d496 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -249,45 +249,11 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 	NF_CT_STAT_INC(net, delete_list);
 	clean_from_lists(ct);
 	/* add this conntrack to the dying list */
-	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
 			     &net->ct.dying);
 	spin_unlock_bh(&nf_conntrack_lock);
 }
 
-static void death_by_event(unsigned long ul_conntrack)
-{
-	struct nf_conn *ct = (void *)ul_conntrack;
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
-
-	BUG_ON(ecache == NULL);
-
-	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
-		/* bad luck, let's retry again */
-		ecache->timeout.expires = jiffies +
-			(prandom_u32() % net->ct.sysctl_events_retry_timeout);
-		add_timer(&ecache->timeout);
-		return;
-	}
-	/* we've got the event delivered, now it's dying */
-	set_bit(IPS_DYING_BIT, &ct->status);
-	nf_ct_put(ct);
-}
-
-static void nf_ct_dying_timeout(struct nf_conn *ct)
-{
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
-
-	BUG_ON(ecache == NULL);
-
-	/* set a new timer to retry event delivery */
-	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
-	ecache->timeout.expires = jiffies +
-		(prandom_u32() % net->ct.sysctl_events_retry_timeout);
-	add_timer(&ecache->timeout);
-}
-
 bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 {
 	struct nf_conn_tstamp *tstamp;
@@ -301,7 +267,8 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 	    portid, report) < 0)) {
 		/* destroy event was not delivered */
 		nf_ct_delete_from_lists(ct);
-		nf_ct_dying_timeout(ct);
+		set_bit(IPS_ECACHE_REDELIVER_BIT, &ct->status);
+		nf_conntrack_ecache_work(nf_ct_net(ct));
 		return false;
 	}
 	set_bit(IPS_DYING_BIT, &ct->status);
@@ -1284,21 +1251,6 @@ void nf_conntrack_flush_report(struct net *net, u32 portid, int report)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
-static void nf_ct_release_dying_list(struct net *net)
-{
-	struct nf_conntrack_tuple_hash *h;
-	struct nf_conn *ct;
-	struct hlist_nulls_node *n;
-
-	spin_lock_bh(&nf_conntrack_lock);
-	hlist_nulls_for_each_entry(h, n, &net->ct.dying, hnnode) {
-		ct = nf_ct_tuplehash_to_ctrack(h);
-		/* never fails to remove them, no listeners at this point */
-		nf_ct_kill(ct);
-	}
-	spin_unlock_bh(&nf_conntrack_lock);
-}
-
 static int untrack_refs(void)
 {
 	int cnt = 0, cpu;
@@ -1362,7 +1314,6 @@ i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_ct_iterate_cleanup(net, kill_all, NULL, 0, 0);
-		nf_ct_release_dying_list(net);
 		if (atomic_read(&net->ct.count) != 0)
 			busy = 1;
 	}
@@ -1582,21 +1533,14 @@ void nf_conntrack_init_end(void)
 	RCU_INIT_POINTER(nf_ct_nat_offset, NULL);
 }
 
-/*
- * We need to use special "null" values, not used in hash table
- */
-#define UNCONFIRMED_NULLS_VAL	((1<<30)+0)
-#define DYING_NULLS_VAL		((1<<30)+1)
-#define TEMPLATE_NULLS_VAL	((1<<30)+2)
-
 int nf_conntrack_init_net(struct net *net)
 {
 	int ret;
 
 	atomic_set(&net->ct.count, 0);
-	INIT_HLIST_NULLS_HEAD(&net->ct.unconfirmed, UNCONFIRMED_NULLS_VAL);
-	INIT_HLIST_NULLS_HEAD(&net->ct.dying, DYING_NULLS_VAL);
-	INIT_HLIST_NULLS_HEAD(&net->ct.tmpl, TEMPLATE_NULLS_VAL);
+	INIT_HLIST_NULLS_HEAD(&net->ct.unconfirmed, NFCT_UNCONFIRMED_NULLS_VAL);
+	INIT_HLIST_NULLS_HEAD(&net->ct.dying, NFCT_DYING_NULLS_VAL);
+	INIT_HLIST_NULLS_HEAD(&net->ct.tmpl, NFCT_TEMPLATE_NULLS_VAL);
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat) {
 		ret = -ENOMEM;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 1df1761..bdb9491 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -22,6 +22,7 @@
 #include <linux/netdevice.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/rculist_nulls.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -29,6 +30,56 @@
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
+#define ECACHE_MAX_EVICTS 1000
+#define ECACHE_RETRY_WAIT (HZ/10) /* at most 10 retries/s when congested */
+
+static void ecache_work(struct work_struct *work)
+{
+	struct netns_ct *ctnet =
+		container_of(work, struct netns_ct, ecache_dwork.work);
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	unsigned int evicted = 0, delay;
+
+	mutex_lock(&nf_ct_ecache_mutex);
+	rcu_read_lock();
+
+	hlist_nulls_for_each_entry_rcu(h, n, &ctnet->dying, hnnode) {
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
+		if (!test_bit(IPS_ECACHE_REDELIVER_BIT, &ct->status) ||
+		    nf_ct_is_dying(ct))
+			continue;
+
+		if (nf_conntrack_event(IPCT_DESTROY, ct))
+			break;
+
+		/* we've got the event delivered, now it's dying */
+		set_bit(IPS_DYING_BIT, &ct->status);
+		nf_ct_put(ct);
+
+		if (++evicted >= ECACHE_MAX_EVICTS || need_resched())
+			break;
+	}
+
+	rcu_read_unlock();
+	mutex_unlock(&nf_ct_ecache_mutex);
+
+	if (is_a_nulls(n)) {
+		if (get_nulls_value(n) == NFCT_DYING_NULLS_VAL)
+			return; /* done, all events delivered */
+		/* else, found recycled element, restart */
+		delay = 0;
+	} else if (evicted) {
+		/* made some progress, restart */
+		delay = 0;
+	} else {
+		/* userspace is congested, back off */
+		delay = ECACHE_RETRY_WAIT;
+	}
+	schedule_delayed_work(&ctnet->ecache_dwork, delay);
+}
+
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
@@ -157,7 +208,6 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
-static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -168,13 +218,6 @@ static struct ctl_table event_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "nf_conntrack_events_retry_timeout",
-		.data		= &init_net.ct.sysctl_events_retry_timeout,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
 	{}
 };
 #endif /* CONFIG_SYSCTL */
@@ -196,7 +239,6 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
-	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	/* Don't export sysctls to unprivileged users */
 	if (net->user_ns != &init_user_ns)
@@ -238,12 +280,13 @@ static void nf_conntrack_event_fini_sysctl(struct net *net)
 int nf_conntrack_ecache_pernet_init(struct net *net)
 {
 	net->ct.sysctl_events = nf_ct_events;
-	net->ct.sysctl_events_retry_timeout = nf_ct_events_retry_timeout;
+	INIT_DELAYED_WORK(&net->ct.ecache_dwork, ecache_work);
 	return nf_conntrack_event_init_sysctl(net);
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
+	cancel_delayed_work_sync(&net->ct.ecache_dwork);
 	nf_conntrack_event_fini_sysctl(net);
 }
 
-- 
1.7.8.6

