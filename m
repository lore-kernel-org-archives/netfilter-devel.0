From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/5] conntrack: ecache: move event cache to conntrack
	extension infrastructure
Date: Fri, 27 Mar 2009 10:40:09 +0100
Message-ID: <20090327094009.8259.64117.stgit@Decadence>
References: <20090327093822.8259.50902.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42605 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752103AbZC0Jkg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:40:36 -0400
In-Reply-To: <20090327093822.8259.50902.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch reworks the event caching infrastructure to use the
conntrack extension infrastructure. As a result, you can enable and
disable event delivery via /proc/sys/net/netfilter/nf_conntrack_events
in runtime opposed to compilation time. The main drawback is that
we consume more memory per conntrack if event delivery is enabled.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack_ecache.h |   71 +++++++---
 include/net/netfilter/nf_conntrack_extend.h |    2 
 include/net/netns/conntrack.h               |    5 -
 net/netfilter/nf_conntrack_core.c           |   37 ++---
 net/netfilter/nf_conntrack_ecache.c         |  195 +++++++++++++++++----------
 net/netfilter/nf_conntrack_ftp.c            |    4 -
 net/netfilter/nf_conntrack_netlink.c        |    1 
 net/netfilter/nf_conntrack_proto_sctp.c     |    2 
 net/netfilter/nf_conntrack_proto_tcp.c      |    7 +
 9 files changed, 202 insertions(+), 122 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 892b8cd..89cf298 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -6,10 +6,11 @@
 #define _NF_CONNTRACK_ECACHE_H
 #include <net/netfilter/nf_conntrack.h>
 
-#include <linux/notifier.h>
-#include <linux/interrupt.h>
 #include <net/net_namespace.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 /* Connection tracking event bits */
 enum ip_conntrack_events
@@ -82,8 +83,24 @@ enum ip_conntrack_expect_events {
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 struct nf_conntrack_ecache {
-	struct nf_conn *ct;
-	unsigned int events;
+	unsigned int cache;
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
@@ -97,22 +114,28 @@ extern struct atomic_notifier_head nf_conntrack_chain;
 extern int nf_conntrack_register_notifier(struct notifier_block *nb);
 extern int nf_conntrack_unregister_notifier(struct notifier_block *nb);
 
-extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
-extern void __nf_ct_event_cache_init(struct nf_conn *ct);
-extern void nf_ct_event_cache_flush(struct net *net);
+extern void nf_ct_deliver_cached_events(struct nf_conn *ct);
+
+static inline void
+__nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
+{
+	struct nf_conntrack_ecache *e;
+
+	e = nf_ct_ecache_find(ct);
+	if (e == NULL)
+		return;
+
+	e->cache |= event;
+}
+
+extern spinlock_t nf_conntrack_lock;
 
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
+	spin_lock_bh(&nf_conntrack_lock);
+	__nf_conntrack_event_cache(event, ct);
+	spin_unlock_bh(&nf_conntrack_lock);
 }
 
 static inline void
@@ -126,6 +149,11 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 		.pid	= pid,
 		.report = report
 	};
+	struct net *net = nf_ct_net(ct);
+
+	if (!net->ct.sysctl_events)
+		return;
+
 	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 		atomic_notifier_call_chain(&nf_conntrack_chain, event, &item);
 }
@@ -157,6 +185,11 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 		.pid	= pid,
 		.report = report
 	};
+	struct net *net = nf_ct_exp_net(exp);
+
+	if (!net->ct.sysctl_events)
+		return;
+
 	atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
 }
 
