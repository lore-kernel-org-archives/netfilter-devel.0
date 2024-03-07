Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1CD12B14B
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709814780; cv=none; b=qzY5bYDHN0UMZzVjQVkHY/ZTsJFQB+uw5HHKtEvhpO6ypUXsuNIbaA8Jw43VUDOtdkjAT+xRRvDNtMX6U0qpLQUn+x4fDha4fwhAk/sOyn8DnzjJSB86IG5yOQi3R1ucChPMxA9t6Tq6LUeBY7dGhywvdJ0YDzhgW9SnrselHI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709814780; c=relaxed/simple;
	bh=+5i4FH4Lr/oNYfM4nktXiSlLm083nxsSDMpDDpXLMQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK2ODF3lwyYBkSVOQ3P349TNeSu8RvzNiVppw+m4yZuIEYsbkIOlrpO9rg6u8khKbjRUNqvCZjWtfiN+OhPj9LBikjJeZYifE8+cWcfJelxD4blO1aRFOPQ0koT2wjC5Cy7VCP5OvzQDF6Ok6S3uObTHsKtjSEjVJSaQLgUZLvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1riCvg-00073k-3a; Thu, 07 Mar 2024 13:32:56 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: phil@nwl.cc,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/5] parser_json: defer command allocation to nft_cmd_expand
Date: Thu,  7 Mar 2024 13:26:34 +0100
Message-ID: <20240307122640.29507-5-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307122640.29507-1-fw@strlen.de>
References: <20240307122640.29507-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Place new chains, flowtables, and sets and objects in struct table
and let nft_cmd_expand() allocate the commands instead.

Likewise new rules get appended to chain->rules.

This makes sure chains are created before set elements that reference
them, and rules get created after sets that are referenced by rules.

Instead of allocating a new command, search for the table/chain in the
existing transaction queue and append the object there.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 129 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 6 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 91c1e01cee52..a557e3ee81a3 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -55,6 +55,7 @@ struct json_ctx {
 	struct list_head *msgs;
 	struct list_head *cmds;
 	uint32_t flags;
+	bool in_ruleset;
 };
 
 #define is_RHS(ctx)	(ctx->flags & CTX_F_RHS)
@@ -2977,6 +2978,55 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 	return NULL;
 }
 
+static bool table_eq(const struct handle *th, const struct handle *handle)
+{
+	return th->family == handle->family &&
+		strcmp(th->table.name, handle->table.name) == 0;
+}
+
+static struct table *json_cmd_get_table(struct json_ctx *ctx,
+					const struct handle *handle)
+{
+	struct cmd *cmd;
+
+	if (!ctx->in_ruleset)
+		return NULL;
+
+	list_for_each_entry(cmd, ctx->cmds, list) {
+		if (cmd->op != CMD_ADD)
+			continue;
+		if (cmd->obj != CMD_OBJ_TABLE)
+			continue;
+		if (table_eq(&cmd->handle, handle)) {
+			if (cmd->table)
+				return cmd->table;
+
+			cmd->table = table_alloc();
+			handle_merge(&cmd->table->handle, &cmd->handle);
+			return cmd->table;
+		}
+	}
+
+	return NULL;
+}
+
+static struct chain *json_cmd_get_chain(struct json_ctx *ctx,
+					const struct handle *handle)
+{
+	struct table *table =json_cmd_get_table(ctx, handle);
+	struct chain *chain;
+
+	if (!table)
+		return NULL;
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (strcmp(chain->handle.chain.name, handle->chain.name) == 0)
+			return chain;
+	}
+
+	return NULL;
+}
+
 static struct cmd *json_parse_cmd_add_table(struct json_ctx *ctx, json_t *root,
 					    enum cmd_ops op, enum cmd_obj obj)
 {
@@ -3114,8 +3164,23 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 	    op == CMD_LIST ||
 	    op == CMD_FLUSH ||
 	    json_unpack(root, "{s:s, s:s, s:i}",
-			"type", &type, "hook", &hookstr, "prio", &prio))
+			"type", &type, "hook", &hookstr, "prio", &prio)) {
+		struct table *table = json_cmd_get_table(ctx, &h);
+
+		if (table) {
+			assert(op == CMD_ADD);
+
+			if (!chain)
+				chain = chain_alloc();
+
+			handle_merge(&chain->handle, &h);
+			list_add_tail(&chain->list, &table->chains);
+			handle_free(&h);
+			return NULL;
+		}
+
 		return cmd_alloc(op, obj, &h, int_loc, chain);
+	}
 
 	if (!chain)
 		chain = chain_alloc();
