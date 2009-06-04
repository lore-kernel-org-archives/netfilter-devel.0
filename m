From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: conntrack: move event cache to conntrack
	extension infrastructure
Date: Thu, 04 Jun 2009 13:08:18 +0200
Message-ID: <20090604110818.6702.51833.stgit@Decadence>
References: <20090604110307.6702.10147.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44924 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZFDLI2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:08:28 -0400
In-Reply-To: <20090604110307.6702.10147.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch reworks the event caching infrastructure to use the
conntrack extension infrastructure. As a result, you can enable and
disable event delivery via /proc/sys/net/netfilter/nf_conntrack_events
in runtime opposed to compilation time. The main drawback is that
we consume more memory per conntrack if event delivery is enabled.
This patch is required by the reliable event delivery that follows
to this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_ecache.h |  125 +++++++++--------
 include/net/netfilter/nf_conntrack_extend.h |    2 
 include/net/netns/conntrack.h               |    5 -
 net/netfilter/nf_conntrack_core.c           |   17 +-
 net/netfilter/nf_conntrack_ecache.c         |  199 +++++++++++++++++----------
 net/netfilter/nf_conntrack_netlink.c        |   74 ++++++----
 6 files changed, 249 insertions(+), 173 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 1afb907..2fb019a 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -6,59 +6,50 @@
 #define _NF_CONNTRACK_ECACHE_H
 #include <net/netfilter/nf_conntrack.h>
 
-#include <linux/interrupt.h>
 #include <net/net_namespace.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
-/* Connection tracking event bits */
+/* Connection tracking event types */
 enum ip_conntrack_events
 {
-	/* New conntrack */
-	IPCT_NEW_BIT = 0,
-	IPCT_NEW = (1 << IPCT_NEW_BIT),
-
-	/* Expected connection */
-	IPCT_RELATED_BIT = 1,
-	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
-
-	/* Destroyed conntrack */
-	IPCT_DESTROY_BIT = 2,
-	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
-
-	/* Status has changed */
-	IPCT_STATUS_BIT = 3,
-	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
-
-	/* Update of protocol info */
-	IPCT_PROTOINFO_BIT = 4,
-	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
-
-	/* New helper for conntrack */
-	IPCT_HELPER_BIT = 5,
-	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
-
-	/* Mark is set */
-	IPCT_MARK_BIT = 6,
-	IPCT_MARK = (1 << IPCT_MARK_BIT),
-
-	/* NAT sequence adjustment */
-	IPCT_NATSEQADJ_BIT = 7,
-	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
-
-	/* Secmark is set */
-	IPCT_SECMARK_BIT = 8,
-	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
+	IPCT_NEW		= 0,	/* new conntrack */
+	IPCT_RELATED		= 1,	/* related conntrack */
+	IPCT_DESTROY		= 2,	/* destroyed conntrack */
+	IPCT_STATUS		= 3,	/* status has changed */
+	IPCT_PROTOINFO		= 4,	/* protocol information has changed */
+	IPCT_HELPER		= 5,	/* new helper has been set */
+	IPCT_MARK		= 6,	/* new mark has been set */
+	IPCT_NATSEQADJ		= 7,	/* NAT is doing sequence adjustment */
+	IPCT_SECMARK		= 8,	/* new security mark has been set */
 };
 
 enum ip_conntrack_expect_events {
-	IPEXP_NEW_BIT = 0,
-	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
+	IPEXP_NEW		= 0,	/* new expectation */
 };
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct nf_conntrack_ecache {
-	struct nf_conn *ct;
-	unsigned int events;
+	unsigned long cache;	/* bitops want long */
+};
+
+static inline struct nf_conntrack_ecache *
+nf_ct_ecache_find(const struct nf_conn *ct)
+{
+	return nf_ct_ext_find(ct, NF_CT_EXT_ECACHE);
+}
+
+static inline struct nf_conntrack_ecache *
+nf_ct_ecache_ext_add(struct nf_conn *ct, gfp_t gfp)
+{
+	struct net *net = nf_ct_net(ct);
+
+	if (!net->ct.sysctl_events)
+		return NULL;
+
+	return nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
 };
 
 /* This structure is passed to event handler */
@@ -76,22 +67,32 @@ extern struct nf_ct_event_notifier *nf_conntrack_event_cb;
 extern int nf_conntrack_register_notifier(struct nf_ct_event_notifier *nb);
 extern void nf_conntrack_unregister_notifier(struct nf_ct_event_notifier *nb);
 
-extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
-extern void __nf_ct_event_cache_init(struct nf_conn *ct);
-extern void nf_ct_event_cache_flush(struct net *net);
+extern void nf_ct_deliver_cached_events_report(struct nf_conn *ct, u32 pid, int report);
+
+static inline void nf_ct_deliver_cached_events(struct nf_conn *ct)
+{
+	nf_ct_deliver_cached_events_report(ct, 0, 0);
+}
 
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 {
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache;
-
-	local_bh_disable();
-	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
-	if (ct != ecache->ct)
-		__nf_ct_event_cache_init(ct);
-	ecache->events |= event;
-	local_bh_enable();
+	struct nf_conntrack_ecache *e;
+	struct nf_ct_event_notifier *notify;
+
+	rcu_read_lock();
+	notify = rcu_dereference(nf_conntrack_event_cb);
+	if (notify == NULL) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
+	e = nf_ct_ecache_find(ct);
+	if (e == NULL)
+		return;
+
+	set_bit(event, &e->cache);
 }
 
 static inline void
@@ -100,6 +101,7 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 			  u32 pid,
 			  int report)
 {
+	struct net *net = nf_ct_net(ct);
 	struct nf_ct_event_notifier *notify;
 
 	rcu_read_lock();
@@ -107,13 +109,16 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 	if (notify == NULL)
 		goto out_unlock;
 
+	if (!net->ct.sysctl_events)
+		goto out_unlock;
+
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct)) {
 		struct nf_ct_event item = {
 			.ct 	= ct,
 			.pid	= pid,
 			.report = report
 		};
-		notify->fcn(event, &item);
+		notify->fcn((1 << event), &item);
 	}
 out_unlock:
 	rcu_read_unlock();
@@ -145,6 +150,7 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			  u32 pid,
 			  int report)
 {
+	struct net *net = nf_ct_exp_net(exp);
 	struct nf_exp_event_notifier *notify;
 
 	rcu_read_lock();
@@ -152,13 +158,16 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 	if (notify == NULL)
 		goto out_unlock;
 
+	if (!net->ct.sysctl_events)
+		goto out_unlock;
+
 	{
 		struct nf_exp_event item = {
 			.exp	= exp,
 			.pid	= pid,
 			.report = report
 		};
-		notify->fcn(event, &item);
+		notify->fcn((1 << event), &item);
 	}
 out_unlock:
 	rcu_read_unlock();
@@ -191,12 +200,6 @@ static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
 					     struct nf_conntrack_expect *exp,
  					     u32 pid,
  					     int report) {}
-static inline void nf_ct_event_cache_flush(struct net *net) {}
-
-static inline int nf_conntrack_ecache_init(struct net *net)
-{
-	return 0;
-}
 
 static inline void nf_conntrack_ecache_fini(struct net *net)
 {
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index da8ee52..7f8fc5d 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -8,12 +8,14 @@ enum nf_ct_ext_id
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
 	NF_CT_EXT_ACCT,
+	NF_CT_EXT_ECACHE,
 	NF_CT_EXT_NUM,
 };
 
 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
+#define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 9dc5840..505a51c 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -15,15 +15,14 @@ struct netns_ct {
 	struct hlist_head	*expect_hash;
 	struct hlist_nulls_head	unconfirmed;
 	struct ip_conntrack_stat *stat;
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct nf_conntrack_ecache *ecache;
-#endif
+	int			sysctl_events;
 	int			sysctl_acct;
 	int			sysctl_checksum;
 	unsigned int		sysctl_log_invalid; /* Log invalid packets */
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 	struct ctl_table_header	*acct_sysctl_header;
+	struct ctl_table_header	*event_sysctl_header;
 #endif
 	int			hash_vmalloc;
 	int			expect_vmalloc;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b54c234..e8905a9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -576,6 +576,7 @@ init_conntrack(struct net *net,
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, GFP_ATOMIC);
 
 	spin_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(net, tuple);
@@ -738,6 +739,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 
 	NF_CT_ASSERT(skb->nfct);
 
