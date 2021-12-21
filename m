Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89225C43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbhLUThS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241814AbhLUThR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE5CC061748
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QqAZMN259gUtf/6oZ9rs+++g70vmXjx1FOGZO1QBdEI=; b=FcaHjmJ9KeYnOHKzzz/h6Kwaq2
        5ocaav3XNIfClUIWeTiaSWUcIWV2hHf61V/v015Lxz9tOz83Pkrg7GS9XLL7nXJWO45rBJt83nt80
        JaoxHWU00ZSiOFz8WO2hft/S+GY0bYUTFLmhkv/I0Bz/o6uZbmv4ZxKpYIM1l+p1xR9H6IPm2anOD
        7u8FoTrZtmH4Ev6lkI4TCx7eOV5DJSPo6AqHBr521oQBk+HHQdnCNkCOsIvxqR8D5uWSUDTMyeyD2
        pkVFJPNdVD6Nnmv7nOSxHWXZsHZtL7ke6tiOn2tcQVZsWV4aN2k/VfgBHT3P0HKWM+2Y6NUr3L9t/
        ilhicSXA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwj-0019T9-V4
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 05/11] src: remove arithmetic on booleans
Date:   Tue, 21 Dec 2021 19:36:51 +0000
Message-Id: <20211221193657.430866-6-jeremy@azazel.net>
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

Instead of subtracting a boolean from the protocol base for stacked
payloads, just decrement the base variable itself.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink.c             | 10 ++++++----
 src/netlink_delinearize.c |  8 ++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 359d801c29d3..5aad865955db 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1868,7 +1868,6 @@ static void trace_gen_stmts(struct list_head *stmts,
 	const void *hdr;
 	uint32_t hlen;
 	unsigned int n;
-	bool stacked;
 
 	if (!nftnl_trace_is_set(nlt, attr))
 		return;
@@ -1923,6 +1922,8 @@ restart:
 	n = 0;
 next:
 	list_for_each_entry(stmt, &unordered, list) {
+		enum proto_bases b = base;
+
 		rel = stmt->expr;
 		lhs = rel->left;
 
@@ -1935,17 +1936,18 @@ next:
 		list_move_tail(&stmt->list, stmts);
 		n++;
 
-		stacked = payload_is_stacked(desc, rel);
+		if (payload_is_stacked(desc, rel))
+			b--;
 
 		if (lhs->flags & EXPR_F_PROTOCOL &&
 		    pctx->pbase == PROTO_BASE_INVALID) {
-			payload_dependency_store(pctx, stmt, base - stacked);
+			payload_dependency_store(pctx, stmt, b);
 		} else {
 			/* Don't strip 'icmp type' from payload dump. */
 			if (pctx->icmp_type == 0)
 				payload_dependency_kill(pctx, lhs, ctx->family);
 			if (lhs->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(pctx, stmt, base - stacked);
+				payload_dependency_store(pctx, stmt, b);
 		}
 
 		goto next;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 83be2fec441d..39b0574e38c8 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1867,7 +1867,6 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	struct stmt *nstmt;
 	struct expr *nexpr = NULL;
 	enum proto_bases base = left->payload.base;
-	bool stacked;
 
 	payload_expr_expand(&list, left, &ctx->pctx);
 
@@ -1893,7 +1892,8 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(left->payload.base);
 		assert(base == left->payload.base);
 
-		stacked = payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr);
+		if (payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr))
+			base--;
 
 		/* Remember the first payload protocol expression to
 		 * kill it later on if made redundant by a higher layer
@@ -1902,12 +1902,12 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
 		    expr->op == OP_EQ &&
 		    left->flags & EXPR_F_PROTOCOL) {
-			payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
+			payload_dependency_store(&ctx->pdctx, nstmt, base);
 		} else {
 			payload_dependency_kill(&ctx->pdctx, nexpr->left,
 						ctx->pctx.family);
 			if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
+				payload_dependency_store(&ctx->pdctx, nstmt, base);
 		}
 	}
 	list_del(&ctx->stmt->list);
-- 
2.34.1

