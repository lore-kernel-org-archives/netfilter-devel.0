From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 01/16] src: consolidate table cache
Date: Mon,  6 Jul 2015 20:16:53 +0200
Message-ID: <1436206628-23894-2-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40423 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbbGFSLi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:38 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces the table cache that is populated before parsing and
evaluation. As a result, there is a single call to netlink_list_tables().

Follow up patches use this new table cache to store other objects that are
contained by the tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    3 +++
 src/main.c     |   30 +++++++++++++++++++++++---
 src/rule.c     |   64 ++++++++++++++++++++++++++++++++++++--------------------
 3 files changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 8ec7f91..b6aabda 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -63,6 +63,9 @@ extern void symbol_bind(struct scope *scope, const char *identifier,
 extern struct symbol *symbol_lookup(const struct scope *scope,
 				    const char *identifier);
 
+extern int cache_init(struct list_head *msgs);
+extern void cache_fini(void);
+
 enum table_flags {
 	TABLE_F_DORMANT		= (1 << 0),
 };
diff --git a/src/main.c b/src/main.c
index bfe589a..651bdbd 100644
--- a/src/main.c
+++ b/src/main.c
@@ -182,7 +182,6 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	bool batch_supported = netlink_batch_supported();
 	int ret = 0;
 
-	netlink_genid_get();
 	mnl_batch_init();
 
 	batch_seqnum = mnl_batch_begin();
@@ -224,25 +223,50 @@ out:
 	return ret;
 }
 
+static int nft_cache_init(struct list_head *msgs)
+{
+	netlink_genid_get();
+	return cache_init(msgs);
+}
+
+static void nft_cache_fini(void)
+{
+	cache_fini();
+}
+
 int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 {
 	struct cmd *cmd, *next;
 	int ret;
 
+retry:
+	ret = nft_cache_init(msgs);
+	if (ret < 0) {
+		nft_cache_fini();
+		if (errno == EINTR) {
+			netlink_restart();
+			goto retry;
+		}
+		return -1;
+	}
+
 	ret = nft_parse(scanner, state);
 	if (ret != 0 || state->nerrs > 0)
-		return -1;
-retry:
+		goto err1;
+
 	ret = nft_netlink(state, msgs);
 	if (ret < 0 && errno == EINTR) {
+		nft_cache_fini();
 		netlink_restart();
 		goto retry;
 	}
 
+err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
+	nft_cache_fini();
 
 	return ret;
 }
diff --git a/src/rule.c b/src/rule.c
index c7a4ef8..3813039 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -53,6 +53,39 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->comment = xstrdup(src->comment);
 }
 
+static LIST_HEAD(table_list);
+
+int cache_init(struct list_head *msgs)
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
+	ret = netlink_list_tables(&ctx, &handle, &internal_location);
+	if (ret < 0)
+		return -1;
+
+	list_splice_tail_init(&ctx.list, &table_list);
+
+	return 0;
+}
+
+void cache_fini(void)
+{
+	struct table *table, *next;
+
+	list_for_each_entry_safe(table, next, &table_list, list) {
+		list_del(&table->list);
+		table_free(table);
+	}
+}
+
 struct set *set_alloc(const struct location *loc)
 {
 	struct set *set;
@@ -516,8 +549,6 @@ void table_free(struct table *table)
 	xfree(table);
 }
 
-static LIST_HEAD(table_list);
-
 void table_add_hash(struct table *table)
 {
 	list_add_tail(&table->list, &table_list);
@@ -845,8 +876,6 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct rule *rule, *nrule;
 	struct chain *chain;
 
-	if (netlink_get_table(ctx, &cmd->handle, &cmd->location, table) < 0)
-		goto err;
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
 		goto err;
 	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
@@ -876,25 +905,19 @@ err:
 
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
@@ -1012,7 +1035,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *t, *nt;
+	struct table *t;
 	struct set *s, *ns;
 	struct netlink_ctx set_ctx;
 	LIST_HEAD(msgs);
@@ -1035,10 +1058,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		init_list_head(&msgs);
 		set_ctx.msgs = &msgs;
 
-		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
-
-		list_for_each_entry_safe(t, nt, &ctx->list, list) {
+		list_for_each_entry(t, &table_list, list) {
 			set_handle.family = t->handle.family;
 			set_handle.table = t->handle.table;
 
@@ -1052,8 +1072,6 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 				s->init = set_expr_alloc(&cmd->location);
 				set_add_hash(s, t);
 			}
-
-			table_add_hash(t);
 		}
 	}
 
-- 
1.7.10.4

