Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD444D58D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 19:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft 3/4] evaluate: bail out if anonymous concat set defines a non concat expression
Date: Wed, 10 Jan 2024 20:42:16 +0100
Message-Id: <20240110194217.484064-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240110194217.484064-1-pablo@netfilter.org>
References: <20240110194217.484064-1-pablo@netfilter.org>
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
 src/evaluate.c                                | 35 ++++++++++++++++++-
 .../bogons/nft-f/unhandled_key_type_13_assert |  5 +++
 .../nft-f/unhandled_key_type_13_assert_map    |  5 +++
 .../nft-f/unhandled_key_type_13_assert_vmap   |  5 +++
 4 files changed, 49 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_map
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert_vmap

diff --git a/src/evaluate.c b/src/evaluate.c
index 8ef1b5e39bdc..b79268e82e4f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -94,6 +94,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct cmd *cmd;
 	struct set *set;
 	struct handle h;
+	int err;
 
 	if (set_is_datamap(expr->set_flags))
 		key_fix_dtype_byteorder(key);
@@ -118,7 +119,15 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 		list_add_tail(&cmd->list, &ctx->cmd->list);
 	}
 
-	set_evaluate(ctx, set);
+	err = set_evaluate(ctx, set);
+	if (err < 0) {
+		list_del(&cmd->list);
+		if (set->flags & NFT_SET_MAP)
+			cmd->set->init = NULL;
+
+		cmd_free(cmd);
+		return NULL;
+	}
 
 	return set_ref_expr_alloc(&expr->location, set);
 }
@@ -2038,6 +2047,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key, data,
 						    mappings);
+		if (!mappings)
+			return -1;
 
 		if (ectx.len && mappings->set->data->len != ectx.len)
 			BUG("%d vs %d\n", mappings->set->data->len, ectx.len);
@@ -2609,6 +2620,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
 							 right);
+			if (!right)
+				return -1;
+
 			/* fall through */
 		case EXPR_SET_REF:
 			if (rel->left->etype == EXPR_CT &&
@@ -3253,6 +3267,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 	setref = implicit_set_declaration(ctx, stmt->meter.name,
 					  expr_get(key), NULL, set);
+	if (!setref)
+		return -1;
 
 	setref->set->desc.size = stmt->meter.size;
 	stmt->meter.set = setref;
@@ -4532,6 +4548,8 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, NULL, mappings);
+		if (!mappings)
+			return -1;
 		mappings->set->objtype  = stmt->objref.type;
 
 		map->mappings = mappings;
@@ -4865,6 +4883,21 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
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

