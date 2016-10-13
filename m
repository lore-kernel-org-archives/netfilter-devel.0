From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: use new range expression for != [a,b] intervals
Date: Thu, 13 Oct 2016 10:34:12 +0200
Message-ID: <1476347652-27762-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbcJMIed (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 04:34:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B4D5325D26
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 10:34:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 833CADA842
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 10:34:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D108DA841
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 10:34:21 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use new range expression in the kernel to fix wrong bytecode generation.
This patch also adjust tests so we don't hit problems there.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h    | 29 +++++++++++++++++++++
 src/netlink_delinearize.c              | 45 +++++++++++++++++++++++++++++++++
 src/netlink_linearize.c                | 46 ++++++++++++++++------------------
 tests/py/any/ct.t.payload              |  6 ++---
 tests/py/any/meta.t.payload            | 21 ++++++----------
 tests/py/arp/arp.t.payload             |  9 +++----
 tests/py/arp/arp.t.payload.netdev      |  9 +++----
 tests/py/inet/ah.t.payload.inet        | 12 +++------
 tests/py/inet/ah.t.payload.ip          | 12 +++------
 tests/py/inet/ah.t.payload.ip6         | 12 +++------
 tests/py/inet/ah.t.payload.netdev      | 12 +++------
 tests/py/inet/comp.t.payload.inet      |  6 ++---
 tests/py/inet/comp.t.payload.ip        |  6 ++---
 tests/py/inet/comp.t.payload.ip6       |  6 ++---
 tests/py/inet/comp.t.payload.netdev    |  6 ++---
 tests/py/inet/dccp.t.payload.inet      |  3 +--
 tests/py/inet/dccp.t.payload.ip        |  3 +--
 tests/py/inet/dccp.t.payload.ip6       |  3 +--
 tests/py/inet/dccp.t.payload.netdev    |  3 +--
 tests/py/inet/esp.t.payload.inet       |  6 ++---
 tests/py/inet/esp.t.payload.ip         |  6 ++---
 tests/py/inet/esp.t.payload.ip6        |  6 ++---
 tests/py/inet/esp.t.payload.netdev     |  6 ++---
 tests/py/inet/sctp.t.payload.inet      | 12 +++------
 tests/py/inet/sctp.t.payload.ip        | 12 +++------
 tests/py/inet/sctp.t.payload.ip6       | 12 +++------
 tests/py/inet/sctp.t.payload.netdev    | 12 +++------
 tests/py/inet/tcp.t.payload.inet       | 21 ++++++----------
 tests/py/inet/tcp.t.payload.ip         | 21 ++++++----------
 tests/py/inet/tcp.t.payload.ip6        | 21 ++++++----------
 tests/py/inet/tcp.t.payload.netdev     | 21 ++++++----------
 tests/py/inet/udp.t.payload.inet       | 12 +++------
 tests/py/inet/udp.t.payload.ip         | 12 +++------
 tests/py/inet/udp.t.payload.ip6        | 12 +++------
 tests/py/inet/udp.t.payload.netdev     | 12 +++------
 tests/py/inet/udplite.t.payload.inet   |  9 +++----
 tests/py/inet/udplite.t.payload.ip     |  9 +++----
 tests/py/inet/udplite.t.payload.ip6    |  9 +++----
 tests/py/inet/udplite.t.payload.netdev |  9 +++----
 tests/py/ip/dnat.t.payload.ip          |  6 ++---
 tests/py/ip/icmp.t.payload.ip          | 18 +++++--------
 tests/py/ip/ip.t.payload               | 24 ++++++------------
 tests/py/ip/ip.t.payload.inet          | 24 ++++++------------
 tests/py/ip/ip.t.payload.netdev        | 24 ++++++------------
 tests/py/ip/snat.t.payload             |  6 ++---
 tests/py/ip6/dst.t.payload.inet        |  6 ++---
 tests/py/ip6/dst.t.payload.ip6         |  6 ++---
 tests/py/ip6/frag.t.payload.inet       |  9 +++----
 tests/py/ip6/frag.t.payload.ip6        |  9 +++----
 tests/py/ip6/hbh.t.payload.inet        |  6 ++---
 tests/py/ip6/hbh.t.payload.ip6         |  6 ++---
 tests/py/ip6/icmpv6.t.payload.ip6      |  9 +++----
 tests/py/ip6/ip6.t.payload.inet        | 12 +++------
 tests/py/ip6/ip6.t.payload.ip6         | 12 +++------
 tests/py/ip6/mh.t.payload.inet         | 12 +++------
 tests/py/ip6/mh.t.payload.ip6          | 12 +++------
 tests/py/ip6/rt.t.payload.inet         | 12 +++------
 tests/py/ip6/rt.t.payload.ip6          | 12 +++------
 58 files changed, 293 insertions(+), 421 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1bec149b2200..b21a844cf5d5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -546,6 +546,35 @@ enum nft_cmp_attributes {
 };
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
+/**
+ * enum nft_range_ops - nf_tables range operator
+ *
+ * @NFT_RANGE_EQ: equal
+ * @NFT_RANGE_NEQ: not equal
+ */
+enum nft_range_ops {
+	NFT_RANGE_EQ,
+	NFT_RANGE_NEQ,
+};
+
+/**
+ * enum nft_range_attributes - nf_tables range expression netlink attributes
+ *
+ * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_registers)
+ * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
+ * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes)
+ * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
+ */
+enum nft_range_attributes {
+	NFTA_RANGE_UNSPEC,
+	NFTA_RANGE_SREG,
+	NFTA_RANGE_OP,
+	NFTA_RANGE_FROM_DATA,
+	NFTA_RANGE_TO_DATA,
+	__NFTA_RANGE_MAX
+};
+#define NFTA_RANGE_MAX         (__NFTA_RANGE_MAX - 1)
+
 enum nft_lookup_flags {
 	NFT_LOOKUP_F_INV = (1 << 0),
 };
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6bb27b6fa2c8..d8d1d7d7aaa7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -186,6 +186,46 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 		netlink_set_register(ctx, dreg, expr);
 }
 
