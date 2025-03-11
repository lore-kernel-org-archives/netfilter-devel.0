Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84612C1A2
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2025 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741698985; cv=none; b=k0j4X0skF5Riy7B9RYxI1dv54WR5Ttfa7hQM27DWnGDQZCzYfhVyES3S0hBv8mHfD0bjC77rftZqPtJM6QlXw9iv9tanG9aYOfPGF/0KE3KGrY9MpFHfJeRLZRGeLIONlYGVRMjWu7Z28+kEOYBAjx2AAeM9qwTjh1S5MAzBdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741698985; c=relaxed/simple;
	bh=Lzio3wBbPoa+7j+4oxXh758LxxwGuwh2oVU9MvFXgo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FOXIjEWSCNcYDSsRAkt6Mm/r7a3UpMi76IziUfnAhF3bxz5P6WaVziy6VJEePxL6PToKJOx/FNBecqlrsBBY1gWQGlO5VeM+f5DTgp4c6nkoAujdPzYMMpQrCsRCQjxfQozUfF3gLfxWIQk1kZxUF7NdpRgePH0uvPUMFRiJdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1trzSx-0002Vj-Ac; Tue, 11 Mar 2025 14:16:15 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix expression data corruption
Date: Tue, 11 Mar 2025 14:07:03 +0100
Message-ID: <20250311130707.12512-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes nftables will segfault when doing error-unwind of the included
afl-generated bogon.

The problem is the unconditional write access to expr->set_flags in
expr_evaluate_map():

   mappings->set_flags |= NFT_SET_MAP;

... but mappings can point to EXPR_VARIABLE (legal), where this will flip
a bit in unused, but allocated memory (i.e., has no effect).

In case of the bogon, mapping is EXPR_RANGE_SYMBOL, and the store can flip
a bit in identifier_range[1], this causes crash when the pointer is freed.

We can't use expr->set_flags unconditionally, so rework this to pass
set_flags as argument and place all read and write accesses in places where
we've made sure we are dealing with EXPR_SET.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 29 ++++++++++++-------
 .../bogons/nft-f/range_expression_corruption  |  2 ++
 2 files changed, 20 insertions(+), 11 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/range_expression_corruption

diff --git a/src/evaluate.c b/src/evaluate.c
index 722c11a23c2d..7fc210fd3b12 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -123,16 +123,16 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct set *set;
 	struct handle h;
 
-	if (set_is_datamap(expr->set_flags))
+	if (set_is_datamap(flags))
 		key_fix_dtype_byteorder(key);
 
 	set = set_alloc(&expr->location);
-	set->flags	= expr->set_flags | flags;
+	set->flags	= flags;
 	set->handle.set.name = xstrdup(name);
 	set->key	= key;
 	set->data	= data;
 	set->init	= expr;
-	set->automerge	= set->flags & NFT_SET_INTERVAL;
+	set->automerge	= flags & NFT_SET_INTERVAL;
 
 	handle_merge(&set->handle, &ctx->cmd->handle);
 
@@ -2117,6 +2117,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *map = *expr, *mappings;
 	struct expr_ctx ectx = ctx->ectx;
+	uint32_t set_flags = NFT_SET_MAP;
 	struct expr *key, *data;
 
 	if (map->map->etype == EXPR_CT &&
@@ -2145,11 +2146,14 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 
 	ctx->stmt_len = 0;
 	mappings = map->mappings;
-	mappings->set_flags |= NFT_SET_MAP;
 
 	switch (map->mappings->etype) {
-	case EXPR_VARIABLE:
+	case EXPR_CONCAT:
+	case EXPR_LIST:
 	case EXPR_SET:
+		set_flags |= mappings->set_flags;
+		/* fallthrough */
+	case EXPR_VARIABLE:
 		if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
 			key = expr_clone(ctx->ectx.key);
 		} else {
@@ -2179,7 +2183,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    key, data,
 						    mappings,
-						    NFT_SET_ANONYMOUS);
+						    NFT_SET_ANONYMOUS | set_flags);
 		if (!mappings)
 			return -1;
 
@@ -2807,7 +2811,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
 							 right,
-							 NFT_SET_ANONYMOUS);
+							 right->set_flags | NFT_SET_ANONYMOUS);
 			if (!right)
 				return -1;
 
@@ -3529,7 +3533,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 
 		set->set_flags |= NFT_SET_EVAL;
 		setref = implicit_set_declaration(ctx, stmt->meter.name,
-						  expr_get(key), NULL, set, 0);
+						  expr_get(key), NULL, set,
+						  NFT_SET_EVAL | set->set_flags);
 		if (setref)
 			setref->set->desc.size = stmt->meter.size;
 	}
@@ -4742,6 +4747,7 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *map = stmt->objref.expr;
+	uint32_t set_flags = NFT_SET_OBJECT;
 	struct expr *mappings;
 	struct expr *key;
 
@@ -4753,11 +4759,12 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 				  "Map expression can not be constant");
 
 	mappings = map->mappings;
-	mappings->set_flags |= NFT_SET_OBJECT;
 
 	switch (map->mappings->etype) {
-	case EXPR_VARIABLE:
 	case EXPR_SET:
+		set_flags |= mappings->set_flags;
+		/* fallthrough */
+	case EXPR_VARIABLE:
 		key = constant_expr_alloc(&stmt->location,
 					  ctx->ectx.dtype,
 					  ctx->ectx.byteorder,
@@ -4765,7 +4772,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 
 		mappings = implicit_set_declaration(ctx, "__objmap%d",
 						    key, NULL, mappings,
-						    NFT_SET_ANONYMOUS);
+						    set_flags | NFT_SET_ANONYMOUS);
 		if (!mappings)
 			return -1;
 		mappings->set->objtype  = stmt->objref.type;
diff --git a/tests/shell/testcases/bogons/nft-f/range_expression_corruption b/tests/shell/testcases/bogons/nft-f/range_expression_corruption
new file mode 100644
index 000000000000..b77221bd11a4
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/range_expression_corruption
@@ -0,0 +1,2 @@
+aal	tht@nh,32,3 set ctag| oi to ip
+		p sept ct 		l3proto map  q -u dscp |  ma
\ No newline at end of file
-- 
2.45.3

