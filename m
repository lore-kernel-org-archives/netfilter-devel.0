Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F5AC47082
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Jun 2021 23:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ACBF6124C
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Jun 2021 23:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFEX3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Jun 2021 19:29:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50654 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFEX3i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Jun 2021 19:29:38 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 84B8163E3D
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Jun 2021 01:26:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] rule: rework CMD_OBJ_SETELEMS logic
Date:   Sun,  6 Jun 2021 01:27:45 +0200
Message-Id: <20210605232745.8395-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not clone the set and zap the elements during the set and map
expansion to the CMD_OBJ_SETELEMS command.

Instead, update the CMD_OBJ_SET command to add the set to the kernel
(without elements) and let CMD_OBJ_SETELEMS add the elements. The
CMD_OBJ_SET command calls set_to_intervals() to update set->init->size
(NFTNL_SET_DESC_SIZE) before adding the set to the kernel. Updating the
set size from do_add_setelems() comes too late, it might result in
spurious ENFILE errors for interval sets.

Moreover, skip CMD_OBJ_SETELEMS if the set definition specifies no
elements.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1500
Fixes: c9eae091983a ("src: add CMD_OBJ_SETELEMS")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index dcf1646a9c7c..8e426c5f2fdd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1286,11 +1286,11 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
-	struct set *set, *newset;
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
 	struct rule *rule;
+	struct set *set;
 	struct obj *obj;
 	struct cmd *new;
 	struct handle h;
@@ -1356,14 +1356,13 @@ void nft_cmd_expand(struct cmd *cmd)
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
+		if (!set->init)
+			break;
+
 		memset(&h, 0, sizeof(h));
 		handle_merge(&h, &set->handle);
-		newset = set_clone(set);
-		newset->handle.set_id = set->handle.set_id;
-		newset->init = set->init;
-		set->init = NULL;
 		new = cmd_alloc(CMD_ADD, CMD_OBJ_SETELEMS, &h,
-				&set->location, newset);
+				&set->location, set_get(set));
 		list_add(&new->list, &cmd->list);
 		break;
 	default:
@@ -1461,7 +1460,7 @@ void cmd_free(struct cmd *cmd)
 #include <netlink.h>
 #include <mnl.h>
 
-static int __do_add_setelems(struct netlink_ctx *ctx, struct set *set,
+static int __do_add_elements(struct netlink_ctx *ctx, struct set *set,
 			     struct expr *expr, uint32_t flags)
 {
 	expr->set_flags |= set->flags;
@@ -1481,7 +1480,7 @@ static int __do_add_setelems(struct netlink_ctx *ctx, struct set *set,
 	return 0;
 }
 
-static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
+static int do_add_elements(struct netlink_ctx *ctx, struct cmd *cmd,
 			   uint32_t flags)
 {
 	struct expr *init = cmd->expr;
@@ -1493,27 +1492,35 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 			     &ctx->nft->output) < 0)
 		return -1;
 
-	return __do_add_setelems(ctx, set, init, flags);
+	return __do_add_elements(ctx, set, init, flags);
+}
+
+static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
+			   uint32_t flags)
+{
+	struct set *set = cmd->set;
+
+	return __do_add_elements(ctx, set, set->init, flags);
 }
 
 static int do_add_set(struct netlink_ctx *ctx, struct cmd *cmd,
-		      uint32_t flags, bool add)
+		      uint32_t flags)
 {
 	struct set *set = cmd->set;
 
 	if (set->init != NULL) {
+		/* Update set->init->size (NFTNL_SET_DESC_SIZE) before adding
+		 * the set to the kernel. Calling this from do_add_setelems()
+		 * comes too late which might result in spurious ENFILE errors.
+		 */
 		if (set_is_non_concat_range(set) &&
 		    set_to_intervals(ctx->msgs, set, set->init, true,
 				     ctx->nft->debug_mask, set->automerge,
 				     &ctx->nft->output) < 0)
 			return -1;
 	}
-	if (add && mnl_nft_set_add(ctx, cmd, flags) < 0)
-		return -1;
-	if (set->init != NULL) {
-		return __do_add_setelems(ctx, set, set->init, flags);
-	}
-	return 0;
+
+	return mnl_nft_set_add(ctx, cmd, flags);
 }
 
 static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
@@ -1531,11 +1538,11 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_RULE:
 		return mnl_nft_rule_add(ctx, cmd, flags | NLM_F_APPEND);
 	case CMD_OBJ_SET:
-		return do_add_set(ctx, cmd, flags, true);
+		return do_add_set(ctx, cmd, flags);
 	case CMD_OBJ_SETELEMS:
-		return do_add_set(ctx, cmd, flags, false);
-	case CMD_OBJ_ELEMENTS:
 		return do_add_setelems(ctx, cmd, flags);
+	case CMD_OBJ_ELEMENTS:
+		return do_add_elements(ctx, cmd, flags);
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
-- 
2.20.1

