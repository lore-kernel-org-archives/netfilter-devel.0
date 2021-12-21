Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7436C4167D
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbhLUThU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241818AbhLUThR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF692C061759
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1280cVmI7gRTiMj2WWMoXHU8YptUjTNRxcxHc7Ytvn4=; b=djX2NzgD2BoEzdkX/IrA7tpDLu
        vNE3u8h2OY3bszGz0GfNu/zb/qjnduVKUyl6pNKlSLnWjDOmmc92S8l/DU4Znrzh4HjhfXx6+QjWk
        Lua9CSyWElHOeVxHl8Z531bxBBUvAbad4A7mn3gOdFhd8+6lJF/HKtLZUrWbYC9nLbr3cQCm+fPXJ
        s2ZalZa4D+vFjbVgAboeIMnhxMTBszkSNh9ybmHuGq4/t94wCGLYte48llGpj+VIdVbYge1WDLX3j
        3nkNKq/CX1BGc8+SAvqk9nD7zreu7ZTyKIZUTY242luKsJmNmhew7mkxjjvnhpJE7QK78kRBl6+/v
        k1Q4MJGA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwk-0019T9-3v
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 07/11] src: simplify logic governing storing payload dependencies
Date:   Tue, 21 Dec 2021 19:36:53 +0000
Message-Id: <20211221193657.430866-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221193657.430866-1-jeremy@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are several places where we check whether `ctx->pdctx.pbase`
equal to `PROTO_BASE_INVALID` and don't bother trying to free the
dependency if so.  However, these checks are redundant.

In `payload_match_expand` and `trace_gen_stmts`, we skip a call to
`payload_dependency_kill`, but that calls `payload_dependency_exists` to check a
dependency exists before doing anything else.

In `ct_meta_common_postprocess`, we skip an open-coded equivalent to
`payload_dependency_kill` which performs some different checks, but the
first is the same: a call to `payload_dependency_exists`.

Therefore, we can drop the redundant checks and simplify the flow-
control in the functions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink.c             | 13 ++++---------
 src/netlink_delinearize.c | 17 ++++-------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 5aad865955db..15b8878eb488 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1939,16 +1939,11 @@ next:
 		if (payload_is_stacked(desc, rel))
 			b--;
 
-		if (lhs->flags & EXPR_F_PROTOCOL &&
-		    pctx->pbase == PROTO_BASE_INVALID) {
+		/* Don't strip 'icmp type' from payload dump. */
+		if (pctx->icmp_type == 0)
+			payload_dependency_kill(pctx, lhs, ctx->family);
+		if (lhs->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(pctx, stmt, b);
-		} else {
-			/* Don't strip 'icmp type' from payload dump. */
-			if (pctx->icmp_type == 0)
-				payload_dependency_kill(pctx, lhs, ctx->family);
-			if (lhs->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(pctx, stmt, b);
-		}
 
 		goto next;
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 36ead8029691..fd81e07151c2 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1899,16 +1899,10 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		 * kill it later on if made redundant by a higher layer
 		 * payload expression.
 		 */
-		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
-		    expr->op == OP_EQ &&
-		    left->flags & EXPR_F_PROTOCOL) {
+		payload_dependency_kill(&ctx->pdctx, nexpr->left,
+					ctx->pctx.family);
+		if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(&ctx->pdctx, nstmt, base);
-		} else {
-			payload_dependency_kill(&ctx->pdctx, nexpr->left,
-						ctx->pctx.family);
-			if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(&ctx->pdctx, nstmt, base);
-		}
 	}
 	list_del(&ctx->stmt->list);
 	stmt_free(ctx->stmt);
@@ -2125,10 +2119,7 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 
 		relational_expr_pctx_update(&ctx->pctx, expr);
 
-		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
-		    left->flags & EXPR_F_PROTOCOL) {
-			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
-		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
+		if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
 			if (payload_dependency_exists(&ctx->pdctx, base) &&
 			    meta_may_dependency_kill(&ctx->pdctx,
 						     ctx->pctx.family, expr))
-- 
2.34.1

