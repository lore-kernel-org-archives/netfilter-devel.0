From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft, v3] mnl: check for NLM_F_DUMP_INTR when dumping object lists
Date: Sat, 12 Jul 2014 14:47:57 +0200
Message-ID: <1405169277-5287-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaGLMsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:48:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This flag allows to detect that an update has ocurred while dumping
any of the object lists. In case of interference, nft cancels the
netlink socket to skip processing the remaining stale entries and
it retries to obtain fresh list of objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Changes from v3: Missing EINTR handling in netlink_get_setelems and
netlink_dump_ruleset.

 include/netlink.h |    2 ++
 src/main.c        |    8 ++++++-
 src/netlink.c     |   42 ++++++++++++++++++++++++++++++-----
 src/rule.c        |   64 +++++++++++++++++++++++++++++++----------------------
 4 files changed, 83 insertions(+), 33 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 4ef7365..af5dcd9 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -137,6 +137,8 @@ extern void netlink_dump_expr(struct nft_rule_expr *nle);
 extern void netlink_dump_set(struct nft_set *nls);
 
 extern int netlink_batch_send(struct list_head *err_list);
+
+extern void netlink_restart(void);
 extern void netlink_abi_error(void) __noreturn;
 extern int netlink_io_error(struct netlink_ctx *ctx,
 			    const struct location *loc, const char *fmt, ...);
diff --git a/src/main.c b/src/main.c
index a446bc6..30ea2c6 100644
--- a/src/main.c
+++ b/src/main.c
@@ -223,8 +223,14 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 	ret = nft_parse(scanner, state);
 	if (ret != 0 || state->nerrs > 0)
 		return -1;
+retry:
+	ret = nft_netlink(state, msgs);
+	if (ret < 0 && errno == EINTR) {
+		netlink_restart();
+		goto retry;
+	}
 
-	return nft_netlink(state, msgs);
+	return ret;
 }
 
 int main(int argc, char * const *argv)
diff --git a/src/netlink.c b/src/netlink.c
index 987dd63..afad5a4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -70,6 +70,12 @@ static void __exit netlink_close_sock(void)
 		mnl_socket_close(nf_mon_sock);
 }
 
+void netlink_restart(void)
+{
+	netlink_close_sock();
+	netlink_open_sock();
+}
+
 static void netlink_open_mon_sock(void)
 {
 	nf_mon_sock = nfsock_open();
@@ -443,10 +449,14 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 	struct nft_rule_list *rule_cache;
 
 	rule_cache = mnl_nft_rule_dump(nf_sock, h->family);
-	if (rule_cache == NULL)
+	if (rule_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
 		return netlink_io_error(ctx, loc,
 					"Could not receive rules from kernel: %s",
 					strerror(errno));
+	}
 
 	ctx->data = h;
 	nft_rule_list_foreach(rule_cache, list_rule_cb, ctx);
@@ -704,10 +714,14 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 	struct chain *chain;
 
 	chain_cache = mnl_nft_chain_dump(nf_sock, h->family);
-	if (chain_cache == NULL)
+	if (chain_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
 		return netlink_io_error(ctx, loc,
 					"Could not receive chains from kernel: %s",
 					strerror(errno));
+	}
 
 	ctx->data = h;
 	nft_chain_list_foreach(chain_cache, list_chain_cb, ctx);
@@ -907,10 +921,14 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 	struct nft_table_list *table_cache;
 
 	table_cache = mnl_nft_table_dump(nf_sock, h->family);
-	if (table_cache == NULL)
+	if (table_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
 		return netlink_io_error(ctx, loc,
 					"Could not receive tables from kernel: %s",
 					strerror(errno));
+	}
 
 	nft_table_list_foreach(table_cache, list_table_cb, ctx);
 	nft_table_list_free(table_cache);
@@ -1177,10 +1195,14 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	set_cache = mnl_nft_set_dump(nf_sock, h->family, h->table);
-	if (set_cache == NULL)
+	if (set_cache == NULL) {
+		if (errno == EINTR)
+			return -1;
+
 		return netlink_io_error(ctx, loc,
 					"Could not receive sets from kernel: %s",
 					strerror(errno));
+	}
 
 	err = nft_set_list_foreach(set_cache, list_set_cb, ctx);
 	nft_set_list_free(set_cache);
@@ -1393,8 +1415,12 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	netlink_dump_set(nls);
 
 	err = mnl_nft_setelem_get(nf_sock, nls);
-	if (err < 0)
+	if (err < 0) {
+		if (errno == EINTR)
+			return -1;
+
 		goto out;
+	}
 
 	ctx->set = set;
 	set->init = set_expr_alloc(loc);
@@ -1423,9 +1449,13 @@ struct nft_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 	struct nft_ruleset *rs;
 
 	rs = mnl_nft_ruleset_dump(nf_sock, h->family);
-	if (rs == NULL)
+	if (rs == NULL) {
+		if (errno == EINTR)
+			return NULL;
+
 		netlink_io_error(ctx, loc, "Could not receive ruleset: %s",
 				 strerror(errno));
+	}
 
 	return rs;
 }
