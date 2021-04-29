Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31753C43470
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DF6613DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhD2Xn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59542 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhD2Xny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3DCC86413C
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 13/18] evaluate: add object to the cache
Date:   Fri, 30 Apr 2021 01:42:50 +0200
Message-Id: <20210429234255.16840-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the cache does not contain this object that is defined in this batch,
add it to the cache. This allows for references to this new object in
the same batch.

This patch also adds missing handle_merge() to set the object name,
otherwise object name is NULL and obj_cache_find() crashes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index f4c1acef0b16..c5adf2cab7b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4246,6 +4246,15 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
+	struct table *table;
+
+	table = table_lookup_global(ctx);
+	if (!table)
+		return table_not_found(ctx);
+
+	if (!obj_cache_find(table, obj->handle.obj.name, obj->type))
+		obj_cache_add(obj_get(obj), table);
+
 	switch (obj->type) {
 	case NFT_OBJECT_CT_TIMEOUT:
 		return ct_timeout_evaluate(ctx, obj);
@@ -4332,6 +4341,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_SYNPROXY:
+		handle_merge(&cmd->object->handle, &cmd->handle);
 		return obj_evaluate(ctx, cmd->object);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
-- 
2.20.1

