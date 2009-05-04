From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack event
	delivery
Date: Mon, 04 May 2009 15:53:55 +0200
Message-ID: <20090504135355.8394.65706.stgit@Decadence>
References: <20090504134740.8394.21789.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37816 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZEDNyF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2009 09:54:05 -0400
In-Reply-To: <20090504134740.8394.21789.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch improves ctnetlink event reliability if one broadcast
listener has set the NETLINK_BROADCAST_ERROR socket option.

The logic is the following: if the event delivery fails, ctnetlink
sets IPCT_DELIVERY_FAILED event bit and keep the undelivered
events in the conntrack event cache. Thus, once the next packet
arrives, we trigger another event delivery in nf_conntrack_in(). If
things don't go well in this second try, we accumulate the pending
events in the cache but we try to deliver the current state as soon
as possible. Therefore, we may lost state transitions but the
userspace process gets in sync at some point.

At worst case, if no events were delivered to userspace, we make
sure that destroy events are successfully delivered. This happens
because if ctnetlink fails to deliver the destroy event, we remove
the conntrack entry from the hashes and insert them in the dying
list, which contains inactive entries. Then, the conntrack timer
is added with an extra grace timeout of 15 seconds to trigger the
event again (this grace timeout is tunable via /proc).

The maximum number of conntrack entries (active or inactive) is
still handled by nf_conntrack_max. Thus, we may start dropping
packets at some point if we accumulate a lot of inactive conntrack
entries waiting to deliver the destroy event to userspace.
During my stress tests consisting of setting a very small buffer
of 2048 bytes for conntrackd and the NETLINK_BROADCAST_ERROR socket
flag, and generating lots of very small connections, we hit "table
full, dropping packet" at some point.

For expectations, no changes are introduced in this patch.
Currently, event delivery is only done for new expectations (no
events from expectation removal and confirmation) and, apart from
the conntrack command line tool, I don't see any client that may
benefit of reliable expectation event delivery, we have to
introduce confirm and destroy events before.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h        |    2 +
 include/net/netfilter/nf_conntrack_core.h   |    6 +-
 include/net/netfilter/nf_conntrack_ecache.h |   19 ++++--
 include/net/netfilter/nf_conntrack_helper.h |    2 +
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |   89 ++++++++++++++++++++++-----
 net/netfilter/nf_conntrack_ecache.c         |   24 ++++++-
 net/netfilter/nf_conntrack_helper.c         |   15 +++++
 net/netfilter/nf_conntrack_netlink.c        |   58 ++++++++++++------
 9 files changed, 170 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f34d596..ceacd5b 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -291,6 +291,8 @@ extern int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
 extern unsigned int nf_conntrack_htable_size;
 extern unsigned int nf_conntrack_max;
 
+extern void nf_ct_setup_event_timer(struct nf_conn *ct);
+
 #define NF_CT_STAT_INC(net, count)	\
 	(per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++)
 #define NF_CT_STAT_INC_ATOMIC(net, count)		\
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 5a449b4..1be51ba 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -62,8 +62,10 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	if (ct && ct != &nf_conntrack_untracked) {
 		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(skb);
-		if (likely(ret == NF_ACCEPT))
-			nf_ct_deliver_cached_events(ct);
+		if (unlikely(ret == NF_DROP))
+			return NF_DROP;
+		if (unlikely(nf_ct_deliver_cached_events(ct) < 0))
+			nf_conntrack_event_cache(IPCT_DELIVERY_FAILED, ct);
 	}
 	return ret;
 }
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 10244f5..c7d7b5e 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -24,6 +24,7 @@ enum ip_conntrack_events
 	IPCT_MARK		= 6,	/* new mark has been set */
 	IPCT_NATSEQADJ		= 7,	/* NAT is doing sequence adjustment */
 	IPCT_SECMARK		= 8,	/* new security mark has been set */
