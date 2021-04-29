Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29317C43461
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E1FF61460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhD2Xn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59536 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhD2Xnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:55 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 83FFE6414D
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 17/18] evaluate: remove flowtable from cache on delete flowtable command
Date:   Fri, 30 Apr 2021 01:42:54 +0200
Message-Id: <20210429234255.16840-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update the cache to remove this flowtable from the evaluation phase.
Add flowtable_cache_del() function for this purpose.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |  1 +
 src/cache.c     |  5 +++++
 src/evaluate.c  | 24 ++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/include/cache.h b/include/cache.h
index 3823e9a78653..ad9078432c73 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -96,6 +96,7 @@ struct obj *obj_cache_find(const struct table *table, const char *name,
 
 struct flowtable;
 void ft_cache_add(struct flowtable *ft, struct table *table);
+void ft_cache_del(struct flowtable *ft);
 struct flowtable *ft_cache_find(const struct table *table, const char *name);
 
 struct nft_cache {
diff --git a/src/cache.c b/src/cache.c
index a98ee5954c36..f59bba03b81e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -527,6 +527,11 @@ void ft_cache_add(struct flowtable *ft, struct table *table)
 	cache_add(&ft->cache, &table->ft_cache, hash);
 }
 
+void ft_cache_del(struct flowtable *ft)
+{
+	cache_del(&ft->cache);
+}
+
 struct flowtable *ft_cache_find(const struct table *table, const char *name)
 {
 	struct flowtable *ft;
diff --git a/src/evaluate.c b/src/evaluate.c
index 19bf73878181..97a77657bbd6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4411,6 +4411,28 @@ static void set_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 	set_free(set);
 }
 
+static void ft_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	struct flowtable *ft;
+	struct table *table;
+
+	if (!cmd->handle.flowtable.name)
+		return;
+
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 cmd->handle.table.name,
+				 cmd->handle.family);
+	if (!table)
+		return;
+
+	ft = ft_cache_find(table, cmd->handle.flowtable.name);
+	if (!ft)
+		return;
+
+	ft_cache_del(ft);
+	flowtable_free(ft);
+}
+
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -4428,6 +4450,8 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 		table_del_cache(ctx, cmd);
 		return 0;
 	case CMD_OBJ_FLOWTABLE:
+		ft_del_cache(ctx, cmd);
+		return 0;
 	case CMD_OBJ_COUNTER:
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
-- 
2.20.1

