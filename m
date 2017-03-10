From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/5] Introduce boolean datatype and boolean expression
Date: Fri, 10 Mar 2017 18:13:49 +0100
Message-ID: <20170310171353.28868-2-phil@nwl.cc>
References: <20170310171353.28868-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:33701 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932678AbdCJROS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:14:18 -0500
In-Reply-To: <20170310171353.28868-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/datatype.h |  2 ++
 src/datatype.c     | 19 +++++++++++++++++++
 src/parser_bison.y | 20 ++++++++++++++++++++
 src/scanner.l      |  3 +++
 4 files changed, 44 insertions(+)

diff --git a/include/datatype.h b/include/datatype.h
index b78d76f78f76c..e614b96e880bf 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -82,6 +82,7 @@ enum datatypes {
 	TYPE_DSCP,
 	TYPE_ECN,
 	TYPE_FIB_ADDR,
+	TYPE_BOOLEAN,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -233,6 +234,7 @@ extern const struct datatype icmp_code_type;
 extern const struct datatype icmpv6_code_type;
 extern const struct datatype icmpx_code_type;
 extern const struct datatype time_type;
+extern const struct datatype boolean_type;
 
 extern const struct datatype *concat_type_alloc(uint32_t type);
 extern void concat_type_destroy(const struct datatype *dtype);
diff --git a/src/datatype.c b/src/datatype.c
index 6b1dd4a09abbc..c61c4245c3868 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -48,6 +48,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_ICMP_CODE]	= &icmp_code_type,
 	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
 	[TYPE_ICMPX_CODE]	= &icmpx_code_type,
+	[TYPE_BOOLEAN]		= &boolean_type,
 };
 
 void datatype_register(const struct datatype *dtype)
@@ -1104,3 +1105,21 @@ struct error_record *rate_parse(const struct location *loc, const char *str,
 
 	return NULL;
 }
+
+static const struct symbol_table boolean_tbl = {
+	.base		= BASE_DECIMAL,
+	.symbols	= {
+		SYMBOL("exists",	true),
+		SYMBOL("missing",	false),
+		SYMBOL_LIST_END
+	},
+};
+
+const struct datatype boolean_type = {
+	.type		= TYPE_BOOLEAN,
+	.name		= "boolean",
+	.desc		= "boolean type",
+	.size		= 1,
+	.basetype	= &integer_type,
+	.sym_tbl	= &boolean_tbl,
+};
diff --git a/src/parser_bison.y b/src/parser_bison.y
index dff8a5ab90ace..f2ae82f471dd6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -448,6 +448,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token NOTRACK			"notrack"
 
+%token EXISTS			"exists"
+%token MISSING			"missing"
+
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
@@ -651,6 +654,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			tcp_hdr_field
 %type <val>			tcp_hdr_option_type tcp_hdr_option_field
 
+%type <expr>			boolean_expr
+%destructor { expr_free($$); }	boolean_expr
+%type <val>			boolean_keys
+
 %%
 
 input			:	/* empty */
@@ -2655,8 +2662,21 @@ concat_rhs_expr		:	basic_rhs_expr
 			}
 			;
 
+boolean_keys		:	EXISTS		{ $$ = true; }
+			|	MISSING		{ $$ = false; }
+			;
+
+boolean_expr		:	boolean_keys
+			{
+				$$ = constant_expr_alloc(&@$, &boolean_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 1, &$1);
+			}
+			;
+
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
+			|	boolean_expr		{ $$ = $1; }
 			|	ETHER
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
diff --git a/src/scanner.l b/src/scanner.l
index 003f15eb1c3c2..b0d571988650a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -504,6 +504,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
+"exists"		{ return EXISTS; }
+"missing"		{ return MISSING; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
-- 
2.11.0

