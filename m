From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] src: add ecn support
Date: Wed, 25 Nov 2015 20:39:22 +0100
Message-ID: <1448480362-12411-2-git-send-email-pablo@netfilter.org>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38760 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbbKYTji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 14:39:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AEC88129257
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:39:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9E852DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:39:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 95552DA80B
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 20:39:32 +0100 (CET)
In-Reply-To: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This supports both IPv4:

 # nft --debug=netlink add rule ip filter forward ip ecn ce counter
 ip filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000c0 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x000000c0 ]
  [ counter pkts 0 bytes 0 ]

For IPv6:

 # nft --debug=netlink add rule ip6 filter forward ip6 ecn ce counter
 ip6 filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000c0 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x000000c0 ]
  [ counter pkts 0 bytes 0 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml        | 10 ++++++++++
 include/datatype.h |  1 +
 include/proto.h    |  2 ++
 src/parser_bison.y |  3 +++
 src/proto.c        | 24 ++++++++++++++++++++++++
 src/scanner.l      |  1 +
 6 files changed, 41 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 4ede9e1..1bce4b3 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1342,6 +1342,11 @@ filter output oif eth0
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
@@ -1426,6 +1431,11 @@ filter output oif eth0
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
 								<entry></entry>
diff --git a/include/datatype.h b/include/datatype.h
index 328e12a..31925b4 100644
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
index 41af0c1..914c292 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -177,6 +177,7 @@ enum ip_hdr_fields {
 	IPHDR_VERSION,
 	IPHDR_HDRLENGTH,
 	IPHDR_DSCP,
+	IPHDR_ECN,
 	IPHDR_LENGTH,
 	IPHDR_ID,
 	IPHDR_FRAG_OFF,
@@ -215,6 +216,7 @@ enum ip6_hdr_fields {
 	IP6HDR_VERSION,
 	IP6HDR_PRIORITY,
 	IP6HDR_DSCP,
+	IP6HDR_ECN,
 	IP6HDR_FLOWLABEL,
 	IP6HDR_LENGTH,
 	IP6HDR_NEXTHDR,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7a5d7f8..67c6009 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -247,6 +247,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token HDRVERSION		"version"
 %token HDRLENGTH		"hdrlength"
 %token DSCP			"dscp"
+%token ECN			"ecn"
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
@@ -2173,6 +2174,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
 ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ = IPHDR_HDRLENGTH; }
 			|	DSCP		{ $$ = IPHDR_DSCP; }
+			|	ECN		{ $$ = IPHDR_ECN; }
 			|	LENGTH		{ $$ = IPHDR_LENGTH; }
 			|	ID		{ $$ = IPHDR_ID; }
 			|	FRAG_OFF	{ $$ = IPHDR_FRAG_OFF; }
@@ -2220,6 +2222,7 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
 			|	PRIORITY	{ $$ = IP6HDR_PRIORITY; }
 			|	DSCP		{ $$ = IP6HDR_DSCP; }
+			|	ECN		{ $$ = IP6HDR_ECN; }
 			|	FLOWLABEL	{ $$ = IP6HDR_FLOWLABEL; }
 			|	LENGTH		{ $$ = IP6HDR_LENGTH; }
 			|	NEXTHDR		{ $$ = IP6HDR_NEXTHDR; }
diff --git a/src/proto.c b/src/proto.c
index 0e5932d..a1f5e75 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -523,6 +523,27 @@ static const struct datatype dscp_type = {
 	.sym_tbl	= &dscp_type_tbl,
 };
 
+static const struct symbol_table ecn_type_tbl = {
+	.symbols	= {
+		SYMBOL("non-ect",	0x00),
+		SYMBOL("ect1",		0x01),
+		SYMBOL("ect0",		0x02),
+		SYMBOL("ce",		0x03),
+		SYMBOL_LIST_END
+	},
+};
+
+static const struct datatype ecn_type = {
+	.type		= TYPE_ECN,
+	.name		= "ecn_type",
+	.desc		= "explicit congestion notification",
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
@@ -547,6 +568,7 @@ const struct proto_desc proto_ip = {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
 		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
 		[IPHDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 8, 6),
+		[IPHDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 14, 2),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
@@ -645,6 +667,7 @@ const struct proto_desc proto_ip6 = {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
 		[IP6HDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 8, 6),
+		[IP6HDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 14, 2),
 		[IP6HDR_FLOWLABEL]	= IP6HDR_FIELD("flowlabel",	flow_lbl),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
@@ -850,4 +873,5 @@ static void __init proto_init(void)
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
 	datatype_register(&dscp_type);
+	datatype_register(&ecn_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index cb7ec4c..54063bf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -362,6 +362,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
 "dscp"			{ return DSCP; }
+"ecn"			{ return ECN; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
 "ttl"			{ return TTL; }
-- 
2.1.4

