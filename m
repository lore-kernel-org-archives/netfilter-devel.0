From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack event
	delivery
Date: Thu, 04 Jun 2009 13:08:41 +0200
Message-ID: <20090604110841.6702.76228.stgit@Decadence>
References: <20090604110307.6702.10147.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58028 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZFDLIs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:08:48 -0400
In-Reply-To: <20090604110307.6702.10147.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch improves ctnetlink event reliability if one broadcast
listener has set the NETLINK_BROADCAST_ERROR socket option.

The logic is the following: if the event delivery, we keep the
undelivered events in the per-conntrack event cache. Thus, once
the next packet arrives, we trigger another event delivery in
nf_conntrack_in(). If things don't go well in this second try,
we accumulate the pending events in the cache but we try to
deliver the current state as soon as possible. Therefore, we may
lost state transitions but the userspace process gets in sync at
some point.

At worst case, if no events were delivered to userspace, we make
sure that destroy events are successfully delivered. This happens
because if ctnetlink fails to deliver the destroy event, we remove
the conntrack entry from the hashes and insert them in the dying
list, which contains inactive entries. Then, the conntrack timer
is added with an extra grace timeout of random32() % 15 seconds
to trigger the event again (this grace timeout is tunable via
/proc). The use of a limited random timeout value allows
distributing the "destroy" resends, thus, avoiding accumulating
lots "destroy" events at the same time.

The maximum number of conntrack entries (active or inactive) is
still handled by nf_conntrack_max. Thus, we may start dropping
packets at some point if we accumulate a lot of inactive conntrack
entries waiting to deliver the destroy event to userspace.
During my stress tests consisting of setting a very small buffer
of 2048 bytes for conntrackd and the NETLINK_BROADCAST_ERROR socket
flag, and generating lots of very small connections, I noticed
very few destroy entries on the fly waiting to be resend.

A simple way to test this patch consist of creating a lot of
entries, set a very small Netlink buffer in conntrackd (+ a patch
which is not in the git tree to set the BROADCAST_ERROR flag)
and invoke `conntrack -F'.

For expectations, no changes are introduced in this patch.
Currently, event delivery is only done for new expectations (no
events from expectation removal and confirmation) and, apart from
the conntrack command line tool, I don't see any client that may
benefit of reliable expectation event delivery, we have to
introduce confirm and destroy events before.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h        |    2 +
 include/net/netfilter/nf_conntrack_ecache.h |   10 ++-
 include/net/netfilter/nf_conntrack_helper.h |    2 +
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |   89 ++++++++++++++++++++++-----
 net/netfilter/nf_conntrack_ecache.c         |   21 ++++++
 net/netfilter/nf_conntrack_helper.c         |   15 +++++
 net/netfilter/nf_conntrack_netlink.c        |   20 ++++--
 8 files changed, 133 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2ba36dd..8671635 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -293,6 +293,8 @@ extern int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
 extern unsigned int nf_conntrack_htable_size;
 extern unsigned int nf_conntrack_max;
 
+extern void nf_ct_setup_event_timer(struct nf_conn *ct);
+
 #define NF_CT_STAT_INC(net, count)	\
 	(per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++)
 #define NF_CT_STAT_INC_ATOMIC(net, count)		\
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 2fb019a..a37929d 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -95,12 +95,13 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	set_bit(event, &e->cache);
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
 
@@ -118,16 +119,17 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
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
index e8905a9..deb7736 100644
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
+		ct->timeout.expires = jiffies +
+			(random32() % net->ct.sysctl_events_retry_timeout);
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
+	ct->timeout.expires = jiffies +
+		(random32() % net->ct.sysctl_events_retry_timeout);
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
index 3fe2682..ee5d3cc 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -37,6 +37,7 @@ void nf_ct_deliver_cached_events_report(struct nf_conn *ct, u32 pid, int report)
 {
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
+	int ret = 0, delivered = 0;
 
 	rcu_read_lock();
 	notify = rcu_dereference(nf_conntrack_event_cb);
@@ -54,9 +55,12 @@ void nf_ct_deliver_cached_events_report(struct nf_conn *ct, u32 pid, int report)
 			.report	= report
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
@@ -136,9 +140,12 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 #endif
 
 static int nf_ct_events_switch __read_mostly = NF_CT_EVENTS_DEFAULT;
+static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 module_param_named(event, nf_ct_events_switch, bool, 0644);
 MODULE_PARM_DESC(event, "Enable connection tracking event delivery");
+module_param_named(retry_timeout, nf_ct_events_retry_timeout, bool, 0644);
+MODULE_PARM_DESC(retry_timeout, "Event delivery retry timeout");
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -150,6 +157,14 @@ static struct ctl_table event_sysctl_table[] = {
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
@@ -171,6 +186,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
+	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	net->ct.event_sysctl_header =
 		register_net_sysctl_table(net,
@@ -211,6 +227,7 @@ int nf_conntrack_ecache_init(struct net *net)
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
index 2dd2910..6695e4b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -463,6 +463,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
+	int err;
 
 	/* ignore our fake conntrack entry */
 	if (ct == &nf_conntrack_untracked)
@@ -558,7 +559,10 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	rcu_read_unlock();
 
 	nlmsg_end(skb, nlh);
-	nfnetlink_send(skb, item->pid, group, item->report, GFP_ATOMIC);
+	err = nfnetlink_send(skb, item->pid, group, item->report, GFP_ATOMIC);
+	if ((err == -ENOBUFS) || (err == -EAGAIN))
+		return -ENOBUFS;
+
 	return 0;
 
 nla_put_failure:
@@ -567,7 +571,7 @@ nla_put_failure:
 nlmsg_failure:
 	kfree_skb(skb);
 errout:
-	nfnetlink_set_err(0, group, -ENOBUFS);
+	nfnetlink_set_err(item->pid, group, -ENOBUFS);
 	return 0;
 }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
@@ -798,10 +802,14 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
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

