From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/4] netlink: fix prefix expression handling
Date: Mon, 17 Feb 2014 17:20:52 +0000
Message-ID: <1392657652-9815-5-git-send-email-kaber@trash.net>
References: <1392657652-9815-1-git-send-email-kaber@trash.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51573 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaBQRVB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:21:01 -0500
In-Reply-To: <1392657652-9815-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The prefix expression handling is full of bugs:

- netlink_gen_data() is used to construct the prefix mask from the full
  prefix expression. This is both conceptually wrong, the prefix expression
  is *not* data, and buggy, it only assumes network masks and thus only
  handles big endian types.

- Prefix expression reconstruction doesn't check whether the mask is a
  valid prefix and reconstructs crap otherwise. It doesn't reconstruct
  prefixes for anything but network addresses. On top of that its
  needlessly complicated, using the mpz values directly its a simple
  matter of finding the sequence of 1's that extend up to the full width.

- Unnecessary cloning of expressions where a simple refcount increase would
  suffice.

Rewrite that code properly.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c             | 27 ------------------------
 src/netlink_delinearize.c | 52 +++++++++++++++++++++--------------------------
 src/netlink_linearize.c   | 11 ++++++++--
 3 files changed, 32 insertions(+), 58 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 6e797dc..07af1cb 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -252,31 +252,6 @@ static void netlink_gen_verdict(const struct expr *expr,
 	}
 }
 
-static void netlink_gen_prefix(const struct expr *expr,
-			       struct nft_data_linearize *data)
-{
-	uint32_t idx;
-	int32_t i, cidr;
-	uint32_t mask;
-
-	assert(expr->ops->type == EXPR_PREFIX);
-
-	data->len = div_round_up(expr->prefix->len, BITS_PER_BYTE);
-	cidr = expr->prefix_len;
-
-	for (i = 0; (uint32_t)i / BITS_PER_BYTE < data->len; i += 32) {
-		if (cidr - i >= 32)
-			mask = 0xffffffff;
-		else if (cidr - i > 0)
-			mask = (1 << (cidr - i)) - 1;
-		else
-			mask = 0;
-
-		idx = i / 32;
-		data->value[idx] = mask;
-	}
-}
-
 void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 {
 	switch (expr->ops->type) {
@@ -286,8 +261,6 @@ void netlink_gen_data(const struct expr *expr, struct nft_data_linearize *data)
 		return netlink_gen_concat_data(expr, data);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
-	case EXPR_PREFIX:
-		return netlink_gen_prefix(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 645bf63..0e75c8a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -663,33 +663,27 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
-static int expr_value2cidr(struct expr *expr)
+/* Convert a bitmask to a prefix length */
+static unsigned int expr_mask_to_prefix(struct expr *expr)
 {
-	int i, j, k = 0;
-	uint32_t data[4], bits;
-	uint32_t len = div_round_up(expr->len, BITS_PER_BYTE) / sizeof(uint32_t);
+	unsigned long n;
 
-	assert(expr->ops->type == EXPR_VALUE);
-
-	mpz_export_data(data, expr->value, expr->byteorder, len);
-
-	for (i = len - 1; i >= 0; i--) {
-		j = 32;
-		bits = UINT32_MAX >> 1;
-
-		if (data[i] == UINT32_MAX)
-			goto next;
+	n = mpz_scan1(expr->value, 0);
+	return mpz_scan0(expr->value, n + 1) - n;
+}
 
-		while (--j >= 0) {
-			if (data[i] == bits)
-				break;
+/* Return true if a bitmask can be expressed as a prefix length */
+static bool expr_mask_is_prefix(const struct expr *expr)
+{
+	unsigned long n1, n2;
 
-			bits >>=1;
-		}
-next:
-		k += j;
-	}
-	return k;
+	n1 = mpz_scan1(expr->value, 0);
+	if (n1 == ULONG_MAX)
+		return false;
+	n2 = mpz_scan0(expr->value, n1 + 1);
+	if (n2 < expr->len || n2 == ULONG_MAX)
+		return false;
+	return true;
 }
 
 /* Convert a series of inclusive OR expressions into a list */
@@ -729,13 +723,13 @@ static void relational_binop_postprocess(struct expr *expr)
 		expr->op    = OP_FLAGCMP;
 
 		expr_free(binop);
-	} else if ((binop->left->dtype->type == TYPE_IPADDR ||
-		    binop->left->dtype->type == TYPE_IP6ADDR) &&
-		    binop->op == OP_AND) {
-		expr->left = expr_clone(binop->left);
+	} else if (binop->left->dtype->flags & DTYPE_F_PREFIX &&
+		   binop->op == OP_AND &&
+		   expr_mask_is_prefix(binop->right)) {
+		expr->left = expr_get(binop->left);
 		expr->right = prefix_expr_alloc(&expr->location,
-						expr_clone(value),
-						expr_value2cidr(binop->right));
+						expr_get(value),
+						expr_mask_to_prefix(binop->right));
 		expr_free(value);
 		expr_free(binop);
 	}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e5fb536..9d59374 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -193,9 +193,14 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	if (expr->right->ops->type == EXPR_PREFIX) {
-		right = expr->right->prefix;
+		mpz_t mask;
+
+		mpz_init(mask);
+		mpz_prefixmask(mask, expr->right->len, expr->right->prefix_len);
+		netlink_gen_raw_data(mask, expr->right->byteorder,
+				     expr->right->len / BITS_PER_BYTE, &nld);
+		mpz_clear(mask);
 
-		netlink_gen_data(expr->right, &nld);
 		zero.len = nld.len;
 
 		nle = alloc_nft_expr("bitwise");
@@ -205,6 +210,8 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 		nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, &nld.value, nld.len);
 		nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, &zero.value, zero.len);
 		nft_rule_add_expr(ctx->nlr, nle);
+
+		right = expr->right->prefix;
 	} else {
 		right = expr->right;
 	}
-- 
1.8.5.3

