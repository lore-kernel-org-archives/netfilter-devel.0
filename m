From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next V2] netfilter: remove extra timer from ecache extension
Date: Thu,  3 Jan 2013 17:36:43 +0100
Message-ID: <1357231003-1241-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55683 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476Ab3ACQem (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:34:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This brings the (per-conntrack) ecache extension back to 24 bytes in
size (was 112 byte on x86_64 with lockdep on).

Instead we use a per-ns timer to re-trigger event delivery.  When we
enqueue a ct entry into the dying list, the timer will be scheduled.

The timer will then deliver up to 20 entries.  If not all pending entries
could be delivered, it will re-add itself to run again after 2 jiffies.
This gives userspace consumers time to drain their sockets.

When userspace listeners don't accept events at all, re-try is done
after 10ms.

If an event was sucessfully delivered via the normal delivery path,
we take this as a hint that userspace has processed its backlog and
re-try pending entries on the next timer tick.
This speeds up re-delivery without adding too much overhead.

While at it, dying list handling is moved into ecache.c, since its only
revlevant if ct events are enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo,

 it would be great if you could give this one a spin in your
 conntrackd testsetup.

 It avoids the "perpertual-busy-retry" of the previous
 tasklet-based approach.

 include/net/netfilter/nf_conntrack.h        |    1 -
 include/net/netfilter/nf_conntrack_ecache.h |   15 ++++++-
 include/net/netns/conntrack.h               |    5 ++-
 net/netfilter/nf_conntrack_core.c           |   55 +----------------------
 net/netfilter/nf_conntrack_ecache.c         |   64 ++++++++++++++++++++++----
 net/netfilter/nf_conntrack_netlink.c        |    2 +-
 6 files changed, 76 insertions(+), 66 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index caca0c4..e1cc862 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -182,7 +182,6 @@ __nf_conntrack_find(struct net *net, u16 zone,
 
 extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 extern void nf_ct_delete_from_lists(struct nf_conn *ct);
-extern void nf_ct_dying_timeout(struct nf_conn *ct);
 
 extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 5654d29..cb46cfc 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,7 +18,6 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 portid;		/* netlink portid of destroyer */
-	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
@@ -210,6 +209,17 @@ nf_ct_expect_event(enum ip_conntrack_expect_events event,
 extern int nf_conntrack_ecache_init(struct net *net);
 extern void nf_conntrack_ecache_fini(struct net *net);
 
+static inline void nf_ct_dying_timer_set(struct net *net)
+{
+	if (!net->ct.dying_backlogged)
+		mod_timer(&net->ct.dying_timer, jiffies);
+}
+
+static inline void nf_ct_dying_timer_retry(struct net *net)
+{
+	if (net->ct.dying_backlogged)
+		mod_timer(&net->ct.dying_timer, jiffies);
+}
 #else /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
@@ -232,6 +242,9 @@ static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
  					     u32 portid,
  					     int report) {}
 
+static inline void nf_ct_dying_timer_set(struct net *net) { }
+static inline void nf_ct_dying_timer_retry(struct net *net) { }
+
 static inline int nf_conntrack_ecache_init(struct net *net)
 {
 	return 0;
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index a1d83cc..cc39bd8 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -71,11 +71,14 @@ struct netns_ct {
 	struct hlist_head	*expect_hash;
 	struct hlist_nulls_head	unconfirmed;
 	struct hlist_nulls_head	dying;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	struct timer_list dying_timer;
+	bool dying_backlogged;
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
index 08cdc71..03a275c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -252,41 +252,6 @@ void nf_ct_delete_from_lists(struct nf_conn *ct)
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
-	nf_ct_put(ct);
-}
-
-void nf_ct_dying_timeout(struct nf_conn *ct)
-{
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
-
-	BUG_ON(ecache == NULL);
-
-	/* set a new timer to retry event delivery */
-	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
-	ecache->timeout.expires = jiffies +
-		(random32() % net->ct.sysctl_events_retry_timeout);
-	add_timer(&ecache->timeout);
-}
-EXPORT_SYMBOL_GPL(nf_ct_dying_timeout);
-
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
@@ -300,12 +265,13 @@ static void death_by_timeout(unsigned long ul_conntrack)
 	    unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
 		/* destroy event was not delivered */
 		nf_ct_delete_from_lists(ct);
-		nf_ct_dying_timeout(ct);
+		nf_ct_dying_timer_set(nf_ct_net(ct));
 		return;
 	}
 	set_bit(IPS_DYING_BIT, &ct->status);
 	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
+	nf_ct_dying_timer_retry(nf_ct_net(ct));
 }
 
 /*
@@ -1304,21 +1270,6 @@ void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
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
@@ -1345,7 +1296,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 {
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
-	nf_ct_release_dying_list(net);
+	nf_ct_dying_timer_set(net);
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
 		goto i_see_dead_people;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index faa978f..714d0bd 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -25,8 +25,58 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
+#define RETRY_INTERVAL (HZ/10)
+#define RETRY_BUDGET 20
+
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
+static void dying_timer_retry_events(unsigned long ctnetns)
+{
+	struct netns_ct *ctnet = (void *) ctnetns;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	struct nf_conn *ct;
+	int err = 0;
+	int budget = RETRY_BUDGET;
+	unsigned long now = jiffies;
+
+	rcu_read_lock();
+
+	hlist_nulls_for_each_entry(h, n, &ctnet->dying, hnnode) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (test_bit(IPS_DYING_BIT, &ct->status))
+			continue;
+		err = nf_conntrack_event(IPCT_DESTROY, ct);
+		if (err)
+			break;
+		/* we've got the event delivered, now it's dying */
+		set_bit(IPS_DYING_BIT, &ct->status);
+		nf_ct_put(ct);
+		if (--budget == 0)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	if (err) {
+		if (!ctnet->dying_backlogged)
+			ctnet->dying_backlogged = true;
+
+		if (budget == RETRY_BUDGET)
+			now += RETRY_INTERVAL;
+		else
+			now += 2;
+
+		mod_timer(&ctnet->dying_timer, now);
+	} else if (budget == 0) { /* might be able to deliver more */
+		mod_timer(&ctnet->dying_timer, now);
+	} else if (ctnet->dying_backlogged) {
+		ctnet->dying_backlogged = false;
+		/* All entries delivered, but other cpu might have added more */
+		mod_timer(&ctnet->dying_timer, now + RETRY_INTERVAL);
+	}
+}
+
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
@@ -155,7 +205,6 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
-static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -166,13 +215,6 @@ static struct ctl_table event_sysctl_table[] = {
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
@@ -194,7 +236,6 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
-	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	/* Don't export sysctls to unprivileged users */
 	if (net->user_ns != &init_user_ns)
@@ -238,8 +279,9 @@ int nf_conntrack_ecache_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_events = nf_ct_events;
-	net->ct.sysctl_events_retry_timeout = nf_ct_events_retry_timeout;
 
+	setup_timer(&net->ct.dying_timer, dying_timer_retry_events,
+					(unsigned long) &net->ct);
 	if (net_eq(net, &init_net)) {
 		ret = nf_ct_extend_register(&event_extend);
 		if (ret < 0) {
@@ -264,6 +306,8 @@ out_extend_register:
 
 void nf_conntrack_ecache_fini(struct net *net)
 {
+	del_timer(&net->ct.dying_timer);
+
 	nf_conntrack_event_fini_sysctl(net);
 	if (net_eq(net, &init_net))
 		nf_ct_extend_unregister(&event_extend);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4e078cd..31d685d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -992,7 +992,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 					      nlmsg_report(nlh)) < 0) {
 			nf_ct_delete_from_lists(ct);
 			/* we failed to report the event, try later */
-			nf_ct_dying_timeout(ct);
+			nf_ct_dying_timer_set(net);
 			nf_ct_put(ct);
 			return 0;
 		}
-- 
1.7.8.6

