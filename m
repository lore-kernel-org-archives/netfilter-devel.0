From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2] echo: Fix for added delays in rule updates
Date: Tue, 15 Aug 2017 13:59:12 +0200
Message-ID: <20170815115912.4254-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53897 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbdHOL7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 07:59:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The added cache update upon every command dealing with rules was a
bummer. Instead, perform the needed cache update only if echo option was
set.

Initially, I tried to perform the cache update from within
netlink_echo_callback(), but that turned into a mess since the shared
socket between cache_init() and mnl_batch_talk() would receive
unexpected new input. So instead update the cache from do_command_add(),
netlink_replace_rule_batch() and do_comand_insert() so it completes
before mnl_batch_talk() starts listening.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Don't change function signatures: It is not really required and should
  be done in a dedicated patch instead.
- Use 'ret' as return code variable name.
---
 src/evaluate.c |  9 ---------
 src/netlink.c  | 11 ++++++++++-
 src/rule.c     | 23 +++++++++++++++++++++--
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 64e14b8ba8d98..0fad0913488d0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2965,10 +2965,6 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		handle_merge(&cmd->set->handle, &cmd->handle);
 		return set_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
-		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
-		if (ret < 0)
-			return ret;
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
@@ -2983,11 +2979,6 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
-		ret = cache_update(ctx->nf_sock, ctx->cache, cmd->op,
-				   ctx->msgs);
-		if (ret < 0)
-			return ret;
-
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/netlink.c b/src/netlink.c
index f631c26b2b9ca..68f336255fc50 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -464,7 +464,16 @@ int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
 			       const struct location *loc)
 {
 	struct nftnl_rule *nlr;
-	int err, flags = ctx->octx->echo ? NLM_F_ECHO : 0;
+	int err, flags = 0;
+
+	if (ctx->octx->echo) {
+		err = cache_update(ctx->nf_sock, ctx->cache,
+				   CMD_INVALID, ctx->msgs);
+		if (err < 0)
+			return err;
+
+		flags |= NLM_F_ECHO;
+	}
 
 	nlr = alloc_nftnl_rule(&rule->handle);
 	netlink_linearize_rule(ctx, nlr, rule);
diff --git a/src/rule.c b/src/rule.c
index 1bd5c80158b7b..38cd648eb24a8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1017,8 +1017,16 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
 	uint32_t flags = excl ? NLM_F_EXCL : 0;
 
-	if (ctx->octx->echo)
+	if (ctx->octx->echo) {
+		int ret;
+
+		ret = cache_update(ctx->nf_sock, ctx->cache,
+				  cmd->obj, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
 		flags |= NLM_F_ECHO;
+	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -1058,7 +1066,18 @@ static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	uint32_t flags = ctx->octx->echo ? NLM_F_ECHO : 0;
+	uint32_t flags = 0;
+
+	if (ctx->octx->echo) {
+		int ret;
+
+		ret = cache_update(ctx->nf_sock, ctx->cache,
+				  cmd->obj, ctx->msgs);
+		if (ret < 0)
+			return ret;
+
+		flags |= NLM_F_ECHO;
+	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
-- 
2.13.1

