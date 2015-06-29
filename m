From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/7] src: consolidate set cache
Date: Mon, 29 Jun 2015 19:54:00 +0200
Message-ID: <1435600444-21529-4-git-send-email-pablo@netfilter.org>
References: <1435600444-21529-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57258 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbbF2Rsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 13:48:41 -0400
In-Reply-To: <1435600444-21529-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch populates the table cache only once through netlink_list_sets() from
the initialization step. As a result, there is a single call to
netlink_list_sets().

The set cache initialization happens once the table cache is ready. On the
other hand, declared sets are added to the cache to they can be referenced from
this batch.

After this changes, we can rid of get_set(). This function was fine by the time
we had no transaction support, but this doesn't work for set objects that are
declared in this batch, so consulting the kernel doesn't help since they are
not yet available.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    3 ++
 src/evaluate.c |   57 +++++++++++++++----------------------
 src/main.c     |    6 ++++
 src/rule.c     |   85 ++++++++++++++++++++++++++++++++------------------------
 4 files changed, 80 insertions(+), 71 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ae69a8d..46dace5 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -219,6 +219,9 @@ struct set {
 extern struct set *set_alloc(const struct location *loc);
 extern struct set *set_get(struct set *set);
 extern void set_free(struct set *set);
+
+int set_init_hash(void);
+void set_fini_hash(void);
 extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
diff --git a/src/evaluate.c b/src/evaluate.c
index ac90162..fb466ba 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -107,37 +107,6 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	return set_ref_expr_alloc(&expr->location, set);
 }
 
