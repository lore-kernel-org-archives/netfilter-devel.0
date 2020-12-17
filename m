Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E5AC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E429F20637
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgLQQos (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:44:48 -0500
Received: from correo.us.es ([193.147.175.20]:60998 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgLQQos (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 11:44:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F04A7C0B27
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF33FDA8FD
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D464DDA8FB; Thu, 17 Dec 2020 17:43:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30860DA72F
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 17:43:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 12F33426CC85
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:44 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2,v2] src: add support for multi-statement in dynamic sets and maps
Date:   Thu, 17 Dec 2020 17:43:58 +0100
Message-Id: <20201217164359.24720-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows for two statements for dynamic set updates, e.g.

 nft rule x y add @y { ip daddr limit rate 1/second counter }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix memleaks.
    fix crashes reported by tests/shell.

 include/statement.h       |  4 +--
 src/evaluate.c            | 24 +++++++------
 src/netlink.c             |  1 +
 src/netlink_delinearize.c | 74 +++++++++++++++++++++++++++++++--------
 src/netlink_linearize.c   | 41 +++++++++++++++++-----
 src/parser_bison.y        | 27 ++++++++++----
 src/statement.c           | 34 +++++++++++++-----
 7 files changed, 157 insertions(+), 48 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index f2fc6ade7734..7637a82e4e00 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -201,7 +201,7 @@ uint32_t fwd_stmt_type(const char *type);
 struct set_stmt {
 	struct expr		*set;
 	struct expr		*key;
-	struct stmt		*stmt;
+	struct list_head	stmt_list;
 	enum nft_dynset_ops	op;
 };
 
@@ -213,7 +213,7 @@ struct map_stmt {
 	struct expr		*set;
 	struct expr		*key;
 	struct expr		*data;
-	struct stmt		*stmt;
+	struct list_head	stmt_list;
 	enum nft_dynset_ops	op;
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index e776cd018051..03f060eb465a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3370,6 +3370,8 @@ static int stmt_evaluate_log(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct stmt *this;
+
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &stmt->set.set) < 0)
 		return -1;
@@ -3389,12 +3391,12 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 	if (stmt->set.key->comment != NULL)
 		return expr_error(ctx->msgs, stmt->set.key,
 				  "Key expression comments are not supported");
-	if (stmt->set.stmt) {
-		if (stmt_evaluate(ctx, stmt->set.stmt) < 0)
+	list_for_each_entry(this, &stmt->set.stmt_list, list) {
+		if (stmt_evaluate(ctx, this) < 0)
 			return -1;
-		if (!(stmt->set.stmt->flags & STMT_F_STATEFUL))
-			return stmt_binary_error(ctx, stmt->set.stmt, stmt,
-						 "meter statement must be stateful");
+		if (!(this->flags & STMT_F_STATEFUL))
+			return stmt_error(ctx, this,
+					  "statement must be stateful");
 	}
 
 	return 0;
@@ -3402,6 +3404,8 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct stmt *this;
+
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &stmt->map.set) < 0)
 		return -1;
@@ -3435,12 +3439,12 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->map.data,
 				  "Data expression comments are not supported");
 
