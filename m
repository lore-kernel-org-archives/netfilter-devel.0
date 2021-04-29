Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA8DC433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6B561460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhD2XoA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:44:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59542 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhD2Xnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:55 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D22736413C
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 18/18] evaluate: remove object from cache on delete object command
Date:   Fri, 30 Apr 2021 01:42:55 +0200
Message-Id: <20210429234255.16840-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update the cache to remove this object from the evaluation phase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 97a77657bbd6..b5dcdd3542f1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4433,6 +4433,28 @@ static void ft_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 	flowtable_free(ft);
 }
 
+static void obj_del_cache(struct eval_ctx *ctx, struct cmd *cmd, int type)
+{
+	struct table *table;
+	struct obj *obj;
+
+	if (!cmd->handle.obj.name)
+		return;
+
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 cmd->handle.table.name,
+				 cmd->handle.family);
+	if (!table)
+		return;
+
+	obj = obj_cache_find(table, cmd->handle.obj.name, type);
+	if (!obj)
+		return;
+
+	obj_cache_del(obj);
+	obj_free(obj);
+}
+
 static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -4453,13 +4475,28 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 		ft_del_cache(ctx, cmd);
 		return 0;
 	case CMD_OBJ_COUNTER:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_COUNTER);
+		return 0;
 	case CMD_OBJ_QUOTA:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_QUOTA);
+		return 0;
 	case CMD_OBJ_CT_HELPER:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_CT_HELPER);
+		return 0;
 	case CMD_OBJ_CT_TIMEOUT:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
+		return 0;
 	case CMD_OBJ_LIMIT:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_LIMIT);
+		return 0;
 	case CMD_OBJ_SECMARK:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_SECMARK);
+		return 0;
 	case CMD_OBJ_CT_EXPECT:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_CT_EXPECT);
+		return 0;
 	case CMD_OBJ_SYNPROXY:
+		obj_del_cache(ctx, cmd, NFT_OBJECT_SYNPROXY);
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
-- 
2.20.1

