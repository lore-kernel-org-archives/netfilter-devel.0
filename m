Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B48E19C542
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2025 12:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742818294; cv=none; b=AoShxJwA95O0rYD7IjQBQAXtnWrllVj3tjoclsqLVBkdI7MTQNEq/chnPo3JsVFD9Em1dBLBE8fqnDbnvt06h5CJh+C4CHWl9criXS6I/JX4zM7B34lhQwJu6yZ/qt62DqGiuJDcw6jzEgZJYBCKIkHdoWYVIHRaOwJkWiMiqo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742818294; c=relaxed/simple;
	bh=fo45TPa853DmUELUI+KB3VLhf1nYUumbJ0UrQjxsOjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gAIclk6eaXG7ekIG/xfhKsY7TwfP6WQzxyKdSu2ra3XjemnBJLIo3up+GFFHmUhI4Ynk8giih0ozMYZYEtTS0Df/1JV/z5YNW5fA8Ldwz3x6F7Ps19QQGWzm9fbDCbJ4NeY+JwPKcnS/TMqIFKnpcnGV6TFnGbGkNu4UmR6O3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1twgeQ-0002X3-6u; Mon, 24 Mar 2025 13:11:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: don't BUG when asked to list synproxies
Date: Mon, 24 Mar 2025 12:53:36 +0100
Message-ID: <20250324115339.11642-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"-j list synproxys" triggers a BUG().

Rewrite this so that all enum values are handled so the compiler can alert
us to a missing value in case there are more commands in the future.

While at it, implement a few low-hanging fruites as well.

Not-yet-supported cases are simply ignored.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c |  6 ++++--
 src/json.c     | 24 ++++++++++++++++++++++--
 src/rule.c     | 11 +++++++++--
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 785c4fab6b3a..1e7f6f53542b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6323,7 +6323,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_monitor(ctx, cmd);
 	case CMD_IMPORT:
 		return cmd_evaluate_import(ctx, cmd);
-	default:
-		BUG("invalid command operation %u\n", cmd->op);
+	case CMD_INVALID:
+		break;
 	};
+
+	BUG("invalid command operation %u\n", cmd->op);
 }
diff --git a/src/json.c b/src/json.c
index 96413d70895a..f92f86bbc974 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1971,7 +1971,7 @@ static json_t *generate_json_metainfo(void)
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
-	json_t *root;
+	json_t *root = NULL;
 
 	if (cmd->handle.table.name)
 		table = table_cache_find(&ctx->nft->cache.table_cache,
@@ -2026,6 +2026,13 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_HELPERS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CT_HELPER);
 		break;
+	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_TIMEOUTS:
+		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
+	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_CT_EXPECTATIONS:
+		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_CT_EXPECT);
+		break;
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_LIMITS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_LIMIT);
@@ -2034,14 +2041,27 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARKS:
 		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SECMARK);
 		break;
+	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_SYNPROXYS:
+		root = do_list_obj_json(ctx, cmd, NFT_OBJECT_SYNPROXY);
+		break;
 	case CMD_OBJ_FLOWTABLE:
 		root = do_list_flowtable_json(ctx, cmd, table);
 		break;
 	case CMD_OBJ_FLOWTABLES:
 		root = do_list_flowtables_json(ctx, cmd);
 		break;
-	default:
+	case CMD_OBJ_HOOKS:
+	case CMD_OBJ_MONITOR:
+	case CMD_OBJ_MARKUP:
+	case CMD_OBJ_SETELEMS:
+	case CMD_OBJ_RULE:
+	case CMD_OBJ_EXPR:
+	case CMD_OBJ_ELEMENTS:
+		return 0;
+	case CMD_OBJ_INVALID:
 		BUG("invalid command object type %u\n", cmd->obj);
+		break;
 	}
 
 	if (!json_is_array(root)) {
diff --git a/src/rule.c b/src/rule.c
index 00fbbc4c080a..cf895a5acf5b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2445,10 +2445,17 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_flowtables(ctx, cmd);
 	case CMD_OBJ_HOOKS:
 		return do_list_hooks(ctx, cmd);
-	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+	case CMD_OBJ_MONITOR:
+	case CMD_OBJ_MARKUP:
+	case CMD_OBJ_SETELEMS:
+	case CMD_OBJ_EXPR:
+	case CMD_OBJ_ELEMENTS:
+		return 0;
+	case CMD_OBJ_INVALID:
+		break;
 	}
 
+	BUG("invalid command object type %u\n", cmd->obj);
 	return 0;
 }
 
-- 
2.48.1

