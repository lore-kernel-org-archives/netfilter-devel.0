Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E17BCCA479
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239850AbiFTIcb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiFTIc2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B92612A88
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:26 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 06/18] optimize: fix verdict map merging
Date:   Mon, 20 Jun 2022 10:32:03 +0200
Message-Id: <20220620083215.1021238-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620083215.1021238-1-pablo@netfilter.org>
References: <20220620083215.1021238-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip comparison when collecting the statement and building the rule vs
statement matrix. Compare verdict type when merging rules.

When infering rule mergers, honor the STMT_VERDICT with map (ie. vmap).

Fixes: 561aa3cfa8da ("optimize: merge verdict maps with same lookup key")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/optimize.c b/src/optimize.c
index 427625846484..747282b4d7f4 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -139,6 +139,9 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 	case STMT_NOTRACK:
 		break;
 	case STMT_VERDICT:
+		if (!fully_compare)
+			break;
+
 		expr_a = stmt_a->expr;
 		expr_b = stmt_b->expr;
 
@@ -276,10 +279,6 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 		if (stmt_type_find(ctx, stmt))
 			continue;
 
-		if (stmt->ops->type == STMT_VERDICT &&
-		    stmt->expr->etype == EXPR_MAP)
-			continue;
-
 		/* No refcounter available in statement objects, clone it to
 		 * to store in the array of selectors.
 		 */
@@ -999,6 +998,10 @@ static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
 			case STMT_EXPRESSION:
 				merge[k].stmt[merge[k].num_stmts++] = m;
 				break;
+			case STMT_VERDICT:
+				if (ctx->stmt_matrix[i][m]->expr->etype == EXPR_MAP)
+					merge[k].stmt[merge[k].num_stmts++] = m;
+				break;
 			default:
 				break;
 			}
-- 
2.30.2

