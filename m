Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBF3C05027
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Feb 2023 14:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjBFO27 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 09:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjBFO2u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 09:28:50 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17DCB244AA
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2023 06:28:45 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] rule: add helper function to expand chain rules into commands
Date:   Mon,  6 Feb 2023 15:28:40 +0100
Message-Id: <20230206142841.594538-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a helper function to expand chain rules into commands.
This comes in preparation for the follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index a58fd1f2483a..3f239cf8c46a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1310,13 +1310,31 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 	cmd->num_attrs++;
 }
 
+static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
+{
+	struct rule *rule;
+	struct handle h;
+	struct cmd *new;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &rule->handle);
+		if (chain->flags & CHAIN_F_BINDING) {
+			rule->handle.chain_id = chain->handle.chain_id;
+			rule->handle.chain.location = chain->location;
+		}
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
+				&rule->location, rule_get(rule));
+		list_add_tail(&new->list, new_cmds);
+	}
+}
+
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
-	struct rule *rule;
 	struct set *set;
 	struct obj *obj;
 	struct cmd *new;
@@ -1362,22 +1380,9 @@ void nft_cmd_expand(struct cmd *cmd)
 					&ft->location, flowtable_get(ft));
 			list_add_tail(&new->list, &new_cmds);
 		}
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry(rule, &chain->rules, list) {
-				memset(&h, 0, sizeof(h));
-				handle_merge(&h, &rule->handle);
-				if (chain->flags & CHAIN_F_BINDING) {
-					rule->handle.chain_id =
-						chain->handle.chain_id;
-					rule->handle.chain.location =
-						chain->location;
-				}
-				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-						&rule->location,
-						rule_get(rule));
-				list_add_tail(&new->list, &new_cmds);
-			}
-		}
+		list_for_each_entry(chain, &table->chains, list)
+			nft_cmd_expand_chain(chain, &new_cmds);
+
 		list_splice(&new_cmds, &cmd->list);
 		break;
 	case CMD_OBJ_SET:
-- 
2.30.2