+static enum ops netlink_parse_range_op(const struct nftnl_expr *nle)
+{
+	switch (nftnl_expr_get_u32(nle, NFTNL_EXPR_RANGE_OP)) {
+	case NFT_RANGE_EQ:
+		return OP_EQ;
+	case NFT_RANGE_NEQ:
+		return OP_NEQ;
+	default:
+		return OP_INVALID;
+	}
+}
+
+static void netlink_parse_range(struct netlink_parse_ctx *ctx,
+				const struct location *loc,
+				const struct nftnl_expr *nle)
+{
+	struct expr *expr, *left, *right, *from, *to;
+	struct nft_data_delinearize nld;
+	enum nft_registers sreg;
+	enum ops op;
+
+	sreg = netlink_parse_register(nle, NFTNL_EXPR_RANGE_SREG);
+	left = netlink_get_register(ctx, loc, sreg);
+	if (left == NULL)
+		return netlink_error(ctx, loc,
+				     "Relational expression has no left hand side");
+
+	op = netlink_parse_range_op(nle);
+
+	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_RANGE_FROM_DATA, &nld.len);
+	from = netlink_alloc_value(loc, &nld);
+
+	nld.value = nftnl_expr_get(nle, NFTNL_EXPR_RANGE_TO_DATA, &nld.len);
+	to = netlink_alloc_value(loc, &nld);
+
+	right = range_expr_alloc(loc, from, to);
+	expr = relational_expr_alloc(loc, op, left, right);
+	ctx->stmt = expr_stmt_alloc(loc, expr);
+}
+
 static enum ops netlink_parse_cmp_op(const struct nftnl_expr *nle)
 {
 	switch (nftnl_expr_get_u32(nle, NFTNL_EXPR_CMP_OP)) {
@@ -1049,6 +1089,7 @@ static const struct {
 	{ .name = "counter",	.parse = netlink_parse_counter },
 	{ .name = "log",	.parse = netlink_parse_log },
 	{ .name = "limit",	.parse = netlink_parse_limit },
+	{ .name = "range",	.parse = netlink_parse_range },
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
 	{ .name = "masq",	.parse = netlink_parse_masq },
@@ -1363,6 +1404,10 @@ static void __binop_adjust(const struct expr *binop, struct expr *right,
 			}
 		}
 		break;
+	case EXPR_RANGE:
+		binop_adjust_one(binop, right->left, shift);
+		binop_adjust_one(binop, right->right, shift);
+		break;
 	default:
 		BUG("unknown expression type %s\n", right->ops->name);
 		break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 558deb23133c..0072dca091ea 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -368,45 +368,41 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	sreg = get_register(ctx, expr->left);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
-	nle = alloc_nft_expr("cmp");
-	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 	switch (expr->op) {
 	case OP_NEQ:
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				   netlink_gen_cmp_op(OP_LT));
+		nle = alloc_nft_expr("range");
+		netlink_put_register(nle, NFTNL_EXPR_RANGE_SREG, sreg);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_RANGE_OP, NFT_RANGE_NEQ);
+		netlink_gen_data(range->left, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_RANGE_FROM_DATA,
+			       nld.value, nld.len);
+		netlink_gen_data(range->right, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_RANGE_TO_DATA,
+			       nld.value, nld.len);
+		nftnl_rule_add_expr(ctx->nlr, nle);
 		break;
 	case OP_RANGE:
 	case OP_EQ:
+		nle = alloc_nft_expr("cmp");
+		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 				   netlink_gen_cmp_op(OP_GTE));
-		break;
-	default:
-		BUG("invalid range operation %u\n", expr->op);
-	}
-
-	netlink_gen_data(range->left, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+		netlink_gen_data(range->left, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
+		nftnl_rule_add_expr(ctx->nlr, nle);
 
-	nle = alloc_nft_expr("cmp");
-	netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
-	switch (expr->op) {
-	case OP_NEQ:
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				   netlink_gen_cmp_op(OP_GT));
-		break;
-	case OP_RANGE:
-	case OP_EQ:
+		nle = alloc_nft_expr("cmp");
+		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
 				   netlink_gen_cmp_op(OP_LTE));
+		netlink_gen_data(range->right, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
+		nftnl_rule_add_expr(ctx->nlr, nle);
 		break;
 	default:
 		BUG("invalid range operation %u\n", expr->op);
-	}
 
-	netlink_gen_data(range->right, &nld);
-	nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-	nftnl_rule_add_expr(ctx->nlr, nle);
+	}
 
 	release_register(ctx, expr->left);
 }
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 97f292ea2359..746b75e3f4d0 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -155,8 +155,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0x32000000 ]
-  [ cmp gt reg 1 0x45000000 ]
+  [ range neq reg 1 0x32000000 0x45000000 ]
 
 # ct mark {0x32, 0x2222, 0x42de3}
 __set%d test-ip4 3
