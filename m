From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 6/7] payload: automatically kill dependencies for exthdr and tcpopt
Date: Tue,  7 Feb 2017 03:14:14 +0100
Message-ID: <20170207021415.22460-7-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:55148 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751450AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 9B1F8B017A
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:35 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch automatically removes the dependencies for exthdr and tcpopt.

 # nft add rule filter input tcp option maxseg kind 3 counter.
 # nft list table filter input

Before:

 # ip protocol 6 tcp option maxseg kind 3 counter

After:

 # tcp option maxseg kind 3 counter

Thus allowing to write tests as follows:

 # tcp option maxseg kind 3;ok

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Manuel Messner <mm@skelett.io>
---
 include/payload.h         |  2 ++
 src/netlink_delinearize.c |  2 +-
 src/payload.c             | 14 ++++++++++++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/payload.h b/include/payload.h
index 5952b24..a3d2309 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -42,6 +42,8 @@ extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 				      enum proto_bases base);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
 				    struct expr *expr);
+extern void exthdr_dependency_kill(struct payload_dep_ctx *ctx,
+				   struct expr *expr);
 
 extern bool payload_can_merge(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 87010f1..e23c48b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1841,7 +1841,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->key);
 		break;
 	case EXPR_EXTHDR:
-		__payload_dependency_kill(&ctx->pdctx, PROTO_BASE_NETWORK_HDR);
+		exthdr_dependency_kill(&ctx->pdctx, expr);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_META:
diff --git a/src/payload.c b/src/payload.c
index 0207296..169954b 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -410,6 +410,20 @@ void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
 	__payload_dependency_kill(ctx, expr->payload.base);
 }
 
+void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	switch (expr->exthdr.op) {
+	case NFT_EXTHDR_OP_TCPOPT:
+		__payload_dependency_kill(ctx, PROTO_BASE_TRANSPORT_HDR);
+		break;
+	case NFT_EXTHDR_OP_IPV6:
+		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR);
+		break;
+	default:
+		break;
+	}
+}
+
 /**
  * payload_expr_complete - fill in type information of a raw payload expr
  *
-- 
2.11.1

