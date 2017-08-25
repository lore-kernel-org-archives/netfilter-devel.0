From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] parser: Fix memleaks for STRING token (and derived ones)
Date: Fri, 25 Aug 2017 13:17:32 +0200
Message-ID: <20170825111732.431-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51547 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755842AbdHYLRo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2017 07:17:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The common paradigm here is that all parser rules converting string
tokens into symbols must free the string token if it's not used anymore.
This is unrelated to the %destructor directive, since that will apply
only if the parser discards the token, which is not the case then.

While being at it, simplify error handling in parser rule for listing
conntrack helpers (error() won't return NULL) and drop the unused extra
parameter passed to error() in level_type rule.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 46 ++++++++++++++++++++++++++++++++++++----------
 src/rule.c         |  1 +
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d149178c2679b..d4b29029186b2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -724,6 +724,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 				if (symbol_lookup(scope, $2) != NULL) {
 					erec_queue(error(&@2, "redefinition of symbol '%s'", $2),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
 
@@ -860,6 +861,7 @@ add_cmd			:	TABLE		table_spec
 				int type;
 
 				erec = ct_objtype_parse(&@$, $2, &type);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -939,6 +941,7 @@ create_cmd		:	TABLE		table_spec
 				int type;
 
 				erec = ct_objtype_parse(&@$, $2, &type);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -992,6 +995,7 @@ delete_cmd		:	TABLE		table_spec
 				int type;
 
 				erec = ct_objtype_parse(&@$, $2, &type);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -1079,6 +1083,7 @@ list_cmd		:	TABLE		table_spec
 				int type;
 
 				erec = ct_objtype_parse(&@$, $2, &type);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -1093,16 +1098,12 @@ list_cmd		:	TABLE		table_spec
 				if (strcmp($2, "helpers") == 0) {
 					cmd = CMD_OBJ_CT_HELPERS;
 				} else {
-					struct error_record *erec;
-
-					erec = error(&@$, "unknown ct class '%s', want 'helpers'", $2);
-
-					if (erec != NULL) {
-						erec_queue(erec, state->msgs);
-						YYERROR;
-					} else
-						YYERROR;
+					erec_queue(error(&@$, "unknown ct class '%s', want 'helpers'", $2),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
 				}
+				xfree($2);
 
 				$$ = cmd_alloc(CMD_LIST, cmd, &$4, &@$, NULL);
 			}
@@ -1231,9 +1232,11 @@ table_options		:	FLAGS		STRING
 			{
 				if (strcmp($2, "dormant") == 0) {
 					$<table>0->flags = TABLE_F_DORMANT;
+					xfree($2);
 				} else {
 					erec_queue(error(&@2, "unknown table option %s", $2),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
 			}
@@ -1302,6 +1305,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				int type;
 
 				erec = ct_objtype_parse(&@$, $3, &type);
+				xfree($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -1478,8 +1482,10 @@ type_identifier_list	:	type_identifier
 				if (dtype == NULL) {
 					erec_queue(error(&@3, "unknown datatype %s", $3),
 						   state->msgs);
+					xfree($3);
 					YYERROR;
 				}
+				xfree($3);
 				$$ = concat_subtype_add($$, dtype->type);
 			}
 			;
@@ -1533,6 +1539,7 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
 				if (chain_type == NULL) {
 					erec_queue(error(&@2, "unknown chain type %s", $2),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
 				$<chain>0->type		= xstrdup(chain_type);
@@ -1542,6 +1549,7 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
 				if ($<chain>0->hookstr == NULL) {
 					erec_queue(error(&@4, "unknown chain hook %s", $4),
 						   state->msgs);
+					xfree($4);
 					YYERROR;
 				}
 				xfree($4);
@@ -1589,6 +1597,7 @@ time_spec		:	STRING
 				uint64_t res;
 
 				erec = time_parse(&@1, $1, &res);
+				xfree($1);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -1919,10 +1928,12 @@ level_type		:	string
 				else if (!strcmp("debug", $1))
 					$$ = LOG_DEBUG;
 				else {
-					erec_queue(error(&@1, "invalid log level", $1),
+					erec_queue(error(&@1, "invalid log level"),
 						   state->msgs);
+					xfree($1);
 					YYERROR;
 				}
+				xfree($1);
 			}
 			;
 
@@ -1980,6 +1991,7 @@ limit_stmt		:	LIMIT	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst
 				uint64_t rate, unit;
 
 				erec = rate_parse(&@$, $5, &rate, &unit);
+				xfree($5);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -2010,6 +2022,7 @@ quota_used		:	/* empty */	{ $$ = 0; }
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $3, &rate);
+				xfree($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -2024,6 +2037,7 @@ quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $4, &rate);
+				xfree($4);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -2055,6 +2069,7 @@ limit_burst		:	/* empty */			{ $$ = 0; }
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $3, &rate);
+				xfree($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -2093,6 +2108,7 @@ reject_opts		:       /* empty */
 							  current_scope(state),
 							  $4);
 				$<stmt>0->reject.expr->dtype = &icmp_code_type;
+				xfree($4);
 			}
 			|	WITH	ICMP6	TYPE	STRING
 			{
@@ -2103,6 +2119,7 @@ reject_opts		:       /* empty */
 							  current_scope(state),
 							  $4);
 				$<stmt>0->reject.expr->dtype = &icmpv6_code_type;
+				xfree($4);
 			}
 			|	WITH	ICMPX	TYPE	STRING
 			{
@@ -2112,6 +2129,7 @@ reject_opts		:       /* empty */
 							  current_scope(state),
 							  $4);
 				$<stmt>0->reject.expr->dtype = &icmpx_code_type;
+				xfree($4);
 			}
 			|	WITH	TCP	RESET
 			{
@@ -2392,6 +2410,7 @@ variable_expr		:	'$'	identifier
 				if (symbol_lookup(scope, $2) == NULL) {
 					erec_queue(error(&@2, "unknown identifier '%s'", $2),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
 
@@ -2692,6 +2711,7 @@ quota_config		:	quota_mode NUM quota_unit quota_used
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $3, &rate);
+				xfree($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -2994,6 +3014,7 @@ meta_expr		:	META	meta_key
 				unsigned int key;
 
 				erec = meta_key_parse(&@$, $2, &key);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3046,6 +3067,7 @@ meta_stmt		:	META	meta_key	SET	expr
 				unsigned int key;
 
 				erec = meta_key_parse(&@$, $2, &key);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3110,6 +3132,7 @@ ct_expr			: 	CT	ct_key
 				unsigned int key;
 
 				erec = ct_key_parse(&@$, $2, &key);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3123,6 +3146,7 @@ ct_expr			: 	CT	ct_key
 				int8_t direction;
 
 				erec = ct_dir_parse(&@$, $2, &direction);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3180,6 +3204,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 				unsigned int key;
 
 				erec = ct_key_parse(&@$, $2, &key);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3202,6 +3227,7 @@ ct_stmt			:	CT	ct_key		SET	expr
 				int8_t direction;
 
 				erec = ct_dir_parse(&@$, $2, &direction);
+				xfree($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
diff --git a/src/rule.c b/src/rule.c
index 140855f517571..44d36c16ea47f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -926,6 +926,7 @@ struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event)
 
 void monitor_free(struct monitor *m)
 {
+	xfree(m->event);
 	xfree(m);
 }
 
-- 
2.13.1

