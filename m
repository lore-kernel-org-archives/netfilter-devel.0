From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH v2] src: Add support for adding TOS symbols
Date: Fri, 23 May 2014 21:15:13 +0200
Message-ID: <1400872513-25062-1-git-send-email-alvaroneay@gmail.com>
References: <1400868602-23142-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:38429 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaEWTQA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2014 15:16:00 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so5319840wes.9
        for <netfilter-devel@vger.kernel.org>; Fri, 23 May 2014 12:15:59 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id dr6sm4386055wid.6.2014.05.23.12.15.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 May 2014 12:15:58 -0700 (PDT)
In-Reply-To: <1400868602-23142-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to add type of service using symbols not
only with mask.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* I have added the TYPE_TOS in the end of enum datatypes.
* I have added the subtypes of TYPE_TOS in the comment.

 include/datatype.h |    2 ++
 src/proto.c        |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++-
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
index 0a37a65..2f77b40 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -478,10 +478,67 @@ const struct proto_desc proto_sctp = {
  */
 
 #include <netinet/ip.h>
+
+static const struct symbol_table tos_type_tbl = {
+	.symbols	= {
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
+	for (s = tos_type_tbl.symbols; s->identifier != NULL; s++) {
+		if (!strcmp(sym->identifier, s->identifier)) {
+			*res = constant_expr_alloc(&sym->location, sym->dtype,
+						   sym->dtype->byteorder,
+						   sym->dtype->size,
+						   &s->value);
+			return NULL;
+		}
+	}
+
+	*res = NULL;
+	erec = sym->dtype->basetype->parse(sym, res);
+	if (erec != NULL)
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
+static const struct datatype tos_type = {
+	.type		= TYPE_TOS,
+	.name		= "tos_type",
+	.desc		= "type of service",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.basefmt	= "0x%.2Zx",
+	.print		= tos_type_print,
+	.parse		= tos_type_parse,
+};
+
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
 	HDR_TYPE(__name, &ipaddr_type, struct iphdr, __member)
+#define IPHDR_TOS(__name, __member) \
+	HDR_TYPE(__name, &tos_type, struct iphdr, __member)
 
 const struct proto_desc proto_ip = {
 	.name		= "ip",
@@ -501,7 +558,7 @@ const struct proto_desc proto_ip = {
 	.templates	= {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
-		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
+		[IPHDR_TOS]		= IPHDR_TOS("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
 		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
@@ -811,4 +868,5 @@ static void __init proto_init(void)
 	datatype_register(&arpop_type);
 	datatype_register(&ethertype_type);
 	datatype_register(&icmp6_type_type);
+	datatype_register(&tos_type);
 }
-- 
1.7.10.4