-	if (stmt->map.stmt) {
-		if (stmt_evaluate(ctx, stmt->map.stmt) < 0)
+	list_for_each_entry(this, &stmt->map.stmt_list, list) {
+		if (stmt_evaluate(ctx, this) < 0)
 			return -1;
-		if (!(stmt->map.stmt->flags & STMT_F_STATEFUL))
-			return stmt_binary_error(ctx, stmt->map.stmt, stmt,
-						 "meter statement must be stateful");
+		if (!(this->flags & STMT_F_STATEFUL))
+			return stmt_error(ctx, this,
+					  "statement must be stateful");
 	}
 
 	return 0;
diff --git a/src/netlink.c b/src/netlink.c
index 8098b9746c95..ab0290926eaf 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1132,6 +1132,7 @@ key_end:
 		key = bitmask_expr_to_binops(key);
 
 	expr = set_elem_expr_alloc(&netlink_location, key);
+
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_TIMEOUT))
 		expr->timeout	 = nftnl_set_elem_get_u64(nlse, NFTNL_SET_ELEM_TIMEOUT);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPIRATION))
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8b06c4c0985f..731507228411 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1489,17 +1489,47 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
+struct dynset_parse_ctx {
+	struct netlink_parse_ctx	*nlctx;
+	const struct location		*loc;
+	struct list_head		stmt_list;
+};
+
+static int dynset_parse_expressions(struct nftnl_expr *e, void *data)
+{
+	struct dynset_parse_ctx *dynset_parse_ctx = data;
+	struct netlink_parse_ctx *ctx = dynset_parse_ctx->nlctx;
+	const struct location *loc = dynset_parse_ctx->loc;
+	struct stmt *stmt;
+
+	if (netlink_parse_expr(e, ctx) < 0 || !ctx->stmt) {
+		netlink_error(ctx, loc, "Could not parse dynset stmt");
+		return -1;
+	}
+	stmt = ctx->stmt;
+
+	list_add_tail(&stmt->list, &dynset_parse_ctx->stmt_list);
+
+	return 0;
+}
+
 static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 				 const struct location *loc,
 				 const struct nftnl_expr *nle)
 {
+	struct dynset_parse_ctx dynset_parse_ctx = {
+		.nlctx	= ctx,
+		.loc	= loc,
+	};
 	struct expr *expr, *expr_data = NULL;
 	enum nft_registers sreg, sreg_data;
+	struct stmt *stmt, *dstmt, *next;
 	const struct nftnl_expr *dnle;
-	struct stmt *stmt, *dstmt;
 	struct set *set;
 	const char *name;
 
+	init_list_head(&dynset_parse_ctx.stmt_list);
+
 	name = nftnl_expr_get_str(nle, NFTNL_EXPR_DYNSET_SET_NAME);
 	set  = set_lookup(ctx->table, name);
 	if (set == NULL)
@@ -1523,16 +1553,25 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	expr = set_elem_expr_alloc(&expr->location, expr);
 	expr->timeout = nftnl_expr_get_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT);
 
-	dstmt = NULL;
-	dnle = nftnl_expr_get(nle, NFTNL_EXPR_DYNSET_EXPR, NULL);
-	if (dnle != NULL) {
-		if (netlink_parse_expr(dnle, ctx) < 0)
-			goto out_err;
-		if (ctx->stmt == NULL) {
-			netlink_error(ctx, loc, "Could not parse dynset stmt");
-			goto out_err;
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_DYNSET_EXPR)) {
+		dstmt = NULL;
+		dnle = nftnl_expr_get(nle, NFTNL_EXPR_DYNSET_EXPR, NULL);
+		if (dnle != NULL) {
+			if (netlink_parse_expr(dnle, ctx) < 0)
+				goto out_err;
+			if (ctx->stmt == NULL) {
+				netlink_error(ctx, loc,
+					      "Could not parse dynset stmt");
+				goto out_err;
+			}
+			dstmt = ctx->stmt;
+			list_add_tail(&dstmt->list,
+				      &dynset_parse_ctx.stmt_list);
 		}
-		dstmt = ctx->stmt;
+	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_DYNSET_EXPRESSIONS)) {
+		if (nftnl_expr_expr_foreach(nle, dynset_parse_expressions,
+					    &dynset_parse_ctx) < 0)
+			goto out_err;
 	}
 
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_DYNSET_SREG_DATA)) {
@@ -1546,27 +1585,34 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 		stmt->map.set	= set_ref_expr_alloc(loc, set);
 		stmt->map.key	= expr;
 		stmt->map.data	= expr_data;
-		stmt->map.stmt	= dstmt;
 		stmt->map.op	= nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
+		list_splice_tail(&dynset_parse_ctx.stmt_list,
+				 &stmt->map.stmt_list);
 	} else {
-		if (dstmt != NULL && set->flags & NFT_SET_ANONYMOUS) {
+		if (!list_empty(&dynset_parse_ctx.stmt_list) &&
+		    set->flags & NFT_SET_ANONYMOUS) {
 			stmt = meter_stmt_alloc(loc);
 			stmt->meter.set  = set_ref_expr_alloc(loc, set);
 			stmt->meter.key  = expr;
-			stmt->meter.stmt = dstmt;
+			stmt->meter.stmt = list_first_entry(&dynset_parse_ctx.stmt_list,
+							    struct stmt, list);
 			stmt->meter.size = set->desc.size;
 		} else {
 			stmt = set_stmt_alloc(loc);
 			stmt->set.set   = set_ref_expr_alloc(loc, set);
 			stmt->set.op    = nftnl_expr_get_u32(nle, NFTNL_EXPR_DYNSET_OP);
 			stmt->set.key   = expr;
-			stmt->set.stmt	= dstmt;
+			list_splice_tail(&dynset_parse_ctx.stmt_list,
+					 &stmt->set.stmt_list);
 		}
 	}
 
 	ctx->stmt = stmt;
 	return;
 out_err:
+	list_for_each_entry_safe(dstmt, next, &dynset_parse_ctx.stmt_list, list)
+		stmt_free(dstmt);
+
 	xfree(expr);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 05af8bb1b485..09d0c61cfcc0 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1397,8 +1397,10 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
 	struct set *set = stmt->meter.set->set;
-	struct nftnl_expr *nle;
 	enum nft_registers sreg_key;
+	struct nftnl_expr *nle;
+	int num_stmts = 0;
+	struct stmt *this;
 
 	sreg_key = get_register(ctx, stmt->set.key->key);
 	netlink_gen_expr(ctx, stmt->set.key->key, sreg_key);
@@ -1414,9 +1416,20 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 
-	if (stmt->set.stmt)
-		nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
-			       netlink_gen_stmt_stateful(stmt->set.stmt), 0);
+	list_for_each_entry(this, &stmt->set.stmt_list, list)
+		num_stmts++;
+
+	if (num_stmts == 1) {
+		list_for_each_entry(this, &stmt->set.stmt_list, list) {
+			nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
+				       netlink_gen_stmt_stateful(this), 0);
+		}
+	} else if (num_stmts > 1) {
+		list_for_each_entry(this, &stmt->set.stmt_list, list) {
+			nftnl_expr_add_expr(nle, NFTNL_EXPR_DYNSET_EXPRESSIONS,
+					    netlink_gen_stmt_stateful(this));
+		}
+	}
 }
 
 static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