+	/* We may have pending events, deliver them and clear the cache */
+	nf_ct_deliver_cached_events(ct);
+
 	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, hooknum);
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
@@ -1035,8 +1039,6 @@ static void nf_conntrack_cleanup_init_net(void)
 
 static void nf_conntrack_cleanup_net(struct net *net)
 {
-	nf_ct_event_cache_flush(net);
-	nf_conntrack_ecache_fini(net);
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
 	if (atomic_read(&net->ct.count) != 0) {
@@ -1049,6 +1051,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 
 	nf_ct_free_hashtable(net->ct.hash, net->ct.hash_vmalloc,
 			     nf_conntrack_htable_size);
+	nf_conntrack_ecache_fini(net);
 	nf_conntrack_acct_fini(net);
 	nf_conntrack_expect_fini(net);
 	free_percpu(net->ct.stat);
@@ -1224,9 +1227,6 @@ static int nf_conntrack_init_net(struct net *net)
 		ret = -ENOMEM;
 		goto err_stat;
 	}
-	ret = nf_conntrack_ecache_init(net);
-	if (ret < 0)
-		goto err_ecache;
 	net->ct.hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size,
 					     &net->ct.hash_vmalloc, 1);
 	if (!net->ct.hash) {
@@ -1240,6 +1240,9 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_acct_init(net);
 	if (ret < 0)
 		goto err_acct;
+	ret = nf_conntrack_ecache_init(net);
+	if (ret < 0)
+		goto err_ecache;
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
@@ -1252,14 +1255,14 @@ static int nf_conntrack_init_net(struct net *net)
 
 	return 0;
 
+err_ecache:
+	nf_conntrack_acct_fini(net);
 err_acct:
 	nf_conntrack_expect_fini(net);
 err_expect:
 	nf_ct_free_hashtable(net->ct.hash, net->ct.hash_vmalloc,
 			     nf_conntrack_htable_size);
 err_hash:
-	nf_conntrack_ecache_fini(net);
-err_ecache:
 	free_percpu(net->ct.stat);
 err_stat:
 	return ret;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 5516b3e..3fe2682 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -1,7 +1,7 @@
 /* Event cache for netfilter. */
 
 /* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2002-2009 Netfilter Core Team <coreteam@netfilter.org>
  * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -21,6 +21,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
@@ -32,93 +33,35 @@ EXPORT_SYMBOL_GPL(nf_expect_event_cb);
 
 /* deliver cached events and clear cache entry - must be called with locally
  * disabled softirqs */
-static inline void
-__nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
+void nf_ct_deliver_cached_events_report(struct nf_conn *ct, u32 pid, int report)
 {
 	struct nf_ct_event_notifier *notify;
+	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
 	notify = rcu_dereference(nf_conntrack_event_cb);
 	if (notify == NULL)
 		goto out_unlock;
 
-	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
-	    && ecache->events) {
+	e = nf_ct_ecache_find(ct);
+	if (e == NULL)
+		goto out_unlock;
+
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct) && e->cache) {
 		struct nf_ct_event item = {
-			.ct 	= ecache->ct,
-			.pid	= 0,
-			.report	= 0
+			.ct	= ct,
+			.pid	= pid,
+			.report	= report
 		};
 
-		notify->fcn(ecache->events, &item);
+		notify->fcn(e->cache, &item);
 	}
-
-	ecache->events = 0;
-	nf_ct_put(ecache->ct);
-	ecache->ct = NULL;
+	xchg(&e->cache, 0);
 
 out_unlock:
 	rcu_read_unlock();
 }
-
-/* Deliver all cached events for a particular conntrack. This is called
- * by code prior to async packet handling for freeing the skb */
-void nf_ct_deliver_cached_events(const struct nf_conn *ct)
-{
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache;
-
-	local_bh_disable();
-	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
-	if (ecache->ct == ct)
-		__nf_ct_deliver_cached_events(ecache);
-	local_bh_enable();
-}
-EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
-
-/* Deliver cached events for old pending events, if current conntrack != old */
-void __nf_ct_event_cache_init(struct nf_conn *ct)
-{
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache;
-
-	/* take care of delivering potentially old events */
-	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
-	BUG_ON(ecache->ct == ct);
-	if (ecache->ct)
-		__nf_ct_deliver_cached_events(ecache);
-	/* initialize for this conntrack/packet */
-	ecache->ct = ct;
-	nf_conntrack_get(&ct->ct_general);
-}
-EXPORT_SYMBOL_GPL(__nf_ct_event_cache_init);
-
-/* flush the event cache - touches other CPU's data and must not be called
- * while packets are still passing through the code */
-void nf_ct_event_cache_flush(struct net *net)
-{
-	struct nf_conntrack_ecache *ecache;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		ecache = per_cpu_ptr(net->ct.ecache, cpu);
-		if (ecache->ct)
-			nf_ct_put(ecache->ct);
-	}
-}
-
-int nf_conntrack_ecache_init(struct net *net)
-{
-	net->ct.ecache = alloc_percpu(struct nf_conntrack_ecache);
-	if (!net->ct.ecache)
-		return -ENOMEM;
-	return 0;
-}
-
-void nf_conntrack_ecache_fini(struct net *net)
-{
-	free_percpu(net->ct.ecache);
-}
+EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events_report);
 
 int nf_conntrack_register_notifier(struct nf_ct_event_notifier *new)
 {
@@ -185,3 +128,115 @@ void nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *new)
 	mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+#define NF_CT_EVENTS_DEFAULT 1
