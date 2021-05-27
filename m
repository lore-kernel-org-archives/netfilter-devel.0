Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD0EC47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F85E613BF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 15:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhE0PpH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 11:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbhE0PpG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 11:45:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799EAC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 27 May 2021 08:43:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lmIAV-0003Ny-TT; Thu, 27 May 2021 17:43:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/6] src: add proto ctx options
Date:   Thu, 27 May 2021 17:43:18 +0200
Message-Id: <20210527154323.4003-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210527154323.4003-1-fw@strlen.de>
References: <20210527154323.4003-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new option flag member and the needed function signature changes
to initialise it.  No changes in behaviour.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/proto.h           | 6 ++++--
 src/evaluate.c            | 3 ++-
 src/netlink.c             | 2 +-
 src/netlink_delinearize.c | 2 +-
 src/proto.c               | 4 +++-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index b9217588f3e3..001b6f9436f7 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -171,7 +171,8 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
 /**
  * struct proto_ctx - protocol context
  *
- * debug_mask:	display debugging information
+ * @debug_mask:	display debugging information
+ * @options	option flags to control proto decoding
  * @family:	hook family
  * @location:	location of the relational expression defining the context
  * @desc:	protocol description for this layer
@@ -183,6 +184,7 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
  */
 struct proto_ctx {
 	unsigned int			debug_mask;
+	uint8_t				options;
 	uint8_t				family;
 	union {
 		struct {
@@ -202,7 +204,7 @@ struct proto_ctx {
 };
 
 extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
-			   unsigned int debug_mask);
+			   unsigned int debug_mask, unsigned int proto_options);
 extern void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			     const struct location *loc,
 			     const struct proto_desc *desc);
diff --git a/src/evaluate.c b/src/evaluate.c
index 384e2fa786e0..6bfc464e677a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4090,7 +4090,8 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	proto_ctx_init(&ctx->pctx, rule->handle.family, ctx->nft->debug_mask);
+	proto_ctx_init(&ctx->pctx, rule->handle.family, ctx->nft->debug_mask,
+		       0);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
 	ctx->rule = rule;
diff --git a/src/netlink.c b/src/netlink.c
index 6b6fe27762d5..a307eb32c136 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1868,7 +1868,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt,
 				 meta_expr_alloc(&netlink_location,
 						 NFT_META_OIF), octx);
 
-	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY), 0);
+	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY), 0, 0);
 	ll_desc = ctx.protocol[PROTO_BASE_LL_HDR].desc;
 	if ((ll_desc == &proto_inet || ll_desc  == &proto_netdev) &&
 	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NFPROTO)) {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a71d06d7fe12..6e907e95dbf1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2820,7 +2820,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	struct stmt *stmt, *next;
 
 	memset(&rctx, 0, sizeof(rctx));
-	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask);
+	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask, 0);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		enum stmt_types type = stmt->ops->type;
diff --git a/src/proto.c b/src/proto.c
index 63727605a20a..302a51f242ed 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -169,7 +169,8 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
  * @debug_mask:	display debugging information
  */
 void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
-		    unsigned int debug_mask)
+		    unsigned int debug_mask,
+		    unsigned int proto_options)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[family];
 
@@ -177,6 +178,7 @@ void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
 	ctx->family = family;
 	ctx->protocol[h->base].desc = h->desc;
 	ctx->debug_mask = debug_mask;
+	ctx->options = proto_options;
 
 	proto_ctx_debug(ctx, h->base, debug_mask);
 }
-- 
2.26.3

