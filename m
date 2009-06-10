From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4] netfilter: conntrack: optional reliable conntrack
 event	delivery
Date: Wed, 10 Jun 2009 22:07:07 +0200
Message-ID: <4A30126B.3080506@netfilter.org>
References: <20090610133716.14805.95308.stgit@Decadence> <20090610134150.14805.4528.stgit@Decadence> <4A2FB985.8030002@netfilter.org> <4A2FB9BA.5050106@trash.net> <4A2FC9B5.8030600@netfilter.org> <4A2FCB93.3090507@trash.net> <4A2FCCF7.40005@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030308070201040309080004"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58942 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbZFJUHU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:07:20 -0400
In-Reply-To: <4A2FCCF7.40005@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030308070201040309080004
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> Yes, the networking merge window closes a lot earlier than the general
>> kernel merge window and I have to get the other patches in.
>>
>> I can delay it today, but I don't want to risk waiting until tomorrow.
> 
> I'm going to take my laptop with me to see if I can finish it during
> some spare time. Let's see if I reach the merge window in time :-).

Attached the version that includes a new pid field in the cache
structure to store the netlink pid of the destroyer process (in case
that it needs to be retransmitted).

Please, you can pull this and the previous three from!

git://1984.lsi.us.es/nf-next-2.6 master

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------030308070201040309080004
Content-Type: text/x-diff;
 name="ctnetlink-reliable-event-delivery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnetlink-reliable-event-delivery.patch"

netfilter: conntrack: optional reliable conntrack event delivery

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch improves ctnetlink event reliability if one broadcast
listener has set the NETLINK_BROADCAST_ERROR socket option.

The logic is the following: if an event delivery fails, we keep
the undelivered events in the missed event cache. Once the next
packet arrives, we add the new events (if any) to the missed
events in the cache and we try a new delivery, and so on. Thus,
if ctnetlink fails to deliver an event, we try to deliver them
once we see a new packet. Therefore, we may lose state
transitions but the userspace process gets in sync at some point.

At worst case, if no events were delivered to userspace, we make
sure that destroy events are successfully delivered. Basically,
if ctnetlink fails to deliver the destroy event, we remove the
conntrack entry from the hashes and we insert them in the dying
list, which contains inactive entries. Then, the conntrack timer
is added with an extra grace timeout of random32() % 15 seconds
to trigger the event again (this grace timeout is tunable via
/proc). The use of a limited random timeout value allows
distributing the "destroy" resends, thus, avoiding accumulating
lots "destroy" events at the same time. Event delivery may
re-order but we can identify them by means of the tuple plus
the conntrack ID.

The maximum number of conntrack entries (active or inactive) is
still handled by nf_conntrack_max. Thus, we may start dropping
packets at some point if we accumulate a lot of inactive conntrack
entries that did not successfully report the destroy event to
userspace.

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
events from expectation expiration, removal and confirmation).
In that case, they need a per-expectation event cache to implement
the same idea that is exposed in this patch.

This patch can be useful to provide reliable flow-accouting. We
still have to add a new conntrack extension to store the creation
and destroy time.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h        |    2 +
 include/net/netfilter/nf_conntrack_ecache.h |   61 +++++++++++++------
 include/net/netns/conntrack.h               |    2 +
 net/netfilter/nf_conntrack_core.c           |   89 ++++++++++++++++++++++++---
 net/netfilter/nf_conntrack_ecache.c         |   28 ++++++++
 net/netfilter/nf_conntrack_netlink.c        |   19 ++++--
 6 files changed, 166 insertions(+), 35 deletions(-)


diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 80a4f3a..c9b06ca 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -204,6 +204,8 @@ extern struct nf_conntrack_tuple_hash *
 __nf_conntrack_find(struct net *net, const struct nf_conntrack_tuple *tuple);
 
 extern void nf_conntrack_hash_insert(struct nf_conn *ct);
+extern void nf_ct_delete_from_lists(struct nf_conn *ct);
+extern void nf_ct_insert_dying_list(struct nf_conn *ct);
 
 extern void nf_conntrack_flush_report(struct net *net, u32 pid, int report);
 
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index e7ae297..4f20d58 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -32,6 +32,8 @@ enum ip_conntrack_expect_events {
 
 struct nf_conntrack_ecache {
 	unsigned long cache;		/* bitops want long */
+	unsigned long missed;		/* missed events */
+	u32 pid;			/* netlink pid of destroyer */
 };
 
 static inline struct nf_conntrack_ecache *
@@ -84,14 +86,16 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	set_bit(event, &e->cache);
 }
 
