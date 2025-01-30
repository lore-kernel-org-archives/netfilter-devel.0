Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF911E503D
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2025 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259432; cv=none; b=R1H8ChZdi5Rldn08cCtbKm5+IkRAqTOTYKzIMfX7rGpRxVtYPO5sMpQmabdm18yo+ay225CbZcH0zFatDAX5PSvfRBrruVoaguLZYwSPJJNa8QPJ8K5bBBSkAG5D9jFThFR/mnkibAwzQXadO+9rSZwRM/fuhF3uE5AQcYz8VKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259432; c=relaxed/simple;
	bh=L43gpkK9AVUBUqmy73ETfxStvOZg6MfWpOv5wwDx9QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEPYINgLrFiBpU3MMuG8SG3BoBfGCV9KpOQNt/KnYdRyK/xwLWzlEI5DsAM1SKaFlypbM892DL1dzReibwYgehJZp4hFYklSn8X8SEbaBkQ40l1Va4rik0kbiPPcHIrvfmd8Lp+GHe05CcSIdHc8qJTnW5JKlAQgv+i7LthIe6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tdYgI-000198-S9; Thu, 30 Jan 2025 18:50:22 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] src: add and use payload_expr_trim_force
Date: Thu, 30 Jan 2025 18:47:13 +0100
Message-ID: <20250130174718.6644-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250130174718.6644-1-fw@strlen.de>
References: <20250130174718.6644-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous commit fixed erroneous handling of raw expressions when RHS sets
a zero value.

Input: @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
Output:@ih,48,16 set @ih,48,16 & 0xffc0 @ih,80,16 set \
	@ih,80,16 & 0xfc0f @ih,160,32 set @ih,160,32 & 0xffc00000

After this patch, this will instead display:

@ih,58,6 set 0x0 @ih,86,6 set 0x0 @ih,170,22 set 0x0

payload_expr_trim_force() only works when the payload has no known
protocol (template) attached, i.e. will be printed as raw payload syntax.

It performs sanity checks on @mask and then adjusts the payload expression
length and offset according to the mask.

Also add this check in __binop_postprocess() so we can also discard masks
when matching, e.g.

'@ih,7,5 2' becomes '@ih,7,5 0x2', not '@ih,0,16 & 0xffc0 == 0x20'.

binop_postprocess now returns if it performed an action or not; if this
returns true then arguments might have been freed so callers must no longer
refer to any of the expressions attached to the binop.

Next patch adds test cases for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  2 ++
 src/netlink_delinearize.c | 31 +++++++++++++++++-----
 src/payload.c             | 54 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 08e45f7f79e2..6685dad6f9f7 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -62,6 +62,8 @@ extern struct expr *payload_expr_join(const struct expr *e1,
 
 bool payload_expr_trim(struct expr *expr, struct expr *mask,
 		       const struct proto_ctx *ctx, unsigned int *shift);
+bool payload_expr_trim_force(struct expr *expr, struct expr *mask,
+			     unsigned int *shift);
 extern void payload_expr_expand(struct list_head *list, struct expr *expr,
 				const struct proto_ctx *ctx);
 extern void payload_expr_complete(struct expr *expr,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 046e7a472b8d..86c8602860f6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2451,7 +2451,7 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 	}
 }
 
-static void __binop_postprocess(struct rule_pp_ctx *ctx,
+static bool __binop_postprocess(struct rule_pp_ctx *ctx,
 				struct expr *expr,
 				struct expr *left,
 				struct expr *mask,
@@ -2501,17 +2501,27 @@ static void __binop_postprocess(struct rule_pp_ctx *ctx,
 			expr_set_type(right, left->dtype, left->byteorder);
 
 		expr_free(binop);
+		return true;
+	} else if (left->etype == EXPR_PAYLOAD &&
+		   expr->right->etype == EXPR_VALUE &&
+		   payload_expr_trim_force(left, mask, &shift)) {
+			mpz_rshift_ui(expr->right->value, shift);
+			*expr_binop = expr_get(left);
+			expr_free(binop);
+			return true;
 	}
+
+	return false;
 }
 
-static void binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
+static bool binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr,
 			      struct expr **expr_binop)
 {
 	struct expr *binop = *expr_binop;
 	struct expr *left = binop->left;
 	struct expr *mask = binop->right;
 
-	__binop_postprocess(ctx, expr, left, mask, expr_binop);
+	return __binop_postprocess(ctx, expr, left, mask, expr_binop);
 }
 
 static void map_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *expr)
