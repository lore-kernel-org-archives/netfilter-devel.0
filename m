From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/3] exthdr: Implement exthdr existence check
Date: Tue, 17 Jan 2017 23:10:07 +0100
Message-ID: <20170117221007.14951-4-phil@nwl.cc>
References: <20170117221007.14951-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44215 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751129AbdAQWHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 17:07:30 -0500
In-Reply-To: <20170117221007.14951-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is meant to be used as LHS of a boolean relational expression, like
the following example matching on fragment header presence:

| exthdr frag exists

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/exthdr.h   |  4 ++++
 src/expression.c   |  1 +
 src/exthdr.c       |  6 +++++-
 src/parser_bison.y | 24 ++++++++++++++++++++++++
 src/scanner.l      |  2 ++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/exthdr.h b/include/exthdr.h
index d17841bc46159..f45cdf9b1886a 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -85,4 +85,8 @@ extern const struct exthdr_desc exthdr_frag;
 extern const struct exthdr_desc exthdr_dst;
 extern const struct exthdr_desc exthdr_mh;
 
+enum nft_exthdr_flags {
+	NFT_EXTHDR_F_PRESENT = (1 << 0),
+};
+
 #endif /* NFTABLES_EXTHDR_H */
diff --git a/src/expression.c b/src/expression.c
index 8842a7836fc07..9034420ae0db4 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1002,6 +1002,7 @@ static void boolean_expr_print(const struct expr *expr)
 	switch (expr->dtype->type) {
 	case TYPE_FIB_ADDR:		/* fib expr */
 	case TYPE_IFINDEX:		/* fib expr */
+	case TYPE_INET_PROTOCOL:	/* exthdr exists expr */
 		printf(expr->boolean ? "exists" : "missing");
 		break;
 	default:
diff --git a/src/exthdr.c b/src/exthdr.c
index 32bf3558115c5..37d7700f328c8 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -24,7 +24,11 @@
 
 static void exthdr_expr_print(const struct expr *expr)
 {
-	printf("%s %s", expr->exthdr.desc->name, expr->exthdr.tmpl->token);
+	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
+		printf("exthdr %s", expr->exthdr.desc->name);
+	else
+		printf("%s %s", expr->exthdr.desc->name,
+				expr->exthdr.tmpl->token);
 }
 
 static bool exthdr_expr_cmp(const struct expr *e1, const struct expr *e2)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3205cc407ffa8..e819affadbf05 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -139,6 +139,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	const struct datatype	*datatype;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
+	const struct exthdr_desc *exthdr_desc;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -431,6 +432,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token TRUE			"true"
 %token FALSE			"false"
 
+%token EXTHDR			"exthdr"
+
 %type <val>			boolean_spec
 %type <expr>			boolean_expr
 %destructor { expr_free($$); }	boolean_expr
@@ -633,6 +636,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <quota>			quota_config
 %destructor { xfree($$); }	quota_config
 
+%type <expr>			exthdr_exists_expr
+%destructor { expr_free($$); }	exthdr_exists_expr
+%type <exthdr_desc>		exthdr_spec
+
 %%
 
 input			:	/* empty */
@@ -2260,6 +2267,7 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	integer_expr			{ $$ = $1; }
 			|	payload_expr			{ $$ = $1; }
 			|	exthdr_expr			{ $$ = $1; }
+			|	exthdr_exists_expr		{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
 			|	rt_expr				{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
@@ -3316,4 +3324,20 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
+exthdr_exists_expr	:	EXTHDR	exthdr_spec
+			{
+				/* Assume that NEXTHDR template is always
+				 * the fist one in list of templates.
+				 */
+				$$ = exthdr_expr_alloc(&@$, $2, 1);
+				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+			}
+			;
+
+exthdr_spec		:	HBH	{ $$ = &exthdr_hbh; }
+			|	RT	{ $$ = &exthdr_rt; }
+			|	FRAG	{ $$ = &exthdr_frag; }
+			|	DST	{ $$ = &exthdr_dst; }
+			|	MH	{ $$ = &exthdr_mh; }
+			;
 %%
diff --git a/src/scanner.l b/src/scanner.l
index debc18fad37ef..bd6edaac1224b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -487,6 +487,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "true"			{ return TRUE; }
 "false"			{ return FALSE; }
 
+"exthdr"		{ return EXTHDR; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
-- 
2.11.0

