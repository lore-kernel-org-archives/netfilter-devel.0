From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC PATCH nft] src: finish concatenation support using the set infrastructure
Date: Mon, 28 Oct 2013 13:59:40 +0100
Message-ID: <1382965180-9400-4-git-send-email-pablo@netfilter.org>
References: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49960 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab3J1M7y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:59:54 -0400
In-Reply-To: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch finished the concatenation support using the set
infrastructure, eg.

nft add rule ip filter output ip saddr . ip daddr { 192.168.1.128 . 8.8.8.8  } counter
nft add rule ip filter output ip saddr . tcp dport { 192.168.1.128 . 80  } counter

You can basically use any combination of existing selectors that
are offered by nft.

NOTE: This patch is incomplete, as map and mappings are not
yet supported. This also requires the 32/64/128 bits registerd addressing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   35 ++++++++-
 include/utils.h                     |    2 +
 src/evaluate.c                      |    7 +-
 src/netlink.c                       |   15 +++-
 src/netlink_linearize.c             |  140 +++++++++++++++++++++++++++++++++--
 5 files changed, 190 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a236cc3..b76401b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -9,7 +9,40 @@ enum nft_registers {
 	NFT_REG_2,
 	NFT_REG_3,
 	NFT_REG_4,
-	__NFT_REG_MAX
+	__NFT_REG_MAX,
+	/* 64 bits addressing */
+	NFT_REG_5 = __NFT_REG_MAX,
+	NFT_REG_6,
+	NFT_REG_7,
+	NFT_REG_8,
+	NFT_REG_9,
+	NFT_REG_10,
+	NFT_REG_11,
+	NFT_REG_12,
+	NFT_REG_13,
+	NFT_REG_14,
+	/* 32 bits addressing */
+	NFT_REG_15,
+	NFT_REG_16,
+	NFT_REG_17,
+	NFT_REG_18,
+	NFT_REG_19,
+	NFT_REG_20,
+	NFT_REG_21,
+	NFT_REG_22,
+	NFT_REG_23,
+	NFT_REG_24,
+	NFT_REG_25,
+	NFT_REG_26,
+	NFT_REG_27,
+	NFT_REG_28,
+	NFT_REG_29,
+	NFT_REG_30,
+	NFT_REG_31,
+	NFT_REG_32,
+	NFT_REG_33,
+	NFT_REG_34,
+	NFT_REG_ADDR_MAX,
 };
 #define NFT_REG_MAX	(__NFT_REG_MAX - 1)
 
diff --git a/include/utils.h b/include/utils.h
index 854986f..38ef7cc 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -62,6 +62,8 @@
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define ALIGN(len, x) ( ((len)+(x)-1) & ~((x)-1) )
+
 extern void memory_allocation_error(void) __noreturn;
 
 extern void xfree(const void *ptr);
diff --git a/src/evaluate.c b/src/evaluate.c
index 94fee64..fbc4490 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -585,11 +585,13 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	return err;
 }
 
+#define ALIGN(len, x) ( ((len)+(x)-1) & ~((x)-1) )
+
 static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct datatype *dtype = ctx->ectx.dtype, *tmp;
 	unsigned int type = dtype ? dtype->type : 0;
-	int off = dtype ? dtype->size: 0;
+	int off = dtype ? dtype->size: 0, len = 0;
 	unsigned int flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 	struct expr *i, *next;
 	unsigned int n;
@@ -606,6 +608,8 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
+
+		len += ALIGN(i->dtype->size, 32);
 		flags &= i->flags;
 
 		n++;
@@ -613,6 +617,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 	(*expr)->flags |= flags;
 	(*expr)->dtype = concat_type_alloc(*expr);
+	(*expr)->len = len;
 
 	if (off > 0)
 		return expr_error(ctx, *expr,
diff --git a/src/netlink.c b/src/netlink.c
index a62c357..d3b369b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -151,8 +151,19 @@ static struct nft_set_elem *alloc_nft_setelem(const struct expr *expr)
 		netlink_gen_data(expr, &nld);
 		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
 				      &nld.value, nld.len);
