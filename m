Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7058C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 21:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D54E6024A
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 21:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBAVu7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 16:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhBAVu4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 16:50:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4416C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 13:50:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l6h5K-0004HB-A5; Mon, 01 Feb 2021 22:50:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <eric@garver.life>,
        Michael Biebl <biebl@debian.org>
Subject: [PATCH nft 2/2] payload: check icmp dependency before removing previous icmp expression
Date:   Mon,  1 Feb 2021 22:50:04 +0100
Message-Id: <20210201215005.26612-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201215005.26612-1-fw@strlen.de>
References: <20210201215005.26612-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft is too greedy when removing icmp dependencies.
'icmp code 1 type 2' did remove the type when printing.

Be more careful and check that the icmp type dependency of the
candidate expression (earlier icmp payload expression) has the same
type dependency as the new expression.

Reported-by: Eric Garver <eric@garver.life>
Reported-by: Michael Biebl <biebl@debian.org>
Fixes: d0f3b9eaab8d77e ("payload: auto-remove simple icmp/icmpv6 dependency expressions")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 63 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 48529bcf5c51..a77ca5500550 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -627,6 +627,40 @@ void payload_dependency_release(struct payload_dep_ctx *ctx)
 	ctx->pdep  = NULL;
 }
 
+static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
+{
+	switch (t) {
+	case PROTO_ICMP_ANY:
+		BUG("Invalid map for simple dependency");
+	case PROTO_ICMP_ECHO: return ICMP_ECHO;
+	case PROTO_ICMP6_ECHO: return ICMP6_ECHO_REQUEST;
+	case PROTO_ICMP_MTU: return ICMP_DEST_UNREACH;
+	case PROTO_ICMP_ADDRESS: return ICMP_REDIRECT;
+	case PROTO_ICMP6_MTU: return ICMP6_PACKET_TOO_BIG;
+	case PROTO_ICMP6_MGMQ: return MLD_LISTENER_QUERY;
+	case PROTO_ICMP6_PPTR: return ICMP6_PARAM_PROB;
+	}
+
+	BUG("Missing icmp type mapping");
+}
+
+static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	const struct expr *dep = ctx->pdep->expr;
+	uint8_t icmp_type;
+
+	icmp_type = expr->payload.tmpl->icmp_dep;
+	if (icmp_type == PROTO_ICMP_ANY)
+		return false;
+
+	if (dep->left->payload.desc != expr->payload.desc)
+		return false;
+
+	icmp_type = icmp_dep_to_type(expr->payload.tmpl->icmp_dep);
+
+	return ctx->icmp_type == icmp_type;
+}
+
 static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 					unsigned int family, struct expr *expr)
 {
@@ -661,6 +695,14 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 		break;
 	}
 
+	if (expr->payload.base == PROTO_BASE_TRANSPORT_HDR &&
+	    dep->left->payload.base == PROTO_BASE_TRANSPORT_HDR) {
+		if (dep->left->payload.desc == &proto_icmp)
+			return payload_may_dependency_kill_icmp(ctx, expr);
+		if (dep->left->payload.desc == &proto_icmp6)
+			return payload_may_dependency_kill_icmp(ctx, expr);
+	}
+
 	return true;
 }
 
@@ -680,10 +722,6 @@ void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 	if (payload_dependency_exists(ctx, expr->payload.base) &&
 	    payload_may_dependency_kill(ctx, family, expr))
 		payload_dependency_release(ctx);
-	else if (ctx->icmp_type && ctx->pdep) {
-		fprintf(stderr, "Did not kill \n");
-		payload_dependency_release(ctx);
-	}
 }
 
 void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
@@ -707,23 +745,6 @@ void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 	}
 }
 
-static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
-{
-	switch (t) {
-	case PROTO_ICMP_ANY:
-		BUG("Invalid map for simple dependency");
-	case PROTO_ICMP_ECHO: return ICMP_ECHO;
-	case PROTO_ICMP6_ECHO: return ICMP6_ECHO_REQUEST;
-	case PROTO_ICMP_MTU: return ICMP_DEST_UNREACH;
-	case PROTO_ICMP_ADDRESS: return ICMP_REDIRECT;
-	case PROTO_ICMP6_MTU: return ICMP6_PACKET_TOO_BIG;
-	case PROTO_ICMP6_MGMQ: return MLD_LISTENER_QUERY;
-	case PROTO_ICMP6_PPTR: return ICMP6_PARAM_PROB;
-	}
-
-	BUG("Missing icmp type mapping");
-}
-
 /**
  * payload_expr_complete - fill in type information of a raw payload expr
  *
-- 
2.26.2

