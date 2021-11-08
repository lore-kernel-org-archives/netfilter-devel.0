Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F932C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 18:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 578D0613B3
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 18:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhKHSYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:24:22 -0500
Received: from mail.netfilter.org ([217.70.188.207]:48110 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbhKHSYW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 13:24:22 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 87A7460831
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 19:19:38 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: do not populate cache if it is going to be flushed
Date:   Mon,  8 Nov 2021 19:21:31 +0100
Message-Id: <20211108182131.246466-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip set element netlink dump if set is flushed, this speeds up
set flush + add element operation in a batch file for an existing set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h | 13 +++++++++++--
 src/cache.c     | 40 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 0523358889de..f3572319c451 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -38,9 +38,18 @@ enum cache_level_flags {
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
+#define NFT_CACHE_MAX_FILTER		12
+
 struct nft_cache_filter {
-	const char		*table;
-	const char		*set;
+	const char			*table;
+	const char			*set;
+
+	struct {
+		const char		*table;
+		const char		*set;
+	} obj[NFT_CACHE_MAX_FILTER];
+
+	unsigned int			num_objs;
 };
 
 struct nft_cache;
diff --git a/src/cache.c b/src/cache.c
index 0cddd1e1cb48..08f6ca700263 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -96,13 +96,43 @@ static unsigned int evaluate_cache_get(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
-static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
+static void cache_filter_add(struct nft_cache_filter *filter,
+			     const struct cmd *cmd)
+{
+	int i;
+
+	if (filter->num_objs >= NFT_CACHE_MAX_FILTER)
+		return;
+
+	i = filter->num_objs;
+	filter->obj[i].table = cmd->handle.table.name;
+	filter->obj[i].set = cmd->handle.set.name;
+	filter->num_objs++;
+}
+
+static bool cache_filter_find(const struct nft_cache_filter *filter,
+			      const struct handle *handle)
+{
+	unsigned int i;
+
+	for (i = 0; i < filter->num_objs; i++) {
+		if (!strcmp(filter->obj[i].table, handle->table.name) &&
+		    !strcmp(filter->obj[i].set, handle->set.name))
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
@@ -219,7 +249,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags |= NFT_CACHE_FULL;
 			break;
 		case CMD_FLUSH:
-			flags = evaluate_cache_flush(cmd, flags);
+			flags = evaluate_cache_flush(cmd, flags, filter);
 			break;
 		case CMD_RENAME:
 			flags = evaluate_cache_rename(cmd, flags);
@@ -685,6 +715,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
+				if (cache_filter_find(filter, &set->handle))
+					continue;
+
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
 				if (ret < 0) {
@@ -694,6 +727,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			}
 		} else if (flags & NFT_CACHE_SETELEM_MAYBE) {
 			list_for_each_entry(set, &table->set_cache.list, cache.list) {
+				if (cache_filter_find(filter, &set->handle))
+					continue;
+
 				if (!set_is_non_concat_range(set))
 					continue;
 
-- 
2.30.2

