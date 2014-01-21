From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] cmd: add create command for tables and chains
Date: Tue, 21 Jan 2014 12:50:10 +0000
Message-ID: <1390308610-32456-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39118 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaAUMuT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 07:50:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently always use NLM_F_EXCL for add, which makes adding existing
chains or tables fail. There's usually no reason why you would care about
this, so change "add" to not use NLM_F_EXCL and add a new "create" command
in case you do care.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h |  4 ++--
 include/rule.h    |  4 +++-
 src/evaluate.c    |  1 +
 src/mnl.c         | 14 +++++++-------
 src/netlink.c     | 10 ++++++----
 src/parser.y      | 31 +++++++++++++++++++++++++++++--
 src/rule.c        | 22 +++++++++++++---------
 src/scanner.l     |  1 +
 8 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index fbaaaeb..3f8d465 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -82,7 +82,7 @@ extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
 
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
-			     const struct chain *chain);
+			     const struct chain *chain, bool excl);
 extern int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc, const char *name);
 extern int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
@@ -98,7 +98,7 @@ extern int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 
 extern int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			     const struct location *loc,
-			     const struct table *table);
+			     const struct table *table, bool excl);
 extern int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 				const struct location *loc);
 extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/include/rule.h b/include/rule.h
index 2a7b798..30a4d12 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -198,7 +198,8 @@ extern void set_print(const struct set *set);
  * enum cmd_ops - command operations
  *
  * @CMD_INVALID:	invalid
- * @CMD_ADD:		add object
+ * @CMD_ADD:		add object (non-exclusive)
+ * @CMD_CREATE:		create object (exclusive)
  * @CMD_INSERT:		insert object
  * @CMD_DELETE:		delete object
  * @CMD_LIST:		list container
@@ -208,6 +209,7 @@ extern void set_print(const struct set *set);
 enum cmd_ops {
 	CMD_INVALID,
 	CMD_ADD,
+	CMD_CREATE,
 	CMD_INSERT,
 	CMD_DELETE,
 	CMD_LIST,
diff --git a/src/evaluate.c b/src/evaluate.c
index 2b2427a..cf30ed9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1397,6 +1397,7 @@ static int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	ctx->cmd = cmd;
 	switch (cmd->op) {
 	case CMD_ADD:
+	case CMD_CREATE:
 	case CMD_INSERT:
 		return cmd_evaluate_add(ctx, cmd);
 	case CMD_DELETE:
diff --git a/src/mnl.c b/src/mnl.c
index b867902..7ac1fc5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -280,7 +280,7 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			flags|NLM_F_CREATE, seqnum);
+			NLM_F_CREATE | flags, seqnum);
 
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 	if (!mnl_nlmsg_batch_next(batch))
@@ -318,7 +318,7 @@ int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
-			flags|NLM_F_ACK|NLM_F_CREATE, seq);
+			NLM_F_ACK | NLM_F_CREATE | flags, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
@@ -394,7 +394,7 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
-			NLM_F_CREATE|NLM_F_ACK|flags, seq);
+			NLM_F_CREATE | NLM_F_ACK | flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
@@ -472,7 +472,7 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
-			NLM_F_ACK|flags, seq);
+			NLM_F_ACK | flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_get_cb, nlc);
@@ -489,7 +489,7 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
-			NLM_F_EXCL|NLM_F_ACK, seq);
+			NLM_F_ACK | flags, seq);
 	nft_table_nlmsg_build_payload(nlh, nlt);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
@@ -590,7 +590,7 @@ int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 
 	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			flags|NLM_F_CREATE|NLM_F_ACK, seq);
+			NLM_F_CREATE | NLM_F_ACK | flags, seq);
 	nft_set_nlmsg_build_payload(nlh, nls);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
@@ -695,7 +695,7 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 
 	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			NLM_F_CREATE|NLM_F_EXCL|NLM_F_ACK, seq);
+			NLM_F_CREATE | NLM_F_ACK | flags, seq);
 	nft_set_elems_nlmsg_build_payload(nlh, nls);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
diff --git a/src/netlink.c b/src/netlink.c
index 7f69995..84be505 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -451,7 +451,8 @@ void netlink_dump_chain(struct nft_chain *nlc)
 }
 
 int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc, const struct chain *chain)
+		      const struct location *loc, const struct chain *chain,
+		      bool excl)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -466,7 +467,7 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 				       chain->type);
 	}
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, NLM_F_EXCL);
+	err = mnl_nft_chain_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0);
 	nft_chain_free(nlc);
 
 	if (err < 0)
