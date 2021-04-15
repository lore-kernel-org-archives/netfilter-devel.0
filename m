Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD73CC433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A231611F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhDONOD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:14:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57872 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhDONOA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:14:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 52AE563E77
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:10 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 07/10] evaluate: add object to the cache
Date:   Thu, 15 Apr 2021 15:13:27 +0200
Message-Id: <20210415131330.6692-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131330.6692-1-pablo@netfilter.org>
References: <20210415131330.6692-1-pablo@netfilter.org>
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
index 7b2d01c5dee1..72cf756bbb5c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4210,6 +4210,15 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
+	struct table *table;
+
+	table = table_lookup_global(ctx);
+	if (table == NULL)
+		return table_not_found(ctx);
+
+	if (obj_cache_find(table, obj->handle.obj.name, obj->type) == NULL)
+		obj_cache_add(obj_get(obj), table);
+
 	switch (obj->type) {
 	case NFT_OBJECT_CT_TIMEOUT:
 		return ct_timeout_evaluate(ctx, obj);
@@ -4296,6 +4305,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SECMARK:
 	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_SYNPROXY:
+		handle_merge(&cmd->object->handle, &cmd->handle);
 		return obj_evaluate(ctx, cmd->object);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
-- 
2.20.1

