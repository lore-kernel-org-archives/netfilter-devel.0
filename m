Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16978302CBA
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750949563; cv=none; b=mv35KZmD6rxiXnGxaP5XajjpJZ9P98+dfgWBZnAYKNUfHRRLo8rAWnkfVauMS50icT0k7VCsoMZF7OlECxVLqcC94kVYhWWSeTBPvHVjQTlkbWCum1gqFmItGurwrncUXN7VGeYpJVQOzFPR5qvbeO8l0vGSFuOJpZEWaG+28mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750949563; c=relaxed/simple;
	bh=k8eR2xH8CBvp/ur9fs4LIEGIAd1lAaayONS1QF27bgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j+zdoLyy9iqHk/dCNfPp+lnuarw0kv4OjEDBDa1yGgjxvOMFisG/SMVQrR9g9/PREOnSa5LgFWkpqLrueAfXk6Y1MNlV6WJB+I78aWkgm0FBqvzXYYxHx8DaaSJV5Cy8teCA2EsqdpxLkQDoUOwOwDuIBhVV4R4AgME7xOV2WsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D63CE6048A; Thu, 26 Jun 2025 16:52:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: check element key vs. set definition
Date: Thu, 26 Jun 2025 16:52:31 +0200
Message-ID: <20250626145234.11360-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon asserts with:
 src/datatype.c:253: symbolic_constant_print: Assertion `expr->len / BITS_PER_BYTE <= sizeof(val)' failed.

Resolve this by validating that the set element key matches the set key
definition.

After this, loading the bogon file gives:
Error: Element mismatches set definition, expected concatenation of (IPv4 address, integer), not 'ICMP type'
elements = {redirect }
           ^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Alternative is to get rid of the assert() in symbolic_constant_print()
 and fall back to printing the raw integer number.

 src/evaluate.c                                | 30 ++++++++++++++-----
 .../nft-f/symbolic_constant_print_assert      |  7 +++++
 2 files changed, 30 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/symbolic_constant_print_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index a2d5d7c29514..4386e015f0a9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1917,6 +1917,23 @@ static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 	return 0;
 }
 
+static bool datatype_compatible(const struct datatype *a, const struct datatype *b)
+{
+	return (a->type == TYPE_MARK &&
+		datatype_equal(datatype_basetype(a), datatype_basetype(b))) ||
+		datatype_equal(a, b);
+}
+
+static bool elem_key_compatible(const struct expr *set_key,
+				const struct expr *elem_key)
+{
+	/* Catchall element is always compatible with the set key declaration */
+	if (elem_key->etype == EXPR_SET_ELEM_CATCHALL)
+		return true;
+
+	return datatype_compatible(set_key->dtype, elem_key->dtype);
+}
+
 static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *elem = *expr;
@@ -1959,6 +1976,12 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		}
 	}
 
+	if (ctx->set && !elem_key_compatible(ctx->ectx.key, elem->key))
+		return expr_error(ctx->msgs, elem,
+				  "Element mismatches %s definition, expected %s, not '%s'",
+				  set_is_map(ctx->set->flags) ? "map" : "set",
+				  ctx->ectx.key->dtype->desc, elem->key->dtype->desc);
+
 	datatype_set(elem, elem->key->dtype);
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
@@ -2169,13 +2192,6 @@ static int mapping_expr_expand(struct eval_ctx *ctx)
 	return 0;
 }
 
-static bool datatype_compatible(const struct datatype *a, const struct datatype *b)
-{
-	return (a->type == TYPE_MARK &&
-		datatype_equal(datatype_basetype(a), datatype_basetype(b))) ||
-		datatype_equal(a, b);
-}
-
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *map = *expr, *mappings;
diff --git a/tests/shell/testcases/bogons/nft-f/symbolic_constant_print_assert b/tests/shell/testcases/bogons/nft-f/symbolic_constant_print_assert
new file mode 100644
index 000000000000..e01fb3beda29
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/symbolic_constant_print_assert
@@ -0,0 +1,7 @@
+table inet t {
+        set y {
+                typeof ip daddr . @ih,32,35
+                elements = {redirect }
+        }
+}
+reset   rules
-- 
2.49.0