@@ -625,13 +626,14 @@ int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc, const struct table *table)
+		      const struct location *loc, const struct table *table,
+		      bool excl)
 {
 	struct nft_table *nlt;
 	int err;
 
 	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_add(nf_sock, nlt, NLM_F_EXCL);
+	err = mnl_nft_table_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0);
 	nft_table_free(nlt);
 
 	if (err < 0)
diff --git a/src/parser.y b/src/parser.y
index 3e3abed..cd9ade1 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -169,6 +169,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token INET			"inet"
 
 %token ADD			"add"
+%token CREATE			"create"
 %token INSERT			"insert"
 %token DELETE			"delete"
 %token LIST			"list"
@@ -351,8 +352,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
 
-%type <cmd>			base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
+%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd
 
 %type <handle>			table_spec tables_spec chain_spec chain_identifier ruleid_spec
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec
@@ -537,6 +538,7 @@ line			:	common_block			{ $$ = NULL; }
 
 base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 	  		|	ADD		add_cmd		{ $$ = $2; }
+			|	CREATE		create_cmd	{ $$ = $2; }
 			|	INSERT		insert_cmd	{ $$ = $2; }
 			|	DELETE		delete_cmd	{ $$ = $2; }
 			|	LIST		list_cmd	{ $$ = $2; }
@@ -601,6 +603,31 @@ add_cmd			:	TABLE		table_spec
 			}
 			;
 
+create_cmd		:	TABLE		table_spec
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TABLE, &$2, &@$, NULL);
+			}
+			|	TABLE		table_spec	table_block_alloc
+						'{'	table_block	'}'
+			{
+				handle_merge(&$3->handle, &$2);
+				close_scope(state);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TABLE, &$2, &@$, $5);
+			}
+			|	CHAIN		chain_spec
+			{
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
+			}
+			|	CHAIN		chain_spec	chain_block_alloc
+						'{'	chain_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				close_scope(state);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_CHAIN, &$2, &@$, $5);
+			}
+			;
+
 insert_cmd		:	RULE		ruleid_spec	rule
 			{
 				$$ = cmd_alloc(CMD_INSERT, CMD_OBJ_RULE, &$2, &@$, $3);
diff --git a/src/rule.c b/src/rule.c
index a721d47..18d72d9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -462,9 +462,10 @@ void cmd_free(struct cmd *cmd)
 #include <netlink.h>
 
 static int do_add_chain(struct netlink_ctx *ctx, const struct handle *h,
-			const struct location *loc, struct chain *chain)
+			const struct location *loc, struct chain *chain,
+			bool excl)
 {
-	if (netlink_add_chain(ctx, h, loc, chain) < 0)
+	if (netlink_add_chain(ctx, h, loc, chain, excl) < 0)
 		return -1;
 	if (chain != NULL) {
 		if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
@@ -496,12 +497,13 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 }
 
 static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
-			const struct location *loc, struct table *table)
+			const struct location *loc, struct table *table,
+			bool excl)
 {
 	struct chain *chain;
 	struct set *set;
 
-	if (netlink_add_table(ctx, h, loc, table) < 0)
+	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
 		return -1;
 	if (table != NULL) {
 		list_for_each_entry(set, &table->sets, list) {
@@ -511,22 +513,22 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		}
 		list_for_each_entry(chain, &table->chains, list) {
 			if (do_add_chain(ctx, &chain->handle, &chain->location,
-					 chain) < 0)
+					 chain, excl) < 0)
 				return -1;
 		}
 	}
 	return 0;
 }
 
-static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd)
+static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		return do_add_table(ctx, &cmd->handle, &cmd->location,
-				    cmd->table);
+				    cmd->table, excl);
 	case CMD_OBJ_CHAIN:
 		return do_add_chain(ctx, &cmd->handle, &cmd->location,
-				    cmd->chain);
+				    cmd->chain, excl);
 	case CMD_OBJ_RULE:
 		return netlink_add_rule_batch(ctx, &cmd->handle,
 					      cmd->rule, NLM_F_APPEND);
@@ -726,7 +728,9 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->op) {
 	case CMD_ADD:
-		return do_command_add(ctx, cmd);
+		return do_command_add(ctx, cmd, false);
+	case CMD_CREATE:
+		return do_command_add(ctx, cmd, true);
 	case CMD_INSERT:
 		return do_command_insert(ctx, cmd);
 	case CMD_DELETE:
diff --git a/src/scanner.l b/src/scanner.l
index a0ca7d7..f133f23 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -249,6 +249,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "inet"			{ return INET; }
 
 "add"			{ return ADD; }
+"create"		{ return CREATE; }
 "insert"		{ return INSERT; }
 "delete"		{ return DELETE; }
 "list"			{ return LIST; }
-- 
1.8.4.2

