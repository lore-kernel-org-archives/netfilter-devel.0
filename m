Return-Path: <SRS0=IXkg=6W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E202C38A2A
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 May 2020 13:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A3320870
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 May 2020 13:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgEHNRW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 May 2020 09:17:22 -0400
Received: from correo.us.es ([193.147.175.20]:35476 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbgEHMoN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 May 2020 08:44:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5742815C111
        for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2020 14:44:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49F501158F3
        for <netfilter-devel@vger.kernel.org>; Fri,  8 May 2020 14:44:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F75E1158E8; Fri,  8 May 2020 14:44:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03A4F1158E7;
        Fri,  8 May 2020 14:44:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 May 2020 14:44:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DC43B42EF4E1;
        Fri,  8 May 2020 14:44:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 1/3] src: rename CMD_OBJ_SETELEM to CMD_OBJ_ELEMENTS
Date:   Fri,  8 May 2020 14:44:01 +0200
Message-Id: <20200508124403.876-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The CMD_OBJ_ELEMENTS provides an expression that contains the list of
set elements. This leaves room to introduce CMD_OBJ_SETELEMS in a follow
up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     | 4 ++--
 src/cache.c        | 6 +++---
 src/evaluate.c     | 6 +++---
 src/parser_bison.y | 8 ++++----
 src/parser_json.c  | 2 +-
 src/rule.c         | 8 ++++----
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 1a4ec3d8bc37..f0f7ee33a3ae 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -558,7 +558,7 @@ enum cmd_ops {
  * enum cmd_obj - command objects
  *
  * @CMD_OBJ_INVALID:	invalid
- * @CMD_OBJ_SETELEM:	set element(s)
+ * @CMD_OBJ_ELEMENTS:	set element(s)
  * @CMD_OBJ_SET:	set
  * @CMD_OBJ_SETS:	multiple sets
  * @CMD_OBJ_RULE:	rule
@@ -586,7 +586,7 @@ enum cmd_ops {
  */
 enum cmd_obj {
 	CMD_OBJ_INVALID,
-	CMD_OBJ_SETELEM,
+	CMD_OBJ_ELEMENTS,
 	CMD_OBJ_SET,
 	CMD_OBJ_SETS,
 	CMD_OBJ_RULE,
diff --git a/src/cache.c b/src/cache.c
index 05f0d68edf03..a45111a7920e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -25,7 +25,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 	case CMD_OBJ_FLOWTABLE:
 		flags |= NFT_CACHE_TABLE;
 		break;
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		flags |= NFT_CACHE_TABLE |
 			 NFT_CACHE_CHAIN |
 			 NFT_CACHE_SET |
@@ -53,7 +53,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
 {
 	switch (cmd->obj) {
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		flags |= NFT_CACHE_SETELEM;
 		break;
 	default:
@@ -66,7 +66,7 @@ static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
 static unsigned int evaluate_cache_get(struct cmd *cmd, unsigned int flags)
 {
 	switch (cmd->obj) {
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		flags |= NFT_CACHE_TABLE |
 			 NFT_CACHE_SET |
 			 NFT_CACHE_SETELEM;
diff --git a/src/evaluate.c b/src/evaluate.c
index de5f60ec1f4d..4f69dfcbbc76 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3976,7 +3976,7 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 		handle_merge(&cmd->set->handle, &cmd->handle);
@@ -4008,7 +4008,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		return setelem_evaluate(ctx, &cmd->expr);
 	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
@@ -4035,7 +4035,7 @@ static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 	struct set *set;
 
 	switch (cmd->obj) {
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 39d3eac83b16..8e937ca305d1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -980,7 +980,7 @@ add_cmd			:	TABLE		table_spec
 			}
 			|	ELEMENT		set_spec	set_block_expr
 			{
-				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEM, &$2, &@$, $3);
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
 			|	FLOWTABLE	flowtable_spec	flowtable_block_alloc
 						'{'	flowtable_block	'}'
@@ -1077,7 +1077,7 @@ create_cmd		:	TABLE		table_spec
 			}
 			|	ELEMENT		set_spec	set_block_expr
 			{
-				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SETELEM, &$2, &@$, $3);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
 			|	FLOWTABLE	flowtable_spec	flowtable_block_alloc
 						'{'	flowtable_block	'}'
@@ -1169,7 +1169,7 @@ delete_cmd		:	TABLE		table_spec
 			}
 			|	ELEMENT		set_spec	set_block_expr
 			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SETELEM, &$2, &@$, $3);
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
 			|	FLOWTABLE	flowtable_spec
 			{
@@ -1227,7 +1227,7 @@ delete_cmd		:	TABLE		table_spec
 
 get_cmd			:	ELEMENT		set_spec	set_block_expr
 			{
-				$$ = cmd_alloc(CMD_GET, CMD_OBJ_SETELEM, &$2, &@$, $3);
+				$$ = cmd_alloc(CMD_GET, CMD_OBJ_ELEMENTS, &$2, &@$, $3);
 			}
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index 4468407b0ecd..c22b9c51be89 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3293,7 +3293,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "rule", CMD_OBJ_RULE, json_parse_cmd_add_rule },
 		{ "set", CMD_OBJ_SET, json_parse_cmd_add_set },
 		{ "map", CMD_OBJ_SET, json_parse_cmd_add_set },
-		{ "element", CMD_OBJ_SETELEM, json_parse_cmd_add_element },
+		{ "element", CMD_OBJ_ELEMENTS, json_parse_cmd_add_element },
 		{ "flowtable", CMD_OBJ_FLOWTABLE, json_parse_cmd_add_flowtable },
 		{ "counter", CMD_OBJ_COUNTER, json_parse_cmd_add_object },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
diff --git a/src/rule.c b/src/rule.c
index c58aa359259e..227b9f30b91d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1521,7 +1521,7 @@ void cmd_free(struct cmd *cmd)
 	handle_free(&cmd->handle);
 	if (cmd->data != NULL) {
 		switch (cmd->obj) {
-		case CMD_OBJ_SETELEM:
+		case CMD_OBJ_ELEMENTS:
 			expr_free(cmd->expr);
 			break;
 		case CMD_OBJ_SET:
@@ -1645,7 +1645,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return mnl_nft_rule_add(ctx, cmd, flags | NLM_F_APPEND);
 	case CMD_OBJ_SET:
 		return do_add_set(ctx, cmd, flags);
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		return do_add_setelems(ctx, cmd, flags);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
@@ -1724,7 +1724,7 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_rule_del(ctx, cmd);
 	case CMD_OBJ_SET:
 		return mnl_nft_set_del(ctx, cmd);
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		return do_delete_setelems(ctx, cmd);
 	case CMD_OBJ_COUNTER:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_COUNTER);
@@ -2588,7 +2588,7 @@ static int do_command_get(struct netlink_ctx *ctx, struct cmd *cmd)
 		table = table_lookup(&cmd->handle, &ctx->nft->cache);
 
 	switch (cmd->obj) {
-	case CMD_OBJ_SETELEM:
+	case CMD_OBJ_ELEMENTS:
 		return do_get_setelems(ctx, cmd, table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
-- 
2.20.1

