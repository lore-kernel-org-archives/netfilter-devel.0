From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: conntrack: remove timer from ecache extension
Date: Thu, 27 Mar 2014 19:00:38 +0100
Message-ID: <1395943238-29319-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40517 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbaC0SFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:05:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This brings the (per-conntrack) ecache extension back to 24 bytes in size
(was 152 byte on x86_64 with lockdep on).

When event delivery fails, re-delivery is attempted via work queue.
As long as the work queue has events to deliver, and at least one
delivery succeeded, it is rescheduled without delay,  if no
pending event was delivered after 0.1 seconds to avoid hogging cpu.

As the dying list also contains entries that do not need event
redelivery, a new status bit is added to identify these conntracks.

We cannot use !IPS_DYING_BIT, as entries whose event was already
sent can be recycled at any time due to SLAB_DESTROY_BY_RCU.

When userspace is heavily backlogged/overloaded, redelivery attempts
every 0.1 seconds are not enough.  To avoid this, the ecache work
is scheduled for immediate execution iff we have pending conntracks
and a conntrack expired successfully (i.e., userspace consumed the
event and is thus likely to accept more messages).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This is not replacement for 'u16 len' patch submitted recently because this
 is not stable material.

 Adding new status bit is not nice, but only alternative is
 adding new 'ecache redelivery' list, which would mean we alter current
 lifecycle (unconfirmed list -> hash list -> dying list).

 Would also need to add ability to dump new list via ctnetlink.

 I'm mainly interested if you think timer removal is worthwile,
 it works well in practice from usability POV.

 include/net/netfilter/nf_conntrack.h               |  7 ++
 include/net/netfilter/nf_conntrack_ecache.h        | 26 +++++-
 include/net/netns/conntrack.h                      |  6 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |  8 +-
 net/netfilter/nf_conntrack_core.c                  | 83 ++++---------------
 net/netfilter/nf_conntrack_ecache.c                | 96 +++++++++++++++++++---
 6 files changed, 143 insertions(+), 83 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 37252f7..1822d4a 100644
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
 	 * plus 1 for any connection(s) we are `master' for
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0e3d08e..57c8803 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,7 +18,6 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 portid;		/* netlink portid of destroyer */
-	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
@@ -216,8 +215,23 @@ void nf_conntrack_ecache_pernet_fini(struct net *net);
 
 int nf_conntrack_ecache_init(void);
 void nf_conntrack_ecache_fini(void);
-#else /* CONFIG_NF_CONNTRACK_EVENTS */
 
+static inline void nf_conntrack_ecache_delayed_work(struct net *net)
+{
+	if (!delayed_work_pending(&net->ct.ecache_dwork)) {
+		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
+		net->ct.ecache_dwork_pending = true;
+	}
+}
+
+static inline void nf_conntrack_ecache_work(struct net *net)
+{
+	if (net->ct.ecache_dwork_pending) {
+		net->ct.ecache_dwork_pending = false;
+		mod_delayed_work(system_wq, &net->ct.ecache_dwork, 0);
+	}
+}
+#else /* CONFIG_NF_CONNTRACK_EVENTS */
 static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
 					    struct nf_conn *ct) {}
 static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
@@ -255,6 +269,14 @@ static inline int nf_conntrack_ecache_init(void)
 static inline void nf_conntrack_ecache_fini(void)
 {
 }
+
+static inline void nf_conntrack_ecache_delayed_work(struct net *net)
+{
+}
+
+static inline void nf_conntrack_ecache_work(struct net *net)
+{
+}
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 #endif /*_NF_CONNTRACK_ECACHE_H*/
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 773cce3..29d6a94 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -4,6 +4,7 @@
 #include <linux/list.h>
 #include <linux/list_nulls.h>
 #include <linux/atomic.h>
+#include <linux/workqueue.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/seqlock.h>
 
@@ -73,6 +74,10 @@ struct ct_pcpu {
 struct netns_ct {
 	atomic_t		count;
 	unsigned int		expect_count;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	struct delayed_work ecache_dwork;
+	bool ecache_dwork_pending;
+#endif
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 	struct ctl_table_header	*acct_sysctl_header;
@@ -82,7 +87,6 @@ struct netns_ct {
 #endif
 	char			*slabname;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
-	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_events;
 	int			sysctl_acct;
 	int			sysctl_auto_assign_helper;
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 319f471..f21618d 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -72,7 +72,9 @@ enum ip_conntrack_status {
 	/* Both together */
 	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
 
-	/* Connection is dying (removed from lists), can not be unset. */
+	/* Connection is dying (removed from hash) and netlink destroy
+	 * event was sent sucessfully.  Cannot be unset.
+	 */
 	IPS_DYING_BIT = 9,
 	IPS_DYING = (1 << IPS_DYING_BIT),
 
@@ -91,6 +93,10 @@ enum ip_conntrack_status {
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Removed from hash, but destroy event must be re-sent */
+	IPS_ECACHE_REDELIVER_BIT = 14,
+	IPS_ECACHE_REDELIVER = (1 << IPS_ECACHE_REDELIVER_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5d1e7d1..d335b8c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -352,40 +352,6 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 	local_bh_enable();
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
@@ -394,15 +360,21 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 	if (tstamp && tstamp->stop == 0)
 		tstamp->stop = ktime_to_ns(ktime_get_real());
 
-	if (!nf_ct_is_dying(ct) &&
-	    unlikely(nf_conntrack_event_report(IPCT_DESTROY, ct,
-	    portid, report) < 0)) {
+	if (nf_ct_is_dying(ct))
+		goto delete;
+
+	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
+				    portid, report) < 0) {
 		/* destroy event was not delivered */
 		nf_ct_delete_from_lists(ct);
-		nf_ct_dying_timeout(ct);
+		set_bit(IPS_ECACHE_REDELIVER_BIT, &ct->status);
+		nf_conntrack_ecache_delayed_work(nf_ct_net(ct));
 		return false;
 	}
+
+	nf_conntrack_ecache_work(nf_ct_net(ct));
 	set_bit(IPS_DYING_BIT, &ct->status);
+ delete:
 	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
 	return true;
@@ -1464,26 +1436,6 @@ void nf_conntrack_flush_report(struct net *net, u32 portid, int report)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
-static void nf_ct_release_dying_list(struct net *net)
-{
-	struct nf_conntrack_tuple_hash *h;
-	struct nf_conn *ct;
-	struct hlist_nulls_node *n;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-
-		spin_lock_bh(&pcpu->lock);
-		hlist_nulls_for_each_entry(h, n, &pcpu->dying, hnnode) {
-			ct = nf_ct_tuplehash_to_ctrack(h);
-			/* never fails to remove them, no listeners at this point */
-			nf_ct_kill(ct);
-		}
-		spin_unlock_bh(&pcpu->lock);
-	}
-}
-
 static int untrack_refs(void)
 {
 	int cnt = 0, cpu;
@@ -1548,7 +1500,6 @@ i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_ct_iterate_cleanup(net, kill_all, NULL, 0, 0);
-		nf_ct_release_dying_list(net);
 		if (atomic_read(&net->ct.count) != 0)
 			busy = 1;
 	}
@@ -1782,13 +1733,6 @@ void nf_conntrack_init_end(void)
 	RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
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
 	int ret = -ENOMEM;
@@ -1804,9 +1748,10 @@ int nf_conntrack_init_net(struct net *net)
 		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 
 		spin_lock_init(&pcpu->lock);
-		INIT_HLIST_NULLS_HEAD(&pcpu->unconfirmed, UNCONFIRMED_NULLS_VAL);
-		INIT_HLIST_NULLS_HEAD(&pcpu->dying, DYING_NULLS_VAL);
-		INIT_HLIST_NULLS_HEAD(&pcpu->tmpl, TEMPLATE_NULLS_VAL);
+		INIT_HLIST_NULLS_HEAD(&pcpu->unconfirmed,
+				      NFCT_UNCONFIRMED_NULLS_VAL);
+		INIT_HLIST_NULLS_HEAD(&pcpu->dying, NFCT_DYING_NULLS_VAL);
+		INIT_HLIST_NULLS_HEAD(&pcpu->tmpl, NFCT_TEMPLATE_NULLS_VAL);
 	}
 
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 1df1761..e5a7bd2 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -22,6 +22,7 @@
 #include <linux/netdevice.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/rculist_nulls.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
@@ -29,6 +30,89 @@
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
+#define ECACHE_MAX_EVICTS 1000
+#define ECACHE_RETRY_WAIT (HZ/10)
+
+enum retry_state {
+	STATE_CONGESTED,
+	STATE_RESTART,
+	STATE_DONE,
+};
+
+static enum retry_state
+ecache_work_evict_list(struct hlist_nulls_head *list_head)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+	unsigned int evicted = 0;
+
+	rcu_read_lock();
+
+	hlist_nulls_for_each_entry_rcu(h, n, list_head, hnnode) {
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
+		if (need_resched() || ++evicted >= ECACHE_MAX_EVICTS)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	if (is_a_nulls(n)) {
+		if (get_nulls_value(n) == NFCT_DYING_NULLS_VAL)
+			return STATE_DONE;
+		return STATE_RESTART;
+	}
+
+	return evicted > 0 ? STATE_RESTART : STATE_CONGESTED;
+}
+
+static void ecache_work(struct work_struct *work)
+{
+	struct netns_ct *ctnet =
+		container_of(work, struct netns_ct, ecache_dwork.work);
+	int cpu, delay = -1;
+	struct ct_pcpu *pcpu;
+
+	mutex_lock(&nf_ct_ecache_mutex);
+
+	for_each_possible_cpu(cpu) {
+		enum retry_state ret;
+
+		local_bh_disable();
+
+		pcpu = per_cpu_ptr(ctnet->pcpu_lists, cpu);
+		ret = ecache_work_evict_list(&pcpu->dying);
+
+		local_bh_enable();
+
+		switch (ret) {
+		case STATE_CONGESTED:
+			delay = ECACHE_RETRY_WAIT;
+			goto out;
+		case STATE_RESTART:
+			delay = 0; /* fallthrough */
+		case STATE_DONE:
+			break;
+		}
+	}
+ out:
+	ctnet->ecache_dwork_pending = delay > 0;
+	mutex_unlock(&nf_ct_ecache_mutex);
+	if (delay >= 0)
+		schedule_delayed_work(&ctnet->ecache_dwork, delay);
+}
+
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
 void nf_ct_deliver_cached_events(struct nf_conn *ct)
@@ -157,7 +241,6 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
-static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -168,13 +251,6 @@ static struct ctl_table event_sysctl_table[] = {
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
@@ -196,7 +272,6 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
-	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	/* Don't export sysctls to unprivileged users */
 	if (net->user_ns != &init_user_ns)
@@ -238,12 +313,13 @@ static void nf_conntrack_event_fini_sysctl(struct net *net)
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
1.8.1.5

