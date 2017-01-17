From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/3] exthdr: Add support for exthdr specific flags
Date: Tue, 17 Jan 2017 23:10:06 +0100
Message-ID: <20170117221007.14951-3-phil@nwl.cc>
References: <20170117221007.14951-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36851 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdAQWHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 17:07:24 -0500
In-Reply-To: <20170117221007.14951-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h      | 1 +
 src/exthdr.c              | 4 +++-
 src/netlink_delinearize.c | 4 +++-
 src/netlink_linearize.c   | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index fa1587639621e..67c046e23de1f 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -288,6 +288,7 @@ struct expr {
 			const struct exthdr_desc	*desc;
 			const struct proto_hdr_template	*tmpl;
 			unsigned int			offset;
+			unsigned int			flags;
 		} exthdr;
 		struct {
 			/* EXPR_META */
diff --git a/src/exthdr.c b/src/exthdr.c
index c641d4a398ad2..32bf3558115c5 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -30,7 +30,8 @@ static void exthdr_expr_print(const struct expr *expr)
 static bool exthdr_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
 	return e1->exthdr.desc == e2->exthdr.desc &&
-	       e1->exthdr.tmpl == e2->exthdr.tmpl;
+	       e1->exthdr.tmpl == e2->exthdr.tmpl &&
+	       e1->exthdr.flags == e2->exthdr.flags;
 }
 
 static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
@@ -38,6 +39,7 @@ static void exthdr_expr_clone(struct expr *new, const struct expr *expr)
 	new->exthdr.desc = expr->exthdr.desc;
 	new->exthdr.tmpl = expr->exthdr.tmpl;
 	new->exthdr.offset = expr->exthdr.offset;
+	new->exthdr.flags = expr->exthdr.flags;
 }
 
 static const struct expr_ops exthdr_expr_ops = {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 06823de24d0e7..1d2a50abb5473 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -504,16 +504,18 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 				 const struct nftnl_expr *nle)
 {
 	enum nft_registers dreg;
-	uint32_t offset, len;
+	uint32_t offset, len, flags;
 	uint8_t type;
 	struct expr *expr;
 
 	type   = nftnl_expr_get_u8(nle, NFTNL_EXPR_EXTHDR_TYPE);
 	offset = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET) * BITS_PER_BYTE;
 	len    = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_LEN) * BITS_PER_BYTE;
+	flags  = nftnl_expr_get_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS);
 
 	expr = exthdr_expr_alloc(loc, NULL, 0);
 	exthdr_init_raw(expr, type, offset, len);
+	expr->exthdr.flags = flags;
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_EXTHDR_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index aff4f04a36db9..f2560ece066a1 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -172,6 +172,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 			   expr->exthdr.tmpl->offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_FLAGS, expr->exthdr.flags);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-- 
2.11.0

