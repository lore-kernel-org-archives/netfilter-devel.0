From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/5] exthdr: Add support for exthdr specific flags
Date: Fri, 10 Mar 2017 18:13:50 +0100
Message-ID: <20170310171353.28868-3-phil@nwl.cc>
References: <20170310171353.28868-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54287 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932678AbdCJROM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:14:12 -0500
In-Reply-To: <20170310171353.28868-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to have custom flags in exthdr expression, which is
necessary for upcoming existence checks (of both IPv6 extension headers
as well as TCP options).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h      |  1 +
 include/exthdr.h          |  2 +-
 include/tcpopt.h          |  3 ++-
 src/exthdr.c              | 11 +++++++----
 src/netlink_delinearize.c |  5 +++--
 src/netlink_linearize.c   |  1 +
 src/tcpopt.c              |  5 +++--
 7 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 4f2948cc002be..423eae7128f5c 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -282,6 +282,7 @@ struct expr {
 			const struct proto_hdr_template	*tmpl;
 			unsigned int			offset;
 			enum nft_exthdr_op		op;
+			unsigned int			flags;
 		} exthdr;
 		struct {
 			/* EXPR_META */
diff --git a/include/exthdr.h b/include/exthdr.h
index cdcc2b9537972..c7f806ebb2fa2 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -23,7 +23,7 @@ extern struct expr *exthdr_expr_alloc(const struct location *loc,
 
 extern void exthdr_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len,
-			    enum nft_exthdr_op op);
+			    enum nft_exthdr_op op, uint32_t flags);
 
 extern bool exthdr_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
diff --git a/include/tcpopt.h b/include/tcpopt.h
index f43a7eb703fed..412d02e7ba80f 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -8,7 +8,8 @@ extern struct expr *tcpopt_expr_alloc(const struct location *loc,
 				      uint8_t type, uint8_t field);
 
 extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
-			    unsigned int offset, unsigned int len);
+			    unsigned int offset, unsigned int len,
+			    uint32_t flags);
 
 extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 				 unsigned int *shift);
diff --git a/src/exthdr.c b/src/exthdr.c
index ddda1b870310f..21fe734f8fc15 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -46,7 +46,8 @@ static bool exthdr_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return e1->exthdr.desc == e2->exthdr.desc &&
 	       e1->exthdr.tmpl == e2->exthdr.tmpl &&
-	       e1->exthdr.op == e2->exthdr.op;
+	       e1->exthdr.op == e2->exthdr.op &&
+	       e1->exthdr.flags == e2->exthdr.flags;
 }
 
 static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
@@ -55,6 +56,7 @@ static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 	new->exthdr.tmpl = expr->exthdr.tmpl;
 	new->exthdr.offset = expr->exthdr.offset;
 	new->exthdr.op = expr->exthdr.op;
+	new->exthdr.flags = expr->exthdr.flags;
 }
 
 const struct expr_ops exthdr_expr_ops = {
@@ -97,16 +99,17 @@ static const struct exthdr_desc *exthdr_protocols[IPPROTO_MAX] = {
 
 void exthdr_init_raw(struct expr *expr, uint8_t type,
 		     unsigned int offset, unsigned int len,
-		     enum nft_exthdr_op op)
+		     enum nft_exthdr_op op, uint32_t flags)
 {
 	const struct proto_hdr_template *tmpl;
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_EXTHDR);
 	if (op == NFT_EXTHDR_OP_TCPOPT)
-		return tcpopt_init_raw(expr, type, offset, len);
+		return tcpopt_init_raw(expr, type, offset, len, flags);
 
 	expr->len = len;
+	expr->exthdr.flags = flags;
 	expr->exthdr.offset = offset;
 	expr->exthdr.desc = exthdr_protocols[type];
 	assert(expr->exthdr.desc != NULL);
@@ -149,7 +152,7 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 	off += round_up(mask->len, BITS_PER_BYTE) - mask_len;
 
 	exthdr_init_raw(expr, expr->exthdr.desc->type,
-			off, mask_len - mask_offset, NFT_EXTHDR_OP_IPV6);
+			off, mask_len - mask_offset, NFT_EXTHDR_OP_IPV6, 0);
 
 	/* still failed to find a template... Bug. */
 	if (expr->exthdr.tmpl == &exthdr_unknown_template)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 36e8fe3c4337b..9ad1e2c681c64 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -498,9 +498,9 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *nle)
 {
+	uint32_t offset, len, flags;
 	enum nft_registers dreg;
 	enum nft_exthdr_op op;
-	uint32_t offset, len;
 	uint8_t type;
 	struct expr *expr;
 
@@ -508,9 +508,10 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_LEN) * BITS_PER_BYTE;
 	op     = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_OP);
+	flags  = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS);
 
 	expr = exthdr_expr_alloc(loc, NULL, 0);
-	exthdr_init_raw(expr, type, offset, len, op);
+	exthdr_init_raw(expr, type, offset, len, op, flags);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 293150e2d0155..b2f27b7a35855 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -178,6 +178,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS, expr->exthdr.flags);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
index f861214117a18..d34dfd459f415 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -192,7 +192,7 @@ struct expr *tcpopt_expr_alloc(const struct location *loc, uint8_t type,
 }
 
 void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
-		     unsigned int len)
+		     unsigned int len, uint32_t flags)
 {
 	const struct proto_hdr_template *tmpl;
 	unsigned int i, off;
@@ -200,6 +200,7 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
 	assert(expr->ops->type == EXPR_EXTHDR);
 
 	expr->len = len;
+	expr->exthdr.flags = flags;
 	expr->exthdr.offset = offset;
 
 	assert(type < array_size(tcpopt_protocols));
@@ -229,7 +230,7 @@ bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
 		return false;
 
 	tcpopt_init_raw(expr, expr->exthdr.desc->type, expr->exthdr.offset,
-			expr->len);
+			expr->len, 0);
 
 	if (expr->exthdr.tmpl == &tcpopt_unknown_template)
 		return false;
-- 
2.11.0

