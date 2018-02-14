From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 6/6] netlink_delinearize: add meta_may_dependency_kill()
Date: Wed, 14 Feb 2018 16:22:29 +0100
Message-ID: <20180214152229.11830-7-pablo@netfilter.org>
References: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51660 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030767AbeBNPWm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3220211772B
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21B2FDA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 248C1DA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:39 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E0B1A41E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:38 +0100 (CET)
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not exercise dependency removal for protocol key network payload
expressions in bridge, netdev and inet families from meta expressions,
more specifically:

* inet: nfproto and ether type.
* netdev and bridge: meta protocol and ether type.

need to be left in place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b9f195b07d63..82eefa61d4a4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1389,6 +1389,74 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
+/* We have seen a protocol key expression that restricts matching at the network
+ * base, leave it in place since this is meaninful in bridge, inet and netdev
+ * families. Exceptions are ICMP and ICMPv6 where this code assumes that can
+ * only happen with IPv4 and IPv6.
+ */
+static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
+				     unsigned int family,
+				     const struct expr *expr)
+{
+	struct expr *dep = ctx->pdep->expr;
+
+	if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
+		return true;
+
+	switch (family) {
+	case NFPROTO_INET:
+		switch (dep->left->ops->type) {
+		case EXPR_META:
+			if (dep->left->meta.key == NFT_META_NFPROTO &&
+			    (mpz_get_uint16(dep->right->value) == NFPROTO_IPV4 ||
+			     mpz_get_uint16(dep->right->value) == NFPROTO_IPV6) &&
+			    expr->left->meta.key == NFT_META_L4PROTO &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMP &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMPV6)
+				return false;
+			break;
+		case EXPR_PAYLOAD:
+			if (dep->left->payload.base == PROTO_BASE_LL_HDR &&
+			    (mpz_get_uint16(dep->right->value) == ETH_P_IP ||
+			     mpz_get_uint16(dep->right->value) == ETH_P_IPV6) &&
+			    expr->left->meta.key == NFT_META_L4PROTO &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMP &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMPV6)
+				return false;
+			break;
+		default:
+			break;
+		}
+		break;
+	case NFPROTO_NETDEV:
+	case NFPROTO_BRIDGE:
+		switch (dep->left->ops->type) {
+		case EXPR_META:
+			if (dep->left->meta.key == NFT_META_PROTOCOL &&
+			    (mpz_get_uint16(dep->right->value) == ETH_P_IP ||
+			     mpz_get_uint16(dep->right->value) == ETH_P_IPV6) &&
+			    expr->left->meta.key == NFT_META_L4PROTO &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMP &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMPV6)
+				return false;
+			break;
+		case EXPR_PAYLOAD:
+			if (dep->left->payload.base == PROTO_BASE_LL_HDR &&
+			    (mpz_get_uint16(dep->right->value) == ETH_P_IP ||
+			     mpz_get_uint16(dep->right->value) == ETH_P_IPV6) &&
+			    expr->left->meta.key == NFT_META_L4PROTO &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMP &&
+			    mpz_get_uint8(expr->right->value) != IPPROTO_ICMPV6)
+				return false;
+			break;
+		default:
+			break;
+		}
+		break;
+	}
+	return true;
+}
+
 static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 				       const struct expr *expr,
 				       enum proto_bases base)
@@ -1407,7 +1475,9 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
-			if (payload_dependency_exists(&ctx->pdctx, base))
+			if (payload_dependency_exists(&ctx->pdctx, base) &&
+			    meta_may_dependency_kill(&ctx->pdctx,
+						     ctx->pctx.family, expr))
 				payload_dependency_release(&ctx->pdctx);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
-- 
2.11.0

