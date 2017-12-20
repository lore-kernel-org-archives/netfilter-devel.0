From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v3 1/7] netfilter: move checksum indirection to struct nf_ipv6_ops
Date: Thu, 21 Dec 2017 00:12:43 +0100
Message-ID: <20171220231249.10599-2-pablo@netfilter.org>
References: <20171220231249.10599-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755846AbdLTXM7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 18:12:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 222A5EBACC
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EB2434D2
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0CFE34D2
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:55 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C80CF4265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 00:12:55 +0100 (CET)
In-Reply-To: <20171220231249.10599-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We cannot make a direct call to nf_ip6_checksum() because that would
result in autoloading the 'ipv6' module because of symbol dependencies.
Therefore, define checksum indirection in nf_ipv6_ops where this really
belongs to.

For IPv4, we can indeed make a direct function call, which is faster,
given IPv4 is built-in in the networking code by default.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h               | 19 +++----------------
 include/linux/netfilter_ipv6.h          |  2 ++
 net/bridge/netfilter/nf_tables_bridge.c |  7 -------
 net/ipv4/netfilter.c                    |  1 -
 net/ipv6/netfilter.c                    |  4 ++--
 net/netfilter/Makefile                  |  2 +-
 net/netfilter/utils.c                   | 26 ++++++++++++++++++++++++++
 7 files changed, 34 insertions(+), 27 deletions(-)
 create mode 100644 net/netfilter/utils.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 85a0b0d599e6..4c4d38ef1a76 100644
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
index 47c6b04c28c0..b136101b5cde 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -19,6 +19,8 @@ struct nf_ipv6_ops {
 	void (*route_input)(struct sk_buff *skb);
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
 			int (*output)(struct net *, struct sock *, struct sk_buff *));
+	__sum16 (*checksum)(struct sk_buff *skb, unsigned int hook,
+			    unsigned int dataoff, u_int8_t protocol);
 };
 
 #ifdef CONFIG_NETFILTER
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
index 39970e212ad5..db69c8af95aa 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -192,12 +192,12 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
 static const struct nf_ipv6_ops ipv6ops = {
 	.chk_addr	= ipv6_chk_addr,
 	.route_input    = ip6_route_input,
-	.fragment	= ip6_fragment
+	.fragment	= ip6_fragment,
+	.checksum	= nf_ip6_checksum,
 };
 
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
index 000000000000..159a9cdcfe1e
--- /dev/null
+++ b/net/netfilter/utils.c
@@ -0,0 +1,26 @@
+#include <linux/kernel.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+
+__sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
+		    unsigned int dataoff, u_int8_t protocol,
+		    unsigned short family)
+{
+	const struct nf_ipv6_ops *v6ops;
+	__sum16 csum = 0;
+
+	switch (family) {
+	case AF_INET:
+		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
+		break;
+	case AF_INET6:
+		v6ops = rcu_dereference(nf_ipv6_ops);
+		if (v6ops)
+			csum = v6ops->checksum(skb, hook, dataoff, protocol);
+		break;
+	}
+
+	return csum;
+}
+EXPORT_SYMBOL_GPL(nf_checksum);
-- 
2.11.0

