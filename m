Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552AAC28CC6
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1FB20866
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfFEQrF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 12:47:05 -0400
Received: from mail.us.es ([193.147.175.20]:58416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728721AbfFEQrF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 12:47:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8793DFB44B
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:47:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 778B2DA70F
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:47:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6D0E1DA708; Wed,  5 Jun 2019 18:47:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 085BCDA709;
        Wed,  5 Jun 2019 18:46:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Jun 2019 18:46:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D0CCE4265A31;
        Wed,  5 Jun 2019 18:46:58 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 4/4] src: single cache_update() call to build cache before evaluation
Date:   Wed,  5 Jun 2019 18:46:52 +0200
Message-Id: <20190605164652.20199-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605164652.20199-1-pablo@netfilter.org>
References: <20190605164652.20199-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows us to make one single cache_update() call. Thus, there
is not need to rebuild an incomplete cache from the middle of the batch
processing.

Note that nft_run_cmd_from_filename() does not need a full netlink dump
to build the cache anymore, this should speed nft -f with incremental
updates and very large rulesets.

cache_evaluate() calculates the netlink dump to populate the cache that
this batch needs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h    |   1 +
 src/Makefile.am   |   1 +
 src/cache.c       | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/evaluate.c    |  76 +--------------------------------
 src/libnftables.c |   9 ++--
 src/mnl.c         |   8 +---
 src/rule.c        |  18 +-------
 7 files changed, 134 insertions(+), 102 deletions(-)
 create mode 100644 src/cache.c

diff --git a/include/rule.h b/include/rule.h
index 8e70c129fcce..bf3f39636efb 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -631,6 +631,7 @@ extern struct error_record *rule_postprocess(struct rule *rule);
 struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
+extern int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
 extern int cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
 			struct list_head *msgs);
 extern void cache_flush(struct nft_ctx *ctx, enum cmd_ops cmd,
diff --git a/src/Makefile.am b/src/Makefile.am
index 8e1a4d8795dc..fd641755b7a4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -31,6 +31,7 @@ lib_LTLIBRARIES = libnftables.la
 libnftables_la_SOURCES =			\
 		rule.c				\
 		statement.c			\
+		cache.c				\
 		datatype.c			\
 		expression.c			\
 		evaluate.c			\
diff --git a/src/cache.c b/src/cache.c
new file mode 100644
index 000000000000..89a884012a90
--- /dev/null
+++ b/src/cache.c
@@ -0,0 +1,123 @@
+/*
+ * Copyright (c) 2019 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <expression.h>
+#include <statement.h>
+#include <rule.h>
+#include <erec.h>
+#include <utils.h>
+
+static void evaluate_cache_add(struct cmd *cmd, unsigned int *completeness)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_SET:
+	case CMD_OBJ_CHAIN:
+	case CMD_OBJ_FLOWTABLE:
+		if (*completeness < cmd->op)
+			*completeness = cmd->op;
+		break;
+	case CMD_OBJ_RULE:
+		/* XXX index is set to zero unless this handle_merge() call is
+		 * invoked, this handle_merge() call is done from the
+		 * evaluation, which is too late.
+		 */
+		handle_merge(&cmd->rule->handle, &cmd->handle);
+
+		if (cmd->rule->handle.index.id &&
+		    *completeness < CMD_LIST)
+			*completeness = CMD_LIST;
+		break;
+	default:
+		break;
+	}
+}
+
+static void evaluate_cache_del(struct cmd *cmd, unsigned int *completeness)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_SETELEM:
+		if (*completeness < cmd->op)
+			*completeness = cmd->op;
+		break;
+	default:
+		break;
+	}
+}
+
+static void evaluate_cache_flush(struct cmd *cmd, unsigned int *completeness)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+	case CMD_OBJ_METER:
+		if (*completeness < cmd->op)
+			*completeness = cmd->op;
+		break;
+	default:
+		break;
+	}
+}
+
+static void evaluate_cache_rename(struct cmd *cmd, unsigned int *completeness)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_CHAIN:
+		if (*completeness < cmd->op)
+			*completeness = cmd->op;
+		break;
+	default:
+		break;
+	}
+}
+
+int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
+{
+	unsigned int completeness = CMD_INVALID;
+	struct cmd *cmd;
+
+	list_for_each_entry(cmd, cmds, list) {
+		switch (cmd->op) {
+		case CMD_ADD:
+		case CMD_INSERT:
+		case CMD_REPLACE:
+			if (nft_output_echo(&nft->output) &&
+			    completeness < cmd->op)
+				return cmd->op;
+
+			/* Fall through */
+		case CMD_CREATE:
+			evaluate_cache_add(cmd, &completeness);
+			break;
+		case CMD_DELETE:
+			evaluate_cache_del(cmd, &completeness);
+			break;
+		case CMD_GET:
+		case CMD_LIST:
+		case CMD_RESET:
+		case CMD_EXPORT:
+		case CMD_MONITOR:
+			if (completeness < cmd->op)
+				completeness = cmd->op;
+			break;
+		case CMD_FLUSH:
+			evaluate_cache_flush(cmd, &completeness);
+			break;
+		case CMD_RENAME:
+			evaluate_cache_rename(cmd, &completeness);
+			break;
+		case CMD_DESCRIBE:
+		case CMD_IMPORT:
+			break;
+		default:
+			break;
+		}
+	}
+
+	return completeness;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 55fb3b6131e0..63be2dde8fa2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -226,7 +226,6 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 	struct table *table;
 	struct set *set;
 	struct expr *new;
-	int ret;
 
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
@@ -238,10 +237,6 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		}
 		break;
 	case SYMBOL_SET:
-		ret = cache_update(ctx->nft, ctx->cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		table = table_lookup_global(ctx);
 		if (table == NULL)
 			return table_not_found(ctx);
@@ -3191,12 +3186,6 @@ static int rule_translate_index(struct eval_ctx *ctx, struct rule *rule)
 	struct chain *chain;
 	uint64_t index = 0;
 	struct rule *r;
-	int ret;
-
-	/* update cache with CMD_LIST so that rules are fetched, too */
-	ret = cache_update(ctx->nft, CMD_LIST, ctx->msgs);
-	if (ret < 0)
-		return ret;
 
 	table = table_lookup(&rule->handle, &ctx->nft->cache);
 	if (!table)
@@ -3412,38 +3401,20 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 
 static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	int ret;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
 		return table_evaluate(ctx, cmd->table);
 	case CMD_OBJ_FLOWTABLE:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		handle_merge(&cmd->flowtable->handle, &cmd->handle);
 		return flowtable_evaluate(ctx, cmd->flowtable);
 	case CMD_OBJ_COUNTER:
@@ -3460,14 +3431,8 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	int ret;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
@@ -3490,11 +3455,6 @@ static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct set *set;
-	int ret;
-
-	ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-	if (ret < 0)
-		return ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
@@ -3553,11 +3513,6 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct set *set;
-	int ret;
-
-	ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-	if (ret < 0)
-		return ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -3648,12 +3603,6 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	int ret;
-
-	ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-	if (ret < 0)
-		return ret;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
@@ -3674,7 +3623,6 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct set *set;
-	int ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
@@ -3688,10 +3636,6 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		/* Chains don't hold sets */
 		break;
 	case CMD_OBJ_SET:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
@@ -3703,10 +3647,6 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_MAP:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
@@ -3718,10 +3658,6 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_METER:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
@@ -3741,14 +3677,9 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
-	int ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		table = table_lookup(&ctx->cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
@@ -3840,11 +3771,6 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	uint32_t event;
-	int ret;
-
-	ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
-	if (ret < 0)
-		return ret;
 
 	if (cmd->monitor->event == NULL)
 		event = CMD_MONITOR_EVENT_ANY;
@@ -3870,7 +3796,7 @@ static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_error(ctx, &cmd->location,
 				 "JSON export is no longer supported, use 'nft -j list ruleset' instead");
 
-	return cache_update(ctx->nft, cmd->op, ctx->msgs);
+	return 0;
 }
 
 static int cmd_evaluate_import(struct eval_ctx *ctx, struct cmd *cmd)
diff --git a/src/libnftables.c b/src/libnftables.c
index f459ecd50e45..4bb770c07819 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -381,8 +381,13 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			struct list_head *cmds)
 {
+	unsigned int completeness;
 	struct cmd *cmd;
 
+	completeness = cache_evaluate(nft, cmds);
+	if (cache_update(nft, completeness, msgs) < 0)
+		return -1;
+
 	list_for_each_entry(cmd, cmds, list) {
 		struct eval_ctx ectx = {
 			.nft	= nft,
@@ -454,10 +459,6 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 
-	rc = cache_update(nft, CMD_INVALID, &msgs);
-	if (rc < 0)
-		return -1;
-
 	if (!strcmp(filename, "-"))
 		filename = "/dev/stdin";
 
diff --git a/src/mnl.c b/src/mnl.c
index 579210e4736a..c0df2c941d88 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -394,15 +394,9 @@ int mnl_nft_rule_replace(struct netlink_ctx *ctx, const struct cmd *cmd)
 	unsigned int flags = 0;
 	struct nftnl_rule *nlr;
 	struct nlmsghdr *nlh;
-	int err;
-
-	if (nft_output_echo(&ctx->nft->output)) {
-		err = cache_update(ctx->nft, CMD_INVALID, ctx->msgs);
-		if (err < 0)
-			return err;
 
+	if (nft_output_echo(&ctx->nft->output))
 		flags |= NLM_F_ECHO;
-	}
 
 	nlr = nftnl_rule_alloc();
 	if (!nlr)
diff --git a/src/rule.c b/src/rule.c
index 326edb5dd459..c87375d51ccc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1501,15 +1501,8 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
 	uint32_t flags = excl ? NLM_F_EXCL : 0;
 
-	if (nft_output_echo(&ctx->nft->output)) {
-		int ret;
-
-		ret = cache_update(ctx->nft, cmd->obj, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
+	if (nft_output_echo(&ctx->nft->output))
 		flags |= NLM_F_ECHO;
-	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -1552,15 +1545,8 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	uint32_t flags = 0;
 
-	if (nft_output_echo(&ctx->nft->output)) {
-		int ret;
-
-		ret = cache_update(ctx->nft, cmd->obj, ctx->msgs);
-		if (ret < 0)
-			return ret;
-
+	if (nft_output_echo(&ctx->nft->output))
 		flags |= NLM_F_ECHO;
-	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
-- 
2.11.0