-	} else {
-		assert(expr->ops->type == EXPR_MAPPING);
+	} else if (expr->ops->type == EXPR_CONCAT) {
+		struct expr *i;
+		struct nft_data_linearize nld2 = {};
+
+		list_for_each_entry(i, &expr->expressions, list) {
+			struct nft_data_linearize nld = {};
+			netlink_gen_data(i, &nld);
+			nld2.len += ALIGN(nld.len, 4);
+			memcpy(&nld2.value[div_round_up(nld2.len, 4) - 1], nld.value, nld.len);
+		}
+		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
+				      &nld2.value, nld2.len);
+	} else if (expr->ops->type == EXPR_MAPPING) {
 		netlink_gen_data(expr->left, &nld);
 		nft_set_elem_attr_set(nlse, NFT_SET_ELEM_ATTR_KEY,
 				      &nld.value, nld.len);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index da8be20..23d9c61 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -19,21 +19,130 @@
 #include <gmputil.h>
 #include <utils.h>
 
+enum reg_mode {
+	REG128 = 0,
+	REG64,
+	REG32,
+};
+
 struct netlink_linearize_ctx {
 	struct nft_rule		*nlr;
+	enum reg_mode		mode;
 	unsigned int		reg_low;
+	unsigned int		reg_low_64;
+	unsigned int		reg_low_32;
+};
+
+static LIST_HEAD(delta_list);
+
+struct delta {
+	struct list_head	list;
+	int			reg_low;
+	int			reg_low_64;
+	int			reg_low_32;
+};
+
+static int reg_to_offset[NFT_REG_ADDR_MAX] = {
+        /* 128-bits addressing */
+        [NFT_REG_VERDICT]       = 0,
+        [NFT_REG_1]             = 4,
+        [NFT_REG_2]             = 8,
+        [NFT_REG_3]             = 12,
+        [NFT_REG_4]             = 16,
+        /* 64-bits addressing */
+        [NFT_REG_5]             = 0, /* NFT_REG_VERDICT */
+        [NFT_REG_6]             = 2, /* NFT_REG_VERDICT */
+        [NFT_REG_7]             = 4,
+        [NFT_REG_8]             = 6,
+        [NFT_REG_9]             = 8,
+        [NFT_REG_10]            = 10,
+        [NFT_REG_11]            = 12,
+        [NFT_REG_12]            = 14,
+        [NFT_REG_13]            = 16,
+        [NFT_REG_14]            = 18,
+        /* 32-bits addressing */
+        [NFT_REG_15]            = 0, /* NFT_REG_VERDICT */
+        [NFT_REG_16]            = 1, /* NFT_REG_VERDICT */
+        [NFT_REG_17]            = 2, /* NFT_REG_VERDICT */
+        [NFT_REG_18]            = 3, /* NFT_REG_VERDICT */
+        [NFT_REG_19]            = 4,
+        [NFT_REG_20]            = 5,
+        [NFT_REG_21]            = 6,
+        [NFT_REG_22]            = 7,
+        [NFT_REG_23]            = 8,
+        [NFT_REG_24]            = 9,
+        [NFT_REG_25]            = 10,
+        [NFT_REG_26]            = 11,
+        [NFT_REG_27]            = 12,
+        [NFT_REG_28]            = 13,
+        [NFT_REG_29]            = 14,
+        [NFT_REG_30]            = 15,
+        [NFT_REG_31]            = 16,
+        [NFT_REG_32]            = 17,
+        [NFT_REG_33]            = 18,
+        [NFT_REG_34]            = 19,
 };
 
 static enum nft_registers get_register(struct netlink_linearize_ctx *ctx)
 {
-	if (ctx->reg_low > NFT_REG_MAX)
-		BUG("register reg_low %u invalid\n", ctx->reg_low);
-	return ctx->reg_low++;
+	struct delta *delta = calloc(1, sizeof(struct delta));
+
+	switch (ctx->mode) {
+	case REG128:
+		ctx->reg_low_32 += 4;
+		delta->reg_low_32 = 4;
+		ctx->reg_low_64 = 2;
+		delta->reg_low_64 += 2;
+		delta->reg_low = 1;
+
+		list_add_tail(&delta->list, &delta_list);
+		return ctx->reg_low++;
+	case REG64:
+		if (reg_to_offset[ctx->reg_low_64] % 2 == 0) {
+			ctx->reg_low++;
+			delta->reg_low = 1;
+			ctx->reg_low_32 += 2;
+			delta->reg_low_32 = 2;
+		}
+		delta->reg_low_64 = 1;
+
+		list_add_tail(&delta->list, &delta_list);
+		return ctx->reg_low_64++;
+	case REG32:
+		if (reg_to_offset[ctx->reg_low_32] % 4 == 0) {
+			ctx->reg_low++;
+			delta->reg_low = 1;
+		}
+		if (reg_to_offset[ctx->reg_low_32] % 2 == 0) {
+			ctx->reg_low_64++;
+			delta->reg_low_64 = 1;
+		}
+		delta->reg_low_32 = 1;
+
+		list_add_tail(&delta->list, &delta_list);
+
+		return ctx->reg_low_32++;
+	}
+	return 0; /* Shouldn't happen */
 }
 
 static void release_register(struct netlink_linearize_ctx *ctx)
 {
-	ctx->reg_low--;
+	struct delta *delta;
+
+	if (delta_list.prev == &delta_list) {
+		printf("BUG: too many register releases\n");
+		return;
+	}
+
+	delta = list_entry(delta_list.prev, struct delta, list);
+	list_del(&delta->list);
+
+	ctx->reg_low_32 -= delta->reg_low_32;
+	ctx->reg_low_64 -= delta->reg_low_64;
+	ctx->reg_low -= delta->reg_low;
+
+	xfree(delta);
 }
 
 static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
@@ -46,8 +155,11 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 {
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr->expressions, list) {
 		netlink_gen_expr(ctx, i, dreg);
+		dreg = get_register(ctx);
+	}
+	release_register(ctx);
 }
 
 static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
