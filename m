From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/33]: nf_conntrack: split out the event cache
Date: Wed, 29 Nov 2006 03:08:48 +0100 (MET)
Message-ID: <20061129020848.21082.72795.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: split out the event cache

This patch splits out the event cache into its own file
nf_conntrack_ecache.c

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7ac05737ce5e38dc88375e149281efa0afbcadb6
tree 14f5347c2c01920680372bf8a3bd41483d22d93e
parent 19dfaa08934591045aee3699c74e9deffbfd5587
author Martin Josefsson <gandalf@wlug.westbo.se> Tue, 28 Nov 2006 23:12:51 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:12:51 +0100

 include/net/netfilter/nf_conntrack.h        |   81 -----------------------
 include/net/netfilter/nf_conntrack_core.h   |    1 
 include/net/netfilter/nf_conntrack_ecache.h |   95 +++++++++++++++++++++++++++
 net/netfilter/Makefile                      |    4 +
 net/netfilter/nf_conntrack_core.c           |   67 -------------------
 net/netfilter/nf_conntrack_ecache.c         |   91 ++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_ftp.c            |    1 
 net/netfilter/nf_conntrack_proto_sctp.c     |    1 
 net/netfilter/nf_conntrack_proto_tcp.c      |    1 
 net/netfilter/nf_conntrack_proto_udp.c      |    2 +
 net/netfilter/nf_conntrack_standalone.c     |    2 -
 net/netfilter/xt_CONNMARK.c                 |    3 +
 12 files changed, 199 insertions(+), 150 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 9d2581f..9a29505 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -244,87 +244,6 @@ extern int nf_conntrack_checksum;
 
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
 
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-#include <linux/notifier.h>
-#include <linux/interrupt.h>
-#include <net/netfilter/nf_conntrack_expect.h>
-
-struct nf_conntrack_ecache {
-	struct nf_conn *ct;
-	unsigned int events;
-};
-DECLARE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
-
-#define CONNTRACK_ECACHE(x)	(__get_cpu_var(nf_conntrack_ecache).x)
-
-extern struct atomic_notifier_head nf_conntrack_chain;
-extern struct atomic_notifier_head nf_conntrack_expect_chain;
-
-static inline int nf_conntrack_register_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
-}
-
-static inline int nf_conntrack_unregister_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
-}
-
-static inline int
-nf_conntrack_expect_register_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&nf_conntrack_expect_chain, nb);
-}
-
-static inline int
-nf_conntrack_expect_unregister_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&nf_conntrack_expect_chain,
-			nb);
-}
-
-extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
-extern void __nf_ct_event_cache_init(struct nf_conn *ct);
-
-static inline void
-nf_conntrack_event_cache(enum ip_conntrack_events event,
-			 const struct sk_buff *skb)
-{
-	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
-	struct nf_conntrack_ecache *ecache;
-
-	local_bh_disable();
-	ecache = &__get_cpu_var(nf_conntrack_ecache);
-	if (ct != ecache->ct)
-		__nf_ct_event_cache_init(ct);
-	ecache->events |= event;
-	local_bh_enable();
-}
-
-static inline void nf_conntrack_event(enum ip_conntrack_events event,
-				      struct nf_conn *ct)
-{
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
-		atomic_notifier_call_chain(&nf_conntrack_chain, event, ct);
-}
-
-static inline void
-nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
-			  struct nf_conntrack_expect *exp)
-{
-	atomic_notifier_call_chain(&nf_conntrack_expect_chain, event, exp);
-}
-#else /* CONFIG_NF_CONNTRACK_EVENTS */
-static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
-					    const struct sk_buff *skb) {}
-static inline void nf_conntrack_event(enum ip_conntrack_events event,
-				      struct nf_conn *ct) {}
-static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
-static inline void
-nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
-			  struct nf_conntrack_expect *exp) {}
-#endif /* CONFIG_NF_CONNTRACK_EVENTS */
-
 /* no helper, no nat */
 #define	NF_CT_F_BASIC	0
 /* for helper */
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index bf8d300..4676b49 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -15,6 +15,7 @@ #define _NF_CONNTRACK_CORE_H
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
new file mode 100644
index 0000000..b62a8a9
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -0,0 +1,95 @@
+/*
+ * connection tracking event cache.
+ */
+
+#ifndef _NF_CONNTRACK_ECACHE_H
+#define _NF_CONNTRACK_ECACHE_H
+#include <net/netfilter/nf_conntrack.h>
+
+#include <linux/notifier.h>
+#include <linux/interrupt.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+struct nf_conntrack_ecache {
+	struct nf_conn *ct;
+	unsigned int events;
+};
+DECLARE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
+
+#define CONNTRACK_ECACHE(x)	(__get_cpu_var(nf_conntrack_ecache).x)
+
+extern struct atomic_notifier_head nf_conntrack_chain;
+extern struct atomic_notifier_head nf_conntrack_expect_chain;
+
+static inline int nf_conntrack_register_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&nf_conntrack_chain, nb);
+}
+
+static inline int nf_conntrack_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&nf_conntrack_chain, nb);
+}
+
+static inline int
+nf_conntrack_expect_register_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&nf_conntrack_expect_chain, nb);
+}
+
+static inline int
+nf_conntrack_expect_unregister_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&nf_conntrack_expect_chain,
+			nb);
+}
+
+extern void nf_ct_deliver_cached_events(const struct nf_conn *ct);
+extern void __nf_ct_event_cache_init(struct nf_conn *ct);
+extern void nf_ct_event_cache_flush(void);
+
+static inline void
+nf_conntrack_event_cache(enum ip_conntrack_events event,
+			 const struct sk_buff *skb)
+{
+	struct nf_conn *ct = (struct nf_conn *)skb->nfct;
+	struct nf_conntrack_ecache *ecache;
+
+	local_bh_disable();
+	ecache = &__get_cpu_var(nf_conntrack_ecache);
+	if (ct != ecache->ct)
+		__nf_ct_event_cache_init(ct);
+	ecache->events |= event;
+	local_bh_enable();
+}
+
+static inline void nf_conntrack_event(enum ip_conntrack_events event,
+				      struct nf_conn *ct)
+{
+	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
+		atomic_notifier_call_chain(&nf_conntrack_chain, event, ct);
+}
+
+static inline void
+nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
+			  struct nf_conntrack_expect *exp)
+{
+	atomic_notifier_call_chain(&nf_conntrack_expect_chain, event, exp);
+}
+
+#else /* CONFIG_NF_CONNTRACK_EVENTS */
+
+static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
+					    const struct sk_buff *skb) {}
+static inline void nf_conntrack_event(enum ip_conntrack_events event,
+				      struct nf_conn *ct) {}
+static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
+static inline void
+nf_conntrack_expect_event(enum ip_conntrack_expect_events event,
+			  struct nf_conntrack_expect *exp) {}
+static inline void nf_ct_event_cache_flush(void) {}
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
+
+#endif /*_NF_CONNTRACK_ECACHE_H*/
+
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 2363764..fd0641d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,5 +1,7 @@
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
-nf_conntrack-objs	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o
+nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cf6face..029acc4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -85,73 +85,6 @@ static int nf_conntrack_vmalloc __read_m
 
 static unsigned int nf_conntrack_next_id;
 
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
-ATOMIC_NOTIFIER_HEAD(nf_conntrack_expect_chain);
-
-DEFINE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
-
-/* deliver cached events and clear cache entry - must be called with locally
- * disabled softirqs */
-static inline void
-__nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
-{
-	DEBUGP("ecache: delivering events for %p\n", ecache->ct);
-	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
-	    && ecache->events)
-		atomic_notifier_call_chain(&nf_conntrack_chain, ecache->events,
-				    ecache->ct);
-
-	ecache->events = 0;
-	nf_ct_put(ecache->ct);
-	ecache->ct = NULL;
-}
-
-/* Deliver all cached events for a particular conntrack. This is called
- * by code prior to async packet handling for freeing the skb */
-void nf_ct_deliver_cached_events(const struct nf_conn *ct)
-{
-	struct nf_conntrack_ecache *ecache;
-
-	local_bh_disable();
-	ecache = &__get_cpu_var(nf_conntrack_ecache);
-	if (ecache->ct == ct)
-		__nf_ct_deliver_cached_events(ecache);
-	local_bh_enable();
-}
-
-/* Deliver cached events for old pending events, if current conntrack != old */
-void __nf_ct_event_cache_init(struct nf_conn *ct)
-{
-	struct nf_conntrack_ecache *ecache;
-	
-	/* take care of delivering potentially old events */
-	ecache = &__get_cpu_var(nf_conntrack_ecache);
-	BUG_ON(ecache->ct == ct);
-	if (ecache->ct)
-		__nf_ct_deliver_cached_events(ecache);
-	/* initialize for this conntrack/packet */
-	ecache->ct = ct;
-	nf_conntrack_get(&ct->ct_general);
-}
-
-/* flush the event cache - touches other CPU's data and must not be called
- * while packets are still passing through the code */
-static void nf_ct_event_cache_flush(void)
-{
-	struct nf_conntrack_ecache *ecache;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		ecache = &per_cpu(nf_conntrack_ecache, cpu);
-		if (ecache->ct)
-			nf_ct_put(ecache->ct);
-	}
-}
-#else
-static inline void nf_ct_event_cache_flush(void) {}
-#endif /* CONFIG_NF_CONNTRACK_EVENTS */
-
 DEFINE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_stat);
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
new file mode 100644
index 0000000..35763e9
--- /dev/null
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -0,0 +1,91 @@
+/* Event cache for netfilter. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <linux/vmalloc.h>
+#include <linux/stddef.h>
+#include <linux/err.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_l3proto.h>
+#include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_core.h>
+
+ATOMIC_NOTIFIER_HEAD(nf_conntrack_chain);
+ATOMIC_NOTIFIER_HEAD(nf_conntrack_expect_chain);
+
+DEFINE_PER_CPU(struct nf_conntrack_ecache, nf_conntrack_ecache);
+
+/* deliver cached events and clear cache entry - must be called with locally
+ * disabled softirqs */
+static inline void
+__nf_ct_deliver_cached_events(struct nf_conntrack_ecache *ecache)
+{
+	if (nf_ct_is_confirmed(ecache->ct) && !nf_ct_is_dying(ecache->ct)
+	    && ecache->events)
+		atomic_notifier_call_chain(&nf_conntrack_chain, ecache->events,
+				    ecache->ct);
+
+	ecache->events = 0;
+	nf_ct_put(ecache->ct);
+	ecache->ct = NULL;
+}
+
+/* Deliver all cached events for a particular conntrack. This is called
+ * by code prior to async packet handling for freeing the skb */
+void nf_ct_deliver_cached_events(const struct nf_conn *ct)
+{
+	struct nf_conntrack_ecache *ecache;
+
+	local_bh_disable();
+	ecache = &__get_cpu_var(nf_conntrack_ecache);
+	if (ecache->ct == ct)
+		__nf_ct_deliver_cached_events(ecache);
+	local_bh_enable();
+}
+
+/* Deliver cached events for old pending events, if current conntrack != old */
+void __nf_ct_event_cache_init(struct nf_conn *ct)
+{
+	struct nf_conntrack_ecache *ecache;
+
+	/* take care of delivering potentially old events */
+	ecache = &__get_cpu_var(nf_conntrack_ecache);
+	BUG_ON(ecache->ct == ct);
+	if (ecache->ct)
+		__nf_ct_deliver_cached_events(ecache);
+	/* initialize for this conntrack/packet */
+	ecache->ct = ct;
+	nf_conntrack_get(&ct->ct_general);
+}
+
+/* flush the event cache - touches other CPU's data and must not be called
+ * while packets are still passing through the code */
+void nf_ct_event_cache_flush(void)
+{
+	struct nf_conntrack_ecache *ecache;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		ecache = &per_cpu(nf_conntrack_ecache, cpu);
+		if (ecache->ct)
+			nf_ct_put(ecache->ct);
+	}
+}
+
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 503fabf..10836fc 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -27,6 +27,7 @@ #include <net/tcp.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index af56877..ba3e31f 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -33,6 +33,7 @@ #include <linux/interrupt.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 #if 0
 #define DEBUGP(format, ...) printk(format, ## __VA_ARGS__)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 238bbb5..e6b6f23 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -43,6 +43,7 @@ #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index d28981c..cf9db03 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -22,10 +22,12 @@ #include <linux/skbuff.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
 #include <net/checksum.h>
+
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
 unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 72643d3..73ca156 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -33,9 +33,9 @@ #define ASSERT_READ_LOCK(x)
 #define ASSERT_WRITE_LOCK(x)
 
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_protocol.h>
-#include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 67ed531..b554823 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -31,6 +31,9 @@ MODULE_ALIAS("ipt_CONNMARK");
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNMARK.h>
 #include <net/netfilter/nf_conntrack_compat.h>
+#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
+#include <net/netfilter/nf_conntrack_ecache.h>
+#endif
 
 static unsigned int
 target(struct sk_buff **pskb,
