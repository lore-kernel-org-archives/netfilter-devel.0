Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A700C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E932360FED
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbhDASq5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:46:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53482 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbhDASoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 14:44:55 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C959F63E3D
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 13:40:01 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: use chain hashtable for lookups
Date:   Thu,  1 Apr 2021 13:40:13 +0200
Message-Id: <20210401114013.5047-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of the linear list lookup.

Before this patch:

real    0m21,735s
user    0m20,329s
sys     0m1,384s

After:

real    0m10,910s
user    0m9,448s
sys     0m1,434s

This patch requires a small adjust: Allocate a clone of the existing
chain in the cache, instead of recycling the object to avoid a list
corruption.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 15 ++++++++++-----
 src/rule.c     |  2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index cebf7cb8ef2c..5f64979453ad 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4106,15 +4106,20 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		return table_not_found(ctx);
 
 	if (chain == NULL) {
-		if (chain_lookup(table, &ctx->cmd->handle) == NULL) {
+		if (chain_cache_find(table, &ctx->cmd->handle) == NULL) {
 			chain = chain_alloc(NULL);
 			handle_merge(&chain->handle, &ctx->cmd->handle);
 			chain_cache_add(chain, table);
 		}
 		return 0;
 	} else if (!(chain->flags & CHAIN_F_BINDING)) {
-		if (chain_lookup(table, &chain->handle) == NULL)
-			chain_cache_add(chain_get(chain), table);
+		if (chain_cache_find(table, &chain->handle) == NULL) {
+			struct chain *newchain;
+
+			newchain = chain_alloc(NULL);
+			handle_merge(&newchain->handle, &chain->handle);
+			chain_cache_add(newchain, table);
+		}
 	}
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
@@ -4440,7 +4445,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (chain_lookup(table, &cmd->handle) == NULL)
+		if (chain_cache_find(table, &cmd->handle) == NULL)
 			return chain_not_found(ctx);
 
 		return 0;
@@ -4600,7 +4605,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (chain_lookup(table, &ctx->cmd->handle) == NULL)
+		if (chain_cache_find(table, &ctx->cmd->handle) == NULL)
 			return chain_not_found(ctx);
 
 		break;
diff --git a/src/rule.c b/src/rule.c
index 969318008933..4f1ca22ec9e7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2621,7 +2621,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		chain = chain_lookup(table, &cmd->handle);
+		chain = chain_cache_find(table, &cmd->handle);
 
 		return mnl_nft_chain_rename(ctx, cmd, chain);
 	default:
-- 
2.20.1

