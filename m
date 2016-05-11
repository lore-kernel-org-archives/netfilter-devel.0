From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 09/12] src: add ecn support
Date: Wed, 11 May 2016 23:05:13 +0200
Message-ID: <1463000716-11885-9-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbcEKVFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 915BF1BD5B7
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7CB60CA100
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 54A9CCA100
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:26 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This supports both IPv4:

 # nft --debug=netlink add rule ip filter forward ip ecn ce counter
 ip filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000003 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000003 ]
  [ counter pkts 0 bytes 0 ]

For IPv6:

 # nft --debug=netlink add rule ip6 filter forward ip6 ecn ce counter
 ip6 filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000030 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000030 ]
  [ counter pkts 0 bytes 0 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml        | 10 ++++++++++
 include/datatype.h |  1 +
 include/proto.h    |  2 ++
 src/parser_bison.y | 10 ++++++++++
 src/proto.c        | 30 +++++++++++++++++++++++++++---
 src/scanner.l      |  1 +
 6 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index a2770bf..22d023e 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1398,6 +1398,11 @@ filter output oif eth0
 								<entry>integer (6 bit)</entry>
 							</row>
 							<row>
+								<entry>ecn</entry>
+								<entry>Explicit Congestion Notification</entry>
+								<entry>integer (2 bit)</entry>
+							</row>
+							<row>
 								<entry>length</entry>
 								<entry>Total packet length</entry>
 								<entry>integer (16 bit)</entry>
@@ -1482,6 +1487,11 @@ filter output oif eth0
 								<entry>integer (6 bit)</entry>
 							</row>
 							<row>
+								<entry>ecn</entry>
+								<entry>Explicit Congestion Notification</entry>
+								<entry>integer (2 bit)</entry>
+							</row>
+							<row>
 								<entry>flowlabel</entry>
 								<entry>Flow label</entry>
 								<entry>integer (20 bit)</entry>
diff --git a/include/datatype.h b/include/datatype.h
index e385bac..c7e110f 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -80,6 +80,7 @@ enum datatypes {
 	TYPE_ICMPX_CODE,
 	TYPE_DEVGROUP,
 	TYPE_DSCP,
+	TYPE_ECN,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/proto.h b/include/proto.h
index 14af965..4fa54a7 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -184,6 +184,7 @@ enum ip_hdr_fields {
 	IPHDR_VERSION,
 	IPHDR_HDRLENGTH,
 	IPHDR_DSCP,
+	IPHDR_ECN,
 	IPHDR_LENGTH,
 	IPHDR_ID,
 	IPHDR_FRAG_OFF,
@@ -221,6 +222,7 @@ enum ip6_hdr_fields {
 	IP6HDR_INVALID,
 	IP6HDR_VERSION,
 	IP6HDR_DSCP,
+	IP6HDR_ECN,
 	IP6HDR_FLOWLABEL,
 	IP6HDR_LENGTH,
 	IP6HDR_NEXTHDR,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 490047b..b8d3386 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -249,6 +249,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token HDRVERSION		"version"
 %token HDRLENGTH		"hdrlength"
 %token DSCP			"dscp"
+%token ECN			"ecn"
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
@@ -1103,6 +1104,7 @@ type_identifier_list	:	type_identifier
 type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
 			|	DSCP	{ $$ = xstrdup("dscp"); }
+			|	ECN	{ $$ = xstrdup("ecn"); }
 			;
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
@@ -2187,6 +2189,12 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 						       current_scope(state),
 						       "dnat");
 			}
+			|	ECN
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state),
+						       "ecn");
+			}
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
@@ -2405,6 +2413,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
 ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ = IPHDR_HDRLENGTH; }
 			|	DSCP		{ $$ = IPHDR_DSCP; }
+			|	ECN		{ $$ = IPHDR_ECN; }
 			|	LENGTH		{ $$ = IPHDR_LENGTH; }
 			|	ID		{ $$ = IPHDR_ID; }
 			|	FRAG_OFF	{ $$ = IPHDR_FRAG_OFF; }
@@ -2438,6 +2447,7 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 
 ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
 			|	DSCP		{ $$ = IP6HDR_DSCP; }
+			|	ECN		{ $$ = IP6HDR_ECN; }
 			|	FLOWLABEL	{ $$ = IP6HDR_FLOWLABEL; }
 			|	LENGTH		{ $$ = IP6HDR_LENGTH; }
 			|	NEXTHDR		{ $$ = IP6HDR_NEXTHDR; }
diff --git a/src/proto.c b/src/proto.c
index 4c65e1c..4c12977 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -552,6 +552,27 @@ static const struct datatype dscp_type = {
 	.sym_tbl	= &dscp_type_tbl,
 };
 
+static const struct symbol_table ecn_type_tbl = {
+	.symbols	= {
+		SYMBOL("not-ect",	0x00),
+		SYMBOL("ect1",		0x01),
+		SYMBOL("ect0",		0x02),
+		SYMBOL("ce",		0x03),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype ecn_type = {
+	.type		= TYPE_ECN,
+	.name		= "ecn",
+	.desc		= "Explicit Congestion Notification",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 2,
+	.basetype	= &integer_type,
+	.basefmt	= "0x%.1Zx",
+	.sym_tbl	= &ecn_type_tbl,
+};
+
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
@@ -577,6 +598,7 @@ const struct proto_desc proto_ip = {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
 		[IPHDR_DSCP]            = HDR_BITFIELD("dscp", &dscp_type, 8, 6),
+		[IPHDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 14, 2),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
@@ -588,8 +610,8 @@ const struct proto_desc proto_ip = {
 	},
 	.format		= {
 		.order	= {
-			IPHDR_SADDR, IPHDR_DADDR, IPHDR_DSCP, IPHDR_TTL,
-			IPHDR_ID, IPHDR_PROTOCOL, IPHDR_LENGTH,
+			IPHDR_SADDR, IPHDR_DADDR, IPHDR_DSCP, IPHDR_ECN,
+			IPHDR_TTL, IPHDR_ID, IPHDR_PROTOCOL, IPHDR_LENGTH,
 		},
 		.filter	= (1 << IPHDR_VERSION)  | (1 << IPHDR_HDRLENGTH) |
 			  (1 << IPHDR_FRAG_OFF),
@@ -683,6 +705,7 @@ const struct proto_desc proto_ip6 = {
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IP6HDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 4, 6),
+		[IP6HDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 10, 2),
 		[IP6HDR_FLOWLABEL]	= HDR_BITFIELD("flowlabel", &integer_type, 12, 20),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
@@ -692,7 +715,7 @@ const struct proto_desc proto_ip6 = {
 	},
 	.format		= {
 		.order	= {
-			IP6HDR_SADDR, IP6HDR_DADDR, IP6HDR_DSCP,
+			IP6HDR_SADDR, IP6HDR_DADDR, IP6HDR_DSCP, IP6HDR_ECN,
 			IP6HDR_HOPLIMIT, IP6HDR_FLOWLABEL, IP6HDR_NEXTHDR,
 			IP6HDR_LENGTH,
 		},
@@ -923,4 +946,5 @@ static void __init proto_init(void)
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
 	datatype_register(&dscp_type);
+	datatype_register(&ecn_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index 275beaa..e8b216e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -363,6 +363,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
 "dscp"			{ return DSCP; }
+"ecn"			{ return ECN; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
 "ttl"			{ return TTL; }
-- 
2.1.4

