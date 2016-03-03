From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] meta: add probability matching
Date: Thu,  3 Mar 2016 18:56:53 +0100
Message-ID: <1457027814-14795-2-git-send-email-fw@strlen.de>
References: <1457027814-14795-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56312 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532AbcCCR4r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 12:56:47 -0500
In-Reply-To: <1457027814-14795-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft meta probability 0.5

probalistic matching just like iptables
'-m statistic --mode random --probability 0.5':

Internally nft translates the request to this:

  [ meta load prandom => reg 1 ]
  [ cmp lte reg 1 0xffffff7f ]

but this stays hidden from the user (i.e. <= operator
is not shown on list).

The float value has to be in range of 0.0000001 to 0.9999999 and
is internally scaled from 0 to UINT_MAX (the higher the value,
the higher the likelyhood of 'random() <= value' being true).

This patch deliberately doesn't add the META_PRANDOM key
to the existing meta keys -- this way we do not allow statement
like 'meta probability ne 0.2' since parser will expect a probability
value instead of 'ne'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: If you still dislike TYPE_PROBABILITY it would be possible
 to handle the de-scaling during netlink delinearization.

 This would also allow us to zap the relational expression
 at the same time which in turn avoids the code to suppress
 OP_LTE for the probability case.

 Only problem is that it needs a bit of meta.c details in
 netlink_delinearize (can only do the re-scaling in case of
 RELOP w. OP_LTE && left-type-is-meta && meta-key-is-prandom).

 Thoughts?

 include/datatype.h                  |  2 ++
 include/linux/netfilter/nf_tables.h |  2 ++
 include/meta.h                      |  4 +++
 src/expression.c                    |  2 ++
 src/meta.c                          | 70 +++++++++++++++++++++++++++++++++++++
 src/parser_bison.y                  | 24 +++++++++++--
 src/scanner.l                       |  7 +++-
 7 files changed, 108 insertions(+), 3 deletions(-)

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
diff --git a/include/meta.h b/include/meta.h
index f25b147..61e3da1 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -26,6 +26,10 @@ struct meta_template {
 extern struct expr *meta_expr_alloc(const struct location *loc,
 				    enum nft_meta_keys key);
 
+struct error_record *meta_probability_parse(const struct location *loc,
+				    const char *s, uint32_t *v);
+struct expr *meta_expr_alloc_probability(const struct location *loc, uint32_t p);
+
 struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type);
 
 const struct datatype ifindex_type;
diff --git a/src/expression.c b/src/expression.c
index c96bce4..4e88e5c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -523,6 +523,8 @@ static bool must_print_op(const struct expr *binop)
 			return true;
 
 		return binop->left->ops->type == EXPR_BINOP;
+	case OP_LTE:
+		return binop->left->dtype->type != TYPE_PROBABILITY;
 	default:
 		break;
 	}
diff --git a/src/meta.c b/src/meta.c
index b8db0f8..13c3f6e 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -10,11 +10,13 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <errno.h>
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
+#include <limits.h>
 #include <net/if.h>
 #include <net/if_arp.h>
 #include <pwd.h>
@@ -360,6 +362,57 @@ static const struct datatype devgroup_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
+/* UINT_MAX == 1.0, UINT_MAX/2 == 0.5, etc. */
+#define META_PROB_FMT	"%.7f"
+static void probability_type_print(const struct expr *expr)
+{
+	uint64_t v = mpz_get_uint32(expr->value) + 1;
+
+	printf(META_PROB_FMT, 1.0 * v / 0x80000000 / 2.0);
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
+};
+
+struct error_record *meta_probability_parse(const struct location *loc, const char *str,
+					    uint32_t *value)
+{
+		static const uint64_t precision = 10000000;
+		uint64_t tmp;
+		char *end;
+		double d, scaled;
+
+		errno = 0;
+		d = strtod(str, &end);
+
+		if (errno)
+			return error(loc, "Could not parse probability %s: %s", str, strerror(errno));
+		if (end == str)
+			return error(loc, "Could not parse probability %s", str);
+
+		scaled = d;
+		scaled *= precision;
+		tmp = (uint64_t) scaled;
+		tmp *= UINT_MAX;
+		tmp /= precision;
+
+		if (tmp >= UINT_MAX || d > 0.9999999)
+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");
+
+		*value = (uint32_t) tmp;
+		if (*value == 0)
+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "small");
+
+		return NULL;
+}
+
 static const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -416,6 +469,9 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_CGROUP]	= META_TEMPLATE("cgroup",    &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_PRANDOM]	= META_TEMPLATE("probability",    &probability_type,
+						4 * BITS_PER_BYTE,
+						BYTEORDER_BIG_ENDIAN), /* avoid conversion; doesn't have endianess */
 };
 
 static bool meta_key_is_qualified(enum nft_meta_keys key)