@@ -221,8 +220,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0xe8800000 ]
-  [ cmp gt reg 1 0xc8af0000 ]
+  [ range neq reg 1 0xe8800000 0xc8af0000 ]
 
 # ct expiration {33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 5fff76e21e25..65d1cd42ec8c 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -24,8 +24,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # meta length { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -119,8 +118,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 2, 1) ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # meta l4proto { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -379,8 +377,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0xd1070000 ]
-  [ cmp gt reg 1 0xd5070000 ]
+  [ range neq reg 1 0xd1070000 0xd5070000 ]
   [ immediate reg 0 accept ]
 
 # meta skuid { 2001-2005} accept
@@ -444,8 +441,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0xd1070000 ]
-  [ cmp gt reg 1 0xd5070000 ]
+  [ range neq reg 1 0xd1070000 0xd5070000 ]
   [ immediate reg 0 accept ]
 
 # meta skgid { 2001-2005} accept
@@ -589,8 +585,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0x01000000 ]
-  [ cmp gt reg 1 0x02000000 ]
+  [ range neq reg 1 0x01000000 0x02000000 ]
 
 # meta cpu { 2,3}
 __set%d test-ip4 3
@@ -728,8 +723,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0x01001000 ]
-  [ cmp gt reg 1 0x02001000 ]
+  [ range neq reg 1 0x01001000 0x02001000 ]
 
 # meta cgroup {1048577-1048578}
 __set%d test-ip4 7
@@ -825,8 +819,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp lt reg 1 0xdadaadbc ]
-  [ cmp gt reg 1 0xdcdaadbc ]
+  [ range neq reg 1 0xdadaadbc 0xdcdaadbc ]
 
 # meta priority {bcad:dada, bcad:dadc, aaaa:bbbb}
 __set%d test-ip4 3
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index 31c3024a4bc7..5b8f8d5613b7 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -27,8 +27,7 @@ arp test-arp input
 # arp htype != 33-45
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # arp htype { 33, 55, 67, 88}
 __set%d test-arp 3
@@ -70,8 +69,7 @@ arp test-arp input
 # arp hlen != 33-45
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # arp hlen { 33, 55, 67, 88}
 __set%d test-arp 3
@@ -108,8 +106,7 @@ arp test-arp input
 # arp plen != 33-45
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # arp plen { 33, 55, 67, 88}
 __set%d test-arp 3
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index a64ebea1d2c1..5188ed709faa 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -39,8 +39,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # arp htype { 33, 55, 67, 88}
 __set%d test-netdev 3
@@ -96,8 +95,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # arp hlen { 33, 55, 67, 88}
 __set%d test-netdev 3
@@ -146,8 +144,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # arp plen { 33, 55, 67, 88}
 __set%d test-netdev 3
diff --git a/tests/py/inet/ah.t.payload.inet b/tests/py/inet/ah.t.payload.inet
index 739386a3bcd3..1e56797f59f5 100644
--- a/tests/py/inet/ah.t.payload.inet
+++ b/tests/py/inet/ah.t.payload.inet
@@ -11,8 +11,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x0000000b ]
-  [ cmp gt reg 1 0x00000017 ]
+  [ range neq reg 1 0x0000000b 0x00000017 ]
 
 # ah hdrlength { 11-23}
 __set%d test-inet 7
@@ -61,8 +60,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ah reserved {23, 100}
 __set%d test-inet 3
@@ -111,8 +109,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # ah spi {111, 122}
 __set%d test-inet 3
@@ -181,6 +178,5 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x17000000 ]
-  [ cmp gt reg 1 0x21000000 ]
+  [ range neq reg 1 0x17000000 0x21000000 ]
 
diff --git a/tests/py/inet/ah.t.payload.ip b/tests/py/inet/ah.t.payload.ip
index b9899488c896..5ad0041cddd8 100644
--- a/tests/py/inet/ah.t.payload.ip
+++ b/tests/py/inet/ah.t.payload.ip
@@ -11,8 +11,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x0000000b ]
-  [ cmp gt reg 1 0x00000017 ]
+  [ range neq reg 1 0x0000000b 0x00000017 ]
 
 # ah hdrlength { 11-23}
 __set%d test-ip4 7
@@ -61,8 +60,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ah reserved {23, 100}
 __set%d test-ip4 3
@@ -111,8 +109,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # ah spi {111, 122}
 __set%d test-ip4 3
@@ -181,6 +178,5 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x17000000 ]
-  [ cmp gt reg 1 0x21000000 ]
+  [ range neq reg 1 0x17000000 0x21000000 ]
 
diff --git a/tests/py/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
index 95eae6659ed4..c57a28a84ea3 100644
--- a/tests/py/inet/ah.t.payload.ip6
+++ b/tests/py/inet/ah.t.payload.ip6
@@ -11,8 +11,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x0000000b ]
-  [ cmp gt reg 1 0x00000017 ]
+  [ range neq reg 1 0x0000000b 0x00000017 ]
 
 # ah hdrlength { 11-23}
 __set%d test-ip6 7
@@ -61,8 +60,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ah reserved {23, 100}
 __set%d test-ip6 3
@@ -111,8 +109,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # ah spi {111, 122}
 __set%d test-ip6 3
@@ -181,6 +178,5 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x17000000 ]
-  [ cmp gt reg 1 0x21000000 ]
+  [ range neq reg 1 0x17000000 0x21000000 ]
 
