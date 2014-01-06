From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 11/12] meta: add nfproto support
Date: Mon,  6 Jan 2014 17:27:26 +0000
Message-ID: <1389029247-27697-12-git-send-email-kaber@trash.net>
References: <1389029247-27697-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55588 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbaAFR1m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:27:42 -0500
In-Reply-To: <1389029247-27697-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the meta nfproto type, which refers to the AF from the
netfilter hook ops. This is needed to get the actual family of a packet
in the dummy NFPROTO_INET family.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h |  3 +++
 include/proto.h    |  2 ++
 src/datatype.c     | 18 ++++++++++++++++++
 src/meta.c         | 35 ++++++++++++++++++++++++++---------
 src/parser.y       |  2 ++
 src/payload.c      |  2 +-
 src/proto.c        | 18 ++++++++++++++++++
 src/scanner.l      |  1 +
 8 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 239d5ea..9f8b44a 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -6,6 +6,7 @@
  *
  * @TYPE_INVALID:	uninitialized
  * @TYPE_VERDICT:	nftables verdict
+ * @TYPE_NFPROTO:	netfilter protocol (integer subtype)
  * @TYPE_BITMASK:	bitmask
  * @TYPE_INTEGER:	integer
  * @TYPE_STRING:	string
@@ -37,6 +38,7 @@
 enum datatypes {
 	TYPE_INVALID,
 	TYPE_VERDICT,
+	TYPE_NFPROTO,
 	TYPE_BITMASK,
 	TYPE_INTEGER,
 	TYPE_STRING,
@@ -168,6 +170,7 @@ extern void rt_symbol_table_free(struct symbol_table *tbl);
 
 extern const struct datatype invalid_type;
 extern const struct datatype verdict_type;
+extern const struct datatype nfproto_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
 extern const struct datatype string_type;
diff --git a/include/proto.h b/include/proto.h
index 6a28036..772f9ed 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -290,6 +290,8 @@ extern const struct proto_desc proto_icmp6;
 extern const struct proto_desc proto_ip;
 extern const struct proto_desc proto_ip6;
 
+extern const struct proto_desc proto_inet;
+
 extern const struct proto_desc proto_arp;
 
 extern const struct proto_desc proto_vlan;
diff --git a/src/datatype.c b/src/datatype.c
index 2e5788d..fdcec8d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -26,6 +26,7 @@
 static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_INVALID]		= &invalid_type,
 	[TYPE_VERDICT]		= &verdict_type,
+	[TYPE_NFPROTO]		= &nfproto_type,
 	[TYPE_BITMASK]		= &bitmask_type,
 	[TYPE_INTEGER]		= &integer_type,
 	[TYPE_STRING]		= &string_type,
@@ -204,6 +205,23 @@ const struct datatype verdict_type = {
 	.print		= verdict_type_print,
 };
 
+static const struct symbol_table nfproto_tbl = {
+	.symbols	= {
+		SYMBOL("ipv4",		NFPROTO_IPV4),
+		SYMBOL("ipv6",		NFPROTO_IPV6),
+		SYMBOL_LIST_END
+	},
+};
+
+const struct datatype nfproto_type = {
+	.type		= TYPE_NFPROTO,
+	.name		= "nfproto",
+	.desc		= "netfilter protocol",
+	.size		= 1 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.sym_tbl	= &nfproto_tbl,
+};
+
 const struct datatype bitmask_type = {
 	.type		= TYPE_BITMASK,
 	.name		= "bitmask",
diff --git a/src/meta.c b/src/meta.c
index e0ae950..1286569 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -301,6 +301,8 @@ static const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_PROTOCOL]	= META_TEMPLATE("protocol",  &ethertype_type,
 						2 * 8, BYTEORDER_BIG_ENDIAN),
