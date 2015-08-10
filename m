From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 01/14] src: add cache infrastructure and use it for table objects
Date: Mon, 10 Aug 2015 13:50:35 +0200
Message-ID: <1439207448-22485-2-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbbHJLow (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:44:52 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces the generic object cache that is populated during the
evaluation phase.

The first client of this infrastructure are table objects. As a result, there
is a single call to netlink_list_tables().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    3 ++
 src/cli.c      |    1 +
 src/evaluate.c |    6 ++++
 src/main.c     |    2 +-
 src/rule.c     |   98 +++++++++++++++++++++++++++++++++++++++++++-------------
 5 files changed, 86 insertions(+), 24 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 8ec7f91..1520222 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -381,4 +381,7 @@ extern struct error_record *rule_postprocess(struct rule *rule);
 struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
+extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
+extern void cache_release(void);
+
 #endif /* NFTABLES_RULE_H */
diff --git a/src/cli.c b/src/cli.c
index fbae0ef..adffd6b 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -124,6 +124,7 @@ static void cli_complete(char *line)
 	nft_run(scanner, state, &msgs);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
+	cache_release();
 	iface_cache_release();
 }
 
diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..f8c7372 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2001,6 +2001,12 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 
 int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	int ret;
+
+	ret = cache_update(cmd->op, ctx->msgs);
+	if (ret < 0)
+		return ret;
+
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
diff --git a/src/main.c b/src/main.c
index a2c4f87..d6c9ccc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -182,7 +182,6 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	bool batch_supported = netlink_batch_supported();
 	int ret = 0;
 
-	netlink_genid_get();
 	mnl_batch_init();
 
 	batch_seqnum = mnl_batch_begin();
@@ -366,6 +365,7 @@ out:
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs);
 	xfree(buf);
+	cache_release();
 	iface_cache_release();
 
 	return rc;
diff --git a/src/rule.c b/src/rule.c
index 09d1ffd..60c5d72 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -53,6 +53,73 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->comment = xstrdup(src->comment);
 }
 
+static LIST_HEAD(table_list);
+
+static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h)
+{
+	int ret;
+
+	ret = netlink_list_tables(ctx, h, &internal_location);
+	if (ret < 0)
+		return -1;
+
+	list_splice_tail_init(&ctx->list, &table_list);
+	return 0;
+}
+
+static int cache_init(enum cmd_ops cmd, struct list_head *msgs)
+{
+	struct handle handle = {
+		.family = NFPROTO_UNSPEC,
+	};
+	struct netlink_ctx ctx;
+	int ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+	init_list_head(&ctx.list);
+	ctx.msgs = msgs;
+
+	ret = cache_init_tables(&ctx, &handle);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static bool cache_initialized;
+
+int cache_update(enum cmd_ops cmd, struct list_head *msgs)
+{
+	int ret;
+
+	if (cache_initialized)
+		return 0;
+replay:
+	netlink_genid_get();
+	ret = cache_init(cmd, msgs);
+	if (ret < 0) {
+		if (errno == EINTR) {
+			netlink_restart();
+			goto replay;
+		}
+		cache_release();
+		return -1;
+	}
+	cache_initialized = true;
+	return 0;
+}
+
+void cache_release(void)
+{
+	struct table *table, *next;
+
+	list_for_each_entry_safe(table, next, &table_list, list) {
+		list_del(&table->list);
+		table_free(table);
+	}
+	cache_initialized = false;
+}
+
 struct set *set_alloc(const struct location *loc)
 {
 	struct set *set;
@@ -516,8 +583,6 @@ void table_free(struct table *table)
 	xfree(table);
 }
 
-static LIST_HEAD(table_list);
-
 void table_add_hash(struct table *table)
 {
 	list_add_tail(&table->list, &table_list);
@@ -845,8 +910,6 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct rule *rule, *nrule;
 	struct chain *chain;
 
-	if (netlink_get_table(ctx, &cmd->handle, &cmd->location, table) < 0)
-		goto err;
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		goto err;
 	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
@@ -876,25 +939,19 @@ err:
 
 static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table, *next;
-	LIST_HEAD(tables);
-
-	if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
-		return -1;
-
-	list_splice_tail_init(&ctx->list, &tables);
+	unsigned int family = cmd->handle.family;
+	struct table *table;
 
-	list_for_each_entry_safe(table, next, &tables, list) {
-		table_add_hash(table);
+	list_for_each_entry(table, &table_list, list) {
+		if (family != NFPROTO_UNSPEC &&
+		    table->handle.family != family)
+			continue;
 
 		cmd->handle.family = table->handle.family;
 		cmd->handle.table = xstrdup(table->handle.table);
 
 		if (do_list_table(ctx, cmd, table) < 0)
 			return -1;
-
-		list_del(&table->list);
-		table_free(table);
 	}
 
 	return 0;
@@ -1015,7 +1072,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *t, *nt;
+	struct table *t;
 	struct set *s, *ns;
 	struct netlink_ctx set_ctx;
 	LIST_HEAD(msgs);
@@ -1038,10 +1095,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		init_list_head(&msgs);
 		set_ctx.msgs = &msgs;
 
-		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
-
-		list_for_each_entry_safe(t, nt, &ctx->list, list) {
+		list_for_each_entry(t, &table_list, list) {
 			set_handle.family = t->handle.family;
 			set_handle.table = t->handle.table;
 
@@ -1055,8 +1109,6 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 				s->init = set_expr_alloc(&cmd->location);
 				set_add_hash(s, t);
 			}
-
-			table_add_hash(t);
 		}
 	}
 
-- 
1.7.10.4