+	IPCT_DELIVERY_FAILED	= 31,	/* previous event delivery has failed */
 };
 
 enum ip_conntrack_expect_events {
@@ -67,7 +68,7 @@ extern struct nf_ct_event_notifier *nf_conntrack_event_cb;
 extern int nf_conntrack_register_notifier(struct nf_ct_event_notifier *nb);
 extern int nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *nb);
 
-extern void nf_ct_deliver_cached_events(struct nf_conn *ct);
+extern int nf_ct_deliver_cached_events(struct nf_conn *ct);
 
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
@@ -90,10 +91,11 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	set_bit(event, &e->cache);
 }
 
-static inline void
+static inline int
 nf_conntrack_event_bitmask_report(unsigned int bitmask,
 				  struct nf_conn *ct, u32 pid, int report)
 {
+	int ret = 0;
 	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
 
@@ -111,18 +113,20 @@ nf_conntrack_event_bitmask_report(unsigned int bitmask,
 			.pid	= pid,
 			.report = report
 		};
-		notify->fcn(bitmask, &item);
+		ret = notify->fcn(bitmask, &item);
 	}
 out_unlock:
 	rcu_read_unlock();
+	return ret;
 }
 
-static inline void
+static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event,
 			  struct nf_conn *ct,
 			  u32 pid,
 			  int report)
 {
+	int ret = 0;
 	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
 
@@ -140,16 +144,17 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 			.pid	= pid,
 			.report = report
 		};
-		notify->fcn((1 << event), &item);
+		ret = notify->fcn((1 << event), &item);
 	}
 out_unlock:
 	rcu_read_unlock();
+	return ret;
 }
 
-static inline void
+static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
-	nf_conntrack_event_report(event, ct, 0, 0);
+	return nf_conntrack_event_report(event, ct, 0, 0);
 }
 
 struct nf_exp_event {
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index ee2a4b3..1b70680 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -50,6 +50,8 @@ extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
 extern int __nf_ct_try_assign_helper(struct nf_conn *ct, gfp_t flags);
 
+extern void nf_ct_helper_destroy(struct nf_conn *ct);
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 505a51c..ba1ba0c 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -14,8 +14,10 @@ struct netns_ct {
 	struct hlist_nulls_head	*hash;
 	struct hlist_head	*expect_hash;
 	struct hlist_nulls_head	unconfirmed;
+	struct hlist_nulls_head	dying;
 	struct ip_conntrack_stat *stat;
 	int			sysctl_events;
+	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e8905a9..b314541 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -182,10 +182,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
-	if (!test_bit(IPS_DYING_BIT, &ct->status))
-		nf_conntrack_event(IPCT_DESTROY, ct);
-	set_bit(IPS_DYING_BIT, &ct->status);
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -219,20 +215,9 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	nf_conntrack_free(ct);
 }
 
-static void death_by_timeout(unsigned long ul_conntrack)
+static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
-	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
-	struct nf_conn_help *help = nfct_help(ct);
-	struct nf_conntrack_helper *helper;
-
-	if (help) {
-		rcu_read_lock();
-		helper = rcu_dereference(help->helper);
-		if (helper && helper->destroy)
-			helper->destroy(ct);
-		rcu_read_unlock();
-	}
 
 	spin_lock_bh(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
@@ -240,6 +225,60 @@ static void death_by_timeout(unsigned long ul_conntrack)
 	NF_CT_STAT_INC(net, delete_list);
 	clean_from_lists(ct);
 	spin_unlock_bh(&nf_conntrack_lock);
+}
+
+static void death_by_event(unsigned long ul_conntrack)
+{
+	struct nf_conn *ct = (void *)ul_conntrack;
+	struct net *net = nf_ct_net(ct);
+
+	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
+		/* bad luck, let's retry again */
+		ct->timeout.expires =
+			jiffies + net->ct.sysctl_events_retry_timeout;
+		add_timer(&ct->timeout);
+		return;
+	}
+	/* we've got the event delivered, now it's dying */
+	set_bit(IPS_DYING_BIT, &ct->status);
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+	spin_unlock_bh(&nf_conntrack_lock);
+	nf_ct_helper_destroy(ct);
+	nf_ct_put(ct);
+}
+
+void nf_ct_setup_event_timer(struct nf_conn *ct)
+{
+	struct net *net = nf_ct_net(ct);
+
+	nf_ct_delete_from_lists(ct);
+	/* add this conntrack to the dying list */
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &net->ct.dying);
+	/* set a new timer to retry event delivery */
+	setup_timer(&ct->timeout, death_by_event, (unsigned long)ct);
+	ct->timeout.expires =
+		jiffies + net->ct.sysctl_events_retry_timeout;
+	add_timer(&ct->timeout);
+	spin_unlock_bh(&nf_conntrack_lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_setup_event_timer);
+
+static void death_by_timeout(unsigned long ul_conntrack)
+{
+	struct nf_conn *ct = (void *)ul_conntrack;
+
+	if (!test_bit(IPS_DYING_BIT, &ct->status) && 
+	    unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
+		/* destroy event was not delivered */
+		nf_ct_setup_event_timer(ct);
+		return;
+	}
+	set_bit(IPS_DYING_BIT, &ct->status);
+	nf_ct_helper_destroy(ct);
+	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
 }
 
