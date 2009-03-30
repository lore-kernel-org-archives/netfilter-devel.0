From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] ctnetlink: optional reliable conntrack event delivery
Date: Mon, 30 Mar 2009 15:28:40 +0200
Message-ID: <20090330132840.14337.57303.stgit@Decadence>
References: <20090330132330.14337.4705.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41799 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751359AbZC3N26 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:28:58 -0400
In-Reply-To: <20090330132330.14337.4705.stgit@Decadence>
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

For expectations, no changes are introduced in this patch.
Currently, event delivery is only done for new expectations (no
events from expectation removal and confirmation) and, apart from
the conntrack command line tool, I don't see any client that may
benefit of reliable expectation event delivery, at least until
destroy and confirm events are introduced.

This patch does not include the removal of the notify chain as
Patrick suggested yet, but I'll work on such change on top of this
patch if this is OK.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h        |    2 +
 include/net/netfilter/nf_conntrack_core.h   |    6 +-
 include/net/netfilter/nf_conntrack_ecache.h |   30 ++++++---
 include/net/netfilter/nf_conntrack_helper.h |    2 +
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |   87 ++++++++++++++++++++++-----
 net/netfilter/nf_conntrack_ecache.c         |   26 +++++++-
 net/netfilter/nf_conntrack_helper.c         |   15 +++++
 net/netfilter/nf_conntrack_netlink.c        |   61 ++++++++++++-------
 9 files changed, 175 insertions(+), 56 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6340be3..d212fad 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -289,6 +289,8 @@ extern int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
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
index eb5dadf..f72e9e8 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -74,6 +74,10 @@ enum ip_conntrack_events
 	/* Secmark is set */
 	IPCT_SECMARK_BIT = 14,
 	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
+
+	/* An event delivery has failed */
+	IPCT_DELIVERY_FAILED_BIT = 31,
+	IPCT_DELIVERY_FAILED = (1 << IPCT_DELIVERY_FAILED_BIT),
 };
 
 enum ip_conntrack_expect_events {
@@ -118,7 +122,7 @@ extern struct nf_ct_event_notifier *nf_conntrack_event_cb;
 extern int nf_conntrack_register_notifier(struct nf_ct_event_notifier *nb);
 extern int nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *nb);
 
-extern void nf_ct_deliver_cached_events(struct nf_conn *ct);
+extern int nf_ct_deliver_cached_events(struct nf_conn *ct);
 
 static inline void
 __nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
@@ -147,12 +151,13 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	spin_unlock_bh(&nf_conntrack_lock);
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
 
@@ -162,7 +167,7 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 		goto out_unlock;
 
 	if (!net->ct.sysctl_events)
-		return;
+		goto out_unlock;
 
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
 		struct nf_ct_event item = {
@@ -171,16 +176,17 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 			.report = report
 		};
 
-		notify->fcn(event, &item);
+		ret = notify->fcn(event, &item);
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
@@ -197,12 +203,13 @@ extern struct nf_exp_event_notifier *nf_expect_event_cb;
 extern int nf_ct_expect_register_notifier(struct nf_exp_event_notifier *nb);
 extern int nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *nb);
 
-static inline void
+static inline int
 nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  struct nf_conntrack_expect *exp,
 			  u32 pid,
 			  int report)
 {
+	int ret = 0;
 	struct net *net = nf_ct_exp_net(exp);
 	struct nf_exp_event_notifier *notify;
 
@@ -212,7 +219,7 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 		goto out_unlock;
 
 	if (!net->ct.sysctl_events)
-		return;
+		goto out_unlock;
 
 	{
 		struct nf_exp_event item = {
@@ -221,17 +228,18 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			.report = report
 		};
 
-		notify->fcn(event, &item);
+		ret = notify->fcn(event, &item);
 	}
 out_unlock:
 	rcu_read_unlock();
+	return ret;
 }
 
-static inline void
+static inline int
 nf_ct_expect_event(enum ip_conntrack_expect_events event,
 		   struct nf_conntrack_expect *exp)
 {
-	nf_ct_expect_event_report(event, exp, 0, 0);
+	return nf_ct_expect_event_report(event, exp, 0, 0);
 }
 
 extern int nf_conntrack_ecache_init(struct net *net);
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 66d65a7..0d4b5aa 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -48,6 +48,8 @@ extern struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 
 extern int __nf_ct_try_assign_helper(struct nf_conn *ct, gfp_t flags);
 