diff --git a/tests/py/inet/ah.t.payload.netdev b/tests/py/inet/ah.t.payload.netdev
index 55eea13689b1..e06811d260e8 100644
--- a/tests/py/inet/ah.t.payload.netdev
+++ b/tests/py/inet/ah.t.payload.netdev
@@ -11,8 +11,7 @@ netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x0000000b ]
-  [ cmp gt reg 1 0x00000017 ]
+  [ range neq reg 1 0x0000000b 0x00000017 ]
 
 # ah hdrlength { 11-23}
 __set%d test-netdev 7
@@ -61,8 +60,7 @@ netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ah reserved {23, 100}
 __set%d test-netdev 3
@@ -111,8 +109,7 @@ netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # ah spi {111, 122}
 __set%d test-netdev 3
@@ -181,6 +178,5 @@ netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x17000000 ]
-  [ cmp gt reg 1 0x21000000 ]
+  [ range neq reg 1 0x17000000 0x21000000 ]
 
diff --git a/tests/py/inet/comp.t.payload.inet b/tests/py/inet/comp.t.payload.inet
index eff32b7e32f6..cdeba2bd2950 100644
--- a/tests/py/inet/comp.t.payload.inet
+++ b/tests/py/inet/comp.t.payload.inet
@@ -32,8 +32,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000033 ]
-  [ cmp gt reg 1 0x00000045 ]
+  [ range neq reg 1 0x00000033 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
 __set%d test-inet 3
@@ -82,8 +81,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/comp.t.payload.ip b/tests/py/inet/comp.t.payload.ip
index b2a8ab402a31..9da8f94d2dba 100644
--- a/tests/py/inet/comp.t.payload.ip
+++ b/tests/py/inet/comp.t.payload.ip
@@ -32,8 +32,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000033 ]
-  [ cmp gt reg 1 0x00000045 ]
+  [ range neq reg 1 0x00000033 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
 __set%d test-ip4 3
@@ -82,8 +81,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
index f1799987514a..69a13edebac3 100644
--- a/tests/py/inet/comp.t.payload.ip6
+++ b/tests/py/inet/comp.t.payload.ip6
@@ -32,8 +32,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000033 ]
-  [ cmp gt reg 1 0x00000045 ]
+  [ range neq reg 1 0x00000033 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
 __set%d test-ip6 3
@@ -82,8 +81,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/inet/comp.t.payload.netdev b/tests/py/inet/comp.t.payload.netdev
index eff32b7e32f6..cdeba2bd2950 100644
--- a/tests/py/inet/comp.t.payload.netdev
+++ b/tests/py/inet/comp.t.payload.netdev
@@ -32,8 +32,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000033 ]
-  [ cmp gt reg 1 0x00000045 ]
+  [ range neq reg 1 0x00000033 0x00000045 ]
 
 # comp flags {0x33, 0x55, 0x67, 0x88}
 __set%d test-inet 3
@@ -82,8 +81,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # comp cpi {33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload.inet
index f5aacf6886a8..ccba6d0ec1d3 100644
--- a/tests/py/inet/dccp.t.payload.inet
+++ b/tests/py/inet/dccp.t.payload.inet
@@ -11,8 +11,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001500 ]
-  [ cmp gt reg 1 0x00002300 ]
+  [ range neq reg 1 0x00001500 0x00002300 ]
 
 # dccp sport {23, 24, 25}
 __set%d test-inet 3
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
index bda8dfd47ded..a02247fd0872 100644
--- a/tests/py/inet/dccp.t.payload.ip
+++ b/tests/py/inet/dccp.t.payload.ip
@@ -11,8 +11,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001500 ]
-  [ cmp gt reg 1 0x00002300 ]
+  [ range neq reg 1 0x00001500 0x00002300 ]
 
 # dccp sport {23, 24, 25}
 __set%d test-ip4 3
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
index f78f9830aacf..c81a3a030dc2 100644
--- a/tests/py/inet/dccp.t.payload.ip6
+++ b/tests/py/inet/dccp.t.payload.ip6
@@ -11,8 +11,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001500 ]
-  [ cmp gt reg 1 0x00002300 ]
+  [ range neq reg 1 0x00001500 0x00002300 ]
 
 # dccp sport {23, 24, 25}
 __set%d test-ip4 3
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
index abed6b25fe77..abb1fb9da275 100644
--- a/tests/py/inet/dccp.t.payload.netdev
+++ b/tests/py/inet/dccp.t.payload.netdev
@@ -11,8 +11,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001500 ]
-  [ cmp gt reg 1 0x00002300 ]
+  [ range neq reg 1 0x00001500 0x00002300 ]
 
 # dccp sport {23, 24, 25}
 __set%d test-inet 3
diff --git a/tests/py/inet/esp.t.payload.inet b/tests/py/inet/esp.t.payload.inet
index 5f3a0da9ebfb..d41f76648b97 100644
--- a/tests/py/inet/esp.t.payload.inet
+++ b/tests/py/inet/esp.t.payload.inet
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # esp spi { 100, 102}
 __set%d test-inet 3
@@ -68,8 +67,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x16000000 ]
-  [ cmp gt reg 1 0x18000000 ]
+  [ range neq reg 1 0x16000000 0x18000000 ]
 
 # esp sequence { 22, 24}
 __set%d test-inet 3
diff --git a/tests/py/inet/esp.t.payload.ip b/tests/py/inet/esp.t.payload.ip
index cf526781f05d..5de41aebcb93 100644
--- a/tests/py/inet/esp.t.payload.ip
+++ b/tests/py/inet/esp.t.payload.ip
@@ -25,8 +25,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # esp spi { 100, 102}
 __set%d test-ip4 3
