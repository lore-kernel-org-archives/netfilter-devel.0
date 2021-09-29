Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31169C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 11:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFBB60FC2
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 11:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245614AbhI2Lfe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Sep 2021 07:35:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60644 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhI2Lfe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Sep 2021 07:35:34 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4CA6063EC2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 13:32:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] cache: finer grain cache population for list commands
Date:   Wed, 29 Sep 2021 13:33:47 +0200
Message-Id: <20210929113348.531501-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip full cache population for list commands to speed up listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 544f64a20396..a0898a976e88 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -127,6 +127,27 @@ static unsigned int evaluate_cache_rename(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
+static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_CHAINS:
+		flags |= NFT_CACHE_TABLE | NFT_CACHE_CHAIN;
+		break;
+	case CMD_OBJ_SETS:
+	case CMD_OBJ_MAPS:
+		flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
+		break;
+	case CMD_OBJ_FLOWTABLES:
+		flags |= NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE;
+		break;
+	default:
+		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+		break;
+	}
+
+	return flags;
+}
+
 unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 {
 	unsigned int flags = NFT_CACHE_EMPTY;
@@ -160,8 +181,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 			flags |= NFT_CACHE_TABLE;
 			break;
 		case CMD_LIST:
-		case CMD_EXPORT:
-			flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+			flags |= evaluate_cache_list(cmd, flags);
 			break;
 		case CMD_MONITOR:
 			flags |= NFT_CACHE_FULL;
@@ -174,6 +194,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 			break;
 		case CMD_DESCRIBE:
 		case CMD_IMPORT:
+		case CMD_EXPORT:
 			break;
 		default:
 			break;
-- 
2.30.2

