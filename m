Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA924F1E3
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2024 12:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705668450; cv=none; b=R+yjlZXPiwHDbf6yS+69Md7ipPLXaB99Chi48HDAFoieobfQhM2uKJeHY/LmqlLCMCe6TK/fITv9uAekHsYq5K9H6winp392NtpLUBD2TmfbEMv1lRx+V8fQDdfdjY5V8YlZmbQjz5Hst/MQZSNp1RpIqV6+spEHU4SSrQgCMGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705668450; c=relaxed/simple;
	bh=zAeXqafQciZDhnUQUjVIwVPCx7pXtRJ4bV3TCavPEBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB7smpu+YLi1eL/iNTmy7gQArbWOvcBGb+RVISimvSi3FLMObPl/7nIsIjmS/Hjh2dgbCvGbtTYxcBP4ZxTZUi9pB8qKC7EO6lQ1QZK0dT3gZ5TrCj4fVVaPLSZQN+YhG3d3JXYdJGIKr6xXFU7BW/Jv4uHYEOfmzmKgGU5xl0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rQoHP-00083i-2c; Fri, 19 Jan 2024 13:47:27 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] evaluate: permit use of host-endian constant values in set lookup keys
Date: Fri, 19 Jan 2024 13:47:09 +0100
Message-ID: <20240119124713.6506-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240119124713.6506-1-fw@strlen.de>
References: <20240119124713.6506-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AFL found following crash:

table ip filter {
	map ipsec_in {
		typeof ipsec in reqid . iif : verdict
		flags interval
	}

	chain INPUT {
		type filter hook input priority filter; policy drop;
		ipsec in reqid . 0 @ipsec_in
	}
}

