Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22C5C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9908420714
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 18:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732441AbgG1S3E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:29:04 -0400
Received: from correo.us.es ([193.147.175.20]:44552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732437AbgG1S3D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 14:29:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9164115AEAE
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:29:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 807B5DA73D
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:29:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 761BFDA78F; Tue, 28 Jul 2020 20:29:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4629DA73D
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jul 2020 20:28:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BEF844265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 20:28:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] src: remove cache lookups after the evaluation phase
Date:   Tue, 28 Jul 2020 20:28:53 +0200
Message-Id: <20200728182854.4473-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200728182854.4473-1-pablo@netfilter.org>
References: <20200728182854.4473-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a new field to the cmd structure for elements to store a
reference to the set. This saves an extra lookup in the netlink bytecode
generation step.

This patch also allows to incrementally update during the evaluation
phase according to the command actions, which is required by the follow
up ("evaluate: remove table from cache on delete table") bugfix patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |  2 +-
 include/netlink.h    |  2 +-
 include/rule.h       |  4 ++++
 src/evaluate.c       | 13 ++++++++-----
 src/netlink.c        |  4 ++--
 src/rule.c           | 43 +++++++++++++++++--------------------------
 src/segtree.c        | 17 ++++++-----------
 7 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 0210a3cb5314..130912a89e04 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -479,7 +479,7 @@ extern void interval_map_decompose(struct expr *set);
 extern struct expr *get_set_intervals(const struct set *set,
 				      const struct expr *init);
 struct table;
-extern int get_set_decompose(struct table *table, struct set *set);
+extern int get_set_decompose(struct set *cache_set, struct set *set);
 
 extern struct expr *mapping_expr_alloc(const struct location *loc,
 				       struct expr *from, struct expr *to);
diff --git a/include/netlink.h b/include/netlink.h
index 14fcec160e20..1077096ea0b1 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -149,7 +149,7 @@ extern struct stmt *netlink_parse_set_expr(const struct set *set,
 extern int netlink_list_setelems(struct netlink_ctx *ctx,
 				 const struct handle *h, struct set *set);
 extern int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
-			       const struct location *loc, struct table *table,
+			       const struct location *loc, struct set *cache_set,
 			       struct set *set, struct expr *init);
 extern int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 				       struct set *set,
diff --git a/include/rule.h b/include/rule.h
index 4de7a0d950ec..60eadfa3c9a2 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -683,6 +683,10 @@ struct cmd {
 		void		*data;
 		struct expr	*expr;
 		struct set	*set;
+		struct {
+			struct expr	*expr;	/* same offset as cmd->expr */
+			struct set	*set;
+		} elem;
 		struct rule	*rule;
 		struct chain	*chain;
 		struct table	*table;
diff --git a/src/evaluate.c b/src/evaluate.c
index bb504962ea8d..26d73959db58 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3560,7 +3560,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
-static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
+static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct set *set;
@@ -3576,9 +3576,12 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 
 	ctx->set = set;
 	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
-	if (expr_evaluate(ctx, expr) < 0)
+	if (expr_evaluate(ctx, &cmd->expr) < 0)
 		return -1;
 	ctx->set = NULL;
+
+	cmd->elem.set = set_get(set);
+
 	return 0;
 }
 
@@ -4141,7 +4144,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		return setelem_evaluate(ctx, &cmd->expr);
+		return setelem_evaluate(ctx, cmd);
 	case CMD_OBJ_SET:
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
@@ -4173,7 +4176,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		return setelem_evaluate(ctx, &cmd->expr);
+		return setelem_evaluate(ctx, cmd);
 	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
 	case CMD_OBJ_CHAIN:
@@ -4197,7 +4200,7 @@ static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		return setelem_evaluate(ctx, &cmd->expr);
+		return setelem_evaluate(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/netlink.c b/src/netlink.c
index b57e1c558501..2f1dbe179ed5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1228,7 +1228,7 @@ int netlink_list_setelems(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
-			const struct location *loc, struct table *table,
+			const struct location *loc, struct set *cache_set,
 			struct set *set, struct expr *init)
 {
 	struct nftnl_set *nls, *nls_out = NULL;
@@ -1261,7 +1261,7 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 	if (set->flags & NFT_SET_INTERVAL && set->desc.field_count > 1)
 		concat_range_aggregate(set->init);
 	else if (set->flags & NFT_SET_INTERVAL)
-		err = get_set_decompose(table, set);
+		err = get_set_decompose(cache_set, set);
 	else
 		list_expr_sort(&ctx->set->init->expressions);
 
diff --git a/src/rule.c b/src/rule.c
index 65973ccb296e..a56a0f52f820 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1577,6 +1577,7 @@ void cmd_free(struct cmd *cmd)
 		switch (cmd->obj) {
 		case CMD_OBJ_ELEMENTS:
 			expr_free(cmd->expr);
+			set_free(cmd->elem.set);
 			break;
 		case CMD_OBJ_SET:
 		case CMD_OBJ_SETELEMS:
@@ -1647,13 +1648,8 @@ static int __do_add_setelems(struct netlink_ctx *ctx, struct set *set,
 static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 			   uint32_t flags)
 {
-	struct handle *h = &cmd->handle;
 	struct expr *init = cmd->expr;
-	struct table *table;
-	struct set *set;
-
-	table = table_lookup(h, &ctx->nft->cache);
-	set = set_lookup(table, h->set.name);
+	struct set *set = cmd->elem.set;
 
 	if (set_is_non_concat_range(set) &&
 	    set_to_intervals(ctx->msgs, set, init, true,
@@ -1750,13 +1746,8 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct handle *h = &cmd->handle;
-	struct expr *expr = cmd->expr;
-	struct table *table;
-	struct set *set;
-
-	table = table_lookup(h, &ctx->nft->cache);
-	set = set_lookup(table, h->set.name);
+	struct expr *expr = cmd->elem.expr;
+	struct set *set = cmd->elem.set;
 
 	if (set_is_non_concat_range(set) &&
 	    set_to_intervals(ctx->msgs, set, expr, false,
@@ -2521,9 +2512,15 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 }
 
 static void __do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
-			  struct table *table, struct set *set)
+			  struct set *set)
 {
+	struct table *table = table_alloc();
+
+	table->handle.table.name = xstrdup(cmd->handle.table.name);
+	table->handle.family = cmd->handle.family;
 	table_print_declaration(table, &ctx->nft->output);
+	table_free(table);
+
 	set_print(set, &ctx->nft->output);
 	nft_print(&ctx->nft->output, "}\n");
 }
@@ -2537,7 +2534,7 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 	if (set == NULL)
 		return -1;
 
-	__do_list_set(ctx, cmd, table, set);
+	__do_list_set(ctx, cmd, set);
 
 	return 0;
 }
@@ -2608,14 +2605,13 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
-			   struct table *table)
+static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct set *set, *new_set;
 	struct expr *init;
 	int err;
 
-	set = set_lookup(table, cmd->handle.set.name);
+	set = cmd->elem.set;
 
 	/* Create a list of elements based of what we got from command line. */
 	if (set_is_non_concat_range(set))
@@ -2627,9 +2623,9 @@ static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	/* Fetch from kernel the elements that have been requested .*/
 	err = netlink_get_setelem(ctx, &cmd->handle, &cmd->location,
-				  table, new_set, init);
+				  cmd->elem.set, new_set, init);
 	if (err >= 0)
-		__do_list_set(ctx, cmd, table, new_set);
+		__do_list_set(ctx, cmd, new_set);
 
 	if (set_is_non_concat_range(set))
 		expr_free(init);
@@ -2641,14 +2637,9 @@ static int do_get_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 
 static int do_command_get(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table = NULL;
-
-	if (cmd->handle.table.name != NULL)
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-
 	switch (cmd->obj) {
 	case CMD_OBJ_ELEMENTS:
-		return do_get_setelems(ctx, cmd, table);
+		return do_get_setelems(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/segtree.c b/src/segtree.c
index 49169e733cff..a9b4b1bd6e2c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -687,17 +687,15 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 	return new_init;
 }
 
-static struct expr *get_set_interval_find(const struct table *table,
-					  const char *set_name,
+static struct expr *get_set_interval_find(const struct set *cache_set,
 					  struct expr *left,
 					  struct expr *right)
 {
+	const struct set *set = cache_set;
 	struct expr *range = NULL;
-	struct set *set;
 	struct expr *i;
 	mpz_t val;
 
-	set = set_lookup(table, set_name);
 	mpz_init2(val, set->key->len);
 
 	list_for_each_entry(i, &set->init->expressions, list) {
@@ -724,7 +722,7 @@ out:
 	return range;
 }
 
-int get_set_decompose(struct table *table, struct set *set)
+int get_set_decompose(struct set *cache_set, struct set *set)
 {
 	struct expr *i, *next, *range;
 	struct expr *left = NULL;
@@ -737,8 +735,7 @@ int get_set_decompose(struct table *table, struct set *set)
 			list_del(&left->list);
 			list_del(&i->list);
 			mpz_sub_ui(i->key->value, i->key->value, 1);
-			range = get_set_interval_find(table, set->handle.set.name,
-						    left, i);
+			range = get_set_interval_find(cache_set, left, i);
 			if (!range) {
 				expr_free(new_init);
 				errno = ENOENT;
@@ -751,8 +748,7 @@ int get_set_decompose(struct table *table, struct set *set)
 			left = NULL;
 		} else {
 			if (left) {
-				range = get_set_interval_find(table,
-							      set->handle.set.name,
+				range = get_set_interval_find(cache_set,
 							      left, NULL);
 				if (range)
 					compound_expr_add(new_init, range);
@@ -764,8 +760,7 @@ int get_set_decompose(struct table *table, struct set *set)
 		}
 	}
 	if (left) {
-		range = get_set_interval_find(table, set->handle.set.name,
-					      left, NULL);
+		range = get_set_interval_find(cache_set, left, NULL);
 		if (range)
 			compound_expr_add(new_init, range);
 		else
-- 
2.20.1

