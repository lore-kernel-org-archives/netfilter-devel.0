Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280A2EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 20:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjFSUnn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjFSUnm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 16:43:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D434E4A
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 13:43:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qBLip-0003sB-V9; Mon, 19 Jun 2023 22:43:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/6] ct timeout: fix 'list object x' vs. 'list objects in table' confusion
Date:   Mon, 19 Jun 2023 22:43:06 +0200
Message-Id: <20230619204306.11785-7-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230619204306.11785-1-fw@strlen.de>
References: <20230619204306.11785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

<empty ruleset>
$ nft list ct timeout table t
Error: No such file or directory
list ct timeout table t
                      ^
This is expected to list all 'ct timeout' objects.
The failure is correct, the table 't' does not exist.

But now lets add one:
$ nft add table t
$ nft list ct timeout  table t
Segmentation fault (core dumped)

... and thats not expected, nothing should be shown
and nft should exit normally.

Because of missing TIMEOUTS command enum, the backend thinks
it should do an object lookup, but as frontend asked for
'list of objects' rather than 'show this object',
handle.obj.name is NULL, which then results in this crash.

Update the command enums so that backend knows what the
frontend asked for.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/rule.h     | 1 +
 src/cache.c        | 1 +
 src/evaluate.c     | 1 +
 src/parser_bison.y | 2 +-
 src/rule.c         | 1 +
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index fa3915298750..b360e2614c78 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -645,6 +645,7 @@ enum cmd_obj {
 	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
 	CMD_OBJ_CT_TIMEOUT,
+	CMD_OBJ_CT_TIMEOUTS,
 	CMD_OBJ_SECMARK,
 	CMD_OBJ_SECMARKS,
 	CMD_OBJ_CT_EXPECT,
diff --git a/src/cache.c b/src/cache.c
index becfa57fc335..d908ae0ad192 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -370,6 +370,7 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 	case CMD_OBJ_CT_HELPER:
 	case CMD_OBJ_CT_HELPERS:
 	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_TIMEOUTS:
 	case CMD_OBJ_CT_EXPECT:
 		if (h->table.name &&
 		    strlen(h->table.name) > NFT_NAME_MAXLEN) {
diff --git a/src/evaluate.c b/src/evaluate.c
index efab28952e32..687f9a7b5924 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5441,6 +5441,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_FLOWTABLES:
 	case CMD_OBJ_SECMARKS:
 	case CMD_OBJ_SYNPROXYS:
+	case CMD_OBJ_CT_TIMEOUTS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (!table_cache_find(&ctx->nft->cache.table_cache,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8a559103250e..47eb81f70aee 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4757,7 +4757,7 @@ ct_obj_type		:	HELPER		{ $$ = NFT_OBJECT_CT_HELPER; }
 			;
 
 ct_cmd_type		:	HELPERS		{ $$ = CMD_OBJ_CT_HELPERS; }
-			|	TIMEOUT		{ $$ = CMD_OBJ_CT_TIMEOUT; }
+			|	TIMEOUT		{ $$ = CMD_OBJ_CT_TIMEOUTS; }
 			|	EXPECTATION	{ $$ = CMD_OBJ_CT_EXPECT; }
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 1faa1a27f38e..3704600a87be 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2351,6 +2351,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_HELPERS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
 	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_TIMEOUTS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
 	case CMD_OBJ_CT_EXPECT:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
-- 
2.39.3

