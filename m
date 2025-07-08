Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A202376E6
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 23:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017049; cv=none; b=hCm7oaYZ/q1zK+UPAu+4EbGWfqsLKfQS0dKB6PWLJS6YcX/d6j5kjoGO4D8gk4juhpL/CPVMlawzjgfxYP6UXNPH0+fPV4OLJJEyu8qp3bFo6bAZtOYAi2zU40pMmur/alRPT9xhaz6m6NNdlOsznBSBdLTv7LMo9xL/5Zjv/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017049; c=relaxed/simple;
	bh=0iPU8cO9cab/spfj1A9N++VIyk7ZjsFi4PT441APe0Y=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NE4xnOPmps7AIGnJv9vDmEnDAVHDqa4EuxexwkCgIOYpoa1Akul2w56DLS/D9U2aTEaEUxfqDDRC2vl3rcqMJ9FwqAbgAFM5DmN6nald5NevNo6/Y5YX4DJf4c79gu6xDqSLbs3KmavQLE4Hl3/eoq/XlR9z8HOpEe7jECKkc6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iM0a3FJ1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sIm0mD1R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iM0a3FJ1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sIm0mD1R"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BEC6D6027A; Wed,  9 Jul 2025 01:24:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017043;
	bh=M9Ib7/d7OqpqbEPq6ADMzd779PxJUgC8IFz3R4d2oe4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iM0a3FJ1o9qB1qC07seQgUn8ziSrvrrNRxucydBtxkoeu8F4Rc4cKBlIO0qTnuTyb
	 Ib/ZOMTkK9W0DzN4EoMaB7NSfehXGkl/BUQCNP3wKby1mjFN9L2J4l8o5fHTXdUQXo
	 0vjJklNxVzDt1JamlTqy17rYCOSCBBTB2+mIVTktwrhIpvipIFooYCgKEpdzgEjnbV
	 jAD8TAotn5zYpkGYzOQ4cFxBy8apR9yLrjYPUifAtH7iOIu7UpkzskOqV4GV+O6FoF
	 Zlc5lIfkFkB2sU9Gg0IZgkx3JI8IwFXKhUNaeDGTyjye1VHCGu2KtsXdA/BCAhOX7Z
	 ZMGBr7Svs1hHg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 29F0E60275
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 01:24:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017041;
	bh=M9Ib7/d7OqpqbEPq6ADMzd779PxJUgC8IFz3R4d2oe4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sIm0mD1Rzdb5TXYQEHufADGdI7UcJO7FLOs0tyiRCejznwket8yFjwKWVDJs2EVaK
	 V3PgLP6GxxaY5KZs16/k2arj+avRB23SbMW/2njq4JizvfrnhUIUC777Yo3rp9uOuh
	 YrSyJtb4fXzmttoGjCVVQEtvv7QDO2/nz3bwyoB64C/RzmdP2BUl7M7euvLREJszTa
	 p4td29w5S+sTDWmmkU0yusGI3T6ZTzVcqy/A7V0F1hJQiVi46gD7+OO4V8c1kHvGZK
	 hg+oYddDzwae3OdTEcjmRw2YVnYpZIJxRYLlG5DeKITE+ABw0oHKjc1P4X2hnBHG17
	 aIoOKSJuhaTDQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] src: detach set, list and concatenation expression layout
Date: Wed,  9 Jul 2025 01:23:54 +0200
Message-Id: <20250708232354.2189045-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250708232354.2189045-1-pablo@netfilter.org>
References: <20250708232354.2189045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These three expressions use the same layout, but they have a different
purpose. Several fields are specific of a given expression:

- set_flags is only required by set expressions.
- field_len and field_count are only used by concatenation expressions.

Add accessors to validate the expression type before accessing the union
fields:

 #define expr_set(__expr)       (assert((__expr)->etype == EXPR_SET), &(__expr)->expr_set)
 #define expr_concat(__expr)    (assert((__expr)->etype == EXPR_CONCAT), &(__expr)->expr_concat)
 #define expr_list(__expr)      (assert((__expr)->etype == EXPR_LIST), &(__expr)->expr_list)

This should help catch subtle bugs due to type confusion.

assert() could be later enabled only in debugging builds to run tests,
keep it by now.

compound_expr_*() still works and it needs the same initial layout for
all of these expressions:

      struct list_head        expressions;
      unsigned int            size;

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h      |  22 +++++--
 src/cmd.c                 |   5 +-
 src/evaluate.c            | 124 +++++++++++++++++++-------------------
 src/expression.c          |  41 +++++++------
 src/intervals.c           |  80 ++++++++++++------------
 src/json.c                |  10 +--
 src/mergesort.c           |   2 +-
 src/mnl.c                 |  12 ++--
 src/monitor.c             |   2 +-
 src/netlink.c             |  26 ++++----
 src/netlink_delinearize.c |  14 ++---
 src/netlink_linearize.c   |   2 +-
 src/optimize.c            |  22 +++----
 src/parser_bison.y        |   2 +-
 src/parser_json.c         |   5 +-
 src/rule.c                |   4 +-
 src/segtree.c             |  22 +++----
 17 files changed, 207 insertions(+), 188 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index f42a0c2b3419..5b60c1b0825e 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -293,14 +293,24 @@ struct expr {
 			struct expr		*prefix;
 			unsigned int		prefix_len;
 		};
-		struct {
-			/* EXPR_CONCAT, EXPR_LIST, EXPR_SET */
+		struct expr_concat {
+			/* EXPR_CONCAT */
 			struct list_head	expressions;
 			unsigned int		size;
-			uint32_t		set_flags;
 			uint8_t			field_len[NFT_REG32_COUNT];
 			uint8_t			field_count;
-		};
+		} expr_concat;
+		struct expr_set {
+			/* EXPR_SET */
+			struct list_head	expressions;
+			unsigned int		size;
+			uint32_t		set_flags;
+		} expr_set;
+		struct expr_list {
+			/* EXPR_LIST */
+			struct list_head	expressions;
+			unsigned int		size;
+		} expr_list;
 		struct {
 			/* EXPR_SET_REF */
 			struct set		*set;
@@ -403,6 +413,10 @@ struct expr {
 	};
 };
 
