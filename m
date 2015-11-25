From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: add dscp support
Date: Wed, 25 Nov 2015 20:39:21 +0100
Message-ID: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38759 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbbKYTji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 14:39:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 66ECC129256
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:39:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 596CBDA7E0
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:39:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 19DD8DA7E0
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:39:31 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This supports both IPv4:

 # nft --debug=netlink add rule filter forward ip dscp cs1 counter
 ip filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000003f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000008 ]
  [ counter pkts 0 bytes 0 ]

And IPv6:

 # nft --debug=netlink add rule ip6 filter forward ip6 dscp cs1 counter
 ip6 filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000003f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000008 ]
  [ counter pkts 0 bytes 0 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml        | 11 ++++++++---
 include/datatype.h |  2 ++
 include/proto.h    |  3 ++-
 src/parser_bison.y |  5 +++--
 src/proto.c        | 44 +++++++++++++++++++++++++++++++++++++++++++-
 src/scanner.l      |  2 +-
 6 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index d51876c..4ede9e1 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1337,9 +1337,9 @@ filter output oif eth0
 								<entry>integer (4 bit) FIXME scaling</entry>
 							</row>
 							<row>
-								<entry>tos</entry>
-								<entry>Type Of Service</entry>
-								<entry>FIXME</entry>
+								<entry>dscp</entry>
+								<entry>Differentiated Services Code Point</entry>
+								<entry>integer (6 bit)</entry>
 							</row>
 							<row>
 								<entry>length</entry>
@@ -1421,6 +1421,11 @@ filter output oif eth0
 								<entry></entry>
 							</row>
 							<row>
+								<entry>dscp</entry>
+								<entry>Differentiated Services Code Point</entry>
+								<entry>integer (6 bit)</entry>
+							</row>
+							<row>
 								<entry>flowlabel</entry>
 								<entry>Flow label</entry>
 								<entry></entry>
diff --git a/include/datatype.h b/include/datatype.h
index 07fedce..328e12a 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -40,6 +40,7 @@
  * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
  * @TYPE_ICMPX_CODE:	icmpx code (integer subtype)
  * @TYPE_DEVGROUP:	devgroup code (integer subtype)
+ * @TYPE_DSCP:		Differentiated Services Code Point (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -78,6 +79,7 @@ enum datatypes {
 	TYPE_ICMPV6_CODE,
 	TYPE_ICMPX_CODE,
 	TYPE_DEVGROUP,
+	TYPE_DSCP,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/proto.h b/include/proto.h
index a43bf98..41af0c1 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -176,7 +176,7 @@ enum ip_hdr_fields {
 	IPHDR_INVALID,
 	IPHDR_VERSION,
 	IPHDR_HDRLENGTH,
-	IPHDR_TOS,
+	IPHDR_DSCP,
 	IPHDR_LENGTH,
 	IPHDR_ID,
 	IPHDR_FRAG_OFF,
@@ -214,6 +214,7 @@ enum ip6_hdr_fields {
 	IP6HDR_INVALID,
 	IP6HDR_VERSION,
 	IP6HDR_PRIORITY,
+	IP6HDR_DSCP,
 	IP6HDR_FLOWLABEL,
 	IP6HDR_LENGTH,
 	IP6HDR_NEXTHDR,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e72d24d..7a5d7f8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -246,7 +246,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token IP			"ip"
 %token HDRVERSION		"version"
 %token HDRLENGTH		"hdrlength"
-%token TOS			"tos"
+%token DSCP			"dscp"
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
@@ -2172,7 +2172,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
 
 ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ = IPHDR_HDRLENGTH; }
-			|	TOS		{ $$ = IPHDR_TOS; }
+			|	DSCP		{ $$ = IPHDR_DSCP; }
 			|	LENGTH		{ $$ = IPHDR_LENGTH; }
 			|	ID		{ $$ = IPHDR_ID; }
 			|	FRAG_OFF	{ $$ = IPHDR_FRAG_OFF; }
@@ -2219,6 +2219,7 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 
 ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
 			|	PRIORITY	{ $$ = IP6HDR_PRIORITY; }
+			|	DSCP		{ $$ = IP6HDR_DSCP; }
 			|	FLOWLABEL	{ $$ = IP6HDR_FLOWLABEL; }
 			|	LENGTH		{ $$ = IP6HDR_LENGTH; }
 			|	NEXTHDR		{ $$ = IP6HDR_NEXTHDR; }
diff --git a/src/proto.c b/src/proto.c
index 28b93cb..0e5932d 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -483,6 +483,46 @@ const struct proto_desc proto_sctp = {
  */
 
 #include <netinet/ip.h>
+
+static const struct symbol_table dscp_type_tbl = {
+	.symbols	= {
+		SYMBOL("cs0",	0x00),
+		SYMBOL("cs1",	0x08),
+		SYMBOL("cs2",	0x10),
+		SYMBOL("cs3",	0x18),
+		SYMBOL("cs4",	0x20),
+		SYMBOL("cs5",	0x28),
+		SYMBOL("cs6",	0x30),
+		SYMBOL("cs7",	0x38),
+		SYMBOL("be",	0x00),
+		SYMBOL("af11",	0x0a),
+		SYMBOL("af12",	0x0c),
+		SYMBOL("af13",	0x0e),
+		SYMBOL("af21",	0x12),
+		SYMBOL("af22",	0x14),
+		SYMBOL("af23",	0x16),
+		SYMBOL("af31",	0x1a),
+		SYMBOL("af32",	0x1c),
+		SYMBOL("af33",	0x1e),
+		SYMBOL("af41",	0x22),
+		SYMBOL("af42",	0x24),
+		SYMBOL("af43",	0x26),
+		SYMBOL("ef",	0x2e),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype dscp_type = {
+	.type		= TYPE_DSCP,
+	.name		= "dscp_type",
+	.desc		= "differentiated services code point",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 6,
+	.basetype	= &integer_type,
+	.basefmt	= "0x%.2Zx",
+	.sym_tbl	= &dscp_type_tbl,
+};
+
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
@@ -506,7 +546,7 @@ const struct proto_desc proto_ip = {
 	.templates	= {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
 		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
-		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
+		[IPHDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 8, 6),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
@@ -604,6 +644,7 @@ const struct proto_desc proto_ip6 = {
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
+		[IP6HDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 8, 6),
 		[IP6HDR_FLOWLABEL]	= IP6HDR_FIELD("flowlabel",	flow_lbl),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
@@ -808,4 +849,5 @@ static void __init proto_init(void)
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
+	datatype_register(&dscp_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index 04fddc9..cb7ec4c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -361,7 +361,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ip"			{ return IP; }
 "version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
-"tos"			{ return TOS; }
+"dscp"			{ return DSCP; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
 "ttl"			{ return TTL; }
-- 
2.1.4