@@ -1426,6 +1439,8 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	enum nft_registers sreg_data;
 	enum nft_registers sreg_key;
 	struct nftnl_expr *nle;
+	int num_stmts = 0;
+	struct stmt *this;
 
 	sreg_key = get_register(ctx, stmt->map.key);
 	netlink_gen_expr(ctx, stmt->map.key, sreg_key);
@@ -1443,12 +1458,22 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, stmt->map.op);
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set.name);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
+	nft_rule_add_expr(ctx, nle, &stmt->location);
 
-	if (stmt->map.stmt)
-		nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
-			       netlink_gen_stmt_stateful(stmt->map.stmt), 0);
+	list_for_each_entry(this, &stmt->map.stmt_list, list)
+		num_stmts++;
 
-	nft_rule_add_expr(ctx, nle, &stmt->location);
+	if (num_stmts == 1) {
+		list_for_each_entry(this, &stmt->map.stmt_list, list) {
+			nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
+				       netlink_gen_stmt_stateful(this), 0);
+		}
+	} else if (num_stmts > 1) {
+		list_for_each_entry(this, &stmt->map.stmt_list, list) {
+			nftnl_expr_add_expr(nle, NFTNL_EXPR_DYNSET_EXPRESSIONS,
+					    netlink_gen_stmt_stateful(this));
+		}
+	}
 }
 
 static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 08aadaa32a86..673ce4ad4080 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -624,8 +624,8 @@ int nft_lex(void *, void *, void *);
 %type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block
 %destructor { obj_free($$); }	obj_block_alloc
 
-%type <list>			stmt_list
-%destructor { stmt_list_free($$); xfree($$); } stmt_list
+%type <list>			stmt_list stateful_stmt_list
+%destructor { stmt_list_free($$); xfree($$); } stmt_list stateful_stmt_list
 %type <stmt>			stmt match_stmt verdict_stmt
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt
@@ -2656,6 +2656,19 @@ stmt_list		:	stmt
 			}
 			;
 
+stateful_stmt_list	:	stateful_stmt
+			{
+				$$ = xmalloc(sizeof(*$$));
+				init_list_head($$);
+				list_add_tail(&$1->list, $$);
+			}
+			|	stateful_stmt_list	stateful_stmt
+			{
+				$$ = $1;
+				list_add_tail(&$2->list, $1);
+			}
+			;
+
 stateful_stmt		:	counter_stmt
 			|	limit_stmt
 			|	quota_stmt
@@ -3675,13 +3688,14 @@ set_stmt		:	SET	set_stmt_op	set_elem_expr_stmt	set_ref_expr
 				$$->set.key = $4;
 				$$->set.set = $2;
 			}
