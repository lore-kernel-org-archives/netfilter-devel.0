From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 12/12] meta: add l4proto support
Date: Wed,  8 Jan 2014 13:09:03 +0000
Message-ID: <1389186543-6919-13-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40205 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaAHNJY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:24 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the meta l4proto type. This is used in the inet table to
match on the transport layer protocol without requiring the network layer
protocol to be known, allowing to use transport header matches that apply
to both IPv4 and IPv6.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/proto.h |  1 +
 src/meta.c      | 14 ++++++++++++++
 src/parser.y    |  2 ++
 src/payload.c   |  6 ++++++
 src/proto.c     | 25 +++++++++++++++++++++++++
 src/scanner.l   |  1 +
 6 files changed, 49 insertions(+)

diff --git a/include/proto.h b/include/proto.h
index 772f9ed..bd3701e 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -291,6 +291,7 @@ extern const struct proto_desc proto_ip;
 extern const struct proto_desc proto_ip6;
 
 extern const struct proto_desc proto_inet;
+extern const struct proto_desc proto_inet_service;
 
 extern const struct proto_desc proto_arp;
 
diff --git a/src/meta.c b/src/meta.c
index 1286569..d7b024b 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -303,6 +303,8 @@ static const struct meta_template meta_templates[] = {
 						2 * 8, BYTEORDER_BIG_ENDIAN),
 	[NFT_META_NFPROTO]	= META_TEMPLATE("nfproto",   &nfproto_type,
 						1 * 8, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_L4PROTO]	= META_TEMPLATE("l4proto",   &inet_protocol_type,
+						1 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_PRIORITY]	= META_TEMPLATE("priority",  &tchandle_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_MARK]		= META_TEMPLATE("mark",      &mark_type,
@@ -378,6 +380,14 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 
 		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
 		break;
+	case NFT_META_L4PROTO:
+		desc = proto_find_upper(&proto_inet_service,
+					mpz_get_uint8(right->value));
+		if (desc == NULL)
+			desc = &proto_unknown;
+
+		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR, &expr->location, desc);
+		break;
 	default:
 		break;
 	}
@@ -408,6 +418,10 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 		expr->flags |= EXPR_F_PROTOCOL;
 		expr->meta.base = PROTO_BASE_LL_HDR;
 		break;
+	case NFT_META_L4PROTO:
+		expr->flags |= EXPR_F_PROTOCOL;
+		expr->meta.base = PROTO_BASE_NETWORK_HDR;
+		break;
 	default:
 		break;
 	}
diff --git a/src/parser.y b/src/parser.y
index aed00c7..7c18875 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -282,6 +282,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token META			"meta"
 %token NFPROTO			"nfproto"
+%token L4PROTO			"l4proto"
 %token MARK			"mark"
 %token IIF			"iif"
 %token IIFNAME			"iifname"
@@ -1378,6 +1379,7 @@ meta_expr		:	META	meta_key
 
 meta_key		:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	NFPROTO		{ $$ = NFT_META_NFPROTO; }
+			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
 			|	MARK		{ $$ = NFT_META_MARK; }
diff --git a/src/payload.c b/src/payload.c
index ac441d4..a312e07 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -174,6 +174,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	}
 
 	desc = ctx->pctx.protocol[expr->payload.base - 1].desc;
+	/* Special case for mixed IPv4/IPv6 tables: use meta L4 proto */
+	if (desc == NULL &&
+	    ctx->pctx.family == NFPROTO_INET &&
+	    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
+		desc = &proto_inet_service;
+
 	if (desc == NULL)
 		return expr_error(ctx, expr,
 				  "ambiguous payload specification: "
diff --git a/src/proto.c b/src/proto.c
index 81fe6cf..56fb793 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -626,6 +626,31 @@ const struct proto_desc proto_inet = {
 };
 
 /*
+ * Dummy protocol for cases where the network layer protocol isn't known
+ * (IPv4 or IPv6), The higher layer protocols are the protocols common to
+ * both.
+ */
+
+const struct proto_desc proto_inet_service = {
+	.name		= "inet-service",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	= 0,
+	.protocols	= {
+		PROTO_LINK(IPPROTO_ESP,		&proto_esp),
+		PROTO_LINK(IPPROTO_AH,		&proto_ah),
+		PROTO_LINK(IPPROTO_COMP,	&proto_comp),
+		PROTO_LINK(IPPROTO_UDP,		&proto_udp),
+		PROTO_LINK(IPPROTO_UDPLITE,	&proto_udplite),
+		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
+		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
+		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+	},
+	.templates	= {
+		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
+	},
+};
+
+/*
  * ARP
  */
 
diff --git a/src/scanner.l b/src/scanner.l
index 9541eb0..0b8abac 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -372,6 +372,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "meta"			{ return META; }
 "nfproto"		{ return NFPROTO; }
+"l4proto"		{ return L4PROTO; }
 "mark"			{ return MARK; }
 "iif"			{ return IIF; }
 "iifname"		{ return IIFNAME; }
-- 
1.8.4.2

