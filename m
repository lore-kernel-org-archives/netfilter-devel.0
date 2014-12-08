From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] src: generate set members using integer_type in the appropriate byteorder
Date: Mon,  8 Dec 2014 23:24:32 +0100
Message-ID: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37507 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaLHWWS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:22:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rules with header fields that rely on the generic integer datatype
from sets are not matching, eg.

 nft add rule filter input udp length { 9 } counter

This set member is an integer represented in host byte order, which
obviously doesn't match the header field (in network byte order).

Since the integer datatype has no specific byteorder, we have to rely
on the expression byteorder instead when configuring the context,
before we evaluate the list of set members.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h |   16 ++++++++++++++--
 src/evaluate.c       |    4 +++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 59fa5f3..4b96879 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -96,19 +96,31 @@ enum symbol_types {
  * struct expr_ctx - type context for symbol parsing during evaluation
  *
  * @dtype:	expected datatype
+ * @byteorder:	expected byteorder
  * @len:	expected len
  */
 struct expr_ctx {
 	const struct datatype	*dtype;
+	enum byteorder		byteorder;
 	unsigned int		len;
 };
 
+static inline void __expr_set_context(struct expr_ctx *ctx,
+				      const struct datatype *dtype,
+				      enum byteorder byteorder,
+				      unsigned int len)
+{
+	ctx->dtype	= dtype;
+	ctx->byteorder	= byteorder;
+	ctx->len	= len;
+}
+
 static inline void expr_set_context(struct expr_ctx *ctx,
 				    const struct datatype *dtype,
 				    unsigned int len)
 {
-	ctx->dtype = dtype;
-	ctx->len   = len;
+	__expr_set_context(ctx, dtype,
+			   dtype ? dtype->byteorder : BYTEORDER_INVALID, len);
 }
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 00e55b7..0732660 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -238,6 +238,7 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 			mpz_clear(mask);
 			return -1;
 		}
+		(*expr)->byteorder = ctx->ectx.byteorder;
 		(*expr)->len = ctx->ectx.len;
 		mpz_clear(mask);
 		break;
@@ -261,7 +262,8 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
  */
 static int expr_evaluate_primary(struct eval_ctx *ctx, struct expr **expr)
 {
-	expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->len);
+	__expr_set_context(&ctx->ectx, (*expr)->dtype, (*expr)->byteorder,
+			   (*expr)->len);
 	return 0;
 }
 
-- 
1.7.10.4

