From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 02/10] src: remove SET_F_* flag definitions
Date: Fri, 23 Dec 2016 15:26:47 +0100
Message-ID: <1482503215-25422-2-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40166 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941155AbcLWO1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A47ED2519A9
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 922EE8E66A
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 620398E677
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:08 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

They map exactly one to one to we have in the kernel headers, so use
kernel definitions instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 15 ---------------
 src/evaluate.c     | 34 +++++++++++++++++-----------------
 src/expression.c   |  4 ++--
 src/netlink.c      |  8 ++++----
 src/parser_bison.y |  6 +++---
 src/rule.c         | 32 ++++++++++++++++----------------
 src/segtree.c      |  4 ++--
 7 files changed, 44 insertions(+), 59 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index b9b4a19c9731..f74630c53d2b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -195,21 +195,6 @@ extern void rule_print(const struct rule *rule);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
 
 /**
- * enum set_flags
- *
- * @SET_F_CONSTANT:		Set content is constant
- * @SET_F_INTERVAL:		set includes ranges and/or prefix expressions
- */
-enum set_flags {
-	SET_F_ANONYMOUS		= 0x1,
-	SET_F_CONSTANT		= 0x2,
-	SET_F_INTERVAL		= 0x4,
-	SET_F_MAP		= 0x8,
-	SET_F_TIMEOUT		= 0x10,
-	SET_F_EVAL		= 0x20,
-};
-
-/**
  * struct set - nftables set
  *
  * @list:	table set list node
diff --git a/src/evaluate.c b/src/evaluate.c
index 8a3da54e5b2d..557c61c814df 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -70,7 +70,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct handle h;
 
 	set = set_alloc(&expr->location);
-	set->flags	= SET_F_ANONYMOUS | expr->set_flags;
+	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
 	set->handle.set = xstrdup(name),
 	set->keytype 	= keytype;
 	set->keylen	= keylen;
@@ -1060,7 +1060,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 
 	if (ctx->set &&
-	    !(ctx->set->flags & (SET_F_ANONYMOUS | SET_F_INTERVAL))) {
+	    !(ctx->set->flags & (NFT_SET_ANONYMOUS | NFT_SET_INTERVAL))) {
 		switch (elem->key->ops->type) {
 		case EXPR_PREFIX:
 			return expr_error(ctx->msgs, elem,
@@ -1106,10 +1106,10 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= i->set_flags;
 			expr_free(i);
 		} else if (!expr_is_singleton(i))
-			set->set_flags |= SET_F_INTERVAL;
+			set->set_flags |= NFT_SET_INTERVAL;
 	}
 
-	set->set_flags |= SET_F_CONSTANT;
+	set->set_flags |= NFT_SET_CONSTANT;
 
 	set->dtype = ctx->ectx.dtype;
 	set->len   = ctx->ectx.len;
@@ -1130,7 +1130,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 				  "Map expression can not be constant");
 
 	mappings = map->mappings;
-	mappings->set_flags |= SET_F_MAP;
+	mappings->set_flags |= NFT_SET_MAP;
 
 	switch (map->mappings->ops->type) {
 	case EXPR_SET:
@@ -1173,7 +1173,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
-	if (map->mappings->set->flags & SET_F_INTERVAL &&
+	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
 	    byteorder_conversion(ctx, &map->map, BYTEORDER_BIG_ENDIAN) < 0)
 		return -1;
 
@@ -1188,7 +1188,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (set == NULL)
 		return expr_error(ctx->msgs, mapping,
 				  "mapping outside of map context");
-	if (!(set->flags & SET_F_MAP))
+	if (!(set->flags & NFT_SET_MAP))
 		return set_error(ctx, set, "set is not a map");
 
 	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
@@ -1481,7 +1481,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 						 right->dtype->desc);
 
 		/* Data for range lookups needs to be in big endian order */
-		if (right->set->flags & SET_F_INTERVAL &&
+		if (right->set->flags & NFT_SET_INTERVAL &&
 		    byteorder_conversion(ctx, &rel->left,
 					 BYTEORDER_BIG_ENDIAN) < 0)
 			return -1;
@@ -1536,7 +1536,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		case EXPR_SET_REF:
 			assert(rel->op == OP_NEQ);
 			/* Data for range lookups needs to be in big endian order */
-			if (right->set->flags & SET_F_INTERVAL &&
+			if (right->set->flags & NFT_SET_INTERVAL &&
 			    byteorder_conversion(ctx, &rel->left, BYTEORDER_BIG_ENDIAN) < 0)
 				return -1;
 			break;
@@ -1847,9 +1847,9 @@ static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
 	/* Declare an empty set */
 	key = stmt->flow.key;
 	set = set_expr_alloc(&key->location);
-	set->set_flags |= SET_F_EVAL;
+	set->set_flags |= NFT_SET_EVAL;
 	if (key->timeout)
-		set->set_flags |= SET_F_TIMEOUT;
+		set->set_flags |= NFT_SET_TIMEOUT;
 
 	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
 					  key->dtype, key->len, set);
@@ -2549,7 +2549,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 ctx->cmd->handle.table);
 
