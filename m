From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 02/12] nftables: generic procotol contexts
Date: Wed,  8 Jan 2014 13:08:53 +0000
Message-ID: <1389186543-6919-3-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40186 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaAHNJO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:14 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the context of higher layer protocols is specific to payload
expressions with some special cases for meta IIFTYPE expressions. This
approach has a few shortcomings, concretely there are more expression
types which define upper layer protocols like the ct expression and two
upcoming new types for the meta expression.

Replace the payload context by a generic protocol context to deal with
this. This patch just splits off the requires parts from the payload
expression without any functional changes, the following patches will
add further functionality for other expressions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/expression.h      |   8 +-
 include/exthdr.h          |   6 +-
 include/meta.h            |   2 +
 include/payload.h         | 280 +---------------
 include/proto.h           | 287 +++++++++++++++++
 include/rule.h            |   2 +-
 src/Makefile.in           |   1 +
 src/evaluate.c            |  16 +-
 src/exthdr.c              |  26 +-
 src/meta.c                |  29 ++
 src/netlink_delinearize.c |  16 +-
 src/parser.y              |  36 +--
 src/payload.c             | 799 ++--------------------------------------------
 src/proto.c               | 731 ++++++++++++++++++++++++++++++++++++++++++
 14 files changed, 1144 insertions(+), 1095 deletions(-)
 create mode 100644 include/proto.h
 create mode 100644 src/proto.c

