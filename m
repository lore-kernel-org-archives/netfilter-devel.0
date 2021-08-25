Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA25C432BE
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 14:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A51610C8
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 14:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbhHYOfV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 10:35:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52514 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhHYOfU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 10:35:20 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 134036011E
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 16:33:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: provide a empty list for flowtables and objects when request fails
Date:   Wed, 25 Aug 2021 16:34:28 +0200
Message-Id: <20210825143428.15622-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Old kernels do not support for dumping the flowtable and object lists,
provide an empty list instead to unbreak the cache initialization.

Fixes: 560963c4d41e ("cache: add hashtable cache for flowtable")
Fixes: 45a84088ecbd ("cache: add hashtable cache for object")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 8300ce8e707a..15eb4522eb75 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -415,8 +415,7 @@ static int obj_cache_init(struct netlink_ctx *ctx, struct table *table,
 }
 
 static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
-					     const struct table *table,
-					     int *err)
+					     const struct table *table)
 {
 	struct nftnl_obj_list *obj_list;
 
@@ -424,12 +423,15 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
 				    table->handle.table.name, NULL,
 				    0, true, false);
 	if (!obj_list) {
-                if (errno == EINTR) {
-			*err = -1;
+                if (errno == EINTR)
 			return NULL;
-		}
-		*err = 0;
-		return NULL;
+
+		/* old kernels do not support this, provide an empty list. */
+		obj_list = nftnl_obj_list_alloc();
+		if (!obj_list)
+	                memory_allocation_error();
+
+		return obj_list;
 	}
 
 	return obj_list;
@@ -500,20 +502,22 @@ static int ft_cache_init(struct netlink_ctx *ctx, struct table *table,
 }
 
 static struct nftnl_flowtable_list *ft_cache_dump(struct netlink_ctx *ctx,
-						  const struct table *table,
-						  int *err)
+						  const struct table *table)
 {
 	struct nftnl_flowtable_list *ft_list;
 
 	ft_list = mnl_nft_flowtable_dump(ctx, table->handle.family,
 					 table->handle.table.name);
 	if (!ft_list) {
-                if (errno == EINTR) {
-			*err = -1;
+                if (errno == EINTR)
 			return NULL;
-		}
-		*err = 0;
-		return NULL;
+
+		/* old kernels do not support this, provide an empty list. */
+		ft_list = nftnl_flowtable_list_alloc();
+		if (!ft_list)
+	                memory_allocation_error();
+
+		return ft_list;
 	}
 
 	return ft_list;
@@ -628,11 +632,12 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			}
 		}
 		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
-			ft_list = ft_cache_dump(ctx, table, &ret);
+			ft_list = ft_cache_dump(ctx, table);
 			if (!ft_list) {
 				ret = -1;
 				goto cache_fails;
 			}
+
 			ret = ft_cache_init(ctx, table, ft_list);
 
 			nftnl_flowtable_list_free(ft_list);
@@ -643,11 +648,12 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			}
 		}
 		if (flags & NFT_CACHE_OBJECT_BIT) {
-			obj_list = obj_cache_dump(ctx, table, &ret);
+			obj_list = obj_cache_dump(ctx, table);
 			if (!obj_list) {
 				ret = -1;
 				goto cache_fails;
 			}
+
 			ret = obj_cache_init(ctx, table, obj_list);
 
 			nftnl_obj_list_free(obj_list);
-- 
2.20.1