-	type = set->flags & SET_F_MAP ? "map" : "set";
+	type = set->flags & NFT_SET_MAP ? "map" : "set";
 
 	if (set->keytype == NULL)
 		return set_error(ctx, set, "%s definition does not specify "
@@ -2560,7 +2560,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return set_error(ctx, set, "unqualified key data type "
 				 "specified in %s definition", type);
 
-	if (set->flags & SET_F_MAP) {
+	if (set->flags & NFT_SET_MAP) {
 		if (set->datatype == NULL)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
@@ -2584,7 +2584,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 
 	/* Default timeout value implies timeout support */
 	if (set->timeout)
-		set->flags |= SET_F_TIMEOUT;
+		set->flags |= NFT_SET_TIMEOUT;
 
 	return 0;
 }
@@ -2810,7 +2810,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		set = set_lookup(table, cmd->handle.set);
-		if (set == NULL || set->flags & (SET_F_MAP | SET_F_EVAL))
+		if (set == NULL || set->flags & (NFT_SET_MAP | NFT_SET_EVAL))
 			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
@@ -2820,7 +2820,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		set = set_lookup(table, cmd->handle.set);
-		if (set == NULL || !(set->flags & SET_F_EVAL))
+		if (set == NULL || !(set->flags & NFT_SET_EVAL))
 			return cmd_error(ctx, "Could not process rule: Flow table '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
@@ -2830,7 +2830,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		set = set_lookup(table, cmd->handle.set);
-		if (set == NULL || !(set->flags & SET_F_MAP))
+		if (set == NULL || !(set->flags & NFT_SET_MAP))
 			return cmd_error(ctx, "Could not process rule: Map '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
diff --git a/src/expression.c b/src/expression.c
index b7403c7009cd..1567870c631b 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -858,8 +858,8 @@ struct expr *map_expr_alloc(const struct location *loc, struct expr *arg,
 
 static void set_ref_expr_print(const struct expr *expr)
 {
-	if (expr->set->flags & SET_F_ANONYMOUS) {
-		if (expr->set->flags & SET_F_EVAL)
+	if (expr->set->flags & NFT_SET_ANONYMOUS) {
+		if (expr->set->flags & NFT_SET_EVAL)
 			printf("table %s", expr->set->handle.set);
 		else
 			expr_print(expr->set->init);
diff --git a/src/netlink.c b/src/netlink.c
index d6d00199d746..e37d3bf124a6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1175,7 +1175,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 
 	nftnl_set_set_u32(nls, NFTNL_SET_ID, set->handle.set_id);
 
-	if (!(set->flags & (SET_F_CONSTANT))) {
+	if (!(set->flags & NFT_SET_CONSTANT)) {
 		if (set->policy != NFT_SET_POL_PERFORMANCE)
 			nftnl_set_set_u32(nls, NFTNL_SET_POLICY, set->policy);
 
@@ -1505,7 +1505,7 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 	if (set->keytype->subtypes)
 		key = netlink_parse_concat_elem(set->keytype, key);
 
-	if (!(set->flags & SET_F_INTERVAL) &&
+	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    key->byteorder == BYTEORDER_HOST_ENDIAN)
 		mpz_switch_byteorder(key->value, key->len / BITS_PER_BYTE);
 
@@ -1858,7 +1858,7 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 
 	nls = netlink_set_alloc(nlh);
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-	if (flags & SET_F_ANONYMOUS)
+	if (flags & NFT_SET_ANONYMOUS)
 		goto out;
 
 	switch (monh->format) {
@@ -1920,7 +1920,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 
 	switch (monh->format) {
 	case NFTNL_OUTPUT_DEFAULT:
-		if (set->flags & SET_F_ANONYMOUS)
+		if (set->flags & NFT_SET_ANONYMOUS)
 			goto out;
 
 		/* we want to 'delinearize' the set_elem, but don't
diff --git a/src/parser_bison.y b/src/parser_bison.y
index deaaf06fa1c6..0f3ad915b701 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1092,9 +1092,9 @@ set_flag_list		:	set_flag_list	COMMA		set_flag
 			|	set_flag
 			;
 
-set_flag		:	CONSTANT	{ $$ = SET_F_CONSTANT; }
-			|	INTERVAL	{ $$ = SET_F_INTERVAL; }
-			|	TIMEOUT		{ $$ = SET_F_TIMEOUT; }
+set_flag		:	CONSTANT	{ $$ = NFT_SET_CONSTANT; }
+			|	INTERVAL	{ $$ = NFT_SET_INTERVAL; }
+			|	TIMEOUT		{ $$ = NFT_SET_TIMEOUT; }
 			;
 
 map_block_alloc		:	/* empty */
diff --git a/src/rule.c b/src/rule.c
index f1bb6cfe04ea..988305b57615 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -263,9 +263,9 @@ static void set_print_declaration(const struct set *set,
 	const char *type;
 	uint32_t flags;
 
-	if (set->flags & SET_F_MAP)
+	if (set->flags & NFT_SET_MAP)
 		type = "map";
-	else if (set->flags & SET_F_EVAL)
+	else if (set->flags & NFT_SET_EVAL)
 		type = "flow table";
 	else
 		type = "set";
@@ -281,12 +281,12 @@ static void set_print_declaration(const struct set *set,
 	printf(" %s {%s", set->handle.set, opts->nl);
 
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
-	if (set->flags & SET_F_MAP)
+	if (set->flags & NFT_SET_MAP)
 		printf(" : %s", set->datatype->name);
 
 	printf("%s", opts->stmt_separator);
 
-	if (!(set->flags & (SET_F_CONSTANT))) {
+	if (!(set->flags & (NFT_SET_CONSTANT))) {
 		if (set->policy != NFT_SET_POL_PERFORMANCE) {
 			printf("%s%spolicy %s%s", opts->tab, opts->tab,
 			       set_policy2str(set->policy),
@@ -302,19 +302,19 @@ static void set_print_declaration(const struct set *set,
 	flags = set->flags;
 	/* "timeout" flag is redundant if a default timeout exists */
 	if (set->timeout)
-		flags &= ~SET_F_TIMEOUT;
+		flags &= ~NFT_SET_TIMEOUT;
 
-	if (flags & (SET_F_CONSTANT | SET_F_INTERVAL | SET_F_TIMEOUT)) {
+	if (flags & (NFT_SET_CONSTANT | NFT_SET_INTERVAL | NFT_SET_TIMEOUT)) {
 		printf("%s%sflags ", opts->tab, opts->tab);
-		if (set->flags & SET_F_CONSTANT) {
+		if (set->flags & NFT_SET_CONSTANT) {
 			printf("%sconstant", delim);
 			delim = ",";
 		}
-		if (set->flags & SET_F_INTERVAL) {
+		if (set->flags & NFT_SET_INTERVAL) {
 			printf("%sinterval", delim);
 			delim = ",";
 		}
-		if (set->flags & SET_F_TIMEOUT) {
+		if (set->flags & NFT_SET_TIMEOUT) {
 			printf("%stimeout", delim);
 			delim = ",";
 		}
@@ -770,7 +770,7 @@ static void table_print(const struct table *table)
 	table_print_options(table, &delim);
 
 	list_for_each_entry(set, &table->sets, list) {
-		if (set->flags & SET_F_ANONYMOUS)
+		if (set->flags & NFT_SET_ANONYMOUS)
 			continue;
 		printf("%s", delim);
 		set_print(set);
@@ -888,7 +888,7 @@ static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			     struct set *set, struct expr *expr, bool excl)
 {
-	if (set->flags & SET_F_INTERVAL &&
+	if (set->flags & NFT_SET_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, expr, true) < 0)
 		return -1;
 
@@ -1006,7 +1006,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	table = table_lookup(h);
 	set = set_lookup(table, h->set);
 
-	if (set->flags & SET_F_INTERVAL &&
+	if (set->flags & NFT_SET_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, expr, false) < 0)
 		return -1;
 
@@ -1080,14 +1080,14 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		list_for_each_entry(set, &table->sets, list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
-			    (set->flags & SET_F_ANONYMOUS ||
-			    set->flags & SET_F_MAP))
+			    (set->flags & NFT_SET_ANONYMOUS ||
+			    set->flags & NFT_SET_MAP))
 				continue;
 			if (cmd->obj == CMD_OBJ_FLOWTABLES &&
-			    !(set->flags & SET_F_EVAL))
+			    !(set->flags & NFT_SET_EVAL))
 				continue;
 			if (cmd->obj == CMD_OBJ_MAPS &&
-			    !(set->flags & SET_F_MAP))
+			    !(set->flags & NFT_SET_MAP))
 				continue;
 			set_print_declaration(set, &opts);
 			printf("%s}%s", opts.tab, opts.nl);
diff --git a/src/segtree.c b/src/segtree.c
index 5b6cdd1d770d..db782f2293c0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -403,7 +403,7 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	 * Insert elements into tree
 	 */
 	for (n = 0; n < init->size; n++) {
-		if (init->set_flags & SET_F_MAP &&
+		if (init->set_flags & NFT_SET_MAP &&
 		    n < init->size - 1 &&
 		    interval_conflict(intervals[n], intervals[n+1]))
 			return expr_binary_error(msgs,
@@ -426,7 +426,7 @@ static bool segtree_needs_first_segment(const struct set *set,
 		 * 2) This set exists and it is empty.
 		 * 3) This set is created with a number of initial elements.
 		 */
-		if ((set->flags & SET_F_ANONYMOUS) ||
+		if ((set->flags & NFT_SET_ANONYMOUS) ||
 		    (set->init && set->init->size == 0) ||
 		    (set->init == init))
 			return true;
-- 
2.1.4

