Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90AACA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 18:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979C8208E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 18:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfJaSVf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 14:21:35 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47724 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJaSVf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 14:21:35 -0400
Received: from localhost ([::1]:60814 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iQF4f-0008O7-Eu; Thu, 31 Oct 2019 19:21:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] evaluate: Reject set references in mapping LHS
Date:   Thu, 31 Oct 2019 19:21:24 +0100
Message-Id: <20191031182124.11393-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This wasn't explicitly caught before causing a program abort:

| BUG: invalid range expression type set reference
| nft: expression.c:1162: range_expr_value_low: Assertion `0' failed.
| zsh: abort      sudo ./install/sbin/nft add rule t c meta mark set tcp dport map '{ @s : 23 }

With this patch in place, the error message is way more descriptive:

| Error: Key can't be set reference
| add rule t c meta mark set tcp dport map { @s : 23 }
|                                            ^^

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 81230fc7f4be4..500780aeae243 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1456,6 +1456,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!expr_is_constant(mapping->left))
 		return expr_error(ctx->msgs, mapping->left,
 				  "Key must be a constant");
+	if (mapping->left->etype == EXPR_SET_ELEM &&
+	    mapping->left->key->etype == EXPR_SET_REF)
+		return expr_error(ctx->msgs, mapping->left,
+				  "Key can't be set reference");
 	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
 
 	expr_set_context(&ctx->ectx, set->datatype, set->datalen);
-- 
2.23.0

