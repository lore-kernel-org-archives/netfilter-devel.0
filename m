Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F4DC4321E
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 13:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiI3NDB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 09:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiI3NC7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 09:02:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2C94176AF3
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:02:57 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 6/6] src: display (inner) tag in --debug=proto-ctx
Date:   Fri, 30 Sep 2022 15:02:48 +0200
Message-Id: <20220930130248.416386-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220930130248.416386-1-pablo@netfilter.org>
References: <20220930130248.416386-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For easier debugging, add decoration on protocol context:

 # nft --debug=proto-ctx add rule netdev x y udp dport 4789 vxlan ip protocol icmp counter
 update link layer protocol context (inner):
  link layer          : netdev <-
  network layer       : none
  transport layer     : none
  payload data        : none

 update network layer protocol context (inner):
  link layer          : netdev
  network layer       : ip <-
  transport layer     : none
  payload data        : none

 update network layer protocol context (inner):
  link layer          : netdev
  network layer       : ip <-
  transport layer     : none
  payload data        : none

 update transport layer protocol context (inner):
  link layer          : netdev
  network layer       : ip
  transport layer     : icmp <-
  payload data        : none

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h           | 3 ++-
 src/evaluate.c            | 4 ++--
 src/netlink.c             | 2 +-
 src/netlink_delinearize.c | 4 ++--
 src/proto.c               | 7 +++++--
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 5bb7562db94b..32e0744854a5 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -190,6 +190,7 @@ extern const struct proto_desc *proto_dev_desc(uint16_t type);
 struct proto_ctx {
 	unsigned int			debug_mask;
 	uint8_t				family;
+	bool				inner;
 	union {
 		struct {
 			uint8_t			type;
@@ -209,7 +210,7 @@ struct proto_ctx {
 };
 
 extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
-			   unsigned int debug_mask);
+			   unsigned int debug_mask, bool inner);
 extern void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			     const struct location *loc,
 			     const struct proto_desc *desc);
diff --git a/src/evaluate.c b/src/evaluate.c
index 253b7b199e49..3a08d5df7681 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4569,9 +4569,9 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	proto_ctx_init(&ctx->_pctx[0], rule->handle.family, ctx->nft->debug_mask);
+	proto_ctx_init(&ctx->_pctx[0], rule->handle.family, ctx->nft->debug_mask, false);
 	/* use NFPROTO_BRIDGE to set up proto_eth as base protocol. */
-	proto_ctx_init(&ctx->_pctx[1], NFPROTO_BRIDGE, ctx->nft->debug_mask);
+	proto_ctx_init(&ctx->_pctx[1], NFPROTO_BRIDGE, ctx->nft->debug_mask, true);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
 	ctx->rule = rule;
diff --git a/src/netlink.c b/src/netlink.c
index 799cf9b8ebef..e38bacf3ac3f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1995,7 +1995,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt,
 				 meta_expr_alloc(&netlink_location,
 						 NFT_META_OIF), octx);
 
-	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY), 0);
+	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY), 0, false);
 	ll_desc = ctx.protocol[PROTO_BASE_LL_HDR].desc;
 	if ((ll_desc == &proto_inet || ll_desc  == &proto_netdev) &&
 	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NFPROTO)) {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9a38a506fe95..ea071aa64d5c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3200,9 +3200,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	struct expr *expr;
 
 	memset(&rctx, 0, sizeof(rctx));
-	proto_ctx_init(&rctx._dl[0].pctx, rule->handle.family, ctx->debug_mask);
+	proto_ctx_init(&rctx._dl[0].pctx, rule->handle.family, ctx->debug_mask, false);
 	/* use NFPROTO_BRIDGE to set up proto_eth as base protocol. */
-	proto_ctx_init(&rctx._dl[1].pctx, NFPROTO_BRIDGE, ctx->debug_mask);
+	proto_ctx_init(&rctx._dl[1].pctx, NFPROTO_BRIDGE, ctx->debug_mask, true);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		enum stmt_types type = stmt->ops->type;
diff --git a/src/proto.c b/src/proto.c
index 1e0476bacffe..e6c1100bb448 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -181,7 +181,9 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
 			pr_debug(" %s", ctx->stacked_ll[i]->name);
 	}
 
-	pr_debug("update %s protocol context:\n", proto_base_names[base]);
+	pr_debug("update %s protocol context%s:\n",
+		 proto_base_names[base], ctx->inner ? " (inner)" : "");
+
 	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
 		pr_debug(" %-20s: %s",
 			 proto_base_names[i],
@@ -202,7 +204,7 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base,
  * @debug_mask:	display debugging information
  */
 void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
-		    unsigned int debug_mask)
+		    unsigned int debug_mask, bool inner)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[family];
 
@@ -210,6 +212,7 @@ void proto_ctx_init(struct proto_ctx *ctx, unsigned int family,
 	ctx->family = family;
 	ctx->protocol[h->base].desc = h->desc;
 	ctx->debug_mask = debug_mask;
+	ctx->inner = inner;
 
 	proto_ctx_debug(ctx, h->base, debug_mask);
 }
-- 
2.30.2

