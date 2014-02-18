From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3 nft] ct: connlabel matching support
Date: Tue, 18 Feb 2014 10:27:24 +0100
Message-ID: <1392715644-4458-3-git-send-email-fw@strlen.de>
References: <1392715644-4458-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52423 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbaBRJbS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:31:18 -0500
In-Reply-To: <1392715644-4458-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Takes advantage of the fact that the current maximum label storage area
is 128 bits, i.e. the dynamically allocated extension area in the
kernel will always fit into a nft register.

Currently this re-uses rt_symbol_table_init() to read connlabel.conf.
This works since the format is pretty much the same.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since RFC:
  - print function should only output one single label
  - use singular ('label', not 'labels')
  - use extra __init function to init label symtable

 include/datatype.h                  |  2 ++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/ct.c                            | 72 +++++++++++++++++++++++++++++++++++++
 src/parser.y                        |  2 ++
 src/scanner.l                       |  1 +
 5 files changed, 79 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index 9e609cf..2c66e9d 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -34,6 +34,7 @@
  * @TYPE_CT_DIR:	conntrack direction
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
+ * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -66,6 +67,7 @@ enum datatypes {
 	TYPE_CT_DIR,
 	TYPE_CT_STATUS,
 	TYPE_ICMP6_TYPE,
+	TYPE_CT_LABEL,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 448593c..ff9b0a7 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -586,6 +586,7 @@ enum nft_meta_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
+ * @NFT_CT_LABELS: conntrack label bitset (stored in conntrack extension)
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -601,6 +602,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
+	NFT_CT_LABEL,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index 79d4666..08f8e1e 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -20,8 +20,10 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
+#include <erec.h>
 #include <expression.h>
 #include <datatype.h>
+#include <gmputil.h>
 #include <ct.h>
 #include <gmputil.h>
 #include <utils.h>
@@ -91,6 +93,73 @@ static const struct datatype ct_status_type = {
 	.sym_tbl	= &ct_status_tbl,
 };
 
+static struct symbol_table *ct_label_tbl;
+
+#define CT_LABEL_BIT_SIZE 128
+
+static void ct_label_type_print(const struct expr *expr)
+{
+	unsigned long bit = mpz_scan1(expr->value, 0);
+	const struct symbolic_constant *s;
+
+	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
+		if (bit != s->value)
+			continue;
+		printf("%s", s->identifier);
+		return;
+	}
+	/* can happen when connlabel.conf is altered after rules were added */
+	gmp_printf("0x%Zx", &expr->value);
+}
+
+static struct error_record *ct_label_type_parse(const struct expr *sym,
+						struct expr **res)
+{
+	const struct symbolic_constant *s;
+	const struct datatype *dtype;
+	uint8_t data[CT_LABEL_BIT_SIZE];
+	mpz_t value;
+
+	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
+		if (!strcmp(sym->identifier, s->identifier))
+			break;
+	}
+
+	dtype = sym->dtype;
+	if (s->identifier == NULL)
+		return error(&sym->location, "Could not parse %s", dtype->desc);
+
+	if (s->value >= CT_LABEL_BIT_SIZE)
+		return error(&sym->location, "%s: out of range (%u max)",
+			     s->identifier, s->value, CT_LABEL_BIT_SIZE);
+
+	mpz_init2(value, dtype->size);
+	mpz_setbit(value, s->value);
+	mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
+
+	*res = constant_expr_alloc(&sym->location, dtype,
+				   dtype->byteorder, sizeof(data),
+				   data);
+	mpz_clear(value);
+	return NULL;
+}
+
+static const struct datatype ct_label_type = {
+	.type		= TYPE_CT_LABEL,
+	.name		= "ct_label",
+	.desc		= "conntrack label",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= CT_LABEL_BIT_SIZE,
+	.basetype	= &bitmask_type,
+	.print		= ct_label_type_print,
+	.parse		= ct_label_type_parse,
+};
+
+static void __init ct_label_table_init(void)
+{
+	ct_label_tbl = rt_symbol_table_init("/etc/xtables/connlabel.conf");
+}
+
 static const struct ct_template ct_templates[] = {
 	[NFT_CT_STATE]		= CT_TEMPLATE("state",	    &ct_state_type,
 					      BYTEORDER_HOST_ENDIAN,
@@ -125,6 +194,9 @@ static const struct ct_template ct_templates[] = {
 	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &invalid_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
+	[NFT_CT_LABEL]		= CT_TEMPLATE("label", &ct_label_type,
+					      BYTEORDER_HOST_ENDIAN,
+					      CT_LABEL_BIT_SIZE),
 };
 
 static void ct_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 07613e2..b3acc74 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -314,6 +314,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token L3PROTOCOL		"l3proto"
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
+%token LABEL			"label"
 
 %token COUNTER			"counter"
 %token PACKETS			"packets"
@@ -1551,6 +1552,7 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
+			|	LABEL		{ $$ = NFT_CT_LABEL; }
 			;
 
 payload_expr		:	payload_raw_expr
diff --git a/src/scanner.l b/src/scanner.l
index e4cb398..45c6476 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -411,6 +411,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
+"label"			{ return LABEL; }
 
 "xml"			{ return XML; }
 "json"			{ return JSON; }
-- 
1.8.1.5