@@ -68,8 +67,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x16000000 ]
-  [ cmp gt reg 1 0x18000000 ]
+  [ range neq reg 1 0x16000000 0x18000000 ]
 
 # esp sequence { 22, 24}
 __set%d test-ip4 3
diff --git a/tests/py/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
index 982412d2af6e..0bc2e70c4767 100644
--- a/tests/py/inet/esp.t.payload.ip6
+++ b/tests/py/inet/esp.t.payload.ip6
@@ -25,8 +25,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # esp spi { 100, 102}
 __set%d test-ip6 3
@@ -68,8 +67,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x16000000 ]
-  [ cmp gt reg 1 0x18000000 ]
+  [ range neq reg 1 0x16000000 0x18000000 ]
 
 # esp sequence { 22, 24}
 __set%d test-ip6 3
diff --git a/tests/py/inet/esp.t.payload.netdev b/tests/py/inet/esp.t.payload.netdev
index 5f3a0da9ebfb..d41f76648b97 100644
--- a/tests/py/inet/esp.t.payload.netdev
+++ b/tests/py/inet/esp.t.payload.netdev
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x6f000000 ]
-  [ cmp gt reg 1 0xde000000 ]
+  [ range neq reg 1 0x6f000000 0xde000000 ]
 
 # esp spi { 100, 102}
 __set%d test-inet 3
@@ -68,8 +67,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x16000000 ]
-  [ cmp gt reg 1 0x18000000 ]
+  [ range neq reg 1 0x16000000 0x18000000 ]
 
 # esp sequence { 22, 24}
 __set%d test-inet 3
diff --git a/tests/py/inet/sctp.t.payload.inet b/tests/py/inet/sctp.t.payload.inet
index 9c68a8cc90c6..bc7fe7ced2b5 100644
--- a/tests/py/inet/sctp.t.payload.inet
+++ b/tests/py/inet/sctp.t.payload.inet
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
 __set%d test-inet 3
@@ -75,8 +74,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
 __set%d test-inet 3
@@ -125,8 +123,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x20000000 ]
-  [ cmp gt reg 1 0x6f000000 ]
+  [ range neq reg 1 0x20000000 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
 __set%d test-inet 3
@@ -175,8 +172,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/sctp.t.payload.ip b/tests/py/inet/sctp.t.payload.ip
index 6e07a4c5a95e..fa6ea4354165 100644
--- a/tests/py/inet/sctp.t.payload.ip
+++ b/tests/py/inet/sctp.t.payload.ip
@@ -25,8 +25,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
 __set%d test-ip4 3
@@ -75,8 +74,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
 __set%d test-ip4 3
@@ -125,8 +123,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x20000000 ]
-  [ cmp gt reg 1 0x6f000000 ]
+  [ range neq reg 1 0x20000000 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
 __set%d test-ip4 3
@@ -175,8 +172,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
index 579609b7360e..5d113692be4c 100644
--- a/tests/py/inet/sctp.t.payload.ip6
+++ b/tests/py/inet/sctp.t.payload.ip6
@@ -25,8 +25,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
 __set%d test-ip6 3
@@ -75,8 +74,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
 __set%d test-ip6 3
@@ -125,8 +123,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x20000000 ]
-  [ cmp gt reg 1 0x6f000000 ]
+  [ range neq reg 1 0x20000000 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
 __set%d test-ip6 3
@@ -175,8 +172,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/inet/sctp.t.payload.netdev b/tests/py/inet/sctp.t.payload.netdev
index 9c68a8cc90c6..bc7fe7ced2b5 100644
--- a/tests/py/inet/sctp.t.payload.netdev
+++ b/tests/py/inet/sctp.t.payload.netdev
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp sport { 23, 24, 25}
 __set%d test-inet 3
@@ -75,8 +74,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002c00 ]
+  [ range neq reg 1 0x00001700 0x00002c00 ]
 
 # sctp dport { 23, 24, 25}
 __set%d test-inet 3
@@ -125,8 +123,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x20000000 ]
-  [ cmp gt reg 1 0x6f000000 ]
+  [ range neq reg 1 0x20000000 0x6f000000 ]
 
 # sctp checksum { 22, 33, 44}
 __set%d test-inet 3
