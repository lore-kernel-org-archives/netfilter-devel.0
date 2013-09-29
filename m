From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 2/2] Add support for IPv6 NAT
Date: Sun, 29 Sep 2013 11:53:29 +0200
Message-ID: <1380448409-19583-3-git-send-email-eric@regit.org>
References: <1380448409-19583-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50860 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3I2Jxv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:53:51 -0400
In-Reply-To: <1380448409-19583-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for IPv6 NAT. It adds IPv6
support in evaluation and in delinearization which
were the only missing parts.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/evaluate.c            |  8 ++++++--
 src/netlink_delinearize.c | 16 ++++++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 29fa32b..94fee64 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1121,8 +1121,12 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 	int err;
 
 	if (stmt->nat.addr != NULL) {
-		expr_set_context(&ctx->ectx, &ipaddr_type,
-				 4 * BITS_PER_BYTE);
+		if (pctx && (pctx->family == AF_INET))
+			expr_set_context(&ctx->ectx, &ipaddr_type,
+					4 * BITS_PER_BYTE);
+		else
+			expr_set_context(&ctx->ectx, &ip6addr_type,
+					 16 * BITS_PER_BYTE);
 		err = expr_evaluate(ctx, &stmt->nat.addr);
 		if (err < 0)
 			return err;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4aacbbd..d80fc78 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -21,6 +21,7 @@
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
+#include <sys/socket.h>
 
 struct netlink_parse_ctx {
 	struct list_head	*msgs;
@@ -406,10 +407,13 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	struct expr *addr, *proto;
 	enum nft_registers reg1, reg2;
+	int family;
 
 	stmt = nat_stmt_alloc(loc);
 	stmt->nat.type = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_TYPE);
 
+	family = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_FAMILY);
+
 	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
 		addr = netlink_get_register(ctx, loc, reg1);
@@ -418,7 +422,11 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 					     "NAT statement has no address "
 					     "expression");
 
-		expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
+		if (family == AF_INET)
+			expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
+		else
+			expr_set_type(addr, &ip6addr_type,
+				      BYTEORDER_BIG_ENDIAN);
 		stmt->nat.addr = addr;
 	}
 
@@ -430,7 +438,11 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 					     "NAT statement has no address "
 					     "expression");
 
-		expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
+		if (family == AF_INET)
+			expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
+		else
+			expr_set_type(addr, &ip6addr_type,
+				      BYTEORDER_BIG_ENDIAN);
 		if (stmt->nat.addr != NULL)
 			addr = range_expr_alloc(loc, stmt->nat.addr, addr);
 		stmt->nat.addr = addr;
-- 
1.8.4.rc3

