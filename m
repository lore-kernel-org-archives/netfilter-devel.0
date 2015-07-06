From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 05/16] src: consolidate set cache
Date: Mon,  6 Jul 2015 20:16:57 +0200
Message-ID: <1436206628-23894-6-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40436 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbbGFSLk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:40 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch populates the table cache only once through netlink_list_sets()
before parsing and evaluation. As a result, there is a single call to
netlink_list_sets().

After this change, we can rid of get_set(). This function was fine by the time
we had no transaction support, but this doesn't work for set objects that are
declared in this batch, so inquiring the kernel doesn't help since they are not
yet available.

This also adds cmd_error() to display an error from the evaluation step, when
the objects that the rule indicates do not exist.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   53 ++++++++++-------------------
 src/rule.c     |  103 ++++++++++++++++++++++++++++----------------------------
 2 files changed, 70 insertions(+), 86 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 475eb16..963622f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -109,37 +109,6 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
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
@@ -192,6 +161,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct error_record *erec;
 	struct symbol *sym;
+	struct table *table;
 	struct set *set;
 	struct expr *new;
 
@@ -213,9 +183,15 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		new = expr_clone(sym->expr);
 		break;
 	case SYMBOL_SET:
-		set = get_set(ctx, &ctx->cmd->handle, (*expr)->identifier);
+		table = table_lookup(&ctx->cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 ctx->cmd->handle.table);
+
+		set = set_lookup(table, (*expr)->identifier);
 		if (set == NULL)
-			return -1;
+			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
+					 (*expr)->identifier);
 		new = set_ref_expr_alloc(&(*expr)->location, set);
 		break;
 	}
@@ -1737,11 +1713,18 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
+	struct table *table;
 	struct set *set;
 
-	set = get_set(ctx, &ctx->cmd->handle, ctx->cmd->handle.set);
+	table = table_lookup(&ctx->cmd->handle);
+	if (table == NULL)
+		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+				 ctx->cmd->handle.table);
+
+	set = set_lookup(table, ctx->cmd->handle.set);
 	if (set == NULL)
-		return -1;
+		return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
+				 ctx->cmd->handle.set);
 
 	ctx->set = set;
 	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
diff --git a/src/rule.c b/src/rule.c
index 67bce43..8f0bc7e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -61,6 +61,7 @@ int cache_init(struct list_head *msgs)
 		.family = NFPROTO_UNSPEC,
 	};
 	struct netlink_ctx ctx;
+	struct table *table;
 	int ret;
 
 	memset(&ctx, 0, sizeof(ctx));
@@ -73,6 +74,15 @@ int cache_init(struct list_head *msgs)
 
 	list_splice_tail_init(&ctx.list, &table_list);
 
+	list_for_each_entry(table, &table_list, list) {
+		ret = netlink_list_sets(&ctx, &table->handle,
+					&internal_location);
+		list_splice_tail_init(&ctx.list, &table->sets);
+
+		if (ret < 0)
+			return -1;
+	}
+
 	return 0;
 }
 
@@ -543,11 +553,14 @@ struct table *table_alloc(void)
 void table_free(struct table *table)
 {
 	struct chain *chain, *next;
+	struct set *set, *nset;
 
 	if (--table->refcnt > 0)
 		return;
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
+	list_for_each_entry_safe(set, nset, &table->sets, list)
+		set_free(set);
 	handle_free(&table->handle);
 	scope_release(&table->scope);
 	xfree(table);
@@ -836,15 +849,11 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -913,6 +922,23 @@ err:
 	return -1;
 }
 
+static int do_list_sets_global(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+	struct set *set;
+
+	list_for_each_entry(table, &table_list, list) {
+		list_for_each_entry(set, &table->sets, list) {
+			if (netlink_get_setelems(ctx, &set->handle,
+						 &cmd->location, set) < 0)
+				return -1;
+
+			set_print(set);
+		}
+	}
+	return 0;
+}
+
 static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	unsigned int family = cmd->handle.family;
@@ -945,10 +971,25 @@ static int do_list_tables(void)
 	return 0;
 }
 
+static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
+		       struct table *table)
+{
+	struct set *set;
+
+	set = set_lookup(table, cmd->handle.set);
+	if (set == NULL)
+		return -1;
+
+	if (netlink_get_setelems(ctx, &cmd->handle, &cmd->location, set) < 0)
+		return -1;
+
+	set_print(set);
+	return 0;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
-	struct set *set;
 
 	if (cmd->handle.table != NULL)
 		table = table_lookup(&cmd->handle);
@@ -961,28 +1002,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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
-			set_print(set);
-		}
-		return 0;
+		return do_list_sets_global(ctx, cmd);
 	case CMD_OBJ_SET:
-		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		list_for_each_entry(set, &ctx->list, list) {
-			if (netlink_get_setelems(ctx, &cmd->handle,
-						 &cmd->location, set) < 0) {
-				goto err;
-			}
-			set_print(set);
-		}
-		return 0;
+		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
 		return do_list_ruleset(ctx, cmd);
 	default:
@@ -990,9 +1012,6 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	return 0;
-err:
-	table_cleanup(table);
-	return -1;
 }
 
 static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -1039,10 +1058,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1057,24 +1073,9 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
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

