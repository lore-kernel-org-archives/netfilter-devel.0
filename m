Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F122356B5
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743605517; cv=none; b=a2I+XSjeVLO4N8BNsK/m2uVZDGVZEMJ7xSpF/Zk013XXz/Q6VLt5xB/ns1ZHAXQoLcFFe0iUSzJIWBppFzGk+9KzFB77aOx54Ppfxd/lhOTFyh8t24GFmfMG3pxhLQIweNbEbm10pAH2Srl6BETff1jcBB/J6IQY5NNTdZHxd+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743605517; c=relaxed/simple;
	bh=6K/ihxXxbOypn+hl3ifPXqjAKqQnXG9dr6koNfa+Ogc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVGtsdJ0hbfY4iGRqQjtCsD1rSImAVO7KwqmjK6932hGoUHlgqPnAbaZUSBP9xPboMOpJOzYeJRFhJ/hp3npIyq81ds07pFxPirENt1WoHD0FujAp6gPT0hYSGeaxL12jxsN3WnHluekAiI8RcZ5F5kF4WPL9zeuz1MPWUBu+6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzzRU-0003LE-4j; Wed, 02 Apr 2025 16:51:48 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] evaluate: restrict allowed subtypes of concatenations
Date: Wed,  2 Apr 2025 16:50:40 +0200
Message-ID: <20250402145045.4637-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250402145045.4637-1-fw@strlen.de>
References: <20250402145045.4637-1-fw@strlen.de>
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

Add a new list recursion counter for this. If its 0 then we're building
the lookup key, if its the latter the concatenation is the RHS part
of a relational expression and prefix, ranges and so on are allowed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h                                |  1 +
 src/evaluate.c                                | 42 ++++++++++++++++++-
 .../unknown_expression_type_prefix_assert     |  9 ++++
 3 files changed, 51 insertions(+), 1 deletion(-)
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
index d099be137cb3..0c8af09492d1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1638,10 +1638,12 @@ static int list_member_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *next = list_entry((*expr)->list.next, struct expr, list);
 	int err;
 
+	ctx->recursion.list++;
 	assert(*expr != next);
 	list_del(&(*expr)->list);
 	err = expr_evaluate(ctx, expr);
 	list_add_tail(&(*expr)->list, &next->list);
+	ctx->recursion.list--;
 	return err;
 }
 
@@ -1704,10 +1706,48 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
-		if (i->etype == EXPR_SET)
+		switch (i->etype) {
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
+		default:
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

