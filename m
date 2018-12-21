From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/37] netfilter: nat: remove l4proto->nlattr_to_range
Date: Fri, 21 Dec 2018 01:28:24 +0100
Message-ID: <20181221002841.28587-21-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

all protocols did set this to nf_nat_l4proto_nlattr_to_range, so
just call it directly.

The important difference is that we'll now also call it for
protocols that we don't support (i.e., nf_nat_proto_unknown did
not provide .nlattr_to_range).

However, there should be no harm, even icmp provided this callback.
If we don't implement a specific l4nat for this, nothing would make
use of this information, so adding a big switch/case construct listing
all supported l4protocols seems a bit pointless.

This change leaves a single function pointer in the l4proto struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h   |  6 ------
 net/ipv4/netfilter/nf_nat_proto_gre.c    |  3 ---
 net/ipv4/netfilter/nf_nat_proto_icmp.c   |  3 ---
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c |  3 ---
 net/netfilter/Makefile                   |  2 +-
 net/netfilter/nf_nat_core.c              | 22 +++++++++++++------
 net/netfilter/nf_nat_proto_common.c      | 36 --------------------------------
 net/netfilter/nf_nat_proto_dccp.c        |  3 ---
 net/netfilter/nf_nat_proto_sctp.c        |  3 ---
 net/netfilter/nf_nat_proto_tcp.c         |  3 ---
 net/netfilter/nf_nat_proto_udp.c         |  6 ------
 11 files changed, 17 insertions(+), 73 deletions(-)
 delete mode 100644 net/netfilter/nf_nat_proto_common.c

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index ebf7cbf605cb..406f7effeb8e 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -20,9 +20,6 @@ struct nf_nat_l4proto {
 			  unsigned int iphdroff, unsigned int hdroff,
 			  const struct nf_conntrack_tuple *tuple,
 			  enum nf_nat_manip_type maniptype);
-
-	int (*nlattr_to_range)(struct nlattr *tb[],
-			       struct nf_nat_range2 *range);
 };
 
 /* Protocol registration. */
@@ -48,7 +45,4 @@ extern const struct nf_nat_l4proto nf_nat_l4proto_sctp;
 extern const struct nf_nat_l4proto nf_nat_l4proto_udplite;
 #endif
 
-int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
-				   struct nf_nat_range2 *range);
-
 #endif /*_NF_NAT_L4PROTO_H*/
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 94b735dd570d..86af36651edd 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -80,9 +80,6 @@ gre_manip_pkt(struct sk_buff *skb,
 static const struct nf_nat_l4proto gre = {
 	.l4proto		= IPPROTO_GRE,
 	.manip_pkt		= gre_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
 
 static int __init nf_nat_proto_gre_init(void)
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index f532e2215970..4fecb3f2c55a 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -39,7 +39,4 @@ icmp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_icmp = {
 	.l4proto		= IPPROTO_ICMP,
 	.manip_pkt		= icmp_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
index ffae55c1fb8d..14717c226cec 100644
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
@@ -47,7 +47,4 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_icmpv6 = {
 	.l4proto		= IPPROTO_ICMPV6,
 	.manip_pkt		= icmpv6_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4ddf3ef51ece..852e47cd769b 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
-nf_nat-y	:= nf_nat_core.o nf_nat_proto_unknown.o nf_nat_proto_common.o \
+nf_nat-y	:= nf_nat_core.o nf_nat_proto_unknown.o \
 		   nf_nat_proto_udp.o nf_nat_proto_tcp.o nf_nat_helper.o
 
 # NAT protocols (nf_nat)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d0351e0f21ad..2d7fac80341b 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -946,12 +946,26 @@ static const struct nla_policy protonat_nla_policy[CTA_PROTONAT_MAX+1] = {
 	[CTA_PROTONAT_PORT_MAX]	= { .type = NLA_U16 },
 };
 
+static int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
+					  struct nf_nat_range2 *range)
+{
+	if (tb[CTA_PROTONAT_PORT_MIN]) {
+		range->min_proto.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
+		range->max_proto.all = range->min_proto.all;
+		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+	if (tb[CTA_PROTONAT_PORT_MAX]) {
+		range->max_proto.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MAX]);
+		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+	}
+	return 0;
+}
+
 static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 				     const struct nf_conn *ct,
 				     struct nf_nat_range2 *range)
 {
 	struct nlattr *tb[CTA_PROTONAT_MAX+1];
-	const struct nf_nat_l4proto *l4proto;
 	int err;
 
 	err = nla_parse_nested(tb, CTA_PROTONAT_MAX, attr,
@@ -959,11 +973,7 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 	if (err < 0)
 		return err;
 
-	l4proto = __nf_nat_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	if (l4proto->nlattr_to_range)
-		err = l4proto->nlattr_to_range(tb, range);
-
-	return err;
+	return nf_nat_l4proto_nlattr_to_range(tb, range);
 }
 
 static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
deleted file mode 100644
index a155cfa1cc13..000000000000
--- a/net/netfilter/nf_nat_proto_common.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2008 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/random.h>
-#include <linux/netfilter.h>
-#include <linux/export.h>
-
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-int nf_nat_l4proto_nlattr_to_range(struct nlattr *tb[],
-				   struct nf_nat_range2 *range)
-{
-	if (tb[CTA_PROTONAT_PORT_MIN]) {
-		range->min_proto.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
-		range->max_proto.all = range->min_proto.all;
-		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-	}
-	if (tb[CTA_PROTONAT_PORT_MAX]) {
-		range->max_proto.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MAX]);
-		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_nat_l4proto_nlattr_to_range);
-#endif
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
index a5ed1e3e4f22..ab0b1384717d 100644
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ b/net/netfilter/nf_nat_proto_dccp.c
@@ -61,7 +61,4 @@ dccp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_dccp = {
 	.l4proto		= IPPROTO_DCCP,
 	.manip_pkt		= dccp_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index ff5f5bbd2ff1..37a9d347a029 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -56,7 +56,4 @@ sctp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_sctp = {
 	.l4proto		= IPPROTO_SCTP,
 	.manip_pkt		= sctp_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
index c938ecf7e0b0..d378b6c31d34 100644
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ b/net/netfilter/nf_nat_proto_tcp.c
@@ -64,7 +64,4 @@ tcp_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_tcp = {
 	.l4proto		= IPPROTO_TCP,
 	.manip_pkt		= tcp_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
diff --git a/net/netfilter/nf_nat_proto_udp.c b/net/netfilter/nf_nat_proto_udp.c
index 6703eb005c67..25fc6138fbf7 100644
--- a/net/netfilter/nf_nat_proto_udp.c
+++ b/net/netfilter/nf_nat_proto_udp.c
@@ -85,16 +85,10 @@ static bool udplite_manip_pkt(struct sk_buff *skb,
 const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
 	.l4proto		= IPPROTO_UDPLITE,
 	.manip_pkt		= udplite_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
 #endif /* CONFIG_NF_NAT_PROTO_UDPLITE */
 
 const struct nf_nat_l4proto nf_nat_l4proto_udp = {
 	.l4proto		= IPPROTO_UDP,
 	.manip_pkt		= udp_manip_pkt,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_l4proto_nlattr_to_range,
-#endif
 };
-- 
2.11.0
