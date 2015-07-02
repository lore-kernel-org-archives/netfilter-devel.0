From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v3 3/7] src: consolidate set cache
Date: Thu,  2 Jul 2015 20:25:08 +0200
Message-ID: <1435861512-23572-4-git-send-email-pablo@netfilter.org>
References: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53400 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbbGBSTq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 14:19:46 -0400
In-Reply-To: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch populates the table cache only once through netlink_list_sets() from
the initialization step. As a result, there is a single call to
netlink_list_sets().

The set cache initialization happens once the table cache is ready. On the
other hand, declared sets are added to the cache so they can be referenced from
this batch.

After this change, we can rid of get_set(). This function was fine by the time
we had no transaction support, but this doesn't work for set objects that are
declared in this batch, so consulting the kernel doesn't help since they are
not yet available.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    3 ++
 src/evaluate.c |   47 +++++++++----------------------
 src/main.c     |   10 ++++++-
 src/rule.c     |   86 ++++++++++++++++++++++++++++++++------------------------
 4 files changed, 76 insertions(+), 70 deletions(-)

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
index 576509c..28ddf12 100644
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
 
diff --git a/src/main.c b/src/main.c
index a84f2f6..1013497 100644
--- a/src/main.c
+++ b/src/main.c
@@ -227,11 +227,19 @@ static int nft_cache_init(void)
 {
 	netlink_genid_get();
 
-	return table_init_hash();
+	if (table_init_hash() < 0)
+		return -1;
+
+	if (set_init_hash() < 0) {
+		table_fini_hash();
+		return -1;
+	}
+	return 0;
 }
 
 static void nft_cache_fini(void)
 {
+	set_fini_hash();
 	table_fini_hash();
 }
 
diff --git a/src/rule.c b/src/rule.c
index 98bb1eb..838bd7e 100644
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
@@ -81,6 +83,42 @@ void set_free(struct set *set)
 	xfree(set);
 }
 
+int set_init_hash(void)
+{
+	struct netlink_ctx ctx;
+	struct table *table;
+	LIST_HEAD(msgs);
+	int ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+	init_list_head(&ctx.list);
+	ctx.msgs = &msgs;
+
+	list_for_each_entry(table, &table_list, list) {
+		ret = netlink_list_sets(&ctx, &table->handle,
+					&internal_location);
+		if (ret < 0) {
+			if (errno != EINTR)
+				erec_print_list(stdout, &msgs);
+
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
@@ -522,8 +560,6 @@ void table_free(struct table *table)
 	xfree(table);
 }
 
-static LIST_HEAD(table_list);
-
 int table_init_hash(void)
 {
 	struct handle handle = {
@@ -835,15 +871,11 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -960,15 +992,15 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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
+		list_for_each_entry(table, &table_list, list) {
+			list_for_each_entry(set, &table->sets, list) {
+				if (netlink_get_setelems(ctx, &set->handle,
+							 &cmd->location,
+							 set) < 0)
+					return -1;
+
+				set_print(set);
 			}
-			set_print(set);
 		}
 		return 0;
 	case CMD_OBJ_SET:
@@ -1037,10 +1069,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -1055,24 +1084,9 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
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

