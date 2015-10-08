From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/7] src: add `list chains' command
Date: Thu,  8 Oct 2015 22:49:25 +0200
Message-ID: <1444337370-8269-3-git-send-email-pablo@netfilter.org>
References: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47750 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbbJHUmi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 16:42:38 -0400
In-Reply-To: <1444337370-8269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft list chains
 table ip filter {
        chain test1 {
        }
        chain test2 {
        }
        chain input {
                type filter hook input priority 0; policy accept;
        }
 }
 table ip6 filter {
        chain test1 {
        }
        chain input {
                type filter hook input priority 0; policy accept;
        }
 }

You can also filter out per family:

 # nft list chains ip
 table ip x {
        chain y {
        }
        chain xz {
        }
        chain input {
                type filter hook input priority 0; policy accept;
        }
 }

 # nft list chains ip6
 table ip6 filter {
        chain x {
        }
        chain input {
                type filter hook input priority 0; policy accept;
        }
 }

This command only shows the chain declarations, so the content (the
definition) is omitted.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     |  2 ++
 src/evaluate.c     |  1 +
 src/parser_bison.y |  4 ++++
 src/rule.c         | 38 +++++++++++++++++++++++++++++++++++---
 4 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index f137a4c..30b4597 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -270,6 +270,7 @@ enum cmd_ops {
  * @CMD_OBJ_SETS:	multiple sets
  * @CMD_OBJ_RULE:	rule
  * @CMD_OBJ_CHAIN:	chain
+ * @CMD_OBJ_CHAINS:	multiple chains
  * @CMD_OBJ_TABLE:	table
  * @CMD_OBJ_RULESET:	ruleset
  * @CMD_OBJ_EXPR:	expression
@@ -283,6 +284,7 @@ enum cmd_obj {
 	CMD_OBJ_SETS,
 	CMD_OBJ_RULE,
 	CMD_OBJ_CHAIN,
+	CMD_OBJ_CHAINS,
 	CMD_OBJ_TABLE,
 	CMD_OBJ_RULESET,
 	CMD_OBJ_EXPR,
diff --git a/src/evaluate.c b/src/evaluate.c
index e8eafc6..9762586 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2105,6 +2105,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Chain '%s' does not exist",
 					 cmd->handle.chain);
 		return 0;
+	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_RULESET:
 		return 0;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3c371ba..86e2dc9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -780,6 +780,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
+			|	CHAINS		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAINS, &$2, &@$, NULL);
+			}
 			|	SETS		tables_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SETS, &$2, &@$, NULL);
diff --git a/src/rule.c b/src/rule.c
index 71b26e3..4e4126d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -600,10 +600,8 @@ static const char *chain_policy2str(uint32_t policy)
 	return "unknown";
 }
 
-static void chain_print(const struct chain *chain)
+static void chain_print_declaration(const struct chain *chain)
 {
-	struct rule *rule;
-
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		if (chain->dev != NULL) {
@@ -619,6 +617,14 @@ static void chain_print(const struct chain *chain)
 			       chain->priority, chain_policy2str(chain->policy));
 		}
 	}
+}
+
+static void chain_print(const struct chain *chain)
+{
+	struct rule *rule;
+
+	chain_print_declaration(chain);
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
 		rule_print(rule);
@@ -1036,6 +1042,30 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
+static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+	struct chain *chain;
+
+	list_for_each_entry(table, &table_list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    cmd->handle.family != table->handle.family)
+			continue;
+
+		printf("table %s %s {\n",
+		       family2str(table->handle.family),
+		       table->handle.table);
+
+		list_for_each_entry(chain, &table->chains, list) {
+			chain_print_declaration(chain);
+			printf("\t}\n");
+		}
+		printf("}\n");
+	}
+
+	return 0;
+}
+
 static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 		       struct table *table)
 {
@@ -1063,6 +1093,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_CHAIN:
 		return do_list_table(ctx, cmd, table);
+	case CMD_OBJ_CHAINS:
+		return do_list_chains(ctx, cmd);
 	case CMD_OBJ_SETS:
 		return do_list_sets(ctx, cmd);
 	case CMD_OBJ_SET:
-- 
2.1.4

