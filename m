From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 08/12] src: add dscp support
Date: Wed, 11 May 2016 23:05:12 +0200
Message-ID: <1463000716-11885-8-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40462 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbcEKVFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4A86E1BD5B4
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 35AC9FF2C7
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B28FBCA0FF
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:25 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This supports both IPv4:

 # nft --debug=netlink add rule filter forward ip dscp cs1 counter
 ip filter forward
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000080 ]
  [ counter pkts 0 bytes 0 ]

And also IPv6, note that in this case we take two bytes from the payload:

 # nft --debug=netlink add rule ip6 filter input ip6 dscp cs4 counter
 ip6 filter input
  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000008 ]
  [ counter pkts 0 bytes 0 ]

Given the DSCP is split in two bytes, the less significant nibble
of the first byte and the two most significant 2 bits of the second
byte.

The 8 bit traffic class in RFC2460 after the version field are used for
DSCP (6 bit) and ECN (2 bit). Support for ECN comes in a follow up
patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml                     | 11 +++++++---
 include/datatype.h              |  2 ++
 include/proto.h                 |  4 ++--
 src/parser_bison.y              |  7 +++---
 src/proto.c                     | 48 ++++++++++++++++++++++++++++++++++++++---
 src/scanner.l                   |  2 +-
 tests/py/ip/ip.t                | 10 ++++-----
 tests/py/ip/ip.t.payload        | 33 ++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 43 ++++++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t              |  6 ++++++
 tests/py/ip6/ip6.t.payload.inet | 43 ++++++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.ip6  | 33 ++++++++++++++++++++++++++++
 12 files changed, 225 insertions(+), 17 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 19b5607..a2770bf 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1393,9 +1393,9 @@ filter output oif eth0
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
@@ -1477,6 +1477,11 @@ filter output oif eth0
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
 								<entry>integer (20 bit)</entry>
