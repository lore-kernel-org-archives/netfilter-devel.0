From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 7/9] netlink_delinearize: introduce register translation helper
Date: Fri,  5 Jun 2015 15:42:49 +0200
Message-ID: <1433511771-4620-8-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59946 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbFENm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:56 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce a helper function to translate register numbers from the kernel
from the compat values to the NFT_REG32 values.

Internally we use the register numbers 0-16:

* 0 is the verdict register in both old and new addressing modes.
* 1-16 are the 32 bit data registers

The NFT_REG32_00 values are mapped to 1-16, the NFT_REG_1-NFT_REG_4
values are each use up 4 registers starting at 1 (1, 5, 9, 13).

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9ce76e..91da859 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -30,7 +30,7 @@ struct netlink_parse_ctx {
 	struct list_head	*msgs;
 	struct table		*table;
 	struct rule		*rule;
-	struct expr		*registers[NFT_REG_MAX + 1];
+	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
 };
 
 static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
@@ -49,14 +49,23 @@ static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
 static unsigned int netlink_parse_register(const struct nft_rule_expr *nle,
 					   unsigned int attr)
 {
-	return nft_rule_expr_get_u32(nle, attr);
+	unsigned int reg;
+
+	reg = nft_rule_expr_get_u32(nle, attr);
+	/* Translate 128bit registers to corresponding 32bit registers */
+	if (reg >= NFT_REG_1 && reg <= NFT_REG_4)
+		reg = 1 + (reg - NFT_REG_1) * (NFT_REG_SIZE / NFT_REG32_SIZE);
+	else if (reg >= NFT_REG32_00)
+		reg = 1 + reg - NFT_REG32_00;
+
+	return reg;
 }
 
 static void netlink_set_register(struct netlink_parse_ctx *ctx,
 				 enum nft_registers reg,
 				 struct expr *expr)
 {
-	if (reg > NFT_REG_MAX) {
+	if (reg == NFT_REG_VERDICT || reg > 1 + NFT_REG32_15 - NFT_REG32_00) {
 		netlink_error(ctx, &expr->location,
 			      "Invalid destination register %u", reg);
 		expr_free(expr);
@@ -75,7 +84,7 @@ static struct expr *netlink_get_register(struct netlink_parse_ctx *ctx,
 {
 	struct expr *expr;
 
-	if (reg == NFT_REG_VERDICT || reg > NFT_REG_MAX) {
+	if (reg == NFT_REG_VERDICT || reg > 1 + NFT_REG32_15 - NFT_REG32_00) {
 		netlink_error(ctx, loc, "Invalid source register %u", reg);
 		return NULL;
 	}
-- 
2.1.0

