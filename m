Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD9CC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CF4603E8
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhKEPHY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:07:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40130 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhKEPHY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 11:07:24 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4D07360831
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Nov 2021 16:02:47 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] evaluate: grab reference in set expression evaluation
Date:   Fri,  5 Nov 2021 16:04:35 +0100
Message-Id: <20211105150435.466838-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211105150435.466838-1-pablo@netfilter.org>
References: <20211105150435.466838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not clone expression when evaluation a set expression, grabbing the
reference counter to reuse the object is sufficient.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index fd7818da1116..eebd992159a1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1439,7 +1439,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			list_for_each_entry(j, &i->left->key->expressions, list) {
 				new = mapping_expr_alloc(&i->location,
 							 expr_get(j),
-							 expr_clone(i->right));
+							 expr_get(i->right));
 				list_add_tail(&new->list, &set->expressions);
 				set->size++;
 			}
@@ -1457,7 +1457,7 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 
 		if (elem->etype == EXPR_SET_ELEM &&
 		    elem->key->etype == EXPR_SET) {
-			struct expr *new = expr_clone(elem->key);
+			struct expr *new = expr_get(elem->key);
 
 			set->set_flags |= elem->key->set_flags;
 			list_replace(&i->list, &new->list);
-- 
2.30.2

