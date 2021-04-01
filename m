Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91210C43462
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A002610D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhDAU3g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:29:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53706 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhDAU3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 16:29:36 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DADBF63E45
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 22:29:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] cache: statify chain_cache_dump()
Date:   Thu,  1 Apr 2021 22:29:28 +0200
Message-Id: <20210401202928.5222-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210401202928.5222-1-pablo@netfilter.org>
References: <20210401202928.5222-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only used internally in cache.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h | 1 -
 src/cache.c     | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index a892b7fcdcb9..087f9ba96848 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -56,7 +56,6 @@ int cache_init(struct netlink_ctx *ctx, unsigned int flags);
 int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs);
 void cache_release(struct nft_cache *cache);
 
-struct nftnl_chain_list *chain_cache_dump(struct netlink_ctx *ctx, int *err);
 void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table,
 			       const struct handle *handle);
diff --git a/src/cache.c b/src/cache.c
index c9e1f22a3291..f7187ee7237f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -217,7 +217,8 @@ static int chain_cache_init(struct netlink_ctx *ctx, struct table *table,
 	return 0;
 }
 
-struct nftnl_chain_list *chain_cache_dump(struct netlink_ctx *ctx, int *err)
+static struct nftnl_chain_list *chain_cache_dump(struct netlink_ctx *ctx,
+						 int *err)
 {
 	struct nftnl_chain_list *chain_list;
 
-- 
2.20.1

