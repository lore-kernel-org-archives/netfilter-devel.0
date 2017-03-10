From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/5] exthdr: Implement existence check
Date: Fri, 10 Mar 2017 18:13:51 +0100
Message-ID: <20170310171353.28868-4-phil@nwl.cc>
References: <20170310171353.28868-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48793 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932595AbdCJROj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:14:39 -0500
In-Reply-To: <20170310171353.28868-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to check for existence of an IPv6 extension or TCP
option header by using the following syntax:

| exthdr frag exists
| tcpopt window exists

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/exthdr.h                    |  2 ++
 src/evaluate.c                      |  3 ++
 src/exthdr.c                        | 28 ++++++++++++++---
 src/parser_bison.y                  | 34 +++++++++++++++++++++
 src/scanner.l                       |  2 ++
 src/tcpopt.c                        |  6 +++-
 tests/py/inet/tcpopt.t              |  3 ++
 tests/py/inet/tcpopt.t.payload.inet | 14 +++++++++
 tests/py/ip6/exthdr.t               | 19 ++++++++++++
 tests/py/ip6/exthdr.t.payload.ip6   | 60 +++++++++++++++++++++++++++++++++++++
 10 files changed, 166 insertions(+), 5 deletions(-)
 create mode 100644 tests/py/ip6/exthdr.t
 create mode 100644 tests/py/ip6/exthdr.t.payload.ip6

diff --git a/include/exthdr.h b/include/exthdr.h
index c7f806ebb2fa2..a2647ee142dcd 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -21,6 +21,8 @@ extern struct expr *exthdr_expr_alloc(const struct location *loc,
 				      const struct exthdr_desc *desc,
 				      uint8_t type);
 
+extern const struct exthdr_desc *exthdr_find_proto(uint8_t proto);
+
 extern void exthdr_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len,
 			    enum nft_exthdr_op op, uint32_t flags);
diff --git a/src/evaluate.c b/src/evaluate.c
index efcafc7249bfc..7c039cbab5ec3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -432,6 +432,9 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
 
+	if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
+		expr->dtype = &boolean_type;
+
 	if (expr_evaluate_primary(ctx, exprp) < 0)
 		return -1;
 
diff --git a/src/exthdr.c b/src/exthdr.c
index 21fe734f8fc15..375e18fce46da 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -32,14 +32,22 @@ static void exthdr_expr_print(const struct expr *expr)
 		unsigned int offset = expr->exthdr.offset / 64;
 		char buf[3] = {0};
 
+		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT) {
+			printf("tcp option %s", expr->exthdr.desc->name);
+			return;
+		}
+
 		if (offset)
 			snprintf(buf, sizeof buf, "%d", offset);
 		printf("tcp option %s%s %s", expr->exthdr.desc->name, buf,
 					     expr->exthdr.tmpl->token);
+	} else {
+		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
+			printf("exthdr %s", expr->exthdr.desc->name);
+		else
+			printf("%s %s", expr->exthdr.desc->name,
+					expr->exthdr.tmpl->token);
 	}
-	else
-		printf("%s %s", expr->exthdr.desc->name,
-				expr->exthdr.tmpl->token);
 }
 
 static bool exthdr_expr_cmp(const struct expr *e1, const struct expr *e2)
@@ -97,6 +105,13 @@ static const struct exthdr_desc *exthdr_protocols[IPPROTO_MAX] = {
 	[IPPROTO_MH]		= &exthdr_mh,
 };
 
+const struct exthdr_desc *exthdr_find_proto(uint8_t proto)
+{
+	assert(exthdr_protocols[proto]);
+
+	return exthdr_protocols[proto];
+}
+
 void exthdr_init_raw(struct expr *expr, uint8_t type,
 		     unsigned int offset, unsigned int len,
 		     enum nft_exthdr_op op, uint32_t flags)
@@ -119,7 +134,12 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 		if (tmpl->offset != offset ||
 		    tmpl->len    != len)
 			continue;
-		expr->dtype	  = tmpl->dtype;
+
+		if (flags & NFT_EXTHDR_F_PRESENT)
+			expr->dtype = &boolean_type;
+		else
+			expr->dtype = tmpl->dtype;
+
 		expr->exthdr.tmpl = tmpl;
 		return;
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f2ae82f471dd6..12a6e64645fa0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -139,6 +139,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	const struct datatype	*datatype;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
+	const struct exthdr_desc *exthdr_desc;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -451,6 +452,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token EXISTS			"exists"
 %token MISSING			"missing"
 
+%token EXTHDR			"exthdr"
+
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
@@ -658,6 +661,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	boolean_expr
 %type <val>			boolean_keys
 
+%type <expr>			exthdr_exists_expr
+%destructor { expr_free($$); }	exthdr_exists_expr
+%type <val>			exthdr_key
+
 %%
 
 input			:	/* empty */
@@ -2291,6 +2298,7 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	integer_expr			{ $$ = $1; }
 			|	payload_expr			{ $$ = $1; }
 			|	exthdr_expr			{ $$ = $1; }
