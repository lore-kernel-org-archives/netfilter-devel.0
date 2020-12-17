Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D87C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D201B20637
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 16:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgLQQov (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:44:51 -0500
Received: from correo.us.es ([193.147.175.20]:32774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbgLQQov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 11:44:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4901DC0B2C
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35F4ADA8FB
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A91CDA704; Thu, 17 Dec 2020 17:43:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 518E2DA704
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 17:43:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2BECA426CC85
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 17:43:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: add set element multi-statement support
Date:   Thu, 17 Dec 2020 17:43:59 +0100
Message-Id: <20201217164359.24720-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201217164359.24720-1-pablo@netfilter.org>
References: <20201217164359.24720-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the set element infrastructure to support for several statements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix memleaks.
    fix crashes reported by tests/shell.

 include/expression.h |  2 +-
 include/list.h       |  7 ++++
 include/rule.h       |  2 +-
 src/evaluate.c       | 58 ++++++++++++++++++++++--------
 src/expression.c     | 18 +++++++---
 src/json.c           | 10 ++++--
 src/mnl.c            | 17 +++++++--
 src/netlink.c        | 66 +++++++++++++++++++++++++++++++---
 src/parser_bison.y   | 84 ++++++++++++++++++++++++++------------------
 src/rule.c           | 24 ++++++++++---
 src/segtree.c        |  6 ++--
 11 files changed, 219 insertions(+), 75 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 894a68d2e822..718dac5a122d 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -280,7 +280,7 @@ struct expr {
 			uint64_t		timeout;
 			uint64_t		expiration;
 			const char		*comment;
-			struct stmt		*stmt;
+			struct list_head	stmt_list;
 			uint32_t		elem_flags;
 		};
 		struct {
diff --git a/include/list.h b/include/list.h
index 9c4da81749de..857921e34201 100644
--- a/include/list.h
+++ b/include/list.h
@@ -348,6 +348,13 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_next_entry - get the next element in list
+ * @pos: the type * to cursor
+ * @member: the name of the list_head within the struct.
+ */
+#define list_next_entry(pos, member) \
+	list_entry((pos)->member.next, typeof(*(pos)), member)
 
 /**
  * list_for_each_entry	-	iterate over list of given type
diff --git a/include/rule.h b/include/rule.h
index 119fc19d79c8..330a09aa77fa 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -333,7 +333,7 @@ struct set {
 	struct expr		*init;
 	struct expr		*rg_cache;
 	uint32_t		policy;
-	struct stmt		*stmt;
+	struct list_head	stmt_list;
 	bool			root;
 	bool			automerge;
 	bool			key_typeof_valid;
diff --git a/src/evaluate.c b/src/evaluate.c
index 03f060eb465a..7e34f12c996f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1340,27 +1340,57 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
-static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
+static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 {
+	int num_elem_exprs = 0, num_set_exprs = 0;
 	struct set *set = ctx->set;
-	struct expr *elem = *expr;
+	struct stmt *stmt;
 
-	if (elem->stmt) {
-		if (set->stmt && set->stmt->ops != elem->stmt->ops) {
-			return stmt_error(ctx, elem->stmt,
-					  "statement mismatch, element expects %s, "
-					  "but %s has type %s",
-					  elem->stmt->ops->name,
-					  set_is_map(set->flags) ? "map" : "set",
-					  set->stmt->ops->name);
-		} else if (!set->stmt && !(set->flags & NFT_SET_EVAL)) {
-			return stmt_error(ctx, elem->stmt,
-					  "missing %s statement in %s definition",
-					  elem->stmt->ops->name,
+	list_for_each_entry(stmt, &elem->stmt_list, list)
+		num_elem_exprs++;
+	list_for_each_entry(stmt, &set->stmt_list, list)
+		num_set_exprs++;
+
+	if (num_elem_exprs > 0) {
+		if (num_elem_exprs != num_set_exprs)
+			return expr_error(ctx->msgs, elem,
+					  "number of statements mismatch, set expects %d "
+					  "but element has %d", num_set_exprs,
+					  num_elem_exprs);
+		else if (!(set->flags & NFT_SET_EVAL))
+			return expr_error(ctx->msgs, elem,
+					  "missing statements in %s definition",
 					  set_is_map(set->flags) ? "map" : "set");
+	}
+
+	if (num_set_exprs > 0) {
+		struct stmt *set_stmt, *elem_stmt;
+
+		set_stmt = list_first_entry(&set->stmt_list, struct stmt, list);
+
+		list_for_each_entry(elem_stmt, &elem->stmt_list, list) {
+			if (set_stmt->ops != elem_stmt->ops) {
+				return stmt_error(ctx, elem_stmt,
+						  "statement mismatch, element expects %s, "
+						  "but %s has type %s",
+						  elem_stmt->ops->name,
+						  set_is_map(set->flags) ? "map" : "set",
+						  set_stmt->ops->name);
+			}
+			set_stmt = list_next_entry(set_stmt, list);
 		}
 	}
 
+	return 0;
+}
+
+static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
+{
+	struct expr *elem = *expr;
+
+	if (ctx->set && __expr_evaluate_set_elem(ctx, elem) < 0)
+		return -1;
+
 	if (expr_evaluate(ctx, &elem->key) < 0)
 		return -1;
 
diff --git a/src/expression.c b/src/expression.c
index 87bd4d01bb72..58d73e9509b0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1248,7 +1248,13 @@ struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 static void set_elem_expr_print(const struct expr *expr,
 				 struct output_ctx *octx)
 {
+	struct stmt *stmt;
+
 	expr_print(expr->key, octx);
+	list_for_each_entry(stmt, &expr->stmt_list, list) {
+		nft_print(octx, " ");
+		stmt_print(stmt, octx);
+	}
 	if (expr->timeout) {
 		nft_print(octx, " timeout ");
 		time_print(expr->timeout, octx);
@@ -1257,19 +1263,18 @@ static void set_elem_expr_print(const struct expr *expr,
 		nft_print(octx, " expires ");
 		time_print(expr->expiration, octx);
 	}
-	if (expr->stmt) {
-		nft_print(octx, " ");
-		stmt_print(expr->stmt, octx);
-	}
 	if (expr->comment)
 		nft_print(octx, " comment \"%s\"", expr->comment);
 }
 
 static void set_elem_expr_destroy(struct expr *expr)
 {
+	struct stmt *stmt, *next;
+
 	xfree(expr->comment);
 	expr_free(expr->key);
-	stmt_free(expr->stmt);
+	list_for_each_entry_safe(stmt, next, &expr->stmt_list, list)
+		stmt_free(stmt);
 }
 
 static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
@@ -1279,6 +1284,7 @@ static void set_elem_expr_clone(struct expr *new, const struct expr *expr)
 	new->timeout = expr->timeout;
 	if (expr->comment)
 		new->comment = xstrdup(expr->comment);
+	init_list_head(&new->stmt_list);
 }
 
 static const struct expr_ops set_elem_expr_ops = {
@@ -1297,6 +1303,8 @@ struct expr *set_elem_expr_alloc(const struct location *loc, struct expr *key)
 	expr = expr_alloc(loc, EXPR_SET_ELEM, key->dtype,
 			  key->byteorder, key->len);
 	expr->key = key;
+	init_list_head(&expr->stmt_list);
+
 	return expr;
 }
 
diff --git a/src/json.c b/src/json.c
index 0b398bf0b25d..585d35326ac0 100644
--- a/src/json.c
+++ b/src/json.c
@@ -583,13 +583,15 @@ json_t *set_ref_expr_json(const struct expr *expr, struct output_ctx *octx)
 json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	json_t *root = expr_print_json(expr->key, octx);
+	struct stmt *stmt;
 	json_t *tmp;
 
 	if (!root)
 		return NULL;
 
 	/* these element attributes require formal set elem syntax */
-	if (expr->timeout || expr->expiration || expr->comment || expr->stmt) {
+	if (expr->timeout || expr->expiration || expr->comment ||
+	    !list_empty(&expr->stmt_list)) {
 		root = json_pack("{s:o}", "val", root);
 
 		if (expr->timeout) {
@@ -604,11 +606,13 @@ json_t *set_elem_expr_json(const struct expr *expr, struct output_ctx *octx)
 			tmp = json_string(expr->comment);
 			json_object_set_new(root, "comment", tmp);
 		}
-		if (expr->stmt) {
-			tmp = stmt_print_json(expr->stmt, octx);
+		list_for_each_entry(stmt, &expr->stmt_list, list) {
+			tmp = stmt_print_json(stmt, octx);
 			/* XXX: detect and complain about clashes? */
 			json_object_update_missing(root, tmp);
 			json_decref(tmp);
+			/* TODO: only one statement per element. */
+			break;
 		}
 		return json_pack("{s:o}", "elem", root);
 	}
diff --git a/src/mnl.c b/src/mnl.c
index cd12309b6ef8..84cfb2380f55 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1046,6 +1046,8 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct set *set = cmd->set;
 	struct nftnl_set *nls;
 	struct nlmsghdr *nlh;
+	struct stmt *stmt;
+	int num_stmts = 0;
 
 	nls = nftnl_set_alloc();
 	if (!nls)
@@ -1128,9 +1130,18 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
 
-	if (set->stmt) {
-		nftnl_set_set_data(nls, NFTNL_SET_EXPR,
-				   netlink_gen_stmt_stateful(set->stmt), 0);
+	list_for_each_entry(stmt, &set->stmt_list, list)
+		num_stmts++;
+
+	if (num_stmts == 1) {
+		list_for_each_entry(stmt, &set->stmt_list, list) {
+			nftnl_set_set_data(nls, NFTNL_SET_EXPR,
+					   netlink_gen_stmt_stateful(stmt), 0);
+			break;
+		}
+	} else if (num_stmts > 1) {
+		list_for_each_entry(stmt, &set->stmt_list, list)
+			nftnl_set_add_expr(nls, netlink_gen_stmt_stateful(stmt));
 	}
 
 	netlink_dump_set(nls, ctx);
diff --git a/src/netlink.c b/src/netlink.c
index ab0290926eaf..ec2dad29ace1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -104,6 +104,8 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	struct nftnl_set_elem *nlse;
 	struct nft_data_linearize nld;
 	struct nftnl_udata_buf *udbuf = NULL;
+	int num_exprs = 0;
+	struct stmt *stmt;
 	struct expr *key;
 
 	nlse = nftnl_set_elem_alloc();
@@ -138,9 +140,20 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	if (elem->expiration)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_EXPIRATION,
 				       elem->expiration);
-	if (elem->stmt)
-		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_EXPR,
-				   netlink_gen_stmt_stateful(elem->stmt), 0);
+	list_for_each_entry(stmt, &elem->stmt_list, list)
+		num_exprs++;
+
+	if (num_exprs == 1) {
+		list_for_each_entry(stmt, &elem->stmt_list, list) {
+			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_EXPR,
+					   netlink_gen_stmt_stateful(stmt), 0);
+		}
+	} else if (num_exprs > 1) {
+		list_for_each_entry(stmt, &elem->stmt_list, list) {
+			nftnl_set_elem_add_expr(nlse,
+						netlink_gen_stmt_stateful(stmt));
+		}
+	}
 	if (elem->comment || expr->elem_flags) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
@@ -766,6 +779,25 @@ static bool set_udata_key_valid(const struct expr *e, const struct datatype *d,
 	return div_round_up(e->len, BITS_PER_BYTE) == len / BITS_PER_BYTE;
 }
 
+struct setelem_parse_ctx {
+	struct set			*set;
+	struct nft_cache		*cache;
+	struct list_head		stmt_list;
+};
+
+static int set_elem_parse_expressions(struct nftnl_expr *e, void *data)
+{
+	struct setelem_parse_ctx *setelem_parse_ctx = data;
+	struct nft_cache *cache = setelem_parse_ctx->cache;
+	struct set *set = setelem_parse_ctx->set;
+	struct stmt *stmt;
+
+	stmt = netlink_parse_set_expr(set, cache, e);
+	list_add_tail(&stmt->list, &setelem_parse_ctx->stmt_list);
+
+	return 0;
+}
+
 struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				    const struct nftnl_set *nls)
 {
@@ -774,6 +806,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	enum byteorder databyteorder = BYTEORDER_INVALID;
 	const struct datatype *keytype, *datatype = NULL;
 	struct expr *typeof_expr_key, *typeof_expr_data;
+	struct setelem_parse_ctx set_parse_ctx;
 	const char *udata, *comment = NULL;
 	uint32_t flags, key, objtype = 0;
 	const struct datatype *dtype;
@@ -847,12 +880,22 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	if (comment)
 		set->comment = comment;
 
+	init_list_head(&set_parse_ctx.stmt_list);
+
 	if (nftnl_set_is_set(nls, NFTNL_SET_EXPR)) {
 		const struct nftnl_expr *nle;
+		struct stmt *stmt;
 
 		nle = nftnl_set_get(nls, NFTNL_SET_EXPR);
-		set->stmt = netlink_parse_set_expr(set, &ctx->nft->cache, nle);
+		stmt = netlink_parse_set_expr(set, &ctx->nft->cache, nle);
+		list_add_tail(&stmt->list, &set_parse_ctx.stmt_list);
+	} else if (nftnl_set_is_set(nls, NFTNL_SET_EXPRESSIONS)) {
+		set_parse_ctx.cache = &ctx->nft->cache;
+		set_parse_ctx.set = set;
+		nftnl_set_expr_foreach(nls, set_elem_parse_expressions,
+				       &set_parse_ctx);
 	}
+	list_splice_tail(&set_parse_ctx.stmt_list, &set->stmt_list);
 
 	if (datatype) {
 		dtype = set_datatype_alloc(datatype, databyteorder);
@@ -1107,10 +1150,16 @@ static void set_elem_parse_udata(struct nftnl_set_elem *nlse,
 int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 				struct set *set, struct nft_cache *cache)
 {
+	struct setelem_parse_ctx setelem_parse_ctx = {
+		.set	= set,
+		.cache	= cache,
+	};
 	struct nft_data_delinearize nld;
 	struct expr *expr, *key, *data;
 	uint32_t flags = 0;
 
+	init_list_head(&setelem_parse_ctx.stmt_list);
+
 	nld.value =
 		nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_KEY, &nld.len);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_FLAGS))
@@ -1141,10 +1190,17 @@ key_end:
 		set_elem_parse_udata(nlse, expr);
 	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPR)) {
 		const struct nftnl_expr *nle;
+		struct stmt *stmt;
 
 		nle = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_EXPR, NULL);
