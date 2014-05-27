From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH v2] src: Replace TOS support for using DSCP support
Date: Tue, 27 May 2014 16:18:20 +0200
Message-ID: <1401200300-24583-1-git-send-email-alvaroneay@gmail.com>
References: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:59046 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaE0OTF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 10:19:05 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so9714711wes.16
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 07:19:03 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id gd5sm35361326wjb.40.2014.05.27.07.19.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 07:19:02 -0700 (PDT)
In-Reply-To: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* Replace TOS support for using DSCP support

Now, when we add a rule with DSCP, in the code generation step, nftable=
s
compares 1 bytes but it should compare 6 bits. I think that the problem=
 should
be in the code generation.

 include/datatype.h |    2 ++
 include/proto.h    |    2 +-
 src/parser.y       |    4 +--
 src/proto.c        |   77 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++-
 src/scanner.l      |    2 +-
 5 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2c66e9d..87f1202 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -35,6 +35,7 @@
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
+ * @TYPE_DSCP:		Differentiated Services Code Point (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -68,6 +69,7 @@ enum datatypes {
 	TYPE_CT_STATUS,
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
+	TYPE_DSCP,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/proto.h b/include/proto.h
index bd3701e..2a9cb86 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -169,7 +169,7 @@ enum ip_hdr_fields {
 	IPHDR_INVALID,
 	IPHDR_VERSION,
 	IPHDR_HDRLENGTH,
-	IPHDR_TOS,
+	IPHDR_DSCP,
 	IPHDR_LENGTH,
 	IPHDR_ID,
 	IPHDR_FRAG_OFF,
diff --git a/src/parser.y b/src/parser.y
index 9c20737..e64192c 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -229,7 +229,7 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 %token IP			"ip"
 %token VERSION			"version"
 %token HDRLENGTH		"hdrlength"
-%token TOS			"tos"
+%token DSCP			"dscp"
 %token LENGTH			"length"
 %token FRAG_OFF			"frag-off"
 %token TTL			"ttl"
@@ -1792,7 +1792,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
=20
 ip_hdr_field		:	VERSION		{ $$ =3D IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ =3D IPHDR_HDRLENGTH; }
-			|	TOS		{ $$ =3D IPHDR_TOS; }
+			|	DSCP		{ $$ =3D IPHDR_DSCP; }
 			|	LENGTH		{ $$ =3D IPHDR_LENGTH; }
 			|	ID		{ $$ =3D IPHDR_ID; }
 			|	FRAG_OFF	{ $$ =3D IPHDR_FRAG_OFF; }
diff --git a/src/proto.c b/src/proto.c
index 0a37a65..0639d37 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -478,10 +478,84 @@ const struct proto_desc proto_sctp =3D {
  */
=20
 #include <netinet/ip.h>
+
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
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
 	HDR_TYPE(__name, &ipaddr_type, struct iphdr, __member)
+#define IPHDR_TOS(__name, __type) \
+	HDR_TYPE(__name, __type, struct iphdr, tos)
=20
 const struct proto_desc proto_ip =3D {
 	.name		=3D "ip",
@@ -501,7 +575,7 @@ const struct proto_desc proto_ip =3D {
 	.templates	=3D {
 		[IPHDR_VERSION]		=3D HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IPHDR_HDRLENGTH]	=3D HDR_BITFIELD("hdrlength", &integer_type, 4, 4)=
,
-		[IPHDR_TOS]		=3D IPHDR_FIELD("tos",		tos),
+		[IPHDR_DSCP]		=3D IPHDR_TOS("dscp",		&dscp_type),
 		[IPHDR_LENGTH]		=3D IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		=3D IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	=3D IPHDR_FIELD("frag-off",	frag_off),
@@ -811,4 +885,5 @@ static void __init proto_init(void)
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
+	datatype_register(&dscp_type);
 }
diff --git a/src/scanner.l b/src/scanner.l
index 801c030..8371e6f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -329,7 +329,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ip"			{ return IP; }
 "version"		{ return VERSION; }
 "hdrlength"		{ return HDRLENGTH; }
-"tos"			{ return TOS; }
+"dscp"			{ return DSCP; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
 "ttl"			{ return TTL; }
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