+#else
+#define NF_CT_EVENTS_DEFAULT 0
+#endif
+
+static int nf_ct_events_switch __read_mostly = NF_CT_EVENTS_DEFAULT;
+
+module_param_named(event, nf_ct_events_switch, bool, 0644);
+MODULE_PARM_DESC(event, "Enable connection tracking event delivery");
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table event_sysctl_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nf_conntrack_events",
+		.data		= &init_net.ct.sysctl_events,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+#endif /* CONFIG_SYSCTL */
+
+static struct nf_ct_ext_type event_extend __read_mostly = {
+	.len	= sizeof(struct nf_conntrack_ecache),
+	.align	= __alignof__(struct nf_conntrack_ecache),
+	.id	= NF_CT_EXT_ECACHE,
+};
+
+#ifdef CONFIG_SYSCTL
+static int nf_conntrack_event_init_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = kmemdup(event_sysctl_table, sizeof(event_sysctl_table),
+			GFP_KERNEL);
+	if (!table)
+		goto out;
+
+	table[0].data = &net->ct.sysctl_events;
+
+	net->ct.event_sysctl_header =
+		register_net_sysctl_table(net,
+					  nf_net_netfilter_sysctl_path, table);
+	if (!net->ct.event_sysctl_header) {
+		printk(KERN_ERR "nf_ct_event: can't register to sysctl.\n");
+		goto out_register;
+	}
+	return 0;
+
+out_register:
+	kfree(table);
+out:
+	return -ENOMEM;
+}
+
+static void nf_conntrack_event_fini_sysctl(struct net *net)
+{
+	struct ctl_table *table;
+
+	table = net->ct.event_sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->ct.event_sysctl_header);
+	kfree(table);
+}
+#else
+static int nf_conntrack_event_init_sysctl(struct net *net)
+{
+	return 0;
+}
+
+static void nf_conntrack_event_fini_sysctl(struct net *net)
+{
+}
+#endif
+
+int nf_conntrack_ecache_init(struct net *net)
+{
+	int ret;
+
+	net->ct.sysctl_events = nf_ct_events_switch;
+
+	if (net_eq(net, &init_net)) {
+		ret = nf_ct_extend_register(&event_extend);
+		if (ret < 0) {
+			printk(KERN_ERR "nf_ct_event: Unable to register "
+					"event extension.\n");
+			goto out_extend_register;
+		}
+	}
+
+	ret = nf_conntrack_event_init_sysctl(net);
+	if (ret < 0)
+		goto out_sysctl;
+
+	return 0;
+
+out_sysctl:
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&event_extend);
+out_extend_register:
+	return ret;
+}
+
+void nf_conntrack_ecache_fini(struct net *net)
+{
+	nf_conntrack_event_fini_sysctl(net);
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&event_extend);
+}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4448b06..2dd2910 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -468,10 +468,10 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	if (ct == &nf_conntrack_untracked)
 		return 0;
 
-	if (events & IPCT_DESTROY) {
+	if (events & (1 << IPCT_DESTROY)) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
-	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
+	} else  if (events & ((1 << IPCT_NEW) | (1 << IPCT_RELATED))) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 		group = NFNLGRP_CONNTRACK_NEW;
@@ -519,7 +519,7 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	if (ctnetlink_dump_status(skb, ct) < 0)
 		goto nla_put_failure;
 