-		expr->stmt = netlink_parse_set_expr(set, cache, nle);
+		stmt = netlink_parse_set_expr(set, cache, nle);
+		list_add_tail(&stmt->list, &setelem_parse_ctx.stmt_list);
+	} else if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPRESSIONS)) {
+		nftnl_set_elem_expr_foreach(nlse, set_elem_parse_expressions,
+					    &setelem_parse_ctx);
 	}
+	list_splice_tail(&setelem_parse_ctx.stmt_list, &expr->stmt_list);
+
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		expr->flags |= EXPR_F_INTERVAL_END;
 		if (mpz_cmp_ui(set->key->value, 0) == 0)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 673ce4ad4080..58a5a4752002 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -624,10 +624,10 @@ int nft_lex(void *, void *, void *);
 %type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block
 %destructor { obj_free($$); }	obj_block_alloc
 
-%type <list>			stmt_list stateful_stmt_list
-%destructor { stmt_list_free($$); xfree($$); } stmt_list stateful_stmt_list
-%type <stmt>			stmt match_stmt verdict_stmt
-%destructor { stmt_free($$); }	stmt match_stmt verdict_stmt
+%type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
+%destructor { stmt_list_free($$); xfree($$); } stmt_list stateful_stmt_list set_elem_stmt_list
+%type <stmt>			stmt match_stmt verdict_stmt set_elem_stmt
+%destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt
 %type <stmt>			payload_stmt
