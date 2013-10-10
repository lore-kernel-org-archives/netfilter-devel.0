From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables tool PATCH v2] src: add support for listing the entire
	ruleset
Date: Thu, 10 Oct 2013 10:06:19 +0200
Message-ID: <20131010080540.1198.84784.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56081 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752878Ab3JJIGg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:06:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add the following operation:

 :~# nft list ruleset

With this, you can backup your current ruleset and import later with '-f'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: delete double NFPROTO_UNSPEC assignement and useless memset.

 include/rule.h |    1 +
 src/parser.y   |   17 +++++++++++++++--
 src/rule.c     |   18 ++++++++++++++++++
 src/scanner.l  |    1 +
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 6ad8af3..28b45ce 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -234,6 +234,7 @@ enum cmd_obj {
 	CMD_OBJ_RULE,
 	CMD_OBJ_CHAIN,
 	CMD_OBJ_TABLE,
+	CMD_OBJ_RULESET,
 };
 
 /**
diff --git a/src/parser.y b/src/parser.y
index 074f075..e4dd44c 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -157,6 +157,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token HOOK			"hook"
 %token TABLE			"table"
 %token TABLES			"tables"
+%token RULESET			"ruleset"
 %token CHAIN			"chain"
 %token RULE			"rule"
 %token SETS			"sets"
@@ -340,8 +341,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
 
-%type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
-%destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
+%type <handle>			table_spec tables_spec ruleset_spec chain_spec chain_identifier ruleid_spec
+%destructor { handle_free(&$$); } table_spec tables_spec ruleset_spec chain_spec chain_identifier ruleid_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			handle_spec family_spec position_spec
@@ -618,6 +619,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
+			|	RULESET		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
+			}
 			|	CHAIN		chain_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CHAIN, &$2, &@$, NULL);
@@ -833,6 +838,14 @@ tables_spec		:	family_spec
 			}
 			;
 
+ruleset_spec		:
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.family	= NFPROTO_UNSPEC;
+				$$.table	= NULL;
+			}
+			;
+
 chain_spec		:	table_spec	identifier
 			{
 				$$		= $1;
diff --git a/src/rule.c b/src/rule.c
index 39a66d7..229b67e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -583,6 +583,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct chain *chain, *nchain;
 	struct rule *rule, *nrule;
 	struct set *set, *nset;
+	struct netlink_ctx ctx_index;
 
 	/* No need to allocate the table object when listing all tables */
 	if (cmd->handle.table != NULL) {
@@ -595,6 +596,23 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	}
 
 	switch (cmd->obj) {
+	case CMD_OBJ_RULESET:
+		if (netlink_list_tables(ctx, &cmd->handle, &cmd->location) < 0)
+			return -1;
+
+		init_list_head(&ctx_index.list);
+		ctx_index.msgs = ctx->msgs;
+		ctx_index.seqnum = cmd->seqnum;
+
+		cmd->obj = CMD_OBJ_TABLE;
+
+		list_for_each_entry(table, &ctx->list, list) {
+			cmd->handle.family = table->handle.family;
+			cmd->handle.table = table->handle.table;
+			if (do_command_list(&ctx_index, cmd) != 0)
+				return -1;
+		}
+		return 0;
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table) {
 			/* List all existing tables */
diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..8035710 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -220,6 +220,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "hook"			{ return HOOK; }
 "table"			{ return TABLE; }
 "tables"		{ return TABLES; }
+"ruleset"		{ return RULESET; }
 "chain"			{ return CHAIN; }
 "rule"			{ return RULE; }
 "sets"			{ return SETS; }

