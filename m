Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BCCC6FA99
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 18:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCJSov (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 13:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjCJSo0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 13:44:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DE56123CF8
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 10:44:19 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cmd: move command functions to src/cmd.c
Date:   Fri, 10 Mar 2023 19:44:16 +0100
Message-Id: <20230310184416.240417-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move several command functions to src/cmd.c to debloat src/rule.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cmd.h  |   6 ++
 include/rule.h |   6 --
 src/cmd.c      | 206 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/rule.c     | 206 -------------------------------------------------
 4 files changed, 212 insertions(+), 212 deletions(-)

diff --git a/include/cmd.h b/include/cmd.h
index 27fa60873427..92a4152bbaea 100644
--- a/include/cmd.h
+++ b/include/cmd.h
@@ -1,7 +1,13 @@
 #ifndef _NFT_CMD_H_
 #define _NFT_CMD_H_
 
+void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc);
 void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 		   struct mnl_err *err);
 
+void nft_cmd_expand(struct cmd *cmd);
+void nft_cmd_post_expand(struct cmd *cmd);
+bool nft_cmd_collapse(struct list_head *cmds);
+void nft_cmd_uncollapse(struct list_head *cmds);
+
 #endif
diff --git a/include/rule.h b/include/rule.h
index f3db6aabf1ff..e1efbb819163 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -735,17 +735,11 @@ struct cmd {
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
-extern void nft_cmd_expand(struct cmd *cmd);
-extern void nft_cmd_post_expand(struct cmd *cmd);
-extern bool nft_cmd_collapse(struct list_head *cmds);
-extern void nft_cmd_uncollapse(struct list_head *cmds);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
 				    const struct location *loc, struct obj *obj);
 extern void cmd_free(struct cmd *cmd);
 
-void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc);
-
 #include <payload.h>
 #include <expression.h>
 
diff --git a/src/cmd.c b/src/cmd.c
index 86c5f432c73a..98216d54e78d 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -17,6 +17,18 @@
 #include <cache.h>
 #include <string.h>
 
+void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
+{
+	if (cmd->num_attrs >= cmd->attr_array_len) {
+		cmd->attr_array_len *= 2;
+		cmd->attr = xrealloc(cmd->attr, sizeof(struct nlerr_loc) * cmd->attr_array_len);
+	}
+
+	cmd->attr[cmd->num_attrs].offset = offset;
+	cmd->attr[cmd->num_attrs].location = loc;
+	cmd->num_attrs++;
+}
+
 static int nft_cmd_enoent_table(struct netlink_ctx *ctx, const struct cmd *cmd,
 				const struct location *loc)
 {
@@ -302,3 +314,197 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 	netlink_io_error(ctx, loc, "Could not process rule: %s",
 			 strerror(err->err));
 }
