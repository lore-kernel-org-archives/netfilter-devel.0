Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2612C0015E
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 19:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjG1TE0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjG1TEZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 15:04:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C28B30F5
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:04:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qPSlC-0004hZ-4Z; Fri, 28 Jul 2023 21:04:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] ct expectation: fix 'list object x' vs. 'list objects in table' confusion
Date:   Fri, 28 Jul 2023 21:04:13 +0200
Message-ID: <20230728190418.132828-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just like "ct timeout", "ct expectation" is in need of the same fix,
we get segfault on "nft list ct expectation table t", if table t exists.

This is the exact same pattern as resolved for "ct timeout" in commit
1d2e22fc0521 ("ct timeout: fix 'list object x' vs. 'list objects in table' confusion").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h     | 1 +
 src/cache.c        | 1 +
 src/evaluate.c     | 1 +
 src/parser_bison.y | 2 +-
 src/rule.c         | 1 +
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index 5cb549c2e14e..13ab1bf3df5a 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -649,6 +649,7 @@ enum cmd_obj {
 	CMD_OBJ_SECMARK,
 	CMD_OBJ_SECMARKS,
 	CMD_OBJ_CT_EXPECT,
+	CMD_OBJ_CT_EXPECTATIONS,
 	CMD_OBJ_SYNPROXY,
 	CMD_OBJ_SYNPROXYS,
 	CMD_OBJ_HOOKS,
diff --git a/src/cache.c b/src/cache.c
index 5cab2622db95..b6a7e194771a 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -377,6 +377,7 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 	case CMD_OBJ_CT_TIMEOUT:
 	case CMD_OBJ_CT_TIMEOUTS:
 	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_CT_EXPECTATIONS:
 		if (h->table.name &&
 		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
 			loc = &h->table.location;
diff --git a/src/evaluate.c b/src/evaluate.c
index 33e4ac93e89a..8fc1ca7e4b4f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5425,6 +5425,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARKS:
 	case CMD_OBJ_SYNPROXYS:
 	case CMD_OBJ_CT_TIMEOUTS:
+	case CMD_OBJ_CT_EXPECTATIONS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (!table_cache_find(&ctx->nft->cache.table_cache,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2d7538d840be..9593de00bd96 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4777,7 +4777,7 @@ ct_obj_type		:	HELPER		{ $$ = NFT_OBJECT_CT_HELPER; }
 
 ct_cmd_type		:	HELPERS		{ $$ = CMD_OBJ_CT_HELPERS; }
 			|	TIMEOUT		{ $$ = CMD_OBJ_CT_TIMEOUTS; }
-			|	EXPECTATION	{ $$ = CMD_OBJ_CT_EXPECT; }
+			|	EXPECTATION	{ $$ = CMD_OBJ_CT_EXPECTATIONS; }
 			;
 
 ct_l4protoname		:	TCP	close_scope_tcp	{ $$ = IPPROTO_TCP; }
diff --git a/src/rule.c b/src/rule.c
index 08841902fef4..99c4f0bb8b00 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2363,6 +2363,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_TIMEOUTS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
 	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_CT_EXPECTATIONS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_LIMITS:
-- 
2.41.0

