Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1805EEB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 14:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241063AbjFOOoh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239165AbjFOOog (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 10:44:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B802738
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 07:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f49sFOnwqYYyt6cJnGOJ1Ssf+UJUwwd7iFeSQ/UG/4A=; b=NazyMdBGuTXuCUx3qtLckVWUI5
        CLzVmDh7SEMmkGEim9PAmSKCgc9b5dHXza8HAK0L1dYmJBR2QPiHxTIy7ESAjfCigTL5hhuALvuP0
        CPYysczQPqu3Ir9W29YCuVrTx5nj7/gBLC3yIc/obAQ69kTBT0q7uSTEXDMqmcB2Ix+PTt8OeX19c
        bwmmBgB7ev/pCYiEJOMSuwHSwn1yIN1+v87L/U7r5bAtOVrYMIHRwQ0kxMkZAx3xzXb7E6p1M5HOY
        KszU6aaGIE7GwT9YObo8r2pBbcAlpxrO0J4SizamlDy1GEydifojkLG5rYIrZoSlcr3SEXwYsgHwa
        BsWsmQUw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1q9oDC-0003nX-9B; Thu, 15 Jun 2023 16:44:34 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] evaluate: Merge some cases in cmd_evaluate_list()
Date:   Thu, 15 Jun 2023 16:44:12 +0200
Message-Id: <20230615144414.1393-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230615144414.1393-1-phil@nwl.cc>
References: <20230615144414.1393-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The code for set, map and meter were almost identical apart from the
specific last check. Fold them together and make the distinction in that
spot only.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 00bb8988bd4c9..3983fcaa35880 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5337,38 +5337,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_SET:
-		table = table_cache_find(&ctx->nft->cache.table_cache,
-					 cmd->handle.table.name,
-					 cmd->handle.family);
-		if (!table)
-			return table_not_found(ctx);
-
-		set = set_cache_find(table, cmd->handle.set.name);
-		if (set == NULL)
-			return set_not_found(ctx, &ctx->cmd->handle.set.location,
-					     ctx->cmd->handle.set.name);
-		else if (!set_is_literal(set->flags))
-			return cmd_error(ctx, &ctx->cmd->handle.set.location,
-					 "%s", strerror(ENOENT));
-
-		return 0;
-	case CMD_OBJ_METER:
-		table = table_cache_find(&ctx->nft->cache.table_cache,
-					 cmd->handle.table.name,
-					 cmd->handle.family);
-		if (!table)
-			return table_not_found(ctx);
-
-		set = set_cache_find(table, cmd->handle.set.name);
-		if (set == NULL)
-			return set_not_found(ctx, &ctx->cmd->handle.set.location,
-					     ctx->cmd->handle.set.name);
-		else if (!set_is_meter(set->flags))
-			return cmd_error(ctx, &ctx->cmd->handle.set.location,
-					 "%s", strerror(ENOENT));
-
-		return 0;
 	case CMD_OBJ_MAP:
+	case CMD_OBJ_METER:
 		table = table_cache_find(&ctx->nft->cache.table_cache,
 					 cmd->handle.table.name,
 					 cmd->handle.family);
@@ -5379,7 +5349,9 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
-		else if (!map_is_literal(set->flags))
+		if ((cmd->obj == CMD_OBJ_SET && !set_is_literal(set->flags)) ||
+		    (cmd->obj == CMD_OBJ_MAP && !map_is_literal(set->flags)) ||
+		    (cmd->obj == CMD_OBJ_METER && !set_is_meter(set->flags)))
 			return cmd_error(ctx, &ctx->cmd->handle.set.location,
 					 "%s", strerror(ENOENT));
 
-- 
2.40.0

