From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] scanner: disable most rules when we expect literal symbol
Date: Sun,  3 Jan 2016 03:32:27 +0100
Message-ID: <1451788347-11846-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [80.244.247.6] ([80.244.247.6]:34390 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbcACChA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jan 2016 21:37:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft fails to parse certain corner-cases, for example:

nft add rule filter input meta rtclassid daddr

... as it finds DADDR token.  However, 'daddr' might be a valid
routing realm listed in iproute2/rt_realms, so this should be allowed.

Pablo suggested to change the start conditions in the scanner
accordingly.

After this patch, the following rule works:

ct label & (foobar | saddr) == saddr ip saddr 1.2.3.4 rtclassid { 42, cosmos, rule}

[ assuming saddr and rule are also valid label/rt_realms ].

Unfortunately this patch is a lot more ugly than strictly needed --
problem is that we have to end the literal mode from the parser since we
can only leave literal mode once RHS is complete.

Unfortunately, BEGIN cannot be used outside of actions in a reentrant
scanner, so we have to resort to %option stack + push/pop.

Transitions are:

INITIAL -> LITERAL (got 'label' or 'rtclassid' keywords)
LITERAL -> INITIAL (complete RHS)
INITIAL -> INITIAL (complete RHS w.o. previous start condition change)

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 ... on top of Pablos 'parser: restrict relational rhs expression recursion'.

 Let me know if you have any other suggestions or see problems
 with this approach.

 Thanks!

 include/parser.h   |  3 +++
 src/parser_bison.y |  2 +-
 src/scanner.l      | 65 ++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 92beab2..c1f69f0 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -27,6 +27,8 @@ struct parser_state {
 
 	struct list_head		cmds;
 	struct eval_ctx			ectx;
+
+	unsigned int			curr_yy_state;
 };
 
 extern void parser_init(struct parser_state *state, struct list_head *msgs);
@@ -42,5 +44,6 @@ extern int scanner_include_file(void *scanner, const char *filename,
 extern void scanner_push_buffer(void *scanner,
 				const struct input_descriptor *indesc,
 				const char *buffer);
+extern void scanner_rhs_done(void *scanner);
 
 #endif /* NFTABLES_PARSER_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d42bd2f..6bf34cd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1996,7 +1996,7 @@ concat_rhs_expr		:	basic_rhs_expr		{ $$ = $1; }
 			}
 			;
 
-basic_rhs_expr		:	primary_rhs_expr	{ $$ = $1; }
+basic_rhs_expr		:	primary_rhs_expr	{ $$ = $1; scanner_rhs_done(scanner); }
 			;
 
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
diff --git a/src/scanner.l b/src/scanner.l
index a98e7b6..18065c9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -56,6 +56,7 @@
 }
 
 static void scanner_pop_buffer(yyscan_t scanner);
+static void scanner_set_start_cond(yyscan_t scanner, int sc);
 
 
 static void init_pos(struct parser_state *state)
@@ -183,21 +184,23 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option yylineno
 %option nodefault
 %option warn
+%option stack
 
+%s SCANNER_STATE_LITERAL
 %%
 
 "=="			{ return EQ; }
-"eq"			{ return EQ; }
+<INITIAL>"eq"		{ return EQ; }
 "!="			{ return NEQ; }
-"ne"			{ return NEQ; }
+<INITIAL>"ne"		{ return NEQ; }
 "<="			{ return LTE; }
-"le"			{ return LTE; }
+<INITIAL>"le"		{ return LTE; }
 "<"			{ return LT; }
-"lt"			{ return LT; }
+<INITIAL>"lt"		{ return LT; }
 ">="			{ return GTE; }
-"ge"			{ return GTE; }
+<INITIAL>"ge"		{ return GTE; }
 ">"			{ return GT; }
-"gt"			{ return GT; }
+<INITIAL>"gt"		{ return GT; }
 ","			{ return COMMA; }
 "."			{ return DOT; }
 ":"			{ return COLON; }
@@ -209,23 +212,25 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "("			{ return '('; }
 ")"			{ return ')'; }
 "<<"			{ return LSHIFT; }
-"lshift"		{ return LSHIFT; }
+<INITIAL>"lshift"	{ return LSHIFT; }
 ">>"			{ return RSHIFT; }
-"rshift"		{ return RSHIFT; }
+<INITIAL>"rshift"	{ return RSHIFT; }
 "^"			{ return CARET; }
-"xor"			{ return CARET; }
+<INITIAL>"xor"		{ return CARET; }
 "&"			{ return AMPERSAND; }
-"and"			{ return AMPERSAND; }
+<INITIAL>"and"		{ return AMPERSAND; }
 "|"			{ return '|'; }
-"or"			{ return '|'; }
+<INITIAL>"or"		{ return '|'; }
 "!"			{ return NOT; }
-"not"			{ return NOT; }
+<INITIAL>"not"		{ return NOT; }
 "/"			{ return SLASH; }
 "-"			{ return DASH; }
 "*"			{ return ASTERISK; }
 "@"			{ return AT; }
 "$"			{ return '$'; }
 "="			{ return '='; }
+
+<INITIAL>{
 "vmap"			{ return VMAP; }
 
 "include"		{ return INCLUDE; }
@@ -439,7 +444,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "skuid"			{ return SKUID; }
 "skgid"			{ return SKGID; }
 "nftrace"		{ return NFTRACE; }
-"rtclassid"		{ return RTCLASSID; }
+"rtclassid"		{
+				scanner_set_start_cond(yyscanner,
+						       SCANNER_STATE_LITERAL);
+				return RTCLASSID;
+			}
 "ibriport"		{ return IBRIPORT; }
 "obriport"		{ return OBRIPORT; }
 "pkttype"		{ return PKTTYPE; }
@@ -457,7 +466,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
-"label"			{ return LABEL; }
+"label"			{
+				scanner_set_start_cond(yyscanner,
+						       SCANNER_STATE_LITERAL);
+				return LABEL;
+			}
 
 "dup"			{ return DUP; }
 
@@ -505,6 +518,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return ASTERISK_STRING;
 			}
 
+} /* INITIAL state end */
+
 {string}		{
 				yylval->string = xstrdup(yytext);
 				return STRING;
@@ -556,6 +571,16 @@ static void scanner_pop_buffer(yyscan_t scanner)
 	state->indesc = &state->indescs[--state->indesc_idx - 1];
 }
 
+static void scanner_set_start_cond(yyscan_t scanner, int sc)
+{
+	struct parser_state *state = yyget_extra(scanner);
+
+	assert(sc);
+
+	yy_push_state(sc, scanner);
+	state->curr_yy_state = sc;
+}
+
 static struct error_record *scanner_push_file(void *scanner, const char *filename,
 					      FILE *f, const struct location *loc)
 {
@@ -682,3 +707,15 @@ void scanner_destroy(struct parser_state *scanner)
 
 	yylex_destroy(scanner);
 }
+
+void scanner_rhs_done(void *scanner)
+{
+	struct parser_state *state = yyget_extra(scanner);
+
+	if (state->curr_yy_state == INITIAL)
+		return;
+
+	state->curr_yy_state = yy_top_state(scanner);
+	assert(state->curr_yy_state == INITIAL);
+	yy_pop_state(scanner);
+}
-- 
2.4.10

