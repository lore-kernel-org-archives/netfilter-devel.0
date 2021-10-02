Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84FBC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 11:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F6861AED
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 11:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhJBLww (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 07:52:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45364 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhJBLwv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 07:52:51 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4101263586
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Oct 2021 13:49:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: unset NFT_CACHE_SETELEM with --terse listing
Date:   Sat,  2 Oct 2021 13:50:59 +0200
Message-Id: <20211002115059.26792-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip populating the set element cache in this case to speed up listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 584328ebc5e7..c602f93a3ec6 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -127,7 +127,8 @@ static unsigned int evaluate_cache_rename(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
-static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags,
+static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
+					unsigned int flags,
 					struct nft_cache_filter *filter)
 {
 	switch (cmd->obj) {
@@ -143,7 +144,10 @@ static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags,
 			filter->table = cmd->handle.table.name;
 			filter->set = cmd->handle.set.name;
 		}
-		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+		if (nft_output_terse(&nft->output))
+			flags |= (NFT_CACHE_FULL & ~NFT_CACHE_SETELEM) | NFT_CACHE_REFRESH;
+		else
+			flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
 		break;
 	case CMD_OBJ_CHAINS:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_CHAIN;
@@ -155,6 +159,11 @@ static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags,
 	case CMD_OBJ_FLOWTABLES:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE;
 		break;
+	case CMD_OBJ_RULESET:
+		if (nft_output_terse(&nft->output))
+			flags |= (NFT_CACHE_FULL & ~NFT_CACHE_SETELEM) | NFT_CACHE_REFRESH;
+		else
+			flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
 	default:
 		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
 		break;
@@ -200,7 +209,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags |= NFT_CACHE_TABLE;
 			break;
 		case CMD_LIST:
-			flags |= evaluate_cache_list(cmd, flags, filter);
+			flags |= evaluate_cache_list(nft, cmd, flags, filter);
 			break;
 		case CMD_MONITOR:
 			flags |= NFT_CACHE_FULL;
-- 
2.30.2