@@ -175,8 +172,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # sctp vtag {33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload.inet
index 9c3fbbf045f9..354d013da884 100644
--- a/tests/py/inet/tcp.t.payload.inet
+++ b/tests/py/inet/tcp.t.payload.inet
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -116,8 +115,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -217,8 +215,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -275,8 +272,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -358,8 +354,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -408,8 +403,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -466,8 +460,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
index 75cbe70cce86..d70a176a3160 100644
--- a/tests/py/inet/tcp.t.payload.ip
+++ b/tests/py/inet/tcp.t.payload.ip
@@ -25,8 +25,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -116,8 +115,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -217,8 +215,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -275,8 +272,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -358,8 +354,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -408,8 +403,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -466,8 +460,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
index f65f9b871b86..4e9c4135e4e6 100644
--- a/tests/py/inet/tcp.t.payload.ip6
+++ b/tests/py/inet/tcp.t.payload.ip6
@@ -25,8 +25,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -116,8 +115,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -217,8 +215,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -275,8 +272,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -358,8 +354,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -408,8 +403,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -466,8 +460,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/inet/tcp.t.payload.netdev b/tests/py/inet/tcp.t.payload.netdev
index a554d07026e3..854f4bbe1f79 100644
--- a/tests/py/inet/tcp.t.payload.netdev
+++ b/tests/py/inet/tcp.t.payload.netdev
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp dport { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -116,8 +115,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp sport { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -217,8 +215,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp sequence { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -275,8 +272,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # tcp ackseq { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -358,8 +354,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp window { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -416,8 +411,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp checksum { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -474,8 +468,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # tcp urgptr { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload.inet
index a2717f39ec08..8fdffbf2573b 100644
--- a/tests/py/inet/udp.t.payload.inet
+++ b/tests/py/inet/udp.t.payload.inet
@@ -28,8 +28,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
@@ -83,8 +82,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
@@ -137,8 +135,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00004100 ]
+  [ range neq reg 1 0x00003200 0x00004100 ]
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
@@ -197,8 +194,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
index 5d36fe5f4d7d..1d41017b343e 100644
--- a/tests/py/inet/udp.t.payload.ip
+++ b/tests/py/inet/udp.t.payload.ip
@@ -28,8 +28,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
@@ -83,8 +82,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
@@ -137,8 +135,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00004100 ]
+  [ range neq reg 1 0x00003200 0x00004100 ]
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
@@ -197,8 +194,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
index 22aa57ff8077..17b6679f6e2d 100644
--- a/tests/py/inet/udp.t.payload.ip6
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -28,8 +28,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
@@ -83,8 +82,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
@@ -137,8 +135,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00004100 ]
+  [ range neq reg 1 0x00003200 0x00004100 ]
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
@@ -197,8 +194,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/inet/udp.t.payload.netdev b/tests/py/inet/udp.t.payload.netdev
index 92858cf0b9a1..9e93ae4c71da 100644
--- a/tests/py/inet/udp.t.payload.netdev
+++ b/tests/py/inet/udp.t.payload.netdev
@@ -28,8 +28,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp sport { 49, 50} drop
@@ -83,8 +82,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udp dport { 49, 50} drop
@@ -137,8 +135,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00004100 ]
+  [ range neq reg 1 0x00003200 0x00004100 ]
   [ immediate reg 0 accept ]
 
 # udp length { 50, 65} accept
@@ -197,8 +194,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udp checksum { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/inet/udplite.t.payload.inet b/tests/py/inet/udplite.t.payload.inet
index 034c62de7d36..ad2c970986ab 100644
--- a/tests/py/inet/udplite.t.payload.inet
+++ b/tests/py/inet/udplite.t.payload.inet
@@ -28,8 +28,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
@@ -83,8 +82,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
@@ -144,8 +142,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/udplite.t.payload.ip b/tests/py/inet/udplite.t.payload.ip
index 3da9e5386a7b..8321c239b8d9 100644
--- a/tests/py/inet/udplite.t.payload.ip
+++ b/tests/py/inet/udplite.t.payload.ip
@@ -28,8 +28,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
@@ -83,8 +82,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
@@ -144,8 +142,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
index 205ea2153853..dce215dd7adb 100644
--- a/tests/py/inet/udplite.t.payload.ip6
+++ b/tests/py/inet/udplite.t.payload.ip6
@@ -28,8 +28,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
@@ -83,8 +82,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
@@ -144,8 +142,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/inet/udplite.t.payload.netdev b/tests/py/inet/udplite.t.payload.netdev
index 034c62de7d36..ad2c970986ab 100644
--- a/tests/py/inet/udplite.t.payload.netdev
+++ b/tests/py/inet/udplite.t.payload.netdev
@@ -28,8 +28,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite sport { 49, 50} drop
@@ -83,8 +82,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00003200 ]
-  [ cmp gt reg 1 0x00003c00 ]
+  [ range neq reg 1 0x00003200 0x00003c00 ]
   [ immediate reg 0 accept ]
 
 # udplite dport { 49, 50} drop
@@ -144,8 +142,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # udplite checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index be382da30115..6caa2c156346 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -17,8 +17,7 @@ ip test-ip4 prerouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00005000 ]
-  [ cmp gt reg 1 0x00005a00 ]
+  [ range neq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
@@ -43,8 +42,7 @@ ip test-ip4 prerouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002200 ]
+  [ range neq reg 1 0x00001700 0x00002200 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
 
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 32f2685231e9..c7df75db1f70 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -142,8 +142,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x00000037 ]
+  [ range neq reg 1 0x00000021 0x00000037 ]
 
 # icmp code { 33-55}
 __set%d test-ip4 7
@@ -195,8 +194,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00000b00 ]
-  [ cmp gt reg 1 0x00005701 ]
+  [ range neq reg 1 0x00000b00 0x00005701 ]
   [ immediate reg 0 accept ]
 
 # icmp checksum { 11-343} accept
@@ -256,8 +254,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmp id { 33-55}
 __set%d test-ip4 7