@@ -187,12 +220,6 @@ static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
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
index f4498a6..69dd322 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -14,15 +14,14 @@ struct netns_ct {
 	struct hlist_head	*expect_hash;
 	struct hlist_head	unconfirmed;
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
index 94bccae..d5cae75 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -371,17 +371,17 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	atomic_inc(&ct->ct_general.use);
 	set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	NF_CT_STAT_INC(net, insert);
-	spin_unlock_bh(&nf_conntrack_lock);
 	help = nfct_help(ct);
 	if (help && help->helper)
-		nf_conntrack_event_cache(IPCT_HELPER, ct);
+		__nf_conntrack_event_cache(IPCT_HELPER, ct);
 #ifdef CONFIG_NF_NAT_NEEDED
 	if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
 	    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
-		nf_conntrack_event_cache(IPCT_NATINFO, ct);
+		__nf_conntrack_event_cache(IPCT_NATINFO, ct);
 #endif
-	nf_conntrack_event_cache(master_ct(ct) ?
-				 IPCT_RELATED : IPCT_NEW, ct);
+	__nf_conntrack_event_cache(master_ct(ct) ?
+				   IPCT_RELATED : IPCT_NEW, ct);
+	spin_unlock_bh(&nf_conntrack_lock);
 	return NF_ACCEPT;
 
 out:
@@ -562,6 +562,7 @@ init_conntrack(struct net *net,
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, GFP_ATOMIC);
 
 	spin_lock_bh(&nf_conntrack_lock);
 	exp = nf_ct_find_expectation(net, tuple);
@@ -724,6 +725,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 
 	NF_CT_ASSERT(skb->nfct);
 
+	/* We may have pending events, deliver them and clear the cache */
+	nf_ct_deliver_cached_events(ct);
+
 	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, hooknum);
 	if (ret < 0) {
 		/* Invalid: inverse of the return code tells
@@ -789,8 +793,6 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  unsigned long extra_jiffies,
 			  int do_acct)
 {
-	int event = 0;
-
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
 	NF_CT_ASSERT(skb);
 
@@ -803,7 +805,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
-		event = IPCT_REFRESH;
+		__nf_conntrack_event_cache(IPCT_REFRESH, ct);
 	} else {
 		unsigned long newtime = jiffies + extra_jiffies;
 
@@ -814,7 +816,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 		    && del_timer(&ct->timeout)) {
 			ct->timeout.expires = newtime;
 			add_timer(&ct->timeout);
-			event = IPCT_REFRESH;
+			__nf_conntrack_event_cache(IPCT_REFRESH, ct);
 		}
 	}
 
@@ -831,10 +833,6 @@ acct:
 	}
 
 	spin_unlock_bh(&nf_conntrack_lock);
-
-	/* must be unlocked when calling event cache */
-	if (event)
-		nf_conntrack_event_cache(event, ct);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
@@ -1020,8 +1018,6 @@ static void nf_conntrack_cleanup_init_net(void)
 
 static void nf_conntrack_cleanup_net(struct net *net)
 {
-	nf_ct_event_cache_flush(net);
-	nf_conntrack_ecache_fini(net);
  i_see_dead_people:
 	nf_ct_iterate_cleanup(net, kill_all, NULL);
 	if (atomic_read(&net->ct.count) != 0) {
@@ -1034,6 +1030,7 @@ static void nf_conntrack_cleanup_net(struct net *net)
 
 	nf_ct_free_hashtable(net->ct.hash, net->ct.hash_vmalloc,
 			     nf_conntrack_htable_size);
+	nf_conntrack_ecache_fini(net);
 	nf_conntrack_acct_fini(net);
 	nf_conntrack_expect_fini(net);
 	free_percpu(net->ct.stat);
@@ -1207,9 +1204,6 @@ static int nf_conntrack_init_net(struct net *net)
 		ret = -ENOMEM;
 		goto err_stat;
 	}
-	ret = nf_conntrack_ecache_init(net);
-	if (ret < 0)
-		goto err_ecache;
 	net->ct.hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size,
 						  &net->ct.hash_vmalloc);
 	if (!net->ct.hash) {
@@ -1223,6 +1217,9 @@ static int nf_conntrack_init_net(struct net *net)
 	ret = nf_conntrack_acct_init(net);
 	if (ret < 0)
 		goto err_acct;
+	ret = nf_conntrack_ecache_init(net);
+	if (ret < 0)
+		goto err_ecache;
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
@@ -1235,14 +1232,14 @@ static int nf_conntrack_init_net(struct net *net)
 
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
index dee4190..7522ea0 100644
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
@@ -22,6 +22,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 
 ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
 EXPORT_SYMBOL_GPL(nf_conntrack_chain);
@@ -29,108 +30,160 @@ EXPORT_SYMBOL_GPL(nf_conntrack_chain);
 ATOMIC_NOTIFIER_HEAD(nf_ct_expect_chain);
 EXPORT_SYMBOL_GPL(nf_ct_expect_chain);
 
-/* deliver cached events and clear cache entry - must be called with locally
- * disabled softirqs */
-static inline void
-__nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
+/* Deliver all cached events for a particular conntrack. This is called
+ * by code prior to async packet handling for freeing the skb */
+void nf_ct_deliver_cached_events(struct nf_conn *ct)
 {
-	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
-	    && ecache->events) {
+	struct nf_conntrack_ecache *e;
+
+	e = nf_ct_ecache_find(ct);
+	if (e == NULL)
+		return;
+
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct) && e->cache) {
 		struct nf_ct_event item = {
-			.ct 	= ecache->ct,
+			.ct	= ct,
 			.pid	= 0,
 			.report	= 0
 		};
-
-		atomic_notifier_call_chain(&nf_conntrack_chain,
-					   ecache->events,
-					   &item);
+		atomic_notifier_call_chain(&nf_conntrack_chain, e->cache,&item);
 	}
-
-	ecache->events = 0;
-	nf_ct_put(ecache->ct);
-	ecache->ct = NULL;
+	xchg(&e->cache, 0);
 }
+EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
 
-/* Deliver all cached events for a particular conntrack. This is called
- * by code prior to async packet handling for freeing the skb */
-void nf_ct_deliver_cached_events(const struct nf_conn *ct)
+int nf_conntrack_register_notifier(struct notifier_block *nb)
 {
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *ecache;
-
-	local_bh_disable();
-	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
-	if (ecache->ct == ct)
-		__nf_ct_deliver_cached_events(ecache);
-	local_bh_enable();
+	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
 }
-EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
+EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
-/* Deliver cached events for old pending events, if current conntrack != old */
-void __nf_ct_event_cache_init(struct nf_conn *ct)
+int nf_conntrack_unregister_notifier(struct notifier_block *nb)
 {
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
+	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
 }
-EXPORT_SYMBOL_GPL(__nf_ct_event_cache_init);
+EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
-/* flush the event cache - touches other CPU's data and must not be called
- * while packets are still passing through the code */
-void nf_ct_event_cache_flush(struct net *net)
+int nf_ct_expect_register_notifier(struct notifier_block *nb)
 {
-	struct nf_conntrack_ecache *ecache;
-	int cpu;
+	return atomic_notifier_chain_register(&nf_ct_expect_chain, nb);
+}
+EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
 
-	for_each_possible_cpu(cpu) {
-		ecache = per_cpu_ptr(net->ct.ecache, cpu);
-		if (ecache->ct)
-			nf_ct_put(ecache->ct);
-	}
+int nf_ct_expect_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&nf_ct_expect_chain, nb);
 }
+EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
-int nf_conntrack_ecache_init(struct net *net)
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
 {
-	net->ct.ecache = alloc_percpu(struct nf_conntrack_ecache);
-	if (!net->ct.ecache)
-		return -ENOMEM;
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
 	return 0;
+
+out_register:
+	kfree(table);
+out:
+	return -ENOMEM;
 }
 
-void nf_conntrack_ecache_fini(struct net *net)
+static void nf_conntrack_event_fini_sysctl(struct net *net)
 {
-	free_percpu(net->ct.ecache);
-}
+	struct ctl_table *table;
 
-int nf_conntrack_register_notifier(struct notifier_block *nb)
+	table = net->ct.event_sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(net->ct.event_sysctl_header);
+	kfree(table);
+}
+#else
+static int nf_conntrack_event_init_sysctl(struct net *net)
 {
-	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
-int nf_conntrack_unregister_notifier(struct notifier_block *nb)
+static void nf_conntrack_event_fini_sysctl(struct net *net)
 {
-	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
 }
-EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
+#endif
 
-int nf_ct_expect_register_notifier(struct notifier_block *nb)
+int nf_conntrack_ecache_init(struct net *net)
 {
-	return atomic_notifier_chain_register(&nf_ct_expect_chain, nb);
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
 }
-EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
 
-int nf_ct_expect_unregister_notifier(struct notifier_block *nb)
+void nf_conntrack_ecache_fini(struct net *net)
 {
-	return atomic_notifier_chain_unregister(&nf_ct_expect_chain, nb);
+	nf_conntrack_event_fini_sysctl(net);
+	if (net_eq(net, &init_net))
+		nf_ct_extend_unregister(&event_extend);
 }
-EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 00fecc3..fe2931d 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -338,11 +338,11 @@ static void update_nl_seq(struct nf_conn *ct, u32 nl_seq,
 
 	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
-		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, ct);
+		__nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, ct);
 	} else if (oldest != NUM_SEQ_TO_REMEMBER &&
 		   after(nl_seq, info->seq_aft_nl[dir][oldest])) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
-		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, ct);
+		__nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, ct);
 	}
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d399b04..cdc09bd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1237,6 +1237,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 	}
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, GFP_ATOMIC);
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK])
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 74e0379..e7ea25c 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -369,7 +369,7 @@ static int sctp_packet(struct nf_conn *ct,
 
 		ct->proto.sctp.state = new_state;
 		if (old_state != new_state)
-			nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+			__nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 	}
 	write_unlock_bh(&sctp_lock);
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a1edb9c..78bce2a 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -969,11 +969,12 @@ static int tcp_packet(struct nf_conn *ct,
 		timeout = nf_ct_tcp_timeout_unacknowledged;
 	else
 		timeout = tcp_timeouts[new_state];
-	write_unlock_bh(&tcp_lock);
 
-	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
+	__nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
 	if (new_state != old_state)
-		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+		__nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+
+	write_unlock_bh(&tcp_lock);
 
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		/* If only reply is a RST, we can consider ourselves not to

