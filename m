Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472A8C48BE5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 16:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D16A6148E
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 16:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhFOQEK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 12:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhFOQEH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 12:04:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27763C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 09:02:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltBVp-0001Jt-Kk; Tue, 15 Jun 2021 18:02:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 1/3] netlink_delinearize: add missing icmp id/sequence support
Date:   Tue, 15 Jun 2021 18:01:49 +0200
Message-Id: <20210615160151.10594-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615160151.10594-1-fw@strlen.de>
References: <20210615160151.10594-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo reports following input and output:
in: icmpv6 id 1
out: icmpv6 type { echo-request, echo-reply } icmpv6 parameter-problem 65536/16

Reason is that icmp fields overlap, decoding of the correct name requires
check of the icmpv6 type.  This only works for equality tests, for
instance

in: icmpv6 type echo-request icmpv6 id 1
will be listed as "icmpv6 id 1" (which is not correct either, since the
input only matches on echo-request).

with this patch, output of 'icmpv6 id 1' is
icmpv6 type { echo-request, echo-reply } icmpv6 id 1

The second problem, the removal of a single check (request OR reply),
is resolved in the followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: make sure dependency set candidate a) has elements and b) is
 anonymous.

 src/netlink_delinearize.c | 68 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9a1cf3c4f7d9..2785a9490682 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1819,9 +1819,6 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	enum proto_bases base = left->payload.base;
 	bool stacked;
 
-	if (ctx->pdctx.icmp_type)
-		ctx->pctx.th_dep.icmp.type = ctx->pdctx.icmp_type;
-
 	payload_expr_expand(&list, left, &ctx->pctx);
 
 	list_for_each_entry(left, &list, list) {
@@ -1868,6 +1865,58 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 	ctx->stmt = NULL;
 }
 
+static void payload_icmp_check(struct rule_pp_ctx *rctx, struct expr *expr, const struct expr *value)
+{
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc;
+	uint8_t icmp_type;
+	unsigned int i;
+
+	assert(expr->etype == EXPR_PAYLOAD);
+	assert(value->etype == EXPR_VALUE);
+
+	if (expr->payload.base != PROTO_BASE_TRANSPORT_HDR)
+		return;
+
+	/* icmp(v6) type is 8 bit, if value is smaller or larger, this is not
+	 * a protocol dependency.
+	 */
+	if (expr->len != 8 || value->len != 8 || rctx->pctx.th_dep.icmp.type)
+		return;
+
+	desc = rctx->pctx.protocol[expr->payload.base].desc;
+	if (desc == NULL)
+		return;
+
+	/* not icmp? ignore. */
+	if (desc != &proto_icmp && desc != &proto_icmp6)
+		return;
+
+	assert(desc->base == expr->payload.base);
+
+	icmp_type = mpz_get_uint8(value->value);
+
+	for (i = 1; i < array_size(desc->templates); i++) {
+		tmpl = &desc->templates[i];
+
+		if (tmpl->len == 0)
+			return;
+
+		if (tmpl->offset != expr->payload.offset ||
+		    tmpl->len != expr->len)
+			continue;
+
+		/* Matches but doesn't load a protocol key -> ignore. */
+		if (desc->protocol_key != i)
+			return;
+
+		expr->payload.desc = desc;
+		expr->payload.tmpl = tmpl;
+		rctx->pctx.th_dep.icmp.type = icmp_type;
+		return;
+	}
+}
+
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct expr *expr,
 				      struct expr *payload)
@@ -1883,6 +1932,19 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		if (expr->right->etype == EXPR_VALUE) {
 			payload_match_expand(ctx, expr, payload);
 			break;
+		} else if (expr->right->etype == EXPR_SET_REF) {
+			struct set *set = expr->right->set;
+
+			if (set_is_anonymous(set->flags) &&
+			    !list_empty(&set->init->expressions)) {
+				struct expr *elem;
+
+				elem = list_first_entry(&set->init->expressions, struct expr, list);
+
+				if (elem->etype == EXPR_SET_ELEM &&
+				    elem->key->etype == EXPR_VALUE)
+					payload_icmp_check(ctx, payload, elem->key);
+			}
 		}
 		/* Fall through */
 	default:
-- 
2.31.1

