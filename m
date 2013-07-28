From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] Add icmpv6 support.
Date: Mon, 29 Jul 2013 00:30:56 +0200
Message-ID: <1375050656-9424-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:53365 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3G1WbT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Jul 2013 18:31:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds ICMPv6 support to nftables. It is now possible to
write rules such as:
  nft add rule ip6 filter input icmpv6 type nd-router-advert accept

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/datatype.h |  2 ++
 include/payload.h  | 14 +++++++++++++
 src/parser.y       | 34 ++++++++++++++++++++++++++++---
 src/payload.c      | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/scanner.l      |  4 ++++
 5 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 053fbd9..239d5ea 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -32,6 +32,7 @@
  * @TYPE_CT_STATE:	conntrack state (bitmask subtype)
  * @TYPE_CT_DIR:	conntrack direction
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
+ * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -62,6 +63,7 @@ enum datatypes {
 	TYPE_CT_STATE,
 	TYPE_CT_DIR,
 	TYPE_CT_STATUS,
+	TYPE_ICMP6_TYPE,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/payload.h b/include/payload.h
index 8f5398b..c9cc84f 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -197,6 +197,18 @@ enum icmp_hdr_fields {
 	ICMPHDR_MTU,
 };
 
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
 enum ip6_hdr_fields {
 	IP6HDR_INVALID,
 	IP6HDR_VERSION,
@@ -207,6 +219,7 @@ enum ip6_hdr_fields {
 	IP6HDR_HOPLIMIT,
 	IP6HDR_SADDR,
 	IP6HDR_DADDR,
+	IP6HDR_PROTOCOL,
 };
 
 enum ah_hdr_fields {
@@ -278,6 +291,7 @@ extern const struct payload_desc payload_udplite;
 extern const struct payload_desc payload_tcp;
 extern const struct payload_desc payload_dccp;
 extern const struct payload_desc payload_sctp;
+extern const struct payload_desc payload_icmp6;
 
 extern const struct payload_desc payload_ip;
 extern const struct payload_desc payload_ip6;
diff --git a/src/parser.y b/src/parser.y
index 91981e9..b2314cc 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -232,6 +232,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token NEXTHDR			"nexthdr"
 %token HOPLIMIT			"hoplimit"
 
+%token ICMP6			"icmpv6"
+%token PPTR			"param-problem"
+%token MAXDELAY			"max-delay"
+
+
 %token AH			"ah"
 %token RESERVED			"reserved"
 %token SPI			"spi"
@@ -420,9 +425,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			ip_hdr_expr	icmp_hdr_expr
 %destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr
 %type <val>			ip_hdr_field	icmp_hdr_field
-%type <expr>			ip6_hdr_expr
-%destructor { expr_free($$); }	ip6_hdr_expr
-%type <val>			ip6_hdr_field
+%type <expr>			ip6_hdr_expr    icmp6_hdr_expr
+%destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
+%type <val>			ip6_hdr_field   icmp6_hdr_field
 %type <expr>			auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
 %destructor { expr_free($$); }	auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
 %type <val>			auth_hdr_field	esp_hdr_field		comp_hdr_field
@@ -1337,6 +1342,7 @@ payload_expr		:	payload_raw_expr
 			|	ip_hdr_expr
 			|	icmp_hdr_expr
 			|	ip6_hdr_expr
+			|	icmp6_hdr_expr
 			|	auth_hdr_expr
 			|	esp_hdr_expr
 			|	comp_hdr_expr
@@ -1454,6 +1460,28 @@ ip6_hdr_field		:	VERSION		{ $$ = IP6HDR_VERSION; }
 			|	SADDR		{ $$ = IP6HDR_SADDR; }
 			|	DADDR		{ $$ = IP6HDR_DADDR; }
 			;
+icmp6_hdr_expr		:	ICMP6	icmp6_hdr_field
+			{
+				$$ = payload_expr_alloc(&@$, &payload_icmp6, $2);
+			}
+			|	ICMP6
+			{
+				uint8_t data = IPPROTO_ICMPV6;
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			;
+
+icmp6_hdr_field		:	TYPE		{ $$ = ICMP6HDR_TYPE; }
+			|	CODE		{ $$ = ICMP6HDR_CODE; }
+			|	CHECKSUM	{ $$ = ICMP6HDR_CHECKSUM; }
+			|	PPTR		{ $$ = ICMP6HDR_PPTR; }
+			|	MTU		{ $$ = ICMP6HDR_MTU; }
+			|	ID		{ $$ = ICMP6HDR_ID; }
+			|	SEQUENCE	{ $$ = ICMP6HDR_SEQ; }
+			|	MAXDELAY	{ $$ = ICMP6HDR_MAXDELAY; }
+			;
 
 auth_hdr_expr		:	AH	auth_hdr_field
 			{
diff --git a/src/payload.c b/src/payload.c
index 942bc85..87801b0 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -795,6 +795,64 @@ const struct payload_desc payload_ip = {
 };
 
 /*
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
+const struct payload_desc payload_icmp6 = {
+	.name		= "icmpv6",
+	.base		= PAYLOAD_BASE_TRANSPORT_HDR,
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
+
+/*
  * IPv6
  */
 
@@ -818,6 +876,7 @@ const struct payload_desc payload_ip6 = {
 		PAYLOAD_PROTO(IPPROTO_TCP,	&payload_tcp),
 		PAYLOAD_PROTO(IPPROTO_DCCP,	&payload_dccp),
 		PAYLOAD_PROTO(IPPROTO_SCTP,	&payload_sctp),
+		PAYLOAD_PROTO(IPPROTO_ICMPV6,	&payload_icmp6),
 	},
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
@@ -991,4 +1050,5 @@ static void __init payload_init(void)
 	datatype_register(&dccp_pkttype_type);
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
+	datatype_register(&icmp6_type_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index 7946e94..59e0aac 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -323,6 +323,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "nexthdr"		{ return NEXTHDR; }
 "hoplimit"		{ return HOPLIMIT; }
 
+"icmpv6"		{ return ICMP6; }
+"param-problem"		{ return PPTR; }
+"max-delay"		{ return MAXDELAY; }
+
 "ah"			{ return AH; }
 "reserved"		{ return RESERVED; }
 "spi"			{ return SPI; }
-- 
1.8.3.2