@@ -306,8 +303,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmp sequence { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -381,8 +377,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmp mtu { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -431,8 +426,7 @@ ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # icmp gateway { 33, 55, 67, 88}
 __set%d test-ip4 3
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 4c7bd7df7a1e..fade387e568f 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -50,8 +50,7 @@ ip test-ip4 input
 # ip length != 333-453
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00004d01 ]
-  [ cmp gt reg 1 0x0000c501 ]
+  [ range neq reg 1 0x00004d01 0x0000c501 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-ip4 3
@@ -88,8 +87,7 @@ ip test-ip4 input
 # ip id != 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -127,8 +125,7 @@ ip test-ip4 input
 # ip frag-off != 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -166,8 +163,7 @@ ip test-ip4 input
 # ip ttl != 45-50
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x0000002d ]
-  [ cmp gt reg 1 0x00000032 ]
+  [ range neq reg 1 0x0000002d 0x00000032 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-ip4 3
@@ -234,8 +230,7 @@ ip test-ip4 input
 # ip checksum != 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-ip4 3
@@ -307,8 +302,7 @@ ip test-ip4 input
 # ip daddr != 192.168.0.1-192.168.0.250
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x0100a8c0 ]
-  [ cmp gt reg 1 0xfa00a8c0 ]
+  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr { 192.168.0.1-192.168.0.250}
 __set%d test-ip4 7
@@ -336,8 +330,7 @@ ip test-ip4 input
 # ip daddr != 192.168.1.2-192.168.1.55
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x0201a8c0 ]
-  [ cmp gt reg 1 0x3701a8c0 ]
+  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 ip test-ip4 input
@@ -348,8 +341,7 @@ ip test-ip4 input
 # ip saddr != 192.168.1.3-192.168.33.55
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp lt reg 1 0x0301a8c0 ]
-  [ cmp gt reg 1 0x3721a8c0 ]
+  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip daddr 192.168.0.1
 ip test-ip4 input
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index baaf7b358335..c9469d36cacd 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -68,8 +68,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00004d01 ]
-  [ cmp gt reg 1 0x0000c501 ]
+  [ range neq reg 1 0x00004d01 0x0000c501 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-inet 3
@@ -118,8 +117,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -169,8 +167,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -220,8 +217,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x0000002d ]
-  [ cmp gt reg 1 0x00000032 ]
+  [ range neq reg 1 0x0000002d 0x00000032 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-inet 3
@@ -310,8 +306,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -407,8 +402,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x0100a8c0 ]
-  [ cmp gt reg 1 0xfa00a8c0 ]
+  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr { 192.168.0.1-192.168.0.250}
 __set%d test-inet 7
@@ -444,8 +438,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x0201a8c0 ]
-  [ cmp gt reg 1 0x3701a8c0 ]
+  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 inet test-inet input
@@ -460,8 +453,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp lt reg 1 0x0301a8c0 ]
-  [ cmp gt reg 1 0x3721a8c0 ]
+  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip daddr 192.168.0.1
 inet test-inet input
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 2d8f947a445d..6f2c174c70ef 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -25,8 +25,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00004d01 ]
-  [ cmp gt reg 1 0x0000c501 ]
+  [ range neq reg 1 0x00004d01 0x0000c501 ]
 
 # ip length { 333, 553, 673, 838}
 __set%d test-netdev 3
@@ -75,8 +74,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip id { 33, 55, 67, 88}
 __set%d test-netdev 3
@@ -126,8 +124,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off { 33, 55, 67, 88}
 __set%d test-netdev 3
@@ -170,8 +167,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp lt reg 1 0x0000002d ]
-  [ cmp gt reg 1 0x00000032 ]
+  [ range neq reg 1 0x0000002d 0x00000032 ]
 
 # ip ttl {43, 53, 45 }
 __set%d test-netdev 3
@@ -246,8 +242,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum { 33, 55, 67, 88}
 __set%d test-netdev 3