@@ -1030,6 +1069,22 @@ void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
+static void nf_ct_release_dying_list(void)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
+	struct hlist_nulls_node *n;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_nulls_for_each_entry(h, n, &init_net.ct.dying, hnnode) {
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		/* never fails to remove them, no listeners at this point */
+		if (del_timer(&ct->timeout))
+			ct->timeout.function((unsigned long)ct);
+	}
+	spin_unlock_bh(&nf_conntrack_lock);
+}
+
 static void nf_conntrack_cleanup_init_net(void)
 {
 	nf_conntrack_helper_fini();
@@ -1041,6 +1096,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 {
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
+	nf_ct_release_dying_list();
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
 		goto i_see_dead_people;
@@ -1222,6 +1278,7 @@ static int nf_conntrack_init_net(struct net *net)
 
 	atomic_set(&net->ct.count, 0);
 	INIT_HLIST_NULLS_HEAD(&net->ct.unconfirmed, 0);
+	INIT_HLIST_NULLS_HEAD(&net->ct.dying, 0);
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat) {
 		ret = -ENOMEM;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 04dde1a..e97f6dc 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -33,10 +33,11 @@ EXPORT_SYMBOL_GPL(nf_expect_event_cb);
 
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
-void nf_ct_deliver_cached_events(struct nf_conn *ct)
+int nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
+	int ret = 0, delivered = 0;
 
 	rcu_read_lock_bh();
 	notify = rcu_dereference(nf_conntrack_event_cb);
@@ -54,12 +55,16 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 			.report	= 0
 		};
 
-		notify->fcn(e->cache, &item);
+		ret = notify->fcn(e->cache, &item);
+		if (ret == 0)
+			delivered = 1;
 	}
-	xchg(&e->cache, 0);
+	if (delivered)
+		xchg(&e->cache, 0);
 
 out_unlock:
 	rcu_read_unlock_bh();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
@@ -154,9 +159,12 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 #endif
 
 static int nf_ct_events_switch __read_mostly = NF_CT_EVENTS_DEFAULT;
+static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 module_param_named(event, nf_ct_events_switch, bool, 0644);
 MODULE_PARM_DESC(event, "Enable connection tracking event delivery");
+module_param_named(retry_timeout, nf_ct_events_retry_timeout, bool, 0644);
+MODULE_PARM_DESC(retry_timeout, "Event delivery retry timeout");
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -168,6 +176,14 @@ static struct ctl_table event_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nf_conntrack_events_retry_timeout",
+		.data		= &init_net.ct.sysctl_events_retry_timeout,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
 	{}
 };
 #endif /* CONFIG_SYSCTL */