diff --git a/include/expression.h b/include/expression.h
index d8f2868..2b7b379 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -225,15 +225,15 @@ struct expr {
 
 		struct {
 			/* EXPR_PAYLOAD */
-			const struct payload_desc	*desc;
-			const struct payload_template	*tmpl;
-			enum payload_bases		base;
+			const struct proto_desc		*desc;
+			const struct proto_hdr_template	*tmpl;
+			enum proto_bases		base;
 			unsigned int			offset;
 		} payload;
 		struct {
 			/* EXPR_EXTHDR */
 			const struct exthdr_desc	*desc;
-			const struct payload_template	*tmpl;
+			const struct proto_hdr_template	*tmpl;
 		} exthdr;
 		struct {
 			/* EXPR_META */
diff --git a/include/exthdr.h b/include/exthdr.h
index 62e69bd..87c4285 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -1,17 +1,19 @@
 #ifndef NFTABLES_EXTHDR_H
 #define NFTABLES_EXTHDR_H
 
+#include <proto.h>
+
 /**
  * struct exthdr_desc - extension header description
  *
  * @name:	extension header name
  * @type:	extension header protocol value
- * @templates:	header templates
+ * @templates:	header field templates
  */
 struct exthdr_desc {
 	const char			*name;
 	uint8_t				type;
-	struct payload_template		templates[10];
+	struct proto_hdr_template	templates[10];
 };
 
 extern struct expr *exthdr_expr_alloc(const struct location *loc,
diff --git a/include/meta.h b/include/meta.h
index 459221f..23f78cf 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -25,5 +25,7 @@ struct meta_template {
 
 extern struct expr *meta_expr_alloc(const struct location *loc,
 				    enum nft_meta_keys key);
+extern void meta_expr_pctx_update(struct proto_ctx *ctx,
+				  const struct expr *expr);
 
 #endif /* NFTABLES_META_H */
diff --git a/include/payload.h b/include/payload.h
index fa8d82e..54d8d54 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -2,128 +2,16 @@
 #define NFTABLES_PAYLOAD_H
 
 #include <nftables.h>
-
-/**
- * enum payload_bases
- *
- * @PAYLOAD_BASE_INVALID:	uninitialised, does not happen
- * @PAYLOAD_BASE_LL_HDR:	link layer header
- * @PAYLOAD_BASE_NETWORK_HDR:	network layer header
- * @PAYLOAD_BASE_TRANSPORT_HDR:	transport layer header
- */
-enum payload_bases {
-	PAYLOAD_BASE_INVALID,
-	PAYLOAD_BASE_LL_HDR,
-	PAYLOAD_BASE_NETWORK_HDR,
-	PAYLOAD_BASE_TRANSPORT_HDR,
-	__PAYLOAD_BASE_MAX
-};
-#define PAYLOAD_BASE_MAX	(__PAYLOAD_BASE_MAX - 1)
-
-/**
- * struct payload_template - template for a payload header expression
- *
- * @token:	parser token describing the header field
- * @dtype:	data type of the expression
- * @offset:	offset from base
- * @len:	length of header field
- */
-struct payload_template {
-	const char			*token;
-	const struct datatype		*dtype;
-	uint16_t			offset;
-	uint16_t			len;
-};
-
-#define PAYLOAD_TEMPLATE(__token, __dtype,  __offset, __len)		\
-	{								\
-		.token		= (__token),				\
-		.dtype		= (__dtype),				\
-		.offset		= (__offset),				\
-		.len		= (__len),				\
-	}
-
-#define PAYLOAD_PROTO_MAX		16
-#define PAYLOAD_TEMPLATE_MAX		20
-
-/**
- * struct payload_desc - payload protocol description
- *
- * @name:	protocol name
- * @base:	header base
- * @protocol_key: key of template containing upper layer protocol description
- * @protocols:	link to upper layer protocol description indexed by protocol value
- * @templates:	header templates
- */
-struct payload_desc {
-	const char			*name;
-	enum payload_bases		base;
-	unsigned int			protocol_key;
-	struct {
-		unsigned int			num;
-		const struct payload_desc	*desc;
-	}				protocols[PAYLOAD_PROTO_MAX];
-	struct payload_template		templates[PAYLOAD_TEMPLATE_MAX];
-};
-
-#define PAYLOAD_PROTO(__num, __desc)	{ .num = (__num), .desc = (__desc), }
-
-/**
- * struct payload_hook_desc - description of constraints imposed by hook family
- *
- * @base:	protocol base of packets
- * @desc:	protocol description of packets
- */
-struct payload_hook_desc {
-	enum payload_bases		base;
-	const struct payload_desc	*desc;
-};
-
-#define PAYLOAD_HOOK(__base, __desc)	{ .base = (__base), .desc = (__desc), }
-
-/**
- * struct dev_payload_desc - description of device LL protocol
- *
- * @desc:	protocol description
- * @type:	arphrd value
- */
-struct dev_payload_desc {
-	const struct payload_desc	*desc;
-	uint16_t			type;
-};
-
-#define DEV_PAYLOAD_DESC(__type, __desc) { .type = (__type), .desc = (__desc), }
-
-/**
- * struct payload_ctx - payload expression protocol context
- *
- * @family:	hook family
- * @location:	location of expression defining the context
- * @desc:	payload description for this layer
- *
- * The location of the context is the location of the relational expression
- * defining it, either directly through a protocol match or indirectly
- * through a dependency.
- */
-struct payload_ctx {
-	unsigned int			family;
-	struct {
-		struct location			location;
-		const struct payload_desc	*desc;
-	} protocol[PAYLOAD_BASE_MAX + 1];
-};
+#include <proto.h>
 
 extern struct expr *payload_expr_alloc(const struct location *loc,
-				       const struct payload_desc *desc,
+				       const struct proto_desc *desc,
 				       unsigned int type);
-extern void payload_init_raw(struct expr *expr, enum payload_bases base,
+extern void payload_init_raw(struct expr *expr, enum proto_bases base,
 			     unsigned int offset, unsigned int len);
 
-extern void payload_ctx_init(struct payload_ctx *ctx, unsigned int family);
-extern void payload_ctx_update_meta(struct payload_ctx *ctx,
-				    const struct expr *expr);
-extern void payload_ctx_update(struct payload_ctx *ctx,
-			       const struct expr *expr);
+extern void payload_expr_pctx_update(struct proto_ctx *ctx,
+				     const struct expr *expr);
 
 struct eval_ctx;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
@@ -134,162 +22,8 @@ extern struct expr *payload_expr_join(const struct expr *e1,
 				      const struct expr *e2);
 
 extern void payload_expr_expand(struct list_head *list, struct expr *expr,
-				const struct payload_ctx *ctx);
+				const struct proto_ctx *ctx);
 extern void payload_expr_complete(struct expr *expr,
-				  const struct payload_ctx *ctx);
-
-enum eth_hdr_fields {
-	ETHHDR_INVALID,
-	ETHHDR_DADDR,
-	ETHHDR_SADDR,
-	ETHHDR_TYPE,
-};
-
-enum vlan_hdr_fields {
-	VLANHDR_INVALID,
-	VLANHDR_VID,
-	VLANHDR_CFI,
-	VLANHDR_PCP,
-	VLANHDR_TYPE,
-};
-
-enum arp_hdr_fields {
-	ARPHDR_INVALID,
-	ARPHDR_HRD,
-	ARPHDR_PRO,
-	ARPHDR_HLN,
-	ARPHDR_PLN,
-	ARPHDR_OP,
-};
-
-enum ip_hdr_fields {
-	IPHDR_INVALID,
-	IPHDR_VERSION,
-	IPHDR_HDRLENGTH,
-	IPHDR_TOS,
-	IPHDR_LENGTH,
-	IPHDR_ID,
-	IPHDR_FRAG_OFF,
-	IPHDR_TTL,
-	IPHDR_PROTOCOL,
-	IPHDR_CHECKSUM,
-	IPHDR_SADDR,
-	IPHDR_DADDR,
-};
-
-enum icmp_hdr_fields {
-	ICMPHDR_INVALID,
-	ICMPHDR_TYPE,
-	ICMPHDR_CODE,
-	ICMPHDR_CHECKSUM,
-	ICMPHDR_ID,
-	ICMPHDR_SEQ,
-	ICMPHDR_GATEWAY,
-	ICMPHDR_MTU,
-};
-
-enum icmp6_hdr_fields {
-	ICMP6HDR_INVALID,
-	ICMP6HDR_TYPE,
-	ICMP6HDR_CODE,
-	ICMP6HDR_CHECKSUM,
-	ICMP6HDR_PPTR,
-	ICMP6HDR_MTU,
-	ICMP6HDR_ID,
-	ICMP6HDR_SEQ,
-	ICMP6HDR_MAXDELAY,
-};
-
-enum ip6_hdr_fields {
-	IP6HDR_INVALID,
-	IP6HDR_VERSION,
-	IP6HDR_PRIORITY,
-	IP6HDR_FLOWLABEL,
-	IP6HDR_LENGTH,
-	IP6HDR_NEXTHDR,
-	IP6HDR_HOPLIMIT,
-	IP6HDR_SADDR,
-	IP6HDR_DADDR,
-	IP6HDR_PROTOCOL,
-};
-
-enum ah_hdr_fields {
-	AHHDR_INVALID,
-	AHHDR_NEXTHDR,
-	AHHDR_HDRLENGTH,
-	AHHDR_RESERVED,
-	AHHDR_SPI,
-	AHHDR_SEQUENCE,
-};
-
-enum esp_hdr_fields {
-	ESPHDR_INVALID,
-	ESPHDR_SPI,
-	ESPHDR_SEQUENCE,
-};
-
-enum comp_hdr_fields {
-	COMPHDR_INVALID,
-	COMPHDR_NEXTHDR,
-	COMPHDR_FLAGS,
-	COMPHDR_CPI,
-};
-
-enum udp_hdr_fields {
-	UDPHDR_INVALID,
-	UDPHDR_SPORT,
-	UDPHDR_DPORT,
-	UDPHDR_LENGTH,
-	UDPHDR_CSUMCOV = UDPHDR_LENGTH,
-	UDPHDR_CHECKSUM,
-};
-
-enum tcp_hdr_fields {
-	TCPHDR_INVALID,
-	TCPHDR_SPORT,
-	TCPHDR_DPORT,
-	TCPHDR_SEQ,
-	TCPHDR_ACKSEQ,
-	TCPHDR_DOFF,
-	TCPHDR_RESERVED,
-	TCPHDR_FLAGS,
-	TCPHDR_WINDOW,
-	TCPHDR_CHECKSUM,
-	TCPHDR_URGPTR,
-};
-
-enum dccp_hdr_fields {
-	DCCPHDR_INVALID,
-	DCCPHDR_SPORT,
-	DCCPHDR_DPORT,
-	DCCPHDR_TYPE,
-};
-
-enum sctp_hdr_fields {
-	SCTPHDR_INVALID,
-	SCTPHDR_SPORT,
-	SCTPHDR_DPORT,
-	SCTPHDR_VTAG,
-	SCTPHDR_CHECKSUM,
-};
-
-extern const struct payload_desc payload_icmp;
-extern const struct payload_desc payload_ah;
-extern const struct payload_desc payload_esp;
-extern const struct payload_desc payload_comp;
-extern const struct payload_desc payload_udp;
-extern const struct payload_desc payload_udplite;
-extern const struct payload_desc payload_tcp;
-extern const struct payload_desc payload_dccp;
-extern const struct payload_desc payload_sctp;
-extern const struct payload_desc payload_icmp6;
-
-extern const struct payload_desc payload_ip;
-extern const struct payload_desc payload_ip6;
-
-extern const struct payload_desc payload_arp;
-
-extern const struct payload_desc payload_vlan;
-extern const struct payload_desc payload_eth;
+				  const struct proto_ctx *ctx);
 
 #endif /* NFTABLES_PAYLOAD_H */
diff --git a/include/proto.h b/include/proto.h
new file mode 100644
index 0000000..037ef09
--- /dev/null
+++ b/include/proto.h
@@ -0,0 +1,287 @@
+#ifndef NFTABLES_PROTO_H
+#define NFTABLES_PROTO_H
+
+#include <nftables.h>
+
+/**
+ * enum proto_bases - protocol bases
+ *
+ * @PROTO_BASE_INVALID:		uninitialised, does not happen
+ * @PROTO_BASE_LL_HDR:		link layer header
+ * @PROTO_BASE_NETWORK_HDR:	network layer header
+ * @PROTO_BASE_TRANSPORT_HDR:	transport layer header
+ */
+enum proto_bases {
+	PROTO_BASE_INVALID,
+	PROTO_BASE_LL_HDR,
+	PROTO_BASE_NETWORK_HDR,
+	PROTO_BASE_TRANSPORT_HDR,
+	__PROTO_BASE_MAX
+};
+#define PROTO_BASE_MAX		(__PROTO_BASE_MAX - 1)
+
+extern const char *proto_base_names[];
+extern const char *proto_base_tokens[];
+
+/**
+ * struct proto_hdr_template - protocol header field description
+ *
+ * @token:	parser token describing the header field
+ * @dtype:	data type of the header field
+ * @offset:	offset of the header field from base
+ * @len:	length of header field
+ */
+struct proto_hdr_template {
+	const char			*token;
+	const struct datatype		*dtype;
+	uint16_t			offset;
+	uint16_t			len;
+};
+
+#define PROTO_HDR_TEMPLATE(__token, __dtype,  __offset, __len)		\
+	{								\
+		.token		= (__token),				\
+		.dtype		= (__dtype),				\
+		.offset		= (__offset),				\
+		.len		= (__len),				\
+	}
+
+#define PROTO_UPPER_MAX		16
+#define PROTO_HDRS_MAX		20
+
+/**
+ * struct proto_desc - protocol header description
+ *
+ * @name:	protocol name
+ * @base:	header base
+ * @protocol_key: key of template containing upper layer protocol description
+ * @protocols:	link to upper layer protocol descriptions indexed by protocol value
+ * @templates:	header templates
+ */
+struct proto_desc {
+	const char			*name;
+	enum proto_bases		base;
+	unsigned int			protocol_key;
+	struct {
+		unsigned int			num;
+		const struct proto_desc		*desc;
+	}				protocols[PROTO_UPPER_MAX];
+	struct proto_hdr_template	templates[PROTO_HDRS_MAX];
+};
+
+#define PROTO_LINK(__num, __desc)	{ .num = (__num), .desc = (__desc), }
+
+/**
+ * struct hook_proto_desc - description of protocol constraints imposed by hook family
+ *
+ * @base:	protocol base of packets
+ * @desc:	protocol description of packets
+ */
+struct hook_proto_desc {
+	enum proto_bases		base;
+	const struct proto_desc		*desc;
+};
+
+#define HOOK_PROTO_DESC(__base, __desc)	{ .base = (__base), .desc = (__desc), }
+
+extern const struct hook_proto_desc hook_proto_desc[];
+
+/**
+ * struct dev_proto_desc - description of device LL protocol
+ *
+ * @desc:	protocol description
+ * @type:	arphrd value
+ */
+struct dev_proto_desc {
+	const struct proto_desc		*desc;
+	uint16_t			type;
+};
+
+#define DEV_PROTO_DESC(__type, __desc)	{ .type = (__type), .desc = (__desc), }
+
+extern int proto_dev_type(const struct proto_desc *desc, uint16_t *res);
+extern const struct proto_desc *proto_dev_desc(uint16_t type);
+
+/**
+ * struct proto_ctx - protocol context
+ *
+ * @family:	hook family
+ * @location:	location of the relational expression defining the context
+ * @desc:	protocol description for this layer
+ *
+ * The location of the context is the location of the relational expression
+ * defining it, either directly through a protocol match or indirectly
+ * through a dependency.
+ */
+struct proto_ctx {
+	unsigned int			family;
+	struct {
+		struct location			location;
+		const struct proto_desc		*desc;
+	} protocol[PROTO_BASE_MAX + 1];
+};
+
+extern void proto_ctx_init(struct proto_ctx *ctx, unsigned int family);
+extern const struct proto_desc *proto_find_upper(const struct proto_desc *base,
+						 unsigned int num);
+extern int proto_find_num(const struct proto_desc *base,
+			  const struct proto_desc *desc);
+
+enum eth_hdr_fields {
+	ETHHDR_INVALID,
+	ETHHDR_DADDR,
+	ETHHDR_SADDR,
+	ETHHDR_TYPE,
+};
+
+enum vlan_hdr_fields {
+	VLANHDR_INVALID,
+	VLANHDR_VID,
+	VLANHDR_CFI,
+	VLANHDR_PCP,
+	VLANHDR_TYPE,
+};
+
+enum arp_hdr_fields {
+	ARPHDR_INVALID,
+	ARPHDR_HRD,
+	ARPHDR_PRO,
+	ARPHDR_HLN,
+	ARPHDR_PLN,
+	ARPHDR_OP,
+};
+
+enum ip_hdr_fields {
+	IPHDR_INVALID,
+	IPHDR_VERSION,
+	IPHDR_HDRLENGTH,
+	IPHDR_TOS,
+	IPHDR_LENGTH,
+	IPHDR_ID,
+	IPHDR_FRAG_OFF,
+	IPHDR_TTL,
+	IPHDR_PROTOCOL,
+	IPHDR_CHECKSUM,
+	IPHDR_SADDR,
+	IPHDR_DADDR,
+};
+
+enum icmp_hdr_fields {
+	ICMPHDR_INVALID,
+	ICMPHDR_TYPE,
+	ICMPHDR_CODE,
+	ICMPHDR_CHECKSUM,
+	ICMPHDR_ID,
+	ICMPHDR_SEQ,
+	ICMPHDR_GATEWAY,
+	ICMPHDR_MTU,
+};
+
+enum icmp6_hdr_fields {
+	ICMP6HDR_INVALID,
+	ICMP6HDR_TYPE,
+	ICMP6HDR_CODE,
+	ICMP6HDR_CHECKSUM,
+	ICMP6HDR_PPTR,
+	ICMP6HDR_MTU,
+	ICMP6HDR_ID,
+	ICMP6HDR_SEQ,
+	ICMP6HDR_MAXDELAY,
+};
+
+enum ip6_hdr_fields {
+	IP6HDR_INVALID,
+	IP6HDR_VERSION,
+	IP6HDR_PRIORITY,
+	IP6HDR_FLOWLABEL,
+	IP6HDR_LENGTH,
+	IP6HDR_NEXTHDR,
+	IP6HDR_HOPLIMIT,
+	IP6HDR_SADDR,
+	IP6HDR_DADDR,
+	IP6HDR_PROTOCOL,
+};
+
+enum ah_hdr_fields {
+	AHHDR_INVALID,
+	AHHDR_NEXTHDR,
+	AHHDR_HDRLENGTH,
+	AHHDR_RESERVED,
+	AHHDR_SPI,
+	AHHDR_SEQUENCE,
+};
+
+enum esp_hdr_fields {
+	ESPHDR_INVALID,
+	ESPHDR_SPI,
+	ESPHDR_SEQUENCE,
+};
+
+enum comp_hdr_fields {
+	COMPHDR_INVALID,
+	COMPHDR_NEXTHDR,
+	COMPHDR_FLAGS,
+	COMPHDR_CPI,
+};
+
+enum udp_hdr_fields {
+	UDPHDR_INVALID,
+	UDPHDR_SPORT,
+	UDPHDR_DPORT,
+	UDPHDR_LENGTH,
+	UDPHDR_CSUMCOV = UDPHDR_LENGTH,
+	UDPHDR_CHECKSUM,
+};
+
+enum tcp_hdr_fields {
+	TCPHDR_INVALID,
+	TCPHDR_SPORT,
+	TCPHDR_DPORT,
+	TCPHDR_SEQ,
+	TCPHDR_ACKSEQ,
+	TCPHDR_DOFF,
+	TCPHDR_RESERVED,
+	TCPHDR_FLAGS,
+	TCPHDR_WINDOW,
+	TCPHDR_CHECKSUM,
+	TCPHDR_URGPTR,
+};
+
+enum dccp_hdr_fields {
+	DCCPHDR_INVALID,
+	DCCPHDR_SPORT,
+	DCCPHDR_DPORT,
+	DCCPHDR_TYPE,
+};
+
+enum sctp_hdr_fields {
+	SCTPHDR_INVALID,
+	SCTPHDR_SPORT,
+	SCTPHDR_DPORT,
+	SCTPHDR_VTAG,
+	SCTPHDR_CHECKSUM,
+};
+
+extern const struct proto_desc proto_icmp;
+extern const struct proto_desc proto_ah;
+extern const struct proto_desc proto_esp;
+extern const struct proto_desc proto_comp;
+extern const struct proto_desc proto_udp;
+extern const struct proto_desc proto_udplite;
+extern const struct proto_desc proto_tcp;
+extern const struct proto_desc proto_dccp;
+extern const struct proto_desc proto_sctp;
+extern const struct proto_desc proto_icmp6;
+
+extern const struct proto_desc proto_ip;
+extern const struct proto_desc proto_ip6;
+
+extern const struct proto_desc proto_arp;
+
+extern const struct proto_desc proto_vlan;
+extern const struct proto_desc proto_eth;
+
+extern const struct proto_desc proto_unknown;
+extern const struct proto_hdr_template proto_unknown_template;
+
+#endif /* NFTABLES_PROTO_H */
diff --git a/include/rule.h b/include/rule.h
index 6ad8af3..2a7b798 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -292,7 +292,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
-	struct payload_ctx	pctx;
+	struct proto_ctx	pctx;
 };
 
 extern int evaluate(struct eval_ctx *ctx, struct list_head *commands);
diff --git a/src/Makefile.in b/src/Makefile.in
index 658e9b3..8ac2b46 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -9,6 +9,7 @@ nft-obj			+= statement.o
 nft-obj			+= datatype.o
 nft-obj			+= expression.o
 nft-obj			+= evaluate.o
+nft-obj			+= proto.o
 nft-obj			+= payload.o
 nft-obj			+= exthdr.o
 nft-obj			+= meta.o
diff --git a/src/evaluate.c b/src/evaluate.c
index d4f8339..112fc94 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -269,7 +269,7 @@ static int expr_evaluate_primary(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *payload = *expr;
-	enum payload_bases base = payload->payload.base;
+	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt;
 	struct expr *nexpr;
 
@@ -916,15 +916,15 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 						 left->dtype->desc,
 						 right->dtype->desc);
 		/*
-		 * Update payload context for payload and meta iiftype equality
-		 * expressions.
+		 * Update protocol context for payload and meta iiftype
+		 * equality expressions.
 		 */
 		switch (left->ops->type) {
 		case EXPR_PAYLOAD:
-			payload_ctx_update(&ctx->pctx, rel);
+			payload_expr_pctx_update(&ctx->pctx, rel);
 			break;
 		case EXPR_META:
-			payload_ctx_update_meta(&ctx->pctx, rel);
+			meta_expr_pctx_update(&ctx->pctx, rel);
 			break;
 		case EXPR_CONCAT:
 			return 0;
@@ -1117,7 +1117,7 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct payload_ctx *pctx = &ctx->pctx;
+	struct proto_ctx *pctx = &ctx->pctx;
 	int err;
 
 	if (stmt->nat.addr != NULL) {
@@ -1133,7 +1133,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 
 	if (stmt->nat.proto != NULL) {
-		if (pctx->protocol[PAYLOAD_BASE_TRANSPORT_HDR].desc == NULL)
+		if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
 			return stmt_binary_error(ctx, stmt->nat.proto, stmt,
 						 "transport protocol mapping is only "
 						 "valid after transport protocol match");
@@ -1232,7 +1232,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	payload_ctx_init(&ctx->pctx, rule->handle.family);
+	proto_ctx_init(&ctx->pctx, rule->handle.family);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
diff --git a/src/exthdr.c b/src/exthdr.c
index 3d01c3a..458f9d6 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -40,14 +40,14 @@ static const struct expr_ops exthdr_expr_ops = {
 	.clone		= exthdr_expr_clone,
 };
 
-static const struct payload_template exthdr_unknown_template =
-	PAYLOAD_TEMPLATE("unknown", &invalid_type, 0, 0);
+static const struct proto_hdr_template exthdr_unknown_template =
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, 0, 0);
 
 struct expr *exthdr_expr_alloc(const struct location *loc,
 			       const struct exthdr_desc *desc,
 			       uint8_t type)
 {
-	const struct payload_template *tmpl;
+	const struct proto_hdr_template *tmpl;
 	struct expr *expr;
 
 	if (desc != NULL)
@@ -73,7 +73,7 @@ static const struct exthdr_desc *exthdr_protocols[IPPROTO_MAX] = {
 void exthdr_init_raw(struct expr *expr, uint8_t type,
 		     unsigned int offset, unsigned int len)
 {
-	const struct payload_template *tmpl;
+	const struct proto_hdr_template *tmpl;
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_EXTHDR);
@@ -94,9 +94,9 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 }
 
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
-	PAYLOAD_TEMPLATE(__name, __dtype,				\
-			 offsetof(__type, __member) * 8,		\
-			 field_sizeof(__type, __member) * 8)
+	PROTO_HDR_TEMPLATE(__name, __dtype,				\
+			   offsetof(__type, __member) * 8,		\
+			   field_sizeof(__type, __member) * 8)
 
 /*
  * Hop-by-hop options
@@ -171,12 +171,12 @@ const struct exthdr_desc exthdr_frag = {
 	.templates	= {
 		[FRAGHDR_NEXTHDR]	= FRAG_FIELD("nexthdr", ip6f_nxt, &inet_protocol_type),
 		[FRAGHDR_RESERVED]	= FRAG_FIELD("reserved", ip6f_reserved, &integer_type),
-		[FRAGHDR_FRAG_OFF]	= PAYLOAD_TEMPLATE("frag-off", &integer_type,
-							   16, 13),
-		[FRAGHDR_RESERVED2]	= PAYLOAD_TEMPLATE("reserved2", &integer_type,
-							   29, 2),
-		[FRAGHDR_MFRAGS]	= PAYLOAD_TEMPLATE("more-fragments", &integer_type,
-							   31, 1),
+		[FRAGHDR_FRAG_OFF]	= PROTO_HDR_TEMPLATE("frag-off", &integer_type,
+							  16, 13),
+		[FRAGHDR_RESERVED2]	= PROTO_HDR_TEMPLATE("reserved2", &integer_type,
+							  29, 2),
+		[FRAGHDR_MFRAGS]	= PROTO_HDR_TEMPLATE("more-fragments", &integer_type,
+							  31, 1),
 		[FRAGHDR_ID]		= FRAG_FIELD("id", ip6f_ident, &integer_type),
 	},
 };
diff --git a/src/meta.c b/src/meta.c
index 32f3012..343f9a3 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -341,6 +341,35 @@ static void meta_expr_clone(struct expr *new, const struct expr *expr)
 	new->meta.key = expr->meta.key;
 }
 
+/**
+ * meta_expr_pctx_update - update protocol context based on meta match
+ *
+ * @ctx:	protocol context
+ * @expr:	relational meta expression
+ *
+ * Update LL protocol context based on IIFTYPE meta match in non-LL hooks.
+ */
+void meta_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
+{
+	const struct hook_proto_desc *h = &hook_proto_desc[ctx->family];
+	const struct expr *left = expr->left, *right = expr->right;
+	const struct proto_desc *desc;
+
+	if (left->meta.key != NFT_META_IIFTYPE)
+		return;
+
+	assert(expr->op == OP_EQ);
+	if (h->base < PROTO_BASE_NETWORK_HDR)
+		return;
+
+	desc = proto_dev_desc(mpz_get_uint16(right->value));
+	if (desc == NULL)
+		desc = &proto_unknown;
+
+	ctx->protocol[PROTO_BASE_LL_HDR].location = expr->location;
+	ctx->protocol[PROTO_BASE_LL_HDR].desc	  = desc;
+}
+
 static const struct expr_ops meta_expr_ops = {
 	.type		= EXPR_META,
 	.name		= "meta",
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8545273..982377f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -573,8 +573,8 @@ static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
 }
 
 struct rule_pp_ctx {
-	struct payload_ctx	pctx;
-	enum payload_bases	pbase;
+	struct proto_ctx	pctx;
+	enum proto_bases	pbase;
 	struct stmt		*pdep;
 };
 
@@ -583,7 +583,7 @@ struct rule_pp_ctx {
  */
 static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
 {
-	if (ctx->pbase != PAYLOAD_BASE_INVALID &&
+	if (ctx->pbase != PROTO_BASE_INVALID &&
 	    ctx->pbase == expr->payload.base - 1 &&
 	    ctx->pdep != NULL) {
 		list_del(&ctx->pdep->list);
@@ -612,7 +612,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 
 			nexpr = relational_expr_alloc(&expr->location, expr->op,
 						      left, tmp);
-			payload_ctx_update(&ctx->pctx, nexpr);
+			payload_expr_pctx_update(&ctx->pctx, nexpr);
 
 			nstmt = expr_stmt_alloc(&stmt->location, nexpr);
 			list_add_tail(&nstmt->list, &stmt->list);
@@ -621,7 +621,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			 * kill it later on if made redundant by a higher layer
 			 * payload expression.
 			 */
-			if (ctx->pbase == PAYLOAD_BASE_INVALID &&
+			if (ctx->pbase == PROTO_BASE_INVALID &&
 			    left->flags & EXPR_F_PROTOCOL) {
 				ctx->pbase = left->payload.base;
 				ctx->pdep  = nstmt;
@@ -639,12 +639,12 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
-static void meta_match_postprocess(struct payload_ctx *ctx,
+static void meta_match_postprocess(struct proto_ctx *ctx,
 				   const struct expr *expr)
 {
 	switch (expr->op) {
 	case OP_EQ:
-		payload_ctx_update_meta(ctx, expr);
+		meta_expr_pctx_update(ctx, expr);
 		break;
 	default:
 		break;
@@ -821,7 +821,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	struct stmt *stmt, *next;
 
 	memset(&rctx, 0, sizeof(rctx));
-	payload_ctx_init(&rctx.pctx, rule->handle.family);
+	proto_ctx_init(&rctx.pctx, rule->handle.family);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		switch (stmt->ops->type) {
diff --git a/src/parser.y b/src/parser.y
index 9320f2d..7778d50 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1444,14 +1444,14 @@ payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
 			}
 			;
 
-payload_base_spec	:	LL_HDR		{ $$ = PAYLOAD_BASE_LL_HDR; }
-			|	NETWORK_HDR	{ $$ = PAYLOAD_BASE_NETWORK_HDR; }
-			|	TRANSPORT_HDR	{ $$ = PAYLOAD_BASE_TRANSPORT_HDR; }
+payload_base_spec	:	LL_HDR		{ $$ = PROTO_BASE_LL_HDR; }
+			|	NETWORK_HDR	{ $$ = PROTO_BASE_NETWORK_HDR; }
+			|	TRANSPORT_HDR	{ $$ = PROTO_BASE_TRANSPORT_HDR; }
 			;
 
 eth_hdr_expr		:	ETH	eth_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_eth, $2);
+				$$ = payload_expr_alloc(&@$, &proto_eth, $2);
 			}
 			;
 
@@ -1462,7 +1462,7 @@ eth_hdr_field		:	SADDR		{ $$ = ETHHDR_SADDR; }
 
 vlan_hdr_expr		:	VLAN	vlan_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_vlan, $2);
+				$$ = payload_expr_alloc(&@$, &proto_vlan, $2);
 			}
 			;
 
@@ -1474,7 +1474,7 @@ vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
 
 arp_hdr_expr		:	ARP	arp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_arp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_arp, $2);
 			}
 			;
 
@@ -1487,7 +1487,7 @@ arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
 
 ip_hdr_expr		:	IP	ip_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_ip, $2);
+				$$ = payload_expr_alloc(&@$, &proto_ip, $2);
 			}
 			;
 
@@ -1506,7 +1506,7 @@ ip_hdr_field		:	VERSION		{ $$ = IPHDR_VERSION; }
 
 icmp_hdr_expr		:	ICMP	icmp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_icmp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_icmp, $2);
 			}
 			|	ICMP
 			{
@@ -1528,7 +1528,7 @@ icmp_hdr_field		:	TYPE		{ $$ = ICMPHDR_TYPE; }
 
 ip6_hdr_expr		:	IP6	ip6_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_ip6, $2);
+				$$ = payload_expr_alloc(&@$, &proto_ip6, $2);
 			}
 			;
 
@@ -1543,7 +1543,7 @@ ip6_hdr_field		:	VERSION		{ $$ = IP6HDR_VERSION; }
 			;
 icmp6_hdr_expr		:	ICMP6	icmp6_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_icmp6, $2);
+				$$ = payload_expr_alloc(&@$, &proto_icmp6, $2);
 			}
 			|	ICMP6
 			{
@@ -1566,7 +1566,7 @@ icmp6_hdr_field		:	TYPE		{ $$ = ICMP6HDR_TYPE; }
 
 auth_hdr_expr		:	AH	auth_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_ah, $2);
+				$$ = payload_expr_alloc(&@$, &proto_ah, $2);
 			}
 			|	AH
 			{
@@ -1586,7 +1586,7 @@ auth_hdr_field		:	NEXTHDR		{ $$ = AHHDR_NEXTHDR; }
 
 esp_hdr_expr		:	ESP	esp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_esp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_esp, $2);
 			}
 			|	ESP
 			{
@@ -1603,7 +1603,7 @@ esp_hdr_field		:	SPI		{ $$ = ESPHDR_SPI; }
 
 comp_hdr_expr		:	COMP	comp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_comp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_comp, $2);
 			}
 			|	COMP
 			{
@@ -1621,7 +1621,7 @@ comp_hdr_field		:	NEXTHDR		{ $$ = COMPHDR_NEXTHDR; }
 
 udp_hdr_expr		:	UDP	udp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_udp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_udp, $2);
 			}
 			|	UDP
 			{
@@ -1640,7 +1640,7 @@ udp_hdr_field		:	SPORT		{ $$ = UDPHDR_SPORT; }
 
 udplite_hdr_expr	:	UDPLITE	udplite_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_udplite, $2);
