From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/4 v2] evaluate: fix a crash if we specify ether type or meta nfproto in reject
Date: Fri, 17 Oct 2014 14:24:34 +0200
Message-ID: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45135 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJQMYZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:24:25 -0400
Received: by mail-wg0-f44.google.com with SMTP id y10so789681wgg.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2014 05:24:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we use a rule:
nft add rule bridge filter input \
	ether type ip reject with icmp type host-unreachable

or this:

nft add rule inet filter input \
	meta nfproto ipv4 reject with icmp type host-unreachable

we have a segfault because we add a network dependency when we already have
network context.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* Fixed a incorrect refactor when we check the family in bridge

 src/evaluate.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 83ef749..4b7bda9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
+#include <net/ethernet.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -1193,6 +1194,8 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 		BUG("cannot generate reject dependency for type %d",
 		    stmt->reject.type);
 	}
+	if (payload == NULL)
+		return 0;
 
 	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 		return -1;
@@ -1204,6 +1207,9 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 				       struct expr *expr)
 {
+	const struct proto_desc *desc, *base;
+	int protocol;
+
 	switch (ctx->pctx.family) {
 	case NFPROTO_ARP:
 		return stmt_error(ctx, stmt, "cannot use reject with arp");
@@ -1224,8 +1230,57 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 			break;
 		}
 		break;
-	case NFPROTO_INET:
 	case NFPROTO_BRIDGE:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc != NULL &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			protocol = proto_find_num(base, desc);
+			switch (protocol) {
+			case __constant_htons(ETH_P_IP):
+				if (NFPROTO_IPV4 == stmt->reject.family)
+					break;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+			case __constant_htons(ETH_P_IPV6):
+				if (NFPROTO_IPV6 == stmt->reject.family)
+					break;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+			default:
+				return stmt_error(ctx, stmt,
+						"cannot reject this ether type");
+			}
+			break;
+		}
+		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+			break;
+		if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+			return -1;
+		break;
+	case NFPROTO_INET:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc != NULL &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			protocol = proto_find_num(base, desc);
+			switch (protocol) {
+			case NFPROTO_IPV4:
+				if (stmt->reject.family == NFPROTO_IPV4)
+					break;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+				break;
+			case NFPROTO_IPV6:
+				if (stmt->reject.family == NFPROTO_IPV6)
+					break;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+			default:
+				BUG("unsupported family");
+			}
+			break;
+		}
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
 			break;
 		if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
-- 
1.7.10.4

