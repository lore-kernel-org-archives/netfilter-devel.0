Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466E03E478
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 08:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNTvY-0006qG-8p; Wed, 10 Jan 2024 09:27:08 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft 1/3] intervals: allow low-level interval code to return errors
Date: Wed, 10 Jan 2024 09:26:52 +0100
Message-ID: <20240110082657.1967-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240110082657.1967-1-fw@strlen.de>
References: <20240110082657.1967-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The low-level code cannot return errors, it lacks the list_head to
enqueue error messages to and functions do not return an errnor number.

Problem is that this code resolves this via assert()s, but it turns out
that with malformed rulesets this can trigger at will, evaluation loop
is not enough to protect us.

Change this and replace asserts with actual error messages so
libnftables can handle this without exiting.

Before:
BUG: unhandled key type 13
nft: src/intervals.c:64: setelem_expr_to_range: Assertion `0' failed.

After:
unhandled_key_type_13:4:38-45: Error: unexpected type concat
 ip protocol . th dport { tcp / 22, udp . 67 }
                                    ^^^^^^^^

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 14 ++++-
 src/intervals.c                               | 59 ++++++++++++++-----
 .../bogons/nft-f/unhandled_key_type_13_assert |  5 ++
 3 files changed, 63 insertions(+), 15 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/unhandled_key_type_13_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 41524eef12b7..eac9267a0107 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -94,6 +94,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct cmd *cmd;
 	struct set *set;
 	struct handle h;
+	int err;
 
 	if (set_is_datamap(expr->set_flags))
 		key_fix_dtype_byteorder(key);
@@ -118,7 +119,9 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 		list_add_tail(&cmd->list, &ctx->cmd->list);
 	}
 
-	set_evaluate(ctx, set);
+	err = set_evaluate(ctx, set);
+	if (err < 0)
+		return NULL;
 
 	return set_ref_expr_alloc(&expr->location, set);
 }
@@ -2038,6 +2041,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key, data,
 						    mappings);
+		if (!mappings)
+			return -1;
 
 		if (ectx.len && mappings->set->data->len != ectx.len)
 			BUG("%d vs %d\n", mappings->set->data->len, ectx.len);
@@ -2607,6 +2612,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
 							 right);
+			if (!right)
+				return -1;
+
 			/* fall through */
 		case EXPR_SET_REF:
 			if (rel->left->etype == EXPR_CT &&
@@ -3251,6 +3259,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 	setref = implicit_set_declaration(ctx, stmt->meter.name,
 					  expr_get(key), NULL, set);
+	if (!setref)
+		return -1;
 
 	setref->set->desc.size = stmt->meter.size;
 	stmt->meter.set = setref;
@@ -4530,6 +4540,8 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, NULL, mappings);
+		if (!mappings)
+			return -1;
 		mappings->set->objtype  = stmt->objref.type;
 
 		map->mappings = mappings;
diff --git a/src/intervals.c b/src/intervals.c
index 5a88a8eb20bd..ea39dbb80665 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -13,9 +13,9 @@
 #include <intervals.h>
 #include <rule.h>
 
-static void set_to_range(struct expr *init);
+static int set_to_range(struct list_head *msgs, struct expr *init);
 
-static void setelem_expr_to_range(struct expr *expr)
+static int setelem_expr_to_range(struct list_head *msgs, struct expr *expr)
 {
 	unsigned char data[sizeof(struct in6_addr) * BITS_PER_BYTE];
 	struct expr *key, *value;
@@ -61,8 +61,10 @@ static void setelem_expr_to_range(struct expr *expr)
 		expr->key = key;
 		break;
 	default:
-		BUG("unhandled key type %d\n", expr->key->etype);
+		return expr_error(msgs, expr->key, "unexpected type %s", expr_name(expr->key));
 	}
+
+	return 0;
 }
 
 struct set_automerge_ctx {
@@ -125,24 +127,34 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 	return false;
 }
 
-static void set_sort_splice(struct expr *init, struct set *set)
+static int set_sort_splice(struct list_head *msgs,
+			   struct expr *init, struct set *set)
 {
 	struct set *existing_set = set->existing_set;
+	int err;
+
+	err = set_to_range(msgs, init);
+	if (err)
+		return err;
 
-	set_to_range(init);
 	list_expr_sort(&init->expressions);
 
 	if (!existing_set)
-		return;
+		return 0;
 
 	if (existing_set->init) {
-		set_to_range(existing_set->init);
+		err = set_to_range(msgs, existing_set->init);
+		if (err)
+			return err;
+
 		list_splice_sorted(&existing_set->init->expressions,
 				   &init->expressions);
 		init_list_head(&existing_set->init->expressions);
 	} else {
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
+
+	return 0;
 }
 
 static void setelem_automerge(struct set_automerge_ctx *ctx)
@@ -220,14 +232,19 @@ static struct expr *interval_expr_key(struct expr *i)
 	return elem;
 }
 
-static void set_to_range(struct expr *init)
+static int set_to_range(struct list_head *msgs, struct expr *init)
 {
 	struct expr *i, *elem;
+	int err = 0;
 
 	list_for_each_entry(i, &init->expressions, list) {
 		elem = interval_expr_key(i);
-		setelem_expr_to_range(elem);
+		err = setelem_expr_to_range(msgs, elem);
+		if (err)
+			return err;
 	}
+
+	return err;
 }
 
 int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
@@ -242,14 +259,21 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	struct expr *i, *next, *clone;
 	struct cmd *purge_cmd;
 	struct handle h = {};
+	int err;
 
 	if (set->flags & NFT_SET_MAP) {
-		set_to_range(init);
+		err = set_to_range(msgs, init);
+
+		if (err < 0)
+			return err;
+
 		list_expr_sort(&init->expressions);
 		return 0;
 	}
 
-	set_sort_splice(init, set);
+	err = set_sort_splice(msgs, init, set);
+	if (err)
+		return err;
 
 	ctx.purge = set_expr_alloc(&internal_location, set);
 
@@ -483,12 +507,17 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	LIST_HEAD(del_list);
 	int err;
 
-	set_to_range(init);
+	err = set_to_range(msgs, init);
+	if (err)
+		return err;
+
 	if (set->automerge)
 		automerge_delete(msgs, set, init, debug_mask);
 
 	if (existing_set->init) {
-		set_to_range(existing_set->init);
+		err = set_to_range(msgs, existing_set->init);
+		if (err)
+			return err;
 	} else {
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
@@ -616,7 +645,9 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 	struct expr *i, *n, *clone;
 	int err;
 
-	set_sort_splice(init, set);
+	err = set_sort_splice(msgs, init, set);
+	if (err)
+		return err;
 
 	err = setelem_overlap(msgs, set, init);
 
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
-- 
2.41.0

