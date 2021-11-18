Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1819DC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 16:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6AD4610CA
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 16:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhKRQdA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 11:33:00 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49108 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhKRQc7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 11:32:59 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 822AD64B8C
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 17:27:51 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: do not skip populating anonymous set with -t
Date:   Thu, 18 Nov 2021 17:29:49 +0100
Message-Id: <20211118162949.190333-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--terse does not apply to anonymous set, add a NFT_CACHE_TERSE bit
to skip named sets only.

Fixes: 9628d52e46ac ("cache: disable NFT_CACHE_SETELEM_BIT on --terse listing only")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h | 1 +
 src/cache.c     | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index e5c509e8510c..3a9a5e819711 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -32,6 +32,7 @@ enum cache_level_flags {
 				  NFT_CACHE_CHAIN_BIT |
 				  NFT_CACHE_RULE_BIT,
 	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
+	NFT_CACHE_TERSE		= (1 << 27),
 	NFT_CACHE_SETELEM_MAYBE	= (1 << 28),
 	NFT_CACHE_REFRESH	= (1 << 29),
 	NFT_CACHE_UPDATE	= (1 << 30),
diff --git a/src/cache.c b/src/cache.c
index fe31e3f02163..9f5980bc25cb 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -216,7 +216,7 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 			filter->list.set = cmd->handle.set.name;
 		}
 		if (nft_output_terse(&nft->output))
-			flags |= (NFT_CACHE_FULL & ~NFT_CACHE_SETELEM_BIT);
+			flags |= (NFT_CACHE_FULL | NFT_CACHE_TERSE);
 		else if (filter->list.table && filter->list.set)
 			flags |= NFT_CACHE_TABLE | NFT_CACHE_SET | NFT_CACHE_SETELEM;
 		else
@@ -234,7 +234,7 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 		break;
 	case CMD_OBJ_RULESET:
 		if (nft_output_terse(&nft->output))
-			flags |= (NFT_CACHE_FULL & ~NFT_CACHE_SETELEM_BIT);
+			flags |= (NFT_CACHE_FULL | NFT_CACHE_TERSE);
 		else
 			flags |= NFT_CACHE_FULL;
 		break;
@@ -830,6 +830,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
 				if (cache_filter_find(filter, &set->handle))
 					continue;
+				if (!set_is_anonymous(set->flags) &&
+				    flags & NFT_CACHE_TERSE)
+					continue;
 
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
-- 
2.30.2

