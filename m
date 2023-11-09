Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDDEC4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 19:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjKITBm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjKITBj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 14:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0BE2D57
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 11:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699556444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kjrS8LzENQFBuYblziR+EDQ9QQmwqiwrCyC/qOcfa0Q=;
        b=H3kSHPE1wMIwdRHdTHjeI2jq9IhL0mzuEykd1PQWiy9PF7PHStGy0OmBA2+jalyrd7kLxe
        PTZiM4aIbSmI8seqBC+ZvBErAAPtD26LuE3JcSws49cLS2CgPKbyGBrTk0y/Jv+FT1tfwm
        SB8sDoVLSbR41CdSJttnxEroqWbJuM8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-UhJ8gwiEPNSZDXDgMMPPNg-1; Thu,
 09 Nov 2023 14:00:43 -0500
X-MC-Unique: UhJ8gwiEPNSZDXDgMMPPNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B450529AA395
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 19:00:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E827440C6EB9;
        Thu,  9 Nov 2023 19:00:41 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] parser: don't mark "string" as const
Date:   Thu,  9 Nov 2023 19:59:47 +0100
Message-ID: <20231109190032.669575-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The "string" field is allocated, and the bison actions are expected to
take/free them. It's not const, and it should not be freed with free_const().

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/parser_bison.y | 148 ++++++++++++++++++++++-----------------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1e8169c44f62..ca0851c915d2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -148,19 +148,19 @@ static bool already_set(const void *attr, const struct location *loc,
 
 static struct expr *ifname_expr_alloc(const struct location *location,
 				      struct list_head *queue,
-				      const char *name)
+				      char *name)
 {
 	unsigned int length = strlen(name);
 	struct expr *expr;
 
 	if (length == 0) {
-		free_const(name);
+		free(name);
 		erec_queue(error(location, "empty interface name"), queue);
 		return NULL;
 	}
 
 	if (length >= IFNAMSIZ) {
-		free_const(name);
+		free(name);
 		erec_queue(error(location, "interface name too long"), queue);
 		return NULL;
 	}
@@ -168,7 +168,7 @@ static struct expr *ifname_expr_alloc(const struct location *location,
 	expr = constant_expr_alloc(location, &ifname_type, BYTEORDER_HOST_ENDIAN,
 				   length * BITS_PER_BYTE, name);
 
-	free_const(name);
+	free(name);
 
 	return expr;
 }
@@ -207,7 +207,7 @@ int nft_lex(void *, void *, void *);
 	uint64_t		val;
 	uint32_t		val32;
 	uint8_t			val8;
-	const char *		string;
+	char *			string;
 
 	struct list_head	*list;
 	struct cmd		*cmd;
@@ -358,7 +358,7 @@ int nft_lex(void *, void *, void *);
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING	"quoted string"
 %token <string> ASTERISK_STRING	"string with a trailing asterisk"
-%destructor { free_const($$); }	STRING QUOTED_STRING ASTERISK_STRING
+%destructor { free($$); }	STRING QUOTED_STRING ASTERISK_STRING
 
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
@@ -674,7 +674,7 @@ int nft_lex(void *, void *, void *);
 %type <limit_rate>		limit_rate_bytes
 
 %type <string>			identifier type_identifier string comment_spec
-%destructor { free_const($$); }	identifier type_identifier string comment_spec
+%destructor { free($$); }	identifier type_identifier string comment_spec
 
 %type <val>			time_spec time_spec_or_num_s quota_used
 
@@ -709,7 +709,7 @@ int nft_lex(void *, void *, void *);
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
 %type <string>			extended_prio_name quota_unit	basehook_device_name
-%destructor { free_const($$); }	extended_prio_name quota_unit	basehook_device_name
+%destructor { free($$); }	extended_prio_name quota_unit	basehook_device_name
 
 %type <expr>			dev_spec
 %destructor { free($$); }	dev_spec
@@ -928,7 +928,7 @@ int nft_lex(void *, void *, void *);
 
 %type <val>			markup_format
 %type <string>			monitor_event
-%destructor { free_const($$); }	monitor_event
+%destructor { free($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
 
 %type <val>			synproxy_ts	synproxy_sack
@@ -1053,10 +1053,10 @@ close_scope_xt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_XT); }
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
 				if (scanner_include_file(nft, scanner, $2, &@$) < 0) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
-				free_const($2);
+				free($2);
 			}
 			|	DEFINE		identifier	'='	initializer_expr	stmt_separator
 			{
@@ -1066,19 +1066,19 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 					erec_queue(error(&@2, "redefinition of symbol '%s'", $2),
 						   state->msgs);
 					expr_free($4);
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 
 				symbol_bind(scope, $2, $4);
-				free_const($2);
+				free($2);
 			}
 			|	REDEFINE	identifier	'='	initializer_expr	stmt_separator
 			{
 				struct scope *scope = current_scope(state);
 
 				symbol_bind(scope, $2, $4);
-				free_const($2);
+				free($2);
 			}
 			|	UNDEFINE	identifier	stmt_separator
 			{
@@ -1087,10 +1087,10 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 				if (symbol_unbind(scope, $2) < 0) {
 					erec_queue(error(&@2, "undefined symbol '%s'", $2),
 						   state->msgs);
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
-				free_const($2);
+				free($2);
 			}
 			|	error		stmt_separator
 			{
@@ -1879,21 +1879,21 @@ table_options		:	FLAGS		STRING
 			{
 				if (strcmp($2, "dormant") == 0) {
 					$<table>0->flags |= TABLE_F_DORMANT;
-					free_const($2);
+					free($2);
 				} else if (strcmp($2, "owner") == 0) {
 					$<table>0->flags |= TABLE_F_OWNER;
-					free_const($2);
+					free($2);
 				} else {
 					erec_queue(error(&@2, "unknown table option %s", $2),
 						   state->msgs);
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 			}
 			|	comment_spec
 			{
 				if (already_set($<table>0->comment, &@$, state)) {
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
 				$<table>0->comment = $1;
@@ -2064,7 +2064,7 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			|	chain_block	comment_spec	stmt_separator
 			{
 				if (already_set($1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$1->comment = $2;
@@ -2190,7 +2190,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	comment_spec	stmt_separator
 			{
 				if (already_set($1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$1->comment = $2;
@@ -2307,7 +2307,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	comment_spec	stmt_separator
 			{
 				if (already_set($1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$1->comment = $2;
@@ -2346,10 +2346,10 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 				if ($$->hook.name == NULL) {
 					erec_queue(error(&@3, "unknown chain hook"),
 						   state->msgs);
-					free_const($3);
+					free($3);
 					YYERROR;
 				}
-				free_const($3);
+				free($3);
 
 				$$->priority = $4;
 			}
@@ -2423,12 +2423,12 @@ data_type_atom_expr	:	type_identifier
 				if (dtype == NULL) {
 					erec_queue(error(&@1, "unknown datatype %s", $1),
 						   state->msgs);
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
 				$$ = constant_expr_alloc(&@1, dtype, dtype->byteorder,
 							 dtype->size, NULL);
-				free_const($1);
+				free($1);
 			}
 			|	TIME
 			{
@@ -2465,7 +2465,7 @@ counter_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|	counter_block	  comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2482,7 +2482,7 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|	quota_block	comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2499,7 +2499,7 @@ ct_helper_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       ct_helper_block     comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2520,7 +2520,7 @@ ct_timeout_block	:	/*empty */
 			|       ct_timeout_block     comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2537,7 +2537,7 @@ ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
 			|       ct_expect_block     comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2554,7 +2554,7 @@ limit_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       limit_block     comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2571,7 +2571,7 @@ secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       secmark_block     comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2588,7 +2588,7 @@ synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       synproxy_block     comment_spec
 			{
 				if (already_set($<obj>1->comment, &@2, state)) {
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$<obj>1->comment = $2;
@@ -2609,12 +2609,12 @@ hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
 				if (chain_type == NULL) {
 					erec_queue(error(&@3, "unknown chain type"),
 						   state->msgs);
-					free_const($3);
+					free($3);
 					YYERROR;
 				}
 				$<chain>0->type.loc = @3;
 				$<chain>0->type.str = xstrdup(chain_type);
-				free_const($3);
+				free($3);
 
 				$<chain>0->loc = @$;
 				$<chain>0->hook.loc = @5;
@@ -2622,10 +2622,10 @@ hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
 				if ($<chain>0->hook.name == NULL) {
 					erec_queue(error(&@5, "unknown chain hook"),
 						   state->msgs);
-					free_const($5);
+					free($5);
 					YYERROR;
 				}
-				free_const($5);
+				free($5);
 
 				$<chain>0->dev_expr	= $6;
 				$<chain>0->priority	= $7;
@@ -2672,7 +2672,7 @@ extended_prio_spec	:	int_num
 								BYTEORDER_HOST_ENDIAN,
 								strlen($1) * BITS_PER_BYTE,
 								$1);
-				free_const($1);
+				free($1);
 				$$ = spec;
 			}
 			|	extended_prio_name PLUS NUM
@@ -2685,7 +2685,7 @@ extended_prio_spec	:	int_num
 								BYTEORDER_HOST_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
-				free_const($1);
+				free($1);
 				$$ = spec;
 			}
 			|	extended_prio_name DASH NUM
@@ -2698,7 +2698,7 @@ extended_prio_spec	:	int_num
 								BYTEORDER_HOST_ENDIAN,
 								strlen(str) * BITS_PER_BYTE,
 								str);
-				free_const($1);
+				free($1);
 				$$ = spec;
 			}
 			;
@@ -2783,7 +2783,7 @@ time_spec		:	STRING
 				uint64_t res;
 
 				erec = time_parse(&@1, $1, &res);
-				free_const($1);
+				free($1);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -2984,7 +2984,7 @@ comment_spec		:	COMMENT		string
 					erec_queue(error(&@2, "comment too long, %d characters maximum allowed",
 							 NFTNL_UDATA_COMMENT_MAXLEN),
 						   state->msgs);
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 				$$ = $2;
@@ -3085,8 +3085,8 @@ stmt			:	verdict_stmt
 xt_stmt			:	XT	STRING	string
 			{
 				$$ = NULL;
-				free_const($2);
-				free_const($3);
+				free($2);
+				free($3);
 				erec_queue(error(&@$, "unsupported xtables compat expression, use iptables-nft with this ruleset"),
 					   state->msgs);
 				YYERROR;
@@ -3244,7 +3244,7 @@ log_arg			:	PREFIX			string
 					expr = constant_expr_alloc(&@$, &string_type,
 								   BYTEORDER_HOST_ENDIAN,
 								   (strlen($2) + 1) * BITS_PER_BYTE, $2);
-					free_const($2);
+					free($2);
 					$<stmt>0->log.prefix = expr;
 					$<stmt>0->log.flags |= STMT_LOG_PREFIX;
 					break;
@@ -3318,7 +3318,7 @@ log_arg			:	PREFIX			string
 									   state->msgs);
 							}
 							expr_free(expr);
-							free_const($2);
+							free($2);
 							YYERROR;
 						}
 						item = variable_expr_alloc(&@$, scope, sym);
@@ -3348,7 +3348,7 @@ log_arg			:	PREFIX			string
 					}
 				}
 
-				free_const($2);
+				free($2);
 				$<stmt>0->log.prefix	 = expr;
 				$<stmt>0->log.flags 	|= STMT_LOG_PREFIX;
 			}
@@ -3401,10 +3401,10 @@ level_type		:	string
 				else {
 					erec_queue(error(&@1, "invalid log level"),
 						   state->msgs);
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
-				free_const($1);
+				free($1);
 			}
 			;
 
@@ -3494,7 +3494,7 @@ quota_used		:	/* empty */	{ $$ = 0; }
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $3, &rate);
-				free_const($3);
+				free($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3509,7 +3509,7 @@ quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $4, &rate);
-				free_const($4);
+				free($4);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3553,7 +3553,7 @@ limit_rate_bytes	:	NUM     STRING
 				uint64_t rate, unit;
 
 				erec = rate_parse(&@$, $2, &rate, &unit);
-				free_const($2);
+				free($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3575,7 +3575,7 @@ limit_bytes		:	NUM	BYTES		{ $$ = $1; }
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $2, &rate);
-				free_const($2);
+				free($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -3604,7 +3604,7 @@ reject_with_expr	:	STRING
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
 						       current_scope(state), $1);
-				free_const($1);
+				free($1);
 			}
 			|	integer_expr	{ $$ = $1; }
 			;
@@ -4268,12 +4268,12 @@ variable_expr		:	'$'	identifier
 						erec_queue(error(&@2, "unknown identifier '%s'", $2),
 							   state->msgs);
 					}
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
 
 				$$ = variable_expr_alloc(&@$, scope, sym);
-				free_const($2);
+				free($2);
 			}
 			;
 
@@ -4283,7 +4283,7 @@ symbol_expr		:	variable_expr
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
 						       current_scope(state),
 						       $1);
-				free_const($1);
+				free($1);
 			}
 			;
 