@@ -1797,10 +1797,11 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->gc_int = $3;
 				$$ = $1;
 			}
-			|	set_block	COUNTER		stmt_separator
+			|	set_block	stateful_stmt_list		stmt_separator
 			{
-				$1->stmt = counter_stmt_alloc(&@$);
+				list_splice_tail($2, &$1->stmt_list);
 				$$ = $1;
+				free($2);
 			}
 			|	set_block	ELEMENTS	'='		set_block_expr
 			{
@@ -4052,7 +4053,12 @@ set_elem_expr		:	set_elem_expr_alloc
 			|	set_elem_expr_alloc		set_elem_expr_options
 			;
 
-set_elem_expr_alloc	:	set_lhs_expr
+set_elem_expr_alloc	:	set_lhs_expr	set_elem_stmt_list
+			{
+				$$ = set_elem_expr_alloc(&@1, $1);
+				list_splice_tail($2, &$$->stmt_list);
+			}
+			|	set_lhs_expr
 			{
 				$$ = set_elem_expr_alloc(&@1, $1);
 			}
@@ -4090,44 +4096,42 @@ set_elem_expr_options	:	set_elem_expr_option
 			|	set_elem_expr_options	set_elem_expr_option
 			;
 
-set_elem_expr_option	:	TIMEOUT			time_spec
+set_elem_stmt_list	:	set_elem_stmt
 			{
-				$<expr>0->timeout = $2;
+				$$ = xmalloc(sizeof(*$$));
+				init_list_head($$);
+				list_add_tail(&$1->list, $$);
 			}
-			|	EXPIRES		time_spec
+			|	set_elem_stmt_list	set_elem_stmt
 			{
-				$<expr>0->expiration = $2;
+				$$ = $1;
+				list_add_tail(&$2->list, $1);
 			}
-			|	COUNTER
+			;
+
+set_elem_stmt		:	COUNTER
 			{
-				$<expr>0->stmt = counter_stmt_alloc(&@$);
+				$$ = counter_stmt_alloc(&@$);
 			}
 			|	COUNTER	PACKETS	NUM	BYTES	NUM
 			{
-				struct stmt *stmt;
-
-				stmt = counter_stmt_alloc(&@$);
-				stmt->counter.packets = $3;
-				stmt->counter.bytes = $5;
-				$<expr>0->stmt = stmt;
+				$$ = counter_stmt_alloc(&@$);
+				$$->counter.packets = $3;
+				$$->counter.bytes = $5;
 			}
 			|	LIMIT   RATE    limit_mode      NUM     SLASH   time_unit       limit_burst_pkts
 			{
-				struct stmt *stmt;
-
-				stmt = limit_stmt_alloc(&@$);
-				stmt->limit.rate  = $4;
-				stmt->limit.unit  = $6;
-				stmt->limit.burst = $7;
-				stmt->limit.type  = NFT_LIMIT_PKTS;
-				stmt->limit.flags = $3;
-				$<expr>0->stmt = stmt;
+				$$ = limit_stmt_alloc(&@$);
+				$$->limit.rate  = $4;
+				$$->limit.unit  = $6;
+				$$->limit.burst = $7;
+				$$->limit.type  = NFT_LIMIT_PKTS;
+				$$->limit.flags = $3;
 			}
 			|       LIMIT   RATE    limit_mode      NUM     STRING  limit_burst_bytes
 			{
 				struct error_record *erec;
 				uint64_t rate, unit;
-				struct stmt *stmt;
 
 				erec = rate_parse(&@$, $5, &rate, &unit);
 				xfree($5);
@@ -4136,13 +4140,23 @@ set_elem_expr_option	:	TIMEOUT			time_spec
 					YYERROR;
 				}
 
-				stmt = limit_stmt_alloc(&@$);
-				stmt->limit.rate  = rate * $4;
-				stmt->limit.unit  = unit;
-				stmt->limit.burst = $6;
-				stmt->limit.type  = NFT_LIMIT_PKT_BYTES;
-				stmt->limit.flags = $3;
+				$$ = limit_stmt_alloc(&@$);
+				$$->limit.rate  = rate * $4;
+				$$->limit.unit  = unit;
+				$$->limit.burst = $6;
+				$$->limit.type  = NFT_LIMIT_PKT_BYTES;
+				$$->limit.flags = $3;
                         }
