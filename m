From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 6/7] netfilter: remove route_key_size field in struct nf_afinfo
Date: Tue, 19 Dec 2017 00:46:57 +0100
Message-ID: <20171218234658.5004-6-pablo@netfilter.org>
References: <20171218234658.5004-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965076AbdLRXrK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 18:47:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 883BBFB442
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7726534D1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5103034D1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:06 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3422A4265A30
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:06 +0100 (CET)
In-Reply-To: <20171218234658.5004-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is only needed by nf_queue, place this code where it belongs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove .route_key_size from nf_tables_bridge. Reported by kbuild robot.

 include/linux/netfilter.h               |  1 -
 include/linux/netfilter_ipv4.h          | 11 +++++++++++
 include/linux/netfilter_ipv6.h          |  9 +++++++++
 net/bridge/netfilter/nf_tables_bridge.c |  1 -
 net/ipv4/netfilter.c                    | 13 -------------
 net/ipv6/netfilter.c                    | 12 ------------
 net/netfilter/nf_queue.c                | 22 ++++++++++++++++------
 7 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 6bdb0e5706a9..be52fa8a96e1 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,7 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	int		route_key_size;
 };
 
 extern const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO];
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 5f0aa8ca4dc5..806809e018df 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -18,4 +18,15 @@ int nf_ip_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		bool strict);
 int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry);
 void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
+
+/* Extra routing may needed on local out, as the QUEUE target never
+ * returns control to the table.
+ */
+struct ip_rt_info {
+	__be32		daddr;
+	__be32		saddr;
+	u_int8_t	tos;
+	u_int32_t	mark;
+};
+
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 00b017aa2f2a..614725f46313 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -79,4 +79,13 @@ static inline void ipv6_netfilter_fini(void) { return; }
 static inline const struct nf_ipv6_ops *nf_get_ipv6_ops(void) { return NULL; }
 #endif /* CONFIG_NETFILTER */
 
+/* Extra routing may needed on local out, as the QUEUE target never
+ * returns control to the table.
+ */
+struct ip6_rt_info {
+	struct in6_addr	daddr;
+	struct in6_addr	saddr;
+	u_int32_t	mark;
+};
+
 #endif /*__LINUX_IP6_NETFILTER_H*/
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index e7348b49bc0d..874b7e034f82 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -97,7 +97,6 @@ static const struct nf_chain_type filter_bridge = {
 
 static const struct nf_afinfo nf_br_afinfo = {
 	.family                 = AF_BRIDGE,
-	.route_key_size         = 0,
 };
 
 static int __init nf_tables_bridge_init(void)
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 57ed83687d35..9a27029038b5 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -80,18 +80,6 @@ int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_t
 }
 EXPORT_SYMBOL(ip_route_me_harder);
 
-/*
- * Extra routing may needed on local out, as the QUEUE target never
- * returns control to the table.
- */
-
-struct ip_rt_info {
-	__be32 daddr;
-	__be32 saddr;
-	u_int8_t tos;
-	u_int32_t mark;
-};
-
 void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 {
 	struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
@@ -188,7 +176,6 @@ EXPORT_SYMBOL(nf_ip_route);
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.route_key_size		= sizeof(struct ip_rt_info),
 };
 
 static int __init ipv4_netfilter_init(void)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 9a842c5e809f..319ff0655060 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -68,17 +68,6 @@ int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ip6_route_me_harder);
 
-/*
- * Extra routing may needed on local out, as the QUEUE target never
- * returns control to the table.
- */
-
-struct ip6_rt_info {
-	struct in6_addr daddr;
-	struct in6_addr saddr;
-	u_int32_t mark;
-};
-
 void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 {
 	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
@@ -197,7 +186,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.route_key_size		= sizeof(struct ip6_rt_info),
 };
 
 int __init ipv6_netfilter_init(void)
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index db87dfd1318e..325e2cafc832 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -13,6 +13,8 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <net/protocol.h>
 #include <net/netfilter/nf_queue.h>
 #include <net/dst.h>
@@ -114,9 +116,9 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 {
 	int status = -ENOENT;
 	struct nf_queue_entry *entry = NULL;
-	const struct nf_afinfo *afinfo;
 	const struct nf_queue_handler *qh;
 	struct net *net = state->net;
+	unsigned int route_key_size;
 
 	/* QUEUE == DROP if no one is waiting, to be safe. */
 	qh = rcu_dereference(net->nf.queue_handler);
@@ -125,11 +127,19 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
-	afinfo = nf_get_afinfo(state->pf);
-	if (!afinfo)
-		goto err;
+	switch (state->pf) {
+	case AF_INET:
+		route_key_size = sizeof(struct ip_rt_info);
+		break;
+	case AF_INET6:
+		route_key_size = sizeof(struct ip6_rt_info);
+		break;
+	default:
+		route_key_size = 0;
+		break;
+	}
 
-	entry = kmalloc(sizeof(*entry) + afinfo->route_key_size, GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry) {
 		status = -ENOMEM;
 		goto err;
@@ -139,7 +149,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.skb	= skb,
 		.state	= *state,
 		.hook_index = index,
-		.size	= sizeof(*entry) + afinfo->route_key_size,
+		.size	= sizeof(*entry) + route_key_size,
 	};
 
 	nf_queue_entry_get_refs(entry);
-- 
2.11.0

