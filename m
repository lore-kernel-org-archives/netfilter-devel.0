Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06742C1B0D9
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0063225AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E3C0617B0
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:49:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3bC-0004RP-DV; Wed, 09 Dec 2020 18:49:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 07/10] payload: auto-remove simple icmp/icmpv6 dependency expressions
Date:   Wed,  9 Dec 2020 18:49:21 +0100
Message-Id: <20201209174924.27720-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of:
icmpv6 type packet-too-big icmpv6 mtu 1280
display just
icmpv6 mtu 1280

The dependency added for id/sequence is still kept, its handled
by a anon set instead to cover both the echo 'request' and 'reply' cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  4 +++-
 src/netlink_delinearize.c |  3 +++
 src/payload.c             | 50 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 7bbb19b936a9..8bc3fb9a8a54 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -26,11 +26,13 @@ extern int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
  * struct payload_dep_ctx - payload protocol dependency tracking
  *
  * @pbase: protocol base of last dependency match
+ * @icmp_type: extra info for icmp(6) decoding
  * @pdep: last dependency match
  * @prev: previous statement
  */
 struct payload_dep_ctx {
-	enum proto_bases	pbase;
+	enum proto_bases	pbase:8;
+	uint8_t			icmp_type;
 	struct stmt		*pdep;
 	struct stmt		*prev;
 };
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9faddde63974..8b06c4c0985f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1771,6 +1771,9 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	enum proto_bases base = left->payload.base;
 	bool stacked;
 
+	if (ctx->pdctx.icmp_type)
+		ctx->pctx.th_dep.icmp.type = ctx->pdctx.icmp_type;
+
 	payload_expr_expand(&list, left, &ctx->pctx);
 
 	list_for_each_entry(left, &list, list) {
diff --git a/src/payload.c b/src/payload.c
index 7cfa530c06c6..48529bcf5c51 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -98,7 +98,7 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	desc = proto_find_upper(base, proto);
 
 	if (!desc) {
-		if (base == &proto_icmp) {
+		if (base == &proto_icmp || base == &proto_icmp6) {
 			/* proto 0 is ECHOREPLY, just pretend its ECHO.
 			 * Not doing this would need an additional marker
 			 * bit to tell when icmp.type was set.
@@ -554,6 +554,35 @@ void payload_dependency_reset(struct payload_dep_ctx *ctx)
 	memset(ctx, 0, sizeof(*ctx));
 }
 
+static uint8_t icmp_get_type(const struct proto_desc *desc, uint8_t value)
+{
+	if (desc == &proto_icmp && value == 0)
+		return ICMP_ECHO;
+
+	return value;
+}
+
+static uint8_t icmp_get_dep_type(const struct proto_desc *desc, struct expr *right)
+{
+	if (right->etype == EXPR_VALUE && right->len == BITS_PER_BYTE)
+		return icmp_get_type(desc, mpz_get_uint8(right->value));
+
+	return 0;
+}
+
+static void payload_dependency_store_icmp_type(struct payload_dep_ctx *ctx)
+{
+	struct expr *dep = ctx->pdep->expr;
+	const struct proto_desc *desc;
+
+	if (dep->left->etype != EXPR_PAYLOAD)
+		return;
+
+	desc = dep->left->payload.desc;
+	if (desc == &proto_icmp || desc == &proto_icmp6)
+		ctx->icmp_type = icmp_get_dep_type(dep->left->payload.desc, dep->right);
+}
+
 /**
  * payload_dependency_store - store a possibly redundant protocol match
  *
@@ -566,6 +595,8 @@ void payload_dependency_store(struct payload_dep_ctx *ctx,
 {
 	ctx->pbase = base + 1;
 	ctx->pdep  = stmt;
+
+	payload_dependency_store_icmp_type(ctx);
 }
 
 /**
@@ -581,8 +612,8 @@ bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
 			       enum proto_bases base)
 {
 	return ctx->pbase != PROTO_BASE_INVALID &&
-	       ctx->pbase == base &&
-	       ctx->pdep != NULL;
+	       ctx->pdep != NULL &&
+	       (ctx->pbase == base || (base == PROTO_BASE_TRANSPORT_HDR && ctx->pbase == base + 1));
 }
 
 void payload_dependency_release(struct payload_dep_ctx *ctx)
@@ -649,6 +680,10 @@ void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 	if (payload_dependency_exists(ctx, expr->payload.base) &&
 	    payload_may_dependency_kill(ctx, family, expr))
 		payload_dependency_release(ctx);
+	else if (ctx->icmp_type && ctx->pdep) {
+		fprintf(stderr, "Did not kill \n");
+		payload_dependency_release(ctx);
+	}
 }
 
 void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
@@ -716,6 +751,11 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 		if (tmpl->offset != expr->payload.offset ||
 		    tmpl->len    != expr->len)
 			continue;
+
+		if (tmpl->icmp_dep && ctx->th_dep.icmp.type &&
+		    ctx->th_dep.icmp.type != icmp_dep_to_type(tmpl->icmp_dep))
+			continue;
+
 		expr->dtype	   = tmpl->dtype;
 		expr->payload.desc = desc;
 		expr->payload.tmpl = tmpl;
@@ -842,6 +882,10 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 		if (tmpl->offset != expr->payload.offset)
 			continue;
 
+		if (tmpl->icmp_dep && ctx->th_dep.icmp.type &&
+		     ctx->th_dep.icmp.type != icmp_dep_to_type(tmpl->icmp_dep))
+			continue;
+
 		if (tmpl->len <= expr->len) {
 			new = payload_expr_alloc(&expr->location, desc, i);
 			list_add_tail(&new->list, list);
-- 
2.26.2

