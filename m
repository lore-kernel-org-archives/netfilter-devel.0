From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 3/7] exthdr: prepare exthdr_gen_dependency for tcp support
Date: Tue,  7 Feb 2017 03:14:11 +0100
Message-ID: <20170207021415.22460-4-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:47322 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751414AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id EC01EB0122
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:30 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently exthdr always needs ipv6 dependency (i.e. link layer), but
with upcomming TCP option matching we also need to include TCP at the
network layer.

This patch prepares this change by adding two parameters to
exthdr_gen_dependency.

Signed-off-by: Manuel Messner <mm@skelett.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h | 3 ++-
 src/evaluate.c    | 9 +++++----
 src/payload.c     | 9 +++++----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index bda3188..5952b24 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -16,7 +16,8 @@ struct stmt;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
 extern int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
-				  struct stmt **res);
+				 const struct proto_desc *dependency,
+				 enum proto_bases pb, struct stmt **res);
 
 /**
  * struct payload_dep_ctx - payload protocol dependency tracking
diff --git a/src/evaluate.c b/src/evaluate.c
index 94412f2..0e02548 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -448,19 +448,20 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
  */
 static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 {
-	const struct proto_desc *base;
+	const struct proto_desc *base, *dependency = &proto_ip6;
+	enum proto_bases pb = PROTO_BASE_NETWORK_HDR;
 	struct expr *expr = *exprp;
 	struct stmt *nstmt;
 
-	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-	if (base == &proto_ip6)
+	base = ctx->pctx.protocol[pb].desc;
+	if (base == dependency)
 		return __expr_evaluate_exthdr(ctx, exprp);
 
 	if (base)
 		return expr_error(ctx->msgs, expr,
 				  "cannot use exthdr with %s", base->name);
 
-	if (exthdr_gen_dependency(ctx, expr, &nstmt) < 0)
+	if (exthdr_gen_dependency(ctx, expr, dependency, pb - 1, &nstmt) < 0)
 		return -1;
 
 	list_add(&nstmt->list, &ctx->rule->stmts);
diff --git a/src/payload.c b/src/payload.c
index 74f8254..efd1960 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -317,18 +317,19 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 }
 
 int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
-			  struct stmt **res)
+			  const struct proto_desc *dependency,
+			  enum proto_bases pb, struct stmt **res)
 {
 	const struct proto_desc *desc;
 
-	desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+	desc = ctx->pctx.protocol[pb].desc;
 	if (desc == NULL)
 		return expr_error(ctx->msgs, expr,
 				  "Cannot generate dependency: "
 				  "no %s protocol specified",
-				  proto_base_names[PROTO_BASE_LL_HDR]);
+				  proto_base_names[pb]);
 
-	return payload_add_dependency(ctx, desc, &proto_ip6, expr, res);
+	return payload_add_dependency(ctx, desc, dependency, expr, res);
 }
 
 /**
-- 
2.11.1