+#define expr_set(__expr)	(assert((__expr)->etype == EXPR_SET), &(__expr)->expr_set)
+#define expr_concat(__expr)	(assert((__expr)->etype == EXPR_CONCAT), &(__expr)->expr_concat)
+#define expr_list(__expr)	(assert((__expr)->etype == EXPR_LIST), &(__expr)->expr_list)
+
 extern struct expr *expr_alloc(const struct location *loc,
 			       enum expr_types etype,
 			       const struct datatype *dtype,
diff --git a/src/cmd.c b/src/cmd.c
index eb44b986a49a..ff634af2ac24 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -398,8 +398,9 @@ bool nft_cmd_collapse_elems(enum cmd_ops op, struct list_head *cmds,
 	    strcmp(last_cmd->handle.set.name, handle->set.name))
 		return false;
 
-	list_splice_tail_init(&init->expressions, &last_cmd->expr->expressions);
-	last_cmd->expr->size += init->size;
+	list_splice_tail_init(&expr_set(init)->expressions,
+			      &expr_set(last_cmd->expr)->expressions);
+	expr_set(last_cmd->expr)->size += expr_set(init)->size;
 
 	return true;
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index fb6c4e06ae32..1fa4cb784a88 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -191,7 +191,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	if ((*expr)->etype == EXPR_CONCAT) {
 		struct expr *i, *next, *unary;
 
-		list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
+		list_for_each_entry_safe(i, next, &expr_concat(*expr)->expressions, list) {
 			if (i->byteorder == BYTEORDER_BIG_ENDIAN)
 				continue;
 
@@ -1669,12 +1669,12 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 	if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
 		key_ctx = ctx->ectx.key;
-		assert(!list_empty(&ctx->ectx.key->expressions));
-		key = list_first_entry(&ctx->ectx.key->expressions, struct expr, list);
-		expressions = &ctx->ectx.key->expressions;
+		assert(!list_empty(&expr_concat(ctx->ectx.key)->expressions));
+		key = list_first_entry(&expr_concat(ctx->ectx.key)->expressions, struct expr, list);
+		expressions = &expr_concat(ctx->ectx.key)->expressions;
 	}
 
-	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_concat(*expr)->expressions, list) {
 		enum byteorder bo = BYTEORDER_INVALID;
 		unsigned dsize_bytes, dsize = 0;
 
@@ -1798,7 +1798,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		ntype = concat_subtype_add(ntype, i->dtype->type);
 
 		dsize_bytes = div_round_up(dsize, BITS_PER_BYTE);
-		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
+		expr_concat(*expr)->field_len[expr_concat(*expr)->field_count++] = dsize_bytes;
 		size += netlink_padded_len(dsize);
 		if (key && expressions) {
 			if (list_is_last(&key->list, expressions))
@@ -1839,7 +1839,7 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 	mpz_t val;
 
 	mpz_init_set_ui(val, 0);
-	list_for_each_entry_safe(i, next, &list->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_list(list)->expressions, list) {
 		if (list_member_evaluate(ctx, &i) < 0) {
 			mpz_clear(val);
 			return -1;
@@ -1943,7 +1943,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 			key = elem->key;
 			goto err_missing_flag;
 		case EXPR_CONCAT:
-			list_for_each_entry(key, &elem->key->expressions, list) {
+			list_for_each_entry(key, &expr_concat(elem->key)->expressions, list) {
 				switch (key->etype) {
 				case EXPR_PREFIX:
 				case EXPR_RANGE:
@@ -2039,7 +2039,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 	struct expr *set = *expr, *i, *next;
 	const struct expr *elem;
 
-	list_for_each_entry_safe(i, next, &set->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
@@ -2048,12 +2048,12 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		    i->left->key->etype == EXPR_SET) {
 			struct expr *new, *j;
 
-			list_for_each_entry(j, &i->left->key->expressions, list) {
+			list_for_each_entry(j, &expr_set(i->left->key)->expressions, list) {
 				new = mapping_expr_alloc(&i->location,
 							 expr_get(j),
 							 expr_get(i->right));
-				list_add_tail(&new->list, &set->expressions);
-				set->size++;
+				list_add_tail(&new->list, &expr_set(set)->expressions);
+				expr_set(set)->size++;
 			}
 			list_del(&i->list);
 			expr_free(i);
@@ -2071,7 +2071,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 		    elem->key->etype == EXPR_SET) {
 			struct expr *new = expr_get(elem->key);
 
-			set->set_flags |= elem->key->set_flags;
+			expr_set(set)->set_flags |= expr_set(elem->key)->set_flags;
 			list_replace(&i->list, &new->list);
 			expr_free(i);
 			i = new;
@@ -2084,24 +2084,24 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 
 		if (i->etype == EXPR_SET) {
 			/* Merge recursive set definitions */
-			list_splice_tail_init(&i->expressions, &i->list);
+			list_splice_tail_init(&expr_set(i)->expressions, &i->list);
 			list_del(&i->list);
-			set->size      += i->size - 1;
-			set->set_flags |= i->set_flags;
+			expr_set(set)->size      += expr_set(i)->size - 1;
+			expr_set(set)->set_flags |= expr_set(i)->set_flags;
 			expr_free(i);
 		} else if (!expr_is_singleton(i)) {
-			set->set_flags |= NFT_SET_INTERVAL;
+			expr_set(set)->set_flags |= NFT_SET_INTERVAL;
 			if (elem->key->etype == EXPR_CONCAT)
-				set->set_flags |= NFT_SET_CONCAT;
+				expr_set(set)->set_flags |= NFT_SET_CONCAT;
 		}
 	}
 
 	if (ctx->set) {
 		if (ctx->set->flags & NFT_SET_CONCAT)
-			set->set_flags |= NFT_SET_CONCAT;
+			expr_set(set)->set_flags |= NFT_SET_CONCAT;
 	}
 
-	set->set_flags |= NFT_SET_CONSTANT;
+	expr_set(set)->set_flags |= NFT_SET_CONSTANT;
 
 	datatype_set(set, ctx->ectx.dtype);
 	set->len   = ctx->ectx.len;
@@ -2114,13 +2114,15 @@ static int binop_transfer(struct eval_ctx *ctx, struct expr **expr);
 
 static void map_set_concat_info(struct expr *map)
 {
-	map->mappings->set->flags |= map->mappings->set->init->set_flags;
+	map->mappings->set->flags |= expr_set(map->mappings->set->init)->set_flags;
 
 	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
 	    map->map->etype == EXPR_CONCAT) {
-		memcpy(&map->mappings->set->desc.field_len, &map->map->field_len,
+		memcpy(&map->mappings->set->desc.field_len,
+		       &expr_concat(map->map)->field_len,
 		       sizeof(map->mappings->set->desc.field_len));
-		map->mappings->set->desc.field_count = map->map->field_count;
+		map->mappings->set->desc.field_count =
+			expr_concat(map->map)->field_count;
 		map->mappings->flags |= NFT_SET_CONCAT;
 	}
 }
@@ -2137,7 +2139,7 @@ static void __mapping_expr_expand(struct expr *i)
 		i->right = range;
 		break;
 	case EXPR_CONCAT:
-		list_for_each_entry_safe(j, next, &i->right->expressions, list) {
+		list_for_each_entry_safe(j, next, &expr_concat(i->right)->expressions, list) {
 			if (j->etype != EXPR_VALUE)
 				continue;
 
@@ -2159,7 +2161,7 @@ static int mapping_expr_expand(struct eval_ctx *ctx)
 	if (!set_is_anonymous(ctx->set->flags))
 		return 0;
 
-	list_for_each_entry(i, &ctx->set->init->expressions, list) {
+	list_for_each_entry(i, &expr_set(ctx->set->init)->expressions, list) {
 		if (i->etype != EXPR_MAPPING)
 			return expr_error(ctx->msgs, i,
 					  "expected mapping, not %s", expr_name(i));
@@ -2191,7 +2193,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	else if (map->map->etype == EXPR_CONCAT) {
 		struct expr *i;
 
-		list_for_each_entry(i, &map->map->expressions, list) {
+		list_for_each_entry(i, &expr_concat(map->map)->expressions, list) {
 			if (i->etype == EXPR_CT &&
 			    (i->ct.key == NFT_CT_SRC ||
 			     i->ct.key == NFT_CT_DST))
@@ -2212,7 +2214,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 	switch (map->mappings->etype) {
 	case EXPR_SET:
-		set_flags |= mappings->set_flags;
+		set_flags |= expr_set(mappings)->set_flags;
 		/* fallthrough */
 	case EXPR_VARIABLE:
 		if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
@@ -2262,8 +2264,8 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					  "Expression is not a map");
 		}
 
-		if (set_is_interval(map->mappings->set->init->set_flags) &&
-		    !(map->mappings->set->init->set_flags & NFT_SET_CONCAT) &&
+		if (set_is_interval(expr_set(map->mappings->set->init)->set_flags) &&
+		    !(expr_set(map->mappings->set->init)->set_flags & NFT_SET_CONCAT) &&
 		    interval_set_eval(ctx, ctx->set, map->mappings->set->init) < 0)
 			return -1;
 
@@ -2333,7 +2335,7 @@ static bool data_mapping_has_interval(struct expr *data)
 	if (data->etype != EXPR_CONCAT)
 		return false;
 
-	list_for_each_entry(i, &data->expressions, list) {
+	list_for_each_entry(i, &expr_concat(data)->expressions, list) {
 		if (i->etype == EXPR_RANGE ||
 		    i->etype == EXPR_RANGE_VALUE ||
 		    i->etype == EXPR_PREFIX)
@@ -2639,12 +2641,12 @@ static int __binop_transfer(struct eval_ctx *ctx,
 			return -1;
 		break;
 	case EXPR_SET:
-		list_for_each_entry(i, &(*right)->expressions, list) {
+		list_for_each_entry(i, &expr_set(*right)->expressions, list) {
 			err = binop_can_transfer(ctx, left, i);
 			if (err <= 0)
 				return err;
 		}
-		list_for_each_entry_safe(i, next, &(*right)->expressions, list) {
+		list_for_each_entry_safe(i, next, &expr_set(*right)->expressions, list) {
 			list_del(&i->list);
 			err = binop_transfer_one(ctx, left, &i);
 			list_add_tail(&i->list, &next->list);
@@ -2710,7 +2712,7 @@ static void optimize_singleton_set(struct expr *rel, struct expr **expr)
 {
 	struct expr *set = rel->right, *i;
 
-	i = list_first_entry(&set->expressions, struct expr, list);
+	i = list_first_entry(&expr_set(set)->expressions, struct expr, list);
 	if (i->etype == EXPR_SET_ELEM &&
 	    list_empty(&i->stmt_list)) {
 
@@ -2819,7 +2821,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case OP_EQ:
 		case OP_IMPLICIT:
 		case OP_NEQ:
-			if (right->etype == EXPR_SET && right->size == 1)
+			if (right->etype == EXPR_SET && expr_set(right)->size == 1)
 				optimize_singleton_set(rel, &right);
 			break;
 		default:
@@ -2868,14 +2870,14 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				return -1;
 			break;
 		case EXPR_SET:
-			if (right->size == 0)
+			if (expr_set(right)->size == 0)
 				return expr_error(ctx->msgs, right, "Set is empty");
 
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
 							 right,
-							 right->set_flags | NFT_SET_ANONYMOUS);
+							 expr_set(right)->set_flags | NFT_SET_ANONYMOUS);
 			if (!right)
 				return -1;
 
@@ -3633,12 +3635,12 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 		set = set_expr_alloc(&key->location, existing_set);
 		if (key->timeout)
-			set->set_flags |= NFT_SET_TIMEOUT;
+			expr_set(set)->set_flags |= NFT_SET_TIMEOUT;
 
-		set->set_flags |= NFT_SET_EVAL;
+		expr_set(set)->set_flags |= NFT_SET_EVAL;
 		setref = implicit_set_declaration(ctx, stmt->meter.name,
 						  expr_get(key), NULL, set,
-						  NFT_SET_EVAL | set->set_flags);
+						  NFT_SET_EVAL | expr_set(set)->set_flags);
 		if (setref)
 			setref->set->desc.size = stmt->meter.size;
 	}
@@ -4168,7 +4170,7 @@ static bool nat_evaluate_addr_has_th_expr(const struct expr *map)
 	if (concat ->etype != EXPR_CONCAT)
 		return false;
 
-	list_for_each_entry(i, &concat->expressions, list) {
+	list_for_each_entry(i, &expr_concat(concat)->expressions, list) {
 		enum proto_bases base;
 
 		if (i->etype == EXPR_PAYLOAD &&
@@ -4245,7 +4247,7 @@ static void expr_family_infer(struct proto_ctx *pctx, const struct expr *expr,
 	if (expr->etype == EXPR_MAP) {
 		switch (expr->map->etype) {
 		case EXPR_CONCAT:
-			list_for_each_entry(i, &expr->map->expressions, list) {
+			list_for_each_entry(i, &expr_concat(expr->map)->expressions, list) {
 				if (i->etype == EXPR_PAYLOAD) {
 					if (i->payload.desc == &proto_ip)
 						*family = NFPROTO_IPV4;
@@ -4356,10 +4358,10 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 		goto out;
 	}
 
-	one = list_first_entry(&data->expressions, struct expr, list);
+	one = list_first_entry(&expr_concat(data)->expressions, struct expr, list);
 	two = list_entry(one->list.next, struct expr, list);
 
-	if (one == two || !list_is_last(&two->list, &data->expressions)) {
+	if (one == two || !list_is_last(&two->list, &expr_concat(data)->expressions)) {
 		err = __stmt_evaluate_arg(ctx, stmt, dtype, dtype->size,
 					   BYTEORDER_BIG_ENDIAN,
 					   &stmt->nat.addr);
@@ -4397,7 +4399,7 @@ static bool nat_concat_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 	switch (stmt->nat.addr->mappings->etype) {
 	case EXPR_SET:
-		list_for_each_entry(i, &stmt->nat.addr->mappings->expressions, list) {
+		list_for_each_entry(i, &expr_set(stmt->nat.addr->mappings)->expressions, list) {
 			if (i->etype == EXPR_MAPPING &&
 			    i->right->etype == EXPR_CONCAT) {
 				stmt->nat.type_flags |= STMT_NAT_F_CONCAT;
@@ -4867,7 +4869,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 	switch (map->mappings->etype) {
 	case EXPR_SET:
-		set_flags |= mappings->set_flags;
+		set_flags |= expr_set(mappings)->set_flags;
 		/* fallthrough */
 	case EXPR_VARIABLE:
 		key = constant_expr_alloc(&stmt->location,
@@ -4893,8 +4895,8 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					  "Expression is not a map");
 		}
 
-		if (set_is_interval(map->mappings->set->init->set_flags) &&
-		    !(map->mappings->set->init->set_flags & NFT_SET_CONCAT) &&
+		if (set_is_interval(expr_set(map->mappings->set->init)->set_flags) &&
+		    !(expr_set(map->mappings->set->init)->set_flags & NFT_SET_CONCAT) &&
 		    interval_set_eval(ctx, ctx->set, map->mappings->set->init) < 0)
 			return -1;
 
@@ -5054,7 +5056,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 			return -1;
 
 		assert(cmd->expr->etype == EXPR_SET);
-		cmd->expr->set_flags |= NFT_SET_INTERVAL;
+		expr_set(cmd->expr)->set_flags |= NFT_SET_INTERVAL;
 	}
 
 	ctx->set = NULL;
@@ -5082,7 +5084,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 	uint32_t ntype = 0, size = 0;
 	struct expr *i, *next;
 
-	list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_concat(*expr)->expressions, list) {
 		unsigned dsize_bytes;
 
 		if (i->etype == EXPR_CT &&
@@ -5117,7 +5119,7 @@ static int set_expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		if (i->dtype->size)
 			assert(dsize_bytes == div_round_up(i->dtype->size, BITS_PER_BYTE));
 
-		(*expr)->field_len[(*expr)->field_count++] = dsize_bytes;
+		expr_concat(*expr)->field_len[expr_concat(*expr)->field_count++] = dsize_bytes;
 		size += netlink_padded_len(i->len);
 
 		if (size > NFT_MAX_EXPR_LEN_BITS)
@@ -5228,9 +5230,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	}
 
 	if (set->flags & NFT_SET_INTERVAL && set->key->etype == EXPR_CONCAT) {
-		memcpy(&set->desc.field_len, &set->key->field_len,
+		memcpy(&set->desc.field_len, &expr_concat(set->key)->field_len,
 		       sizeof(set->desc.field_len));
-		set->desc.field_count = set->key->field_count;
+		set->desc.field_count = expr_concat(set->key)->field_count;
 		set->flags |= NFT_SET_CONCAT;
 
 		if (set->automerge)
@@ -5240,7 +5242,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	if (set_is_anonymous(set->flags) && set->key->etype == EXPR_CONCAT) {
 		struct expr *i;
 
-		list_for_each_entry(i, &set->init->expressions, list) {
+		list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
 			if ((i->etype == EXPR_SET_ELEM &&
 			     i->key->etype != EXPR_CONCAT &&
 			     i->key->etype != EXPR_SET_ELEM_CATCHALL) ||
@@ -5291,8 +5293,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	if (set_is_anonymous(set->flags)) {
 		if (set->init->etype == EXPR_SET &&
-		    set_is_interval(set->init->set_flags) &&
-		    !(set->init->set_flags & NFT_SET_CONCAT) &&
+		    set_is_interval(expr_set(set->init)->set_flags) &&
+		    !(expr_set(set->init)->set_flags & NFT_SET_CONCAT) &&
 		    interval_set_eval(ctx, set, set->init) < 0)
 			return -1;
 
@@ -5399,7 +5401,7 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 	struct location loc;
 	LIST_HEAD(tmp);
 
-	list_for_each_entry_safe(expr, next, &dev_expr->expressions, list) {
+	list_for_each_entry_safe(expr, next, &expr_set(dev_expr)->expressions, list) {
 		list_del(&expr->list);
 
 		switch (expr->etype) {
@@ -5411,7 +5413,7 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 
 			if (expr->etype == EXPR_SET) {
 				expr = expr_set_to_list(ctx, expr);
-				list_splice_init(&expr->expressions, &tmp);
+				list_splice_init(&expr_list(expr)->expressions, &tmp);
 				expr_free(expr);
 				continue;
 			}
@@ -5433,7 +5435,7 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 	loc = dev_expr->location;
 	expr_free(dev_expr);
 	dev_expr = compound_expr_alloc(&loc, EXPR_LIST);
-	list_splice_init(&tmp, &dev_expr->expressions);
+	list_splice_init(&tmp, &expr_list(dev_expr)->expressions);
 
 	return dev_expr;
 }
@@ -5455,7 +5457,7 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 
 	assert((*dev_expr)->etype == EXPR_LIST);
 
-	list_for_each_entry_safe(expr, next, &(*dev_expr)->expressions, list) {
+	list_for_each_entry_safe(expr, next, &expr_list(*dev_expr)->expressions, list) {
 		list_del(&expr->list);
 
 		switch (expr->etype) {
@@ -5467,7 +5469,7 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 
 			if (expr->etype == EXPR_SET) {
 				expr = expr_set_to_list(ctx, expr);
-				list_splice_init(&expr->expressions, &tmp);
+				list_splice_init(&expr_list(expr)->expressions, &tmp);
 				expr_free(expr);
 				continue;
 			}
@@ -5481,7 +5483,7 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 
 		list_add(&expr->list, &tmp);
 	}
-	list_splice_init(&tmp, &(*dev_expr)->expressions);
+	list_splice_init(&tmp, &expr_list(*dev_expr)->expressions);
 
 	return true;
 }
diff --git a/src/expression.c b/src/expression.c
index aa97413d0794..8cb639797284 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -940,7 +940,7 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
 		if (expr_is_singleton(right))
 			ops->pctx_update(ctx, &expr->location, left, right);
 		else if (right->etype == EXPR_SET) {
-			list_for_each_entry(i, &right->expressions, list) {
+			list_for_each_entry(i, &expr_set(right)->expressions, list) {
 				if (i->etype == EXPR_SET_ELEM &&
 				    i->key->etype == EXPR_VALUE)
 					ops->pctx_update(ctx, &expr->location, left, i->key);
@@ -1022,7 +1022,8 @@ struct expr *compound_expr_alloc(const struct location *loc,
 	struct expr *expr;
 
 	expr = expr_alloc(loc, etype, &invalid_type, BYTEORDER_INVALID, 0);
-	init_list_head(&expr->expressions);
+	/* same layout for EXPR_CONCAT, EXPR_SET and EXPR_LIST. */
+	init_list_head(&expr->expr_set.expressions);
 	return expr;
 }
 
@@ -1030,8 +1031,8 @@ static void compound_expr_clone(struct expr *new, const struct expr *expr)
 {
 	struct expr *i;
 
-	init_list_head(&new->expressions);
-	list_for_each_entry(i, &expr->expressions, list)
+	init_list_head(&new->expr_set.expressions);
+	list_for_each_entry(i, &expr->expr_set.expressions, list)
 		compound_expr_add(new, expr_clone(i));
 }
 
@@ -1039,7 +1040,7 @@ static void compound_expr_destroy(struct expr *expr)
 {
 	struct expr *i, *next;
 
-	list_for_each_entry_safe(i, next, &expr->expressions, list)
+	list_for_each_entry_safe(i, next, &expr->expr_set.expressions, list)
 		expr_free(i);
 }
 
@@ -1049,7 +1050,7 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 	const struct expr *i;
 	const char *d = "";
 
-	list_for_each_entry(i, &expr->expressions, list) {
+	list_for_each_entry(i, &expr->expr_set.expressions, list) {
 		nft_print(octx, "%s", d);
 		expr_print(i, octx);
 		d = delim;
@@ -1058,13 +1059,13 @@ static void compound_expr_print(const struct expr *expr, const char *delim,
 
 void compound_expr_add(struct expr *compound, struct expr *expr)
 {
-	list_add_tail(&expr->list, &compound->expressions);
-	compound->size++;
+	list_add_tail(&expr->list, &compound->expr_set.expressions);
+	compound->expr_set.size++;
 }
 
 void compound_expr_remove(struct expr *compound, struct expr *expr)
 {
-	compound->size--;
+	compound->expr_set.size--;
 	list_del(&expr->list);
 }
 
@@ -1104,7 +1105,7 @@ static int concat_expr_build_udata(struct nftnl_udata_buf *udbuf,
 	struct expr *expr, *tmp;
 	unsigned int i = 0;
 
-	list_for_each_entry_safe(expr, tmp, &concat_expr->expressions, list) {
+	list_for_each_entry_safe(expr, tmp, &expr_concat(concat_expr)->expressions, list) {
 		struct nftnl_udata *nest_expr;
 		int err;
 
@@ -1268,12 +1269,12 @@ struct expr *list_expr_to_binop(struct expr *expr)
 {
 	struct expr *first, *last = NULL, *i;
 
-	assert(!list_empty(&expr->expressions));
+	assert(!list_empty(&expr_list(expr)->expressions));
 
-	first = list_first_entry(&expr->expressions, struct expr, list);
+	first = list_first_entry(&expr_list(expr)->expressions, struct expr, list);
 	i = first;
 
-	list_for_each_entry_continue(i, &expr->expressions, list) {
+	list_for_each_entry_continue(i, &expr_list(expr)->expressions, list) {
 		if (first) {
 			last = binop_expr_alloc(&expr->location, OP_OR, first, i);
 			first = NULL;
@@ -1285,7 +1286,7 @@ struct expr *list_expr_to_binop(struct expr *expr)
 	assert(!first);
 
 	/* zap list expressions, they have been moved to binop expression. */
-	init_list_head(&expr->expressions);
+	init_list_head(&expr_list(expr)->expressions);
 	expr_free(expr);
 
 	return last;
@@ -1300,7 +1301,7 @@ static const char *calculate_delim(const struct expr *expr, int *count,
 	if (octx->force_newline)
 		return newline;
 
-	if (set_is_anonymous(expr->set_flags))
+	if (set_is_anonymous(expr_set(expr)->set_flags))
 		return singleline;
 
 	if (!expr->dtype)
@@ -1348,7 +1349,7 @@ static void set_expr_print(const struct expr *expr, struct output_ctx *octx)
 
 	nft_print(octx, "{ ");
 
-	list_for_each_entry(i, &expr->expressions, list) {
+	list_for_each_entry(i, &expr_set(expr)->expressions, list) {
 		nft_print(octx, "%s", d);
 		expr_print(i, octx);
 		count++;
@@ -1364,7 +1365,7 @@ static void set_expr_set_type(const struct expr *expr,
 {
 	struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_set(expr)->expressions, list)
 		expr_set_type(i, dtype, byteorder);
 }
 
@@ -1385,7 +1386,7 @@ struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
 	if (!set)
 		return set_expr;
 
-	set_expr->set_flags = set->flags;
+	expr_set(set_expr)->set_flags = set->flags;
 	datatype_set(set_expr, set->key->dtype);
 
 	return set_expr;
@@ -1443,10 +1444,10 @@ static bool __set_expr_is_vmap(const struct expr *mappings)
 {
 	const struct expr *mapping;
 
-	if (list_empty(&mappings->expressions))
+	if (list_empty(&expr_set(mappings)->expressions))
 		return false;
 
-	mapping = list_first_entry(&mappings->expressions, struct expr, list);
+	mapping = list_first_entry(&expr_set(mappings)->expressions, struct expr, list);
 	if (mapping->etype == EXPR_MAPPING &&
 	    mapping->right->etype == EXPR_VERDICT)
 		return true;
diff --git a/src/intervals.c b/src/intervals.c
index e5bbb0384964..8c8ce8c8a305 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -88,7 +88,7 @@ static void purge_elem(struct set_automerge_ctx *ctx, struct expr *i)
 			     i->key->range.low,
 			     i->key->range.high);
 	}
-	list_move_tail(&i->list, &ctx->purge->expressions);
+	list_move_tail(&i->list, &expr_set(ctx->purge)->expressions);
 }
 
 static void remove_overlapping_range(struct set_automerge_ctx *ctx,
@@ -101,7 +101,7 @@ static void remove_overlapping_range(struct set_automerge_ctx *ctx,
 	}
 	list_del(&i->list);
 	expr_free(i);
-	ctx->init->size--;
+	expr_set(ctx->init)->size--;
 }
 
 struct range {
@@ -129,7 +129,7 @@ static bool merge_ranges(struct set_automerge_ctx *ctx,
 		mpz_set(prev_range->high, range->high);
 		list_del(&i->list);
 		expr_free(i);
-		ctx->init->size--;
+		expr_set(ctx->init)->size--;
 	}
 	return false;
 }
@@ -139,16 +139,16 @@ static void set_sort_splice(struct expr *init, struct set *set)
 	struct set *existing_set = set->existing_set;
 
 	set_to_range(init);
-	list_expr_sort(&init->expressions);
+	list_expr_sort(&expr_set(init)->expressions);
 
 	if (!existing_set || existing_set->errors)
 		return;
 
 	if (existing_set->init) {
 		set_to_range(existing_set->init);
-		list_splice_sorted(&existing_set->init->expressions,
-				   &init->expressions);
-		init_list_head(&existing_set->init->expressions);
+		list_splice_sorted(&expr_set(existing_set->init)->expressions,
+				   &expr_set(init)->expressions);
+		init_list_head(&expr_set(existing_set->init)->expressions);
 	} else {
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
@@ -174,7 +174,7 @@ static void setelem_automerge(struct set_automerge_ctx *ctx)
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(i, next, &ctx->init->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_set(ctx->init)->expressions, list) {
 		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
 			continue;
 
@@ -237,7 +237,7 @@ static void set_to_range(struct expr *init)
 {
 	struct expr *i, *elem;
 
-	list_for_each_entry(i, &init->expressions, list) {
+	list_for_each_entry(i, &expr_set(init)->expressions, list) {
 		elem = interval_expr_key(i);
 		setelem_expr_to_range(elem);
 	}
@@ -258,7 +258,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 
 	if (set->flags & NFT_SET_MAP) {
 		set_to_range(init);
-		list_expr_sort(&init->expressions);
+		list_expr_sort(&expr_set(init)->expressions);
 		return 0;
 	}
 
@@ -268,9 +268,9 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 
 	setelem_automerge(&ctx);
 
-	list_for_each_entry_safe(i, next, &init->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_set(init)->expressions, list) {
 		if (i->flags & EXPR_F_KERNEL) {
-			list_move_tail(&i->list, &existing_set->init->expressions);
+			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 		} else if (existing_set) {
 			if (debug_mask & NFT_DEBUG_SEGTREE) {
 				pr_gmp_debug("add: [%Zx-%Zx]\n",
@@ -278,11 +278,11 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 			}
 			clone = expr_clone(i);
 			clone->flags |= EXPR_F_KERNEL;
-			list_add_tail(&clone->list, &existing_set->init->expressions);
+			list_add_tail(&clone->list, &expr_set(existing_set->init)->expressions);
 		}
 	}
 
-	if (list_empty(&ctx.purge->expressions)) {
+	if (list_empty(&expr_set(ctx.purge)->expressions)) {
 		expr_free(ctx.purge);
 		return 0;
 	}
@@ -301,7 +301,7 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 
 	if (prev->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
-		list_move_tail(&clone->list, &purge->expressions);
+		list_move_tail(&clone->list, &expr_set(purge)->expressions);
 	}
 }
 
@@ -310,7 +310,7 @@ static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *
 	prev->flags &= ~EXPR_F_KERNEL;
 	mpz_set(prev->key->range.low, i->key->range.high);
 	mpz_add_ui(prev->key->range.low, prev->key->range.low, 1);
-	list_move(&prev->list, &set->existing_set->init->expressions);
+	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
 }
 
 static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
@@ -329,7 +329,7 @@ static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr
 	prev->flags &= ~EXPR_F_KERNEL;
 	mpz_set(prev->key->range.high, i->key->range.low);
 	mpz_sub_ui(prev->key->range.high, prev->key->range.high, 1);
-	list_move(&prev->list, &set->existing_set->init->expressions);
+	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
 }
 
 static void adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
@@ -352,18 +352,18 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 
 	if (prev->flags & EXPR_F_KERNEL) {
 		clone = expr_clone(prev);
-		list_move_tail(&clone->list, &purge->expressions);
+		list_move_tail(&clone->list, &expr_set(purge)->expressions);
 	}
 
 	prev->flags &= ~EXPR_F_KERNEL;
 	clone = expr_clone(prev);
 	mpz_set(clone->key->range.low, i->key->range.high);
 	mpz_add_ui(clone->key->range.low, i->key->range.high, 1);
-	list_add_tail(&clone->list, &set->existing_set->init->expressions);
+	list_add_tail(&clone->list, &expr_set(set->existing_set->init)->expressions);
 
 	mpz_set(prev->key->range.high, i->key->range.low);
 	mpz_sub_ui(prev->key->range.high, i->key->range.low, 1);
-	list_move(&prev->list, &set->existing_set->init->expressions);
+	list_move(&prev->list, &expr_set(set->existing_set->init)->expressions);
 
 	list_del(&i->list);
 	expr_free(i);
@@ -407,7 +407,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(elem, next, &elems->expressions, list) {
+	list_for_each_entry_safe(elem, next, &expr_set(elems)->expressions, list) {
 		i = interval_expr_key(elem);
 
 		if (i->key->etype == EXPR_SET_ELEM_CATCHALL) {
@@ -437,7 +437,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 			if (elem->flags & EXPR_F_REMOVE) {
 				if (prev->flags & EXPR_F_KERNEL) {
 					prev->location = elem->location;
-					list_move_tail(&prev->list, &purge->expressions);
+					list_move_tail(&prev->list, &expr_set(purge)->expressions);
 				}
 
 				list_del(&elem->list);
@@ -476,7 +476,7 @@ static void automerge_delete(struct list_head *msgs, struct set *set,
 	};
 
 	ctx.purge = set_expr_alloc(&internal_location, set);
-	list_expr_sort(&init->expressions);
+	list_expr_sort(&expr_set(init)->expressions);
 	setelem_automerge(&ctx);
 	expr_free(ctx.purge);
 }
@@ -486,8 +486,8 @@ static int __set_delete(struct list_head *msgs, struct expr *i,	struct set *set,
 			unsigned int debug_mask)
 {
 	i->flags |= EXPR_F_REMOVE;
-	list_move_tail(&i->list, &existing_set->init->expressions);
-	list_expr_sort(&existing_set->init->expressions);
+	list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
+	list_expr_sort(&expr_set(existing_set->init)->expressions);
 
 	return setelem_delete(msgs, set, init, existing_set->init, debug_mask);
 }
@@ -513,38 +513,38 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		existing_set->init = set_expr_alloc(&internal_location, set);
 	}
 
-	list_splice_init(&init->expressions, &del_list);
+	list_splice_init(&expr_set(init)->expressions, &del_list);
 
 	list_for_each_entry_safe(i, next, &del_list, list) {
 		err = __set_delete(msgs, i, set, init, existing_set, debug_mask);
 		if (err < 0) {
-			list_splice(&del_list, &init->expressions);
+			list_splice(&del_list, &expr_set(init)->expressions);
 			return err;
 		}
 	}
 
 	add = set_expr_alloc(&internal_location, set);
-	list_for_each_entry(i, &existing_set->init->expressions, list) {
+	list_for_each_entry(i, &expr_set(existing_set->init)->expressions, list) {
 		if (!(i->flags & EXPR_F_KERNEL)) {
 			clone = expr_clone(i);
-			list_add_tail(&clone->list, &add->expressions);
+			list_add_tail(&clone->list, &expr_set(add)->expressions);
 			i->flags |= EXPR_F_KERNEL;
 		}
 	}
 
 	if (debug_mask & NFT_DEBUG_SEGTREE) {
-		list_for_each_entry(i, &init->expressions, list)
+		list_for_each_entry(i, &expr_set(init)->expressions, list)
 			pr_gmp_debug("remove: [%Zx-%Zx]\n",
 				     i->key->range.low, i->key->range.high);
-		list_for_each_entry(i, &add->expressions, list)
+		list_for_each_entry(i, &expr_set(add)->expressions, list)
 			pr_gmp_debug("add: [%Zx-%Zx]\n",
 				     i->key->range.low, i->key->range.high);
-		list_for_each_entry(i, &existing_set->init->expressions, list)
+		list_for_each_entry(i, &expr_set(existing_set->init)->expressions, list)
 			pr_gmp_debug("existing: [%Zx-%Zx]\n",
 				     i->key->range.low, i->key->range.high);
 	}
 
-	if (list_empty(&add->expressions)) {
+	if (list_empty(&expr_set(add)->expressions)) {
 		expr_free(add);
 		return 0;
 	}
@@ -571,7 +571,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 	mpz_init(range.high);
 	mpz_init(rop);
 
-	list_for_each_entry_safe(elem, next, &init->expressions, list) {
+	list_for_each_entry_safe(elem, next, &expr_set(init)->expressions, list) {
 		i = interval_expr_key(elem);
 
 		if (i->key->etype == EXPR_SET_ELEM_CATCHALL)
@@ -640,13 +640,13 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 
 	err = setelem_overlap(msgs, set, init);
 
-	list_for_each_entry_safe(i, n, &init->expressions, list) {
+	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
 		if (i->flags & EXPR_F_KERNEL)
-			list_move_tail(&i->list, &existing_set->init->expressions);
+			list_move_tail(&i->list, &expr_set(existing_set->init)->expressions);
 		else if (existing_set) {
 			clone = expr_clone(i);
 			clone->flags |= EXPR_F_KERNEL;
-			list_add_tail(&clone->list, &existing_set->init->expressions);
+			list_add_tail(&clone->list, &expr_set(existing_set->init)->expressions);
 		}
 	}
 
@@ -665,7 +665,7 @@ static bool segtree_needs_first_segment(const struct set *set,
 		 * 4) This set is created with a number of initial elements.
 		 */
 		if ((set_is_anonymous(set->flags)) ||
-		    (set->init && set->init->size == 0) ||
+		    (set->init && expr_set(set->init)->size == 0) ||
 		    (set->init == NULL && init) ||
 		    (set->init == init)) {
 			return true;
@@ -683,7 +683,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 	LIST_HEAD(intervals);
 	mpz_t p;
 
-	list_for_each_entry_safe(i, n, &init->expressions, list) {
+	list_for_each_entry_safe(i, n, &expr_set(init)->expressions, list) {
 		elem = interval_expr_key(i);
 
 		if (elem->key->etype == EXPR_SET_ELEM_CATCHALL)
@@ -715,7 +715,7 @@ int set_to_intervals(const struct set *set, struct expr *init, bool add)
 		prev = i;
 	}
 
-	list_splice_init(&intervals, &init->expressions);
+	list_splice_init(&intervals, &expr_set(init)->expressions);
 
 	return 0;
 }
diff --git a/src/json.c b/src/json.c
index f0430776851c..5d34b27eb915 100644
--- a/src/json.c
+++ b/src/json.c
@@ -232,11 +232,11 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 	if (set->automerge)
 		json_object_set_new(root, "auto-merge", json_true());
 
-	if (!nft_output_terse(octx) && set->init && set->init->size > 0) {
+	if (!nft_output_terse(octx) && set->init && expr_set(set->init)->size > 0) {
 		json_t *array = json_array();
 		const struct expr *i;
 
-		list_for_each_entry(i, &set->init->expressions, list)
+		list_for_each_entry(i, &expr_set(set->init)->expressions, list)
 			json_array_append_new(array, expr_print_json(i, octx));
 
 		json_object_set_new(root, "elem", array);
@@ -658,7 +658,7 @@ json_t *concat_expr_json(const struct expr *expr, struct output_ctx *octx)
 	json_t *array = json_array();
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
 		json_array_append_new(array, expr_print_json(i, octx));
 
 	return nft_json_pack("{s:o}", "concat", array);
@@ -669,7 +669,7 @@ json_t *set_expr_json(const struct expr *expr, struct output_ctx *octx)
 	json_t *array = json_array();
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_set(expr)->expressions, list)
 		json_array_append_new(array, expr_print_json(i, octx));
 
 	return nft_json_pack("{s:o}", "set", array);
@@ -738,7 +738,7 @@ json_t *list_expr_json(const struct expr *expr, struct output_ctx *octx)
 	json_t *array = json_array();
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_list(expr)->expressions, list)
 		json_array_append_new(array, expr_print_json(i, octx));
 
 	//return nft_json_pack("{s:s, s:o}", "type", "list", "val", array);
diff --git a/src/mergesort.c b/src/mergesort.c
index 0452d60ad42b..bd1c21877b21 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -18,7 +18,7 @@ static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 	const struct expr *i;
 	char data[512];
 
-	list_for_each_entry(i, &expr->expressions, list) {
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		ilen = div_round_up(i->len, BITS_PER_BYTE);
 		mpz_export_data(data + len, i->value, i->byteorder, ilen);
 		len += ilen;
diff --git a/src/mnl.c b/src/mnl.c
index cc20908fd636..e6da401374ad 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -758,12 +758,12 @@ static struct nft_dev *nft_dev_array(const struct expr *dev_expr, int *num_devs)
 
 	switch (dev_expr->etype) {
 	case EXPR_LIST:
-		list_for_each_entry(expr, &dev_expr->expressions, list)
+		list_for_each_entry(expr, &expr_list(dev_expr)->expressions, list)
 			len++;
 
 		dev_array = xmalloc(sizeof(struct nft_dev) * len);
 
-		list_for_each_entry(expr, &dev_expr->expressions, list) {
+		list_for_each_entry(expr, &expr_list(dev_expr)->expressions, list) {
 			nft_dev_add(dev_array, expr, i);
 			i++;
 		}
@@ -1793,7 +1793,7 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 		flags |= NLM_F_CREATE;
 
 	if (init)
-		expr = list_first_entry(&init->expressions, struct expr, list);
+		expr = list_first_entry(&expr_set(init)->expressions, struct expr, list);
 
 next:
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(batch), msg_type,
@@ -1813,16 +1813,16 @@ next:
 				 htonl(nftnl_set_get_u32(nls, NFTNL_SET_ID)));
 	}
 
-	if (!init || list_empty(&init->expressions))
+	if (!init || list_empty(&expr_set(init)->expressions))
 		return 0;
 
 	assert(expr);
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
-	list_for_each_entry_from(expr, &init->expressions, list) {
+	list_for_each_entry_from(expr, &expr_set(init)->expressions, list) {
 
 		if (set_is_non_concat_range(set)) {
 			if (set_is_anonymous(set->flags) &&
-			    !list_is_last(&expr->list, &init->expressions))
+			    !list_is_last(&expr->list, &expr_set(init)->expressions))
 				next = list_next_entry(expr, list);
 			else
 				next = NULL;
diff --git a/src/monitor.c b/src/monitor.c
index e3e38c2a12b7..ecd32d935472 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -402,7 +402,7 @@ static bool netlink_event_range_cache(struct set *cached_set,
 	}
 
 	/* don't cache half-open range elements */
-	elem = list_entry(dummyset->init->expressions.prev, struct expr, list);
+	elem = list_entry(expr_set(dummyset->init)->expressions.prev, struct expr, list);
 	if (!set_elem_is_open_interval(elem) &&
 	    dummyset->desc.field_count <= 1) {
 		cached_set->rg_cache = expr_clone(elem);
diff --git a/src/netlink.c b/src/netlink.c
index f3157d9d7f1c..d18aeb10b294 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -134,8 +134,8 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	case EXPR_SET_ELEM_CATCHALL:
 		break;
 	default:
-		if (set->set_flags & NFT_SET_INTERVAL &&
-		    key->etype == EXPR_CONCAT && key->field_count > 1) {
+		if (expr_set(set)->set_flags & NFT_SET_INTERVAL &&
+		    key->etype == EXPR_CONCAT && expr_concat(key)->field_count > 1) {
 			key->flags |= EXPR_F_INTERVAL;
 			netlink_gen_key(key, &nld);
 			key->flags &= ~EXPR_F_INTERVAL;
@@ -201,7 +201,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 				   nftnl_udata_buf_len(udbuf));
 		nftnl_udata_buf_free(udbuf);
 	}
-	if (set_is_datamap(set->set_flags) && data != NULL) {
+	if (set_is_datamap(expr_set(set)->set_flags) && data != NULL) {
 		__netlink_gen_data(data, &nld, !(data->flags & EXPR_F_SINGLETON));
 		switch (data->etype) {
 		case EXPR_VERDICT:
@@ -226,7 +226,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			break;
 		}
 	}
-	if (set_is_objmap(set->set_flags) && data != NULL) {
+	if (set_is_objmap(expr_set(set)->set_flags) && data != NULL) {
 		netlink_gen_data(data, &nld);
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_OBJREF,
 				   nld.value, nld.len);
@@ -361,7 +361,7 @@ static void netlink_gen_concat_key(const struct expr *expr,
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
 		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
 
 	nft_data_memcpy(nld, data, len);
@@ -425,10 +425,10 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
 		offset += __netlink_gen_concat_data(false, i, data + offset);
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
 		offset += __netlink_gen_concat_data(true, i, data + offset);
 
 	nft_data_memcpy(nld, data, len);
@@ -447,7 +447,7 @@ static void __netlink_gen_concat(const struct expr *expr,
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
 		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
 
 	nft_data_memcpy(nld, data, len);
@@ -1215,7 +1215,7 @@ void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 	struct nftnl_set_elem *nlse;
 	const struct expr *expr;
 
-	list_for_each_entry(expr, &set->expressions, list) {
+	list_for_each_entry(expr, &expr_set(set)->expressions, list) {
 		nlse = alloc_nftnl_setelem(set, expr);
 		nftnl_set_elem_add(nls, nlse);
 	}
@@ -1362,7 +1362,7 @@ static struct expr *netlink_parse_concat_elem_key(const struct set *set,
 	int off = dtype->subtypes;
 
 	if (set->key->etype == EXPR_CONCAT)
-		n = list_first_entry(&set->key->expressions, struct expr, list);
+		n = list_first_entry(&expr_concat(set->key)->expressions, struct expr, list);
 
 	concat = concat_expr_alloc(&data->location);
 	while (off > 0) {
@@ -1410,7 +1410,7 @@ static struct expr *netlink_parse_concat_elem(const struct set *set,
 		}
 		assert(list_empty(&expressions));
 	} else {
-		list_splice_tail(&expressions, &concat->expressions);
+		list_splice_tail(&expressions, &expr_concat(concat)->expressions);
 	}
 
 	expr_free(data);
@@ -1681,7 +1681,7 @@ int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	else if (set->flags & NFT_SET_INTERVAL)
 		interval_map_decompose(set->init);
 	else
-		list_expr_sort(&ctx->set->init->expressions);
+		list_expr_sort(&expr_set(ctx->set->init)->expressions);
 
 	nftnl_set_free(nls);
 	ctx->set = NULL;
@@ -1725,7 +1725,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 	else if (set->flags & NFT_SET_INTERVAL)
 		err = get_set_decompose(cache_set, set);
 	else
-		list_expr_sort(&ctx->set->init->expressions);
+		list_expr_sort(&expr_set(ctx->set->init)->expressions);
 
 	nftnl_set_free(nls);
 	nftnl_set_free(nls_out);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 48a3e33adc8f..b4d4a3da3b37 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2186,10 +2186,10 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 
 			if (set_is_anonymous(set->flags) &&
 			    set->init &&
-			    !list_empty(&set->init->expressions)) {
+			    !list_empty(&expr_set(set->init)->expressions)) {
 				struct expr *elem;
 
-				elem = list_first_entry(&set->init->expressions, struct expr, list);
+				elem = list_first_entry(&expr_set(set->init)->expressions, struct expr, list);
 
 				if (elem->etype == EXPR_SET_ELEM &&
 				    elem->key->etype == EXPR_VALUE)
@@ -2476,7 +2476,7 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 		if (!set_is_anonymous(right->set->flags))
 			break;
 
-		list_for_each_entry(i, &right->set->init->expressions, list) {
+		list_for_each_entry(i, &expr_set(right->set->init)->expressions, list) {
 			switch (i->key->etype) {
 			case EXPR_VALUE:
 				binop_adjust_one(binop, i->key, shift);
@@ -2822,7 +2822,7 @@ static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp
 	assert(expr->etype == EXPR_CONCAT);
 
 	ctx->flags |= RULE_PP_IN_CONCATENATION;
-	list_for_each_entry_safe(i, n, &expr->expressions, list) {
+	list_for_each_entry_safe(i, n, &expr_concat(expr)->expressions, list) {
 		if (type) {
 			dtype = concat_subtype_lookup(type, --off);
 			expr_set_type(i, dtype, dtype->byteorder);
@@ -2834,7 +2834,7 @@ static void expr_postprocess_concat(struct rule_pp_ctx *ctx, struct expr **exprp
 		ntype = concat_subtype_add(ntype, i->dtype->type);
 	}
 	ctx->flags &= ~RULE_PP_IN_CONCATENATION;
-	list_splice(&tmp, &expr->expressions);
+	list_splice(&tmp, &expr_concat(expr)->expressions);
 	__datatype_set(expr, concat_type_alloc(ntype));
 }
 
@@ -2861,7 +2861,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->right);
 		break;
 	case EXPR_SET:
-		list_for_each_entry(i, &expr->expressions, list)
+		list_for_each_entry(i, &expr_set(expr)->expressions, list)
 			expr_postprocess(ctx, &i);
 		break;
 	case EXPR_CONCAT:
@@ -3432,7 +3432,7 @@ static bool has_inner_desc(const struct expr *expr)
 	case EXPR_BINOP:
 		return has_inner_desc(expr->left);
 	case EXPR_CONCAT:
-		list_for_each_entry(i, &expr->expressions, list) {
+		list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 			if (has_inner_desc(i))
 				return true;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5f73183bf19a..8ac33d344de4 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -123,7 +123,7 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 {
 	const struct expr *i;
 
-	list_for_each_entry(i, &expr->expressions, list) {
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		netlink_gen_expr(ctx, i, dreg);
 		dreg += netlink_register_space(i->len);
 	}
diff --git a/src/optimize.c b/src/optimize.c
index 89ba0d9dee6a..40756cecbbc3 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -565,7 +565,7 @@ static void merge_expr_stmts(const struct optimize_ctx *ctx,
 	uint32_t i;
 
 	set = set_expr_alloc(&internal_location, NULL);
-	set->set_flags |= NFT_SET_ANONYMOUS;
+	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	expr_a = stmt_a->expr->right;
 	elem = set_elem_expr_alloc(&internal_location, expr_get(expr_a));
@@ -588,7 +588,7 @@ static void merge_vmap(const struct optimize_ctx *ctx,
 	struct expr *mappings, *mapping, *expr;
 
 	mappings = stmt_b->expr->mappings;
-	list_for_each_entry(expr, &mappings->expressions, list) {
+	list_for_each_entry(expr, &expr_set(mappings)->expressions, list) {
 		mapping = expr_clone(expr);
 		compound_expr_add(stmt_a->expr->mappings, mapping);
 	}
@@ -654,7 +654,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
 			switch (stmt_a->expr->right->etype) {
 			case EXPR_SET:
-				list_for_each_entry(expr, &stmt_a->expr->right->expressions, list) {
+				list_for_each_entry(expr, &expr_set(stmt_a->expr->right)->expressions, list) {
 					concat_clone = expr_clone(concat);
 					clone = expr_clone(expr->key);
 					compound_expr_add(concat_clone, clone);
@@ -673,7 +673,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 				compound_expr_add(concat, clone);
 				break;
 			case EXPR_LIST:
-				list_for_each_entry(expr, &stmt_a->expr->right->expressions, list) {
+				list_for_each_entry(expr, &expr_list(stmt_a->expr->right)->expressions, list) {
 					concat_clone = expr_clone(concat);
 					clone = expr_clone(expr);
 					compound_expr_add(concat_clone, clone);
@@ -727,7 +727,7 @@ static void merge_concat_stmts(const struct optimize_ctx *ctx,
 
 	/* build set data contenation, eg. { eth0 . 1.1.1.1 . 22 } */
 	set = set_expr_alloc(&internal_location, NULL);
-	set->set_flags |= NFT_SET_ANONYMOUS;
+	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	for (i = from; i <= to; i++)
 		__merge_concat_stmts(ctx, i, merge, set);
@@ -750,7 +750,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 
 	switch (expr->etype) {
 	case EXPR_LIST:
-		list_for_each_entry(item, &expr->expressions, list) {
+		list_for_each_entry(item, &expr_list(expr)->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item));
 			if (counter) {
 				counter_elem = counter_stmt_alloc(&counter->location);
@@ -764,7 +764,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 		stmt_free(counter);
 		break;
 	case EXPR_SET:
-		list_for_each_entry(item, &expr->expressions, list) {
+		list_for_each_entry(item, &expr_set(expr)->expressions, list) {
 			elem = set_elem_expr_alloc(&internal_location, expr_get(item->key));
 			if (counter) {
 				counter_elem = counter_stmt_alloc(&counter->location);
@@ -851,7 +851,7 @@ static void merge_stmts_vmap(const struct optimize_ctx *ctx,
 	assert(k >= 0);
 
 	set = set_expr_alloc(&internal_location, NULL);
-	set->set_flags |= NFT_SET_ANONYMOUS;
+	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	expr_a = stmt_a->expr->right;
 	verdict_a = ctx->stmt_matrix[from][k];
@@ -925,7 +925,7 @@ static void merge_concat_stmts_vmap(const struct optimize_ctx *ctx,
 
 	/* build set data contenation, eg. { eth0 . 1.1.1.1 . 22 : accept } */
 	set = set_expr_alloc(&internal_location, NULL);
-	set->set_flags |= NFT_SET_ANONYMOUS;
+	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	for (i = from; i <= to; i++) {
 		verdict = ctx->stmt_matrix[i][k];
@@ -1050,7 +1050,7 @@ static void merge_nat(const struct optimize_ctx *ctx,
 	assert(k >= 0);
 
 	set = set_expr_alloc(&internal_location, NULL);
-	set->set_flags |= NFT_SET_ANONYMOUS;
+	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	for (i = from; i <= to; i++) {
 		stmt = ctx->stmt_matrix[i][merge->stmt[0]];
@@ -1102,7 +1102,7 @@ static void merge_concat_nat(const struct optimize_ctx *ctx,
 	assert(k >= 0);
 
 	set = set_expr_alloc(&internal_location, NULL);
-	set->set_flags |= NFT_SET_ANONYMOUS;
+	expr_set(set)->set_flags |= NFT_SET_ANONYMOUS;
 
 	for (i = from; i <= to; i++) {
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f9cc909836bc..5b84331f220d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2073,7 +2073,7 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			|	chain_block	DEVICES		'='	flowtable_expr	stmt_separator
 			{
 				if ($$->dev_expr) {
-					list_splice_init(&$4->expressions, &$$->dev_expr->expressions);
+					list_splice_init(&expr_list($4)->expressions, &expr_list($$->dev_expr)->expressions);
 					expr_free($4);
 					break;
 				}
diff --git a/src/parser_json.c b/src/parser_json.c
index 08657f2849a5..bd865de59007 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1286,10 +1286,11 @@ static struct expr *json_parse_binop_expr(struct json_ctx *ctx,
 
 static struct expr *json_check_concat_expr(struct json_ctx *ctx, struct expr *e)
 {
-	if (e->size >= 2)
+	if (expr_concat(e)->size >= 2)
 		return e;
 
-	json_error(ctx, "Concatenation with %d elements is illegal", e->size);
+	json_error(ctx, "Concatenation with %d elements is illegal",
+		   expr_concat(e)->size);
 	expr_free(e);
 	return NULL;
 }
diff --git a/src/rule.c b/src/rule.c
index 3e3cc3b0fb7d..0ad948ea87f2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -424,7 +424,7 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 		return;
 	}
 
-	if (set->init != NULL && set->init->size > 0) {
+	if (set->init != NULL && expr_set(set->init)->size > 0) {
 		nft_print(octx, "%s%selements = ", opts->tab, opts->tab);
 
 		if (set->timeout || set->elem_has_comment ||
@@ -1459,7 +1459,7 @@ void cmd_free(struct cmd *cmd)
 static int __do_add_elements(struct netlink_ctx *ctx, struct cmd *cmd,
 			     struct set *set, struct expr *expr, uint32_t flags)
 {
-	expr->set_flags |= set->flags;
+	expr_set(expr)->set_flags |= set->flags;
 	if (mnl_nft_setelem_add(ctx, cmd, set, expr, flags) < 0)
 		return -1;
 
diff --git a/src/segtree.c b/src/segtree.c
index 00db8810cdba..70b4416cf39b 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -77,9 +77,9 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	mpz_init2(low, set->key->len);
 	mpz_init2(high, set->key->len);
 
-	new_init = list_expr_alloc(&internal_location);
+	new_init = set_expr_alloc(&internal_location, NULL);
 
-	list_for_each_entry(i, &init->expressions, list) {
+	list_for_each_entry(i, &expr_set(init)->expressions, list) {
 		switch (i->key->etype) {
 		case EXPR_VALUE:
 			set_elem_add(set, new_init, i->key->value,
@@ -135,7 +135,7 @@ static struct expr *get_set_interval_find(const struct set *cache_set,
 
 	mpz_init2(val, set->key->len);
 
-	list_for_each_entry(i, &set->init->expressions, list) {
+	list_for_each_entry(i, &expr_set(set->init)->expressions, list) {
 		key = expr_value(i);
 		switch (key->etype) {
 		case EXPR_VALUE:
@@ -236,7 +236,7 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 
 	new_init = set_expr_alloc(&internal_location, set);
 
-	list_for_each_entry_safe(i, next, &set->init->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_set(set->init)->expressions, list) {
 		if (i->flags & EXPR_F_INTERVAL_END && left) {
 			list_del(&left->list);
 			list_del(&i->list);
@@ -354,7 +354,7 @@ void concat_range_aggregate(struct expr *set)
 	int prefix_len, free_r1;
 	mpz_t range, p;
 
-	list_for_each_entry_safe(i, next, &set->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
 		if (!start) {
 			start = i;
 			continue;
@@ -366,10 +366,10 @@ void concat_range_aggregate(struct expr *set)
 		 * store them by replacing r2 expressions, and free r1
 		 * expressions.
 		 */
-		r2 = list_first_entry(&expr_value(end)->expressions,
+		r2 = list_first_entry(&expr_concat(expr_value(end))->expressions,
 				      struct expr, list);
 		list_for_each_entry_safe(r1, r1_next,
-					 &expr_value(start)->expressions,
+					 &expr_concat(expr_value(start))->expressions,
 					 list) {
 			bool string_type = false;
 
@@ -564,15 +564,15 @@ void interval_map_decompose(struct expr *set)
 	unsigned int n, m, size;
 	bool interval;
 
-	if (set->size == 0)
+	if (expr_set(set)->size == 0)
 		return;
 
-	elements = xmalloc_array(set->size, sizeof(struct expr *));
-	ranges = xmalloc_array(set->size * 2, sizeof(struct expr *));
+	elements = xmalloc_array(expr_set(set)->size, sizeof(struct expr *));
+	ranges = xmalloc_array(expr_set(set)->size * 2, sizeof(struct expr *));
 
 	/* Sort elements */
 	n = 0;
-	list_for_each_entry_safe(i, next, &set->expressions, list) {
+	list_for_each_entry_safe(i, next, &expr_set(set)->expressions, list) {
 		key = NULL;
 		if (i->etype == EXPR_SET_ELEM)
 			key = i->key;
-- 
2.30.2