@@ -426,6 +482,7 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	case NFT_META_L4PROTO:
 	case NFT_META_PROTOCOL:
 	case NFT_META_PRIORITY:
+	case NFT_META_PRANDOM:
 		return true;
 	default:
 		return false;
@@ -552,6 +609,18 @@ struct expr *meta_expr_alloc(const struct location *loc, enum nft_meta_keys key)
 	return expr;
 }
 
+struct expr *meta_expr_alloc_probability(const struct location *loc, uint32_t p)
+{
+	struct expr *meta = meta_expr_alloc(loc, NFT_META_PRANDOM);
+	struct expr *pexp;
+
+	pexp = constant_expr_alloc(loc, &probability_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   BITS_PER_BYTE * sizeof(p), &p);
+
+	return relational_expr_alloc(loc, OP_LTE, meta, pexp);
+}
+
 static void meta_stmt_print(const struct stmt *stmt)
 {
 	if (meta_key_is_qualified(stmt->meta.key))
@@ -589,6 +658,7 @@ static void __init meta_init(void)
 	datatype_register(&gid_type);
 	datatype_register(&devgroup_type);
 	datatype_register(&pkttype_type);
+	datatype_register(&probability_type);
 }
 
 /*
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05ade0f..b56a5b1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -329,6 +329,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token IBRIPORT			"ibriport"
 %token OBRIPORT			"obriport"
 %token PKTTYPE			"pkttype"
+%token PROBABILITY		"probability"
 %token CPU			"cpu"
 %token IIFGROUP			"iifgroup"
 %token OIFGROUP			"oifgroup"
@@ -563,8 +564,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	mh_hdr_expr
 %type <val>			mh_hdr_field
 
-%type <expr>			meta_expr
-%destructor { expr_free($$); }	meta_expr
+%type <expr>			meta_expr	meta_probability_expr
+%destructor { expr_free($$); }	meta_expr	meta_probability_expr
 %type <val>			meta_key	meta_key_qualified	meta_key_unqualified
 
 %type <expr>			ct_expr
@@ -1764,6 +1765,10 @@ match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
 			}
+			|	meta_probability_expr
+			{
+				$$ = expr_stmt_alloc(&@$, $1);
+			}
 			;
 
 symbol_expr		:	string
@@ -2226,6 +2231,21 @@ meta_expr		:	META	meta_key
 			}
 			;
 
+meta_probability_expr	:	META	PROBABILITY	STRING
+			{
+				struct error_record *erec;
+				uint32_t value;
+
+				erec = meta_probability_parse(&@$, $3, &value);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = meta_expr_alloc_probability(&@$, value);
+			}
+			;
+
 meta_key		:	meta_key_qualified
 			|	meta_key_unqualified
 			;
diff --git a/src/scanner.l b/src/scanner.l
index a0dee47..2af4616 100644
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
@@ -445,6 +446,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ibriport"		{ return IBRIPORT; }
 "obriport"		{ return OBRIPORT; }
 "pkttype"		{ return PKTTYPE; }
+"probability"		{ return PROBABILITY; }
 "cpu"			{ return CPU; }
 "iifgroup"		{ return IIFGROUP; }
 "oifgroup"		{ return OIFGROUP; }
@@ -486,7 +488,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
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

