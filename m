Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046ACC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0142071B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 17:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgGPRnP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:43:15 -0400
Received: from correo.us.es ([193.147.175.20]:39074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbgGPRnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 13:43:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93F65EF425
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8269EDA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77EA0DA72F; Thu, 16 Jul 2020 19:43:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52033DA789
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jul 2020 19:43:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3DB834265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 19:43:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] evaluate: use evaluate_expr_variable() for chain policy evaluation
Date:   Thu, 16 Jul 2020 19:43:04 +0200
Message-Id: <20200716174305.4114-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200716174305.4114-1-pablo@netfilter.org>
References: <20200716174305.4114-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

evaluate_policy() is very similar to evaluate_expr_variable(), replace it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c9601f175cc4..4ec91a1ce771 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3968,25 +3968,6 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	return NF_INET_NUMHOOKS;
 }
 
-static bool evaluate_policy(struct eval_ctx *ctx, struct expr **exprp)
-{
-	struct expr *expr;
-
-	ctx->ectx.dtype = &policy_type;
-	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
-	if (expr_evaluate(ctx, exprp) < 0)
-		return false;
-
-	expr = *exprp;
-	if (expr->etype != EXPR_VALUE) {
-		expr_error(ctx->msgs, expr, "%s is not a valid "
-			   "policy expression", expr_name(expr));
-		return false;
-	}
-
-	return true;
-}
-
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct table *table;
@@ -4022,7 +4003,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 						   "invalid priority expression %s in this context.",
 						   expr_name(chain->priority.expr));
 		if (chain->policy) {
-			if (!evaluate_policy(ctx, &chain->policy))
+			expr_set_context(&ctx->ectx, &policy_type,
+					 NFT_NAME_MAXLEN * BITS_PER_BYTE);
+			if (!evaluate_expr_variable(ctx, &chain->policy))
 				return chain_error(ctx, chain, "invalid policy expression %s",
 						   expr_name(chain->policy));
 		}
-- 
2.20.1