+			;
+
+set_elem_expr_option	:	TIMEOUT			time_spec
+			{
+				$<expr>0->timeout = $2;
+			}
+			|	EXPIRES		time_spec
+			{
+				$<expr>0->expiration = $2;
+			}
 			|	comment_spec
 			{
 				if (already_set($<expr>0->comment, &@1, state)) {
diff --git a/src/rule.c b/src/rule.c
index dddfdf5182b0..e4bb6bae276a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -338,6 +338,9 @@ struct set *set_alloc(const struct location *loc)
 	set->handle.set_id = ++set_id;
 	if (loc != NULL)
 		set->location = *loc;
+
+	init_list_head(&set->stmt_list);
+
 	return set;
 }
 
@@ -357,6 +360,7 @@ struct set *set_clone(const struct set *set)
 	new_set->policy		= set->policy;
 	new_set->automerge	= set->automerge;
 	new_set->desc		= set->desc;
+	init_list_head(&new_set->stmt_list);
 
 	return new_set;
 }
@@ -369,6 +373,8 @@ struct set *set_get(struct set *set)
 
 void set_free(struct set *set)
 {
+	struct stmt *stmt, *next;
+
 	if (--set->refcnt > 0)
 		return;
 	if (set->init != NULL)
@@ -376,7 +382,8 @@ void set_free(struct set *set)
 	if (set->comment)
 		xfree(set->comment);
 	handle_free(&set->handle);
-	stmt_free(set->stmt);
+	list_for_each_entry_safe(stmt, next, &set->stmt_list, list)
+		stmt_free(stmt);
 	expr_free(set->key);
 	expr_free(set->data);
 	xfree(set);
@@ -500,6 +507,7 @@ static void set_print_declaration(const struct set *set,
 				  struct output_ctx *octx)
 {
 	const char *delim = "";
+	struct stmt *stmt;
 	const char *type;
 	uint32_t flags;
 
@@ -570,14 +578,22 @@ static void set_print_declaration(const struct set *set,
 		nft_print(octx, "%s", opts->stmt_separator);
 	}
 
-	if (set->stmt) {
+	if (!list_empty(&set->stmt_list))
 		nft_print(octx, "%s%s", opts->tab, opts->tab);
+
+	if (!list_empty(&set->stmt_list)) {
 		octx->flags |= NFT_CTX_OUTPUT_STATELESS;
-		stmt_print(set->stmt, octx);
+		list_for_each_entry(stmt, &set->stmt_list, list) {
+			stmt_print(stmt, octx);
+			if (!list_is_last(&stmt->list, &set->stmt_list))
+				nft_print(octx, " ");
+		}
 		octx->flags &= ~NFT_CTX_OUTPUT_STATELESS;
-		nft_print(octx, "%s", opts->stmt_separator);
 	}
 
+	if (!list_empty(&set->stmt_list))
+		nft_print(octx, "%s", opts->stmt_separator);
+
 	if (set->automerge)
 		nft_print(octx, "%s%sauto-merge%s", opts->tab, opts->tab,
 			  opts->stmt_separator);
diff --git a/src/segtree.c b/src/segtree.c
index ba455a6a8137..6988d07b24fb 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -935,10 +935,8 @@ static void interval_expr_copy(struct expr *dst, struct expr *src)
 		dst->timeout = src->timeout;
 	if (src->expiration)
 		dst->expiration = src->expiration;
-	if (src->stmt) {
-		dst->stmt = src->stmt;
-		src->stmt = NULL;
-	}
+
+	list_splice_init(&src->stmt_list, &dst->stmt_list);
 }
 
 void interval_map_decompose(struct expr *set)
-- 
2.20.1

