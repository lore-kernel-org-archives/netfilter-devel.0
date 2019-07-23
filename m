Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90665C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644EE22543
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfGWNgq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 09:36:46 -0400
Received: from mail.us.es ([193.147.175.20]:38210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfGWNgp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 09:36:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21A2569653
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 15:36:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DFA7FF6CC
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 15:36:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 03BE16DA95; Tue, 23 Jul 2019 15:36:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5CA9DA704;
        Tue, 23 Jul 2019 15:36:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 15:36:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.183.64])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 458724265A31;
        Tue, 23 Jul 2019 15:36:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft] cache: add NFT_CACHE_UPDATE and NFT_CACHE_FLUSHED flags
Date:   Tue, 23 Jul 2019 15:36:36 +0200
Message-Id: <20190723133636.18814-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NFT_CACHE_FLUSHED tells cache_update() that dumping kernel content is
not required, since any previous ruleset is going to flush in this
batch.

NFT_CACHE_UPDATE tells rule_evaluate() to perform incremental updates to
the cache based on the existing batch.

cache_flush() is not required anymore in this approach, this call is
coming too late, in the evaluation phase, after the cache_update()
invocation.

Be careful with NFT_CACHE_UPDATE, this flags needs to be left it in
place if NFT_CACHE_FLUSHED is set on.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |  2 ++
 include/rule.h  |  3 +--
 src/cache.c     |  4 +++-
 src/evaluate.c  |  8 +++-----
 src/rule.c      | 33 ++++++++++++++++-----------------
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index d3502a8a6039..86a7eff78055 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -30,6 +30,8 @@ enum cache_level_flags {
 				  NFT_CACHE_CHAIN_BIT |
 				  NFT_CACHE_RULE_BIT,
 	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
+	NFT_CACHE_UPDATE	= (1 << 30),
+	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/rule.h b/include/rule.h
index 67c3d3314953..ee881b9ccd17 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -679,9 +679,8 @@ extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 extern unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
 extern int cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
 			struct list_head *msgs);
-extern void cache_flush(struct nft_ctx *ctx, struct list_head *msgs);
+extern bool cache_needs_update(struct nft_cache *cache);
 extern void cache_release(struct nft_cache *cache);
-extern bool cache_is_complete(struct nft_cache *cache, enum cmd_ops cmd);
 
 struct timeout_protocol {
 	uint32_t array_size;
diff --git a/src/cache.c b/src/cache.c
index e04ead85c830..0d38034e853f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -41,7 +41,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 
 		if (cmd->handle.index.id ||
 		    cmd->handle.position.id)
-			flags |= NFT_CACHE_RULE;
+			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;
 		break;
 	default:
 		break;
@@ -72,6 +72,8 @@ static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
 		flags |= NFT_CACHE_SET;
 		break;
 	case CMD_OBJ_RULESET:
+		flags |= NFT_CACHE_FLUSHED;
+		break;
 	default:
 		flags = NFT_CACHE_EMPTY;
 		break;
diff --git a/src/evaluate.c b/src/evaluate.c
index e7f16ba6461b..48c65cd2f35a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3394,11 +3394,10 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 		return -1;
 	}
 
-	/* add rules to cache only if it is complete enough to contain them */
-	if (!cache_is_complete(&ctx->nft->cache, NFT_CACHE_RULE))
-		return 0;
+	if (cache_needs_update(&ctx->nft->cache))
+		return rule_cache_update(ctx, op);
 
-	return rule_cache_update(ctx, op);
+	return 0;
 }
 
 static uint32_t str2hooknum(uint32_t family, const char *hook)
@@ -3824,7 +3823,6 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
-		cache_flush(ctx->nft, ctx->msgs);
 		break;
 	case CMD_OBJ_TABLE:
 		/* Flushing a table does not empty the sets in the table nor remove
diff --git a/src/rule.c b/src/rule.c
index 0ebe91e79a03..293606576044 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -224,7 +224,7 @@ static int cache_init(struct netlink_ctx *ctx, unsigned int flags)
 	return 0;
 }
 
-bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
+static bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
 {
 	return (cache->flags & flags) == flags;
 }
@@ -234,6 +234,11 @@ static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
 	return genid && genid == cache->genid;
 }
 
+bool cache_needs_update(struct nft_cache *cache)
+{
+	return cache->flags & NFT_CACHE_UPDATE;
+}
+
 int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs)
 {
 	struct netlink_ctx ctx = {
@@ -242,7 +247,7 @@ int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs
 		.msgs		= msgs,
 	};
 	struct nft_cache *cache = &nft->cache;
-	uint32_t genid, genid_stop;
+	uint32_t genid, genid_stop, oldflags;
 	int ret;
 replay:
 	ctx.seqnum = cache->seqnum++;
@@ -254,6 +259,14 @@ replay:
 	if (cache->genid)
 		cache_release(cache);
 
+	if (flags & NFT_CACHE_FLUSHED) {
+		oldflags = flags;
+		flags = NFT_CACHE_EMPTY;
+		if (oldflags & NFT_CACHE_UPDATE)
+			flags |= NFT_CACHE_UPDATE;
+		goto skip;
+	}
+
 	ret = cache_init(&ctx, flags);
 	if (ret < 0) {
 		cache_release(cache);
@@ -269,7 +282,7 @@ replay:
 		cache_release(cache);
 		goto replay;
 	}
-
+skip:
 	cache->genid = genid;
 	cache->flags = flags;
 	return 0;
@@ -285,20 +298,6 @@ static void __cache_flush(struct list_head *table_list)
 	}
 }
 
-void cache_flush(struct nft_ctx *nft, struct list_head *msgs)
-{
-	struct netlink_ctx ctx = {
-		.list		= LIST_HEAD_INIT(ctx.list),
-		.nft		= nft,
-		.msgs		= msgs,
-	};
-	struct nft_cache *cache = &nft->cache;
-
-	__cache_flush(&cache->list);
-	cache->genid = mnl_genid_get(&ctx);
-	cache->flags = NFT_CACHE_FULL;
-}
-
 void cache_release(struct nft_cache *cache)
 {
 	__cache_flush(&cache->list);
-- 
2.11.0