@@ -3153,10 +3218,20 @@ static struct cmd *json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
 		}
 	}
 
-	if (op == CMD_ADD)
+	handle_merge(&chain->handle, &h);
+
+	if (op == CMD_ADD) {
+		struct table *table = json_cmd_get_table(ctx, &h);
+
 		json_object_del(root, "handle");
 
-	handle_merge(&chain->handle, &h);
+		if (table) {
+			list_add_tail(&chain->list, &table->chains);
+			handle_free(&h);
+			return NULL;
+		}
+	}
+
 	return cmd_alloc(op, obj, &h, int_loc, chain);
 }
 
@@ -3231,9 +3306,17 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		rule_stmt_append(rule, stmt);
 	}
 
-	if (op == CMD_ADD)
+	if (op == CMD_ADD) {
+		struct chain *chain = json_cmd_get_chain(ctx, &h);
+
 		json_object_del(root, "handle");
 
+		if (chain) {
+			list_add_tail(&rule->list, &chain->rules);
+			handle_free(&h);
+			return NULL;
+		}
+	}
 	return cmd_alloc(op, obj, &h, int_loc, rule);
 }
 
@@ -3399,9 +3482,18 @@ static struct cmd *json_parse_cmd_add_set(struct json_ctx *ctx, json_t *root,
 
 	handle_merge(&set->handle, &h);
 
-	if (op == CMD_ADD)
+	if (op == CMD_ADD) {
+		struct table *table = json_cmd_get_table(ctx, &h);
+
 		json_object_del(root, "handle");
 
+		if (table) {
+			list_add_tail(&set->list, &table->sets);
+			handle_free(&h);
+			return NULL;
+		}
+	}
+
 	return cmd_alloc(op, obj, &h, int_loc, set);
 }
 
@@ -3505,6 +3597,18 @@ static struct cmd *json_parse_cmd_add_flowtable(struct json_ctx *ctx,
 			return CMD_ERR_PTR(-1);
 		}
 	}
+
+	if (op == CMD_ADD) {
+		struct table *table = json_cmd_get_table(ctx, &h);
+
+		if (table) {
+			handle_merge(&flowtable->handle, &h);
+			list_add_tail(&flowtable->list, &table->flowtables);
+			handle_free(&h);
+			return NULL;
+		}
+	}
+
 	return cmd_alloc(op, cmd_obj, &h, int_loc, flowtable);
 }
 
@@ -3754,9 +3858,19 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		BUG("Invalid CMD '%d'", cmd_obj);
 	}
 
-	if (op == CMD_ADD)
+	if (op == CMD_ADD) {
+		struct table *table = json_cmd_get_table(ctx, &h);
+
 		json_object_del(root, "handle");
 
+		if (table) {
+			handle_merge(&obj->handle, &h);
+			list_add_tail(&obj->list, &table->objs);
+			handle_free(&h);
+			return NULL;
+		}
+	}
+
 	return cmd_alloc(op, cmd_obj, &h, int_loc, obj);
 }
 
@@ -4160,10 +4274,13 @@ static int json_parse_cmd(struct json_ctx *ctx, json_t *root)
 		return -1;
 	}
 
+	assert(!ctx->in_ruleset);
+	ctx->in_ruleset = true;
 	/* to accept 'list ruleset' output 1:1, try add command */
 	cmd = json_parse_cmd_add(ctx, root, CMD_ADD);
 	if (CMD_IS_ERR(cmd))
 		return -1;
+	ctx->in_ruleset = false;
 
 out:
 	if (cmd) {
-- 
2.43.0