+				$$ = payload_expr_alloc(&@$, &proto_udplite, $2);
 			}
 			|	UDPLITE
 			{
@@ -1659,7 +1659,7 @@ udplite_hdr_field	:	SPORT		{ $$ = UDPHDR_SPORT; }
 
 tcp_hdr_expr		:	TCP	tcp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_tcp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_tcp, $2);
 			}
 			|	TCP
 			{
@@ -1684,7 +1684,7 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 
 dccp_hdr_expr		:	DCCP	dccp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_dccp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
 			}
 			|	DCCP
 			{
@@ -1702,7 +1702,7 @@ dccp_hdr_field		:	SPORT		{ $$ = DCCPHDR_SPORT; }
 
 sctp_hdr_expr		:	SCTP	sctp_hdr_field
 			{
-				$$ = payload_expr_alloc(&@$, &payload_sctp, $2);
+				$$ = payload_expr_alloc(&@$, &proto_sctp, $2);
 			}
 			|	SCTP
 			{
diff --git a/src/payload.c b/src/payload.c
index 2a60a76..7721b75 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -1,5 +1,5 @@
 /*
- * Payload expression protocol and type definitions and related functions.
+ * Payload expression and related functions.
  *
  * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
  *
@@ -22,36 +22,13 @@
 #include <rule.h>
 #include <expression.h>
 #include <payload.h>
-#include <headers.h>
 #include <gmputil.h>
 #include <utils.h>
 
-static const char *payload_base_names[] = {
-	[PAYLOAD_BASE_INVALID]		= "invalid",
-	[PAYLOAD_BASE_LL_HDR]		= "link layer",
-	[PAYLOAD_BASE_NETWORK_HDR]	= "network layer",
-	[PAYLOAD_BASE_TRANSPORT_HDR]	= "transport layer",
-};
-
-static const char *payload_base_tokens[] = {
-	[PAYLOAD_BASE_INVALID]		= "invalid",
-	[PAYLOAD_BASE_LL_HDR]		= "ll",
-	[PAYLOAD_BASE_NETWORK_HDR]	= "nh",
-	[PAYLOAD_BASE_TRANSPORT_HDR]	= "th",
-};
-
-static const struct payload_template payload_unknown_template =
-	PAYLOAD_TEMPLATE("unknown", &invalid_type, 0, 0);
-
-static const struct payload_desc payload_unknown_desc = {
-	.name		= "unknown",
-	.base		= PAYLOAD_BASE_INVALID,
-};
-
 static void payload_expr_print(const struct expr *expr)
 {
-	const struct payload_desc *desc;
-	const struct payload_template *tmpl;
+	const struct proto_desc *desc;
+	const struct proto_hdr_template *tmpl;
 
 	desc = expr->payload.desc;
 	tmpl = expr->payload.tmpl;
@@ -59,7 +36,7 @@ static void payload_expr_print(const struct expr *expr)
 		printf("%s %s", desc->name, tmpl->token);
 	else
 		printf("payload @%s,%u,%u",
-		       payload_base_tokens[expr->payload.base],
+		       proto_base_tokens[expr->payload.base],
 		       expr->payload.offset, expr->len);
 }
 
@@ -79,11 +56,11 @@ static const struct expr_ops payload_expr_ops = {
 };
 
 struct expr *payload_expr_alloc(const struct location *loc,
-				const struct payload_desc *desc,
+				const struct proto_desc *desc,
 				unsigned int type)
 {
-	const struct payload_template *tmpl;
-	enum payload_bases base;
+	const struct proto_hdr_template *tmpl;
+	enum proto_bases base;
 	struct expr *expr;
 	unsigned int flags = 0;
 
@@ -93,8 +70,8 @@ struct expr *payload_expr_alloc(const struct location *loc,
 		if (type == desc->protocol_key)
 			flags = EXPR_F_PROTOCOL;
 	} else {
-		tmpl = &payload_unknown_template;
-		base = PAYLOAD_BASE_INVALID;
+		tmpl = &proto_unknown_template;
+		base = PROTO_BASE_INVALID;
 	}
 
 	expr = expr_alloc(loc, &payload_expr_ops, tmpl->dtype,
@@ -109,7 +86,7 @@ struct expr *payload_expr_alloc(const struct location *loc,
 	return expr;
 }
 
-void payload_init_raw(struct expr *expr, enum payload_bases base,
+void payload_init_raw(struct expr *expr, enum proto_bases base,
 		      unsigned int offset, unsigned int len)
 {
 	expr->payload.base	= base;
@@ -118,151 +95,24 @@ void payload_init_raw(struct expr *expr, enum payload_bases base,
 }
 
 /**
- * payload_select_proto - find protocol description by protocol value linking
- * 			  it to lower layer protocol
- *
- * @base:	lower layer protocol description
- * @num:	protocol value
- */
-static const struct payload_desc *
-payload_select_proto(const struct payload_desc *base, unsigned int num)
-{
-	unsigned int i;
-
-	for (i = 0; i < array_size(base->protocols); i++) {
-		if (base->protocols[i].num == num)
-			return base->protocols[i].desc;
-	}
-	return NULL;
-}
-
-/**
- * payload_proto_val - return protocol number linking two protocols together
- *
- * @base:	lower layer protocol description
- * @desc:	upper layer protocol description
- */
-static int payload_proto_val(const struct payload_desc *base,
-			     const struct payload_desc *desc)
-{
-	unsigned int i;
-
-	for (i = 0; i < array_size(base->protocols); i++) {
-		if (base->protocols[i].desc == desc)
-			return base->protocols[i].num;
-	}
-	return -1;
-}
-
-static const struct dev_payload_desc dev_payload_desc[] = {
-	DEV_PAYLOAD_DESC(ARPHRD_ETHER, &payload_eth),
-};
-
-/**
- * payload_dev_type - return arphrd type linking a device and a protocol together
- *
- * @desc:	the protocol description
- * @res:	pointer to result
- */
-static int payload_dev_type(const struct payload_desc *desc, uint16_t *res)
-{
-	unsigned int i;
-
-	for (i = 0; i < array_size(dev_payload_desc); i++) {
-		if (dev_payload_desc[i].desc == desc) {
-			*res = dev_payload_desc[i].type;
-			return 0;
-		}
-	}
-	return -1;
-}
-
-/**
- * payload_dev_desc - return protocol description for an arphrd type
- *
- * @type:	the arphrd type
- */
-static const struct payload_desc *payload_dev_desc(uint16_t type)
-{
-	unsigned int i;
-
-	for (i = 0; i < array_size(dev_payload_desc); i++) {
-		if (dev_payload_desc[i].type == type)
-			return dev_payload_desc[i].desc;
-	}
-	return NULL;
-}
-
-static const struct payload_hook_desc payload_hooks[] = {
-	[NFPROTO_BRIDGE]	= PAYLOAD_HOOK(PAYLOAD_BASE_LL_HDR, &payload_eth),
-	[NFPROTO_IPV4]		= PAYLOAD_HOOK(PAYLOAD_BASE_NETWORK_HDR, &payload_ip),
-	[NFPROTO_IPV6]		= PAYLOAD_HOOK(PAYLOAD_BASE_NETWORK_HDR, &payload_ip6),
-	[NFPROTO_ARP]		= PAYLOAD_HOOK(PAYLOAD_BASE_NETWORK_HDR, &payload_arp),
-};
-
-/**
- * payload_ctx_init - initialize payload context for a given hook family
- *
- * @ctx:	payload context
- * @family:	hook family
- */
-void payload_ctx_init(struct payload_ctx *ctx, unsigned int family)
-{
-	const struct payload_hook_desc *h = &payload_hooks[family];
-
-	memset(ctx, 0, sizeof(*ctx));
-	ctx->family = family;
-	ctx->protocol[h->base].desc = h->desc;
-}
-
-/**
- * payload_ctx_update_meta - update payload context with meta expression
- *
- * @ctx:	payload context
- * @expr:	relational meta expression
- *
- * Update LL payload context based on IIFTYPE meta match in non-LL hooks.
- */
-void payload_ctx_update_meta(struct payload_ctx *ctx, const struct expr *expr)
-{
-	const struct payload_hook_desc *h = &payload_hooks[ctx->family];
-	const struct expr *left = expr->left, *right = expr->right;
-	const struct payload_desc *desc;
-
-	if (left->meta.key != NFT_META_IIFTYPE)
-		return;
-
-	assert(expr->op == OP_EQ);
-	if (h->base < PAYLOAD_BASE_NETWORK_HDR)
-		return;
-
-	desc = payload_dev_desc(mpz_get_uint16(right->value));
-	if (desc == NULL)
-		desc = &payload_unknown_desc;
-
-	ctx->protocol[PAYLOAD_BASE_LL_HDR].location = expr->location;
-	ctx->protocol[PAYLOAD_BASE_LL_HDR].desc = desc;
-}
-
-/**
- * payload_ctx_update - update payload context
+ * payload_expr_pctx_update - update protocol context based on payload match
  *
- * @ctx:	payload context
+ * @ctx:	protocol context
  * @expr:	relational payload expression
  *
- * Update payload context for relational payload expressions.
+ * Update protocol context for relational payload expressions.
  */
-void payload_ctx_update(struct payload_ctx *ctx, const struct expr *expr)
+void payload_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
 {
 	const struct expr *left = expr->left, *right = expr->right;
-	const struct payload_desc *base, *desc;
+	const struct proto_desc *base, *desc;
 
 	if (!(left->flags & EXPR_F_PROTOCOL))
 		return;
 
 	assert(expr->op == OP_EQ);
 	base = ctx->protocol[left->payload.base].desc;
-	desc = payload_select_proto(base, mpz_get_uint32(right->value));
+	desc = proto_find_upper(base, mpz_get_uint32(right->value));
 
 	ctx->protocol[left->payload.base + 1].location = expr->location;
 	ctx->protocol[left->payload.base + 1].desc = desc;
@@ -294,9 +144,9 @@ void payload_ctx_update(struct payload_ctx *ctx, const struct expr *expr)
 int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 			   struct expr **res)
 {
-	const struct payload_hook_desc *h = &payload_hooks[ctx->pctx.family];
-	const struct payload_desc *desc;
-	const struct payload_template *tmpl;
+	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
+	const struct proto_desc *desc;
+	const struct proto_hdr_template *tmpl;
 	struct expr *dep, *left, *right;
 	int protocol;
 	uint16_t type;
@@ -307,7 +157,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					  "payload base is invalid for this "
 					  "family");
 
-		if (payload_dev_type(expr->payload.desc, &type) < 0)
+		if (proto_dev_type(expr->payload.desc, &type) < 0)
 			return expr_error(ctx, expr,
 					  "protocol specification is invalid "
 					  "for this family");
@@ -327,9 +177,9 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		return expr_error(ctx, expr,
 				  "ambiguous payload specification: "
 				  "no %s protocol specified",
-				  payload_base_names[expr->payload.base - 1]);
+				  proto_base_names[expr->payload.base - 1]);
 
-	protocol = payload_proto_val(desc, expr->payload.desc);
+	protocol = proto_find_num(desc, expr->payload.desc);
 	if (protocol < 0)
 		return expr_error(ctx, expr,
 				  "conflicting protocols specified: %s vs. %s",
@@ -342,7 +192,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				    tmpl->len, &protocol);
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-	payload_ctx_update(&ctx->pctx, dep);
+	payload_expr_pctx_update(&ctx->pctx, dep);
 	*res = dep;
 	return 0;
 }
