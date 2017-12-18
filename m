From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v2 1/7] netfilter: remove checksum indirection in struct nf_afinfo
Date: Tue, 19 Dec 2017 00:46:52 +0100
Message-ID: <20171218234658.5004-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933814AbdLRXrG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 18:47:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5219FFB441
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 403F934D5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A95E34D5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:03 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F28434265A30
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 00:47:02 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simplify this infrastructure by replacing it by direction call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove .checksum from nf_tables_bridge. Reported by kbuild robot.

 include/linux/netfilter.h               | 19 +++----------------
 include/linux/netfilter_ipv6.h          | 13 +++++++++++--
 net/bridge/netfilter/nf_tables_bridge.c |  7 -------
 net/ipv4/netfilter.c                    |  1 -
 net/ipv6/netfilter.c                    |  1 -
 net/netfilter/Makefile                  |  2 +-
 net/netfilter/utils.c                   | 23 +++++++++++++++++++++++
 7 files changed, 38 insertions(+), 28 deletions(-)
 create mode 100644 net/netfilter/utils.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index fcb391a0fbd9..3ae4cfb92b54 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -311,8 +311,6 @@ struct nf_queue_entry;
 
 struct nf_afinfo {
 	unsigned short	family;
-	__sum16		(*checksum)(struct sk_buff *skb, unsigned int hook,
-				    unsigned int dataoff, u_int8_t protocol);
 	__sum16		(*checksum_partial)(struct sk_buff *skb,
 					    unsigned int hook,
 					    unsigned int dataoff,
@@ -333,20 +331,9 @@ static inline const struct nf_afinfo *nf_get_afinfo(unsigned short family)
 	return rcu_dereference(nf_afinfo[family]);
 }
 
-static inline __sum16
-nf_checksum(struct sk_buff *skb, unsigned int hook, unsigned int dataoff,
-	    u_int8_t protocol, unsigned short family)
-{
-	const struct nf_afinfo *afinfo;
-	__sum16 csum = 0;
-
-	rcu_read_lock();
-	afinfo = nf_get_afinfo(family);
-	if (afinfo)
-		csum = afinfo->checksum(skb, hook, dataoff, protocol);
-	rcu_read_unlock();
-	return csum;
-}
+__sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
+		    unsigned int dataoff, u_int8_t protocol,
+		    unsigned short family);
 
 static inline __sum16
 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 47c6b04c28c0..ea8c99e5112a 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -21,10 +21,19 @@ struct nf_ipv6_ops {
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
 };
 
-#ifdef CONFIG_NETFILTER
-int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
+#if defined(CONFIG_IPV6)
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
+#else
+static inline __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
+				      unsigned int dataoff, u_int8_t protocol)
+{
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_NETFILTER
+int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
 
 int ipv6_netfilter_init(void);
 void ipv6_netfilter_fini(void);
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 74260ffec74d..b850c17f02f5 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -106,12 +106,6 @@ static int nf_br_reroute(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
-static __sum16 nf_br_checksum(struct sk_buff *skb, unsigned int hook,
-			      unsigned int dataoff, u_int8_t protocol)
-{
-	return 0;
-}
-
 static __sum16 nf_br_checksum_partial(struct sk_buff *skb, unsigned int hook,
 				      unsigned int dataoff, unsigned int len,
 				      u_int8_t protocol)
@@ -127,7 +121,6 @@ static int nf_br_route(struct net *net, struct dst_entry **dst,
 
 static const struct nf_afinfo nf_br_afinfo = {
 	.family                 = AF_BRIDGE,
-	.checksum               = nf_br_checksum,
 	.checksum_partial       = nf_br_checksum_partial,
 	.route                  = nf_br_route,
 	.saveroute              = nf_br_saveroute,
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index c0cc6aa8cfaa..2f7ffefd2732 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -188,7 +188,6 @@ static int nf_ip_route(struct net *net, struct dst_entry **dst,
 
 static const struct nf_afinfo nf_ip_afinfo = {
 	.family			= AF_INET,
-	.checksum		= nf_ip_checksum,
 	.checksum_partial	= nf_ip_checksum_partial,
 	.route			= nf_ip_route,
 	.saveroute		= nf_ip_saveroute,
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 39970e212ad5..a24810ecc432 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -197,7 +197,6 @@ static const struct nf_ipv6_ops ipv6ops = {
 
 static const struct nf_afinfo nf_ip6_afinfo = {
 	.family			= AF_INET6,
-	.checksum		= nf_ip6_checksum,
 	.checksum_partial	= nf_ip6_checksum_partial,
 	.route			= nf_ip6_route,
 	.saveroute		= nf_ip6_saveroute,
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 490a55e7166d..eec0c3b72926 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
+netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
 
 nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
new file mode 100644
index 000000000000..92a51e507fab
--- /dev/null
+++ b/net/netfilter/utils.c
@@ -0,0 +1,23 @@
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+
+__sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
+		    unsigned int dataoff, u_int8_t protocol,
+		    unsigned short family)
+{
+	__sum16 csum = 0;
+
+	switch (family) {
+	case AF_INET:
+		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
+		break;
+	case AF_INET6:
+		csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
+		break;
+	}
+
+	return csum;
+}
+EXPORT_SYMBOL_GPL(nf_checksum);
-- 
2.11.0

