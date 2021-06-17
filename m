Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB77C49361
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 15:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0926E61412
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 15:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhFQPRJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:17:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48394 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhFQPRI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 11:17:08 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 497F86425B
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jun 2021 17:13:40 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: memleak when listing ct event rule
Date:   Thu, 17 Jun 2021 17:14:57 +0200
Message-Id: <20210617151457.26414-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

listing a ruleset containing:

	ct event set new,related,destroy,label

results in memleak:

 Direct leak of 3672 byte(s) in 27 object(s) allocated from:
    #0 0x7fa5465c0330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7fa54233772c in xmalloc /home/.../devel/nftables/src/utils.c:36
    #2 0x7fa5423378eb in xzalloc /home/.../devel/nftables/src/utils.c:75
    #3 0x7fa5422488c6 in expr_alloc /home/.../devel/nftables/src/expression.c:45
    #4 0x7fa54224fb91 in binop_expr_alloc /home/.../devel/nftables/src/expression.c:698
    #5 0x7fa54224ddf8 in bitmask_expr_to_binops /home/.../devel/nftables/src/expression.c:512
    #6 0x7fa5423102ca in expr_postprocess /home/.../devel/nftables/src/netlink_delinearize.c:2448

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index bf4712e65d2c..c7fd1172edbc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2817,8 +2817,9 @@ rule_maybe_reset_payload_deps(struct payload_dep_ctx *pdctx, enum stmt_types t)
 
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
-	struct rule_pp_ctx rctx;
 	struct stmt *stmt, *next;
+	struct rule_pp_ctx rctx;
+	struct expr *expr;
 
 	memset(&rctx, 0, sizeof(rctx));
 	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask);
@@ -2847,9 +2848,11 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 				expr_postprocess(&rctx, &stmt->ct.expr);
 
 				if (stmt->ct.expr->etype == EXPR_BINOP &&
-				    stmt->ct.key == NFT_CT_EVENTMASK)
-					stmt->ct.expr = binop_tree_to_list(NULL,
-									   stmt->ct.expr);
+				    stmt->ct.key == NFT_CT_EVENTMASK) {
+					expr = binop_tree_to_list(NULL, stmt->ct.expr);
+					expr_free(stmt->ct.expr);
+					stmt->ct.expr = expr;
+				}
 			}
 			break;
 		case STMT_NAT:
-- 
2.20.1

