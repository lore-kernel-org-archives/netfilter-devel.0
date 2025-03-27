Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA9079D2
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743093136; cv=none; b=daN79awpqQObJdGOAJfv4NMFYGnNdUAPoSZK1eBv8ZICZuf3WuRThWnSUCwkeIb91iIMC5EWKFo1dUXHO7ztv52qXq+nay4mcckmzSK4pmrqHlE4R7IauA9GzC1BTWvOxmGMhRpJNZmrTrXYs8soELf1lSUx9GcKiV7m8rz4c9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743093136; c=relaxed/simple;
	bh=hVAPlis10kZCuEaBfLZZ71iR7VIQqGLweR3hDHo68qM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oTWkP+1N/+kwJbbdM40bGJ11frTapeb7nCs2hgTlEGPNQW7tam2A3cmmkngs819J2Y2wf8bhNEPKkiZ40wp77LalvSzDBcJkrfEMVr/lCMs/OWv0SornrrdvHfAupFXAjYNbRJ+K5c4FqAp0u+gbfSWb+dLl3HK8Gqm5R9F5fRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1txq9L-00088N-V5; Thu, 27 Mar 2025 17:32:11 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] json: don't BUG when asked to list synproxies
Date: Thu, 27 Mar 2025 17:32:00 +0100
Message-ID: <20250327163203.26366-1-fw@strlen.de>
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

v2: return EOPNOTSUPP for unsupported commands (Pablo Neira Ayuso)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c |  6 ++++--
 src/json.c     | 26 ++++++++++++++++++++++++--
 src/rule.c     | 12 ++++++++++--
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index bd99e33971f7..a6b08cf3b1b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -6329,7 +6329,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
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
index 831bc90f0833..adebe47980b9 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1971,7 +1971,7 @@ static json_t *generate_json_metainfo(void)
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
-	json_t *root;
+	json_t *root = NULL;
 
 	if (cmd->handle.table.name) {
 		table = table_cache_find(&ctx->nft->cache.table_cache,
@@ -2031,6 +2031,13 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -2039,14 +2046,29 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
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
+		return 0;
+	case CMD_OBJ_MONITOR:
+	case CMD_OBJ_MARKUP:
+	case CMD_OBJ_SETELEMS:
+	case CMD_OBJ_RULE:
+	case CMD_OBJ_EXPR:
+	case CMD_OBJ_ELEMENTS:
+		errno = EOPNOTSUPP;
+		return -1;
+	case CMD_OBJ_INVALID:
 		BUG("invalid command object type %u\n", cmd->obj);
+		break;
 	}
 
 	if (!json_is_array(root)) {
diff --git a/src/rule.c b/src/rule.c
index 00fbbc4c080a..80315837baf0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2445,10 +2445,18 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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
+		errno = EOPNOTSUPP;
+		return -1;
+	case CMD_OBJ_INVALID:
+		break;
 	}
 
+	BUG("invalid command object type %u\n", cmd->obj);
 	return 0;
 }
 
-- 
2.48.1

