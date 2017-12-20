From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v3 3/7] netfilter: remove saveroute indirection in struct nf_afinfo
Date: Thu, 21 Dec 2017 00:12:45 +0100
Message-ID: <20171220231249.10599-4-pablo@netfilter.org>
References: <20171220231249.10599-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58456 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756503AbdLTXNB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 18:13:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6AACAEBAD6
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5726E34D7
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 162F534D7
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:57 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 01AAA4265A30
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:56 +0100 (CET)
In-Reply-To: <20171220231249.10599-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is only used by nf_queue.c and this function comes with no symbol
dependencies with IPv6, it just refers to structure layouts. Therefore,
we can replace it by a direct function call from where it belongs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h               |  2 --
 include/linux/netfilter_ipv4.h          | 10 ++++++++
 include/linux/netfilter_ipv6.h          |  9 +++++++
 net/bridge/netfilter/nf_tables_bridge.c |  6 -----
 net/ipv4/netfilter.c                    | 28 ----------------------
 net/ipv6/netfilter.c                    | 26 --------------------
 net/netfilter/nf_queue.c                | 42 ++++++++++++++++++++++++++++++++-
 7 files changed, 60 insertions(+), 63 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 70b238eff29f..5fc2443225f9 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -313,8 +313,6 @@ struct nf_afinfo {
 	unsigned short	family;
 	int		(*route)(struct net *net, struct dst_entry **dst,
 				 struct flowi *fl, bool strict);
-	void		(*saveroute)(const struct sk_buff *skb,
-				     struct nf_queue_entry *entry);
 	int		(*reroute)(struct net *net, struct sk_buff *skb,
 				   const struct nf_queue_entry *entry);
 	int		route_key_size;
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 6d61ec0a7695..efa0619486c9 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -6,6 +6,16 @@
 
 #include <uapi/linux/netfilter_ipv4.h>
 
+/* Extra routing may needed on local out, as the QUEUE target never returns
+ * control to the table.
+ */
+struct ip_rt_info {
+	__be32 daddr;
+	__be32 saddr;
+	u_int8_t tos;
+	u_int32_t mark;
+};
+
 int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 29e8f1286584..08d58dc018b5 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -9,6 +9,15 @@
 
 #include <uapi/linux/netfilter_ipv6.h>
 
+/* Extra routing may needed on local out, as the QUEUE target never returns
+ * control to the table.
+ */
+struct ip6_rt_info {
+	struct in6_addr daddr;
+	struct in6_addr saddr;
+	u_int32_t mark;
+};
+
 /*
  * Hook functions for ipv6 to allow xt_* modules to be built-in even
  * if IPv6 is a module.
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index b24ac11cacc9..f38350c6bc29 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -95,11 +95,6 @@ static const struct nf_chain_type filter_bridge = {
 	},
 };
 
-static void nf_br_saveroute(const struct sk_buff *skb,
-			    struct nf_queue_entry *entry)
-{
-}
-
 static int nf_br_reroute(struct net *net, struct sk_buff *skb,
 			 const struct nf_queue_entry *entry)
 {
@@ -115,7 +110,6 @@ static int nf_br_route(struct net *net, struct dst_entry **dst,
 static const struct nf_afinfo nf_br_afinfo = {
 	.family                 = AF_BRIDGE,
 	.route                  = nf_br_route,
-	.saveroute              = nf_br_saveroute,
 	.reroute                = nf_br_reroute,
 	.route_key_size         = 0,
 };
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 010c75fddf7e..7878ae6c35b2 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -80,33 +80,6 @@ int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned int addr_t
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
-static void nf_ip_saveroute(const struct sk_buff *skb,
-			    struct nf_queue_entry *entry)
-{
-	struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
-
-	if (entry->state.hook == NF_INET_LOCAL_OUT) {
-		const struct iphdr *iph = ip_hdr(skb);
-
-		rt_info->tos = iph->tos;
-		rt_info->daddr = iph->daddr;
-		rt_info->saddr = iph->saddr;
-		rt_info->mark = skb->mark;
-	}
-}
-
 static int nf_ip_reroute(struct net *net, struct sk_buff *skb,
 			 const struct nf_queue_entry *entry)
 {
@@ -190,7 +163,6 @@ static int nf_ip_route(struct net *net, struct dst_entry **dst,
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
 	.route			= nf_ip_route,
-	.saveroute		= nf_ip_saveroute,
 	.reroute		= nf_ip_reroute,
 	.route_key_size		= sizeof(struct ip_rt_info),
 };
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a57546ce54a6..6d1f470660db 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -68,31 +68,6 @@ int ip6_route_me_harder(struct net *net, struct sk_buff *skb)
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
-static void nf_ip6_saveroute(const struct sk_buff *skb,
-			     struct nf_queue_entry *entry)
-{
-	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
-
-	if (entry->state.hook == NF_INET_LOCAL_OUT) {
-		const struct ipv6hdr *iph = ipv6_hdr(skb);
-
-		rt_info->daddr = iph->daddr;
-		rt_info->saddr = iph->saddr;
-		rt_info->mark = skb->mark;
-	}
-}
-
 static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
 			  const struct nf_queue_entry *entry)
 {
@@ -200,7 +175,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
 	.route			= nf_ip6_route,
-	.saveroute		= nf_ip6_saveroute,
 	.reroute		= nf_ip6_reroute,
 	.route_key_size		= sizeof(struct ip6_rt_info),
 };
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 0c02fdb7efc9..dfa35bd292c8 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -10,6 +10,8 @@
 #include <linux/proc_fs.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
@@ -108,6 +110,35 @@ void nf_queue_nf_hook_drop(struct net *net)
 }
 EXPORT_SYMBOL_GPL(nf_queue_nf_hook_drop);
 
+static void nf_ip_saveroute(const struct sk_buff *skb,
+			    struct nf_queue_entry *entry)
+{
+	struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
+
+	if (entry->state.hook == NF_INET_LOCAL_OUT) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		rt_info->tos = iph->tos;
+		rt_info->daddr = iph->daddr;
+		rt_info->saddr = iph->saddr;
+		rt_info->mark = skb->mark;
+	}
+}
+
+static void nf_ip6_saveroute(const struct sk_buff *skb,
+			     struct nf_queue_entry *entry)
+{
+	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
+
+	if (entry->state.hook == NF_INET_LOCAL_OUT) {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
+		rt_info->daddr = iph->daddr;
+		rt_info->saddr = iph->saddr;
+		rt_info->mark = skb->mark;
+	}
+}
+
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		      const struct nf_hook_entries *entries,
 		      unsigned int index, unsigned int queuenum)
@@ -144,7 +175,16 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 	nf_queue_entry_get_refs(entry);
 	skb_dst_force(skb);
-	afinfo->saveroute(skb, entry);
+
+	switch (entry->state.pf) {
+	case AF_INET:
+		nf_ip_saveroute(skb, entry);
+		break;
+	case AF_INET6:
+		nf_ip6_saveroute(skb, entry);
+		break;
+	}
+
 	status = qh->outfn(entry, queuenum);
 
 	if (status < 0) {
-- 
2.11.0

