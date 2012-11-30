From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: remove extra timer from ecache extension
Date: Fri, 30 Nov 2012 21:16:05 +0100
Message-ID: <1354306565-2289-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35423 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759957Ab2K3UTg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:19:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This brings the (per-conntrack) ecache extension back to 24 bytes in
size (was 112 byte on x86_64 with lockdep on).

Instead we use a per-ns tasklet to re-trigger event delivery.
When we enqueue a ct entry into the dying list, the tasklet
is scheduled.

The tasklet will then deliver up to 20 entries.  It will
re-sched itself if not all the pending events could be delivered.

While at it, dying list handling is moved into ecache.c, since its
only revlevant if ct events are enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Note: Conflicts with "improve conntrack object traceability".

 The patch assumes the dying list only contains entries where the delete
 event has not been delivered yet.

 With that patch, all conntracks are put on the dying list, including
 those who are about to be free'd.

 I THINK that this is fixable by skipping dying-list entries with
 IPS_DYING_BIT set.  However, this will increase the tasket workload.

 Any other ideas?

 include/net/netfilter/nf_conntrack.h        |    1 -
 include/net/netfilter/nf_conntrack_ecache.h |    9 +++-
 include/net/netns/conntrack.h               |    5 +-
 net/netfilter/nf_conntrack_core.c           |   58 -------------------
 net/netfilter/nf_conntrack_ecache.c         |   80 +++++++++++++++++++++++---
 5 files changed, 82 insertions(+), 71 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f1494fe..e1cc862 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -182,7 +182,6 @@ __nf_conntrack_find(struct net *net, u16 zone,
 
 extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 extern void nf_ct_delete_from_lists(struct nf_conn *ct);
-extern void nf_ct_insert_dying_list(struct nf_conn *ct);
 
 extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 5654d29..4b31c00 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,7 +18,6 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 portid;		/* netlink portid of destroyer */
-	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
@@ -207,6 +206,8 @@ nf_ct_expect_event(enum ip_conntrack_expect_events event,
 	nf_ct_expect_event_report(event, exp, 0, 0);
 }
 
+extern void nf_ct_insert_dying_list(struct nf_conn *ct);
+extern void nf_ct_release_dying_list(struct net *net);
 extern int nf_conntrack_ecache_init(struct net *net);
 extern void nf_conntrack_ecache_fini(struct net *net);
 
@@ -232,6 +233,12 @@ static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
  					     u32 portid,
  					     int report) {}
 