@@ -189,6 +205,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
+	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	net->ct.event_sysctl_header =
 		register_net_sysctl_table(net,
@@ -229,6 +246,7 @@ int nf_conntrack_ecache_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_events = nf_ct_events_switch;
+	net->ct.sysctl_events_retry_timeout = nf_ct_events_retry_timeout;
 
 	if (net_eq(net, &init_net)) {
 		ret = nf_ct_extend_register(&event_extend);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 0fa5a42..5fc1fe7 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -136,6 +136,21 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
 	return 0;
 }
 
+void nf_ct_helper_destroy(struct nf_conn *ct)
+{
+	struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conntrack_helper *helper;
+
+	if (help) {
+		rcu_read_lock();
+		helper = rcu_dereference(help->helper);
+		if (helper && helper->destroy)
+			helper->destroy(ct);
+		rcu_read_unlock();
+	}
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_destroy);
+
 int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 {
 	unsigned int h = helper_hash(&me->tuple);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ee9e1bc..c7d2a65 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -487,6 +487,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	unsigned int type;
 	sk_buff_data_t b;
 	unsigned int flags = 0, group;
+	int err;
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
@@ -583,7 +584,10 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, item->pid, group, item->report);
+	err = nfnetlink_send(skb, item->pid, group, item->report);
+	if ((err == -ENOBUFS) || (err == -EAGAIN))
+		return -ENOBUFS;
+
 	return 0;
 
 nla_put_failure:
@@ -591,7 +595,7 @@ nla_put_failure:
 nlmsg_failure:
 	kfree_skb(skb);
 errout:
-	nfnetlink_set_err(0, group, -ENOBUFS);
+	nfnetlink_set_err(item->pid, group, -ENOBUFS);
 	return 0;
 }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
@@ -823,10 +827,14 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	nf_conntrack_event_report(IPCT_DESTROY,
-				  ct,
-				  NETLINK_CB(skb).pid,
-				  nlmsg_report(nlh));
+	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
+				      NETLINK_CB(skb).pid,
+				      nlmsg_report(nlh)) < 0) {
+		/* we failed to report the event, try later */
+		nf_ct_setup_event_timer(ct);
+		nf_ct_put(ct);
+		return 0;
+	}
 
 	/* death_by_timeout would report the event again */
 	set_bit(IPS_DYING_BIT, &ct->status);
@@ -1184,7 +1192,7 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 	return 0;
 }
 
-static inline void
+static inline int
 ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 {
 	unsigned int events = 0;
@@ -1194,12 +1202,12 @@ ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 	else
 		events |= (1 << IPCT_NEW);
 
-	nf_conntrack_event_bitmask_report((1 << IPCT_STATUS) |
-					  (1 << IPCT_HELPER) |
-					  (1 << IPCT_PROTOINFO) |
-					  (1 << IPCT_NATSEQADJ) |
-					  (1 << IPCT_MARK) | events,
-					  ct, pid, report);
+	return nf_conntrack_event_bitmask_report((1 << IPCT_STATUS) |
+						 (1 << IPCT_HELPER) |
+						 (1 << IPCT_PROTOINFO) |
+						 (1 << IPCT_NATSEQADJ) |
+						 (1 << IPCT_MARK) | events,
+						 ct, pid, report);
 }
 
 static struct nf_conn *
@@ -1378,9 +1386,16 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			err = 0;
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (ctnetlink_event_report(ct,
+						   NETLINK_CB(skb).pid,
+						   nlmsg_report(nlh)) < 0) {
+				/* first packet matching this entry will
+				 * trigger a new event delivery. */
+				nf_conntrack_event_cache(IPCT_DELIVERY_FAILED,
+							 ct);
+				nf_ct_put(ct);
+				return 0;
+			}
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1399,9 +1414,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			ctnetlink_event_report(ct,
-					       NETLINK_CB(skb).pid,
-					       nlmsg_report(nlh));
+			if (ctnetlink_event_report(ct,
+						   NETLINK_CB(skb).pid,
+						   nlmsg_report(nlh)) < 0) {
+				nf_conntrack_event_cache(IPCT_DELIVERY_FAILED,
+							 ct);
+				nf_ct_put(ct);
+				return 0;
+			}
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);

