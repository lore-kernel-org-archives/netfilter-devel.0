Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C4EC31E57
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 12:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81EA020657
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 12:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfFQMZ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 08:25:27 -0400
Received: from mail.us.es ([193.147.175.20]:46282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfFQMZ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 08:25:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A4CA5C1D46
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 14:25:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 928E6DA711
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 14:25:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87AC1DA703; Mon, 17 Jun 2019 14:25:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61CC8DA703;
        Mon, 17 Jun 2019 14:25:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 14:25:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 387724265A2F;
        Mon, 17 Jun 2019 14:25:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 1/5] src: remove useless parameter from cache_flush()
Date:   Mon, 17 Jun 2019 14:25:14 +0200
Message-Id: <20190617122518.10486-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Command type is never used in cache_flush().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 3 +--
 src/evaluate.c | 2 +-
 src/rule.c     | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index b41825d000d6..299485ffeeaa 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -639,8 +639,7 @@ extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 extern int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
 extern int cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
 			struct list_head *msgs);
-extern void cache_flush(struct nft_ctx *ctx, enum cmd_ops cmd,
-			struct list_head *msgs);
+extern void cache_flush(struct nft_ctx *ctx, struct list_head *msgs);
 extern void cache_release(struct nft_cache *cache);
 extern bool cache_is_complete(struct nft_cache *cache, enum cmd_ops cmd);
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 70c7e597f3b0..73a4be339ce1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3682,7 +3682,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
-		cache_flush(ctx->nft, cmd->op, ctx->msgs);
+		cache_flush(ctx->nft, ctx->msgs);
 		break;
 	case CMD_OBJ_TABLE:
 		/* Flushing a table does not empty the sets in the table nor remove
diff --git a/src/rule.c b/src/rule.c
index 0c0fd07ec70c..4407b0b0ceaa 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -297,7 +297,7 @@ static void __cache_flush(struct list_head *table_list)
 	}
 }
 
-void cache_flush(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
+void cache_flush(struct nft_ctx *nft, struct list_head *msgs)
 {
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
-- 
2.11.0

