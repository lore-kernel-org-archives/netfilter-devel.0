From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] parser_bison: use keywords in ct expression
Date: Tue, 26 Sep 2017 19:09:50 +0200
Message-ID: <1506445791-20482-2-git-send-email-pablo@netfilter.org>
References: <1506445791-20482-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937278AbdIZRKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 13:10:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DBB7220BC
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:09:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B6E5C882F
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:09:59 +0200 (CEST)
In-Reply-To: <1506445791-20482-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using string give us more chances to hit shift/reduce conflicts when
extending this grammar, more specifically, from the stmt_expr rule, so
add keywords for this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 89 +++++++++++++++++++++---------------------------------
 src/scanner.l      |  9 ++++++
 2 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8bcf64e9903d..351b51010f59 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -386,6 +386,15 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
 %token ZONE			"zone"
+%token DIRECTION		"direction"
+%token EVENT			"event"
+%token EXPIRATION		"expiration"
+%token HELPER			"helper"
+%token LABEL			"label"
+%token STATE			"state"
+%token STATUS			"status"
+%token ORIGINAL			"original"
+%token REPLY			"reply"
 
 %token COUNTER			"counter"
 %token NAME			"name"
@@ -658,7 +667,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
-%type <val>			ct_key		ct_key_dir	ct_key_dir_optional
+%type <val>			ct_key		ct_dir	ct_key_dir_optional	ct_key_dir
 
 %type <expr>			fib_expr
 %destructor { expr_free($$); }	fib_expr
@@ -3061,6 +3070,9 @@ keyword_rhs_expr	:	ETHER                   { $$ = symbol_value(&@$, "ether"); }
 			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
 			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
 			|	RESET			{ $$ = symbol_value(&@$, "reset"); }
+			|	ORIGINAL		{ $$ = symbol_value(&@$, "original"); }
+			|	REPLY			{ $$ = symbol_value(&@$, "reply"); }
+			|	LABEL			{ $$ = symbol_value(&@$, "label"); }
 			;
 
 primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
@@ -3306,41 +3318,33 @@ ct_expr			: 	CT	ct_key
 			{
 				$$ = ct_expr_alloc(&@$, $2, -1);
 			}
-			| 	CT	STRING
+			|	CT	ct_dir	ct_key_dir
 			{
-				struct error_record *erec;
-				unsigned int key;
-
-				erec = ct_key_parse(&@$, $2, &key);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = ct_expr_alloc(&@$, key, -1);
+				$$ = ct_expr_alloc(&@$, $3, $2);
 			}
-			|	CT	STRING	ct_key_dir
-			{
-				struct error_record *erec;
-				int8_t direction;
-
-				erec = ct_dir_parse(&@$, $2, &direction);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
+			;
 
-				$$ = ct_expr_alloc(&@$, $3, direction);
-			}
+ct_dir			:	ORIGINAL	{ $$ = IP_CT_DIR_ORIGINAL; }
+			|	REPLY		{ $$ = IP_CT_DIR_REPLY; }
 			;
 
 ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	MARK		{ $$ = NFT_CT_MARK; }
+			|	STATE		{ $$ = NFT_CT_STATE; }
+			|	DIRECTION	{ $$ = NFT_CT_DIRECTION; }
+			|	STATUS		{ $$ = NFT_CT_STATUS; }
+			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
+			|	HELPER		{ $$ = NFT_CT_HELPER; }
+			|	SADDR		{ $$ = NFT_CT_SRC; }
+			|	DADDR		{ $$ = NFT_CT_DST; }
+			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
+			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
+			|	LABEL		{ $$ = NFT_CT_LABELS; }
+			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
 			|	ct_key_dir_optional
 			;
+
 ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	DADDR		{ $$ = NFT_CT_DST; }
 			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
@@ -3356,6 +3360,7 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
 			|	ZONE		{ $$ = NFT_CT_ZONE; }
 			;
 
+
 list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
 			{
 				$$ = list_expr_alloc(&@$);
@@ -3372,44 +3377,20 @@ list_stmt_expr		:	symbol_expr	COMMA	symbol_expr
 
 ct_stmt			:	CT	ct_key		SET	stmt_expr
 			{
-				$$ = ct_stmt_alloc(&@$, $2, -1, $4);
-			}
-			|	CT	STRING		SET	stmt_expr
-			{
-				struct error_record *erec;
-				unsigned int key;
-
-				erec = ct_key_parse(&@$, $2, &key);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				switch (key) {
+				switch ($2) {
 				case NFT_CT_HELPER:
 					$$ = objref_stmt_alloc(&@$);
 					$$->objref.type = NFT_OBJECT_CT_HELPER;
 					$$->objref.expr = $4;
 					break;
 				default:
-					$$ = ct_stmt_alloc(&@$, key, -1, $4);
+					$$ = ct_stmt_alloc(&@$, $2, -1, $4);
 					break;
 				}
 			}
-			|	CT	STRING	ct_key_dir_optional SET	stmt_expr
+			|	CT	ct_dir	ct_key_dir_optional SET	stmt_expr
 			{
-				struct error_record *erec;
-				int8_t direction;
-
-				erec = ct_dir_parse(&@$, $2, &direction);
-				xfree($2);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-
-				$$ = ct_stmt_alloc(&@$, $3, direction, $5);
+				$$ = ct_stmt_alloc(&@$, $3, $2, $5);
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 0cfb6c50e418..186fb47eb763 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -484,6 +484,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
 "zone"			{ return ZONE; }
+"original"		{ return ORIGINAL; }
+"reply"			{ return REPLY; }
+"direction"		{ return DIRECTION; }
+"event"			{ return EVENT; }
+"expiration"		{ return EXPIRATION; }
+"helper"		{ return HELPER; }
+"label"			{ return LABEL; }
+"state"			{ return STATE; }
+"status"		{ return STATUS; }
 
 "numgen"		{ return NUMGEN; }
 "inc"			{ return INC; }
-- 
2.1.4

