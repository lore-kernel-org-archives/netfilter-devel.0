From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/4] echo: Fix for added delays in rule updates
Date: Tue, 15 Aug 2017 01:43:04 +0200
Message-ID: <20170814234305.2829-4-phil@nwl.cc>
References: <20170814234305.2829-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57355 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbdHNXnS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 19:43:18 -0400
In-Reply-To: <20170814234305.2829-1-phil@nwl.cc>
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
 include/netlink.h |  5 +----
 src/evaluate.c    |  9 ---------
 src/netlink.c     | 22 +++++++++++++++-------
 src/rule.c        | 26 ++++++++++++++++++++++----
 4 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 3726171424c33..e7e4bbcfc0f51 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -119,10 +119,7 @@ extern int netlink_add_rule_batch(struct netlink_ctx *ctx,
 extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
 				  const struct handle *h,
 				  const struct location *loc);
-extern int netlink_replace_rule_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct rule *rule,
-				      const struct location *loc);
+extern int netlink_replace_rule_batch(struct netlink_ctx *ctx, struct cmd *cmd);
 
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
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
index f631c26b2b9ca..e7fe62b21da6a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -459,20 +459,28 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx,
 	return err;
 }
 
-int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct handle *h,
-			       const struct rule *rule,
-			       const struct location *loc)
+int netlink_replace_rule_batch(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_rule *nlr;
-	int err, flags = ctx->octx->echo ? NLM_F_ECHO : 0;
+	int err, flags = 0;
 
-	nlr = alloc_nftnl_rule(&rule->handle);
-	netlink_linearize_rule(ctx, nlr, rule);
+	if (ctx->octx->echo) {
+		err = cache_update(ctx->nf_sock, ctx->cache,
+				   cmd->obj, ctx->msgs);
+		if (err < 0)
+			return err;
+
+		flags |= NLM_F_ECHO;
+	}
+
+	nlr = alloc_nftnl_rule(&cmd->rule->handle);
+	netlink_linearize_rule(ctx, nlr, cmd->rule);
 	err = mnl_nft_rule_batch_replace(nlr, ctx->batch, flags, ctx->seqnum);
 	nftnl_rule_free(nlr);
 
 	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not replace rule to batch: %s",
+		netlink_io_error(ctx, &cmd->location,
+				 "Could not replace rule to batch: %s",
 				 strerror(errno));
 	return err;
 }
diff --git a/src/rule.c b/src/rule.c
index 1bd5c80158b7b..ab19525757fff 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1017,8 +1017,16 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
 	uint32_t flags = excl ? NLM_F_EXCL : 0;
 
-	if (ctx->octx->echo)
+	if (ctx->octx->echo) {
+		int rc;
+
+		rc = cache_update(ctx->nf_sock, ctx->cache,
+				  cmd->obj, ctx->msgs);
+		if (rc < 0)
+			return rc;
+
 		flags |= NLM_F_ECHO;
+	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -1048,8 +1056,7 @@ static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
-		return netlink_replace_rule_batch(ctx, &cmd->handle, cmd->rule,
-						  &cmd->location);
+		return netlink_replace_rule_batch(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
@@ -1058,7 +1065,18 @@ static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	uint32_t flags = ctx->octx->echo ? NLM_F_ECHO : 0;
+	uint32_t flags = 0;
+
+	if (ctx->octx->echo) {
+		int rc;
+
+		rc = cache_update(ctx->nf_sock, ctx->cache,
+				  cmd->obj, ctx->msgs);
+		if (rc < 0)
+			return rc;
+
+		flags |= NLM_F_ECHO;
+	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULE:
-- 
2.13.1

