Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A437C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 00:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343931AbiALAeP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:34:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47922 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347259AbiALAeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 19:34:14 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 02A8C64285
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2022 01:31:21 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] cache: do not set error code twice
Date:   Wed, 12 Jan 2022 01:33:59 +0100
Message-Id: <20220112003401.332999-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220112003401.332999-1-pablo@netfilter.org>
References: <20220112003401.332999-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'ret' variable is already set to a negative value to report an
error, do not set it again to a negative value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 6ca6bbc6645b..0e9e7fe5381d 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -847,10 +847,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (flags & NFT_CACHE_SET_BIT) {
 			ret = set_cache_init(ctx, table, set_list);
-			if (ret < 0) {
-				ret = -1;
+			if (ret < 0)
 				goto cache_fails;
-			}
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
@@ -862,10 +860,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
-				if (ret < 0) {
-					ret = -1;
+				if (ret < 0)
 					goto cache_fails;
-				}
 			}
 		} else if (flags & NFT_CACHE_SETELEM_MAYBE) {
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
@@ -877,25 +873,19 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
-				if (ret < 0) {
-					ret = -1;
+				if (ret < 0)
 					goto cache_fails;
-				}
 			}
 		}
 		if (flags & NFT_CACHE_CHAIN_BIT) {
 			ret = chain_cache_init(ctx, table, chain_list);
-			if (ret < 0) {
-				ret = -1;
+			if (ret < 0)
 				goto cache_fails;
-			}
 		}
 		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
 			ret = ft_cache_init(ctx, table, ft_list);
-			if (ret < 0) {
-				ret = -1;
+			if (ret < 0)
 				goto cache_fails;
-			}
 		}
 		if (flags & NFT_CACHE_OBJECT_BIT) {
 			obj_list = obj_cache_dump(ctx, table);
@@ -907,10 +897,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 
 			nftnl_obj_list_free(obj_list);
 
-			if (ret < 0) {
-				ret = -1;
+			if (ret < 0)
 				goto cache_fails;
-			}
 		}
 
 		if (flags & NFT_CACHE_RULE_BIT) {
@@ -927,10 +915,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 
 				list_move_tail(&rule->list, &chain->rules);
 			}
-			if (ret < 0) {
-				ret = -1;
+			if (ret < 0)
 				goto cache_fails;
-			}
 		}
 	}
 
-- 
2.30.2