-			|	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	stateful_stmt	'}'
+			|	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	stateful_stmt_list	'}'
 			{
 				$$ = set_stmt_alloc(&@$);
 				$$->set.op  = $1;
 				$$->set.key = $4;
 				$$->set.set = $2;
-				$$->set.stmt = $5;
+				list_splice_tail($5, &$$->set.stmt_list);
+				free($5);
 			}
 			;
 
@@ -3698,14 +3712,15 @@ map_stmt		:	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	COLON	set_elem_expr_
 				$$->map.data = $6;
 				$$->map.set = $2;
 			}
-			|	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	stateful_stmt COLON	set_elem_expr_stmt	'}'
+			|	set_stmt_op	set_ref_expr '{' set_elem_expr_stmt	stateful_stmt_list	COLON	set_elem_expr_stmt	'}'
 			{
 				$$ = map_stmt_alloc(&@$);
 				$$->map.op  = $1;
 				$$->map.key = $4;
 				$$->map.data = $7;
-				$$->map.stmt = $5;
 				$$->map.set = $2;
+				list_splice_tail($5, &$$->map.stmt_list);
+				free($5);
 			}
 			;
 
diff --git a/src/statement.c b/src/statement.c
index 6fe8e9d9beb4..39020857ae9c 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -732,15 +732,16 @@ const char * const set_stmt_op_names[] = {
 static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	unsigned int flags = octx->flags;
+	struct stmt *this;
 
 	nft_print(octx, "%s ", set_stmt_op_names[stmt->set.op]);
 	expr_print(stmt->set.set, octx);
 	nft_print(octx, " { ");
 	expr_print(stmt->set.key, octx);
-	if (stmt->set.stmt) {
+	list_for_each_entry(this, &stmt->set.stmt_list, list) {
 		nft_print(octx, " ");
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
-		stmt_print(stmt->set.stmt, octx);
+		stmt_print(this, octx);
 		octx->flags = flags;
 	}
 	nft_print(octx, " }");
@@ -748,9 +749,12 @@ static void set_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 static void set_stmt_destroy(struct stmt *stmt)
 {
+	struct stmt *this, *next;
+
 	expr_free(stmt->set.key);
 	expr_free(stmt->set.set);
-	stmt_free(stmt->set.stmt);
+	list_for_each_entry_safe(this, next, &stmt->set.stmt_list, list)
+		stmt_free(this);
 }
 
 static const struct stmt_ops set_stmt_ops = {
@@ -763,21 +767,27 @@ static const struct stmt_ops set_stmt_ops = {
 
 struct stmt *set_stmt_alloc(const struct location *loc)
 {
-	return stmt_alloc(loc, &set_stmt_ops);
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &set_stmt_ops);
+	init_list_head(&stmt->set.stmt_list);
+
+	return stmt;
 }
 
 static void map_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	unsigned int flags = octx->flags;
+	struct stmt *this;
 
 	nft_print(octx, "%s ", set_stmt_op_names[stmt->map.op]);
 	expr_print(stmt->map.set, octx);
 	nft_print(octx, " { ");
 	expr_print(stmt->map.key, octx);
-	if (stmt->map.stmt) {
+	list_for_each_entry(this, &stmt->map.stmt_list, list) {
 		nft_print(octx, " ");
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
-		stmt_print(stmt->map.stmt, octx);
+		stmt_print(this, octx);
 		octx->flags = flags;
 	}
 	nft_print(octx, " : ");
@@ -787,10 +797,13 @@ static void map_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 
 static void map_stmt_destroy(struct stmt *stmt)
 {
+	struct stmt *this, *next;
+
 	expr_free(stmt->map.key);
 	expr_free(stmt->map.data);
 	expr_free(stmt->map.set);
-	stmt_free(stmt->map.stmt);
+	list_for_each_entry_safe(this, next, &stmt->map.stmt_list, list)
+		stmt_free(this);
 }
 
 static const struct stmt_ops map_stmt_ops = {
@@ -802,7 +815,12 @@ static const struct stmt_ops map_stmt_ops = {
 
 struct stmt *map_stmt_alloc(const struct location *loc)
 {
-	return stmt_alloc(loc, &map_stmt_ops);
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &map_stmt_ops);
+	init_list_head(&stmt->map.stmt_list);
+
+	return stmt;
 }
 
 static void dup_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
-- 
2.20.1