-static inline void
+static inline int
 nf_conntrack_eventmask_report(unsigned int eventmask,
 			      struct nf_conn *ct,
 			      u32 pid,
 			      int report)
 {
+	int ret = 0;
 	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
+	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
 	notify = rcu_dereference(nf_conntrack_event_cb);
@@ -101,29 +105,52 @@ nf_conntrack_eventmask_report(unsigned int eventmask,
 	if (!net->ct.sysctl_events)
 		goto out_unlock;
 
+	e = nf_ct_ecache_find(ct);
+	if (e == NULL)
+		goto out_unlock;
+
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
 		struct nf_ct_event item = {
 			.ct 	= ct,
-			.pid	= pid,
+			.pid	= e->pid ? e->pid : pid,
 			.report = report
 		};
-		notify->fcn(eventmask, &item);
+		/* This is a resent of a destroy event? If so, skip missed */
+		unsigned long missed = e->pid ? 0 : e->missed;
+
+		ret = notify->fcn(eventmask | missed, &item);
+		if (unlikely(ret < 0 || missed)) {
+			spin_lock_bh(&ct->lock);
+			if (ret < 0) {
+				/* This is a destroy event that has been
+				 * triggered by a process, we store the PID
+				 * to include it in the retransmission. */
+				if (eventmask & (1 << IPCT_DESTROY) &&
+				    e->pid == 0 && pid != 0)
+					e->pid = pid;
+				else
+					e->missed |= eventmask;
+			} else
+				e->missed &= ~missed;
+			spin_unlock_bh(&ct->lock);
+		}
 	}
 out_unlock:
 	rcu_read_unlock();
+	return ret;
 }
 
-static inline void
+static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 pid, int report)
 {
-	nf_conntrack_eventmask_report(1 << event, ct, pid, report);
+	return nf_conntrack_eventmask_report(1 << event, ct, pid, report);
 }
 
-static inline void
+static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
-	nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
+	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
 }
 
 struct nf_exp_event {
@@ -183,16 +210,16 @@ extern void nf_conntrack_ecache_fini(struct net *net);
 
 static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
 					    struct nf_conn *ct) {}
-static inline void nf_conntrack_eventmask_report(unsigned int eventmask,
-						 struct nf_conn *ct,
-						 u32 pid,
-						 int report) {}
-static inline void nf_conntrack_event(enum ip_conntrack_events event,
-				      struct nf_conn *ct) {}
-static inline void nf_conntrack_event_report(enum ip_conntrack_events event,
-					     struct nf_conn *ct,
-					     u32 pid,
-					     int report) {}
+static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
+						struct nf_conn *ct,
+						u32 pid,
+						int report) { return 0; }
+static inline int nf_conntrack_event(enum ip_conntrack_events event,
+				     struct nf_conn *ct) { return 0; }
+static inline int nf_conntrack_event_report(enum ip_conntrack_events event,
+					    struct nf_conn *ct,
+					    u32 pid,
+					    int report) { return 0; }
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
 static inline void nf_ct_expect_event(enum ip_conntrack_expect_events event,
 				      struct nf_conntrack_expect *exp) {}
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
index 822c607..f31d4ee 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -183,10 +183,6 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
-	if (!test_bit(IPS_DYING_BIT, &ct->status))
-		nf_conntrack_event(IPCT_DESTROY, ct);
-	set_bit(IPS_DYING_BIT, &ct->status);
-
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -220,9 +216,8 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	nf_conntrack_free(ct);
 }
 
-static void death_by_timeout(unsigned long ul_conntrack)
+void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
-	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
 
 	nf_ct_helper_destroy(ct);
@@ -232,6 +227,59 @@ static void death_by_timeout(unsigned long ul_conntrack)
 	NF_CT_STAT_INC(net, delete_list);
 	clean_from_lists(ct);
 	spin_unlock_bh(&nf_conntrack_lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_delete_from_lists);
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
+	spin_lock(&nf_conntrack_lock);
+	hlist_nulls_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
+	spin_unlock(&nf_conntrack_lock);
+	nf_ct_put(ct);
+}
+
+void nf_ct_insert_dying_list(struct nf_conn *ct)
+{
+	struct net *net = nf_ct_net(ct);
+
+	/* add this conntrack to the dying list */
+	spin_lock_bh(&nf_conntrack_lock);
+	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+			     &net->ct.dying);
+	spin_unlock_bh(&nf_conntrack_lock);
+	/* set a new timer to retry event delivery */
+	setup_timer(&ct->timeout, death_by_event, (unsigned long)ct);
+	ct->timeout.expires = jiffies +
+		(random32() % net->ct.sysctl_events_retry_timeout);
+	add_timer(&ct->timeout);
+}
+EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
+
+static void death_by_timeout(unsigned long ul_conntrack)
+{
+	struct nf_conn *ct = (void *)ul_conntrack;
+
+	if (!test_bit(IPS_DYING_BIT, &ct->status) && 
+	    unlikely(nf_conntrack_event(IPCT_DESTROY, ct) < 0)) {
+		/* destroy event was not delivered */
+		nf_ct_delete_from_lists(ct);
+		nf_ct_insert_dying_list(ct);
+		return;
+	}
+	set_bit(IPS_DYING_BIT, &ct->status);
+	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
 }
 
