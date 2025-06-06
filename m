Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FC62882DC
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Jun 2025 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749211996; cv=none; b=Koqs+CbKUfPMWl589WnD0X4kDV22fmsg7nS4xWTumKtf4PHEl6G0JeMNL7y+kVSaem3uyqNGWDbLDiL+U+52B419clBd8XAyIfBHiMElWlwi4BwmVmRAdXZpD/XocMm5bz0rUAj5zfN0+Wl3We91iOEZRnC2CquQDPRFCaoh7jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749211996; c=relaxed/simple;
	bh=ZVuqmDLKnmHi4/LbdwA3xfJzdC/jbYRZjOCpOa9t7mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUSgusSe8t5vtLqOT3w0CB6binEit76artu9hrOwTZAfa3KNPpSC+Ssjk30h5XqTfb7NuSXYH76+IABnNPMHsSu1sIWumXR8Q7hXv5GPvA3hbJbOsKIdIazGYEuWYiVMjDFgyje8HlnzyvT+e78OJWWAU+ORtKzxG4L1eeJq6Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0DB4E60708; Fri,  6 Jun 2025 14:13:13 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 2/2] evaluate: restrict allowed subtypes of concatenations
Date: Fri,  6 Jun 2025 14:12:37 +0200
Message-ID: <20250606121303.17247-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250606121303.17247-1-fw@strlen.de>
References: <20250606121303.17247-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to restrict this, included bogon asserts with:
BUG: unknown expression type prefix
nft: src/netlink_linearize.c:940: netlink_gen_expr: Assertion `0' failed.

Prefix expressions are only allowed if the concatenation is used within
a set element, not when specifying the lookup key.

For the former, anything that represents a value is allowed.
For the latter, only what will generate data (fill a register) is
permitted.

At this time we do not have an annotation that tells if the expression
is on the left hand side (lookup key) or right hand side (set element).

Add a new list recursion counter for this. If its 0 then we're building
the lookup key, if its the latter the concatenation is the RHS part
of a relational expression and prefix, ranges and so on are allowed.

IOW, we don't really need a recursion counter, another type of annotation
that would tell if the expression is placed on the left or right hand side
of another expression would work too.

v2: explicitly list all 'illegal' expression types instead of
using a default label for them.

This will raise a compiler warning to remind us to adjust the case
labels in case a new expression type gets added in the future.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Resending as per our last discussion.
 WRT. to Pablos comment about changing the logic to only explicitly
 deny whats not allowed and accept the rest, I don't like this and
 prefer the conservative approach of denying everything that isn't
 permitted.
 As a compromise, I replaced the 'default' label of v1 with the
 remaining, not-allowed expressions.  This will at least spot a
 warning when a new expression gets added so it can be classified
 (lhs/rhs safe) accordingly.

 I also slightly changed the commit message to say that the counter
 isn't strictly required and just serves as 'is this lhs or rhs'
 indicator.

 include/rule.h                                |  1 +
 src/evaluate.c                                | 61 ++++++++++++++++++-
 .../unknown_expression_type_prefix_assert     |  9 +++
 3 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert

diff --git a/include/rule.h b/include/rule.h
index e7e80a41506c..655d6abaf5fa 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -758,6 +758,7 @@ extern void cmd_free(struct cmd *cmd);
 
 struct eval_recursion {
 	uint16_t binop;
+	uint16_t list;
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 2878a23c24ee..a27c2d0cb2ea 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1642,10 +1642,18 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *next = list_entry((*expr)->list.next, struct expr, list);
 	int err;
 
+	/* should never be hit in practice */
+	if (ctx->recursion.list >= USHRT_MAX)
+		return expr_binary_error(ctx->msgs, next, NULL,
+					 "List limit %u reached ",
+					 ctx->recursion.list);
+
+	ctx->recursion.list++;
 	assert(*expr != next);
 	list_del(&(*expr)->list);
 	err = expr_evaluate(ctx, expr);
 	list_add_tail(&(*expr)->list, &next->list);
+	ctx->recursion.list--;
 	return err;
 }
 
@@ -1708,10 +1716,61 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
-		if (i->etype == EXPR_SET)
+		switch (i->etype) {
+		case EXPR_INVALID:
+		case __EXPR_MAX:
+			BUG("Unexpected etype %d", i->etype);
+			break;
+		case EXPR_VALUE:
+		case EXPR_UNARY:
+		case EXPR_BINOP:
+		case EXPR_RELATIONAL:
+		case EXPR_CONCAT:
+		case EXPR_MAP:
+		case EXPR_PAYLOAD:
+		case EXPR_EXTHDR:
+		case EXPR_META:
+		case EXPR_RT:
+		case EXPR_CT:
+		case EXPR_SET_ELEM:
+		case EXPR_NUMGEN:
+		case EXPR_HASH:
+		case EXPR_FIB:
+		case EXPR_SOCKET:
+		case EXPR_OSF:
+		case EXPR_XFRM:
+			break;
+		case EXPR_RANGE:
+		case EXPR_PREFIX:
+			/* allowed on RHS (e.g. th dport . mark { 1-65535 . 42 }
+			 *                                       ~~~~~~~~ allowed
+			 * but not on LHS (e.g  1-4 . mark { ...}
+			 *                      ~~~ illegal
+			 *
+			 * recursion.list > 0 means that the concatenation is
+			 * part of another expression, such as EXPR_MAPPING or
+			 * EXPR_SET_ELEM (is used as RHS).
+			 */
+			if (ctx->recursion.list > 0)
+				break;
+
+			return expr_error(ctx->msgs, i,
+					  "cannot use %s in concatenation",
+					  expr_name(i));
+		case EXPR_VERDICT:
+		case EXPR_SYMBOL:
+		case EXPR_VARIABLE:
+		case EXPR_LIST:
+		case EXPR_SET:
+		case EXPR_SET_REF:
+		case EXPR_MAPPING:
+		case EXPR_SET_ELEM_CATCHALL:
+		case EXPR_RANGE_VALUE:
+		case EXPR_RANGE_SYMBOL:
 			return expr_error(ctx->msgs, i,
 					  "cannot use %s in concatenation",
 					  expr_name(i));
+		}
 
 		if (!i->dtype)
 			return expr_error(ctx->msgs, i,
diff --git a/tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert b/tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert
new file mode 100644
index 000000000000..d7f8526092a5
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/unknown_expression_type_prefix_assert
@@ -0,0 +1,9 @@
+table t {
+	set sc {
+		type inet_service . ifname
+	}
+
+	chain c {
+		tcp dport . bla* @sc accept
+	}
+}
-- 
2.49.0

