Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9769C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872EC22D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfHUJ1E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:27:04 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43796 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfHUJ1E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 05:27:04 -0400
Received: from localhost ([::1]:56886 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i0MtS-00056t-5g; Wed, 21 Aug 2019 11:27:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/14] nft: Keep nft_handle pointer in nft_xt_ctx
Date:   Wed, 21 Aug 2019 11:25:51 +0200
Message-Id: <20190821092602.16292-4-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190821092602.16292-1-phil@nwl.cc>
References: <20190821092602.16292-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of carrying the family value, carry the handle (which contains
the family value) and relieve expression parsers from having to call
nft_family_ops_lookup().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 40 ++++++++++++++--------------------------
 iptables/nft-shared.h |  2 +-
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 904bc845e6a41..3ab21932f8fe6 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -310,7 +310,6 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	struct xtables_target *target;
 	struct xt_entry_target *t;
 	size_t size;
-	struct nft_family_ops *ops;
 	void *data = ctx->cs;
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
@@ -327,8 +326,7 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 	target->t = t;
 
-	ops = nft_family_ops_lookup(ctx->family);
-	ops->parse_target(target, data);
+	ctx->h->ops->parse_target(target, data);
 }
 
 static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -339,9 +337,8 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	struct xtables_match *match;
 	struct xtables_rule_match **matches;
 	struct xt_entry_match *m;
-	struct nft_family_ops *ops;
 
-	switch (ctx->family) {
+	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
@@ -349,7 +346,7 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		break;
 	default:
 		fprintf(stderr, "BUG: nft_parse_match() unknown family %d\n",
-			ctx->family);
+			ctx->h->family);
 		exit(EXIT_FAILURE);
 	}
 
@@ -365,9 +362,8 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 	match->m = m;
 
-	ops = nft_family_ops_lookup(ctx->family);
-	if (ops->parse_match != NULL)
-		ops->parse_match(match, ctx->cs);
+	if (ctx->h->ops->parse_match != NULL)
+		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
 void print_proto(uint16_t proto, int invert)
@@ -400,7 +396,6 @@ void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv)
 
 static void nft_meta_set_to_target(struct nft_xt_ctx *ctx)
 {
-	const struct nft_family_ops *ops;
 	struct xtables_target *target;
 	struct xt_entry_target *t;
 	unsigned int size;
@@ -429,8 +424,7 @@ static void nft_meta_set_to_target(struct nft_xt_ctx *ctx)
 
 	target->t = t;
 
-	ops = nft_family_ops_lookup(ctx->family);
-	ops->parse_target(target, ctx->cs);
+	ctx->h->ops->parse_target(target, ctx->cs);
 }
 
 static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -474,7 +468,6 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
-	struct nft_family_ops *ops = nft_family_ops_lookup(ctx->family);
 	void *data = ctx->cs;
 	uint32_t reg;
 
@@ -483,12 +476,12 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		return;
 
 	if (ctx->flags & NFT_XT_CTX_META) {
-		ops->parse_meta(ctx, e, data);
+		ctx->h->ops->parse_meta(ctx, e, data);
 		ctx->flags &= ~NFT_XT_CTX_META;
 	}
 	/* bitwise context is interpreted from payload */
 	if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
-		ops->parse_payload(ctx, e, data);
+		ctx->h->ops->parse_payload(ctx, e, data);
 		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
 	}
 }
@@ -502,7 +495,6 @@ static void nft_parse_counter(struct nftnl_expr *e, struct xt_counters *counters
 static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	const char *chain = nftnl_expr_get_str(e, NFTNL_EXPR_IMM_CHAIN);
-	struct nft_family_ops *ops;
 	const char *jumpto = NULL;
 	bool nft_goto = false;
 	void *data = ctx->cs;
@@ -544,8 +536,7 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		break;
 	}
 
-	ops = nft_family_ops_lookup(ctx->family);
-	ops->parse_immediate(jumpto, nft_goto, data);
+	ctx->h->ops->parse_immediate(jumpto, nft_goto, data);
 }
 
 static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -555,11 +546,10 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	__u64 rate = nftnl_expr_get_u64(e, NFTNL_EXPR_LIMIT_RATE);
 	struct xtables_rule_match **matches;
 	struct xtables_match *match;
-	struct nft_family_ops *ops;
 	struct xt_rateinfo *rinfo;
 	size_t size;
 
-	switch (ctx->family) {
+	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_BRIDGE:
@@ -567,7 +557,7 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		break;
 	default:
 		fprintf(stderr, "BUG: nft_parse_limit() unknown family %d\n",
-			ctx->family);
+			ctx->h->family);
 		exit(EXIT_FAILURE);
 	}
 
@@ -586,9 +576,8 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	rinfo->avg = XT_LIMIT_SCALE * unit / rate;
 	rinfo->burst = burst;
 
-	ops = nft_family_ops_lookup(ctx->family);
-	if (ops->parse_match != NULL)
-		ops->parse_match(match, ctx->cs);
+	if (ctx->h->ops->parse_match != NULL)
+		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
 void nft_rule_to_iptables_command_state(const struct nftnl_rule *r,
@@ -596,10 +585,9 @@ void nft_rule_to_iptables_command_state(const struct nftnl_rule *r,
 {
 	struct nftnl_expr_iter *iter;
 	struct nftnl_expr *expr;
-	int family = nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY);
 	struct nft_xt_ctx ctx = {
 		.cs = cs,
-		.family = family,
+		.h = h,
 	};
 
 	iter = nftnl_expr_iter_create(r);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index de889ead7b605..ad5e8cde239f4 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -47,7 +47,7 @@ enum {
 struct nft_xt_ctx {
 	struct iptables_command_state *cs;
 	struct nftnl_expr_iter *iter;
-	int family;
+	struct nft_handle *h;
 	uint32_t flags;
 
 	uint32_t reg;
-- 
2.22.0

