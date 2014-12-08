From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: add big endian integer datatype
Date: Mon,  8 Dec 2014 19:15:50 +0100
Message-ID: <1418062551-4715-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbaLHSNj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:13:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rules with header fields that rely on the generic integer datatype
from sets are not matching, eg.

 nft add rule filter input udp length { 9 } counter

This set member is an integer represented in host byte order, which
obviously doesn't match the header field (in network byte order).

Since the integer datatype has no specific byteorder, we could rely
on the expression byteorder instead when configuring the context,
before we evaluate the list of set members.

This approach doesn't solve the problem in the delinearize path, since
we infer the datatype from the set keytype, ie. integer_type. But this
type has no specific byteorder (BYTEORDER_INVALID) so
netlink_delinearize_setelem() doesn't know if we sent the integer in
host or network byteorder.

To resolve this, this patch adds TYPE_BE_INTEGER, a dummy integer
subtype, and use it from the protocol header definitions. Thus, the
set keytype indicates what byteorder had been used for the set members.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |    3 +++
 src/datatype.c     |   10 ++++++++++
 src/evaluate.c     |    1 +
 src/exthdr.c       |   30 +++++++++++++++---------------
 src/proto.c        |   22 +++++++++++-----------
 5 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 3f13dcd..e4edcab 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -40,6 +40,7 @@
  * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
  * @TYPE_ICMPX_CODE:	icmpx code (integer subtype)
  * @TYPE_DEVGROUP:	devgroup code (integer subtype)
+ * @TYPE_BE_INTEGER:	big endian integer (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -78,6 +79,7 @@ enum datatypes {
 	TYPE_ICMPV6_CODE,
 	TYPE_ICMPX_CODE,
 	TYPE_DEVGROUP,
+	TYPE_BE_INTEGER,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -206,6 +208,7 @@ extern const struct datatype icmp_code_type;
 extern const struct datatype icmpv6_code_type;
 extern const struct datatype icmpx_code_type;
 extern const struct datatype time_type;
+extern const struct datatype be_integer_type;
 
 extern const struct datatype *concat_type_alloc(const struct expr *expr);
 extern void concat_type_destroy(const struct datatype *dtype);
diff --git a/src/datatype.c b/src/datatype.c
index 729e63b..bfe34ff 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -47,6 +47,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_ICMP_CODE]	= &icmp_code_type,
 	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
 	[TYPE_ICMPX_CODE]	= &icmpx_code_type,
+	[TYPE_BE_INTEGER]	= &be_integer_type,
 };
 
 void datatype_register(const struct datatype *dtype)
@@ -295,10 +296,19 @@ const struct datatype integer_type = {
 	.type		= TYPE_INTEGER,
 	.name		= "integer",
 	.desc		= "integer",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.print		= integer_type_print,
 	.parse		= integer_type_parse,
 };
 
+const struct datatype be_integer_type = {
+	.type		= TYPE_BE_INTEGER,
+	.name		= "big endian integer",
+	.desc		= "be_integer",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+};
+
 static void string_type_print(const struct expr *expr)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
diff --git a/src/evaluate.c b/src/evaluate.c
index 00e55b7..60560dc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -238,6 +238,7 @@ static int expr_evaluate_value(struct eval_ctx *ctx, struct expr **expr)
 			mpz_clear(mask);
 			return -1;
 		}
+		(*expr)->byteorder = ctx->ectx.dtype->byteorder;
 		(*expr)->len = ctx->ectx.len;
 		mpz_clear(mask);
 		break;
diff --git a/src/exthdr.c b/src/exthdr.c
index 9ed0b6a..e225cc9 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -118,7 +118,7 @@ const struct exthdr_desc exthdr_hbh = {
 	.type		= IPPROTO_HOPOPTS,
 	.templates	= {
 		[HBHHDR_NEXTHDR]	= HBH_FIELD("nexthdr", ip6h_nxt, &inet_protocol_type),
-		[HBHHDR_HDRLENGTH]	= HBH_FIELD("hdrlength", ip6h_len, &integer_type),
+		[HBHHDR_HDRLENGTH]	= HBH_FIELD("hdrlength", ip6h_len, &be_integer_type),
 	},
 };
 
