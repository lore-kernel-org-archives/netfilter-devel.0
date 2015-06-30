From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/7] src: consolidate table cache
Date: Tue, 30 Jun 2015 17:10:12 +0200
Message-ID: <20150630151012.GA4559@salvia>
References: <1435600444-21529-1-git-send-email-pablo@netfilter.org>
 <1435600444-21529-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55847 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbbF3PEr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jun 2015 11:04:47 -0400
Content-Disposition: inline
In-Reply-To: <1435600444-21529-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have a new round to revisit the generation ID checks, that were not
correct in the previous patch.

--C7zPtVaVf+AK4Oqc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-consolidate-table-cache.patch"

>From d55709f87108645269ea478746cf98a63bb2e637 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 26 Jun 2015 11:33:22 +0200
Subject: [PATCH nft 1/7,v2] src: consolidate table cache

This patch populates the table cache only once through netlink_list_tables()
from the initialization step. As a result, there is a single call to
netlink_list_tables().

Then, new table declarations are also added to this cache, thus follow up calls
to table_lookup() for tables that don't exist yet in the kernel will be found
in the cache.

Note that table_alloc() inserts the object in the cache and table_free()
removes the object from the cache and it releases it.

Table objects may be released from cmd_free() or after all commands in the file
have been processed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Rework v1 to fix generation ID checks.

 include/rule.h |    3 +++
 src/main.c     |   29 ++++++++++++++++++++--
 src/netlink.c  |   12 +++------
 src/rule.c     |   75 +++++++++++++++++++++++++++++++++++---------------------
 4 files changed, 80 insertions(+), 39 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 5d44599..ae69a8d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -89,6 +89,9 @@ struct table {
 
 extern struct table *table_alloc(void);
 extern void table_free(struct table *table);
+
+extern int table_init_hash(void);
+extern void table_fini_hash(void);
 extern void table_add_hash(struct table *table);
 extern struct table *table_lookup(const struct handle *h);
 
diff --git a/src/main.c b/src/main.c
index bfe589a..a84f2f6 100644
--- a/src/main.c
+++ b/src/main.c
@@ -182,7 +182,6 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs)
 	bool batch_supported = netlink_batch_supported();
 	int ret = 0;
 
-	netlink_genid_get();
 	mnl_batch_init();
 
 	batch_seqnum = mnl_batch_begin();
@@ -224,18 +223,43 @@ out:
 	return ret;
 }
 
+static int nft_cache_init(void)
+{
+	netlink_genid_get();
+
+	return table_init_hash();
+}
+
+static void nft_cache_fini(void)
+{
+	table_fini_hash();
+}
+
+static int nft_cache_restart(void)
+{
+	nft_cache_fini();
+	return nft_cache_init();
+}
+
 int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 {
 	struct cmd *cmd, *next;
 	int ret;
 
+	if (nft_cache_init() < 0)
+		return -1;
+
 	ret = nft_parse(scanner, state);
-	if (ret != 0 || state->nerrs > 0)
+	if (ret != 0 || state->nerrs > 0) {
+		nft_cache_fini();
 		return -1;
+	}
 retry:
 	ret = nft_netlink(state, msgs);
 	if (ret < 0 && errno == EINTR) {
 		netlink_restart();
+		if (nft_cache_restart() < 0)
+			return -1;
 		goto retry;
 	}
 
@@ -243,6 +267,7 @@ retry:
 		list_del(&cmd->list);
 		cmd_free(cmd);
 	}
+	nft_cache_fini();
 
 	return ret;
 }
diff --git a/src/netlink.c b/src/netlink.c
index 429eed4..4b57aab 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -926,10 +926,8 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 static int list_table_cb(struct nft_table *nlt, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
-	struct table *table;
 
-	table = netlink_delinearize_table(ctx, nlt);
-	list_add_tail(&table->list, &ctx->list);
+	netlink_delinearize_table(ctx, nlt);
 
 	return 0;
 }
@@ -972,7 +970,7 @@ int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
 
 	ntable = netlink_delinearize_table(ctx, nlt);
 	table->flags = ntable->flags;
-	xfree(ntable);
+	table_free(ntable);
 out:
 	nft_table_free(nlt);
 	return err;
