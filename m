Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E7DEE4993
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 12:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbjHWME6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 08:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjHWMEn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 08:04:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42EFC1987
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 05:04:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: error out on meter overlap with an existing set/map declaration
Date:   Wed, 23 Aug 2023 14:04:00 +0200
Message-Id: <20230823120400.91225-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One of the problems with meters is that they use the set/map
infrastructure behind the scenes which might be confusing to users.

This patch errors out in case user declares a meter whose name overlaps
with an existing set/map:

meter.nft:15:18-91: Error: File exists; meter ‘syn4-meter’ overlaps an existing set ‘syn4-meter’ in family inet
    tcp dport 22 meter syn4-meter { ip  saddr . tcp dport timeout 5m limit rate 20/minute } counter accept
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An old 5.10 kernel bails out simply with EEXIST, with this patch a
better hint is provided.

Dynamic sets are preferred over meters these days.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8fc1ca7e4b4f..bdd3c651ea2f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3037,6 +3037,24 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *key, *set, *setref;
+	struct set *existing_set;
+	struct table *table;
+
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
+	if (table == NULL)
+		return table_not_found(ctx);
+
+	existing_set = set_cache_find(table, stmt->meter.name);
+	if (existing_set)
+		return cmd_error(ctx, &stmt->location,
+				 "%s; meter ‘%s’ overlaps an existing %s ‘%s’ in family %s",
+				 strerror(EEXIST),
+				 stmt->meter.name,
+				 set_is_map(existing_set->flags) ? "map" : "set",
+				 existing_set->handle.set.name,
+				 family2str(existing_set->handle.family));
 
 	expr_set_context(&ctx->ectx, NULL, 0);
 	if (expr_evaluate(ctx, &stmt->meter.key) < 0)
-- 
2.30.2