+static inline void nf_ct_insert_dying_list(struct nf_conn *ct)
+{
+	WARN_ON_ONCE(1); /* never called when CONFIG_NF_CONNTRACK_EVENTS=n */
+}
+static inline void nf_ct_release_dying_list(struct net *net) {}
+
 static inline int nf_conntrack_ecache_init(struct net *net)
 {
 	return 0;
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index a1d83cc..0cef968 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/list_nulls.h>
 #include <linux/atomic.h>
+#include <linux/interrupt.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 
 struct ctl_table_header;
@@ -71,11 +72,13 @@ struct netns_ct {
 	struct hlist_head	*expect_hash;
 	struct hlist_nulls_head	unconfirmed;
 	struct hlist_nulls_head	dying;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	struct tasklet_struct dying_tasklet;
+#endif
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 	int			sysctl_events;
-	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
 	int			sysctl_tstamp;
 	int			sysctl_checksum;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0f241be..09c9046 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -251,49 +251,6 @@ void nf_ct_delete_from_lists(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_ct_delete_from_lists);
 
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
-			(random32() % net->ct.sysctl_events_retry_timeout);
-		add_timer(&ecache->timeout);
-		return;
-	}
-	/* we've got the event delivered, now it's dying */
-	set_bit(IPS_DYING_BIT, &ct->status);
-	spin_lock(&nf_conntrack_lock);
-	hlist_nulls_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
-	spin_unlock(&nf_conntrack_lock);
-	nf_ct_put(ct);
-}
-
-void nf_ct_insert_dying_list(struct nf_conn *ct)
-{
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
-
-	BUG_ON(ecache == NULL);
-
-	/* add this conntrack to the dying list */
-	spin_lock_bh(&nf_conntrack_lock);
-	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
-			     &net->ct.dying);
-	spin_unlock_bh(&nf_conntrack_lock);
-	/* set a new timer to retry event delivery */
-	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
-	ecache->timeout.expires = jiffies +
-		(random32() % net->ct.sysctl_events_retry_timeout);
-	add_timer(&ecache->timeout);
-}
-EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
-
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
@@ -1311,21 +1268,6 @@ void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
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
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index de9781b..5bc0403 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -27,6 +27,38 @@
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
+static void dying_tasklet_retry_events(unsigned long ctnetns)
+{
+	struct netns_ct *ctnet = (void *) ctnetns;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	struct nf_conn *ct;
+	int err = 0;
+	int budget = 20;
+
+	hlist_nulls_for_each_entry(h, n, &ctnet->dying, hnnode) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+
+		err = nf_conntrack_event(IPCT_DESTROY, ct);
+		if (err)
+			break;
+		spin_lock_bh(&nf_conntrack_lock);
+		hlist_nulls_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+		spin_unlock_bh(&nf_conntrack_lock);
+
+		/* we've got the event delivered, now it's dying */
+		set_bit(IPS_DYING_BIT, &ct->status);
+
+		nf_ct_put(ct);
+		if (--budget == 0)
+			break;
+	}
+
+	/* err or budget exhausted? -> dying list not empty -- resched. */
+	if (err || budget == 0)
+		tasklet_schedule(&ctnet->dying_tasklet);
+}
+
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
@@ -81,6 +113,39 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
+void nf_ct_insert_dying_list(struct nf_conn *ct)
+{
+	struct net *net = nf_ct_net(ct);
+
+	/* add this conntrack to the dying list */
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+			     &net->ct.dying);
+	spin_unlock_bh(&nf_conntrack_lock);
+
+	/* retry event delivery */
+	tasklet_schedule(&net->ct.dying_tasklet);
+}
+EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
+
+void nf_ct_release_dying_list(struct net *net)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
+	struct hlist_nulls_node *n;
+
+	/* no listeners at this point */
+	hlist_nulls_for_each_entry(h, n, &net->ct.dying, hnnode) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+
+		spin_lock_bh(&nf_conntrack_lock);
+		hlist_nulls_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+		spin_unlock_bh(&nf_conntrack_lock);
+
+		nf_ct_put(ct);
+	}
+}
+
 int nf_conntrack_register_notifier(struct net *net,
 				   struct nf_ct_event_notifier *new)
 {
@@ -155,7 +220,6 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
-static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -166,13 +230,6 @@ static struct ctl_table event_sysctl_table[] = {
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
@@ -194,7 +251,6 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
-	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	net->ct.event_sysctl_header =
 		register_net_sysctl(net, "net/netfilter", table);
@@ -234,7 +290,9 @@ int nf_conntrack_ecache_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_events = nf_ct_events;
-	net->ct.sysctl_events_retry_timeout = nf_ct_events_retry_timeout;
+
+	tasklet_init(&net->ct.dying_tasklet, dying_tasklet_retry_events,
+						(unsigned long) &net->ct);
 
 	if (net_eq(net, &init_net)) {
 		ret = nf_ct_extend_register(&event_extend);
@@ -260,6 +318,8 @@ out_extend_register:
 
 void nf_conntrack_ecache_fini(struct net *net)
 {
+	tasklet_kill(&net->ct.dying_tasklet);
+
 	nf_conntrack_event_fini_sysctl(net);
 	if (net_eq(net, &init_net))
 		nf_ct_extend_unregister(&event_extend);
-- 
1.7.8.6

