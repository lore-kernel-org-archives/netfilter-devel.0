Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C69C48BE5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 18:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11979610A3
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 18:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhFPSLw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 14:11:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46470 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhFPSLw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 14:11:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BA2636423C
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 20:08:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: do not skip evaluation of mapping set elements
Date:   Wed, 16 Jun 2021 20:09:40 +0200
Message-Id: <20210616180941.78202-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set element keys are of EXPR_SET_ELEM expression type, however, mappings
use the EXPR_MAPPING expression to wrap the EXPR_SET_ELEM key
(mapping->left) and the corresponding data (mapping->right).

This patch adds a wrapper function to fetch the EXPR_SET_ELEM expression
from the key in case of mappings and use it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index aa7ec9bee4ae..d220c8e391ac 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1414,27 +1414,39 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static const struct expr *expr_set_elem(const struct expr *expr)
+{
+	if (expr->etype == EXPR_MAPPING)
+		return expr->left;
+
+	return expr;
+}
+
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
+	const struct expr *elem;
 
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
 
-		if (i->etype == EXPR_SET_ELEM &&
-		    i->key->etype == EXPR_SET_REF)
+		elem = expr_set_elem(i);
+
+		if (elem->etype == EXPR_SET_ELEM &&
+		    elem->key->etype == EXPR_SET_REF)
 			return expr_error(ctx->msgs, i,
 					  "Set reference cannot be part of another set");
 
-		if (i->etype == EXPR_SET_ELEM &&
-		    i->key->etype == EXPR_SET) {
-			struct expr *new = expr_clone(i->key);
+		if (elem->etype == EXPR_SET_ELEM &&
+		    elem->key->etype == EXPR_SET) {
+			struct expr *new = expr_clone(elem->key);
 
-			set->set_flags |= i->key->set_flags;
+			set->set_flags |= elem->key->set_flags;
 			list_replace(&i->list, &new->list);
 			expr_free(i);
 			i = new;
+			elem = expr_set_elem(i);
 		}
 
 		if (!expr_is_constant(i))
@@ -1450,7 +1462,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			expr_free(i);
 		} else if (!expr_is_singleton(i)) {
 			set->set_flags |= NFT_SET_INTERVAL;
-			if (i->key->etype == EXPR_CONCAT)
+			if (elem->key->etype == EXPR_CONCAT)
 				set->set_flags |= NFT_SET_CONCAT;
 		}
 	}
-- 
2.30.2

