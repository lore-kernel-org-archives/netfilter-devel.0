From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] netlink: do binop postprocessing also for map lookups
Date: Sun, 24 Jan 2016 18:58:27 +0100
Message-ID: <1453658307-7177-3-git-send-email-fw@strlen.de>
References: <1453658307-7177-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57954 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbcAXSGP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jan 2016 13:06:15 -0500
In-Reply-To: <1453658307-7177-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft list before patch:
mark set unknown unknown & 0xfff [invalid type] map { 3 : 0x00000017, 1 : 0x0000002a}
now:
mark set vlan id map { 3 : 0x00000017, 1 : 0x0000002a}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c          | 19 +++++++++++++++++++
 tests/py/inet/map.t                |  1 +
 tests/py/inet/map.t.payload.inet   | 12 ++++++++++++
 tests/py/inet/map.t.payload.ip     | 10 ++++++++++
 tests/py/inet/map.t.payload.netdev | 12 ++++++++++++
 5 files changed, 54 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6876f02..76d598c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1204,6 +1204,17 @@ static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 	}
 }
 
+static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
+{
+	struct expr *binop = expr->left;
+
+	if (binop->op != OP_AND)
+		return;
+
+	if (binop->left->ops->type == EXPR_PAYLOAD &&
+	    binop->right->ops->type == EXPR_VALUE)
+		binop_postprocess(ctx, expr);
+}
 
 static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
 {
@@ -1357,6 +1368,14 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 
 	switch (expr->ops->type) {
 	case EXPR_MAP:
+		switch (expr->map->ops->type) {
+		case EXPR_BINOP:
+			map_binop_postprocess(ctx, expr);
+			break;
+		default:
+			break;
+		}
+
 		expr_postprocess(ctx, &expr->map);
 		expr_postprocess(ctx, &expr->mappings);
 		break;
diff --git a/tests/py/inet/map.t b/tests/py/inet/map.t
index f48afcd..5075540 100644
--- a/tests/py/inet/map.t
+++ b/tests/py/inet/map.t
@@ -6,3 +6,4 @@
 *netdev;test-netdev;ingress
 
 mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017};ok;mark set ip saddr map { 10.2.3.1 : 0x00000017, 10.2.3.2 : 0x0000002a}
+mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001};ok;mark set ip hdrlength map { 4 : 0x00000001, 5 : 0x00000017}
diff --git a/tests/py/inet/map.t.payload.inet b/tests/py/inet/map.t.payload.inet
index 73e68b6..a0ff003 100644
--- a/tests/py/inet/map.t.payload.inet
+++ b/tests/py/inet/map.t.payload.inet
@@ -9,3 +9,15 @@ inet test-inet input
   [ lookup reg 1 set map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
+# mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
+map%d test-inet b
+map%d test-inet 0
+	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/inet/map.t.payload.ip b/tests/py/inet/map.t.payload.ip
index 54b9583..465a55a 100644
--- a/tests/py/inet/map.t.payload.ip
+++ b/tests/py/inet/map.t.payload.ip
@@ -7,3 +7,13 @@ ip test-ip input
   [ lookup reg 1 set map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
+# mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
+map%d test-ip4 b
+map%d test-ip4 0
+	element 00000004  : 00000001 0 [end]	element 00000005  : 00000017 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
diff --git a/tests/py/inet/map.t.payload.netdev b/tests/py/inet/map.t.payload.netdev
index 27a3ca8..fb9260c 100644
--- a/tests/py/inet/map.t.payload.netdev
+++ b/tests/py/inet/map.t.payload.netdev
@@ -9,3 +9,15 @@ netdev test-netdev ingress
   [ lookup reg 1 set map%d dreg 1 ]
   [ meta set mark with reg 1 ]
 
+# mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000005  : 00000017 0 [end]	element 00000004  : 00000001 0 [end]
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
+
-- 
2.4.10

