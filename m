Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD814C47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A79960241
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhFHNCi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:02:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56428 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhFHNCh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 09:02:37 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BFF6463E3D
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Jun 2021 14:59:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cmd: check for table mismatch first in error reporting
Date:   Tue,  8 Jun 2021 15:00:38 +0200
Message-Id: <20210608130039.361-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the fuzzy lookup provides a table, check if it is an inexact
matching, in that case, report that the table does not exist and provide
a mispelling suggestion for the non-existing table.

Initialize table to NULL since the fuzzy lookup might return no table
at all.

This patch fixes misleading error reporting:

 # nft delete chain xxx yyy
 Error: No such file or directory; did you mean chain ‘B’ in table ip ‘A’?
 delete chain xxx yyy
              ^^^

This refers to table 'xxx' but the suggestion refers to the chain instead.

Therefore, if the fuzzy lookup provides an exact matching table, then do
the fuzzy lookup for the next non-existing object (either chain, set,
...).

Fixes: 3a0e07106f66 ("src: combine extended netlink error reporting with mispelling support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cmd.c | 71 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 14 deletions(-)

diff --git a/src/cmd.c b/src/cmd.c
index a647130ec8b4..a69767c551fe 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -27,16 +27,38 @@ static int nft_cmd_enoent_table(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return 1;
 }
 
+static int table_fuzzy_check(struct netlink_ctx *ctx, const struct cmd *cmd,
+			     const struct table *table,
+			     const struct location *loc)
+{
+	if (strcmp(cmd->handle.table.name, table->handle.table.name) ||
+	    cmd->handle.family != table->handle.family) {
+		netlink_io_error(ctx, loc, "%s; did you mean table ‘%s’ in family %s?",
+				 strerror(ENOENT), table->handle.table.name,
+				 family2str(table->handle.family));
+		return 1;
+	}
+
+	return 0;
+}
+
 static int nft_cmd_enoent_chain(struct netlink_ctx *ctx, const struct cmd *cmd,
 				const struct location *loc)
 {
-	const struct table *table;
+	const struct table *table = NULL;
 	struct chain *chain;
 
 	if (!cmd->handle.chain.name)
 		return 0;
 
 	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
+	/* check table first. */
+	if (!table)
+		return 0;
+
+	if (table_fuzzy_check(ctx, cmd, table, loc))
+		return 1;
+
 	if (!chain)
 		return 0;
 
@@ -52,24 +74,24 @@ static int nft_cmd_enoent_rule(struct netlink_ctx *ctx, const struct cmd *cmd,
 {
 	unsigned int flags = NFT_CACHE_TABLE |
 			     NFT_CACHE_CHAIN;
-	const struct table *table;
+	const struct table *table = NULL;
 	struct chain *chain;
 
 	if (nft_cache_update(ctx->nft, flags, ctx->msgs) < 0)
 		return 0;
 
-	table = table_lookup_fuzzy(&cmd->handle, &ctx->nft->cache);
-	if (table && strcmp(cmd->handle.table.name, table->handle.table.name)) {
-		netlink_io_error(ctx, loc, "%s; did you mean table ‘%s’ in family %s?",
-				 strerror(ENOENT), table->handle.table.name,
-				 family2str(table->handle.family));
+	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
+	/* check table first. */
+	if (!table)
+		return 0;
+
+	if (table_fuzzy_check(ctx, cmd, table, loc))
 		return 1;
-	} else if (!table) {
+
+	if (!chain)
 		return 0;
-	}
 
-	chain = chain_lookup_fuzzy(&cmd->handle, &ctx->nft->cache, &table);
-	if (chain && strcmp(cmd->handle.chain.name, chain->handle.chain.name)) {
+	if (strcmp(cmd->handle.chain.name, chain->handle.chain.name)) {
 		netlink_io_error(ctx, loc, "%s; did you mean chain ‘%s’ in table %s ‘%s’?",
 				 strerror(ENOENT),
 				 chain->handle.chain.name,
@@ -84,13 +106,20 @@ static int nft_cmd_enoent_rule(struct netlink_ctx *ctx, const struct cmd *cmd,
 static int nft_cmd_enoent_set(struct netlink_ctx *ctx, const struct cmd *cmd,
 			      const struct location *loc)
 {
-	const struct table *table;
+	const struct table *table = NULL;
 	struct set *set;
 
 	if (!cmd->handle.set.name)
 		return 0;
 
 	set = set_lookup_fuzzy(cmd->handle.set.name, &ctx->nft->cache, &table);
+	/* check table first. */
+	if (!table)
+		return 0;
+
+	if (table_fuzzy_check(ctx, cmd, table, loc))
+		return 1;
+
 	if (!set)
 		return 0;
 
@@ -106,13 +135,20 @@ static int nft_cmd_enoent_set(struct netlink_ctx *ctx, const struct cmd *cmd,
 static int nft_cmd_enoent_obj(struct netlink_ctx *ctx, const struct cmd *cmd,
 			      const struct location *loc)
 {
-	const struct table *table;
+	const struct table *table = NULL;
 	struct obj *obj;
 
 	if (!cmd->handle.obj.name)
 		return 0;
 
 	obj = obj_lookup_fuzzy(cmd->handle.obj.name, &ctx->nft->cache, &table);
+	/* check table first. */
+	if (!table)
+		return 0;
+
+	if (table_fuzzy_check(ctx, cmd, table, loc))
+		return 1;
+
 	if (!obj)
 		return 0;
 
@@ -127,7 +163,7 @@ static int nft_cmd_enoent_flowtable(struct netlink_ctx *ctx,
 				    const struct cmd *cmd,
 				    const struct location *loc)
 {
-	const struct table *table;
+	const struct table *table = NULL;
 	struct flowtable *ft;
 
 	if (!cmd->handle.flowtable.name)
@@ -135,6 +171,13 @@ static int nft_cmd_enoent_flowtable(struct netlink_ctx *ctx,
 
 	ft = flowtable_lookup_fuzzy(cmd->handle.flowtable.name,
 				    &ctx->nft->cache, &table);
+	/* check table first. */
+	if (!table)
+		return 0;
+
+	if (table_fuzzy_check(ctx, cmd, table, loc))
+		return 1;
+
 	if (!ft)
 		return 0;
 
-- 
2.20.1

