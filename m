Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B4CC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jul 2022 15:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiGRPCc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbiGRPCb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Jul 2022 11:02:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CA5124969
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2022 08:02:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] cache: prepare nft_cache_evaluate() to return error
Date:   Mon, 18 Jul 2022 17:02:26 +0200
Message-Id: <20220718150227.506532-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move flags as parameter reference and add list of error messages to prepare
for sanity checks.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h   | 5 +++--
 src/cache.c       | 8 +++++---
 src/libnftables.c | 5 ++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index b6c7d48bfba6..575381ef971b 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -65,8 +65,9 @@ struct nft_cache_filter {
 struct nft_cache;
 enum cmd_ops;
 
-unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
-				struct nft_cache_filter *filter);
+int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
+		       struct list_head *msgs, struct nft_cache_filter *filter,
+		       unsigned int *flags);
 int nft_cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
 		     struct list_head *msgs,
 		     const struct nft_cache_filter *filter);
diff --git a/src/cache.c b/src/cache.c
index b6ae2310b175..9e2fe950a884 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -262,8 +262,9 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	return flags;
 }
 
-unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
-				struct nft_cache_filter *filter)
+int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
+		       struct list_head *msgs, struct nft_cache_filter *filter,
+		       unsigned int *pflags)
 {
 	unsigned int flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
@@ -318,8 +319,9 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			break;
 		}
 	}
+	*pflags = flags;
 
-	return flags;
+	return 0;
 }
 
 void table_cache_add(struct table *table, struct nft_cache *cache)
diff --git a/src/libnftables.c b/src/libnftables.c
index f2a1ef04e80b..a376825d7309 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -506,7 +506,10 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	int err = 0;
 
 	filter = nft_cache_filter_init();
-	flags = nft_cache_evaluate(nft, cmds, filter);
+	if (nft_cache_evaluate(nft, cmds, msgs, filter, &flags) < 0) {
+		nft_cache_filter_fini(filter);
+		return -1;
+	}
 	if (nft_cache_update(nft, flags, msgs, filter) < 0) {
 		nft_cache_filter_fini(filter);
 		return -1;
-- 
2.30.2

