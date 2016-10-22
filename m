From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nft 3/4] src: add offset attribute for numgen expression
Date: Sat, 22 Oct 2016 23:36:07 +0200
Message-ID: <37be3c331f27312031dc6541073e44a4a7c1996a.1477170966.git.nevola@gmail.com>
References: <cover.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34368 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbcJVVgL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 17:36:11 -0400
Received: by mail-wm0-f67.google.com with SMTP id d199so3966705wmd.1
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Oct 2016 14:36:11 -0700 (PDT)
Received: from sonyv (72.red-88-15-56.dynamicip.rima-tde.net. [88.15.56.72])
        by smtp.gmail.com with ESMTPSA id af4sm10286276wjc.17.2016.10.22.14.36.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 22 Oct 2016 14:36:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1477170966.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to add an offset to the numgen generated value.

Example:

 ct mark set numgen inc mod 2 offset 100

This will generate marks with serie like 100, 101, 100, ...

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/numgen.h                    |  3 ++-
 src/netlink_delinearize.c           |  5 +++--
 src/netlink_linearize.c             |  1 +
 src/numgen.c                        | 10 ++++++++--
 src/parser_bison.y                  |  4 ++--
 tests/py/ip/numgen.t                |  1 +
 8 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 38073ee..960c21e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -291,6 +291,7 @@ struct expr {
 			/* EXPR_NUMGEN */
 			enum nft_ng_types	type;
 			uint32_t		mod;
+			uint32_t		offset;
 		} numgen;
 		struct {
 			/* EXPR_HASH */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 335102d..73cf897 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1159,12 +1159,14 @@ enum nft_trace_types {
  * @NFTA_NG_DREG: destination register (NLA_U32)
  * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
+ * @NFTA_NG_OFFSET: offset value (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
 	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_OFFSET,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/include/numgen.h b/include/numgen.h
index bec18e5..b230620 100644
--- a/include/numgen.h
+++ b/include/numgen.h
@@ -2,6 +2,7 @@
 #define NFTABLES_NUMGEN_H
 
 extern struct expr *numgen_expr_alloc(const struct location *loc,
-				      enum nft_ng_types type, uint32_t until);
+				      enum nft_ng_types type, uint32_t until,
+				      uint32_t offset);
 
 #endif /* NFTABLES_NUMGEN_H */
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7db109d..1f14456 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -591,13 +591,14 @@ static void netlink_parse_numgen(struct netlink_parse_ctx *ctx,
 				 const struct nftnl_expr *nle)
 {
 	enum nft_registers dreg;
-	uint32_t type, until;
+	uint32_t type, until, offset;
 	struct expr *expr;
 
 	type  = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_TYPE);
 	until = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_MODULUS);
+	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_NG_OFFSET);
 
-	expr = numgen_expr_alloc(loc, type, until);
+	expr = numgen_expr_alloc(loc, type, until, offset);
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_NG_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 117ea8c..15a8953 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -183,6 +183,7 @@ static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 	netlink_put_register(nle, NFTNL_EXPR_NG_DREG, dreg);
 	netlink_put_register(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_MODULUS, expr->numgen.mod);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_OFFSET, expr->numgen.offset);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/numgen.c b/src/numgen.c
index d9a43aa..5c1d00a 100644
--- a/src/numgen.c
+++ b/src/numgen.c
@@ -32,18 +32,22 @@ static void numgen_expr_print(const struct expr *expr)
 {
 	printf("numgen %s mod %u", numgen_type_str(expr->numgen.type),
 	       expr->numgen.mod);
+	if (expr->numgen.offset)
+		printf(" offset %u", expr->numgen.offset);
 }
 
 static bool numgen_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return e1->numgen.type == e2->numgen.type &&
-	       e1->numgen.mod == e2->numgen.mod;
+	       e1->numgen.mod == e2->numgen.mod &&
+	       e1->numgen.offset == e2->numgen.offset;
 }
 
 static void numgen_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->numgen.type = expr->numgen.type;
 	new->numgen.mod = expr->numgen.mod;
+	new->numgen.offset = expr->numgen.offset;
 }
 
 static const struct expr_ops numgen_expr_ops = {
@@ -55,7 +59,8 @@ static const struct expr_ops numgen_expr_ops = {
 };
 
 struct expr *numgen_expr_alloc(const struct location *loc,
-			       enum nft_ng_types type, uint32_t mod)
+			       enum nft_ng_types type, uint32_t mod,
+			       uint32_t offset)
 {
 	struct expr *expr;
 
@@ -63,6 +68,7 @@ struct expr *numgen_expr_alloc(const struct location *loc,
 			  BYTEORDER_HOST_ENDIAN, 4 * BITS_PER_BYTE);
 	expr->numgen.type  = type;
 	expr->numgen.mod   = mod;
+	expr->numgen.offset = offset;
 
 	return expr;
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index bb9320d..0c03a55 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2475,9 +2475,9 @@ numgen_type		:	INC		{ $$ = NFT_NG_INCREMENTAL; }
 			|	RANDOM		{ $$ = NFT_NG_RANDOM; }
 			;
 
-numgen_expr		:	NUMGEN	numgen_type	MOD	NUM
+numgen_expr		:	NUMGEN	numgen_type	MOD	NUM	offset_opt
 			{
-				$$ = numgen_expr_alloc(&@$, $2, $4);
+				$$ = numgen_expr_alloc(&@$, $2, $4, $5);
 			}
 			;
 
diff --git a/tests/py/ip/numgen.t b/tests/py/ip/numgen.t
index 9ce0c71..29a6a10 100644
--- a/tests/py/ip/numgen.t
+++ b/tests/py/ip/numgen.t
@@ -2,5 +2,6 @@
 *ip;test-ip4;pre
 
 ct mark set numgen inc mod 2;ok
+ct mark set numgen inc mod 2 offset 100;ok
 dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 };ok
 dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200};ok
-- 
2.9.3

