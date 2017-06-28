From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 04/17] parser: compact list of rhs keyword expressions
Date: Wed, 28 Jun 2017 12:06:46 +0200
Message-ID: <20170628100659.26976-5-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33352 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdF1KGz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:06:55 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Condenses the copy/pastry via a define, will make it less of a hassle
to extend this list later if needed.

Based on earlier patch from Pablo.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 72 ++++++++++++------------------------------------------
 1 file changed, 16 insertions(+), 56 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 86f0464295eb..a95c16adde61 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -97,6 +97,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
+#define symbol_value(loc, str) \
+	symbol_expr_alloc(loc, SYMBOL_VALUE, current_scope(state), str)
 %}
 
 /* Declaration section */
@@ -580,8 +582,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <expr>			flow_key_expr flow_key_expr_alloc
 %destructor { expr_free($$); }	flow_key_expr flow_key_expr_alloc
 
-%type <expr>			expr initializer_expr
-%destructor { expr_free($$); }	expr initializer_expr
+%type <expr>			expr initializer_expr keyword_expr
+%destructor { expr_free($$); }	expr initializer_expr keyword_expr
 
 %type <expr>			rhs_expr concat_rhs_expr basic_rhs_expr
 %destructor { expr_free($$); }	rhs_expr concat_rhs_expr basic_rhs_expr
@@ -2795,39 +2797,21 @@ boolean_expr		:	boolean_keys
 			}
 			;
 
+keyword_expr		:	ETHER                   { $$ = symbol_value(&@$, "ether"); }
+			|	IP			{ $$ = symbol_value(&@$, "ip"); }
+			|	IP6			{ $$ = symbol_value(&@$, "ip6"); }
+			|	VLAN			{ $$ = symbol_value(&@$, "vlan"); }
+			|	ARP			{ $$ = symbol_value(&@$, "arp"); }
+			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
+			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
+			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
+			|	RESET			{ $$ = symbol_value(&@$, "reset"); }
+			;
+
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	boolean_expr		{ $$ = $1; }
-			|	ETHER
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ether");
-			}
-			|	IP
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ip");
-			}
-			|	IP6
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ip6");
-			}
-			|	VLAN
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "vlan");
-			}
-			|	ARP
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "arp");
-			}
+			|	keyword_expr		{ $$ = $1; }
 			|	TCP
 			{
 				uint8_t data = IPPROTO_TCP;
@@ -2905,30 +2889,6 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	SNAT
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "snat");
-			}
-			|	DNAT
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "dnat");
-			}
-			|	ECN
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "ecn");
-			}
-			|	RESET
-			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       "reset");
-			}
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
-- 
2.13.0

