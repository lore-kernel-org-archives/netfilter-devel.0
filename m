From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] meta: add prandom matching
Date: Tue,  2 Feb 2016 00:19:00 +0100
Message-ID: <1454368741-16368-3-git-send-email-fw@strlen.de>
References: <1454368741-16368-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35231 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbcBAXVk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 18:21:40 -0500
In-Reply-To: <1454368741-16368-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Probalistic random matching just like iptables
-m statistic --mode random --probability 0.1.

It introduces a new 'probability' type, which looks like fractional
value ("0.25") to the user, but is internally scaled to a uint32_t
where 1.0 is UINT_MAX.

Furthermore, make the default op for the type <= so that
"nft ... meta random 0.5" will match every 2nd packet.

This means that users can still do something like
"nft ... meta random eq 0.1" although thats not very useful (matching
probability 1/UINT_MAX).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml                         | 14 ++++++++++
 include/datatype.h                  |  2 ++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/evaluate.c                      |  3 +++
 src/meta.c                          | 54 +++++++++++++++++++++++++++++++++++++
 src/parser_bison.y                  |  1 +
 src/scanner.l                       |  6 ++++-
 7 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 7cc9988..a934ad3 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -966,6 +966,7 @@ filter output ip6 daddr ::1
 						<arg>l4proto</arg>
 						<arg>protocol</arg>
 						<arg>priority</arg>
+						<arg>random</arg>
 					</group>
 				</cmdsynopsis>
 				<cmdsynopsis>
@@ -1032,6 +1033,11 @@ filter output ip6 daddr ::1
 								<entry>integer (32 bit)</entry>
 							</row>
 							<row>
+								<entry>random</entry>
+								<entry>probability</entry>
+								<entry>probability_type</entry>
+							</row>
+							<row>
 								<entry>mark</entry>
 								<entry>Packet mark</entry>
 								<entry>packetmark</entry>
@@ -1187,6 +1193,14 @@ filter output ip6 daddr ::1
 									Broadcast (to all), Multicast (to group).
 								</entry>
 							</row>
+							<row>
+								<entry>probability_type</entry>
+								<entry>
+									Probability type: floating point value, must be within 0.0 and 0.9999999.
+									The value given is internally mapped to a 32bit integer number.
+								</entry>
+							</row>
+
 						</tbody>
 					</tgroup>
 				</table>
diff --git a/include/datatype.h b/include/datatype.h
index 91ca2dd..dbfd8ff 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -40,6 +40,7 @@
  * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
  * @TYPE_ICMPX_CODE:	icmpx code (integer subtype)
  * @TYPE_DEVGROUP:	devgroup code (integer subtype)
+ * @TYPE_PROBABILITY:	probability value (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -78,6 +79,7 @@ enum datatypes {
 	TYPE_ICMPV6_CODE,
 	TYPE_ICMPX_CODE,
 	TYPE_DEVGROUP,
+	TYPE_PROBABILITY,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 310c785..2fba42d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -668,6 +668,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFGROUP: packet input interface group
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
+ * @NFT_META_PRANDOM: a 32bit pseudo-random number
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -694,6 +695,7 @@ enum nft_meta_keys {
 	NFT_META_IIFGROUP,
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
+	NFT_META_PRANDOM,
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 4d741e3..9fe0d14 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1133,6 +1133,9 @@ static enum ops expr_defaultop(const struct expr *e)
 		if (e->dtype->basetype != NULL &&
 		    e->dtype->basetype->type == TYPE_BITMASK)
 			return OP_FLAGCMP;
+
+		if (e->dtype->type == TYPE_PROBABILITY)
+			return OP_LTE;
 		break;
 	}
 
diff --git a/src/meta.c b/src/meta.c
index 8cbc974..cfdb2e0 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -360,6 +360,55 @@ static const struct datatype devgroup_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
+/* UINT_MAX == 1.0, UINT_MAX/2 == 0.5, etc. */
+static void probability_type_print(const struct expr *expr)
+{
+	uint64_t v = mpz_get_uint32(expr->value) + 0;
+
+	printf("%.9f", 1.0 * v / 0x80000000 / 2.0);
+}
+
+static struct error_record *probability_type_parse(const struct expr *sym,
+						   struct expr **res)
+{
+	char *end;
+	uint64_t value;
+	uint32_t import_value;
+	double limit = 0.000000001;
+	double d = strtod(sym->identifier, &end);
+
+	if (end == sym->identifier)
+		return error(&sym->location, "Could not parse %s", sym->dtype->desc);
+
+	if (d < limit)
+		return error(&sym->location, "Could not parse %s, must be larger or equal to %.9f", sym->dtype->desc,
+			     limit);
+
+	d *= 1000000000u;
+	value = (unsigned long) d;
+	value *= 0x80000000;
+	value *= 2;
+	value /= 1000000000u;
+
+	import_value = value;
+	*res = constant_expr_alloc(&sym->location, sym->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   sizeof(import_value) * BITS_PER_BYTE,
+				   &import_value);
+	return NULL;
+}
+
+static const struct datatype probability_type = {
+	.type		= TYPE_PROBABILITY,
+	.name		= "probability",
+	.desc		= "probability value",
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.size		= 4 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= probability_type_print,
+	.parse		= probability_type_parse,
+};
+
 static const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -416,6 +465,9 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_CGROUP]	= META_TEMPLATE("cgroup",    &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_PRANDOM]	= META_TEMPLATE("random",    &probability_type,
+						4 * BITS_PER_BYTE,
+						BYTEORDER_BIG_ENDIAN), /* avoid conversion; doesn't have endianess */
 };
 
 static bool meta_key_is_qualified(enum nft_meta_keys key)
@@ -426,6 +478,7 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	case NFT_META_L4PROTO:
 	case NFT_META_PROTOCOL:
 	case NFT_META_PRIORITY:
+	case NFT_META_PRANDOM:
 		return true;
 	default:
 		return false;
@@ -589,6 +642,7 @@ static void __init meta_init(void)
 	datatype_register(&gid_type);
 	datatype_register(&devgroup_type);
 	datatype_register(&pkttype_type);
+	datatype_register(&probability_type);
 }
 
 /*
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05ade0f..d22b66b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2235,6 +2235,7 @@ meta_key_qualified	:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
+			|	RANDOM		{ $$ = NFT_META_PRANDOM; }
 			;
 
 meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
diff --git a/src/scanner.l b/src/scanner.l
index a0dee47..d33ab03 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -110,6 +110,7 @@ digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
 hexstring	0[xX]{hexdigit}+
+probability	0.{decstring}
 range		({decstring}?:{decstring}?)
 letter		[a-zA-Z]
 string		({letter})({letter}|{digit}|[/\-_\.])*
@@ -486,7 +487,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				}
 				return NUM;
 			}
-
+{probability}		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
 {hexstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
-- 
2.4.10