diff --git a/include/datatype.h b/include/datatype.h
index 91ca2dd..e385bac 100644
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
index 2a662a1..14af965 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -183,7 +183,7 @@ enum ip_hdr_fields {
 	IPHDR_INVALID,
 	IPHDR_VERSION,
 	IPHDR_HDRLENGTH,
-	IPHDR_TOS,
+	IPHDR_DSCP,
 	IPHDR_LENGTH,
 	IPHDR_ID,
 	IPHDR_FRAG_OFF,
@@ -220,7 +220,7 @@ enum icmp6_hdr_fields {
 enum ip6_hdr_fields {
 	IP6HDR_INVALID,
 	IP6HDR_VERSION,
-	IP6HDR_PRIORITY,
+	IP6HDR_DSCP,
 	IP6HDR_FLOWLABEL,
 	IP6HDR_LENGTH,
 	IP6HDR_NEXTHDR,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 444ed4c..490047b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -248,7 +248,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token IP			"ip"
 %token HDRVERSION		"version"
 %token HDRLENGTH		"hdrlength"
-%token TOS			"tos"
+%token DSCP			"dscp"
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
@@ -1102,6 +1102,7 @@ type_identifier_list	:	type_identifier
 
 type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
+			|	DSCP	{ $$ = xstrdup("dscp"); }
 			;
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
@@ -2403,7 +2404,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
 
 ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ = IPHDR_HDRLENGTH; }
-			|	TOS		{ $$ = IPHDR_TOS; }
+			|	DSCP		{ $$ = IPHDR_DSCP; }
 			|	LENGTH		{ $$ = IPHDR_LENGTH; }
 			|	ID		{ $$ = IPHDR_ID; }
 			|	FRAG_OFF	{ $$ = IPHDR_FRAG_OFF; }
@@ -2436,7 +2437,7 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 			;
 
 ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
-			|	PRIORITY	{ $$ = IP6HDR_PRIORITY; }
+			|	DSCP		{ $$ = IP6HDR_DSCP; }
 			|	FLOWLABEL	{ $$ = IP6HDR_FLOWLABEL; }
 			|	LENGTH		{ $$ = IP6HDR_LENGTH; }
 			|	NEXTHDR		{ $$ = IP6HDR_NEXTHDR; }
diff --git a/src/proto.c b/src/proto.c
index fb774b1..4c65e1c 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -512,6 +512,46 @@ const struct proto_desc proto_sctp = {
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
+	.name		= "dscp",
+	.desc		= "Differentiated Services Code Point",
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
@@ -536,7 +576,7 @@ const struct proto_desc proto_ip = {
 	.templates	= {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
-		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
+		[IPHDR_DSCP]            = HDR_BITFIELD("dscp", &dscp_type, 8, 6),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
@@ -548,7 +588,7 @@ const struct proto_desc proto_ip = {
 	},
 	.format		= {
 		.order	= {
-			IPHDR_SADDR, IPHDR_DADDR, IPHDR_TOS, IPHDR_TTL,
+			IPHDR_SADDR, IPHDR_DADDR, IPHDR_DSCP, IPHDR_TTL,
 			IPHDR_ID, IPHDR_PROTOCOL, IPHDR_LENGTH,
 		},
 		.filter	= (1 << IPHDR_VERSION)  | (1 << IPHDR_HDRLENGTH) |
@@ -642,6 +682,7 @@ const struct proto_desc proto_ip6 = {
 	},
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
+		[IP6HDR_DSCP]		= HDR_BITFIELD("dscp", &dscp_type, 4, 6),
 		[IP6HDR_FLOWLABEL]	= HDR_BITFIELD("flowlabel", &integer_type, 12, 20),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
@@ -651,7 +692,7 @@ const struct proto_desc proto_ip6 = {
 	},
 	.format		= {
 		.order	= {
-			IP6HDR_SADDR, IP6HDR_DADDR, IP6HDR_PRIORITY,
+			IP6HDR_SADDR, IP6HDR_DADDR, IP6HDR_DSCP,
 			IP6HDR_HOPLIMIT, IP6HDR_FLOWLABEL, IP6HDR_NEXTHDR,
 			IP6HDR_LENGTH,
 		},
@@ -881,4 +922,5 @@ static void __init proto_init(void)
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
+	datatype_register(&dscp_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index 60b61a5..275beaa 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -362,7 +362,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ip"			{ return IP; }
 "version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
-"tos"			{ return TOS; }
+"dscp"			{ return DSCP; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
 "ttl"			{ return TTL; }
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 6dd8fe6..594136c 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -23,11 +23,11 @@
 # <cmdline>:1:37-38: Error: Value 22 exceeds valid range 0-15
 # add rule ip test input ip hdrlength 22
 
-- ip dscp CS1;ok
-- ip dscp != CS1;ok
-- ip dscp 0x38;ok
-- ip dscp != 0x20;ok
-- ip dscp {CS1, CS2, CS3, CS4, CS5, CS6, CS7, BE, AF11, AF12, AF13, AF21, AF22, AF23, AF31, AF32, AF33, AF41, AF42, AF43, EF};ok
+ip dscp cs1;ok
+ip dscp != cs1;ok
+ip dscp 0x38;ok;ip dscp cs7
+ip dscp != 0x20;ok;ip dscp != cs4
+ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 - ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
 - ip dscp != {CS0, CS3};ok
 
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index aa3bfe9..2d4fe42 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -1,3 +1,36 @@
+# ip dscp cs1
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000020 ]
+
+# ip dscp != cs1
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000020 ]
+
+# ip dscp 0x38
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x000000e0 ]
+
+# ip dscp != 0x20
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000080 ]
+
+# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+set%d test-ip4 3
+set%d test-ip4 0
+        element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
 # ip length 232
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 4d4d485..72b5e07 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -1,3 +1,46 @@
+# ip dscp cs1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000020 ]
+
+# ip dscp != cs1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000020 ]
+
+# ip dscp 0x38
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x000000e0 ]
+
+# ip dscp != 0x20
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000080 ]
+
+# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+set%d test-inet 3
+set%d test-inet 0
+        element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
 # ip length 232
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 8226130..2278618 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -10,6 +10,12 @@
 
 - ip6 version 6;ok
 
+ip6 dscp cs1;ok
+ip6 dscp != cs1;ok
+ip6 dscp 0x38;ok;ip6 dscp cs7
+ip6 dscp != 0x20;ok;ip6 dscp != cs4
+ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
+
 ip6 flowlabel 22;ok
 ip6 flowlabel != 233;ok
 - ip6 flowlabel 33-45;ok
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 3d0ae39..35e77c1 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -1,3 +1,46 @@
+# ip6 dscp cs1
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# ip6 dscp != cs1
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000002 ]
+
+# ip6 dscp 0x38
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000e ]
+
+# ip6 dscp != 0x20
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000008 ]
+
+# ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+set%d test-inet 3
+set%d test-inet 0
+        element 00000000  : 0 [end]     element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]    element 00000008  : 0 [end]      element 0000000a  : 0 [end]     element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
+inet test-inet input 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
 # ip6 flowlabel 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 55286ee..7c9d1f5 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -1,3 +1,36 @@
+# ip6 dscp cs1
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# ip6 dscp != cs1
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000002 ]
+
+# ip6 dscp 0x38
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000e ]
+
+# ip6 dscp != 0x20
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000008 ]
+
+# ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+set%d test-ip6 3
+set%d test-ip6 0
+        element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]     element 00000008  : 0 [end]    element 0000000a  : 0 [end]      element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00000000  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
-- 
2.1.4