@@ -4296,7 +4296,7 @@ set_ref_symbol_expr	:	AT	identifier	close_scope_at
 				$$ = symbol_expr_alloc(&@$, SYMBOL_SET,
 						       current_scope(state),
 						       $2);
-				free_const($2);
+				free($2);
 			}
 			;
 
@@ -4393,10 +4393,10 @@ osf_ttl			:	/* empty */
 				else {
 					erec_queue(error(&@2, "invalid ttl option"),
 						   state->msgs);
-					free_const($2);
+					free($2);
 					YYERROR;
 				}
-				free_const($2);
+				free($2);
 			}
 			;
 
@@ -4566,7 +4566,7 @@ set_elem_option		:	TIMEOUT			time_spec
 			|	comment_spec
 			{
 				if (already_set($<expr>0->comment, &@1, state)) {
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
 				$<expr>0->comment = $1;
@@ -4648,7 +4648,7 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $4, &rate);
-				free_const($4);
+				free($4);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -4681,7 +4681,7 @@ set_elem_expr_option	:	TIMEOUT			time_spec
 			|	comment_spec
 			{
 				if (already_set($<expr>0->comment, &@1, state)) {
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
 				$<expr>0->comment = $1;
@@ -4733,7 +4733,7 @@ quota_config		:	quota_mode NUM quota_unit quota_used
 				uint64_t rate;
 
 				erec = data_unit_parse(&@$, $3, &rate);
-				free_const($3);
+				free($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -4762,10 +4762,10 @@ secmark_config		:	string
 				ret = snprintf(secmark->ctx, sizeof(secmark->ctx), "%s", $1);
 				if (ret <= 0 || ret >= (int)sizeof(secmark->ctx)) {
 					erec_queue(error(&@1, "invalid context '%s', max length is %u\n", $1, (int)sizeof(secmark->ctx)), state->msgs);
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
-				free_const($1);
+				free($1);
 			}
 			;
 
@@ -4802,7 +4802,7 @@ ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator	cl
 					erec_queue(error(&@2, "invalid name '%s', max length is %u\n", $2, (int)sizeof(ct->name)), state->msgs);
 					YYERROR;
 				}
-				free_const($2);
+				free($2);
 
 				ct->l4proto = $4;
 			}
@@ -5197,7 +5197,7 @@ chain_expr		:	variable_expr
 							 BYTEORDER_HOST_ENDIAN,
 							 strlen($1) * BITS_PER_BYTE,
 							 $1);
-				free_const($1);
+				free($1);
 			}
 			;
 
@@ -5215,7 +5215,7 @@ meta_expr		:	META	meta_key	close_scope_meta
 				unsigned int key;
 
 				erec = meta_key_parse(&@$, $2, &key);
-				free_const($2);
+				free($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -5292,7 +5292,7 @@ meta_stmt		:	META	meta_key	SET	stmt_expr	close_scope_meta
 				unsigned int key;
 
 				erec = meta_key_parse(&@$, $2, &key);
-				free_const($2);
+				free($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
@@ -5603,10 +5603,10 @@ payload_base_spec	:	LL_HDR		{ $$ = PROTO_BASE_LL_HDR; }
 					$$ = PROTO_BASE_INNER_HDR;
 				} else {
 					erec_queue(error(&@1, "unknown raw payload base"), state->msgs);
-					free_const($1);
+					free($1);
 					YYERROR;
 				}
-				free_const($1);
+				free($1);
 			}
 			;
 
-- 
2.41.0