@@ -117,6 +229,10 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 
 	assert(expr->mappings->ops->type == EXPR_SET_REF);
 
+	/* Enter 32 bits mode to squash data into registers */
+	if (expr->map->left->ops->type == EXPR_CONCAT)
+		ctx->mode = REG32;
+
 	if (dreg == NFT_REG_VERDICT)
 		sreg = get_register(ctx);
 	else
@@ -133,6 +249,9 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	if (dreg == NFT_REG_VERDICT)
 		release_register(ctx);
 
+	if (expr->map->left->ops->type == EXPR_CONCAT)
+		ctx->mode = REG128;
+
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -146,6 +265,10 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	assert(expr->right->ops->type == EXPR_SET_REF);
 	assert(dreg == NFT_REG_VERDICT);
 
+	/* Enter 32 bits mode to squash data into registers */
+	if (expr->left->ops->type == EXPR_CONCAT)
+		ctx->mode = REG32;
+
 	sreg = get_register(ctx);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
@@ -155,6 +278,11 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 			      expr->right->set->handle.set);
 
 	release_register(ctx);
+
+	/* Back to 128 bits mode */
+	if (expr->left->ops->type == EXPR_CONCAT)
+		ctx->mode = REG128;
+
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -666,6 +794,8 @@ int netlink_linearize_rule(struct netlink_ctx *ctx, struct nft_rule *nlr,
 
 	memset(&lctx, 0, sizeof(lctx));
 	lctx.reg_low = NFT_REG_1;
+	lctx.reg_low_64 = NFT_REG_7;
+	lctx.reg_low_32 = NFT_REG_19;
 	lctx.nlr = nlr;
 
 	list_for_each_entry(stmt, &rule->stmts, list)
-- 
1.7.10.4

