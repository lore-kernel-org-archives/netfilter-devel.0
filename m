Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 511AEC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Nov 2021 11:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6CD61184
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Nov 2021 11:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245740AbhKIL2r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 06:28:47 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50246 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245747AbhKIL2q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 06:28:46 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8CB9560056
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Nov 2021 12:24:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v4 3/3] cache: missing family in cache filtering
Date:   Tue,  9 Nov 2021 12:25:24 +0100
Message-Id: <20211109112524.201758-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211109112524.201758-1-pablo@netfilter.org>
References: <20211109112524.201758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check family when filtering out listing of tables and sets.

Fixes: 3f1d3912c3a6 ("cache: filter out tables that are not requested")
Fixes: 635ee1cad8aa ("cache: filter out sets and maps that are not requested")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new in this series.

 include/cache.h |  1 +
 src/cache.c     | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index cdf1f4fbf6f7..120a1b8d91b5 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -49,6 +49,7 @@ struct nft_filter_obj {
 
 struct nft_cache_filter {
 	struct {
+		uint32_t	family;
 		const char	*table;
 		const char	*set;
 	} list;
diff --git a/src/cache.c b/src/cache.c
index fb4137bc17a6..ac7d8b26a642 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -194,14 +194,16 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 {
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
-		if (filter && cmd->handle.table.name)
+		if (filter && cmd->handle.table.name) {
+			filter->list.family = cmd->handle.family;
 			filter->list.table = cmd->handle.table.name;
-
+		}
 		flags |= NFT_CACHE_FULL;
 		break;
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		if (filter && cmd->handle.table.name && cmd->handle.set.name) {
+			filter->list.family = cmd->handle.family;
 			filter->list.table = cmd->handle.table.name;
 			filter->list.set = cmd->handle.set.name;
 		}
@@ -439,7 +441,8 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 		return -1;
 
 	if (ctx->filter && ctx->filter->list.set &&
-	    (strcmp(ctx->filter->list.table, set->handle.table.name) ||
+	    (ctx->filter->list.family != set->handle.family ||
+	     strcmp(ctx->filter->list.table, set->handle.table.name) ||
 	     strcmp(ctx->filter->list.set, set->handle.set.name))) {
 		set_free(set);
 		return 0;
@@ -699,7 +702,8 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 		list_del(&table->list);
 
 		if (filter && filter->list.table &&
-		    (strcmp(filter->list.table, table->handle.table.name))) {
+		    (filter->list.family != table->handle.family &&
+		     strcmp(filter->list.table, table->handle.table.name))) {
 			table_free(table);
 			continue;
 		}
-- 
2.30.2