Which yields:
nft: evaluate.c:1213: expr_evaluate_unary: Assertion `!expr_is_constant(arg)' failed.

All existing test cases with constant values use big endian values, but
"iif" expects host endian values.

As raw values were not supported before, concat byteorder conversion
doesn't handle constants.

Fix this:

1. Add constant handling so that the number is converted in-place,
   without unary expression.

2. Add the inverse handling on delinearization for non-interval set
   types.
   When dissecting the concat data soup, watch for integer constants where
   the datatype indicates host endian integer.

Last, extend an existing test case with the afl input to cover
in/output.

A new test case is added to test linearization, delinearization and
matching.

Fixes: b422b07ab2f9 ("src: permit use of constant values in set lookup keys")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 65 ++++++++++---------
 src/netlink_delinearize.c                     | 27 ++++++--
 .../packetpath/dumps/set_lookups.nft          | 51 +++++++++++++++
 tests/shell/testcases/packetpath/set_lookups  | 64 ++++++++++++++++++
 .../sets/dumps/typeof_sets_concat.nft         | 11 ++++
 5 files changed, 180 insertions(+), 38 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/set_lookups.nft
 create mode 100755 tests/shell/testcases/packetpath/set_lookups

diff --git a/src/evaluate.c b/src/evaluate.c
index 5a25916506fc..3cfbb6c10767 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -174,42 +174,12 @@ static enum ops byteorder_conversion_op(struct expr *expr,
 	    expr->byteorder, byteorder);
 }
 
-static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
-				enum byteorder byteorder)
+static int byteorder_convert_expr(struct eval_ctx *ctx, struct expr **expr,
+				  enum byteorder byteorder)
 {
 	enum datatypes basetype;
 	enum ops op;
 
-	assert(!expr_is_constant(*expr) || expr_is_singleton(*expr));
-
-	if ((*expr)->byteorder == byteorder)
-		return 0;
-
-	/* Conversion for EXPR_CONCAT is handled for single composing ranges */
-	if ((*expr)->etype == EXPR_CONCAT) {
-		struct expr *i, *next, *unary;
-
-		list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
-			if (i->byteorder == BYTEORDER_BIG_ENDIAN)
-				continue;
-
-			basetype = expr_basetype(i)->type;
-			if (basetype == TYPE_STRING)
-				continue;
-
-			assert(basetype == TYPE_INTEGER);
-
-			op = byteorder_conversion_op(i, byteorder);
-			unary = unary_expr_alloc(&i->location, op, i);
-			if (expr_evaluate(ctx, &unary) < 0)
-				return -1;
-
-			list_replace(&i->list, &unary->list);
-		}
-
-		return 0;
-	}
-
 	basetype = expr_basetype(*expr)->type;
 	switch (basetype) {
 	case TYPE_INTEGER:
@@ -235,6 +205,37 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	return 0;
 }
 
+static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
+				enum byteorder byteorder)
+{
+	assert(!expr_is_constant(*expr) || expr_is_singleton(*expr));
+
+	if ((*expr)->byteorder == byteorder)
+		return 0;
+
+	/* Conversion for EXPR_CONCAT is handled for single composing ranges */
+	if ((*expr)->etype == EXPR_CONCAT) {
+		struct expr *i, *next;
+
+		list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
+			struct expr *unary = i;
+
+			if (i->byteorder == BYTEORDER_BIG_ENDIAN)
+				continue;
+
+			if (byteorder_convert_expr(ctx, &unary, byteorder) < 0)
+				return -1;
+
+			if (i != unary)
+				list_replace(&i->list, &unary->list);
+		}
+
+		return 0;
+	}
+
+	return byteorder_convert_expr(ctx, expr, byteorder);
+}
+
 static int table_not_found(struct eval_ctx *ctx)
 {
 	struct table *table;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 27630a8a9b34..fe0bbc49e0d3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2720,12 +2720,14 @@ static struct expr *expr_postprocess_string(struct expr *expr)
 	return out;
 }
 
-static void expr_postprocess_value(struct rule_pp_ctx *ctx, struct expr **exprp)
+static void expr_postprocess_value(struct rule_pp_ctx *ctx, struct expr **exprp,
+				   const struct set *set)
 {
+	bool interval = set && set->flags & NFT_SET_INTERVAL;
 	struct expr *expr = *exprp;
 
 	// FIXME
-	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+	if (expr->byteorder == BYTEORDER_HOST_ENDIAN && !interval)
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
 	if (expr_basetype(expr)->type == TYPE_STRING)
@@ -2737,7 +2739,8 @@ static void expr_postprocess_value(struct rule_pp_ctx *ctx, struct expr **exprp)
 		*exprp = bitmask_expr_to_binops(expr);
 }
 
-static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp)
+static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp,
+				    const struct set *set)
 {
 	struct expr *i, *n, *expr = *exprp;
 	unsigned int type = expr->dtype->type, ntype = 0;
@@ -2754,7 +2757,15 @@ static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp
 			expr_set_type(i, dtype, dtype->byteorder);
 		}
 		list_del(&i->list);
-		expr_postprocess(ctx, &i);
+
+		switch (i->etype) {
+		case EXPR_VALUE:
+			expr_postprocess_value(ctx, &i, set);
+			break;
+		default:
+			expr_postprocess(ctx, &i);
+			break;
+		}
 		list_add_tail(&i->list, &tmp);
 
 		ntype = concat_subtype_add(ntype, i->dtype->type);
@@ -2791,7 +2802,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_postprocess(ctx, &i);
 		break;
 	case EXPR_CONCAT:
-		expr_postprocess_concat(ctx, exprp);
+		expr_postprocess_concat(ctx, exprp, NULL);
 		break;
 	case EXPR_UNARY:
 		expr_postprocess(ctx, &expr->arg);
@@ -2864,10 +2875,14 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			return;
 		case EXPR_CONCAT:
 			if (expr->right->etype == EXPR_SET_REF) {
+				const struct set *set = expr->right->set;
+
 				assert(expr->left->dtype == &invalid_type);
 				assert(expr->right->dtype != &invalid_type);
 
 				datatype_set(expr->left, expr->right->dtype);
+				expr_postprocess_concat(ctx, &expr->left, set);
+				break;
 			}
 			expr_postprocess(ctx, &expr->left);
 			break;
@@ -2905,7 +2920,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		payload_dependency_kill(&dl->pdctx, expr, dl->pctx.family);
 		break;
 	case EXPR_VALUE:
-		expr_postprocess_value(ctx, exprp);
+		expr_postprocess_value(ctx, exprp, NULL);
 		break;
 	case EXPR_RANGE:
 		expr_postprocess(ctx, &expr->left);
diff --git a/tests/shell/testcases/packetpath/dumps/set_lookups.nft b/tests/shell/testcases/packetpath/dumps/set_lookups.nft
new file mode 100644
index 000000000000..7566f557bb83
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/set_lookups.nft
@@ -0,0 +1,51 @@
+table ip t {
+	set s {
+		type ipv4_addr . iface_index
+		flags interval
+		elements = { 127.0.0.1 . "lo",
+			     127.0.0.2 . "lo" }
+	}
+
+	set s2 {
+		typeof ip saddr . iif
+		elements = { 127.0.0.1 . "lo",
+			     127.0.0.2 . "lo" }
+	}
+
+	set s3 {
+		type iface_index
+		elements = { "lo" }
+	}
+
+	set s4 {
+		type iface_index
+		flags interval
+		elements = { "lo" }
+	}
+
+	set nomatch {
+		typeof ip saddr . iif
+		elements = { 127.0.0.3 . "lo" }
+	}
+
+	set nomatch2 {
+		type ipv4_addr . iface_index
+		elements = { 127.0.0.2 . 90000 }
+	}
+
+	chain c {
+		type filter hook input priority filter; policy accept;
+		icmp type echo-request ip saddr . iif @s counter packets 1 bytes 84
+		icmp type echo-request ip saddr . "lo" @s counter packets 1 bytes 84
+		icmp type echo-request ip saddr . "lo" @s counter packets 1 bytes 84
+		icmp type echo-request ip saddr . iif @s2 counter packets 1 bytes 84
+		icmp type echo-request ip saddr . "lo" @s2 counter packets 1 bytes 84
+		icmp type echo-request ip saddr . "lo" @s2 counter packets 1 bytes 84
+		icmp type echo-request ip daddr . "lo" @s counter packets 1 bytes 84
+		icmp type echo-request ip daddr . "lo" @s2 counter packets 1 bytes 84
+		icmp type echo-request iif @s3 counter packets 1 bytes 84
+		icmp type echo-request iif @s4 counter packets 1 bytes 84
+		ip daddr . "lo" @nomatch counter packets 0 bytes 0 drop
+		ip daddr . iif @nomatch2 counter packets 0 bytes 0 drop
+	}
+}
diff --git a/tests/shell/testcases/packetpath/set_lookups b/tests/shell/testcases/packetpath/set_lookups
new file mode 100755
index 000000000000..84a0000af665
--- /dev/null
+++ b/tests/shell/testcases/packetpath/set_lookups
@@ -0,0 +1,64 @@
+#!/bin/bash
+
+set -e
+
+$NFT -f /dev/stdin <<"EOF"
+table ip t {
+	set s {
+		type ipv4_addr . iface_index
+		flags interval
+		elements = { 127.0.0.1 . 1 }
+	}
+
+	set s2 {
+		typeof ip saddr . meta iif
+		elements = { 127.0.0.1 . 1 }
+	}
+
+	set s3 {
+		type iface_index
+		elements = { "lo" }
+	}
+
+	set s4 {
+		type iface_index
+		flags interval
+		elements = { "lo" }
+	}
+
+	set nomatch {
+		typeof ip saddr . meta iif
+		elements = { 127.0.0.3 . 1 }
+	}
+
+	set nomatch2 {
+		type ipv4_addr . iface_index
+		elements = { 127.0.0.2 . 90000 }
+	}
+
+	chain c {
+		type filter hook input priority filter;
+		icmp type echo-request ip saddr . meta iif @s counter
+		icmp type echo-request ip saddr . 1 @s counter
+		icmp type echo-request ip saddr . "lo" @s counter
+		icmp type echo-request ip saddr . meta iif @s2 counter
+		icmp type echo-request ip saddr . 1 @s2 counter
+		icmp type echo-request ip saddr . "lo" @s2 counter
+
+		icmp type echo-request ip daddr . "lo" @s counter
+		icmp type echo-request ip daddr . "lo" @s2 counter
+
+		icmp type echo-request meta iif @s3 counter
+		icmp type echo-request meta iif @s4 counter
+
+		ip daddr . 1 @nomatch counter drop
+		ip daddr . meta iif @nomatch2 counter drop
+	}
+}
+EOF
+
+$NFT add element t s { 127.0.0.2 . 1 }
+$NFT add element t s2 { 127.0.0.2 . "lo" }
+
+ip link set lo up
+ping -q -c 1 127.0.0.2 > /dev/null
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft b/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
index dbaf7cdc2d7d..348b58487d5c 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_concat.nft
@@ -10,3 +10,14 @@ table netdev t {
 		ether type != 8021q update @s { ether daddr . 123 timeout 1m } counter packets 0 bytes 0 return
 	}
 }
+table ip t {
+	set s {
+		typeof ipsec in reqid . iif
+		size 16
+		flags interval
+	}
+
+	chain c2 {
+		ipsec in reqid . "lo" @s
+	}
+}
-- 
2.43.0