diff --git a/src/rule.c b/src/rule.c
index a7bc6f4..1e54526 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -14,6 +14,7 @@
 #include <stdint.h>
 #include <string.h>
 #include <inttypes.h>
+#include <errno.h>
 
 #include <statement.h>
 #include <rule.h>
@@ -701,12 +702,28 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static void do_command_list_cleanup(struct table *table)
+{
+	struct chain *chain, *nchain;
+	struct set *set, *nset;
+
+	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
+		list_del(&chain->list);
+		chain_free(chain);
+	}
+
+	list_for_each_entry_safe(set, nset, &table->sets, list) {
+		list_del(&set->list);
+		set_free(set);
+	}
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
-	struct chain *chain, *nchain;
+	struct chain *chain;
 	struct rule *rule, *nrule;
-	struct set *set, *nset;
+	struct set *set;
 
 	/* No need to allocate the table object when listing all tables */
 	if (cmd->handle.table != NULL) {
@@ -726,7 +743,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 
 			if (netlink_list_tables(ctx, &cmd->handle,
 						&cmd->location) < 0)
-				return -1;
+				goto err;
 
 			list_for_each_entry(table, &ctx->list, list) {
 				printf("table %s\n", table->handle.table);
@@ -735,39 +752,41 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		}
 		/* List content of this table */
 		if (do_list_sets(ctx, &cmd->location, table) < 0)
-			return -1;
+			goto err;
 		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
+			goto err;
 		list_splice_tail_init(&ctx->list, &table->chains);
 		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
+			goto err;
 		break;
 	case CMD_OBJ_CHAIN:
 		if (do_list_sets(ctx, &cmd->location, table) < 0)
-			return -1;
+			goto err;
 		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
+			goto err;
 		list_splice_tail_init(&ctx->list, &table->chains);
 		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
+			goto err;
 		break;
 	case CMD_OBJ_SETS:
 		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
+			goto err;
 		list_for_each_entry(set, &ctx->list, list){
 			if (netlink_get_setelems(ctx, &set->handle,
-						 &cmd->location, set) < 0)
-				return -1;
+						 &cmd->location, set) < 0) {
+				goto err;
+			}
 			set_print(set);
 		}
 		return 0;
 	case CMD_OBJ_SET:
 		if (netlink_get_set(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
+			goto err;
 		list_for_each_entry(set, &ctx->list, list) {
 			if (netlink_get_setelems(ctx, &cmd->handle,
-						 &cmd->location, set) < 0)
-				return -1;
+						 &cmd->location, set) < 0) {
+				goto err;
+			}
 			set_print(set);
 		}
 		return 0;
@@ -787,18 +806,11 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	table_print(table);
-
-	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
-		list_del(&chain->list);
-		chain_free(chain);
-	}
-
-	list_for_each_entry_safe(set, nset, &table->sets, list) {
-		list_del(&set->list);
-		set_free(set);
-	}
-
+	do_command_list_cleanup(table);
 	return 0;
+err:
+	do_command_list_cleanup(table);
+	return -1;
 }
 
 static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
-- 
1.7.10.4

