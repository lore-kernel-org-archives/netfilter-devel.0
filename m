Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A23C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A9C364F98
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhCPXlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhCPXlP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:41:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC21C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:41:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJJI-00058X-7E; Wed, 17 Mar 2021 00:41:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/6] src: allow arbitary chain name in implicit rule add case
Date:   Wed, 17 Mar 2021 00:40:39 +0100
Message-Id: <20210316234039.15677-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316234039.15677-1-fw@strlen.de>
References: <20210316234039.15677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow switch of the flex state from bison parser.
Note that this switch will happen too late to cover all cases:

nft add ip dup fwd ip saddr ...  # adds a rule to chain fwd in table dup
nft add dup fwd ... # syntax error  (flex parses dup as expression keyword)

to solve this, bison must carry a list of keywords that are allowed to
be used as table names.

This adds FWD as an example.  When new keywords are added, this can
then be extended as needed.

Another alternative is to deprecate implicit rule add altogether
so users would have to move to 'nft add rule ...'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 57 ++++++++++++++++++++++++++++++++++++++--------
 src/scanner.l      |  4 +---
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index d6cf20729421..35117acc977f 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -77,5 +77,6 @@ extern void scanner_push_buffer(void *scanner,
 				const char *buffer);
 
 extern void scanner_pop_start_cond(void *scanner, enum startcond_type sc);
+extern void scanner_push_start_cond(void *scanner, enum startcond_type sc);
 
 #endif /* NFTABLES_PARSER_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index bbac85fd35ce..a910d813e637 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -568,8 +568,8 @@ int nft_lex(void *, void *, void *);
 %token IN			"in"
 %token OUT			"out"
 
-%type <string>			identifier type_identifier string comment_spec
-%destructor { xfree($$); }	identifier type_identifier string comment_spec
+%type <string>			identifier type_identifier string comment_spec	implicit_table_name
+%destructor { xfree($$); }	identifier type_identifier string comment_spec	implicit_table_name
 
 %type <val>			time_spec quota_used
 
@@ -582,13 +582,13 @@ int nft_lex(void *, void *, void *);
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 
-%type <handle>			table_spec tableid_spec table_or_id_spec
-%destructor { handle_free(&$$); } table_spec tableid_spec table_or_id_spec
-%type <handle>			chain_spec chainid_spec chain_or_id_spec
-%destructor { handle_free(&$$); } chain_spec chainid_spec chain_or_id_spec
+%type <handle>			table_spec tableid_spec table_or_id_spec implicit_table_spec
+%destructor { handle_free(&$$); } table_spec tableid_spec table_or_id_spec implicit_table_spec
+%type <handle>			chain_spec chainid_spec chain_or_id_spec implicit_chain_spec
+%destructor { handle_free(&$$); } chain_spec chainid_spec chain_or_id_spec implicit_chain_spec
 
-%type <handle>			flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
-%destructor { handle_free(&$$); } flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
+%type <handle>			flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec	implicit_rule_position
+%destructor { handle_free(&$$); } flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec	implicit_rule_position
 %type <handle>			set_spec setid_spec set_or_id_spec
 %destructor { handle_free(&$$); } set_spec setid_spec set_or_id_spec
 %type <handle>			obj_spec objid_spec obj_or_id_spec
@@ -882,6 +882,7 @@ close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKE
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 
+open_scope_chain	: { scanner_push_start_cond(nft->scanner, PARSER_SC_STRING_CHAIN); };
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
 				if (scanner_include_file(nft, scanner, $2, &@$) < 0) {
@@ -998,7 +999,7 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$2, &@$, $3);
 			}
-			|	/* empty */	rule_position	rule
+			|	/* empty */	implicit_rule_position	rule
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$1, &@$, $2);
 			}
@@ -2607,6 +2608,44 @@ rule_position		:	chain_spec
 			}
 			;
 
+implicit_table_name	:	FWD { $$ = xstrdup("fwd"); }
+			|	DUP { $$ = xstrdup("dup"); }
+			;
+
+implicit_table_spec	:	family_spec implicit_table_name
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.family = $1;
+				$$.table.location = @2;
+				$$.table.name	= $2;
+			}
+			;
+
+implicit_chain_spec	:	open_scope_chain implicit_table_spec	identifier	close_scope_chain
+			{
+				$$		= $2;
+				$$.chain.name	= $3;
+				$$.chain.location = @3;
+			}
+			;
+
+implicit_rule_position	:	open_scope_chain rule_position { $$ = $2; }
+			|	implicit_chain_spec { $$ = $1; }
+			|	implicit_chain_spec position_spec { handle_merge(&$1, &$2); $$ = $1; }
+			|	implicit_chain_spec handle_spec {
+				$2.position.location = $2.handle.location;
+				$2.position.id = $2.handle.id;
+				$2.handle.id = 0;
+				handle_merge(&$1, &$2);
+				$$ = $1;
+			}
+			|	implicit_chain_spec index_spec
+			{
+				handle_merge(&$1, &$2);
+				$$ = $1;
+			}
+			;
+
 ruleid_spec		:	chain_spec	handle_spec
 			{
 				handle_merge(&$1, &$2);
diff --git a/src/scanner.l b/src/scanner.l
index a156accaa944..a4747b39b314 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -101,8 +101,6 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 static int scanner_handle_tablename(void *scanner, const char *token);
 static int scanner_handle_chainname(void *scanner, const char *token);
 
-static void scanner_push_start_cond(void *scanner, enum startcond_type type);
-
 #define YY_USER_ACTION {					\
 	update_pos(yyget_extra(yyscanner), yylloc, yyleng);	\
 	update_offset(yyget_extra(yyscanner), yylloc, yyleng);	\
@@ -1087,7 +1085,7 @@ void scanner_destroy(struct nft_ctx *nft)
 	yylex_destroy(nft->scanner);
 }
 
-static void scanner_push_start_cond(void *scanner, enum startcond_type type)
+void scanner_push_start_cond(void *scanner, enum startcond_type type)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
-- 
2.26.2