@@ -1963,13 +1961,10 @@ static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
 					  const struct nlmsghdr *nlh)
 {
 	struct nft_table *nlt;
-	struct table *t;
 
 	nlt = netlink_table_alloc(nlh);
-	t = netlink_delinearize_table(monh->ctx, nlt);
+	netlink_delinearize_table(monh->ctx, nlt);
 	nft_table_free(nlt);
-
-	table_add_hash(t);
 }
 
 static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
@@ -1987,7 +1982,6 @@ static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
 	if (t == NULL)
 		goto out;
 
-	list_del(&t->list);
 	table_free(t);
 out:
 	nft_table_free(nlt);
diff --git a/src/rule.c b/src/rule.c
index b2090dd..36b8a5e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -20,6 +20,7 @@
 #include <rule.h>
 #include <utils.h>
 #include <netlink.h>
+#include <erec.h>
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -504,6 +505,8 @@ struct table *table_alloc(void)
 	init_list_head(&table->chains);
 	init_list_head(&table->sets);
 	init_list_head(&table->scope.symbols);
+	table_add_hash(table);
+
 	return table;
 }
 
@@ -515,11 +518,46 @@ void table_free(struct table *table)
 		chain_free(chain);
 	handle_free(&table->handle);
 	scope_release(&table->scope);
+	list_del(&table->list);
 	xfree(table);
 }
 
 static LIST_HEAD(table_list);
 
+int table_init_hash(void)
+{
+	struct handle handle = {
+		.family = NFPROTO_UNSPEC,
+	};
+	struct netlink_ctx ctx;
+	LIST_HEAD(msgs);
+	int ret;
+
+	memset(&ctx, 0, sizeof(ctx));
+	init_list_head(&ctx.list);
+	ctx.msgs = &msgs;
+
+	ret = netlink_list_tables(&ctx, &handle, &internal_location);
+	if (ret < 0) {
+		if (errno != EINTR)
+			erec_print_list(stdout, &msgs);
+
+		return ret;
+	}
+
+	list_splice_tail_init(&ctx.list, &table_list);
+
+	return 0;
+}
+
+void table_fini_hash(void)
+{
+	struct table *table, *next;
+
+	list_for_each_entry_safe(table, next, &table_list, list)
+		table_free(table);
+}
+
 void table_add_hash(struct table *table)
 {
 	list_add_tail(&table->list, &table_list);
@@ -878,25 +916,18 @@ err:
 
 static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table, *next;
-	LIST_HEAD(tables);
-
-	if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
-		return -1;
-
-	list_splice_tail_init(&ctx->list, &tables);
+	struct table *table;
 
-	list_for_each_entry_safe(table, next, &tables, list) {
-		table_add_hash(table);
+	list_for_each_entry(table, &table_list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    table->handle.family != cmd->handle.family)
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
@@ -913,23 +944,17 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		if (table == NULL) {
 			table = table_alloc();
 			handle_merge(&table->handle, &cmd->handle);
-			table_add_hash(table);
 		}
 	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table) {
-			/* List all existing tables */
 			struct table *table;
 
-			if (netlink_list_tables(ctx, &cmd->handle,
-						&cmd->location) < 0)
-				return -1;
-
-			list_for_each_entry(table, &ctx->list, list) {
+			list_for_each_entry(table, &table_list, list)
 				printf("table %s\n", table->handle.table);
-			}
+
 			return 0;
 		}
 		return do_list_table(ctx, cmd, table);
@@ -993,7 +1018,6 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	table = table_alloc();
 	handle_merge(&table->handle, &cmd->handle);
-	table_add_hash(table);
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
@@ -1013,7 +1037,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *t, *nt;
+	struct table *t;
 	struct set *s, *ns;
 	struct netlink_ctx set_ctx;
 	LIST_HEAD(msgs);
@@ -1036,10 +1060,7 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 		init_list_head(&msgs);
 		set_ctx.msgs = &msgs;
 
-		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
-			return -1;
-
-		list_for_each_entry_safe(t, nt, &ctx->list, list) {
+		list_for_each_entry(t, &table_list, list) {
 			set_handle.family = t->handle.family;
 			set_handle.table = t->handle.table;
 
@@ -1053,8 +1074,6 @@ static int do_command_monitor(struct netlink_ctx *ctx, struct cmd *cmd)
 				s->init = set_expr_alloc(&cmd->location);
 				set_add_hash(s, t);
 			}
-
-			table_add_hash(t);
 		}
 	}
 
-- 
1.7.10.4


--C7zPtVaVf+AK4Oqc--
