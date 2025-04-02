Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C02B2356B5
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743605515; cv=none; b=Iyg5jg7zYnqmidxjpxmn6vgpQdRHl02txuPrpJ+NjD2eN8LAtbHQ3a2T7Eygx0g8lU26pkBbxOvtXTWLm5hbWsaSFwRTOvJB+X1O0MVYpP57aAp1HZYZtLy/WS45r8/RbBssEd5SGwRC1Gw5mSxlr6JXAesSJBuNLe5CSzvg3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743605515; c=relaxed/simple;
	bh=G3ODJLwoJFVv/uS/XoLN2oEjUzFRwkC9eDK+5kWY5js=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WOzvC1mxwvEEy0ywoJWRcxM2570u+iWmiP7nUl91sM2VDCRSVwi5XlXg9qx4iQEd3xmqFOR3whQfi4cCx3R5hq0U5nsnFm/20flUE1RklGjcrujDVyxCPCPIK7UOgCrvFiJqxgTsUYnMtRqgkQKfsSkL+jsJj43tm88qSqUWzgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzzRP-0003Kt-PH; Wed, 02 Apr 2025 16:51:43 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: rename recursion counter to recursion.binop
Date: Wed,  2 Apr 2025 16:50:39 +0200
Message-ID: <20250402145045.4637-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing recursion counter is only used by the binop expression
to detect if we've completely followed all the binops.

We can only chain up to NFT_MAX_EXPR_RECURSION binops, but
the evaluation step can perform constant-folding, so we must
first recurse until we found the rightmost (last) binop in the
chain.

Then we can check the post-eval chain to see if it is something
that can be serialized later or not.

Thus we can't reuse the existing ctx->recursion counter for
other expressions; entering the initial expr_evaluate_binop with
ctx->recursion > 0 would break things.

Therefore rename this to an embedded structure.
This allows us to add a new recursion counter to the new embedded
structure in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h |  8 ++++++--
 src/evaluate.c | 10 +++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 85a0d9c0b524..e7e80a41506c 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -756,6 +756,10 @@ extern void cmd_free(struct cmd *cmd);
 #include <payload.h>
 #include <expression.h>
 
+struct eval_recursion {
+	uint16_t binop;
+};
+
 /**
  * struct eval_ctx - evaluation context
  *
@@ -767,7 +771,7 @@ extern void cmd_free(struct cmd *cmd);
  * @set:	current set
  * @stmt:	current statement
  * @stmt_len:	current statement template length
- * @recursion:  expr evaluation recursion counter
+ * @recursion:  expr evaluation recursion counters
  * @cache:	cache context
  * @debug_mask: debugging bitmask
  * @ectx:	expression context
@@ -783,7 +787,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	uint32_t		stmt_len;
-	uint32_t		recursion;
+	struct eval_recursion	recursion;
 	struct expr_ctx		ectx;
 	struct proto_ctx	_pctx[2];
 	const struct proto_desc	*inner_desc;
diff --git a/src/evaluate.c b/src/evaluate.c
index f73edc916406..d099be137cb3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1518,11 +1518,11 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	unsigned int max_shift_len = ctx->ectx.len;
 	int ret = -1;
 
-	if (ctx->recursion >= USHRT_MAX)
+	if (ctx->recursion.binop >= USHRT_MAX)
 		return expr_binary_error(ctx->msgs, op, NULL,
 					 "Binary operation limit %u reached ",
-					 ctx->recursion);
-	ctx->recursion++;
+					 ctx->recursion.binop);
+	ctx->recursion.binop++;
 
 	if (expr_evaluate(ctx, &op->left) < 0)
 		return -1;
@@ -1607,7 +1607,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 
-	if (ctx->recursion == 0)
+	if (ctx->recursion.binop == 0)
 		BUG("recursion counter underflow");
 
 	/* can't check earlier: evaluate functions might do constant-merging + expr_free.
@@ -1615,7 +1615,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	 * So once we've evaluate everything check for remaining length of the
 	 * binop chain.
 	 */
-	if (--ctx->recursion == 0) {
+	if (--ctx->recursion.binop == 0) {
 		unsigned int to_linearize = 0;
 
 		op = *expr;
-- 
2.49.0