@@ -351,15 +201,15 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
  * payload_expr_complete - fill in type information of a raw payload expr
  *
  * @expr:	the payload expression
- * @ctx:	payload context
+ * @ctx:	protocol context
  *
  * Complete the type of a raw payload expression based on the context. If
  * insufficient information is available the expression remains unchanged.
  */
-void payload_expr_complete(struct expr *expr, const struct payload_ctx *ctx)
+void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 {
-	const struct payload_desc *desc;
-	const struct payload_template *tmpl;
+	const struct proto_desc *desc;
+	const struct proto_hdr_template *tmpl;
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_PAYLOAD);
@@ -387,7 +237,7 @@ void payload_expr_complete(struct expr *expr, const struct payload_ctx *ctx)
  *
  * @list:	list to append expanded payload expressions to
  * @expr:	the payload expression to expand
- * @ctx:	payload context
+ * @ctx:	protocol context
  *
  * Expand a merged adjacent payload expression into its original components
  * by splitting elements off the beginning matching a payload template.
@@ -396,10 +246,10 @@ void payload_expr_complete(struct expr *expr, const struct payload_ctx *ctx)
  * 	 offset order.
  */
 void payload_expr_expand(struct list_head *list, struct expr *expr,
-			 const struct payload_ctx *ctx)
+			 const struct proto_ctx *ctx)
 {
-	const struct payload_desc *desc;
-	const struct payload_template *tmpl;
+	const struct proto_desc *desc;
+	const struct proto_hdr_template *tmpl;
 	struct expr *new;
 	unsigned int i;
 
@@ -465,590 +315,3 @@ struct expr *payload_expr_join(const struct expr *e1, const struct expr *e2)
 	expr->len	     = e1->len + e2->len;
 	return expr;
 }