@@ -336,8 +331,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x0100a8c0 ]
-  [ cmp gt reg 1 0xfa00a8c0 ]
+  [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr { 192.168.0.1-192.168.0.250}
 __set%d test-netdev 7
@@ -373,8 +367,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp lt reg 1 0x0201a8c0 ]
-  [ cmp gt reg 1 0x3701a8c0 ]
+  [ range neq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip saddr 192.168.1.3-192.168.33.55
 netdev test-netdev ingress 
@@ -389,8 +382,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp lt reg 1 0x0301a8c0 ]
-  [ cmp gt reg 1 0x3721a8c0 ]
+  [ range neq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip daddr 192.168.0.1
 netdev test-netdev ingress 
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index bef97a857099..3d828a38a6bd 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -17,8 +17,7 @@ ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00005000 ]
-  [ cmp gt reg 1 0x00005a00 ]
+  [ range neq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
@@ -43,8 +42,7 @@ ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00001700 ]
-  [ cmp gt reg 1 0x00002200 ]
+  [ range neq reg 1 0x00001700 0x00002200 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 0 ]
 
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 15914d968de7..62d1c5a134f8 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -25,8 +25,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst nexthdr { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -99,8 +98,7 @@ ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst hdrlength { 33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index 3f6c8e15b369..c022c7f71613 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -17,8 +17,7 @@ ip6 test-ip6 input
 # dst nexthdr != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst nexthdr { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -73,8 +72,7 @@ ip6 test-ip6 input
 # dst hdrlength != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 60 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # dst hdrlength { 33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 387dbd660967..bf57eca22607 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -63,8 +63,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -117,8 +116,7 @@ inet test-inet output
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp lt reg 1 0x00000801 ]
-  [ cmp gt reg 1 0x00006801 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -184,8 +182,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # frag id { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index 1f279756c070..aa27005ebcc0 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -45,8 +45,7 @@ ip6 test-ip6 output
 # frag reserved != 33-45
 ip6 test-ip6 output
   [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -87,8 +86,7 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ exthdr load 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp lt reg 1 0x00000801 ]
-  [ cmp gt reg 1 0x00006801 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -138,8 +136,7 @@ ip6 test-ip6 output
 # frag id != 33-45
 ip6 test-ip6 output
   [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # frag id { 33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index 5fcd2fde1304..7e0d079b556b 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -25,8 +25,7 @@ inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh hdrlength {33, 55, 67, 88}
 __set%d test-inet 3
@@ -85,8 +84,7 @@ inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh nexthdr {33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index a2b46335a327..783fc6acfdad 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -17,8 +17,7 @@ ip6 test-ip6 filter-input
 # hbh hdrlength != 33-45
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh hdrlength {33, 55, 67, 88}
 __set%d test-ip6 3
@@ -63,8 +62,7 @@ ip6 test-ip6 filter-input
 # hbh nexthdr != 33-45
 ip6 test-ip6 filter-input
   [ exthdr load 1b @ 0 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # hbh nexthdr {33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 4b6f54121c6f..822db2d5a2c5 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -266,8 +266,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
 
 # icmpv6 mtu {33, 55, 67, 88}
 __set%d test-ip6 3
@@ -302,8 +301,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # icmpv6 id {33, 55, 67, 88}
 __set%d test-ip6 3
@@ -366,8 +364,7 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00000200 ]
-  [ cmp gt reg 1 0x00000400 ]
+  [ range neq reg 1 0x00000200 0x00000400 ]
 
 # icmpv6 sequence { 2-4}
 __set%d test-ip6 7
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index f9512154d45d..1aa0f5b62137 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -106,8 +106,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip6 length { 33-55}
 __set%d test-inet 7
@@ -176,8 +175,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002c ]
+  [ range neq reg 1 0x00000021 0x0000002c ]
 
 # ip6 hoplimit 1
 inet test-inet input
@@ -206,8 +204,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # ip6 hoplimit {33, 55, 67, 88}
 __set%d test-inet 3
@@ -510,8 +507,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp lt reg 1 0x34120000 0x34123412 0x34123412 0x34123412 ]
-  [ cmp gt reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ range neq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 0x34123412 0x34120000 0x34123412 0x34123412 ]
 
 # iif "lo" ip6 daddr set ::1
 inet test-inet input
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 422fabdb6d6c..56ed8bd4e699 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -80,8 +80,7 @@ ip6 test-ip6 input
 # ip6 length != 33-45
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # ip6 length { 33-55}
 __set%d test-ip6 7
@@ -134,8 +133,7 @@ ip6 test-ip6 input
 # ip6 nexthdr != 33-44
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002c ]
+  [ range neq reg 1 0x00000021 0x0000002c ]
 
 # ip6 hoplimit 1
 ip6 test-ip6 input
@@ -156,8 +154,7 @@ ip6 test-ip6 input
 # ip6 hoplimit != 33-45
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # ip6 hoplimit {33, 55, 67, 88}
 __set%d test-ip6 3
@@ -376,8 +373,7 @@ ip6 test-ip6 input
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp lt reg 1 0x34120000 0x34123412 0x34123412 0x34123412 ]
-  [ cmp gt reg 1 0x34123412 0x34120000 0x34123412 0x34123412 ]
+  [ range neq reg 1 0x34120000 0x34123412 0x34123412 0x34123412 0x34123412 0x34120000 0x34123412 0x34123412 ]
 
 # iif "lo" ip6 daddr set ::1
 ip6 test-ip6 input
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 5d0656611d4e..471af09c8d58 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -63,8 +63,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
 __set%d test-inet 3
@@ -113,8 +112,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
 __set%d test-inet 3
@@ -187,8 +185,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh reserved { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -237,8 +234,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # mh checksum { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index d5366a5441b6..7a9aa35a5e9c 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -45,8 +45,7 @@ ip6 test-ip6 input
 # mh nexthdr != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh nexthdr { 33, 55, 67, 88 }
 __set%d test-ip6 3
@@ -83,8 +82,7 @@ ip6 test-ip6 input
 # mh hdrlength != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh hdrlength { 33, 55, 67, 88 }
 __set%d test-ip6 3
@@ -139,8 +137,7 @@ ip6 test-ip6 input
 # mh reserved != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 135 + 3 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # mh reserved { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -177,8 +174,7 @@ ip6 test-ip6 input
 # mh checksum != 33-45
 ip6 test-ip6 input
   [ exthdr load 2b @ 135 + 4 => reg 1 ]
-  [ cmp lt reg 1 0x00002100 ]
-  [ cmp gt reg 1 0x00002d00 ]
+  [ range neq reg 1 0x00002100 0x00002d00 ]
 
 # mh checksum { 33, 55, 67, 88}
 __set%d test-ip6 3
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index 7d644fb15b12..30e29a582f1c 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -63,8 +63,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt nexthdr { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -113,8 +112,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt hdrlength { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -163,8 +161,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt type { 33, 55, 67, 88}
 __set%d test-inet 3
@@ -213,8 +210,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt seg-left { 33, 55, 67, 88}
 __set%d test-inet 3
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index 3245725b2996..b96980bec903 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -45,8 +45,7 @@ ip6 test-ip6 input
 # rt nexthdr != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 0 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt nexthdr { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -83,8 +82,7 @@ ip6 test-ip6 input
 # rt hdrlength != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt hdrlength { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -121,8 +119,7 @@ ip6 test-ip6 input
 # rt type != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 2 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt type { 33, 55, 67, 88}
 __set%d test-ip6 3
@@ -159,8 +156,7 @@ ip6 test-ip6 input
 # rt seg-left != 33-45
 ip6 test-ip6 input
   [ exthdr load 1b @ 43 + 3 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
 
 # rt seg-left { 33, 55, 67, 88}
 __set%d test-ip6 3
-- 
2.1.4