-// FIXME
-#include <netlink.h>
-static struct set *get_set(struct eval_ctx *ctx, const struct handle *h,
-			   const char *identifier)
-{
-	struct netlink_ctx nctx = {
-		.msgs = ctx->msgs,
-	};
-	struct handle handle;
-	struct set *set;
-	int err;
-
-	if (ctx->table != NULL) {
-		set = set_lookup(ctx->table, identifier);
-		if (set != NULL)
-			return set;
-	}
-
-	init_list_head(&nctx.list);
-
-	memset(&handle, 0, sizeof(handle));
-	handle_merge(&handle, h);
-	handle.set = xstrdup(identifier);
-	err = netlink_get_set(&nctx, &handle, &internal_location);
-	handle_free(&handle);
-
-	if (err < 0)
-		return NULL;
-	return list_first_entry(&nctx.list, struct set, list);
-}
-
 static enum ops byteorder_conversion_op(struct expr *expr,
 					enum byteorder byteorder)
 {
@@ -190,6 +159,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct error_record *erec;
 	struct symbol *sym;
+	struct table *table;
 	struct set *set;
 	struct expr *new;
 
@@ -211,7 +181,13 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		new = expr_clone(sym->expr);
 		break;
 	case SYMBOL_SET:
-		set = get_set(ctx, &ctx->cmd->handle, (*expr)->identifier);
+		table = table_lookup(&ctx->cmd->handle);
+		if (table == NULL)
+			return expr_error(ctx->msgs, *expr,
+					  "missing table '%s'",
+					  (*expr)->identifier);
+
+		set = set_lookup(table, (*expr)->identifier);
 		if (set == NULL)
 			return -1;
 		new = set_ref_expr_alloc(&(*expr)->location, set);
@@ -1735,9 +1711,14 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
+	struct table *table;
 	struct set *set;
 
-	set = get_set(ctx, &ctx->cmd->handle, ctx->cmd->handle.set);
+	table = table_lookup(&ctx->cmd->handle);
+	if (table == NULL)
+		return -1;
+
+	set = set_lookup(table, ctx->cmd->handle.set);
 	if (set == NULL)
 		return -1;
 
@@ -1751,6 +1732,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 
 static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 {
+	struct table *table;
 	const char *type;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
@@ -1775,7 +1757,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		set->flags |= SET_F_TIMEOUT;
 
 	if (!(set->flags & SET_F_MAP))
-		return 0;
+		goto out;
 
 	if (set->datatype == NULL)
 		return set_error(ctx, set, "map definition does not specify "
@@ -1786,6 +1768,13 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return set_error(ctx, set, "unqualified mapping data type "
 				 "specified in map definition");
 
+out:
+	table = table_lookup(&set->handle);
+	if (table == NULL)
+		return set_error(ctx, set, "cannot find table");
+
+	set_add_hash(set, table);
+	set_get(set);
 	return 0;
 }
 
diff --git a/src/main.c b/src/main.c
index 7d559df..ec93877 100644
--- a/src/main.c
+++ b/src/main.c
@@ -232,6 +232,11 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 	if (table_init_hash() < 0)
 		return -1;
 
+	if (set_init_hash() < 0) {
+		table_fini_hash();
+		return -1;
+	}
+
 	ret = nft_parse(scanner, state);
 	if (ret != 0 || state->nerrs > 0) {
 		table_fini_hash();
@@ -248,6 +253,7 @@ retry:
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
+	set_fini_hash();
 	table_fini_hash();
 
 	return ret;
diff --git a/src/rule.c b/src/rule.c
index d250549..1997b81 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -28,6 +28,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 
+static LIST_HEAD(table_list);
+
 void handle_free(struct handle *h)
 {
 	xfree(h->table);
@@ -81,6 +83,47 @@ void set_free(struct set *set)
 	xfree(set);
 }
 
+int set_init_hash(void)
+{
+	struct netlink_ctx ctx;
+	struct table *table;
+	LIST_HEAD(msgs);
+	int ret;
+
+retry:
+	netlink_genid_get();
+	memset(&ctx, 0, sizeof(ctx));
+	init_list_head(&ctx.list);
+	ctx.msgs = &msgs;
+
+	list_for_each_entry(table, &table_list, list) {
+		ret = netlink_list_sets(&ctx, &table->handle,
+					&internal_location);
+		if (ret < 0) {
+			if (errno == EINTR) {
+				set_fini_hash();
+				goto retry;
+			}
+
+			erec_print_list(stdout, &msgs);
+			return ret;
+		}
+		list_splice_tail_init(&ctx.list, &table->sets);
+	}
+
+	return 0;
+}
+
+void set_fini_hash(void)
+{
+	struct set *set, *next;
+	struct table *table;
+
+	list_for_each_entry(table, &table_list, list)
+		list_for_each_entry_safe(set, next, &table->sets, list)
+			set_free(set);
+}
+
 void set_add_hash(struct set *set, struct table *table)
 {
 	list_add_tail(&set->list, &table->sets);
@@ -522,8 +565,6 @@ void table_free(struct table *table)
 	xfree(table);
 }
 
-static LIST_HEAD(table_list);
-
 int table_init_hash(void)
 {
 	struct handle handle = {
@@ -850,15 +891,11 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_list_sets(struct netlink_ctx *ctx, const struct location *loc,
 			struct table *table)
 {
-	struct set *set, *nset;
-
-	if (netlink_list_sets(ctx, &table->handle, loc) < 0)
-		return -1;
+	struct set *set;
 
-	list_for_each_entry_safe(set, nset, &ctx->list, list) {
+	list_for_each_entry(set, &table->sets, list) {
 		if (netlink_get_setelems(ctx, &set->handle, loc, set) < 0)
 			return -1;
-		list_move_tail(&set->list, &table->sets);
 	}
 	return 0;
 }
@@ -976,16 +1013,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAIN:
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_SETS:
-		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
-
-		list_for_each_entry(set, &ctx->list, list){
-			if (netlink_get_setelems(ctx, &set->handle,
-						 &cmd->location, set) < 0) {
-				return -1;
-			}
+		list_for_each_entry(set, &table->sets, list)
 			set_print(set);
-		}
 		return 0;
 	case CMD_OBJ_SET:
 		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
@@ -1053,10 +1082,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *t;
-	struct set *s, *ns;
-	struct netlink_ctx set_ctx;
-	LIST_HEAD(msgs);
-	struct handle set_handle;
+	struct set *s;
 	struct netlink_mon_handler monhandler;
 
 	/* cache only needed if monitoring:
@@ -1071,24 +1097,9 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		monhandler.cache_needed = false;
 
 	if (monhandler.cache_needed) {
-		memset(&set_ctx, 0, sizeof(set_ctx));
-		init_list_head(&msgs);
-		set_ctx.msgs = &msgs;
-
 		list_for_each_entry(t, &table_list, list) {
-			set_handle.family = t->handle.family;
-			set_handle.table = t->handle.table;
-
-			init_list_head(&set_ctx.list);
-
-			if (netlink_list_sets(&set_ctx, &set_handle,
-					      &cmd->location) < 0)
-				return -1;
-
-			list_for_each_entry_safe(s, ns, &set_ctx.list, list) {
+			list_for_each_entry(s, &t->sets, list)
 				s->init = set_expr_alloc(&cmd->location);
-				set_add_hash(s, t);
-			}
 		}
 	}
 
-- 
1.7.10.4

