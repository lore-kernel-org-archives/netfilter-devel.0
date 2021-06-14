Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46CCC48BE8
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 13:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6B2F6128A
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Jun 2021 13:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhFNNMT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 09:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhFNNMS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 09:12:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECB1C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2021 06:10:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lsmM0-0000LV-Eo; Mon, 14 Jun 2021 15:10:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/3] fix icmpv6 id dependeny handling
Date:   Mon, 14 Jun 2021 15:10:03 +0200
Message-Id: <20210614131006.26490-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo reports following input and output:
in: icmpv6 id 1
out: icmpv6 type { echo-request, echo-reply } icmpv6 parameter-problem 65536/16

First patch fixes delinearization to handle this correctly.
Second patch fixes a bug related to dependency removal.
Third patch adds test cases for this bug.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 66 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9a1cf3c4f7d9..94f68c956018 100644
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
@@ -1868,6 +1865,61 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
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
+	if (rctx->pctx.th_dep.icmp.type)
+		return;
+
+	/* icmp(v6) type is 8 bit, if value is smaller or larger, this is not
+	 * a protocol dependency.
+	 */
+	if (value->len != 8)
+		return;
+
+	if (expr->payload.base != PROTO_BASE_TRANSPORT_HDR)
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
@@ -1883,6 +1935,14 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		if (expr->right->etype == EXPR_VALUE) {
 			payload_match_expand(ctx, expr, payload);
 			break;
+		} else if (expr->right->etype == EXPR_SET_REF) {
+			struct expr *elem;
+
+			elem = list_first_entry(&expr->right->set->init->expressions, struct expr, list);
+
+			if (elem->etype == EXPR_SET_ELEM &&
+			    elem->key->etype == EXPR_VALUE)
+				payload_icmp_check(ctx, payload, elem->key);
 		}
 		/* Fall through */
 	default:
-- 
2.31.1



