From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft V2] src: fix compile error due to _UNTIL renamed to _MODULUS in libnftnl
Date: Mon, 12 Sep 2016 20:19:04 +0800
Message-ID: <1473682744-5504-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:38962 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757812AbcILMTj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 08:19:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In the latest libnftnl, NFTNL_EXPR_NG_UNTIL was renamed to
NFTNL_EXPR_NG_MODULUS, so compile error happened:
  netlink_linearize.c: In function ‘netlink_gen_numgen’:
  netlink_linearize.c:184:26: error: ‘NFTNL_EXPR_NG_UNTIL’ undeclared
  (first use in this function)

Also update NFTA_NG_UNTIL to NFTA_NG_MODULUS.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 V2: update NFTA_NG_UNTIL to NFTA_NG_MODULUS reported by Laura Garcia Liebana.

 include/linux/netfilter/nf_tables.h | 4 ++--
 src/netlink_delinearize.c           | 2 +-
 src/netlink_linearize.c             | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8a63f22..1bec149 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1126,13 +1126,13 @@ enum nft_trace_types {
  * enum nft_ng_attributes - nf_tables number generator expression netlink attributes
  *
  * @NFTA_NG_DREG: destination register (NLA_U32)
- * @NFTA_NG_UNTIL: source value to increment the counter until reset (NLA_U32)
+ * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
-	NFTA_NG_UNTIL,
+	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
 	__NFTA_NG_MAX
 };
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 05edb01..6bb27b6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -554,7 +554,7 @@ static void netlink_parse_numgen(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	type  = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_TYPE);
-	until = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_UNTIL);
+	until = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_MODULUS);
 
 	expr = numgen_expr_alloc(loc, type, until);
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_NG_DREG);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5204154..558deb2 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -181,7 +181,7 @@ static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("numgen");
 	netlink_put_register(nle, NFTNL_EXPR_NG_DREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
-	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_UNTIL, expr->numgen.mod);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_MODULUS, expr->numgen.mod);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-- 
2.5.5


