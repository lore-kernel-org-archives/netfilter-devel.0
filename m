From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sat, 15 Feb 2014 23:47:12 +0100
Message-ID: <1392504432-20918-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52025 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbaBOWvB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:51:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Takes advantage of the fact that the current maximum label storage area
is 128 bits, i.e. it will fit into a nft register.

Advantages:
- kernel part is very small (just copies extension storage to register)
- userspace part is not huge either and very powerful since
  we can operate on the entire '128 bit connlabel pseudo-register'
  (f.e. "ct labels & foo|bar == foo" to match when foo is set and bar is not,
   etc)

Disadvantage:

- We get into trouble if kernel would ever increase the current limit
  of 128 labels (its just a matter of changing #define in kernel and
  making sure nf_conn extension offsets can deal with larger sizes).
- Its currently not necessarily doing what the user would think.

The latter point deserves example:

add rule filter output ct labels foo

is NOT the translation of iptables
-m connlabel --label foo

The former matches only if foo and ONLY foo is set.
The latter matches when foo label bit is set and doesn't care about
other labels, i.e. the nft translation would be

add rule filter output ct labels & foo == foo

Thus I am not sure at the moment if this is really the right approach
and if it would be better to follow the xt_connlabel model and ask kernel
for the desired *bit* instead.

It could be done by adding a 'ctlabel' instruction that would check the
bit given in sreg (eg. 3 would do test_bit(... 3) and BREAK if its not set.

Something to also keep in mind is that this currently lacks write
support.  In iptables this is done via
'-m connlabel --label foo --set', which causes atomic set-bit operation.

For nft with current approach it would mean we would need to copy to
reg, alter reg, then copy altered register back to extension area.

What do others think?

Just for reference i've included the userspace part of the change
(treating labels as 128 bit register).

Its not complete for merging at this time, so no SOB line.
---
 include/datatype.h                  |  2 ++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/ct.c                            | 65 +++++++++++++++++++++++++++++++++++++
 src/parser.y                        |  2 ++
 src/scanner.l                       |  1 +
 5 files changed, 72 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index 84dcdc8..3176092 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -32,6 +32,7 @@
  * @TYPE_CT_STATE:	conntrack state (bitmask subtype)
  * @TYPE_CT_DIR:	conntrack direction
  * @TYPE_CT_STATUS:	conntrack status (bitmask subtype)
+ * @TYPE_CT_LABELS:	Conntrack Labels (bitmask subtype)
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  */
 enum datatypes {
@@ -63,6 +64,7 @@ enum datatypes {
 	TYPE_CT_STATE,
 	TYPE_CT_DIR,
 	TYPE_CT_STATUS,
+	TYPE_CT_LABELS,
 	TYPE_ICMP6_TYPE,
 	__TYPE_MAX
 };
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a236cc3..8d9d317 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -507,6 +507,7 @@ enum nft_meta_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
+ * @NFT_CT_LABELS: conntrack label bitset (stored in conntrack extension)
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -522,6 +523,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
+	NFT_CT_LABELS,
 };
 
 /**
diff --git a/src/ct.c b/src/ct.c
index c7849fb..7639944 100644
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
 #include <utils.h>
 
@@ -90,6 +92,65 @@ static const struct datatype ct_status_type = {
 	.sym_tbl	= &ct_status_tbl,
 };
 
+static struct symbol_table *ct_label_tbl;
+#define CT_LABELS_BIT_SIZE 128
+
+static void ct_label_type_print(const struct expr *expr)
+{
+	const struct symbolic_constant *s;
+	unsigned long bit = 0;
+	int cnt = 0;
+
+	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
+		bit = mpz_scan1(expr->value, s->value);
+		if (bit < CT_LABELS_BIT_SIZE && bit == s->value) {
+			if (cnt)
+				printf("|");
+			printf("%s", s->identifier);
+			++cnt;
+		}
+	}
+}
+
+static struct error_record *ct_label_type_parse(const struct expr *sym,
+						struct expr **res)
+{
+	const struct symbolic_constant *s;
+	const struct datatype *dtype;
+	uint8_t data[CT_LABELS_BIT_SIZE];
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
+static const struct datatype ct_labels_type = {
+	.type		= TYPE_CT_LABELS,
+	.name		= "ct_labels",
+	.desc		= "conntrack labels",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= CT_LABELS_BIT_SIZE,
+	.basetype	= &bitmask_type,
+	.print		= ct_label_type_print,
+	.parse		= ct_label_type_parse,
+};
+
 static const struct ct_template ct_templates[] = {
 	[NFT_CT_STATE]		= CT_TEMPLATE("state",	    &ct_state_type,
 					      BYTEORDER_HOST_ENDIAN,
@@ -124,6 +185,9 @@ static const struct ct_template ct_templates[] = {
 	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &invalid_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
+	[NFT_CT_LABELS]		= CT_TEMPLATE("labels", &ct_labels_type,
+					      BYTEORDER_HOST_ENDIAN,
+					      CT_LABELS_BIT_SIZE),
 };
 
 static void ct_expr_print(const struct expr *expr)
@@ -159,4 +223,5 @@ static void __init ct_init(void)
 	datatype_register(&ct_state_type);
 	datatype_register(&ct_dir_type);
 	datatype_register(&ct_status_type);
+	ct_label_tbl = rt_symbol_table_init("/etc/xtables/connlabel.conf");
 }
diff --git a/src/parser.y b/src/parser.y
index 345d8d0..24bd9df 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -305,6 +305,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token L3PROTOCOL		"l3proto"
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
+%token LABELS			"labels"
 
 %token COUNTER			"counter"
 %token PACKETS			"packets"
@@ -1405,6 +1406,7 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
+			|	LABELS		{ $$ = NFT_CT_LABELS; }
 			;
 
 payload_expr		:	payload_raw_expr
diff --git a/src/scanner.l b/src/scanner.l
index c47e610..bfb087c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -399,6 +399,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
+"labels"		{ return LABELS; }
 
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
-- 
1.8.1.5

