From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH nft] parser: re-try unexpected tokens as symbol expression
Date: Tue, 29 Dec 2015 22:41:59 +0100
Message-ID: <1451425319-11715-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57827 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbbL2Vmn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 16:42:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft fails to parse certain corner-cases, for example:

nft add rule filter input meta rtclassid daddr

... as it finds DADDR token.  However, 'daddr' might be a valid
routing realm listed in iproute2/rt_realms, so this should be allowed.

This demo hack abuses error recovery to treat such problematic tokens
on the RHS of relational expressions to symbolic expressions.

The change is incomplete, as the example above still throws a parser
error (would have to add a supression for this case) and doesn't work
for binops or map case.
---
 include/parser.h   |  1 +
 src/parser_bison.y | 37 +++++++++++++++++++++++++++++++++++++
 src/scanner.l      | 11 +++++++++++
 3 files changed, 49 insertions(+)

diff --git a/include/parser.h b/include/parser.h
index 92beab2..ee03a1d 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -18,6 +18,7 @@ struct parser_state {
 	struct input_descriptor		indescs[MAX_INCLUDE_DEPTH];
 	unsigned int			indesc_idx;
 
+	char *lookahead_token;
 	struct list_head		*msgs;
 	unsigned int			nerrs;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index fbfe7ea..f55070b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -94,6 +94,21 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	}
 }
 
+/* attempt to treat next token as a textual symbolic name.
+ * Helper to resolve cases where RHS can contain reserved words like 'saddr',
+ * e.g. 'meta rtclassid reject', 'ct label != saddr', etc.
+ */
+static struct expr *try_as_symbol(const struct location *loc, struct parser_state *state)
+{
+	struct expr *sym = symbol_expr_alloc(loc, SYMBOL_VALUE,
+					     current_scope(state),
+					     state->lookahead_token);
+	xfree(state->lookahead_token);
+	state->lookahead_token = NULL;
+
+	return sym;
+}
+
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
 %}
@@ -1942,6 +1957,17 @@ relational_expr		:	expr	/* implicit */	expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_IMPLICIT, $1, $2);
 			}
+			|	expr	/* implicit */ error
+			{
+				if (yychar == YYEOF)
+                                       YYACCEPT;
+
+				if (yychar == YYEMPTY)
+                                       YYERROR;
+
+				$$ = relational_expr_alloc(&@2, OP_IMPLICIT, $1, try_as_symbol(&@2, state));
+				yyclearin;
+			}
 			|	expr	/* implicit */	list_expr
 			{
 				$$ = relational_expr_alloc(&@$, OP_FLAGCMP, $1, $2);
@@ -1950,6 +1976,17 @@ relational_expr		:	expr	/* implicit */	expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
 			}
+			|	expr	relational_op	error
+			{
+				if (yychar == YYEOF)
+                                       YYACCEPT;
+
+				if (yychar == YYEMPTY)
+                                       YYERROR;
+
+				$$ = relational_expr_alloc(&@2, $2, $1, try_as_symbol(&@2, state));
+				yyclearin;
+			}
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
diff --git a/src/scanner.l b/src/scanner.l
index a98e7b6..3c73907 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -85,6 +85,14 @@ static void update_offset(struct parser_state *state, struct location *loc,
 	loc->line_offset		= state->indesc->line_offset;
 }
 
+static void update_lookahead_token(struct parser_state *state, const char *s,
+				   unsigned int len, int what)
+{
+	state->lookahead_token = xrealloc(state->lookahead_token, len + 1);
+	memcpy(state->lookahead_token, s, len);
+	state->lookahead_token[len] = 0;
+}
+
 static void reset_pos(struct parser_state *state, struct location *loc)
 {
 	state->indesc->line_offset	= state->indesc->token_offset;
@@ -93,6 +101,7 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 }
 
 #define YY_USER_ACTION {					\
+	update_lookahead_token(yyget_extra(yyscanner), yytext, yyleng, yy_act);	\
 	update_pos(yyget_extra(yyscanner), yylloc, yyleng);	\
 	update_offset(yyget_extra(yyscanner), yylloc, yyleng);	\
 }
@@ -664,6 +673,7 @@ void *scanner_init(struct parser_state *state)
 	yyscan_t scanner;
 
 	state->indesc = state->indescs;
+	state->lookahead_token = NULL;
 
 	yylex_init(&scanner);
 	yyset_extra(state, scanner),
@@ -680,5 +690,6 @@ void scanner_destroy(struct parser_state *scanner)
 	while (state->indesc_idx--)
 		yypop_buffer_state(scanner);
 
+	free(state->lookahead_token);
 	yylex_destroy(scanner);
 }
-- 
2.4.10

