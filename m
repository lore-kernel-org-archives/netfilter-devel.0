Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E84C43600
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E352D61460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhD2Xn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59546 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhD2Xny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D529164133
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 15/18] evaluate: remove chain from cache on delete chain command
Date:   Fri, 30 Apr 2021 01:42:52 +0200
Message-Id: <20210429234255.16840-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update the cache to remove this chain from the evaluation phase. Add
chain_cache_del() function for this purpose.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |  2 ++
 src/cache.c     |  5 +++++
 src/evaluate.c  | 24 ++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/cache.h b/include/cache.h
index fddb843b510e..3823e9a78653 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -62,7 +62,9 @@ struct table;
 struct chain;
 
 void chain_cache_add(struct chain *chain, struct table *table);
+void chain_cache_del(struct chain *chain);
 struct chain *chain_cache_find(const struct table *table, const char *name);
+
 void set_cache_add(struct set *set, struct table *table);
 void set_cache_del(struct set *set);
 struct set *set_cache_find(const struct table *table, const char *name);
diff --git a/src/cache.c b/src/cache.c
index 3c139f1a5dbb..a98ee5954c36 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -278,6 +278,11 @@ void chain_cache_add(struct chain *chain, struct table *table)
 	cache_add(&chain->cache, &table->chain_cache, hash);
 }
 
+void chain_cache_del(struct chain *chain)
+{
+	cache_del(&chain->cache);
+}
+
 struct chain *chain_cache_find(const struct table *table, const char *name)
 {
 	struct chain *chain;
diff --git a/src/evaluate.c b/src/evaluate.c
index e770cffa6d99..49d47d0b4f34 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4367,6 +4367,28 @@ static void table_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 	table_free(table);
 }
 
+static void chain_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+	struct chain *chain;
+
+	if (!cmd->handle.chain.name)
+		return;
+
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 cmd->handle.table.name,
+				 cmd->handle.family);
+	if (!table)
+		return;
+
+	chain = chain_cache_find(table, cmd->handle.chain.name);
+	if (!chain)
+		return;
+
+	chain_cache_del(chain);
+	chain_free(chain);
+}
+
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -4374,7 +4396,9 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 		return setelem_evaluate(ctx, cmd);
 	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
+		return 0;
 	case CMD_OBJ_CHAIN:
+		chain_del_cache(ctx, cmd);
 		return 0;
 	case CMD_OBJ_TABLE:
 		table_del_cache(ctx, cmd);
-- 
2.20.1

