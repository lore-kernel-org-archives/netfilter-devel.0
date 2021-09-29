Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E44C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 11:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE86460FC2
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 11:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhI2Lff (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Sep 2021 07:35:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60646 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245602AbhI2Lfe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Sep 2021 07:35:34 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 650C863EC9
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 13:32:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] cache: filter out tables that are not requested
Date:   Wed, 29 Sep 2021 13:33:48 +0200
Message-Id: <20210929113348.531501-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929113348.531501-1-pablo@netfilter.org>
References: <20210929113348.531501-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not fetch table content for list commands that specify a
table name, e.g.

 # nft list table filter

This speeds up listing of a given table by not populating the
cache with tables that are not needed.

 - Full ruleset (huge with ~100k lines).

 # sudo nft list ruleset &> /dev/null
 real    0m3,049s
 user    0m2,080s
 sys     0m0,968s

- Listing per table is now faster:

 # nft list table nat &> /dev/null
 real    0m1,969s
 user    0m1,412s
 sys     0m0,556s

 # nft list table filter &> /dev/null
 real    0m0,697s
 user    0m0,478s
 sys     0m0,220s

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1326
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h   | 11 +++++++++--
 src/cache.c       | 42 ++++++++++++++++++++++++++++++++----------
 src/cmd.c         |  2 +-
 src/libnftables.c |  5 +++--
 4 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 70aaf735f7d9..b238c1cfe326 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -38,12 +38,19 @@ enum cache_level_flags {
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
+struct nft_cache_filter {
+	bool			enabled;
+	const char		*table;
+};
+
 struct nft_cache;
 enum cmd_ops;
 
-unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
+unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
+				struct nft_cache_filter *filter);
 int nft_cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
-		     struct list_head *msgs);
+		     struct list_head *msgs,
+		     const struct nft_cache_filter *filter);
 bool nft_cache_needs_update(struct nft_cache *cache);
 void nft_cache_release(struct nft_cache *cache);
 
diff --git a/src/cache.c b/src/cache.c
index a0898a976e88..563860e82fb8 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -127,9 +127,17 @@ static unsigned int evaluate_cache_rename(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
-static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags)
+static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags,
+					struct nft_cache_filter *filter)
 {
 	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		if (filter && cmd->handle.table.name) {
+			filter->table = cmd->handle.table.name;
+			filter->enabled = true;
+		}
+		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+		break;
 	case CMD_OBJ_CHAINS:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_CHAIN;
 		break;
@@ -148,12 +156,16 @@ static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
-unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
+unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
+				struct nft_cache_filter *filter)
 {
 	unsigned int flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
 
 	list_for_each_entry(cmd, cmds, list) {
+		if (filter->enabled && cmd->op != CMD_LIST)
+			filter->enabled = false;
+
 		switch (cmd->op) {
 		case CMD_ADD:
 		case CMD_INSERT:
@@ -181,7 +193,7 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 			flags |= NFT_CACHE_TABLE;
 			break;
 		case CMD_LIST:
-			flags |= evaluate_cache_list(cmd, flags);
+			flags |= evaluate_cache_list(cmd, flags, filter);
 			break;
 		case CMD_MONITOR:
 			flags |= NFT_CACHE_FULL;
@@ -582,7 +594,8 @@ struct flowtable *ft_cache_find(const struct table *table, const char *name)
 }
 
 static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
-			     struct nft_cache *cache)
+			     struct nft_cache *cache,
+			     const struct nft_cache_filter *filter)
 {
 	struct table *table, *next;
 	int ret;
@@ -593,13 +606,20 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 
 	list_for_each_entry_safe(table, next, &ctx->list, list) {
 		list_del(&table->list);
+
+		if (filter && filter->enabled &&
+		    (strcmp(filter->table, table->handle.table.name))) {
+			table_free(table);
+			continue;
+		}
 		table_cache_add(table, cache);
 	}
 
 	return 0;
 }
 
-static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
+static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
+			      const struct nft_cache_filter *filter)
 {
 	struct nftnl_flowtable_list *ft_list = NULL;
 	struct nftnl_chain_list *chain_list = NULL;
@@ -721,7 +741,8 @@ cache_fails:
 	return ret;
 }
 
-static int nft_cache_init(struct netlink_ctx *ctx, unsigned int flags)
+static int nft_cache_init(struct netlink_ctx *ctx, unsigned int flags,
+			  const struct nft_cache_filter *filter)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -732,10 +753,10 @@ static int nft_cache_init(struct netlink_ctx *ctx, unsigned int flags)
 		return 0;
 
 	/* assume NFT_CACHE_TABLE is always set. */
-	ret = cache_init_tables(ctx, &handle, &ctx->nft->cache);
+	ret = cache_init_tables(ctx, &handle, &ctx->nft->cache, filter);
 	if (ret < 0)
 		return ret;
-	ret = cache_init_objects(ctx, flags);
+	ret = cache_init_objects(ctx, flags, filter);
 	if (ret < 0)
 		return ret;
 
@@ -763,7 +784,8 @@ bool nft_cache_needs_update(struct nft_cache *cache)
 }
 
 int nft_cache_update(struct nft_ctx *nft, unsigned int flags,
-		     struct list_head *msgs)
+		     struct list_head *msgs,
+		     const struct nft_cache_filter *filter)
 {
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
@@ -792,7 +814,7 @@ replay:
 		goto skip;
 	}
 
-	ret = nft_cache_init(&ctx, flags);
+	ret = nft_cache_init(&ctx, flags, filter);
 	if (ret < 0) {
 		if (errno == EINTR) {
 			nft_cache_release(cache);
diff --git a/src/cmd.c b/src/cmd.c
index d956919b6b5e..f6a8aa114768 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -81,7 +81,7 @@ static int nft_cmd_enoent_rule(struct netlink_ctx *ctx, const struct cmd *cmd,
 	const struct table *table = NULL;
 	struct chain *chain;
 
-	if (nft_cache_update(ctx->nft, flags, ctx->msgs) < 0)
+	if (nft_cache_update(ctx->nft, flags, ctx->msgs, NULL) < 0)
 		return 0;
 
 	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
diff --git a/src/libnftables.c b/src/libnftables.c
index fc52fbc35d21..2b2ed1a44329 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -459,11 +459,12 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			struct list_head *cmds)
 {
+	struct nft_cache_filter filter = {};
 	unsigned int flags;
 	struct cmd *cmd;
 
-	flags = nft_cache_evaluate(nft, cmds);
-	if (nft_cache_update(nft, flags, msgs) < 0)
+	flags = nft_cache_evaluate(nft, cmds, &filter);
+	if (nft_cache_update(nft, flags, msgs, &filter) < 0)
 		return -1;
 
 	list_for_each_entry(cmd, cmds, list) {
-- 
2.30.2

