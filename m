Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED27EC1550F
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B356524F
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCHRTH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhCHRSy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:18:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D52C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:18:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJWu-0000Lb-Gy; Mon, 08 Mar 2021 18:18:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/6] scanner: introduce start condition stack
Date:   Mon,  8 Mar 2021 18:18:33 +0100
Message-Id: <20210308171837.8542-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210308171837.8542-1-fw@strlen.de>
References: <20210308171837.8542-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a small initial chunk of flex start conditionals.

This starts with two low-hanging fruits, numgen and j/symhash.

NUMGEN and HASH start conditions are entered from flex when
the corresponding expression token is encountered.

Flex returns to the INIT condition when the bison parser
has seen a complete numgen/hash statement.

This intentionally uses a stack rather than BEGIN()
to eventually support nested states.

The scanner_pop_start_cond() function argument is not used yet, but
will need to be used later to deal with nesting.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  8 ++++++++
 src/parser_bison.y | 11 +++++++----
 src/scanner.l      | 36 +++++++++++++++++++++++++++++-------
 3 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 9baa3a4db789..b2ebd7aa226c 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -26,6 +26,12 @@ struct parser_state {
 	struct list_head		*cmds;
 };
 
+enum startcond_type {
+	PARSER_SC_BEGIN,
+	PARSER_SC_EXPR_HASH,
+	PARSER_SC_EXPR_NUMGEN,
+};
+
 struct mnl_socket;
 
 extern void parser_init(struct nft_ctx *nft, struct parser_state *state,
@@ -45,4 +51,6 @@ extern void scanner_push_buffer(void *scanner,
 				const struct input_descriptor *indesc,
 				const char *buffer);
 
+extern void scanner_pop_start_cond(void *scanner, enum startcond_type sc);
+
 #endif /* NFTABLES_PARSER_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index abfcccc4a021..1ac4dbe43c84 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -861,6 +861,9 @@ opt_newline		:	NEWLINE
 		 	|	/* empty */
 			;
 
+close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
+close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
+
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
 				if (scanner_include_file(nft, scanner, $2, &@$) < 0) {
@@ -4811,7 +4814,7 @@ numgen_type		:	INC		{ $$ = NFT_NG_INCREMENTAL; }
 			|	RANDOM		{ $$ = NFT_NG_RANDOM; }
 			;
 
-numgen_expr		:	NUMGEN	numgen_type	MOD	NUM	offset_opt
+numgen_expr		:	NUMGEN	numgen_type	MOD	NUM	offset_opt	close_scope_numgen
 			{
 				$$ = numgen_expr_alloc(&@$, $2, $4, $5);
 			}
@@ -4868,17 +4871,17 @@ xfrm_expr		:	IPSEC	xfrm_dir	xfrm_spnum	xfrm_state_key
 			}
 			;
 
-hash_expr		:	JHASH		expr	MOD	NUM	SEED	NUM	offset_opt
+hash_expr		:	JHASH		expr	MOD	NUM	SEED	NUM	offset_opt	close_scope_hash
 			{
 				$$ = hash_expr_alloc(&@$, $4, true, $6, $7, NFT_HASH_JENKINS);
 				$$->hash.expr = $2;
 			}
-			|	JHASH		expr	MOD	NUM	offset_opt
+			|	JHASH		expr	MOD	NUM	offset_opt	close_scope_hash
 			{
 				$$ = hash_expr_alloc(&@$, $4, false, 0, $5, NFT_HASH_JENKINS);
 				$$->hash.expr = $2;
 			}
-			|	SYMHASH		MOD	NUM	offset_opt
+			|	SYMHASH		MOD	NUM	offset_opt	close_scope_hash
 			{
 				$$ = hash_expr_alloc(&@$, $3, false, 0, $4, NFT_HASH_SYM);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 1da3b5e0628c..94225c296a3b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -98,6 +98,8 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 	state->indesc->column		= 1;
 }
 
+static void scanner_push_start_cond(void *scanner, enum startcond_type type);
+
 #define YY_USER_ACTION {					\
 	update_pos(yyget_extra(yyscanner), yylloc, yyleng);	\
 	update_offset(yyget_extra(yyscanner), yylloc, yyleng);	\
@@ -193,6 +195,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option yylineno
 %option nodefault
 %option warn
+%option stack
+%s SCANSTATE_EXPR_HASH
+%s SCANSTATE_EXPR_NUMGEN
 
 %%
 
@@ -548,15 +553,21 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "state"			{ return STATE; }
 "status"		{ return STATUS; }
 
-"numgen"		{ return NUMGEN; }
-"inc"			{ return INC; }
-"mod"			{ return MOD; }
-"offset"		{ return OFFSET; }
+"numgen"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_NUMGEN); return NUMGEN; }
+<SCANSTATE_EXPR_NUMGEN>{
+	"inc"		{ return INC; }
+}
 
-"jhash"			{ return JHASH; }
-"symhash"		{ return SYMHASH; }
-"seed"			{ return SEED; }
+"jhash"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HASH); return JHASH; }
+"symhash"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HASH); return SYMHASH; }
 
+<SCANSTATE_EXPR_HASH>{
+	"seed"		{ return SEED; }
+}
+<SCANSTATE_EXPR_HASH,SCANSTATE_EXPR_NUMGEN>{
+	"mod"		{ return MOD; }
+	"offset"	{ return OFFSET; }
+}
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
 
@@ -967,3 +978,14 @@ void scanner_destroy(struct nft_ctx *nft)
 	input_descriptor_list_destroy(state);
 	yylex_destroy(nft->scanner);
 }
+
+static void scanner_push_start_cond(void *scanner, enum startcond_type type)
+{
+	yy_push_state((int)type, scanner);
+}
+
+void scanner_pop_start_cond(void *scanner, enum startcond_type t)
+{
+	yy_pop_state(scanner);
+	(void)yy_top_state(scanner); /* suppress gcc warning wrt. unused function */
+}
-- 
2.26.2