-
-#define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
-	PAYLOAD_TEMPLATE(__name, __dtype,				\
-			 offsetof(__type, __member) * 8,		\
-			 field_sizeof(__type, __member) * 8)
-
-#define HDR_FIELD(__name, __struct, __member)				\
-	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
-#define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
-	PAYLOAD_TEMPLATE(__name, __dtype, __offset, __len)
-#define HDR_TYPE(__name, __dtype, __struct, __member)			\
-	HDR_TEMPLATE(__name, __dtype, __struct, __member)
-
-#define INET_PROTOCOL(__name, __struct, __member)			\
-	HDR_TYPE(__name, &inet_protocol_type, __struct, __member)
-#define INET_SERVICE(__name, __struct, __member)			\
-	HDR_TYPE(__name, &inet_service_type, __struct, __member)
-
-/*
- * AH
- */
-
-#define AHHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct ip_auth_hdr, __member)
-
-const struct payload_desc payload_ah = {
-	.name		= "ah",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.protocol_key	= AHHDR_NEXTHDR,
-	.protocols	= {
-		PAYLOAD_PROTO(IPPROTO_ESP,	&payload_esp),
-		PAYLOAD_PROTO(IPPROTO_AH,	&payload_ah),
-		PAYLOAD_PROTO(IPPROTO_COMP,	&payload_comp),
-		PAYLOAD_PROTO(IPPROTO_UDP,	&payload_udp),
-		PAYLOAD_PROTO(IPPROTO_UDPLITE,	&payload_udplite),
-		PAYLOAD_PROTO(IPPROTO_TCP,	&payload_tcp),
-		PAYLOAD_PROTO(IPPROTO_DCCP,	&payload_dccp),
-		PAYLOAD_PROTO(IPPROTO_SCTP,	&payload_sctp),
-	},
-	.templates	= {
-		[AHHDR_NEXTHDR]		= INET_PROTOCOL("nexthdr", struct ip_auth_hdr, nexthdr),
-		[AHHDR_HDRLENGTH]	= AHHDR_FIELD("hdrlength", hdrlen),
-		[AHHDR_RESERVED]	= AHHDR_FIELD("reserved", reserved),
-		[AHHDR_SPI]		= AHHDR_FIELD("spi", spi),
-		[AHHDR_SEQUENCE]	= AHHDR_FIELD("sequence", seq_no),
-	},
-};
-
-/*
- * ESP
- */
-
-#define ESPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct ip_esp_hdr, __member)
-
-const struct payload_desc payload_esp = {
-	.name		= "esp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[ESPHDR_SPI]		= ESPHDR_FIELD("spi", spi),
-		[ESPHDR_SEQUENCE]	= ESPHDR_FIELD("sequence", seq_no),
-	},
-};
-
-/*
- * IPCOMP
- */
-
-#define COMPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct ip_comp_hdr, __member)
-
-const struct payload_desc payload_comp = {
-	.name		= "comp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.protocol_key	= COMPHDR_NEXTHDR,
-	.protocols	= {
-		PAYLOAD_PROTO(IPPROTO_ESP,	&payload_esp),
-		PAYLOAD_PROTO(IPPROTO_AH,	&payload_ah),
-		PAYLOAD_PROTO(IPPROTO_COMP,	&payload_comp),
-		PAYLOAD_PROTO(IPPROTO_UDP,	&payload_udp),
-		PAYLOAD_PROTO(IPPROTO_UDPLITE,	&payload_udplite),
-		PAYLOAD_PROTO(IPPROTO_TCP,	&payload_tcp),
-		PAYLOAD_PROTO(IPPROTO_DCCP,	&payload_dccp),
-		PAYLOAD_PROTO(IPPROTO_SCTP,	&payload_sctp),
-	},
-	.templates	= {
-		[COMPHDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ip_comp_hdr, nexthdr),
-		[COMPHDR_FLAGS]		= COMPHDR_FIELD("flags", flags),
-		[COMPHDR_CPI]		= COMPHDR_FIELD("cpi", cpi),
-	},
-};
-
-/*
- * ICMP
- */
-
-#include <netinet/ip_icmp.h>
-
-static const struct symbol_table icmp_type_tbl = {
-	.symbols	= {
-		SYMBOL("echo-reply",			ICMP_ECHOREPLY),
-		SYMBOL("destination-unreachable",	ICMP_DEST_UNREACH),
-		SYMBOL("source-quench",			ICMP_SOURCE_QUENCH),
-		SYMBOL("redirect",			ICMP_REDIRECT),
-		SYMBOL("echo-request",			ICMP_ECHO),
-		SYMBOL("time-exceeded",			ICMP_TIME_EXCEEDED),
-		SYMBOL("parameter-problem",		ICMP_PARAMETERPROB),
-		SYMBOL("timestamp-request",		ICMP_TIMESTAMP),
-		SYMBOL("timestamp-reply",		ICMP_TIMESTAMPREPLY),
-		SYMBOL("info-request",			ICMP_INFO_REQUEST),
-		SYMBOL("info-reply",			ICMP_INFO_REPLY),
-		SYMBOL("address-mask-request",		ICMP_ADDRESS),
-		SYMBOL("address-mask-reply",		ICMP_ADDRESSREPLY),
-		SYMBOL_LIST_END
-	},
-};
-
-static const struct datatype icmp_type_type = {
-	.type		= TYPE_ICMP_TYPE,
-	.name		= "icmp_type",
-	.desc		= "ICMP type",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
-	.size		= BITS_PER_BYTE,
-	.basetype	= &integer_type,
-	.sym_tbl	= &icmp_type_tbl,
-};
-
-#define ICMPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct icmphdr, __member)
-#define ICMPHDR_TYPE(__name, __type, __member) \
-	HDR_TYPE(__name, __type, struct icmphdr, __member)
-
-const struct payload_desc payload_icmp = {
-	.name		= "icmp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[ICMPHDR_TYPE]		= ICMPHDR_TYPE("type", &icmp_type_type, type),
-		[ICMPHDR_CODE]		= ICMPHDR_FIELD("code", code),
-		[ICMPHDR_CHECKSUM]	= ICMPHDR_FIELD("checksum", checksum),
-		[ICMPHDR_ID]		= ICMPHDR_FIELD("id", un.echo.id),
-		[ICMPHDR_SEQ]		= ICMPHDR_FIELD("sequence", un.echo.sequence),
-		[ICMPHDR_GATEWAY]	= ICMPHDR_FIELD("gateway", un.gateway),
-		[ICMPHDR_MTU]		= ICMPHDR_FIELD("mtu", un.frag.mtu),
-	},
-};
-
-/*
- * UDP/UDP-Lite
- */
-
-#include <netinet/udp.h>
-#define UDPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct udphdr, __member)
-
-const struct payload_desc payload_udp = {
-	.name		= "udp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
-		[UDPHDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
-		[UDPHDR_LENGTH]		= UDPHDR_FIELD("length", len),
-		[UDPHDR_CHECKSUM]	= UDPHDR_FIELD("checksum", check),
-	},
-};
-
-const struct payload_desc payload_udplite = {
-	.name		= "udplite",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
-		[UDPHDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
-		[UDPHDR_CSUMCOV]	= UDPHDR_FIELD("csumcov", len),
-		[UDPHDR_CHECKSUM]	= UDPHDR_FIELD("checksum", check),
-	},
-};
-
-/*
- * TCP
- */
-
-#include <netinet/tcp.h>
-
-static const struct symbol_table tcp_flag_tbl = {
-	.symbols	= {
-		SYMBOL("fin",	TCP_FLAG_FIN),
-		SYMBOL("syn",	TCP_FLAG_SYN),
-		SYMBOL("rst",	TCP_FLAG_RST),
-		SYMBOL("psh",	TCP_FLAG_PSH),
-		SYMBOL("ack",	TCP_FLAG_ACK),
-		SYMBOL("urg",	TCP_FLAG_URG),
-		SYMBOL("ecn",	TCP_FLAG_ECN),
-		SYMBOL("cwr",	TCP_FLAG_CWR),
-		SYMBOL_LIST_END
-	},
-};
-
-static const struct datatype tcp_flag_type = {
-	.type		= TYPE_TCP_FLAG,
-	.name		= "tcp_flag",
-	.desc		= "TCP flag",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
-	.size		= BITS_PER_BYTE,
-	.basetype	= &bitmask_type,
-	.sym_tbl	= &tcp_flag_tbl,
-};
-
-#define TCPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct tcphdr, __member)
-
-const struct payload_desc payload_tcp = {
-	.name		= "tcp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[TCPHDR_SPORT]		= INET_SERVICE("sport", struct tcphdr, source),
-		[TCPHDR_DPORT]		= INET_SERVICE("dport", struct tcphdr, dest),
-		[TCPHDR_SEQ]		= TCPHDR_FIELD("sequence", seq),
-		[TCPHDR_ACKSEQ]		= TCPHDR_FIELD("ackseq", ack_seq),
-		[TCPHDR_DOFF]		= {},
-		[TCPHDR_RESERVED]	= {},
-		[TCPHDR_FLAGS]		= HDR_BITFIELD("flags", &tcp_flag_type,
-						       13 * BITS_PER_BYTE,
-						       BITS_PER_BYTE),
-		[TCPHDR_WINDOW]		= TCPHDR_FIELD("window", window),
-		[TCPHDR_CHECKSUM]	= TCPHDR_FIELD("checksum", check),
-		[TCPHDR_URGPTR]		= TCPHDR_FIELD("urgptr", urg_ptr),
-	},
-};
-
-/*
- * DCCP
- */
-
-static const struct symbol_table dccp_pkttype_tbl = {
-	.symbols	= {
-		SYMBOL("request",	DCCP_PKT_REQUEST),
-		SYMBOL("response",	DCCP_PKT_RESPONSE),
-		SYMBOL("data",		DCCP_PKT_DATA),
-		SYMBOL("ack",		DCCP_PKT_ACK),
-		SYMBOL("dataack",	DCCP_PKT_DATAACK),
-		SYMBOL("closereq",	DCCP_PKT_CLOSEREQ),
-		SYMBOL("close",		DCCP_PKT_CLOSE),
-		SYMBOL("reset",		DCCP_PKT_RESET),
-		SYMBOL("sync",		DCCP_PKT_SYNC),
-		SYMBOL("syncack",	DCCP_PKT_SYNCACK),
-		SYMBOL_LIST_END
-	},
-};
-
-static const struct datatype dccp_pkttype_type = {
-	.type		= TYPE_DCCP_PKTTYPE,
-	.name		= "dccp_pkttype",
-	.desc		= "DCCP packet type",
-	.byteorder	= BYTEORDER_INVALID,
-	.size		= 4,
-	.basetype	= &integer_type,
-	.sym_tbl	= &dccp_pkttype_tbl,
-};
-
-
-#define DCCPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct dccp_hdr, __member)
-
-const struct payload_desc payload_dccp = {
-	.name		= "dccp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[DCCPHDR_SPORT]		= INET_SERVICE("sport", struct dccp_hdr, dccph_sport),
-		[DCCPHDR_DPORT]		= INET_SERVICE("dport", struct dccp_hdr, dccph_dport),
-		[DCCPHDR_TYPE]		= HDR_BITFIELD("type", &dccp_pkttype_type, 67, 4),
-	},
-};
-
-/*
- * SCTP
- */
-
-#define SCTPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct sctphdr, __member)
-
-const struct payload_desc payload_sctp = {
-	.name		= "sctp",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[SCTPHDR_SPORT]		= INET_SERVICE("sport", struct sctphdr, source),
-		[SCTPHDR_DPORT]		= INET_SERVICE("dport", struct sctphdr, dest),
-		[SCTPHDR_VTAG]		= SCTPHDR_FIELD("vtag", vtag),
-		[SCTPHDR_CHECKSUM]	= SCTPHDR_FIELD("checksum", checksum),
-	},
-};
-
-/*
- * IPv4
- */
-
-#include <netinet/ip.h>
-#define IPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct iphdr, __member)
-#define IPHDR_ADDR(__name, __member) \
-	HDR_TYPE(__name, &ipaddr_type, struct iphdr, __member)
-
-const struct payload_desc payload_ip = {
-	.name		= "ip",
-	.base		= PAYLOAD_BASE_NETWORK_HDR,
-	.protocol_key	= IPHDR_PROTOCOL,
-	.protocols	= {
-		PAYLOAD_PROTO(IPPROTO_ICMP,	&payload_icmp),
-		PAYLOAD_PROTO(IPPROTO_ESP,	&payload_esp),
-		PAYLOAD_PROTO(IPPROTO_AH,	&payload_ah),
-		PAYLOAD_PROTO(IPPROTO_COMP,	&payload_comp),
-		PAYLOAD_PROTO(IPPROTO_UDP,	&payload_udp),
-		PAYLOAD_PROTO(IPPROTO_UDPLITE,	&payload_udplite),
-		PAYLOAD_PROTO(IPPROTO_TCP,	&payload_tcp),
-		PAYLOAD_PROTO(IPPROTO_DCCP,	&payload_dccp),
-		PAYLOAD_PROTO(IPPROTO_SCTP,	&payload_sctp),
-	},
-	.templates	= {
-		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
-		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
-		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
-		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
-		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
-		[IPHDR_TTL]		= IPHDR_FIELD("ttl",		ttl),
-		[IPHDR_PROTOCOL]	= INET_PROTOCOL("protocol", struct iphdr, protocol),
-		[IPHDR_CHECKSUM]	= IPHDR_FIELD("checksum",	check),
-		[IPHDR_SADDR]		= IPHDR_ADDR("saddr",		saddr),
-		[IPHDR_DADDR]		= IPHDR_ADDR("daddr",		daddr),
-	},
-};
-
-/*
- * ICMPv6
- */
-
-#include <netinet/icmp6.h>
-
-static const struct symbol_table icmp6_type_tbl = {
-	.symbols	= {
-		SYMBOL("destination-unreachable",	ICMP6_DST_UNREACH),
-		SYMBOL("packet-too-big",		ICMP6_PACKET_TOO_BIG),
-		SYMBOL("time-exceeded",			ICMP6_TIME_EXCEEDED),
-		SYMBOL("param-problem",			ICMP6_PARAM_PROB),
-		SYMBOL("echo-request",			ICMP6_ECHO_REQUEST),
-		SYMBOL("echo-reply",			ICMP6_ECHO_REPLY),
-		SYMBOL("mld-listener-query",		MLD_LISTENER_QUERY),
-		SYMBOL("mld-listener-report",		MLD_LISTENER_REPORT),
-		SYMBOL("mld-listener-reduction",	MLD_LISTENER_REDUCTION),
-		SYMBOL("nd-router-solicit",		ND_ROUTER_SOLICIT),
-		SYMBOL("nd-router-advert",		ND_ROUTER_ADVERT),
-		SYMBOL("nd-neighbor-solicit",		ND_NEIGHBOR_SOLICIT),
-		SYMBOL("nd-neighbor-advert",		ND_NEIGHBOR_ADVERT),
-		SYMBOL("nd-redirect",			ND_REDIRECT),
-		SYMBOL("router-renumbering",		ICMP6_ROUTER_RENUMBERING),
-		SYMBOL_LIST_END
-	},
-};
-
-static const struct datatype icmp6_type_type = {
-	.type		= TYPE_ICMP6_TYPE,
-	.name		= "icmpv6_type",
-	.desc		= "ICMPv6 type",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
-	.size		= BITS_PER_BYTE,
-	.basetype	= &integer_type,
-	.sym_tbl	= &icmp6_type_tbl,
-};
-
-#define ICMP6HDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct icmp6_hdr, __member)
-#define ICMP6HDR_TYPE(__name, __type, __member) \
-	HDR_TYPE(__name, __type, struct icmp6_hdr, __member)
-
-const struct payload_desc payload_icmp6 = {
-	.name		= "icmpv6",
-	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
-	.templates	= {
-		[ICMP6HDR_TYPE]		= ICMP6HDR_TYPE("type", &icmp6_type_type, icmp6_type),
-		[ICMP6HDR_CODE]		= ICMP6HDR_FIELD("code", icmp6_code),
-		[ICMP6HDR_CHECKSUM]	= ICMP6HDR_FIELD("checksum", icmp6_cksum),
-		[ICMP6HDR_PPTR]		= ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
-		[ICMP6HDR_MTU]		= ICMP6HDR_FIELD("packet-too-big", icmp6_mtu),
-		[ICMP6HDR_ID]		= ICMP6HDR_FIELD("id", icmp6_id),
-		[ICMP6HDR_SEQ]		= ICMP6HDR_FIELD("sequence", icmp6_seq),
-		[ICMP6HDR_MAXDELAY]	= ICMP6HDR_FIELD("max-delay", icmp6_maxdelay),
-	},
-};
-
-/*
- * IPv6
- */
-
-#define IP6HDR_FIELD(__name,  __member) \
-	HDR_FIELD(__name, struct ipv6hdr, __member)
-#define IP6HDR_ADDR(__name, __member) \
-	HDR_TYPE(__name, &ip6addr_type, struct ipv6hdr, __member)
-#define IP6HDR_PROTOCOL(__name, __member) \
-	HDR_TYPE(__name, &inet_service_type, struct ipv6hdr, __member)
-
-const struct payload_desc payload_ip6 = {
-	.name		= "ip6",
-	.base		= PAYLOAD_BASE_NETWORK_HDR,
-	.protocol_key	= IP6HDR_NEXTHDR,
-	.protocols	= {
-		PAYLOAD_PROTO(IPPROTO_ESP,	&payload_esp),
-		PAYLOAD_PROTO(IPPROTO_AH,	&payload_ah),
-		PAYLOAD_PROTO(IPPROTO_COMP,	&payload_comp),
-		PAYLOAD_PROTO(IPPROTO_UDP,	&payload_udp),
-		PAYLOAD_PROTO(IPPROTO_UDPLITE,	&payload_udplite),
-		PAYLOAD_PROTO(IPPROTO_TCP,	&payload_tcp),
-		PAYLOAD_PROTO(IPPROTO_DCCP,	&payload_dccp),
-		PAYLOAD_PROTO(IPPROTO_SCTP,	&payload_sctp),
-		PAYLOAD_PROTO(IPPROTO_ICMPV6,	&payload_icmp6),
-	},
-	.templates	= {
-		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
-		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
-		[IP6HDR_FLOWLABEL]	= IP6HDR_FIELD("flowlabel",	flow_lbl),
-		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
-		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
-		[IP6HDR_HOPLIMIT]	= IP6HDR_FIELD("hoplimit",	hop_limit),
-		[IP6HDR_SADDR]		= IP6HDR_ADDR("saddr",		saddr),
-		[IP6HDR_DADDR]		= IP6HDR_ADDR("daddr",		daddr),
-	},
-};
-
-/*
- * ARP
- */
-
-#include <net/if_arp.h>
-
-static const struct symbol_table arpop_tbl = {
-	.symbols	= {
-		SYMBOL("request",	ARPOP_REQUEST),
-		SYMBOL("reply",		ARPOP_REPLY),
-		SYMBOL("rrequest",	ARPOP_RREQUEST),
-		SYMBOL("rreply",	ARPOP_REPLY),
-		SYMBOL("inrequest",	ARPOP_InREQUEST),
-		SYMBOL("inreply",	ARPOP_InREPLY),
-		SYMBOL("nak",		ARPOP_NAK),
-		SYMBOL_LIST_END
-	},
-};
-
-static const struct datatype arpop_type = {
-	.type		= TYPE_ARPOP,
-	.name		= "arp_op",
-	.desc		= "ARP operation",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
-	.size		= 2 * BITS_PER_BYTE,
-	.basetype	= &integer_type,
-	.sym_tbl	= &arpop_tbl,
-};
-
-#define ARPHDR_TYPE(__name, __type, __member) \
-	HDR_TYPE(__name, __type, struct arphdr, __member)
-#define ARPHDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct arphdr, __member)
-
-const struct payload_desc payload_arp = {
-	.name		= "arp",
-	.base		= PAYLOAD_BASE_NETWORK_HDR,
-	.templates	= {
-		[ARPHDR_HRD]		= ARPHDR_FIELD("htype",	ar_hrd),
-		[ARPHDR_PRO]		= ARPHDR_TYPE("ptype", &ethertype_type, ar_pro),
-		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
-		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
-		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
-	},
-};
-
-/*
- * VLAN
- */
-
-#include <net/ethernet.h>
-
-#define VLANHDR_BITFIELD(__name, __offset, __len) \
-	HDR_BITFIELD(__name, &integer_type, __offset, __len)
-#define VLANHDR_TYPE(__name, __type, __member) \
-	HDR_TYPE(__name, __type, struct vlan_hdr, __member)
-
-const struct payload_desc payload_vlan = {
-	.name		= "vlan",
-	.base		= PAYLOAD_BASE_LL_HDR,
-	.protocol_key	= VLANHDR_TYPE,
-	.protocols	= {
-		PAYLOAD_PROTO(ETH_P_IP,		&payload_ip),
-		PAYLOAD_PROTO(ETH_P_ARP,	&payload_arp),
-		PAYLOAD_PROTO(ETH_P_IPV6,	&payload_ip6),
-		PAYLOAD_PROTO(ETH_P_8021Q,	&payload_vlan),
-
-	},
-	.templates	= {
-		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 0, 12),
-		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 12, 1),
-		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 13, 3),
-		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
-	},
-};
-
-/*
- * Ethernet
- */
-
-const struct datatype etheraddr_type = {
-	.type		= TYPE_ETHERADDR,
-	.name		= "etheraddr",
-	.desc		= "Ethernet address",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
-	.size		= ETH_ALEN * BITS_PER_BYTE,
-	.basetype	= &lladdr_type,
-};
-
-static const struct symbol_table ethertype_tbl = {
-	.symbols	= {
-		SYMBOL("ip",		ETH_P_IP),
-		SYMBOL("arp",		ETH_P_ARP),
-		SYMBOL("ipv6",		ETH_P_IPV6),
-		SYMBOL("vlan",		ETH_P_8021Q),
-		SYMBOL_LIST_END
-	},
-};
-
-static struct error_record *ethertype_parse(const struct expr *sym,
-					    struct expr **res)
-{
-	struct error_record *erec;
-
-	erec = sym->dtype->basetype->parse(sym, res);
-	if (erec != NULL)
-		return erec;
-	if (*res)
-		return NULL;
-	return symbolic_constant_parse(sym, &ethertype_tbl, res);
-}
-
-static void ethertype_print(const struct expr *expr)
-{
-	return symbolic_constant_print(&ethertype_tbl, expr);
-}
-
-const struct datatype ethertype_type = {
-	.type		= TYPE_ETHERTYPE,
-	.name		= "ethertype",
-	.desc		= "Ethernet protocol",
-	.byteorder	= BYTEORDER_BIG_ENDIAN,
-	.size		= 2 * BITS_PER_BYTE,
-	.basetype	= &integer_type,
-	.basefmt	= "0x%.4Zx",
-	.print		= ethertype_print,
-	.parse		= ethertype_parse,
-};
-
-#define ETHHDR_TEMPLATE(__name, __dtype, __member) \
-	HDR_TEMPLATE(__name, __dtype, struct ether_header, __member)
-#define ETHHDR_TYPE(__name, __member) \
-	ETHHDR_TEMPLATE(__name, &ethertype_type, __member)
-#define ETHHDR_ADDR(__name, __member) \
-	ETHHDR_TEMPLATE(__name, &etheraddr_type, __member)
-
-const struct payload_desc payload_eth = {
-	.name		= "eth",
-	.base		= PAYLOAD_BASE_LL_HDR,
-	.protocol_key	= ETHHDR_TYPE,
-	.protocols	= {
-		PAYLOAD_PROTO(ETH_P_IP,		&payload_ip),
-		PAYLOAD_PROTO(ETH_P_ARP,	&payload_arp),
-		PAYLOAD_PROTO(ETH_P_IPV6,	&payload_ip6),
-		PAYLOAD_PROTO(ETH_P_8021Q,	&payload_vlan),
-	},
-	.templates	= {
-		[ETHHDR_DADDR]		= ETHHDR_ADDR("daddr", ether_dhost),
-		[ETHHDR_SADDR]		= ETHHDR_ADDR("saddr", ether_shost),
-		[ETHHDR_TYPE]		= ETHHDR_TYPE("type", ether_type),
-	},
-};
-
-static void __init payload_init(void)
-{
-	datatype_register(&icmp_type_type);
-	datatype_register(&tcp_flag_type);
-	datatype_register(&dccp_pkttype_type);
-	datatype_register(&arpop_type);
-	datatype_register(&ethertype_type);
-	datatype_register(&icmp6_type_type);
-}
diff --git a/src/proto.c b/src/proto.c
new file mode 100644
index 0000000..c6428e4
--- /dev/null
+++ b/src/proto.c
@@ -0,0 +1,731 @@
+/*
+ * Protocol header and type definitions and related functions.
+ *
+ * Copyright (c) 2014 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <net/if_arp.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+
+#include <expression.h>
+#include <headers.h>
+#include <proto.h>
+#include <gmputil.h>
+#include <utils.h>
+
+const char *proto_base_names[] = {
+	[PROTO_BASE_INVALID]		= "invalid",
+	[PROTO_BASE_LL_HDR]		= "link layer",
+	[PROTO_BASE_NETWORK_HDR]	= "network layer",
+	[PROTO_BASE_TRANSPORT_HDR]	= "transport layer",
+};
+
+const char *proto_base_tokens[] = {
+	[PROTO_BASE_INVALID]		= "invalid",
+	[PROTO_BASE_LL_HDR]		= "ll",
+	[PROTO_BASE_NETWORK_HDR]	= "nh",
+	[PROTO_BASE_TRANSPORT_HDR]	= "th",
+};
+
+const struct proto_hdr_template proto_unknown_template =
+	PROTO_HDR_TEMPLATE("unknown", &invalid_type, 0, 0);
+
+const struct proto_desc proto_unknown = {
+	.name		= "unknown",
+	.base		= PROTO_BASE_INVALID,
+};
+
+/**
+ * proto_find_upper - find higher layer protocol description by protocol value
+ * 		      linking it to the lower layer protocol
+ *
+ * @base:	lower layer protocol description
+ * @num:	protocol value
+ */
+const struct proto_desc *
+proto_find_upper(const struct proto_desc *base, unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(base->protocols); i++) {
+		if (base->protocols[i].num == num)
+			return base->protocols[i].desc;
+	}
+	return NULL;
+}
+
+/**
+ * proto_find_num - return protocol number linking two protocols together
+ *
+ * @base:	lower layer protocol description
+ * @desc:	upper layer protocol description
+ */
+int proto_find_num(const struct proto_desc *base,
+		   const struct proto_desc *desc)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(base->protocols); i++) {
+		if (base->protocols[i].desc == desc)
+			return base->protocols[i].num;
+	}
+	return -1;
+}
+
+static const struct dev_proto_desc dev_proto_desc[] = {
+	DEV_PROTO_DESC(ARPHRD_ETHER, &proto_eth),
+};
+
+/**
+ * proto_dev_type - return arphrd type linking a device and a protocol together
+ *
+ * @desc:	the protocol description
+ * @res:	pointer to result
+ */
+int proto_dev_type(const struct proto_desc *desc, uint16_t *res)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(dev_proto_desc); i++) {
+		if (dev_proto_desc[i].desc == desc) {
+			*res = dev_proto_desc[i].type;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+/**
+ * proto_dev_desc - return protocol description for an arphrd type
+ *
+ * @type:	the arphrd type
+ */
+const struct proto_desc *proto_dev_desc(uint16_t type)
+{
+	unsigned int i;
+
+	for (i = 0; i < array_size(dev_proto_desc); i++) {
+		if (dev_proto_desc[i].type == type)
+			return dev_proto_desc[i].desc;
+	}
+	return NULL;
+}
+
+const struct hook_proto_desc hook_proto_desc[] = {
+	[NFPROTO_BRIDGE]	= HOOK_PROTO_DESC(PROTO_BASE_LL_HDR,	  &proto_eth),
+	[NFPROTO_IPV4]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip),
+	[NFPROTO_IPV6]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_ip6),
+	[NFPROTO_ARP]		= HOOK_PROTO_DESC(PROTO_BASE_NETWORK_HDR, &proto_arp),
+};
+
+/**
+ * proto_ctx_init - initialize protocol context for a given hook family
+ *
+ * @ctx:	protocol context
+ * @family:	hook family
+ */
+void proto_ctx_init(struct proto_ctx *ctx, unsigned int family)
+{
+	const struct hook_proto_desc *h = &hook_proto_desc[family];
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->family = family;
+	ctx->protocol[h->base].desc = h->desc;
+}
+
+#define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
+	PROTO_HDR_TEMPLATE(__name, __dtype,				\
+			   offsetof(__type, __member) * 8,		\
+			   field_sizeof(__type, __member) * 8)
+
+#define HDR_FIELD(__name, __struct, __member)				\
+	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
+#define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
+	PROTO_HDR_TEMPLATE(__name, __dtype, __offset, __len)
+#define HDR_TYPE(__name, __dtype, __struct, __member)			\
+	HDR_TEMPLATE(__name, __dtype, __struct, __member)
+
+#define INET_PROTOCOL(__name, __struct, __member)			\
+	HDR_TYPE(__name, &inet_protocol_type, __struct, __member)
+#define INET_SERVICE(__name, __struct, __member)			\
+	HDR_TYPE(__name, &inet_service_type, __struct, __member)
+
+/*
+ * AH
+ */
+
+#define AHHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct ip_auth_hdr, __member)
+
+const struct proto_desc proto_ah = {
+	.name		= "ah",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	= AHHDR_NEXTHDR,
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
+		[AHHDR_NEXTHDR]		= INET_PROTOCOL("nexthdr", struct ip_auth_hdr, nexthdr),
+		[AHHDR_HDRLENGTH]	= AHHDR_FIELD("hdrlength", hdrlen),
+		[AHHDR_RESERVED]	= AHHDR_FIELD("reserved", reserved),
+		[AHHDR_SPI]		= AHHDR_FIELD("spi", spi),
+		[AHHDR_SEQUENCE]	= AHHDR_FIELD("sequence", seq_no),
+	},
+};
+
+/*
+ * ESP
+ */
+
+#define ESPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct ip_esp_hdr, __member)
+
+const struct proto_desc proto_esp = {
+	.name		= "esp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[ESPHDR_SPI]		= ESPHDR_FIELD("spi", spi),
+		[ESPHDR_SEQUENCE]	= ESPHDR_FIELD("sequence", seq_no),
+	},
+};
+
+/*
+ * IPCOMP
+ */
+
+#define COMPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct ip_comp_hdr, __member)
+
+const struct proto_desc proto_comp = {
+	.name		= "comp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	= COMPHDR_NEXTHDR,
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
+		[COMPHDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ip_comp_hdr, nexthdr),
+		[COMPHDR_FLAGS]		= COMPHDR_FIELD("flags", flags),
+		[COMPHDR_CPI]		= COMPHDR_FIELD("cpi", cpi),
+	},
+};
+
+/*
+ * ICMP
+ */
+
+#include <netinet/ip_icmp.h>
+
+static const struct symbol_table icmp_type_tbl = {
+	.symbols	= {
+		SYMBOL("echo-reply",			ICMP_ECHOREPLY),
+		SYMBOL("destination-unreachable",	ICMP_DEST_UNREACH),
+		SYMBOL("source-quench",			ICMP_SOURCE_QUENCH),
+		SYMBOL("redirect",			ICMP_REDIRECT),
+		SYMBOL("echo-request",			ICMP_ECHO),
+		SYMBOL("time-exceeded",			ICMP_TIME_EXCEEDED),
+		SYMBOL("parameter-problem",		ICMP_PARAMETERPROB),
+		SYMBOL("timestamp-request",		ICMP_TIMESTAMP),
+		SYMBOL("timestamp-reply",		ICMP_TIMESTAMPREPLY),
+		SYMBOL("info-request",			ICMP_INFO_REQUEST),
+		SYMBOL("info-reply",			ICMP_INFO_REPLY),
+		SYMBOL("address-mask-request",		ICMP_ADDRESS),
+		SYMBOL("address-mask-reply",		ICMP_ADDRESSREPLY),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype icmp_type_type = {
+	.type		= TYPE_ICMP_TYPE,
+	.name		= "icmp_type",
+	.desc		= "ICMP type",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.sym_tbl	= &icmp_type_tbl,
+};
+
+#define ICMPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct icmphdr, __member)
+#define ICMPHDR_TYPE(__name, __type, __member) \
+	HDR_TYPE(__name, __type, struct icmphdr, __member)
+
+const struct proto_desc proto_icmp = {
+	.name		= "icmp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[ICMPHDR_TYPE]		= ICMPHDR_TYPE("type", &icmp_type_type, type),
+		[ICMPHDR_CODE]		= ICMPHDR_FIELD("code", code),
+		[ICMPHDR_CHECKSUM]	= ICMPHDR_FIELD("checksum", checksum),
+		[ICMPHDR_ID]		= ICMPHDR_FIELD("id", un.echo.id),
+		[ICMPHDR_SEQ]		= ICMPHDR_FIELD("sequence", un.echo.sequence),
+		[ICMPHDR_GATEWAY]	= ICMPHDR_FIELD("gateway", un.gateway),
+		[ICMPHDR_MTU]		= ICMPHDR_FIELD("mtu", un.frag.mtu),
+	},
+};
+
+/*
+ * UDP/UDP-Lite
+ */
+
+#include <netinet/udp.h>
+#define UDPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct udphdr, __member)
+
+const struct proto_desc proto_udp = {
+	.name		= "udp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
+		[UDPHDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
+		[UDPHDR_LENGTH]		= UDPHDR_FIELD("length", len),
+		[UDPHDR_CHECKSUM]	= UDPHDR_FIELD("checksum", check),
+	},
+};
+
+const struct proto_desc proto_udplite = {
+	.name		= "udplite",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
+		[UDPHDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
+		[UDPHDR_CSUMCOV]	= UDPHDR_FIELD("csumcov", len),
+		[UDPHDR_CHECKSUM]	= UDPHDR_FIELD("checksum", check),
+	},
+};
+
+/*
+ * TCP
+ */
+
+#include <netinet/tcp.h>
+
+static const struct symbol_table tcp_flag_tbl = {
+	.symbols	= {
+		SYMBOL("fin",	TCP_FLAG_FIN),
+		SYMBOL("syn",	TCP_FLAG_SYN),
+		SYMBOL("rst",	TCP_FLAG_RST),
+		SYMBOL("psh",	TCP_FLAG_PSH),
+		SYMBOL("ack",	TCP_FLAG_ACK),
+		SYMBOL("urg",	TCP_FLAG_URG),
+		SYMBOL("ecn",	TCP_FLAG_ECN),
+		SYMBOL("cwr",	TCP_FLAG_CWR),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype tcp_flag_type = {
+	.type		= TYPE_TCP_FLAG,
+	.name		= "tcp_flag",
+	.desc		= "TCP flag",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= BITS_PER_BYTE,
+	.basetype	= &bitmask_type,
+	.sym_tbl	= &tcp_flag_tbl,
+};
+
+#define TCPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct tcphdr, __member)
+
+const struct proto_desc proto_tcp = {
+	.name		= "tcp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[TCPHDR_SPORT]		= INET_SERVICE("sport", struct tcphdr, source),
+		[TCPHDR_DPORT]		= INET_SERVICE("dport", struct tcphdr, dest),
+		[TCPHDR_SEQ]		= TCPHDR_FIELD("sequence", seq),
+		[TCPHDR_ACKSEQ]		= TCPHDR_FIELD("ackseq", ack_seq),
+		[TCPHDR_DOFF]		= {},
+		[TCPHDR_RESERVED]	= {},
+		[TCPHDR_FLAGS]		= HDR_BITFIELD("flags", &tcp_flag_type,
+						       13 * BITS_PER_BYTE,
+						       BITS_PER_BYTE),
+		[TCPHDR_WINDOW]		= TCPHDR_FIELD("window", window),
+		[TCPHDR_CHECKSUM]	= TCPHDR_FIELD("checksum", check),
+		[TCPHDR_URGPTR]		= TCPHDR_FIELD("urgptr", urg_ptr),
+	},
+};
+
+/*
+ * DCCP
+ */
+
+static const struct symbol_table dccp_pkttype_tbl = {
+	.symbols	= {
+		SYMBOL("request",	DCCP_PKT_REQUEST),
+		SYMBOL("response",	DCCP_PKT_RESPONSE),
+		SYMBOL("data",		DCCP_PKT_DATA),
+		SYMBOL("ack",		DCCP_PKT_ACK),
+		SYMBOL("dataack",	DCCP_PKT_DATAACK),
+		SYMBOL("closereq",	DCCP_PKT_CLOSEREQ),
+		SYMBOL("close",		DCCP_PKT_CLOSE),
+		SYMBOL("reset",		DCCP_PKT_RESET),
+		SYMBOL("sync",		DCCP_PKT_SYNC),
+		SYMBOL("syncack",	DCCP_PKT_SYNCACK),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype dccp_pkttype_type = {
+	.type		= TYPE_DCCP_PKTTYPE,
+	.name		= "dccp_pkttype",
+	.desc		= "DCCP packet type",
+	.byteorder	= BYTEORDER_INVALID,
+	.size		= 4,
+	.basetype	= &integer_type,
+	.sym_tbl	= &dccp_pkttype_tbl,
+};
+
+
+#define DCCPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct dccp_hdr, __member)
+
+const struct proto_desc proto_dccp = {
+	.name		= "dccp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[DCCPHDR_SPORT]		= INET_SERVICE("sport", struct dccp_hdr, dccph_sport),
+		[DCCPHDR_DPORT]		= INET_SERVICE("dport", struct dccp_hdr, dccph_dport),
+		[DCCPHDR_TYPE]		= HDR_BITFIELD("type", &dccp_pkttype_type, 67, 4),
+	},
+};
+
+/*
+ * SCTP
+ */
+
+#define SCTPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct sctphdr, __member)
+
+const struct proto_desc proto_sctp = {
+	.name		= "sctp",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[SCTPHDR_SPORT]		= INET_SERVICE("sport", struct sctphdr, source),
+		[SCTPHDR_DPORT]		= INET_SERVICE("dport", struct sctphdr, dest),
+		[SCTPHDR_VTAG]		= SCTPHDR_FIELD("vtag", vtag),
+		[SCTPHDR_CHECKSUM]	= SCTPHDR_FIELD("checksum", checksum),
+	},
+};
+
+/*
+ * IPv4
+ */
+
+#include <netinet/ip.h>
+#define IPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct iphdr, __member)
+#define IPHDR_ADDR(__name, __member) \
+	HDR_TYPE(__name, &ipaddr_type, struct iphdr, __member)
+
+const struct proto_desc proto_ip = {
+	.name		= "ip",
+	.base		= PROTO_BASE_NETWORK_HDR,
+	.protocol_key	= IPHDR_PROTOCOL,
+	.protocols	= {
+		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
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
+		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
+		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
+		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
+		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
+		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
+		[IPHDR_TTL]		= IPHDR_FIELD("ttl",		ttl),
+		[IPHDR_PROTOCOL]	= INET_PROTOCOL("protocol", struct iphdr, protocol),
+		[IPHDR_CHECKSUM]	= IPHDR_FIELD("checksum",	check),
+		[IPHDR_SADDR]		= IPHDR_ADDR("saddr",		saddr),
+		[IPHDR_DADDR]		= IPHDR_ADDR("daddr",		daddr),
+	},
+};
+
+/*
+ * ICMPv6
+ */
+
+#include <netinet/icmp6.h>
+
+static const struct symbol_table icmp6_type_tbl = {
+	.symbols	= {
+		SYMBOL("destination-unreachable",	ICMP6_DST_UNREACH),
+		SYMBOL("packet-too-big",		ICMP6_PACKET_TOO_BIG),
+		SYMBOL("time-exceeded",			ICMP6_TIME_EXCEEDED),
+		SYMBOL("param-problem",			ICMP6_PARAM_PROB),
+		SYMBOL("echo-request",			ICMP6_ECHO_REQUEST),
+		SYMBOL("echo-reply",			ICMP6_ECHO_REPLY),
+		SYMBOL("mld-listener-query",		MLD_LISTENER_QUERY),
+		SYMBOL("mld-listener-report",		MLD_LISTENER_REPORT),
+		SYMBOL("mld-listener-reduction",	MLD_LISTENER_REDUCTION),
+		SYMBOL("nd-router-solicit",		ND_ROUTER_SOLICIT),
+		SYMBOL("nd-router-advert",		ND_ROUTER_ADVERT),
+		SYMBOL("nd-neighbor-solicit",		ND_NEIGHBOR_SOLICIT),
+		SYMBOL("nd-neighbor-advert",		ND_NEIGHBOR_ADVERT),
+		SYMBOL("nd-redirect",			ND_REDIRECT),
+		SYMBOL("router-renumbering",		ICMP6_ROUTER_RENUMBERING),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype icmp6_type_type = {
+	.type		= TYPE_ICMP6_TYPE,
+	.name		= "icmpv6_type",
+	.desc		= "ICMPv6 type",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.sym_tbl	= &icmp6_type_tbl,
+};
+
+#define ICMP6HDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct icmp6_hdr, __member)
+#define ICMP6HDR_TYPE(__name, __type, __member) \
+	HDR_TYPE(__name, __type, struct icmp6_hdr, __member)
+
+const struct proto_desc proto_icmp6 = {
+	.name		= "icmpv6",
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[ICMP6HDR_TYPE]		= ICMP6HDR_TYPE("type", &icmp6_type_type, icmp6_type),
+		[ICMP6HDR_CODE]		= ICMP6HDR_FIELD("code", icmp6_code),
+		[ICMP6HDR_CHECKSUM]	= ICMP6HDR_FIELD("checksum", icmp6_cksum),
+		[ICMP6HDR_PPTR]		= ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
+		[ICMP6HDR_MTU]		= ICMP6HDR_FIELD("packet-too-big", icmp6_mtu),
+		[ICMP6HDR_ID]		= ICMP6HDR_FIELD("id", icmp6_id),
+		[ICMP6HDR_SEQ]		= ICMP6HDR_FIELD("sequence", icmp6_seq),
+		[ICMP6HDR_MAXDELAY]	= ICMP6HDR_FIELD("max-delay", icmp6_maxdelay),
+	},
+};
+
+/*
+ * IPv6
+ */
+
+#define IP6HDR_FIELD(__name,  __member) \
+	HDR_FIELD(__name, struct ipv6hdr, __member)
+#define IP6HDR_ADDR(__name, __member) \
+	HDR_TYPE(__name, &ip6addr_type, struct ipv6hdr, __member)
+#define IP6HDR_PROTOCOL(__name, __member) \
+	HDR_TYPE(__name, &inet_service_type, struct ipv6hdr, __member)
+
+const struct proto_desc proto_ip6 = {
+	.name		= "ip6",
+	.base		= PROTO_BASE_NETWORK_HDR,
+	.protocol_key	= IP6HDR_NEXTHDR,
+	.protocols	= {
+		PROTO_LINK(IPPROTO_ESP,		&proto_esp),
+		PROTO_LINK(IPPROTO_AH,		&proto_ah),
+		PROTO_LINK(IPPROTO_COMP,	&proto_comp),
+		PROTO_LINK(IPPROTO_UDP,		&proto_udp),
+		PROTO_LINK(IPPROTO_UDPLITE,	&proto_udplite),
+		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
+		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
+		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
+	},
+	.templates	= {
+		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
+		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
+		[IP6HDR_FLOWLABEL]	= IP6HDR_FIELD("flowlabel",	flow_lbl),
+		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
+		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
+		[IP6HDR_HOPLIMIT]	= IP6HDR_FIELD("hoplimit",	hop_limit),
+		[IP6HDR_SADDR]		= IP6HDR_ADDR("saddr",		saddr),
+		[IP6HDR_DADDR]		= IP6HDR_ADDR("daddr",		daddr),
+	},
+};
+
+/*
+ * ARP
+ */
+
+#include <net/if_arp.h>
+
+static const struct symbol_table arpop_tbl = {
+	.symbols	= {
+		SYMBOL("request",	ARPOP_REQUEST),
+		SYMBOL("reply",		ARPOP_REPLY),
+		SYMBOL("rrequest",	ARPOP_RREQUEST),
+		SYMBOL("rreply",	ARPOP_REPLY),
+		SYMBOL("inrequest",	ARPOP_InREQUEST),
+		SYMBOL("inreply",	ARPOP_InREPLY),
+		SYMBOL("nak",		ARPOP_NAK),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype arpop_type = {
+	.type		= TYPE_ARPOP,
+	.name		= "arp_op",
+	.desc		= "ARP operation",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 2 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.sym_tbl	= &arpop_tbl,
+};
+
+#define ARPHDR_TYPE(__name, __type, __member) \
+	HDR_TYPE(__name, __type, struct arphdr, __member)
+#define ARPHDR_FIELD(__name, __member) \
+	HDR_FIELD(__name, struct arphdr, __member)
+
+const struct proto_desc proto_arp = {
+	.name		= "arp",
+	.base		= PROTO_BASE_NETWORK_HDR,
+	.templates	= {
+		[ARPHDR_HRD]		= ARPHDR_FIELD("htype",	ar_hrd),
+		[ARPHDR_PRO]		= ARPHDR_TYPE("ptype", &ethertype_type, ar_pro),
+		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
+		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
+		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
+	},
+};
+
+/*
+ * VLAN
+ */
+
+#include <net/ethernet.h>
+
+#define VLANHDR_BITFIELD(__name, __offset, __len) \
+	HDR_BITFIELD(__name, &integer_type, __offset, __len)
+#define VLANHDR_TYPE(__name, __type, __member) \
+	HDR_TYPE(__name, __type, struct vlan_hdr, __member)
+
+const struct proto_desc proto_vlan = {
+	.name		= "vlan",
+	.base		= PROTO_BASE_LL_HDR,
+	.protocol_key	= VLANHDR_TYPE,
+	.protocols	= {
+		PROTO_LINK(ETH_P_IP,		&proto_ip),
+		PROTO_LINK(ETH_P_ARP,		&proto_arp),
+		PROTO_LINK(ETH_P_IPV6,		&proto_ip6),
+		PROTO_LINK(ETH_P_8021Q,		&proto_vlan),
+
+	},
+	.templates	= {
+		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 0, 12),
+		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 12, 1),
+		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 13, 3),
+		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
+	},
+};
+
+/*
+ * Ethernet
+ */
+
+const struct datatype etheraddr_type = {
+	.type		= TYPE_ETHERADDR,
+	.name		= "etheraddr",
+	.desc		= "Ethernet address",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= ETH_ALEN * BITS_PER_BYTE,
+	.basetype	= &lladdr_type,
+};
+
+static const struct symbol_table ethertype_tbl = {
+	.symbols	= {
+		SYMBOL("ip",		ETH_P_IP),
+		SYMBOL("arp",		ETH_P_ARP),
+		SYMBOL("ipv6",		ETH_P_IPV6),
+		SYMBOL("vlan",		ETH_P_8021Q),
+		SYMBOL_LIST_END
+	},
+};
+
+static struct error_record *ethertype_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	struct error_record *erec;
+
+	erec = sym->dtype->basetype->parse(sym, res);
+	if (erec != NULL)
+		return erec;
+	if (*res)
+		return NULL;
+	return symbolic_constant_parse(sym, &ethertype_tbl, res);
+}
+
+static void ethertype_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&ethertype_tbl, expr);
+}
+
+const struct datatype ethertype_type = {
+	.type		= TYPE_ETHERTYPE,
+	.name		= "ethertype",
+	.desc		= "Ethernet protocol",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 2 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.basefmt	= "0x%.4Zx",
+	.print		= ethertype_print,
+	.parse		= ethertype_parse,
+};
+
+#define ETHHDR_TEMPLATE(__name, __dtype, __member) \
+	HDR_TEMPLATE(__name, __dtype, struct ether_header, __member)
+#define ETHHDR_TYPE(__name, __member) \
+	ETHHDR_TEMPLATE(__name, &ethertype_type, __member)
+#define ETHHDR_ADDR(__name, __member) \
+	ETHHDR_TEMPLATE(__name, &etheraddr_type, __member)
+
+const struct proto_desc proto_eth = {
+	.name		= "eth",
+	.base		= PROTO_BASE_LL_HDR,
+	.protocol_key	= ETHHDR_TYPE,
+	.protocols	= {
+		PROTO_LINK(ETH_P_IP,		&proto_ip),
+		PROTO_LINK(ETH_P_ARP,		&proto_arp),
+		PROTO_LINK(ETH_P_IPV6,		&proto_ip6),
+		PROTO_LINK(ETH_P_8021Q,		&proto_vlan),
+	},
+	.templates	= {
+		[ETHHDR_DADDR]		= ETHHDR_ADDR("daddr", ether_dhost),
+		[ETHHDR_SADDR]		= ETHHDR_ADDR("saddr", ether_shost),
+		[ETHHDR_TYPE]		= ETHHDR_TYPE("type", ether_type),
+	},
+};
+
+static void __init proto_init(void)
+{
+	datatype_register(&icmp_type_type);
+	datatype_register(&tcp_flag_type);
+	datatype_register(&dccp_pkttype_type);
+	datatype_register(&arpop_type);
+	datatype_register(&ethertype_type);
+	datatype_register(&icmp6_type_type);
+}
-- 
1.8.4.2

