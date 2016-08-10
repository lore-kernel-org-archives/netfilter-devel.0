From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 4/4, V3, nft] Implement deleting rule by description
Date: Wed, 10 Aug 2016 11:48:57 +0200
Message-ID: <20160810094857.14227-4-carlosfg@riseup.net>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:36379 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933961AbcHJTMW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:12:22 -0400
In-Reply-To: <20160810094857.14227-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces deletion in a similar fashion as in iptables,
thus, we can delete the first rule that matches our description, for
example:

	$ nft list -a ruleset
	table ip t {
		chain c {
			ip saddr 1.1.1.1 counter packets 0 bytes 0 # handle 1
			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 2
			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 3
			ip saddr 1.1.1.4 counter packets 0 bytes 0 # handle 4
		}
	}
	$ nft delete rule table chain ip saddr 1.1.1.2 counter
	$ nft list -a ruleset
	table ip t {
		chain c {
			ip saddr 1.1.1.1 counter packets 0 bytes 0 # handle 1
			ip saddr 1.1.1.2 counter packets 0 bytes 0 # handle 3
			ip saddr 1.1.1.4 counter packets 0 bytes 0 # handle 4
		}
	}

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/evaluate.c     |  6 ++++++
 src/parser_bison.y | 28 +++++++++++++++++++++-------
 src/rule.c         | 45 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2f94ac6..f7b349b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2661,7 +2661,13 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
+		return 0;
 	case CMD_OBJ_RULE:
+		/* CMD_LIST force caching all ruleset */
+		ret = cache_update(CMD_LIST, ctx->msgs);
+		if (ret < 0)
+			return ret;
+		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
 		return 0;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8dce416..31ce35b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -425,8 +425,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
+%type <handle>			table_spec chain_spec chain_identifier handle_spec position_spec rule_position ruleset_spec
+%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier handle_spec position_spec rule_position ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
@@ -438,7 +438,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
 %type <chain>			chain_block_alloc chain_block
 %destructor { close_scope(state); chain_free($$); }	chain_block_alloc
-%type <rule>			rule rule_alloc
+%type <rule>			rule ruleid_spec rule_alloc
 %destructor { rule_free($$); }	rule
 
 %type <val>			set_flag_list	set_flag
@@ -747,7 +747,7 @@ add_cmd			:	TABLE		table_spec
 
 replace_cmd		:	RULE		ruleid_spec	rule
 			{
-				$$ = cmd_alloc(CMD_REPLACE, CMD_OBJ_RULE, &$2, &@$, $3);
+				$$ = cmd_alloc(CMD_REPLACE, CMD_OBJ_RULE, &$2->handle, &@$, $3);
 			}
 			;
 
@@ -792,7 +792,7 @@ delete_cmd		:	TABLE		table_spec
 			}
 			|	RULE		ruleid_spec
 			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2->handle, &@$, $2);
 			}
 			|	SET		set_spec
 			{
@@ -1282,8 +1282,22 @@ rule_position		:	chain_spec
 
 ruleid_spec		:	chain_spec handle_spec
 			{
-				$$ = $1;
-				handle_merge(&$$, &$2);
+				$$ = rule_alloc(&@$, NULL);
+				$$->handle = $1;
+				handle_merge(&$$->handle, &$2);
+			}
+			|
+				chain_spec rule
+			{
+				$$ = $2;
+				handle_merge(&$$->handle, &$1);
+			}
+			|	chain_spec error
+			{
+				erec_queue(error(&@2, "Expected `handle' or rule description"),
+					   state->msgs);
+				$$ = rule_alloc(&@$, NULL);
+				handle_merge(&$$->handle, &$1);
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 14e57f2..3f15ee5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -402,6 +402,32 @@ void rule_print(const struct rule *rule)
 		printf(" # handle %" PRIu64, rule->handle.handle.id);
 }
 
+static struct rule *search_first_rule(const struct rule *rule)
+{
+	struct nftnl_rule *nlr1, *nlr2;
+	struct rule *rule_idx;
+	struct table *table;
+	struct chain *chain;
+
+	table = table_lookup(&rule->handle);
+	if (!table)
+		return NULL;
+	chain = chain_lookup(table, &rule->handle);
+	if (!chain)
+		return NULL;
+
+	nlr1 = alloc_nftnl_rule(&rule->handle);
+	netlink_linearize_rule(NULL, nlr1, rule);
+
+	list_for_each_entry(rule_idx, &chain->rules, list) {
+		nlr2 = alloc_nftnl_rule(&rule_idx->handle);
+		netlink_linearize_rule(NULL, nlr2, rule_idx);
+		if (nftnl_rule_cmp(nlr1, nlr2))
+			return rule_idx;
+	}
+	return NULL;
+}
+
 struct rule *rule_lookup(const struct chain *chain, uint64_t handle)
 {
 	struct rule *rule;
@@ -1010,6 +1036,22 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	return 0;
 }
 
+static int do_delete_rule(struct netlink_ctx *ctx, const struct cmd *cmd)
+{
+	struct rule *rule;
+
+	// Delete by handle
+	if (cmd->handle.handle.id)
+		return netlink_del_rule_batch(ctx, &cmd->handle, &cmd->location);
+
+	// Delete by description
+	rule = search_first_rule(cmd->rule);
+	if (!rule)
+		return 0;
+	return netlink_del_rule_batch(ctx, &rule->handle,
+				      &rule->handle.position.location);
+}
+
 static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -1018,8 +1060,7 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAIN:
 		return netlink_delete_chain(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_RULE:
-		return netlink_del_rule_batch(ctx, &cmd->handle,
-					      &cmd->location);
+		return do_delete_rule(ctx, cmd);
 	case CMD_OBJ_SET:
 		return netlink_delete_set(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SETELEM:
-- 
2.8.3

