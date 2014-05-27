From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH 1/2 v3] src: Add support for adding TOS symbols
Date: Tue, 27 May 2014 11:59:52 +0200
Message-ID: <1401184792-13969-1-git-send-email-alvaroneay@gmail.com>
References: <1400872513-25062-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52111 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaE0KAf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 06:00:35 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so9114828wgg.21
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 03:00:34 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id l2sm7035439wix.13.2014.05.27.03.00.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 03:00:33 -0700 (PDT)
In-Reply-To: <1400872513-25062-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This patch allows to add type of service using symbols not
only with mask.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
* I have changed the function IPHDR_TOS for adding the struct datatype =
like
  a parameter. With this changes we have a general function that we can=
 use
  for adding DSCP support.

 include/datatype.h |    2 ++
 src/proto.c        |   60 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/include/datatype.h b/include/datatype.h
index 2c66e9d..2ddab7d 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -35,6 +35,7 @@
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
+ * @TYPE_TOS:		Type of service (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -68,6 +69,7 @@ enum datatypes {
 	TYPE_CT_STATUS,
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
+	TYPE_TOS,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/src/proto.c b/src/proto.c
index 0a37a65..cb27495 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -478,10 +478,67 @@ const struct proto_desc proto_sctp =3D {
  */
=20
 #include <netinet/ip.h>
+
+static const struct symbol_table tos_type_tbl =3D {
+	.symbols	=3D {
+		SYMBOL("minimize-delay",	IPTOS_LOWDELAY),
+		SYMBOL("maximize-throughput",	IPTOS_THROUGHPUT),
+		SYMBOL("maximize-reliability",	IPTOS_RELIABILITY),
+		SYMBOL("minimize-cost",		IPTOS_MINCOST),
+		SYMBOL("normal-service",	0),
+		SYMBOL_LIST_END
+	},
+};
+
+static struct error_record *tos_type_parse(const struct expr *sym,
+					   struct expr **res)
+{
+	struct error_record *erec;
+	const struct symbolic_constant *s;
+
+	for (s =3D tos_type_tbl.symbols; s->identifier !=3D NULL; s++) {
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
+	return symbolic_constant_parse(sym, &tos_type_tbl, res);
+}
+
+static void tos_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&tos_type_tbl, expr);
+}
+
+static const struct datatype tos_type =3D {
+	.type		=3D TYPE_TOS,
+	.name		=3D "tos_type",
+	.desc		=3D "type of service",
+	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
+	.size		=3D BITS_PER_BYTE,
+	.basetype	=3D &integer_type,
+	.basefmt	=3D "0x%.2Zx",
+	.print		=3D tos_type_print,
+	.parse		=3D tos_type_parse,
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
@@ -501,7 +558,7 @@ const struct proto_desc proto_ip =3D {
 	.templates	=3D {
 		[IPHDR_VERSION]		=3D HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IPHDR_HDRLENGTH]	=3D HDR_BITFIELD("hdrlength", &integer_type, 4, 4)=
,
-		[IPHDR_TOS]		=3D IPHDR_FIELD("tos",		tos),
+		[IPHDR_TOS]		=3D IPHDR_TOS("tos",		&tos_type),
 		[IPHDR_LENGTH]		=3D IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		=3D IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	=3D IPHDR_FIELD("frag-off",	frag_off),
@@ -811,4 +868,5 @@ static void __init proto_init(void)
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
+	datatype_register(&tos_type);
 }
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
