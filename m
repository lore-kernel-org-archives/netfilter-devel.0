From: Ana Rey <anarey@gmail.com>
Subject: [nft PATCH] src: Add support for pkttype in meta
Date: Thu, 12 Jun 2014 19:17:53 +0200
Message-ID: <1402593473-4904-3-git-send-email-anarey@gmail.com>
References: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42445 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFLRSL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:18:11 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so1568315wgh.6
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 10:18:09 -0700 (PDT)
In-Reply-To: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joint work with Alvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/datatype.h                  |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 src/meta.c                          | 55 +++++++++++++++++++++++++++++++++++++
 src/parser.y                        |  2 ++
 src/scanner.l                       |  1 +
 5 files changed, 61 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index b53358c..66ca8ed 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -70,6 +70,7 @@ enum datatypes {
 	TYPE_CT_STATUS,
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
+	TYPE_PKTTYPE,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a5f8ec0..e391ed4 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -535,6 +535,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @@NFT_META_PKTTYPE: packet class
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -556,6 +557,7 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_PKTTYPE,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 80f88ff..0155b2a 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -20,6 +20,7 @@
 #include <pwd.h>
 #include <grp.h>
 #include <linux/pkt_sched.h>
+#include <linux/if_packet.h>
 
 #include <nftables.h>
 #include <expression.h>
@@ -297,6 +298,57 @@ static const struct datatype gid_type = {
 	.parse		= gid_type_parse,
 };
 
+static const struct symbol_table pkttype_type_tbl = {
+	.symbols	= {
+		SYMBOL("unicast", PACKET_HOST),
+		SYMBOL("broadcast", PACKET_BROADCAST),
+		SYMBOL("multicast", PACKET_MULTICAST),
+		SYMBOL("loopback", PACKET_LOOPBACK),
+	},
+};
+
+static void pkttype_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&pkttype_type_tbl, expr);
+}
+
+static struct error_record *pkttype_type_parse(const struct expr *sym,
+					       struct expr **res)
+{
+	struct error_record *erec;
+	const struct symbolic_constant *s;
+
+	for (s = pkttype_type_tbl.symbols; s->identifier != NULL; s++) {
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
+	return symbolic_constant_parse(sym, &pkttype_type_tbl, res);
+}
+
+static const struct datatype pkttype_type = {
+	.type		= TYPE_PKTTYPE,
+	.name		= "pkttype",
+	.desc		= "Packet class",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= pkttype_type_print,
+	.parse		= pkttype_type_parse,
+};
+
 static const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -338,6 +390,9 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_BRI_OIFNAME]	= META_TEMPLATE("obriport",  &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_PKTTYPE]	= META_TEMPLATE("pkttype",  &pkttype_type,
+						BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 3e08e21..6da6e98 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -324,6 +324,7 @@ static int monitor_lookup_event(const char *event)
 %token RTCLASSID		"rtclassid"
 %token IBRIPORT			"ibriport"
 %token OBRIPORT			"obriport"
+%token PKTTYPE			"pkttype"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1784,6 +1785,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
 			|	IBRIPORT	{ $$ = NFT_META_BRI_IIFNAME; }
 			|       OBRIPORT	{ $$ = NFT_META_BRI_OIFNAME; }
+			|       PKTTYPE		{ $$ = NFT_META_PKTTYPE; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 73a1a3f..1d2be76 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -406,6 +406,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rtclassid"		{ return RTCLASSID; }
 "ibriport"		{ return IBRIPORT; }
 "obriport"		{ return OBRIPORT; }
+"pkttype"		{ return PKTTYPE; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
2.0.0

