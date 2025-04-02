Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D0E231A4D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 06:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743575149; cv=none; b=I5UScCRCzZ1ao3k5RcgAnZjWiyMd1DxZbalLZVw5AFdTblFLxog3V01gr6aX601EtvuMHFF/dlRU9n6u/Lsik8fkR3ftTmPtOgr66ALeMF7om2dRNmpw5pRKH3E1kBYZUVLdd0zwQU7QlkMN/DR427jsYbsAiqkLieyXKA8nejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743575149; c=relaxed/simple;
	bh=Iwhy+tqVoBbvrz/cJEuEQ/JVHG1ZmEDx408/y/7t5Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dhOZbniUErmyZEsSrVuvfJxmLhONQW3tAsfkHavKVslofpyVULTFnJNcXwGf5ootaflrQq3BXWPEH/tWkzVgm4pW+iGnhN+zEn8GI3ArrOhdax6pXm+SvuU/KrNhGCkIGEvN5VPlVU3/ppaCV5lpBn8mViCeQlF6OjvLva1TJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tzrXl-0007Rv-8T; Wed, 02 Apr 2025 08:25:45 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_json: only allow concatenations with 2 or more expressions
Date: Wed,  2 Apr 2025 07:18:18 +0200
Message-ID: <20250402051820.9653-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bison grammar enforces this implicitly by grammar rules, e.g.
"mark . ip saddr" or similar, i.e., ALL concatenation expressions
consist of at least two elements.

But this doesn't apply to the json frontend which just uses an
array: it can be empty or only contain one element.

The included reproducer makes the eval stage set the "concatenation" flag
on the interval set.  This prevents the needed conversion code to turn the
element values into ranges from getting run.

The reproducer asserts with:
nft: src/intervals.c:786: setelem_to_interval: Assertion `key->etype == EXPR_RANGE_VALUE' failed.

Convert the assertion to BUG() so we can see what element type got passed
to the set interval code in case we have further issues in this area.

Reject 0-or-1-element concatenations from the json parser.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/intervals.c                               |  4 ++-
 src/parser_json.c                             | 20 ++++++++------
 .../set_with_single_value_concat_assert       | 26 +++++++++++++++++++
 3 files changed, 41 insertions(+), 9 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert

diff --git a/src/intervals.c b/src/intervals.c
index 71ad210bf759..1ab443bcde87 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -783,7 +783,9 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 			next_key = NULL;
 	}
 
-	assert(key->etype == EXPR_RANGE_VALUE);
+	if (key->etype != EXPR_RANGE_VALUE)
+		BUG("key must be RANGE_VALUE, not %s\n", expr_name(key));
+
 	assert(!next_key || next_key->etype == EXPR_RANGE_VALUE);
 
 	/* skip end element for adjacents intervals in anonymous sets. */
diff --git a/src/parser_json.c b/src/parser_json.c
index 94d09212314f..724cba881623 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1251,6 +1251,16 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 	return binop_expr_alloc(int_loc, thisop, left, right);
 }
 
+static struct expr *json_check_concat_expr(struct json_ctx *ctx, struct expr *e)
+{
+	if (e->size >= 2)
+		return e;
+
+	json_error(ctx, "Concatenation with %d elements is illegal", e->size);
+	expr_free(e);
+	return NULL;
+}
+
 static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
 					   const char *type, json_t *root)
 {
@@ -1284,7 +1294,7 @@ static struct expr *json_parse_concat_expr(struct json_ctx *ctx,
 		}
 		compound_expr_add(expr, tmp);
 	}
-	return expr;
+	return expr ? json_check_concat_expr(ctx, expr) : NULL;
 }
 
 static struct expr *json_parse_prefix_expr(struct json_ctx *ctx,
@@ -1748,13 +1758,7 @@ static struct expr *json_parse_dtype_expr(struct json_ctx *ctx, json_t *root)
 			compound_expr_add(expr, i);
 		}
 
-		if (list_empty(&expr->expressions)) {
-			json_error(ctx, "Empty concatenation");
-			expr_free(expr);
-			return NULL;
-		}
-
-		return expr;
+		return json_check_concat_expr(ctx, expr);
 	} else if (json_is_object(root)) {
 		const char *key;
 		json_t *val;
diff --git a/tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert b/tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert
new file mode 100644
index 000000000000..c99a26683470
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/set_with_single_value_concat_assert
@@ -0,0 +1,26 @@
+{
+  "nftables": [
+    {
+  "metainfo": {
+   "version": "nftables", "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+	"family": "ip",
+	"name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "t",
+	"type": [ "ifname" ],
+        "flags": [ "interval" ],
+        "elem": [ [] ]
+      }
+    }
+  ]
+}
-- 
2.49.0