@@ -138,7 +138,7 @@ const struct exthdr_desc exthdr_rt2 = {
 
 const struct exthdr_desc exthdr_rt0 = {
 	.templates	= {
-		[RT0HDR_RESERVED]	= RT0_FIELD("reserved", ip6r0_reserved, &integer_type),
+		[RT0HDR_RESERVED]	= RT0_FIELD("reserved", ip6r0_reserved, &be_integer_type),
 		[RT0HDR_ADDR_1]		= RT0_FIELD("addr[1]", ip6r0_addr[0], &ip6addr_type),
 		[RT0HDR_ADDR_1 + 1]	= RT0_FIELD("addr[2]", ip6r0_addr[0], &ip6addr_type),
 		// ...
@@ -160,9 +160,9 @@ const struct exthdr_desc exthdr_rt = {
 #endif
 	.templates	= {
 		[RTHDR_NEXTHDR]		= RT_FIELD("nexthdr", ip6r_nxt, &inet_protocol_type),
-		[RTHDR_HDRLENGTH]	= RT_FIELD("hdrlength", ip6r_len, &integer_type),
-		[RTHDR_TYPE]		= RT_FIELD("type", ip6r_type, &integer_type),
-		[RTHDR_SEG_LEFT]	= RT_FIELD("seg-left", ip6r_segleft, &integer_type),
+		[RTHDR_HDRLENGTH]	= RT_FIELD("hdrlength", ip6r_len, &be_integer_type),
+		[RTHDR_TYPE]		= RT_FIELD("type", ip6r_type, &be_integer_type),
+		[RTHDR_SEG_LEFT]	= RT_FIELD("seg-left", ip6r_segleft, &be_integer_type),
 	},
 };
 
@@ -178,17 +178,17 @@ const struct exthdr_desc exthdr_frag = {
 	.type		= IPPROTO_FRAGMENT,
 	.templates	= {
 		[FRAGHDR_NEXTHDR]	= FRAG_FIELD("nexthdr", ip6f_nxt, &inet_protocol_type),
-		[FRAGHDR_RESERVED]	= FRAG_FIELD("reserved", ip6f_reserved, &integer_type),
-		[FRAGHDR_FRAG_OFF]	= PROTO_HDR_TEMPLATE("frag-off", &integer_type,
+		[FRAGHDR_RESERVED]	= FRAG_FIELD("reserved", ip6f_reserved, &be_integer_type),
+		[FRAGHDR_FRAG_OFF]	= PROTO_HDR_TEMPLATE("frag-off", &be_integer_type,
 							  BYTEORDER_BIG_ENDIAN,
 							  16, 13),
-		[FRAGHDR_RESERVED2]	= PROTO_HDR_TEMPLATE("reserved2", &integer_type,
+		[FRAGHDR_RESERVED2]	= PROTO_HDR_TEMPLATE("reserved2", &be_integer_type,
 							  BYTEORDER_BIG_ENDIAN,
 							  29, 2),
-		[FRAGHDR_MFRAGS]	= PROTO_HDR_TEMPLATE("more-fragments", &integer_type,
+		[FRAGHDR_MFRAGS]	= PROTO_HDR_TEMPLATE("more-fragments", &be_integer_type,
 							  BYTEORDER_BIG_ENDIAN,
 							  31, 1),
-		[FRAGHDR_ID]		= FRAG_FIELD("id", ip6f_ident, &integer_type),
+		[FRAGHDR_ID]		= FRAG_FIELD("id", ip6f_ident, &be_integer_type),
 	},
 };
 
@@ -204,7 +204,7 @@ const struct exthdr_desc exthdr_dst = {
 	.type		= IPPROTO_DSTOPTS,
 	.templates	= {
 		[DSTHDR_NEXTHDR]	= DST_FIELD("nexthdr", ip6d_nxt, &inet_protocol_type),
-		[DSTHDR_HDRLENGTH]	= DST_FIELD("hdrlength", ip6d_len, &integer_type),
+		[DSTHDR_HDRLENGTH]	= DST_FIELD("hdrlength", ip6d_len, &be_integer_type),
 	},
 };
 
@@ -240,7 +240,7 @@ static const struct datatype mh_type_type = {
 	.desc		= "Mobility Header Type",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= BITS_PER_BYTE,
-	.basetype	= &integer_type,
+	.basetype	= &be_integer_type,
 	.sym_tbl	= &mh_type_tbl,
 };
 
@@ -249,10 +249,10 @@ const struct exthdr_desc exthdr_mh = {
 	.type		= IPPROTO_MH,
 	.templates	= {
 		[MHHDR_NEXTHDR]		= MH_FIELD("nexthdr", ip6mh_proto, &inet_protocol_type),
-		[MHHDR_HDRLENGTH]	= MH_FIELD("hdrlength", ip6mh_hdrlen, &integer_type),
+		[MHHDR_HDRLENGTH]	= MH_FIELD("hdrlength", ip6mh_hdrlen, &be_integer_type),
 		[MHHDR_TYPE]		= MH_FIELD("type", ip6mh_type, &mh_type_type),
-		[MHHDR_RESERVED]	= MH_FIELD("reserved", ip6mh_reserved, &integer_type),
-		[MHHDR_CHECKSUM]	= MH_FIELD("checksum", ip6mh_cksum, &integer_type),
+		[MHHDR_RESERVED]	= MH_FIELD("reserved", ip6mh_reserved, &be_integer_type),
+		[MHHDR_CHECKSUM]	= MH_FIELD("checksum", ip6mh_cksum, &be_integer_type),
 	},
 };
 
diff --git a/src/proto.c b/src/proto.c
index 7dc7b3e..2678179 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -191,7 +191,7 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 			   field_sizeof(__type, __member) * 8)
 
 #define HDR_FIELD(__name, __struct, __member)				\
-	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
+	HDR_TEMPLATE(__name, &be_integer_type, __struct, __member)
 #define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype, BYTEORDER_BIG_ENDIAN,	\
 			   __offset, __len)
@@ -308,7 +308,7 @@ static const struct datatype icmp_type_type = {
 	.desc		= "ICMP type",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= BITS_PER_BYTE,
-	.basetype	= &integer_type,
+	.basetype	= &be_integer_type,
 	.sym_tbl	= &icmp_type_tbl,
 };
 
@@ -439,7 +439,7 @@ static const struct datatype dccp_pkttype_type = {
 	.desc		= "DCCP packet type",
 	.byteorder	= BYTEORDER_INVALID,
 	.size		= 4,
-	.basetype	= &integer_type,
+	.basetype	= &be_integer_type,
 	.sym_tbl	= &dccp_pkttype_tbl,
 };
 
@@ -501,8 +501,8 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 	},
 	.templates	= {
-		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
+		[IPHDR_VERSION]		= HDR_BITFIELD("version", &be_integer_type, 0, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &be_integer_type, 4, 4),
 		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
@@ -548,7 +548,7 @@ static const struct datatype icmp6_type_type = {
 	.desc		= "ICMPv6 type",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= BITS_PER_BYTE,
-	.basetype	= &integer_type,
+	.basetype	= &be_integer_type,
 	.sym_tbl	= &icmp6_type_tbl,
 };
 
@@ -599,8 +599,8 @@ const struct proto_desc proto_ip6 = {
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 	},
 	.templates	= {
-		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
-		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
+		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &be_integer_type, 0, 4),
+		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &be_integer_type, 4, 4),
 		[IP6HDR_FLOWLABEL]	= IP6HDR_FIELD("flowlabel",	flow_lbl),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
@@ -677,7 +677,7 @@ static const struct datatype arpop_type = {
 	.desc		= "ARP operation",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= 2 * BITS_PER_BYTE,
-	.basetype	= &integer_type,
+	.basetype	= &be_integer_type,
 	.sym_tbl	= &arpop_tbl,
 };
 
@@ -705,7 +705,7 @@ const struct proto_desc proto_arp = {
 #include <net/ethernet.h>
 
 #define VLANHDR_BITFIELD(__name, __offset, __len) \
-	HDR_BITFIELD(__name, &integer_type, __offset, __len)
+	HDR_BITFIELD(__name, &be_integer_type, __offset, __len)
 #define VLANHDR_TYPE(__name, __type, __member) \
 	HDR_TYPE(__name, __type, struct vlan_hdr, __member)
 
@@ -762,7 +762,7 @@ const struct datatype ethertype_type = {
 	.desc		= "Ethernet protocol",
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= 2 * BITS_PER_BYTE,
-	.basetype	= &integer_type,
+	.basetype	= &be_integer_type,
 	.basefmt	= "0x%.4Zx",
 	.print		= ethertype_print,
 	.sym_tbl	= &ethertype_tbl,
-- 
1.7.10.4