+
+static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
+{
+	struct rule *rule, *next;
+	struct handle h;
+	struct cmd *new;
+
+	list_for_each_entry_safe(rule, next, &chain->rules, list) {
+		list_del(&rule->list);
+		handle_merge(&rule->handle, &chain->handle);
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &chain->handle);
+		if (chain->flags & CHAIN_F_BINDING) {
+			rule->handle.chain_id = chain->handle.chain_id;
+			rule->handle.chain.location = chain->location;
+		}
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
+				&rule->location, rule);
+		list_add_tail(&new->list, new_cmds);
+	}
+}
+
+void nft_cmd_expand(struct cmd *cmd)
+{
+	struct list_head new_cmds;
+	struct flowtable *ft;
+	struct table *table;
+	struct chain *chain;
+	struct set *set;
+	struct obj *obj;
+	struct cmd *new;
+	struct handle h;
+
+	init_list_head(&new_cmds);
+
+	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		table = cmd->table;
+		if (!table)
+			return;
+
+		list_for_each_entry(chain, &table->chains, list) {
+			handle_merge(&chain->handle, &table->handle);
+			memset(&h, 0, sizeof(h));
+			handle_merge(&h, &chain->handle);
+			h.chain_id = chain->handle.chain_id;
+			new = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &h,
+					&chain->location, chain_get(chain));
+			list_add_tail(&new->list, &new_cmds);
+		}
+		list_for_each_entry(obj, &table->objs, list) {
+			handle_merge(&obj->handle, &table->handle);
+			memset(&h, 0, sizeof(h));
+			handle_merge(&h, &obj->handle);
+			new = cmd_alloc(CMD_ADD, obj_type_to_cmd(obj->type), &h,
+					&obj->location, obj_get(obj));
+			list_add_tail(&new->list, &new_cmds);
+		}
+		list_for_each_entry(set, &table->sets, list) {
+			handle_merge(&set->handle, &table->handle);
+			memset(&h, 0, sizeof(h));
+			handle_merge(&h, &set->handle);
+			new = cmd_alloc(CMD_ADD, CMD_OBJ_SET, &h,
+					&set->location, set_get(set));
+			list_add_tail(&new->list, &new_cmds);
+		}
+		list_for_each_entry(ft, &table->flowtables, list) {
+			handle_merge(&ft->handle, &table->handle);
+			memset(&h, 0, sizeof(h));
+			handle_merge(&h, &ft->handle);
+			new = cmd_alloc(CMD_ADD, CMD_OBJ_FLOWTABLE, &h,
+					&ft->location, flowtable_get(ft));
+			list_add_tail(&new->list, &new_cmds);
+		}
+		list_for_each_entry(chain, &table->chains, list)
+			nft_cmd_expand_chain(chain, &new_cmds);
+
+		list_splice(&new_cmds, &cmd->list);
+		break;
+	case CMD_OBJ_CHAIN:
+		chain = cmd->chain;
+		if (!chain || list_empty(&chain->rules))
+			break;
+
+		nft_cmd_expand_chain(chain, &new_cmds);
+		list_splice(&new_cmds, &cmd->list);
+		break;
+	default:
+		break;
+	}
+}
+
+void nft_cmd_post_expand(struct cmd *cmd)
+{
+	struct list_head new_cmds;
+	struct set *set;
+	struct cmd *new;
+	struct handle h;
+
+	init_list_head(&new_cmds);
+
+	switch (cmd->obj) {
+	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+		set = cmd->set;
+		if (!set->init)
+			break;
+
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &set->handle);
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEMS, &h,
+				&set->location, set_get(set));
+		list_add(&new->list, &cmd->list);
+		break;
+	default:
+		break;
+	}
+}
+
+bool nft_cmd_collapse(struct list_head *cmds)
+{
+	struct cmd *cmd, *next, *elems = NULL;
+	struct expr *expr, *enext;
+	bool collapse = false;
+
+	list_for_each_entry_safe(cmd, next, cmds, list) {
+		if (cmd->op != CMD_ADD &&
+		    cmd->op != CMD_CREATE) {
+			elems = NULL;
+			continue;
+		}
+
+		if (cmd->obj != CMD_OBJ_ELEMENTS) {
+			elems = NULL;
+			continue;
+		}
+
+		if (!elems) {
+			elems = cmd;
+			continue;
+		}
+
+		if (cmd->op != elems->op) {
+			elems = cmd;
+			continue;
+		}
+
+		if (elems->handle.family != cmd->handle.family ||
+		    strcmp(elems->handle.table.name, cmd->handle.table.name) ||
+		    strcmp(elems->handle.set.name, cmd->handle.set.name)) {
+			elems = cmd;
+			continue;
+		}
+
+		collapse = true;
+		list_for_each_entry_safe(expr, enext, &cmd->expr->expressions, list) {
+			expr->cmd = cmd;
+			list_move_tail(&expr->list, &elems->expr->expressions);
+		}
+		elems->expr->size += cmd->expr->size;
+		list_move_tail(&cmd->list, &elems->collapse_list);
+	}
+
+	return collapse;
+}
+
+void nft_cmd_uncollapse(struct list_head *cmds)
+{
+	struct cmd *cmd, *cmd_next, *collapse_cmd, *collapse_cmd_next;
+	struct expr *expr, *next;
+
+	list_for_each_entry_safe(cmd, cmd_next, cmds, list) {
+		if (list_empty(&cmd->collapse_list))
+			continue;
+
+		assert(cmd->obj == CMD_OBJ_ELEMENTS);
+
+		list_for_each_entry_safe(expr, next, &cmd->expr->expressions, list) {
+			if (!expr->cmd)
+				continue;
+
+			list_move_tail(&expr->list, &expr->cmd->expr->expressions);
+			cmd->expr->size--;
+			expr->cmd = NULL;
+		}
+
+		list_for_each_entry_safe(collapse_cmd, collapse_cmd_next, &cmd->collapse_list, list) {
+			if (cmd->elem.set)
+				collapse_cmd->elem.set = set_get(cmd->elem.set);
+
+			list_add(&collapse_cmd->list, &cmd->list);
+		}
+	}
+}
diff --git a/src/rule.c b/src/rule.c
index 047e405707f6..a04063f7faf7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1298,212 +1298,6 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	return cmd;
 }
 