@@ -3178,6 +3188,7 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 
 	switch (expr->left->etype) {
 	case EXPR_BINOP: {/* I? */
+		unsigned int shift = 0;
 		mpz_t tmp;
 
 		if (expr->op != OP_OR)
@@ -3211,13 +3222,18 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 		mpz_set(mask->value, bitmask);
 		mpz_clear(bitmask);
 
-		binop_postprocess(ctx, expr, &expr->left);
-		if (!payload_is_known(payload)) {
+		if (!binop_postprocess(ctx, expr, &expr->left) &&
+		    !payload_is_known(payload) &&
+		    !payload_expr_trim_force(payload,
+					     mask, &shift)) {
 			mpz_set(mask->value, tmp);
 			mpz_clear(tmp);
 			return;
 		}
 
+		if (shift)
+			mpz_rshift_ui(value->value, shift);
+
 		mpz_clear(tmp);
 		expr_free(stmt->payload.expr);
 		stmt->payload.expr = expr_get(payload);
@@ -3237,6 +3253,7 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 
 		switch (expr->op) {
 		case OP_AND: { /* IIa */
+			unsigned int shift_unused;
 			mpz_t tmp;
 
 			mpz_init(tmp);
@@ -3248,7 +3265,8 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 			mpz_clear(bitmask);
 
 			stmt_payload_binop_pp(ctx, expr);
-			if (!payload_is_known(expr->left)) {
+			if (!payload_is_known(expr->left) &&
+			    !payload_expr_trim_force(expr->left, mask, &shift_unused)) {
 				mpz_set(mask->value, tmp);
 				mpz_clear(tmp);
 				return;
@@ -3260,6 +3278,7 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 			 * clear the payload expression.
 			 * The "mask" value becomes new stmt->payload.value
 			 * so set this to 0.
+			 * Also the reason why &shift_unused is ignored.
 			 */
 			mpz_set_ui(mask->value, 0);
 			break;
diff --git a/src/payload.c b/src/payload.c
index 44aa834cc07b..f8b192b5f2fa 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -1046,6 +1046,7 @@ static unsigned int mask_length(const struct expr *mask)
  * @expr:	the payload expression
  * @mask:	mask to use when searching templates
  * @ctx:	protocol context
+ * @shift:	shift adjustment to fix up RHS value
  *
  * Walk the template list and determine if a match can be found without
  * using the provided mask.
@@ -1106,6 +1107,59 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
 	return false;
 }
 
+/**
+ * payload_expr_trim_force - adjust payload len/offset according to mask
+ *
+ * @expr:	the payload expression
+ * @mask:	mask to use when searching templates
+ * @shift:	shift adjustment to fix up RHS value
+ *
+ * Force-trim an unknown payload expression according to mask.
+ *
+ * This is only useful for unkown payload expressions that need
+ * to be printed in raw syntax (@base,offset,length).  The kernel
+ * can only deal with byte-divisible offsets/length, e.g. @th,16,8.
+ * In such case we might be able to get rid of the mask.
+ * @base,offset,length & MASK OPERATOR VALUE then becomes
+ * @base,offset,length VALUE, where at least one of offset increases
+ * and length decreases.
+ *
+ * This function also returns the shift for the right hand
+ * constant side of the expression.
+ *
+ * @return: true if @expr was adjusted and mask can be discarded.
+ */
+bool payload_expr_trim_force(struct expr *expr, struct expr *mask, unsigned int *shift)
+{
+	unsigned int payload_offset = expr->payload.offset;
+	unsigned int mask_len = mask_length(mask);
+	unsigned int off, real_len;
+
+	if (payload_is_known(expr) || expr->len <= mask_len)
+		return false;
+
+	/* This provides the payload offset to use.
+	 * mask->len is the total length of the mask, e.g. 16.
+	 * mask_len holds the last bit number that will be zeroed,
+	 */
+	off = round_up(mask->len, BITS_PER_BYTE) - mask_len;
+	payload_offset += off;
+
+	/* kernel only allows offsets <= 255 */
+	if (round_up(payload_offset, BITS_PER_BYTE) > 255)
+		return false;
+
+	real_len = mpz_popcount(mask->value);
+	if (real_len > expr->len)
+		return false;
+
+	expr->payload.offset = payload_offset;
+	expr->len = real_len;
+
+	*shift = mask_to_offset(mask);
+	return true;
+}
+
 /**
  * payload_expr_expand - expand raw merged adjacent payload expressions into its
  * 			 original components
-- 
2.45.3

