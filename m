From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 3/7] netfilter: remove saveroute indirection in struct nf_afinfo
Date: Tue, 19 Dec 2017 00:46:54 +0100
Message-ID: <20171218234658.5004-3-pablo@netfilter.org>
References: <20171218234658.5004-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965039AbdLRXrI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 18:47:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BD7CFB443
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0ACB734D2
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C58A534D2
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:04 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AEA174265A30
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:04 +0100 (CET)
In-Reply-To: <20171218234658.5004-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is only used by nf_queue.c, and there we can replace it by a direct
function call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix warning: 'struct nf_queue_entry' declared inside parameter list
    remove .saveroute from nf_tables_bridge. Reported by kbuild robot.

 include/linux/netfilter.h               |  3 +--
 include/linux/netfilter_ipv4.h          |  3 +++
 include/linux/netfilter_ipv6.h          |  5 +++++
 net/bridge/netfilter/nf_tables_bridge.c |  6 ------
 net/ipv4/netfilter.c                    |  4 +---
 net/ipv6/netfilter.c                    |  5 ++---
 net/netfilter/nf_queue.c                |  2 +-
 net/netfilter/utils.c                   | 13 +++++++++++++
 8 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index a2bb6fefde13..b3a46a374a89 100644
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
@@ -332,6 +330,7 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			    unsigned int dataoff, unsigned int len,
 			    u_int8_t protocol, unsigned short family);
+void nf_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 
 int nf_register_afinfo(const struct nf_afinfo *afinfo);
 void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 6d61ec0a7695..f47e657f32ef 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -6,10 +6,13 @@
 
 #include <uapi/linux/netfilter_ipv4.h>
 
+struct nf_queue_entry;
+
 int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
 __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 		       unsigned int dataoff, u_int8_t protocol);
 __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
 			       unsigned int dataoff, unsigned int len,
 			       u_int8_t protocol);
+void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 729cc76cb3db..d359ee1f3e37 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -21,12 +21,15 @@ struct nf_ipv6_ops {
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
 };
 
+struct nf_queue_entry;
+
 #if defined(CONFIG_IPV6)
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 				unsigned int dataoff, unsigned int len,
 				u_int8_t protocol);
+void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry);
 #else
 static inline __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 				      unsigned int dataoff, u_int8_t protocol)
@@ -41,6 +44,8 @@ static inline__sum16 nf_ip6_checksum_partial(struct sk_buff *skb,
 {
 	return 0;
 }
+static inline void nf_ip6_saveroute(const struct sk_buff *skb,
+				    struct nf_queue_entry *entry) {}
 #endif
 
 #ifdef CONFIG_NETFILTER
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
index 050b614662f8..dc2021aaf885 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -92,8 +92,7 @@ struct ip_rt_info {
 	u_int32_t mark;
 };
 
-static void nf_ip_saveroute(const struct sk_buff *skb,
-			    struct nf_queue_entry *entry)
+void nf_ip_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 {
 	struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
@@ -189,7 +188,6 @@ static int nf_ip_route(struct net *net, struct dst_entry **dst,
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
 	.route			= nf_ip_route,
-	.saveroute		= nf_ip_saveroute,
 	.reroute		= nf_ip_reroute,
 	.route_key_size		= sizeof(struct ip_rt_info),
 };
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 6e39b721136e..4894f030511e 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -79,8 +79,7 @@ struct ip6_rt_info {
 	u_int32_t mark;
 };
 
-static void nf_ip6_saveroute(const struct sk_buff *skb,
-			     struct nf_queue_entry *entry)
+void nf_ip6_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
 {
 	struct ip6_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
@@ -92,6 +91,7 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 		rt_info->mark = skb->mark;
 	}
 }
+EXPORT_SYMBOL_GPL(nf_ip6_saveroute);
 
 static int nf_ip6_reroute(struct net *net, struct sk_buff *skb,
 			  const struct nf_queue_entry *entry)
@@ -198,7 +198,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
 	.route			= nf_ip6_route,
-	.saveroute		= nf_ip6_saveroute,
 	.reroute		= nf_ip6_reroute,
 	.route_key_size		= sizeof(struct ip6_rt_info),
 };
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 0c02fdb7efc9..833710ee7654 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -144,7 +144,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 	nf_queue_entry_get_refs(entry);
 	skb_dst_force(skb);
-	afinfo->saveroute(skb, entry);
+	nf_saveroute(skb, entry);
 	status = qh->outfn(entry, queuenum);
 
 	if (status < 0) {
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 3fdad0c7b189..7d8c0fd283ee 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -2,6 +2,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
+#include <net/netfilter/nf_queue.h>
 
 __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 		    unsigned int dataoff, u_int8_t protocol,
@@ -42,3 +43,15 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	return csum;
 }
 EXPORT_SYMBOL_GPL(nf_checksum_partial);
+
+void nf_saveroute(const struct sk_buff *skb, struct nf_queue_entry *entry)
+{
+	switch (entry->state.pf) {
+	case AF_INET:
+		nf_ip_saveroute(skb, entry);
+		break;
+	case AF_INET6:
+		nf_ip6_saveroute(skb, entry);
+		break;
+	}
+}
-- 
2.11.0

