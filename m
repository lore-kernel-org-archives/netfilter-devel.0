From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH v3] payload: Update the context only in equality relations
Date: Mon,  2 Jun 2014 16:44:11 +0200
Message-ID: <1401720251-9041-1-git-send-email-alvaroneay@gmail.com>
References: <1401270454-11669-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54728 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaFBOpd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:45:33 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so4742093wiv.1
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 07:45:32 -0700 (PDT)
In-Reply-To: <1401270454-11669-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we add this rule:

sudo nft add rule ip test input ip protocol != icmp

and we try to list the rules in the table test, nftables
show this error:

nft: src/payload.c:76: payload_expr_pctx_update: Assertion `expr->op
== OP_EQ' failed.

This patch change the function payload_match_postprocess for updating
only the context in equality relations case.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
*Changed the patch for updating the context only in case of equality relations
case and keep the assert without changes in the function
payload_expr_pctx_update.

 src/netlink_delinearize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 479c643..ea33308 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -644,7 +644,8 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 
 			nexpr = relational_expr_alloc(&expr->location, expr->op,
 						      left, tmp);
-			left->ops->pctx_update(&ctx->pctx, nexpr);
+			if (expr->op == OP_EQ)
+				left->ops->pctx_update(&ctx->pctx, nexpr);
 
 			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
 			list_add_tail(&nstmt->list, &stmt->list);
-- 
1.7.10.4

