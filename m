From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/2 v3] evaluate: reject: check in bridge and inet the network context in reject
Date: Wed, 22 Oct 2014 15:25:53 +0200
Message-ID: <1413984353-16029-2-git-send-email-alvaroneay@gmail.com>
References: <1413984353-16029-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50017 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaJVNZi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:25:38 -0400
Received: by mail-wi0-f169.google.com with SMTP id r20so1270160wiv.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2014 06:25:37 -0700 (PDT)
In-Reply-To: <1413984353-16029-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In Inet tables, we have to check the network context in rules that we use
icmp or icmpv6 reason in reject. To be sure that the context is the correct.
However, for icmpx and tcp reject, we don't need to check it.

In Bridge tables, ee have vlan and arp traffic and they are not supported.
For this things, we have to check the network context. For example:

  nft add rule bridge test-bridge input \
			ether type arp reject with icmp type host-unreachable
or
  nft add rule bridge test-bridge input \
  			ether type vlan reject with tcp reset

In that cases, we have to throw an error. Moreover, we have to accept rules
that the network context is Ipv4 and Ipv6. For example:

  nft add rule -nnn bridge test-bridge input \
			ip protocol tcp reject with tcp reset

Moreover, this patch refactor the code for check the family for bridge and inet
tables.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
 * Join the refactor patch with this fix patch. To make more clean the solution.

 src/evaluate.c |  168 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 117 insertions(+), 51 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 977f6b4..63ba82e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1202,12 +1202,124 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 	return 0;
 }
 
-static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
-				       struct expr *expr)
+static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
+					    struct stmt *stmt,
+					    const struct proto_desc *desc)
 {
-	const struct proto_desc *desc, *base;
+	const struct proto_desc *base;
 	int protocol;
 
+	switch (stmt->reject.type) {
+	case NFT_REJECT_TCP_RST:
+		break;
+	case NFT_REJECT_ICMPX_UNREACH:
+		return stmt_error(ctx, stmt,
+				  "conflicting network protocol specified");
+	case NFT_REJECT_ICMP_UNREACH:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case NFPROTO_IPV4:
+			if (stmt->reject.family == NFPROTO_IPV4)
+				break;
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		case NFPROTO_IPV6:
+			if (stmt->reject.family == NFPROTO_IPV6)
+				break;
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		default:
+			BUG("unsupported family");
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
+				     struct expr *expr)
+{
+	const struct proto_desc *desc;
+
+	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (desc != NULL &&
+	    stmt_evaluate_reject_inet_family(ctx, stmt, desc) < 0)
+		return -1;
+	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+		return 0;
+	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		return -1;
+	return 0;
+}
+
+static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
+					      struct stmt *stmt,
+					      const struct proto_desc *desc)
+{
+	const struct proto_desc *base;
+	int protocol;
+
+	switch (stmt->reject.type) {
+	case NFT_REJECT_ICMPX_UNREACH:
+		return stmt_error(ctx, stmt,
+				  "conflicting network protocol specified");
+	case NFT_REJECT_TCP_RST:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case __constant_htons(ETH_P_IP):
+		case __constant_htons(ETH_P_IPV6):
+			break;
+		default:
+			return stmt_error(ctx, stmt,
+					  "cannot reject this ether type");
+		}
+		break;
+	case NFT_REJECT_ICMP_UNREACH:
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case __constant_htons(ETH_P_IP):
+			if (NFPROTO_IPV4 == stmt->reject.family)
+				break;
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		case __constant_htons(ETH_P_IPV6):
+			if (NFPROTO_IPV6 == stmt->reject.family)
+				break;
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		default:
+			return stmt_error(ctx, stmt,
+					  "cannot reject this ether type");
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
+				       struct expr *expr)
+{
+	const struct proto_desc *desc;
+
+	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (desc != NULL &&
+	    stmt_evaluate_reject_bridge_family(ctx, stmt, desc) < 0)
+		return -1;
+	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+		return 0;
+	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		return -1;
+	return 0;
+}
+
+static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
+				       struct expr *expr)
+{
 	switch (ctx->pctx.family) {
 	case NFPROTO_ARP:
 		return stmt_error(ctx, stmt, "cannot use reject with arp");
@@ -1229,57 +1341,11 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 		}
 		break;
 	case NFPROTO_BRIDGE:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-		if (desc != NULL) {
-			protocol = proto_find_num(base, desc);
-			switch (protocol) {
-			case __constant_htons(ETH_P_IP):
-				if (NFPROTO_IPV4 == stmt->reject.family)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-			case __constant_htons(ETH_P_IPV6):
-				if (NFPROTO_IPV6 == stmt->reject.family)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-			default:
-				return stmt_error(ctx, stmt,
-						"cannot reject this ether type");
-			}
-			break;
-		}
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
-			break;
-		if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		if (stmt_evaluate_reject_bridge(ctx, stmt, expr) < 0)
 			return -1;
 		break;
 	case NFPROTO_INET:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-		if (desc != NULL) {
-			protocol = proto_find_num(base, desc);
-			switch (protocol) {
-			case NFPROTO_IPV4:
-				if (stmt->reject.family == NFPROTO_IPV4)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-				break;
-			case NFPROTO_IPV6:
-				if (stmt->reject.family == NFPROTO_IPV6)
-					break;
-				return stmt_error(ctx, stmt,
-				  "conflicting protocols specified: ip vs ip6");
-			default:
-				BUG("unsupported family");
-			}
-			break;
-		}
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
-			break;
-		if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
+		if (stmt_evaluate_reject_inet(ctx, stmt, expr) < 0)
 			return -1;
 		break;
 	}
-- 
1.7.10.4