+			|	exthdr_exists_expr		{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
 			|	rt_expr				{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
@@ -3254,6 +3262,11 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			{
 				$$ = tcpopt_expr_alloc(&@$, $3, $4);
 			}
+			|	TCP	OPTION	tcp_hdr_option_type
+			{
+				$$ = tcpopt_expr_alloc(&@$, $3, TCPOPTHDR_FIELD_KIND);
+				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+			}
 			;
 
 tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
@@ -3404,4 +3417,25 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
+exthdr_exists_expr	:	EXTHDR	exthdr_key
+			{
+				const struct exthdr_desc *desc;
+
+				desc = exthdr_find_proto($2);
+
+				/* Assume that NEXTHDR template is always
+				 * the fist one in list of templates.
+				 */
+				$$ = exthdr_expr_alloc(&@$, desc, 1);
+				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
+			}
+			;
+
+exthdr_key		:	HBH	{ $$ = IPPROTO_HOPOPTS; }
+			|	RT	{ $$ = IPPROTO_ROUTING; }
+			|	FRAG	{ $$ = IPPROTO_FRAGMENT; }
+			|	DST	{ $$ = IPPROTO_DSTOPTS; }
+			|	MH	{ $$ = IPPROTO_MH; }
+			;
+
 %%
diff --git a/src/scanner.l b/src/scanner.l
index b0d571988650a..c2c008d6d611c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -507,6 +507,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "exists"		{ return EXISTS; }
 "missing"		{ return MISSING; }
 
+"exthdr"		{ return EXTHDR; }
+
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
diff --git a/src/tcpopt.c b/src/tcpopt.c
index d34dfd459f415..dac4fdb90915a 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -205,6 +205,7 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
 
 	assert(type < array_size(tcpopt_protocols));
 	expr->exthdr.desc = tcpopt_protocols[type];
+	expr->exthdr.flags = flags;
 	assert(expr->exthdr.desc != TCPOPT_OBSOLETE);
 
 	for (i = 0; i < array_size(expr->exthdr.desc->templates); ++i) {
@@ -216,7 +217,10 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int offset,
 		if (tmpl->offset != off || tmpl->len != len)
 			continue;
 
-		expr->dtype       = tmpl->dtype;
+		if (flags & NFT_EXTHDR_F_PRESENT)
+			expr->dtype = &boolean_type;
+		else
+			expr->dtype = tmpl->dtype;
 		expr->exthdr.tmpl = tmpl;
 		expr->exthdr.op   = NFT_EXTHDR_OP_TCPOPT;
 		break;
diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
index 59452b48fce54..a42ecd250a9c1 100644
--- a/tests/py/inet/tcpopt.t
+++ b/tests/py/inet/tcpopt.t
@@ -35,3 +35,6 @@ tcp option eol left 1;fail
 tcp option eol left 1;fail
 tcp option sack window;fail
 tcp option sack window 1;fail
+
+tcp option window exists;ok
+tcp option window missing;ok
diff --git a/tests/py/inet/tcpopt.t.payload.inet b/tests/py/inet/tcpopt.t.payload.inet
index 12deab8c920ff..0d14e77929cca 100644
--- a/tests/py/inet/tcpopt.t.payload.inet
+++ b/tests/py/inet/tcpopt.t.payload.inet
@@ -179,3 +179,17 @@ inet test-inet input
   [ cmp eq reg 1 0x00000006 ]
   [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
+
+# tcp option window exists
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window missing
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
diff --git a/tests/py/ip6/exthdr.t b/tests/py/ip6/exthdr.t
new file mode 100644
index 0000000000000..a6c2d2be179ca
--- /dev/null
+++ b/tests/py/ip6/exthdr.t
@@ -0,0 +1,19 @@
+:input;type filter hook input priority 0
+
+*ip6;test-ip6;input
+
+exthdr hbh exists;ok
+exthdr rt exists;ok
+exthdr frag exists;ok
+exthdr dst exists;ok
+exthdr mh exists;ok
+
+exthdr hbh missing;ok
+
+exthdr hbh == exists;ok;exthdr hbh exists
+exthdr hbh == missing;ok;exthdr hbh missing
+exthdr hbh != exists;ok
+exthdr hbh != missing;ok
+
+exthdr hbh 1;ok;exthdr hbh exists
+exthdr hbh 0;ok;exthdr hbh missing
diff --git a/tests/py/ip6/exthdr.t.payload.ip6 b/tests/py/ip6/exthdr.t.payload.ip6
new file mode 100644
index 0000000000000..b45eb8e74272f
--- /dev/null
+++ b/tests/py/ip6/exthdr.t.payload.ip6
@@ -0,0 +1,60 @@
+# exthdr hbh exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr rt exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 43 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr frag exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr dst exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 60 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr mh exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 135 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr hbh missing
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# exthdr hbh == exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr hbh == missing
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# exthdr hbh != exists
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# exthdr hbh != missing
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# exthdr hbh 1
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# exthdr hbh 0
+ip6 test-ip6 input
+  [ exthdr load 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
-- 
2.11.0