+	[NFT_META_NFPROTO]	= META_TEMPLATE("nfproto",   &nfproto_type,
+						1 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_PRIORITY]	= META_TEMPLATE("priority",  &tchandle_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_MARK]		= META_TEMPLATE("mark",      &mark_type,
@@ -356,18 +358,29 @@ static void meta_expr_pctx_update(struct proto_ctx *ctx,
 	const struct expr *left = expr->left, *right = expr->right;
 	const struct proto_desc *desc;
 
-	if (left->meta.key != NFT_META_IIFTYPE)
-		return;
-
 	assert(expr->op == OP_EQ);
-	if (h->base < PROTO_BASE_NETWORK_HDR)
-		return;
 
-	desc = proto_dev_desc(mpz_get_uint16(right->value));
-	if (desc == NULL)
-		desc = &proto_unknown;
+	switch (left->meta.key) {
+	case NFT_META_IIFTYPE:
+		if (h->base < PROTO_BASE_NETWORK_HDR)
+			return;
+
+		desc = proto_dev_desc(mpz_get_uint16(right->value));
+		if (desc == NULL)
+			desc = &proto_unknown;
+
+		proto_ctx_update(ctx, PROTO_BASE_LL_HDR, &expr->location, desc);
+		break;
+	case NFT_META_NFPROTO:
+		desc = proto_find_upper(h->desc, mpz_get_uint8(right->value));
+		if (desc == NULL)
+			desc = &proto_unknown;
 
-	proto_ctx_update(ctx, PROTO_BASE_LL_HDR, &expr->location, desc);
+		proto_ctx_update(ctx, PROTO_BASE_NETWORK_HDR, &expr->location, desc);
+		break;
+	default:
+		break;
+	}
 }
 
 static const struct expr_ops meta_expr_ops = {
@@ -391,6 +404,10 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 	case NFT_META_IIFTYPE:
 		expr->flags |= EXPR_F_PROTOCOL;
 		break;
+	case NFT_META_NFPROTO:
+		expr->flags |= EXPR_F_PROTOCOL;
+		expr->meta.base = PROTO_BASE_LL_HDR;
+		break;
 	default:
 		break;
 	}
diff --git a/src/parser.y b/src/parser.y
index 6671804..2e019a1 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -282,6 +282,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token MH			"mh"
 
 %token META			"meta"
+%token NFPROTO			"nfproto"
 %token MARK			"mark"
 %token IIF			"iif"
 %token IIFNAME			"iifname"
@@ -1319,6 +1320,7 @@ meta_expr		:	META	meta_key
 			;
 
 meta_key		:	LENGTH		{ $$ = NFT_META_LEN; }
+			|	NFPROTO		{ $$ = NFT_META_NFPROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
 			|	MARK		{ $$ = NFT_META_MARK; }
diff --git a/src/payload.c b/src/payload.c
index 04a3455..ac441d4 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -197,7 +197,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				    tmpl->len, &protocol);
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-	payload_expr_pctx_update(&ctx->pctx, dep);
+	left->ops->pctx_update(&ctx->pctx, dep);
 	*res = dep;
 	return 0;
 }
diff --git a/src/proto.c b/src/proto.c
index c3fb7bf..81fe6cf 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -123,6 +123,7 @@ const struct proto_desc *proto_dev_desc(uint16_t type)
 
 const struct hook_proto_desc hook_proto_desc[] = {
 	[NFPROTO_BRIDGE]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_eth),
+	[NFPROTO_INET]		= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_inet),
 	[NFPROTO_IPV4]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip),
 	[NFPROTO_IPV6]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip6),
 	[NFPROTO_ARP]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_arp),
@@ -608,6 +609,23 @@ const struct proto_desc proto_ip6 = {
 };
 
 /*
+ * Dummy protocol for mixed IPv4/IPv6 tables. The protocol is set at the link
+ * layer header, the upper layer protocols are IPv4 and IPv6.
+ */
+
+const struct proto_desc proto_inet = {
+	.name		= "inet",
+	.base		= PROTO_BASE_LL_HDR,
+	.protocols	= {
+		PROTO_LINK(NFPROTO_IPV4,	&proto_ip),
+		PROTO_LINK(NFPROTO_IPV6,	&proto_ip6),
+	},
+	.templates	= {
+		[0]	= PROTO_META_TEMPLATE("nfproto", &nfproto_type, NFT_META_NFPROTO, 8),
+	},
+};
+
+/*
  * ARP
  */
 
diff --git a/src/scanner.l b/src/scanner.l
index 0c62729..ce0f32f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -365,6 +365,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "mh"			{ return MH; }
 
 "meta"			{ return META; }
+"nfproto"		{ return NFPROTO; }
 "mark"			{ return MARK; }
 "iif"			{ return IIF; }
 "iifname"		{ return IIFNAME; }
-- 
1.8.4.2

