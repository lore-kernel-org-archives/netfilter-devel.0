Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B89AC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Nov 2021 10:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F38AB611BF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Nov 2021 10:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbhKIKID (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 05:08:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50074 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238163AbhKIKID (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 05:08:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1D958606AE
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Nov 2021 11:03:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/2] cache: do not populate cache if it is going to be flushed
Date:   Tue,  9 Nov 2021 11:05:11 +0100
Message-Id: <20211109100511.265682-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109100511.265682-1-pablo@netfilter.org>
References: <20211109100511.265682-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip set element netlink dump if set is flushed, this speeds up
set flush + add element operation in a batch file for an existing set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use a hashtable.

 include/cache.h | 14 +++++++++++--
 src/cache.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 7d61701a02b5..33c9ab66905b 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -38,11 +38,23 @@ enum cache_level_flags {
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
+struct nft_filter_obj {
+	struct list_head list;
+	const char	*table;
+	const char	*set;
+};
+
+#define NFT_CACHE_HSIZE	8192
+
 struct nft_cache_filter {
 	struct {
 		const char	*table;
 		const char	*set;
 	} list;
+
+	struct {
+		struct list_head head;
+	} obj[NFT_CACHE_HSIZE];
 };
 
 struct nft_cache;
@@ -66,8 +78,6 @@ static inline uint32_t djb_hash(const char *key)
 	return hash;
 }
 
-#define NFT_CACHE_HSIZE 8192
-
 struct table;
 struct chain;
 
diff --git a/src/cache.c b/src/cache.c
index 58397551aafc..e86a2d867f55 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -96,13 +96,46 @@ static unsigned int evaluate_cache_get(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
-static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
+static void cache_filter_add(struct nft_cache_filter *filter,
+			     const struct cmd *cmd)
+{
+	struct nft_filter_obj *obj;
+	uint32_t hash;
+
+	obj = xmalloc(sizeof(struct nft_filter_obj));
+	obj->table = cmd->handle.table.name;
+	obj->set = cmd->handle.set.name;
+
+	hash = djb_hash(cmd->handle.set.name) % NFT_CACHE_HSIZE;
+	list_add_tail(&obj->list, &filter->obj[hash].head);
+}
+
+static bool cache_filter_find(const struct nft_cache_filter *filter,
+			      const struct handle *handle)
+{
+	struct nft_filter_obj *obj;
+	uint32_t hash;
+
+	hash = djb_hash(handle->set.name) % NFT_CACHE_HSIZE;
+
+	list_for_each_entry(obj, &filter->obj[hash].head, list) {
+		if (!strcmp(obj->table, handle->table.name) &&
+		    !strcmp(obj->set, handle->set.name))
+			return true;
+	}
+
+	return false;
+}
+
+static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags,
+					 struct nft_cache_filter *filter)
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 	case CMD_OBJ_METER:
 		flags |= NFT_CACHE_SET;
+		cache_filter_add(filter, cmd);
 		break;
 	case CMD_OBJ_RULESET:
 		flags |= NFT_CACHE_FLUSHED;
@@ -181,6 +214,10 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 {
 	unsigned int flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
+	int i;
+
+	for (i = 0; i < NFT_CACHE_HSIZE; i++)
+		init_list_head(&filter->obj[i].head);
 
 	list_for_each_entry(cmd, cmds, list) {
 		if (filter->list.table && cmd->op != CMD_LIST)
@@ -219,7 +256,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags |= NFT_CACHE_FULL;
 			break;
 		case CMD_FLUSH:
-			flags = evaluate_cache_flush(cmd, flags);
+			flags = evaluate_cache_flush(cmd, flags, filter);
 			break;
 		case CMD_RENAME:
 			flags = evaluate_cache_rename(cmd, flags);
@@ -659,7 +696,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	struct table *table;
 	struct chain *chain;
 	struct set *set;
-	int ret = 0;
+	int ret = 0, i;
 
 	if (flags & NFT_CACHE_CHAIN_BIT) {
 		chain_list = chain_cache_dump(ctx, &ret);
@@ -685,6 +722,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
+				if (cache_filter_find(filter, &set->handle))
+					continue;
+
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
 				if (ret < 0) {
@@ -694,6 +734,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			}
 		} else if (flags & NFT_CACHE_SETELEM_MAYBE) {
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
+				if (cache_filter_find(filter, &set->handle))
+					continue;
+
 				if (!set_is_non_concat_range(set))
 					continue;
 
@@ -765,6 +808,13 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	}
 
 cache_fails:
+	for (i = 0; i < NFT_CACHE_HSIZE; i++) {
+		struct nft_filter_obj *obj, *next;
+
+		list_for_each_entry_safe(obj, next, &filter->obj[i].head, list)
+			xfree(obj);
+	}
+
 	if (flags & NFT_CACHE_CHAIN_BIT)
 		nftnl_chain_list_free(chain_list);
 
-- 
2.30.2

