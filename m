From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH 2/2] src: Add DSCP support in nftables
Date: Tue, 27 May 2014 12:00:15 +0200
Message-ID: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43977 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaE0KA5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 06:00:57 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so9116802wgh.23
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 03:00:56 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id lq14sm7046980wic.7.2014.05.27.03.00.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 03:00:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch allows to use DSCP support in nftables.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/datatype.h |    2 ++
 include/proto.h    |    1 +
 src/parser.y       |    2 ++
 src/proto.c        |   73 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
 src/scanner.l      |    1 +
 5 files changed, 79 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index 2ddab7d..987e95e 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -36,6 +36,7 @@
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
  * @TYPE_TOS:		Type of service (integer subtype)
+ * @TYPE_DSCP:		Differentiated Services Field (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -70,6 +71,7 @@ enum datatypes {
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
 	TYPE_TOS,
+	TYPE_DSCP,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/proto.h b/include/proto.h
index bd3701e..233a482 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -169,6 +169,7 @@ enum ip_hdr_fields {
 	IPHDR_INVALID,
 	IPHDR_VERSION,
 	IPHDR_HDRLENGTH,
+	IPHDR_DSCP,
 	IPHDR_TOS,
 	IPHDR_LENGTH,
 	IPHDR_ID,
diff --git a/src/parser.y b/src/parser.y
index 9c20737..1000cad 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -229,6 +229,7 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 %token IP			"ip"
 %token VERSION			"version"
 %token HDRLENGTH		"hdrlength"
+%token DSCP			"dscp"
 %token TOS			"tos"
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
@@ -1793,6 +1794,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
 ip_hdr_field		:	VERSION		{ $$ =3D IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ =3D IPHDR_HDRLENGTH; }
 			|	TOS		{ $$ =3D IPHDR_TOS; }
+			|	DSCP		{ $$ =3D IPHDR_DSCP; }
 			|	LENGTH		{ $$ =3D IPHDR_LENGTH; }
 			|	ID		{ $$ =3D IPHDR_ID; }
 			|	FRAG_OFF	{ $$ =3D IPHDR_FRAG_OFF; }
diff --git a/src/proto.c b/src/proto.c
index cb27495..492e8f3 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -479,6 +479,77 @@ const struct proto_desc proto_sctp =3D {
=20
 #include <netinet/ip.h>
=20
+static const struct symbol_table dscp_type_tbl =3D {
+	.symbols	=3D {
+		SYMBOL("CS0",	0x00),
+		SYMBOL("CS1",	0x08),
+		SYMBOL("CS2",	0x10),
+		SYMBOL("CS3",	0x18),
+		SYMBOL("CS4",	0x20),
+		SYMBOL("CS5",	0x28),
+		SYMBOL("CS6",	0x30),
+		SYMBOL("CS7",	0x38),
+		SYMBOL("BE",	0x00),
+		SYMBOL("AF11",	0x0a),
+		SYMBOL("AF12",	0x0c),
+		SYMBOL("AF13",	0x0e),
+		SYMBOL("AF21",	0x12),
+		SYMBOL("AF22",	0x14),
+		SYMBOL("AF23",	0x16),
+		SYMBOL("AF31",	0x1a),
+		SYMBOL("AF32",	0x1c),
+		SYMBOL("AF33",	0x1e),
+		SYMBOL("AF41",	0x22),
+		SYMBOL("AF42",	0x24),
+		SYMBOL("AF43",	0x26),
+		SYMBOL("EF",	0x2e),
+		SYMBOL_LIST_END
+	},
+};
+
+static struct error_record *dscp_type_parse(const struct expr *sym,
+						  struct expr **res)
+{
+	struct error_record *erec;
+	const struct symbolic_constant *s;
+
+	for (s =3D dscp_type_tbl.symbols; s->identifier !=3D NULL; s++) {
+		if (!strcmp(sym->identifier, s->identifier)) {
+			*res =3D constant_expr_alloc(&sym->location, sym->dtype,
+						   sym->dtype->byteorder,
+						   sym->dtype->size,
+						   &s->value);
+			return NULL;
+		}
+	}
+
+	*res =3D NULL;
+	erec =3D sym->dtype->basetype->parse(sym, res);
+	if (erec !=3D NULL)
+		return erec;
+	if (*res)
+		return NULL;
+
+	return symbolic_constant_parse(sym, &dscp_type_tbl, res);
+}
+
+static void dscp_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&dscp_type_tbl, expr);
+}
+
+static const struct datatype dscp_type =3D {
+	.type		=3D TYPE_DSCP,
+	.name		=3D "dscp_type",
+	.desc		=3D "Differentiated Services Field",
+	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
+	.size		=3D 6,
+	.basetype	=3D &integer_type,
+	.basefmt	=3D "0x%.2Zx",
+	.print		=3D dscp_type_print,
+	.parse		=3D dscp_type_parse,
+};
+
 static const struct symbol_table tos_type_tbl =3D {
 	.symbols	=3D {
 		SYMBOL("minimize-delay",	IPTOS_LOWDELAY),
@@ -558,6 +629,7 @@ const struct proto_desc proto_ip =3D {
 	.templates	=3D {
 		[IPHDR_VERSION]		=3D HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IPHDR_HDRLENGTH]	=3D HDR_BITFIELD("hdrlength", &integer_type, 4, 4)=
,
+		[IPHDR_DSCP]		=3D IPHDR_TOS("dscp",		&dscp_type),
 		[IPHDR_TOS]		=3D IPHDR_TOS("tos",		&tos_type),
 		[IPHDR_LENGTH]		=3D IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		=3D IPHDR_FIELD("id",		id),
@@ -868,5 +940,6 @@ static void __init proto_init(void)
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
+	datatype_register(&dscp_type);
 	datatype_register(&tos_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index 801c030..c70012a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -329,6 +329,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ip"			{ return IP; }
 "version"		{ return VERSION; }
 "hdrlength"		{ return HDRLENGTH; }
+"dscp"			{ return DSCP; }
 "tos"			{ return TOS; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
