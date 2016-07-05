From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] meta: add short-hand mnemonic for probalistic matching
Date: Tue,  5 Jul 2016 09:35:34 +0200
Message-ID: <1467704135-9154-3-git-send-email-fw@strlen.de>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55925 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbcGEHfX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 03:35:23 -0400
In-Reply-To: <1467704135-9154-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow users to use a simpler way to specify probalistic matching, e. g.:

meta probability 0.5		(match approx. every 2nd packet)
meta probability 0.001		(match approx. once every 1000 packets)

nft list will still show
meta random <= 2147483647
meta random <= 4294967

a followup patch will hide this internal representation (comparing
random 32 bit value with the scaled constant) -- we will munge the
expression statement and turn it into a special-cased meta one during
netlink delinearization.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/meta.h     |  4 ++++
 src/meta.c         | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y | 19 +++++++++++++++++++
 src/scanner.l      |  5 +++++
 4 files changed, 83 insertions(+)

diff --git a/include/meta.h b/include/meta.h
index f25b147..aafd232 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -26,6 +26,10 @@ struct meta_template {
 extern struct expr *meta_expr_alloc(const struct location *loc,
 				    enum nft_meta_keys key);
 
+struct error_record *meta_probability_parse(const struct location *loc,
+				    const char *s, uint32_t *v);
+struct stmt *meta_stmt_meta_probability(const struct location *loc, uint32_t p);
+
 struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type);
 
 const struct datatype ifindex_type;
diff --git a/src/meta.c b/src/meta.c
index 8b1a2fc..2b0d5f0 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -364,6 +364,47 @@ static const struct datatype devgroup_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
+#define META_PROB_FMT	"%.9f"
+
+/* UINT_MAX == 1.0, UINT_MAX/2 == 0.5, etc. */
+struct error_record *meta_probability_parse(const struct location *loc, const char *str,
+					    uint32_t *value)
+{
+		static const uint64_t precision = 1000000000;
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
+
+		if (tmp > UINT_MAX)
+			goto overflow;
+
+		tmp *= UINT_MAX;
+		tmp /= precision;
+
+		if (tmp >= UINT_MAX)
+			goto overflow;
+
+		*value = (uint32_t) tmp;
+		if (*value == 0)
+			return error(loc, "Probability " META_PROB_FMT " too %s", d, "small");
+
+		return NULL;
+ overflow:
+		return error(loc, "Probability " META_PROB_FMT " too %s", d, "big");
+}
+
 static const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -618,3 +659,17 @@ struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type)
 	dep = relational_expr_alloc(loc, OP_EQ, left, right);
 	return expr_stmt_alloc(&dep->location, dep);
 }
+
+struct stmt *meta_stmt_meta_probability(const struct location *loc, uint32_t p)
+{
+	struct expr *e, *left, *right;
+
+	left = meta_expr_alloc(loc, NFT_META_PRANDOM);
+	right = constant_expr_alloc(loc, &integer_type,
+				    BYTEORDER_HOST_ENDIAN,
+				    sizeof(p) * BITS_PER_BYTE, &p);
+
+	e = relational_expr_alloc(loc, OP_LTE, left, right);
+
+	return expr_stmt_alloc(&e->location, e);
+}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fdbfed9..dceb90f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2367,6 +2367,25 @@ meta_stmt		:	META	meta_key	SET	expr
 			{
 				$$ = meta_stmt_alloc(&@$, $1, $3);
 			}
+			|	META	STRING		STRING
+			{
+				struct error_record *erec;
+				uint32_t value;
+
+				if (strcmp($2, "probability") != 0) {
+					erec_queue(error(&@$, "unknown meta option %s", $2),
+						   state->msgs);
+					YYERROR;
+				}
+
+				erec = meta_probability_parse(&@$, $3, &value);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+
+				$$ = meta_stmt_meta_probability(&@$, value);
+			}
 			;
 
 ct_expr			: 	CT	ct_key
diff --git a/src/scanner.l b/src/scanner.l
index 88669d0..29ffe94 100644
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
@@ -490,6 +491,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return NUM;
 			}
 
+{probability}		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
 {hexstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
-- 
2.7.3

