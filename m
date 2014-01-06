From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 04/12] proto: add helper function to update protocol context
Date: Mon,  6 Jan 2014 17:27:19 +0000
Message-ID: <1389029247-27697-5-git-send-email-kaber@trash.net>
References: <1389029247-27697-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55582 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbaAFR1i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:38 -0500
In-Reply-To: <1389029247-27697-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper function which is to be used to update the protocol update.

Signed-off-by: Patrick McHardy <ksber@trash.net<
---
 include/proto.h |  3 +++
 src/meta.c      |  3 +--
 src/payload.c   |  3 +--
 src/proto.c     | 16 ++++++++++++++++
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 037ef09..de58d4c 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -122,6 +122,9 @@ struct proto_ctx {
 };
 
 extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family);
+extern void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
+			     const struct location *loc,
+			     const struct proto_desc *desc);
 extern const struct proto_desc *proto_find_upper(const struct proto_desc *base,
 						 unsigned int num);
 extern int proto_find_num(const struct proto_desc *base,
diff --git a/src/meta.c b/src/meta.c
index 9173c30..e0ae950 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -367,8 +367,7 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 	if (desc == NULL)
 		desc = &proto_unknown;
 
-	ctx->protocol[PROTO_BASE_LL_HDR].location = expr->location;
-	ctx->protocol[PROTO_BASE_LL_HDR].desc	  = desc;
+	proto_ctx_update(ctx, PROTO_BASE_LL_HDR, &expr->location, desc);
 }
 
 static const struct expr_ops meta_expr_ops = {
diff --git a/src/payload.c b/src/payload.c
index 426adc3..0ef3c79 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -69,8 +69,7 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 	base = ctx->protocol[left->payload.base].desc;
 	desc = proto_find_upper(base, mpz_get_uint32(right->value));
 
-	ctx->protocol[left->payload.base + 1].location = expr->location;
-	ctx->protocol[left->payload.base + 1].desc = desc;
+	proto_ctx_update(ctx, left->payload.base + 1, &expr->location, desc);
 }
 
 static const struct expr_ops payload_expr_ops = {
diff --git a/src/proto.c b/src/proto.c
index c6428e4..f611c97 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -143,6 +143,22 @@ void proto_ctx_init(struct proto_ctx *ctx, unsigned int family)
 	ctx->protocol[h->base].desc = h->desc;
 }
 
+/**
+ * proto_ctx_update: update protocol context for given protocol base
+ *
+ * @ctx:	protocol context
+ * @base:	protocol base
+ * @loc:	location of the relational expression definiting the context
+ * @desc:	protocol description for the given layer
+ */
+void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
+		      const struct location *loc,
+		      const struct proto_desc *desc)
+{
+	ctx->protocol[base].location	= *loc;
+	ctx->protocol[base].desc	= desc;
+}
+
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype,				\
 			   offsetof(__type, __member) * 8,		\
-- 
1.8.4.2