-	if (events & IPCT_DESTROY) {
+	if (events & (1 << IPCT_DESTROY)) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 			goto nla_put_failure;
@@ -527,31 +527,31 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		if (ctnetlink_dump_timeout(skb, ct) < 0)
 			goto nla_put_failure;
 
-		if (events & IPCT_PROTOINFO
+		if (events & (1 << IPCT_PROTOINFO)
 		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
 			goto nla_put_failure;
 
-		if ((events & IPCT_HELPER || nfct_help(ct))
+		if ((events & (1 << IPCT_HELPER) || nfct_help(ct))
 		    && ctnetlink_dump_helpinfo(skb, ct) < 0)
 			goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
-		if ((events & IPCT_SECMARK || ct->secmark)
+		if ((events & (1 << IPCT_SECMARK) || ct->secmark)
 		    && ctnetlink_dump_secmark(skb, ct) < 0)
 			goto nla_put_failure;
 #endif
 
-		if (events & IPCT_RELATED &&
+		if (events & (1 << IPCT_RELATED) &&
 		    ctnetlink_dump_master(skb, ct) < 0)
 			goto nla_put_failure;
 
-		if (events & IPCT_NATSEQADJ &&
+		if (events & (1 << IPCT_NATSEQADJ) &&
 		    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 			goto nla_put_failure;
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((events & IPCT_MARK || ct->mark)
+	if ((events & (1 << IPCT_MARK) || ct->mark)
 	    && ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
@@ -1123,6 +1123,8 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 		err = ctnetlink_change_helper(ct, cda);
 		if (err < 0)
 			return err;
+
+		nf_conntrack_event_cache(IPCT_HELPER, ct);
 	}
 
 	if (cda[CTA_TIMEOUT]) {
@@ -1135,17 +1137,23 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
 			return err;
+
+		nf_conntrack_event_cache(IPCT_STATUS, ct);
 	}
 
 	if (cda[CTA_PROTOINFO]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
 			return err;
+
+		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
+	if (cda[CTA_MARK]) {
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		nf_conntrack_event_cache(IPCT_MARK, ct);
+	}
 #endif
 
 #ifdef CONFIG_NF_NAT_NEEDED
@@ -1153,6 +1161,8 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 		err = ctnetlink_change_nat_seq_adj(ct, cda);
 		if (err < 0)
 			return err;
+
+		nf_conntrack_event_cache(IPCT_NATSEQADJ, ct);
 	}
 #endif
 
@@ -1179,6 +1189,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
+	nf_conntrack_event_cache(IPCT_STATUS, ct);
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
@@ -1218,12 +1229,17 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 			/* not in hash table yet so not strictly necessary */
 			rcu_assign_pointer(help->helper, helper);
+			nf_conntrack_event_cache(IPCT_HELPER, ct);
 		}
 	} else {
 		/* try an implicit helper assignation */
 		err = __nf_ct_try_assign_helper(ct, GFP_ATOMIC);
 		if (err < 0)
 			goto err2;
+
+		/* we've got a helper, add this to the event cache */
+		if (nfct_help(ct))
+			nf_conntrack_event_cache(IPCT_HELPER, ct);
 	}
 
 	if (cda[CTA_STATUS]) {
@@ -1243,6 +1259,8 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		err = ctnetlink_change_nat_seq_adj(ct, cda);
 		if (err < 0)
 			goto err2;
+
+		nf_conntrack_event_cache(IPCT_NATSEQADJ, ct);
 	}
 #endif
 
@@ -1250,13 +1268,18 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
 			goto err2;
+
+		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, GFP_ATOMIC);
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
+	if (cda[CTA_MARK]) {
 		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		nf_conntrack_event_cache(IPCT_MARK, ct);
+	}
 #endif
 
 	/* setup master conntrack: this is a confirmed expectation */
@@ -1324,7 +1347,6 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
 			struct nf_conn *ct;
-			enum ip_conntrack_events events;
 
 			ct = ctnetlink_create_conntrack(cda, &otuple,
 							&rtuple, u3);
@@ -1336,17 +1358,13 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
 			if (test_bit(IPS_EXPECTED_BIT, &ct->status))
-				events = IPCT_RELATED;
+				nf_conntrack_event_cache(IPCT_RELATED, ct);
 			else
-				events = IPCT_NEW;
-
-			nf_conntrack_event_report(IPCT_STATUS |
-						  IPCT_HELPER |
-						  IPCT_PROTOINFO |
-						  IPCT_NATSEQADJ |
-						  IPCT_MARK | events,
-						  ct, NETLINK_CB(skb).pid,
-						  nlmsg_report(nlh));
+				nf_conntrack_event_cache(IPCT_NEW, ct);
+
+			nf_ct_deliver_cached_events_report(ct,
+							   NETLINK_CB(skb).pid,
+							   nlmsg_report(nlh));
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1365,13 +1383,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			nf_conntrack_event_report(IPCT_STATUS |
-						  IPCT_HELPER |
-						  IPCT_PROTOINFO |
-						  IPCT_NATSEQADJ |
-						  IPCT_MARK,
-						  ct, NETLINK_CB(skb).pid,
-						  nlmsg_report(nlh));
+			nf_ct_deliver_cached_events_report(ct,
+							   NETLINK_CB(skb).pid,
+							   nlmsg_report(nlh));
 			nf_ct_put(ct);
 		} else
 			spin_unlock_bh(&nf_conntrack_lock);
@@ -1515,7 +1529,7 @@ ctnetlink_expect_event(unsigned int events, struct nf_exp_event *item)
 	unsigned int type;
 	int flags = 0;
 
-	if (events & IPEXP_NEW) {
+	if (events & (1 << IPEXP_NEW)) {
 		type = IPCTNL_MSG_EXP_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 	} else

