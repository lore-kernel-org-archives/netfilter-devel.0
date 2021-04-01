Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51FFC433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7246260240
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhDASSe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbhDASNl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 14:13:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D75AC08EE13
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 07:09:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRy0O-0001ZD-QU; Thu, 01 Apr 2021 16:09:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] payload: be careful on vlan dependency removal
Date:   Thu,  1 Apr 2021 16:08:45 +0200
Message-Id: <20210401140846.24452-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210401140846.24452-1-fw@strlen.de>
References: <20210401140846.24452-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'vlan ...' implies 8021Q frame.  In case the expression tests something else
(802.1AD for example) its not an implictly added one, so keep it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index a77ca5500550..cfa952248a15 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -661,6 +661,24 @@ static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct
 	return ctx->icmp_type == icmp_type;
 }
 
+static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	const struct expr *dep = ctx->pdep->expr;
+
+	/* Never remove a 'vlan type 0x...' expression, they are never added implicitly */
+	if (dep->left->payload.desc == &proto_vlan)
+		return false;
+
+	/* 'vlan id 2' implies 'ether type 8021Q'. If a different protocol is
+	 * tested, this is not a redundant expression.
+	 */
+	if (dep->left->payload.desc == &proto_eth &&
+	    dep->right->etype == EXPR_VALUE && dep->right->len == 16)
+		return mpz_get_uint16(dep->right->value) == ETH_P_8021Q;
+
+	return true;
+}
+
 static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 					unsigned int family, struct expr *expr)
 {
@@ -689,9 +707,14 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 		 * for stacked protocols if we only have protcol type matches.
 		 */
 		if (dep->left->etype == EXPR_PAYLOAD && dep->op == OP_EQ &&
-		    expr->flags & EXPR_F_PROTOCOL &&
-		    expr->payload.base == dep->left->payload.base)
-			return false;
+		    expr->payload.base == dep->left->payload.base) {
+			if (expr->flags & EXPR_F_PROTOCOL)
+				return false;
+
+			if (expr->payload.base == PROTO_BASE_LL_HDR)
+				return payload_may_dependency_kill_ll(ctx, expr);
+		}
+
 		break;
 	}
 
-- 
2.26.3

