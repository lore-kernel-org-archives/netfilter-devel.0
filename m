From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: error reporting for nested ruleset representation
Date: Fri, 16 Jun 2017 19:03:06 +0200
Message-ID: <1497632586-13161-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdFPRDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2017 13:03:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F7A317D428
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2017 19:03:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86098100790
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2017 19:03:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 484C1100791
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2017 19:03:08 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you load a file using the nested ruleset representation, ie. the one
you get via `nft list ruleset', error reporting doesn't help you much to
find the problem.

For example, the following ruleset points to an unexisting chain 'x':

 table test {
        chain test {
                type filter hook ingress priority 0; policy drop;
                ip saddr { 1.1.1.1, 2.2.2.2, 3.3.3.3, 4.4.4.4 } jump x
        }
 }

Error reporting is very sparse as it says:

 # nft -f /home/test/x
 /home/test/x:1:1-2: Error: Could not process rule: No such file or directory
 table netdev test{
 ^^

So it's hard to know what is exactly missing.

This patch enhances the existing logic, so nft points to the rule
causing the problem, ie.

 # nft -f /home/test/x
 /home/test/x:4:17-70: Error: Could not process rule: No such file or directory
                ip saddr { 1.1.1.1, 2.2.2.2, 3.3.3.3, 4.4.4.4 } jump x
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The idea behind this patch is to expand the single table command into a
list of individual commands, one per nested object inside the table.
This expanded list is spliced into the existing list of commands. Thus,
each command gets a sequence number that helps us correlate the error
with the command that triggers it.

This patch also includes reference counting for rules and objects. This
was already in place for table, chain and sets. We need this since now
we hold references to them from both the command and the table object
itself. So the last reference releases the object from memory. Note that
table objects still keep the list of chain, sets, etc. since the
existing cache logic needs this to work.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |   9 +++-
 src/main.c     |   4 ++
 src/rule.c     | 148 +++++++++++++++++++++++++++++++++++++--------------------
 3 files changed, 108 insertions(+), 53 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index fb4606406a94..3178a9788e18 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -182,6 +182,7 @@ extern void chain_print_plain(const struct chain *chain);
  * @stmt:	list of statements
  * @num_stmts:	number of statements in stmts list
  * @comment:	comment
+ * @refcnt:	rule reference counter
  */
 struct rule {
 	struct list_head	list;
@@ -190,10 +191,12 @@ struct rule {
 	struct list_head	stmts;
 	unsigned int		num_stmts;
 	const char		*comment;
+	unsigned int		refcnt;
 };
 
 extern struct rule *rule_alloc(const struct location *loc,
 			       const struct handle *h);
+extern struct rule *rule_get(struct rule *rule);
 extern void rule_free(struct rule *rule);
 extern void rule_print(const struct rule *rule);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
@@ -273,13 +276,14 @@ struct ct {
  * @location:	location the stateful object was defined/declared at
  * @handle:	counter handle
  * @type:	type of stateful object
+ * @refcnt:	object reference counter
  */
 struct obj {
 	struct list_head		list;
 	struct location			location;
 	struct handle			handle;
 	uint32_t			type;
-
+	unsigned int			refcnt;
 	union {
 		struct counter		counter;
 		struct quota		quota;
@@ -288,6 +292,7 @@ struct obj {
 };
 
 struct obj *obj_alloc(const struct location *loc);
+extern struct obj *obj_get(struct obj *obj);
 void obj_free(struct obj *obj);
 void obj_add_hash(struct obj *obj, struct table *table);
 struct obj *obj_lookup(const struct table *table, const char *name,
@@ -295,6 +300,7 @@ struct obj *obj_lookup(const struct table *table, const char *name,
 void obj_print(const struct obj *n);
 void obj_print_plain(const struct obj *obj);
 const char *obj_type_name(uint32_t type);
+uint32_t obj_type_to_cmd(uint32_t type);
 
 /**
  * enum cmd_ops - command operations
@@ -439,6 +445,7 @@ struct cmd {
 extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
+extern void nft_cmd_expand(struct cmd *cmd);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
 				    const struct location *loc, void *data);
diff --git a/src/main.c b/src/main.c
index 5089ff2448f3..9ddcdf549fda 100644
--- a/src/main.c
+++ b/src/main.c
@@ -241,6 +241,10 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 		ret = -1;
 		goto err1;
 	}
+
+	list_for_each_entry(cmd, &state->cmds, list)
+		nft_cmd_expand(cmd);
+
 	ret = nft_netlink(state, msgs);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
diff --git a/src/rule.c b/src/rule.c
index 0d9e393ab26f..a2dd44ec6ec7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -391,13 +391,23 @@ struct rule *rule_alloc(const struct location *loc, const struct handle *h)
 	rule->location = *loc;
 	init_list_head(&rule->list);
 	init_list_head(&rule->stmts);
+	rule->refcnt = 1;
 	if (h != NULL)
 		rule->handle = *h;
+
+	return rule;
+}
+
+struct rule *rule_get(struct rule *rule)
+{
+	rule->refcnt++;
 	return rule;
 }
 
 void rule_free(struct rule *rule)
 {
+	if (--rule->refcnt > 0)
+		return;
 	stmt_list_free(&rule->stmts);
 	handle_free(&rule->handle);
 	xfree(rule->comment);
@@ -821,6 +831,65 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 	return cmd;
 }
 
+void nft_cmd_expand(struct cmd *cmd)
+{
+	struct list_head new_cmds;
+	struct table *table;
+	struct chain *chain;
+	struct rule *rule;
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
+			memset(&h, 0, sizeof(h));
+			handle_merge(&h, &chain->handle);
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
+		list_for_each_entry(chain, &table->chains, list) {
+			list_for_each_entry(rule, &chain->rules, list) {
+				memset(&h, 0, sizeof(h));
+				handle_merge(&h, &rule->handle);
+				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
+						&rule->location,
+						rule_get(rule));
+				list_add_tail(&new->list, &new_cmds);
+			}
+		}
+		list_splice(&new_cmds, &cmd->list);
+		break;
+	default:
+		break;
+	}
+}
+
 struct export *export_alloc(uint32_t format)
 {
 	struct export *export;
@@ -898,19 +967,6 @@ void cmd_free(struct cmd *cmd)
 
 #include <netlink.h>
 
-static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
-			const struct location *loc, struct chain *chain,
-			bool excl)
-{
-	if (netlink_add_chain(ctx, h, loc, chain, excl) < 0)
-		return -1;
-	if (chain != NULL) {
-		if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
-			return -1;
-	}
-	return 0;
-}
-
 static int __do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			     struct set *set, struct expr *expr, bool excl)
 {
@@ -954,50 +1010,15 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
-static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
-			const struct location *loc, struct table *table,
-			bool excl)
-{
-	struct chain *chain;
-	struct obj *obj;
-	struct set *set;
-
-	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
-		return -1;
-	if (table != NULL) {
-		list_for_each_entry(chain, &table->chains, list) {
-			if (netlink_add_chain(ctx, &chain->handle,
-					      &chain->location, chain,
-					      excl) < 0)
-				return -1;
-		}
-		list_for_each_entry(obj, &table->objs, list) {
-			handle_merge(&obj->handle, &table->handle);
-			if (netlink_add_obj(ctx, &obj->handle, obj, excl) < 0)
-				return -1;
-		}
-		list_for_each_entry(set, &table->sets, list) {
-			handle_merge(&set->handle, &table->handle);
-			if (do_add_set(ctx, &set->handle, set, excl) < 0)
-				return -1;
-		}
-		list_for_each_entry(chain, &table->chains, list) {
-			if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
-				return -1;
-		}
-	}
-	return 0;
-}
-
 static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
-		return do_add_table(ctx, &cmd->handle, &cmd->location,
-				    cmd->table, excl);
+		return netlink_add_table(ctx, &cmd->handle, &cmd->location,
+					 cmd->table, excl);
 	case CMD_OBJ_CHAIN:
-		return do_add_chain(ctx, &cmd->handle, &cmd->location,
-				    cmd->chain, excl);
+		return netlink_add_chain(ctx, &cmd->handle, &cmd->location,
+					 cmd->chain, excl);
 	case CMD_OBJ_RULE:
 		return netlink_add_rule_batch(ctx, &cmd->handle,
 					      cmd->rule, NLM_F_APPEND);
@@ -1156,11 +1177,21 @@ struct obj *obj_alloc(const struct location *loc)
 	obj = xzalloc(sizeof(*obj));
 	if (loc != NULL)
 		obj->location = *loc;
+
+	obj->refcnt = 1;
+	return obj;
+}
+
+struct obj *obj_get(struct obj *obj)
+{
+	obj->refcnt++;
 	return obj;
 }
 
 void obj_free(struct obj *obj)
 {
+	if (--obj->refcnt > 0)
+		return;
 	handle_free(&obj->handle);
 	xfree(obj);
 }
@@ -1249,6 +1280,19 @@ const char *obj_type_name(enum stmt_types type)
 	return obj_type_name_array[type];
 }
 
+static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
+	[NFT_OBJECT_COUNTER]	= CMD_OBJ_COUNTER,
+	[NFT_OBJECT_QUOTA]	= CMD_OBJ_QUOTA,
+	[NFT_OBJECT_CT_HELPER]	= CMD_OBJ_CT_HELPER,
+};
+
+uint32_t obj_type_to_cmd(uint32_t type)
+{
+	assert(type <= NFT_OBJECT_MAX && obj_type_cmd_array[type]);
+
+	return obj_type_cmd_array[type];
+}
+
 static void obj_print_declaration(const struct obj *obj,
 				  struct print_fmt_options *opts)
 {
-- 
2.1.4