@@ -987,11 +1035,13 @@ static int kill_report(struct nf_conn *i, void *data)
 {
 	struct __nf_ct_flush_report *fr = (struct __nf_ct_flush_report *)data;
 
-	/* get_next_corpse sets the dying bit for us */
-	nf_conntrack_event_report(IPCT_DESTROY,
-				  i,
-				  fr->pid,
-				  fr->report);
+	/* If we fail to deliver the event, death_by_timeout() will retry */
+	if (nf_conntrack_event_report(IPCT_DESTROY, i,
+				      fr->pid, fr->report) < 0)
+		return 1;
+
+	/* Avoid the delivery of the destroy event in death_by_timeout(). */
+	set_bit(IPS_DYING_BIT, &i->status);
 	return 1;
 }
 
@@ -1020,6 +1070,21 @@ void nf_conntrack_flush_report(struct net *net, u32 pid, int report)
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
+		nf_ct_kill(ct);
+	}
+	spin_unlock_bh(&nf_conntrack_lock);
+}
+
 static void nf_conntrack_cleanup_init_net(void)
 {
 	nf_conntrack_helper_fini();
@@ -1031,6 +1096,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 {
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
+	nf_ct_release_dying_list();
 	if (atomic_read(&net->ct.count) != 0) {
 		schedule();
 		goto i_see_dead_people;
@@ -1212,6 +1278,7 @@ static int nf_conntrack_init_net(struct net *net)
 
 	atomic_set(&net->ct.count, 0);
 	INIT_HLIST_NULLS_HEAD(&net->ct.unconfirmed, 0);
+	INIT_HLIST_NULLS_HEAD(&net->ct.dying, 0);
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat) {
 		ret = -ENOMEM;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 61f5608..ddaaae6 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -56,8 +56,21 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 			.pid	= 0,
 			.report	= 0
 		};
-
-		notify->fcn(events, &item);
+		int ret;
+		/* We make a copy of the missed event cache without taking
+		 * the lock, thus we may send missed events twice. However,
+		 * this does not harm and it happens very rarely. */
+		unsigned long missed = e->missed;
+
+		ret = notify->fcn(events | missed, &item);
+		if (unlikely(ret < 0 || missed)) {
+			spin_lock_bh(&ct->lock);
+			if (ret < 0)
+				e->missed |= events;
+			else
+				e->missed &= ~missed;
+			spin_unlock_bh(&ct->lock);
+		} 
 	}
 
 out_unlock:
@@ -133,6 +146,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
+static int nf_ct_events_retry_timeout __read_mostly = 15*HZ;
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table event_sysctl_table[] = {
@@ -144,6 +158,14 @@ static struct ctl_table event_sysctl_table[] = {
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
@@ -166,6 +188,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 		goto out;
 
 	table[0].data = &net->ct.sysctl_events;
+	table[1].data = &net->ct.sysctl_events_retry_timeout;
 
 	net->ct.event_sysctl_header =
 		register_net_sysctl_table(net,
@@ -206,6 +229,7 @@ int nf_conntrack_ecache_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_events = nf_ct_events;
+	net->ct.sysctl_events_retry_timeout = nf_ct_events_retry_timeout;
 
 	if (net_eq(net, &init_net)) {
 		ret = nf_ct_extend_register(&event_extend);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 19706ef..49479d1 100644
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
+	if (err == -ENOBUFS || err == -EAGAIN)
+		return -ENOBUFS;
+
 	return 0;
 
 nla_put_failure:
@@ -798,10 +802,15 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	nf_conntrack_event_report(IPCT_DESTROY,
-				  ct,
-				  NETLINK_CB(skb).pid,
-				  nlmsg_report(nlh));
+	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
+				      NETLINK_CB(skb).pid,
+				      nlmsg_report(nlh)) < 0) {
+		nf_ct_delete_from_lists(ct);
+		/* we failed to report the event, try later */
+		nf_ct_insert_dying_list(ct);
+		nf_ct_put(ct);
+		return 0;
+	}
 
 	/* death_by_timeout would report the event again */
 	set_bit(IPS_DYING_BIT, &ct->status);

--------------030308070201040309080004--
