From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 nft] src: add new netdev protocol description
Date: Mon, 28 Dec 2015 12:52:52 +0100
Message-ID: <1451303574-14510-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54848 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbbL1LxM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 06:53:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1BC371324C0
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0CF2BDA808
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CF712DA7FF
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch relies on NFT_META_PROTOCOL instead of ethernet protocol type
header field to prepare support for non-ethernet protocols in the
future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h |  2 ++
 src/evaluate.c  |  2 +-
 src/meta.c      | 18 +++++++++++++++++-
 src/payload.c   | 13 ++++++++++++-
 src/proto.c     | 19 ++++++++++++++++++-
 5 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index d90bccd..c252a67 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -308,6 +308,8 @@ extern const struct proto_desc proto_arp;
 extern const struct proto_desc proto_vlan;
 extern const struct proto_desc proto_eth;
 
+extern const struct proto_desc proto_netdev;
+
 extern const struct proto_desc proto_unknown;
 extern const struct proto_hdr_template proto_unknown_template;
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 7aab6aa..6277f14 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -365,7 +365,7 @@ static bool supersede_dep(const struct proto_desc *have,
 	if (payload->payload.base != PROTO_BASE_LL_HDR || have->length)
 		return false;
 
-	if (have != &proto_inet)
+	if (have != &proto_inet && have != &proto_netdev)
 		return false;
 
 	return true;
diff --git a/src/meta.c b/src/meta.c
index d31d292..8cbc974 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -470,7 +470,9 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 
 	switch (left->meta.key) {
 	case NFT_META_IIFTYPE:
-		if (h->base < PROTO_BASE_NETWORK_HDR && ctx->family != NFPROTO_INET)
+		if (h->base < PROTO_BASE_NETWORK_HDR &&
+		    ctx->family != NFPROTO_INET &&
+		    ctx->family != NFPROTO_NETDEV)
 			return;
 
 		desc = proto_dev_desc(mpz_get_uint16(right->value));
@@ -494,6 +496,16 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 
 		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc);
 		break;
+	case NFT_META_PROTOCOL:
+		if (h->base < PROTO_BASE_NETWORK_HDR && ctx->family != NFPROTO_NETDEV)
+			return;
+
+		desc = proto_find_upper(h->desc, ntohs(mpz_get_uint16(right->value)));
+		if (desc == NULL)
+			desc = &proto_unknown;
+
+		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
+		break;
 	default:
 		break;
 	}
@@ -529,6 +541,10 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 		expr->flags |= EXPR_F_PROTOCOL;
 		expr->meta.base = PROTO_BASE_NETWORK_HDR;
 		break;
+	case NFT_META_PROTOCOL:
+		expr->flags |= EXPR_F_PROTOCOL;
+		expr->meta.base = PROTO_BASE_LL_HDR;
+		break;
 	default:
 		break;
 	}
diff --git a/src/payload.c b/src/payload.c
index fe91ee0..6a977e8 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -233,7 +233,6 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 			}
 			break;
 		case NFPROTO_BRIDGE:
-		case NFPROTO_NETDEV:
 			switch (expr->payload.base) {
 			case PROTO_BASE_LL_HDR:
 				desc = &proto_eth;
@@ -245,6 +244,18 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				break;
 			}
 			break;
+		case NFPROTO_NETDEV:
+			switch (expr->payload.base) {
+			case PROTO_BASE_LL_HDR:
+				desc = &proto_netdev;
+				break;
+			case PROTO_BASE_TRANSPORT_HDR:
+				desc = &proto_inet_service;
+				break;
+			default:
+				break;
+			}
+			break;
 		}
 	}
 
diff --git a/src/proto.c b/src/proto.c
index 68d635f..3282271 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -123,7 +123,7 @@ const struct proto_desc *proto_dev_desc(uint16_t type)
 
 const struct hook_proto_desc hook_proto_desc[] = {
 	[NFPROTO_BRIDGE]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_eth),
-	[NFPROTO_NETDEV]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_eth),
+	[NFPROTO_NETDEV]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_netdev),
 	[NFPROTO_INET]		= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_inet),
 	[NFPROTO_IPV4]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip),
 	[NFPROTO_IPV6]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip6),
@@ -806,6 +806,23 @@ const struct proto_desc proto_eth = {
 	},
 };
 
+/*
+ * Dummy protocol for netdev tables.
+ */
+const struct proto_desc proto_netdev = {
+	.name		= "netdev",
+	.base		= PROTO_BASE_LL_HDR,
+	.protocols	= {
+		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
+		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
+	},
+	.templates	= {
+		[0]	= PROTO_META_TEMPLATE("protocol", &ethertype_type, NFT_META_PROTOCOL, 16),
+	},
+};
+
 static void __init proto_init(void)
 {
 	datatype_register(&icmp_type_type);
-- 
2.1.4