+extern void nf_ct_helper_destroy(struct nf_conn *ct);
+
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
 {
 	return nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 69dd322..0471cd5 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -13,8 +13,10 @@ struct netns_ct {
 	struct hlist_head	*hash;
 	struct hlist_head	*expect_hash;
 	struct hlist_head	unconfirmed;
+	struct hlist_head	dying;
 	struct ip_conntrack_stat *stat;
 	int			sysctl_events;
+	unsigned int		sysctl_events_retry_timeout;
 	int			sysctl_acct;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a4862f0..f9b17c0 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -181,10 +181,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
-	if (!test_bit(IPS_DYING_BIT, &ct->status))
-		nf_conntrack_event(IPCT_DESTROY, ct);
-	set_bit(IPS_DYING_BIT, &ct->status);
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -218,20 +214,9 @@ destroy_conntrack(struct nf_conntrack *nfct)
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
@@ -239,6 +224,58 @@ static void death_by_timeout(unsigned long ul_conntrack)
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
+	}
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode);
+	spin_unlock_bh(&nf_conntrack_lock);
+	nf_ct_helper_destroy(ct);
+	nf_ct_put(ct);
+}
+
+void nf_ct_setup_event_timer(struct nf_conn *ct)
+{
+	struct net *net = nf_ct_net(ct);
+
+	/* destroy event was not delivered */
+	set_bit(IPS_DYING_BIT, &ct->status);
+	nf_ct_delete_from_lists(ct);
+	/* add this conntrack to the dying list */
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnode,
+		       &net->ct.dying);
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
+		nf_ct_setup_event_timer(ct);
+		return;
+	}
+	set_bit(IPS_DYING_BIT, &ct->status);
+	nf_ct_helper_destroy(ct);
+	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
 }
 
@@ -1011,6 +1048,22 @@ void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_flush_report);
 
+static void nf_ct_release_dying_list(void)
+{
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conn *ct;
+	struct hlist_node *n;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_for_each_entry(h, n, &init_net.ct.dying, hnode) {
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
@@ -1022,6 +1075,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 {
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
+	nf_ct_release_dying_list();
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
 		goto i_see_dead_people;
@@ -1201,6 +1255,7 @@ static int nf_conntrack_init_net(struct net *net)
 
 	atomic_set(&net->ct.count, 0);
 	INIT_HLIST_HEAD(&net->ct.unconfirmed);
+	INIT_HLIST_HEAD(&net->ct.dying);
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat) {
 		ret = -ENOMEM;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 77f9254..29d432c 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -33,10 +33,11 @@ EXPORT_SYMBOL_GPL(nf_expect_event_cb);
 
 /* Deliver all cached events for a particular conntrack. This is called
  * by code prior to async packet handling for freeing the skb */
-void nf_ct_deliver_cached_events(struct nf_conn *ct)
+int nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
+	int ret = 0, delivered = 0;
 
 	rcu_read_lock();
 	notify = rcu_dereference(nf_conntrack_event_cb);
@@ -45,7 +46,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 
 	e = nf_ct_ecache_find(ct);
 	if (e == NULL)
-		return;
+		goto out_unlock;
 
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct) && e->cache) {
 		struct nf_ct_event item = {
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
 	rcu_read_unlock();
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
index a51bdac..6af779d 100644
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
index 6aece58..fc000ae 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -414,6 +414,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	unsigned int type;
 	sk_buff_data_t b;
 	unsigned int flags = 0, group;
+	int err;
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
@@ -510,13 +511,16 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	rcu_read_unlock();
 
 	nlh->nlmsg_len = skb->tail - b;
-	nfnetlink_send(skb, item->pid, group, item->report);
+	err = nfnetlink_send(skb, item->pid, group, item->report);
+	if ((err == -ENOBUFS) || (err == -EAGAIN))
+		return -ENOBUFS;
+
 	return 0;
 
 nla_put_failure:
 	rcu_read_unlock();
 nlmsg_failure:
-	nfnetlink_set_err(0, group, -ENOBUFS);
+	nfnetlink_set_err(item->pid, group, -ENOBUFS);
 	kfree_skb(skb);
 	return 0;
 }
@@ -747,10 +751,14 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
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
@@ -1108,7 +1116,7 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 	return 0;
 }
 
-static inline void
+static inline int
 ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 {
 	unsigned int events = 0;
@@ -1118,16 +1126,13 @@ ctnetlink_event_report(struct nf_conn *ct, u32 pid, int report)
 	else
 		events |= IPCT_NEW;
 
-	nf_conntrack_event_report(IPCT_STATUS |
-				  IPCT_HELPER |
-				  IPCT_REFRESH |
-				  IPCT_PROTOINFO |
-				  IPCT_NATSEQADJ |
-				  IPCT_MARK |
-				  events,
-				  ct,
-				  pid,
-				  report);
+	return nf_conntrack_event_report(IPCT_STATUS |
+					 IPCT_HELPER |
+					 IPCT_REFRESH |
+					 IPCT_PROTOINFO |
+					 IPCT_NATSEQADJ |
+					 IPCT_MARK |
+					 events, ct, pid, report);
 }
 
 static struct nf_conn *
@@ -1307,9 +1312,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			err = 0;
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
@@ -1328,9 +1338,14 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
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

