Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9A825A2A7
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2025 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749211993; cv=none; b=avVUS/TlR3I+57vIArWjHVPHN4M9bVV6iXhzxm5pgXToLF9CgrCEcRN4CuSntlyVLizH+GRTbqm3nTNRDQOTVdRNgDS7TasIiuVhtGNuoLjqvm9Lf4iwVhJZwUiFpkrt23tDZ1NlN0k/HFsK8IiajWodkX7jHMwdNZC4StCkvFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749211993; c=relaxed/simple;
	bh=75vfgefx1gaxbK+NvyqVXqNSW23x3EqJThHBOgif/yA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qqV36273Ct9hN+BTa0jtLfoFP62PoijlzWeWOdTyvqI3bpRIF1ntmlNg5AjMygsuM4re01yuZco5a+sA4jZtuZJ9VltYv3F048T0v6GO0baucUruwO3gnujRpXbwO2aBXqEZKlhVN2HPWTwXaO4RC+7vAkpZsWa6TfAFYVGd3wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AB9DA60704; Fri,  6 Jun 2025 14:13:08 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 1/2] evaluate: rename recursion counter to recursion.binop
Date: Fri,  6 Jun 2025 14:12:36 +0200
Message-ID: <20250606121303.17247-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing recursion counter is used by the binop expression to detect
if we've completely followed all the binops.

We can only chain up to NFT_MAX_EXPR_RECURSION binops, but the evaluation
step can perform constant-folding, so we must recurse until we found the
rightmost (last) binop in the chain.

Then we can check the post-eval chain to see if it is something that can
be serialized later (i.e., if we are within the NFT_MAX_EXPR_RECURSION
after constant folding) or not.

Thus we can't reuse the existing ctx->recursion counter for other
expressions; entering the initial expr_evaluate_binop with
ctx->recursion > 0 would break things.

Therefore rename this to an embedded structure.
This allows us to add a new recursion counter in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: I'm resending this as per last discussion.
 There are no changes in this patch.

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
index e8e4aa2df4ca..2878a23c24ee 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1522,11 +1522,11 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
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
@@ -1611,7 +1611,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 
-	if (ctx->recursion == 0)
+	if (ctx->recursion.binop == 0)
 		BUG("recursion counter underflow");
 
 	/* can't check earlier: evaluate functions might do constant-merging + expr_free.
@@ -1619,7 +1619,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 	 * So once we've evaluate everything check for remaining length of the
 	 * binop chain.
 	 */
-	if (--ctx->recursion == 0) {
+	if (--ctx->recursion.binop == 0) {
 		unsigned int to_linearize = 0;
 
 		op = *expr;
-- 
2.49.0

