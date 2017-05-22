From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/4 RFC] payload: Convert AH header expression to exthdr for IPv6
Date: Mon, 22 May 2017 18:49:36 +0200
Message-ID: <20170522164936.28034-5-phil@nwl.cc>
References: <20170522164936.28034-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:33229 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935372AbdEVQuI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2017 12:50:08 -0400
In-Reply-To: <20170522164936.28034-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If protocol context specifies IPv6 on network layer, convert the payload
expression at hand into an exthdr one. OTOH, if network layer protocol
is not IPv4, bail out with an error since it is not clear what the user
wants in this case.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 27cee98916db0..9b28d5266135d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -633,10 +633,40 @@ static bool payload_needs_adjustment(const struct expr *expr)
 	       expr->len % BITS_PER_BYTE != 0;
 }
 
+static int proto_desc2proto(const struct proto_desc *proto_desc)
+{
+	int i;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		if (hook_proto_desc[i].desc == proto_desc)
+			return i;
+	}
+
+	return NFPROTO_NUMPROTO;
+}
+
 static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
 
+	if (expr->payload.desc == &proto_ah) {
+		struct proto_desc *desc =
+			ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		switch (proto_desc2proto(desc)) {
+		case NFPROTO_IPV4:
+			break;
+		case NFPROTO_IPV6:
+			expr = exthdr_expr_alloc(&expr->location, &exthdr_ah,
+						 expr->payload.type);
+			expr_free(*exprp);
+			*exprp = expr;
+			return expr_evaluate(ctx, exprp);
+			break;
+		default:
+			return expr_error(ctx->msgs, expr, "ah header match requires address family to be either IPv4 or IPv6 (got %d)", proto_desc2proto(desc));
+		}
+	}
+
 	if (__expr_evaluate_payload(ctx, expr) < 0)
 		return -1;
 
-- 
2.11.0

