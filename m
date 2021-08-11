Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62962C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 10:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3451860C3E
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 10:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbhHKKeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 06:34:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44466 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbhHKKeQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 06:34:16 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9D1936006C
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 12:33:09 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: element key cannot in map cannot be a set
Date:   Wed, 11 Aug 2021 12:33:43 +0200
Message-Id: <20210811103344.23073-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # cat x.nft
 define lala = { eth0, eth1 }

 table ip x {
        chain y {
                iifname vmap { lo : accept, $lala : drop }
        }
 }
 # nft -f x.nft
 x.nft:5:16-44: Error: Could not process rule: Invalid argument
                iifname vmap { lo : accept, $lala : drop }
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

instead:

 x.nft:1:15-28: Error: Element key in map cannot be a set
 define lala = { eth0, eth1 }
               ^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8b5f51cee01c..110a40413c1c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1395,16 +1395,23 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	if (expr_evaluate(ctx, &elem->key) < 0)
 		return -1;
 
-	if (ctx->set &&
-	    !(ctx->set->flags & (NFT_SET_ANONYMOUS | NFT_SET_INTERVAL))) {
-		switch (elem->key->etype) {
-		case EXPR_PREFIX:
-		case EXPR_RANGE:
-			return expr_error(ctx->msgs, elem,
-					  "You must add 'flags interval' to your %s declaration if you want to add %s elements",
-					  set_is_map(ctx->set->flags) ? "map" : "set", expr_name(elem->key));
-		default:
-			break;
+	if (ctx->set) {
+		if (!(ctx->set->flags & (NFT_SET_ANONYMOUS | NFT_SET_INTERVAL))) {
+			switch (elem->key->etype) {
+			case EXPR_PREFIX:
+			case EXPR_RANGE:
+				return expr_error(ctx->msgs, elem,
+						  "You must add 'flags interval' to your %s declaration if you want to add %s elements",
+						  set_is_map(ctx->set->flags) ? "map" : "set", expr_name(elem->key));
+				break;
+			default:
+				break;
+			}
+		}
+		if (set_is_map(ctx->set->flags) &&
+		    elem->key->etype == EXPR_SET) {
+			return expr_error(ctx->msgs, elem->key,
+					  "Element key in map cannot be a set");
 		}
 	}
 
-- 
2.20.1