-void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
-{
-	if (cmd->num_attrs >= cmd->attr_array_len) {
-		cmd->attr_array_len *= 2;
-		cmd->attr = xrealloc(cmd->attr, sizeof(struct nlerr_loc) * cmd->attr_array_len);
-	}
-
-	cmd->attr[cmd->num_attrs].offset = offset;
-	cmd->attr[cmd->num_attrs].location = loc;
-	cmd->num_attrs++;
-}
-
-static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
-{
-	struct rule *rule, *next;
-	struct handle h;
-	struct cmd *new;
-
-	list_for_each_entry_safe(rule, next, &chain->rules, list) {
-		list_del(&rule->list);
-		handle_merge(&rule->handle, &chain->handle);
-		memset(&h, 0, sizeof(h));
-		handle_merge(&h, &chain->handle);
-		if (chain->flags & CHAIN_F_BINDING) {
-			rule->handle.chain_id = chain->handle.chain_id;
-			rule->handle.chain.location = chain->location;
-		}
-		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-				&rule->location, rule);
-		list_add_tail(&new->list, new_cmds);
-	}
-}
-
-void nft_cmd_expand(struct cmd *cmd)
-{
-	struct list_head new_cmds;
-	struct flowtable *ft;
-	struct table *table;
-	struct chain *chain;
-	struct set *set;
-	struct obj *obj;
-	struct cmd *new;
-	struct handle h;
-
-	init_list_head(&new_cmds);
-
-	switch (cmd->obj) {
-	case CMD_OBJ_TABLE:
-		table = cmd->table;
-		if (!table)
-			return;
-
-		list_for_each_entry(chain, &table->chains, list) {
-			handle_merge(&chain->handle, &table->handle);
-			memset(&h, 0, sizeof(h));
-			handle_merge(&h, &chain->handle);
-			h.chain_id = chain->handle.chain_id;
-			new = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &h,
-					&chain->location, chain_get(chain));
-			list_add_tail(&new->list, &new_cmds);
-		}
-		list_for_each_entry(obj, &table->objs, list) {
-			handle_merge(&obj->handle, &table->handle);
-			memset(&h, 0, sizeof(h));
-			handle_merge(&h, &obj->handle);
-			new = cmd_alloc(CMD_ADD, obj_type_to_cmd(obj->type), &h,
-					&obj->location, obj_get(obj));
-			list_add_tail(&new->list, &new_cmds);
-		}
-		list_for_each_entry(set, &table->sets, list) {
-			handle_merge(&set->handle, &table->handle);
-			memset(&h, 0, sizeof(h));
-			handle_merge(&h, &set->handle);
-			new = cmd_alloc(CMD_ADD, CMD_OBJ_SET, &h,
-					&set->location, set_get(set));
-			list_add_tail(&new->list, &new_cmds);
-		}
-		list_for_each_entry(ft, &table->flowtables, list) {
-			handle_merge(&ft->handle, &table->handle);
-			memset(&h, 0, sizeof(h));
-			handle_merge(&h, &ft->handle);
-			new = cmd_alloc(CMD_ADD, CMD_OBJ_FLOWTABLE, &h,
-					&ft->location, flowtable_get(ft));
-			list_add_tail(&new->list, &new_cmds);
-		}
-		list_for_each_entry(chain, &table->chains, list)
-			nft_cmd_expand_chain(chain, &new_cmds);
-
-		list_splice(&new_cmds, &cmd->list);
-		break;
-	case CMD_OBJ_CHAIN:
-		chain = cmd->chain;
-		if (!chain || list_empty(&chain->rules))
-			break;
-
-		nft_cmd_expand_chain(chain, &new_cmds);
-		list_splice(&new_cmds, &cmd->list);
-		break;
-	default:
-		break;
-	}
-}
-
-void nft_cmd_post_expand(struct cmd *cmd)
-{
-	struct list_head new_cmds;
-	struct set *set;
-	struct cmd *new;
-	struct handle h;
-
-	init_list_head(&new_cmds);
-
-	switch (cmd->obj) {
-	case CMD_OBJ_SET:
-	case CMD_OBJ_MAP:
-		set = cmd->set;
-		if (!set->init)
-			break;
-
-		memset(&h, 0, sizeof(h));
-		handle_merge(&h, &set->handle);
-		new = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEMS, &h,
-				&set->location, set_get(set));
-		list_add(&new->list, &cmd->list);
-		break;
-	default:
-		break;
-	}
-}
-
-bool nft_cmd_collapse(struct list_head *cmds)
-{
-	struct cmd *cmd, *next, *elems = NULL;
-	struct expr *expr, *enext;
-	bool collapse = false;
-
-	list_for_each_entry_safe(cmd, next, cmds, list) {
-		if (cmd->op != CMD_ADD &&
-		    cmd->op != CMD_CREATE) {
-			elems = NULL;
-			continue;
-		}
-
-		if (cmd->obj != CMD_OBJ_ELEMENTS) {
-			elems = NULL;
-			continue;
-		}
-
-		if (!elems) {
-			elems = cmd;
-			continue;
-		}
-
-		if (cmd->op != elems->op) {
-			elems = cmd;
-			continue;
-		}
-
-		if (elems->handle.family != cmd->handle.family ||
-		    strcmp(elems->handle.table.name, cmd->handle.table.name) ||
-		    strcmp(elems->handle.set.name, cmd->handle.set.name)) {
-			elems = cmd;
-			continue;
-		}
-
-		collapse = true;
-		list_for_each_entry_safe(expr, enext, &cmd->expr->expressions, list) {
-			expr->cmd = cmd;
-			list_move_tail(&expr->list, &elems->expr->expressions);
-		}
-		elems->expr->size += cmd->expr->size;
-		list_move_tail(&cmd->list, &elems->collapse_list);
-	}
-
-	return collapse;
-}
-
-void nft_cmd_uncollapse(struct list_head *cmds)
-{
-	struct cmd *cmd, *cmd_next, *collapse_cmd, *collapse_cmd_next;
-	struct expr *expr, *next;
-
-	list_for_each_entry_safe(cmd, cmd_next, cmds, list) {
-		if (list_empty(&cmd->collapse_list))
-			continue;
-
-		assert(cmd->obj == CMD_OBJ_ELEMENTS);
-
-		list_for_each_entry_safe(expr, next, &cmd->expr->expressions, list) {
-			if (!expr->cmd)
-				continue;
-
-			list_move_tail(&expr->list, &expr->cmd->expr->expressions);
-			cmd->expr->size--;
-			expr->cmd = NULL;
-		}
-
-		list_for_each_entry_safe(collapse_cmd, collapse_cmd_next, &cmd->collapse_list, list) {
-			if (cmd->elem.set)
-				collapse_cmd->elem.set = set_get(cmd->elem.set);
-
-			list_add(&collapse_cmd->list, &cmd->list);
-		}
-	}
-}
-
 struct markup *markup_alloc(uint32_t format)
 {
 	struct markup *markup;
-- 
2.30.2

