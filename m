From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] src: revisit cache population logic
Date: Mon, 14 Mar 2016 20:38:27 +0100
Message-ID: <1457984308-23864-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32769 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbcCNTil (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 15:38:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9E037114819
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DB6BDA386
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AED8BDA384
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:38:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We get a partial cache (tables, chains and sets) when:

* We see a set reference from a rule, since this set object may be
  already defined in kernelspace and we need to fetch the datatype
  for evaluation.

* We add/delete a set element, we need this to evaluate if the
  element datatype is correct.

* We rename a chain, since we need to know the chain handle.

* We add a chain/set. This isn't needed for simple command line
  invocations. However, since the existing codepath is also exercised
  from `nft -f' context, we need to know if the object exists in the
  kernel. Thus, if this a newly declared object (not yet in the kernel) we
  add it to the cache, otherwise, we will not find follow up references to
  this object in our cache.

We get a full cache when:

* We list the ruleset. We can provide finer grain listing though,
  via partial cache, later.

* We monitor updates, since this displays incremental updates based on
  the existing objects.

* We export the ruleset, since this dumps all of the existing objects.

* We push updates via `nft -f'. We need to know what objects are
  already in the kernel for incremental updates. Otherwise,
  cache_update() hits a bogus 'set doesn't exist' error message for
  just declared set in this batch.  To avoid this problem, we need a
  way to differentiate between what objects in the lists that are
  already defined in the kernel and what are just declared in this
  batch (hint: the location structure information is set for just
  declared objects).

We don't get a cache at all when:

* We flush the ruleset, this is important in case of delinearize
  bugs, so you don't need to reboot or manually flush the ruleset via
  libnftnl examples/nft-table-flush.

* We delete any object, except for set elements (as we describe above).

* We add a rule, so you can generate via --debug=netlink the expression
  without requiring a table and chain in place.

* We describe a expression.

This patch also includes some intentional adjustments to the shell tests
to we don't get bogus errors due to changes in the list printing.

BTW, this patch also includes a revert for 97493717e738 ("evaluate: check
if table and chain exists when adding rules") since that check is not
possible anymore with this logic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                           | 61 +++++++++++++++++++++++---------
 src/main.c                               |  4 +++
 tests/shell/testcases/listing/0010sets_0 | 24 ++++++-------
 tests/shell/testcases/listing/0011sets_0 |  4 +--
 4 files changed, 63 insertions(+), 30 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b17cc82..45d585d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -165,6 +165,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 	struct table *table;
 	struct set *set;
 	struct expr *new;
+	int ret;
 
 	switch ((*expr)->symtype) {
 	case SYMBOL_VALUE:
@@ -184,6 +185,10 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		new = expr_clone(sym->expr);
 		break;
 	case SYMBOL_SET:
+		ret = cache_update(ctx->cmd->op, ctx->msgs);
+		if (ret < 0)
+			return cmd_error(ctx, "Could not process rule: Cannot list sets");
+
 		table = table_lookup(&ctx->cmd->handle);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
@@ -2297,27 +2302,30 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 
 static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table;
+	int ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
+		ret = cache_update(cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
+		ret = cache_update(cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
-		table = table_lookup_global(ctx);
-		if (table == NULL)
-			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
-					 ctx->cmd->handle.table);
-
-		if (chain_lookup(table, &ctx->cmd->handle) == NULL)
-			return cmd_error(ctx, "Could not process rule: Chain '%s' does not exist",
-					 ctx->cmd->handle.chain);
-
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
+		ret = cache_update(cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
 		return table_evaluate(ctx, cmd->table);
@@ -2328,8 +2336,14 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	int ret;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
+		ret = cache_update(cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
@@ -2344,6 +2358,11 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
+	int ret;
+
+	ret = cache_update(cmd->op, ctx->msgs);
+	if (ret < 0)
+		return ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -2385,9 +2404,14 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
+	int ret;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
+		ret = cache_update(cmd->op, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		table = table_lookup(&ctx->cmd->handle);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
@@ -2452,6 +2476,11 @@ static uint32_t monitor_flags[CMD_MONITOR_EVENT_MAX][CMD_MONITOR_OBJ_MAX] = {
 static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	uint32_t event;
+	int ret;
+
+	ret = cache_update(cmd->op, ctx->msgs);
+	if (ret < 0)
+		return ret;
 
 	if (cmd->monitor->event == NULL)
 		event = CMD_MONITOR_EVENT_ANY;
@@ -2468,14 +2497,13 @@ static int cmd_evaluate_monitor(struct eval_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
+static int cmd_evaluate_export(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	int ret;
-
-	ret = cache_update(cmd->op, ctx->msgs);
-	if (ret < 0)
-		return ret;
+	return cache_update(cmd->op, ctx->msgs);
+}
 
+int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
+{
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
 		struct error_record *erec;
@@ -2500,6 +2528,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_RENAME:
 		return cmd_evaluate_rename(ctx, cmd);
 	case CMD_EXPORT:
+		return cmd_evaluate_export(ctx, cmd);
 	case CMD_DESCRIBE:
 		return 0;
 	case CMD_MONITOR:
diff --git a/src/main.c b/src/main.c
index d643970..ad73d80 100644
--- a/src/main.c
+++ b/src/main.c
@@ -338,6 +338,10 @@ int main(int argc, char * const *argv)
 		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
+		rc = cache_update(CMD_INVALID, &msgs);
+		if (rc < 0)
+			return rc;
+
 		parser_init(&state, &msgs);
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
diff --git a/tests/shell/testcases/listing/0010sets_0 b/tests/shell/testcases/listing/0010sets_0
index 42d60b4..855cceb 100755
--- a/tests/shell/testcases/listing/0010sets_0
+++ b/tests/shell/testcases/listing/0010sets_0
@@ -12,18 +12,6 @@ table ip6 test {
 		type ipv6_addr
 	}
 }
-table inet filter {
-	set set0 {
-		type inet_service
-	}
-	set set1 {
-		type inet_service
-		flags constant
-	}
-	set set2 {
-		type icmpv6_type
-	}
-}
 table arp test_arp {
 	set test_set_arp00 {
 		type inet_service
@@ -37,6 +25,18 @@ table bridge test_bridge {
 	set test_set_bridge {
 		type inet_service
 	}
+}
+table inet filter {
+	set set0 {
+		type inet_service
+	}
+	set set1 {
+		type inet_service
+		flags constant
+	}
+	set set2 {
+		type icmpv6_type
+	}
 }"
 
 set -e
diff --git a/tests/shell/testcases/listing/0011sets_0 b/tests/shell/testcases/listing/0011sets_0
index 1bf6887..75f2895 100755
--- a/tests/shell/testcases/listing/0011sets_0
+++ b/tests/shell/testcases/listing/0011sets_0
@@ -6,11 +6,11 @@ EXPECTED="table ip nat {
 }
 table ip6 test {
 }
-table inet filter {
-}
 table arp test_arp {
 }
 table bridge test_bridge {
+}
+table inet filter {
 }"
 
 set -e
-- 
2.1.4

