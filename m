Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EDF5813B
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft,v2] evaluate: bail out if anonymous concat set defines a non concat expression
Date: Thu, 11 Jan 2024 22:50:22 +0100
Message-Id: <20240111215022.1182-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Iterate over the element list in the anonymous set to validate that all
expressions are concatenations, otherwise bail out.

  ruleset.nft:3:46-53: Error: expression is not a concatenation
               ip protocol . th dport vmap { tcp / 22 : accept, tcp . 80 : drop}
                                             ^^^^^^^^

This is based on a patch from Florian Westphal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Fix compilation warning due to uninitialized cmd reported by Florian.

 src/evaluate.c                                | 33 +++++++++++++++++--
 .../bogons/nft-f/unhandled_key_type_13_assert |  5 +++
 .../nft-f/unhandled_key_type_13_assert_map    |  5 +++
 .../nft-f/unhandled_key_type_13_assert_vmap   |  5 +++
 4 files changed, 46 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_map
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_vmap

diff --git a/src/evaluate.c b/src/evaluate.c
index 877cd551805a..9b94ea8de940 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -106,6 +106,13 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	set->init	= expr;
 	set->automerge	= set->flags & NFT_SET_INTERVAL;
 
+	if (set_evaluate(ctx, set) < 0) {
+		if (set->flags & NFT_SET_MAP)
+			set->init = NULL;
+		set_free(set);
+		return NULL;
+	}
+
 	if (ctx->table != NULL)
 		list_add_tail(&set->list, &ctx->table->sets);
 	else {
@@ -118,8 +125,6 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 		list_add_tail(&cmd->list, &ctx->cmd->list);
 	}
 
-	set_evaluate(ctx, set);
-
 	return set_ref_expr_alloc(&expr->location, set);
 }
 
@@ -2043,6 +2048,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key, data,
 						    mappings);
+		if (!mappings)
+			return -1;
 
 		if (ectx.len && mappings->set->data->len != ectx.len)
 			BUG("%d vs %d\n", mappings->set->data->len, ectx.len);
@@ -2614,6 +2621,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
 							 right);
+			if (!right)
+				return -1;
+
 			/* fall through */
 		case EXPR_SET_REF:
 			if (rel->left->etype == EXPR_CT &&
@@ -3258,6 +3268,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 	setref = implicit_set_declaration(ctx, stmt->meter.name,
 					  expr_get(key), NULL, set);
+	if (!setref)
+		return -1;
 
 	setref->set->desc.size = stmt->meter.size;
 	stmt->meter.set = setref;
@@ -4537,6 +4549,8 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, NULL, mappings);
+		if (!mappings)
+			return -1;
 		mappings->set->objtype  = stmt->objref.type;
 
 		map->mappings = mappings;
@@ -4870,6 +4884,21 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		set->flags |= NFT_SET_CONCAT;
 	}
 
+	if (set_is_anonymous(set->flags) && set->key->etype == EXPR_CONCAT) {
+		struct expr *i;
+
+		list_for_each_entry(i, &set->init->expressions, list) {
+			if ((i->etype == EXPR_SET_ELEM &&
+			     i->key->etype != EXPR_CONCAT &&
+			     i->key->etype != EXPR_SET_ELEM_CATCHALL) ||
+			    (i->etype == EXPR_MAPPING &&
+			     i->left->etype == EXPR_SET_ELEM &&
+			     i->left->key->etype != EXPR_CONCAT &&
+			     i->left->key->etype != EXPR_SET_ELEM_CATCHALL))
+				return expr_error(ctx->msgs, i, "expression is not a concatenation");
+		}
+	}
+
 	if (set_is_datamap(set->flags)) {
 		if (set->data == NULL)
 			return set_error(ctx, set, "map definition does not "
diff --git a/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert b/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert
new file mode 100644
index 000000000000..35eecf607230
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ip protocol . th dport { tcp / 22, udp . 67 }
+	}
+}
diff --git a/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_map b/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_map
new file mode 100644
index 000000000000..3da16ce15886
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_map
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		meta mark set ip protocol . th dport map { tcp / 22 : 1234, udp . 67 : 1234 }
+	}
+}
diff --git a/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_vmap b/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_vmap
new file mode 100644
index 000000000000..f4dc273fdb85
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_vmap
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ip protocol . th dport vmap { tcp / 22 : accept, udp . 67 : drop }
+	}
+}
-- 
2.30.2

