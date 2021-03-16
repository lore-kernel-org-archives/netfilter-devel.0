Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC9EC4332B
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F94E64F90
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhCPXlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhCPXlJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:41:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B05BC06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:41:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJJD-00058Q-Hr; Wed, 17 Mar 2021 00:41:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/6] scanner: support arbitrary chain names
Date:   Wed, 17 Mar 2021 00:40:38 +0100
Message-Id: <20210316234039.15677-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316234039.15677-1-fw@strlen.de>
References: <20210316234039.15677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous change removed constraints on table naming, this extends it
to handle chain names as well.

The new exclusive scope also needs to permit '{' to handle bounded
chains, e.g.

 .... jump { ip ...

and "handle", to deal with: 'delete chain test-ip handle 2' -- in both
cases flex needs to leave the chain scope immediately.

The parser_state struct is used to record if we saw a family or table
name:

chain tname cname
chain ip tname cname
chain cname {
chain tname handle 1
chain ip tname handle 1

... are all valid.  We can't exit after the second name, first name
could have been the family name, not the table.

This change allows nft to parse:
  table ip dup {
        chain fwd {
        }
 }
 table inet dup {
        chain fwd {
        }
 }

The point here is not to allow aribitrary names (for instance
'table ip handle' won't work), its to make sure a new/future expression
keyword won't break an existing ruleset where the 'new keyword' happened
to be the name of a chain/table.

Remaining issue:

   |       RULE            rule_position   rule
   {
       $$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$2, &@$, $3);
   }
   |       /* empty */     rule_position   rule

so, implicit 'add rule', e.g.  "nft ip tname cname ip saddr ..."
will not work when either tname or cname would be added as
token/expression in a future release.

This can't be fully resolved, there is no context (from scanner) to know that
'ip tname cname' need to be parsed as 'IP STRING STRING'.

With the long form (nft add rule ip tname cname ...), the RULE token
allows to switch scanner start condition.

Switching state from bison doesn't work reliably as the switch rule
will be evaluated too late, e.g. 'nft add dup ...'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  3 ++
 src/parser_bison.y |  5 +--
 src/scanner.l      | 81 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0843aa1adb6a..d6cf20729421 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -26,6 +26,8 @@ struct parser_state {
 	unsigned int			flex_state_pop;
 	unsigned int			startcond_type;
 	unsigned int			saw_family:1;
+	unsigned int			saw_table:1;
+	unsigned int			saw_chain:1;
 	struct list_head		*cmds;
 };
 
@@ -52,6 +54,7 @@ enum startcond_type {
 	PARSER_SC_STMT_LOG,
 
 	PARSER_SC_STRING_TABLE,
+	PARSER_SC_STRING_CHAIN,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 98fe4431c4f4..bbac85fd35ce 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -864,6 +864,7 @@ opt_newline		:	NEWLINE
 close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
+close_scope_chain	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STRING_CHAIN); }
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
@@ -2462,7 +2463,7 @@ tableid_spec 		: 	family_spec 	HANDLE NUM
 			}
 			;
 
-chain_spec		:	table_spec	identifier
+chain_spec		:	table_spec	identifier	close_scope_chain
 			{
 				$$		= $1;
 				$$.chain.name	= $2;
@@ -2470,7 +2471,7 @@ chain_spec		:	table_spec	identifier
 			}
 			;
 
-chainid_spec 		: 	table_spec 	HANDLE NUM
+chainid_spec 		: 	table_spec 	HANDLE NUM	close_scope_chain
 			{
 				$$ 			= $1;
 				$$.handle.location 	= @3;
diff --git a/src/scanner.l b/src/scanner.l
index bf6f290db3db..a156accaa944 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -99,6 +99,7 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 }
 
 static int scanner_handle_tablename(void *scanner, const char *token);
+static int scanner_handle_chainname(void *scanner, const char *token);
 
 static void scanner_push_start_cond(void *scanner, enum startcond_type type);
 
@@ -219,6 +220,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_STMT_LOG
 
 %x SCANSTATE_STRING_TABLE
+%x SCANSTATE_STRING_CHAIN
+%x SCANSTATE_STRING_JUMP
 %%
 
 "=="			{ return EQ; }
@@ -277,9 +280,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "devices"		{ return DEVICES; }
 "table"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STRING_TABLE); return TABLE; }
 "tables"		{ return TABLES; }
-"chain"			{ return CHAIN; }
+"chain"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STRING_CHAIN); return CHAIN; }
 "chains"		{ return CHAINS; }
-"rule"			{ return RULE; }
+"rule"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STRING_CHAIN); return RULE; }
 "rules"			{ return RULES; }
 "sets"			{ return SETS; }
 "set"			{ return SET; }
@@ -301,8 +304,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
 "continue"		{ return CONTINUE; }
-"jump"			{ return JUMP; }
-"goto"			{ return GOTO; }
+"jump"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STRING_JUMP); return JUMP; }
+"goto"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STRING_JUMP); return GOTO; }
 "return"		{ return RETURN; }
 "to"			{ return TO; }
 
@@ -721,11 +724,44 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				if (token != STRING)
 					return token;
 
+				scanner_pop_start_cond(yyscanner, SCANSTATE_STRING_TABLE);
 				yylval->string = xstrdup(yytext);
 				return STRING;
 			}
 
-<SCANSTATE_STRING_TABLE>{
+<SCANSTATE_STRING_CHAIN>{
+	"handle"	{
+			scanner_pop_start_cond(yyscanner, SCANSTATE_STRING_CHAIN);
+			return HANDLE;
+	}
+	{string}	{
+				int token = scanner_handle_chainname(yyscanner, yytext);
+
+				if (token != STRING)
+					return token;
+
+				yylval->string = xstrdup(yytext);
+				return STRING;
+	}
+	"{"		{
+			scanner_pop_start_cond(yyscanner, SCANSTATE_STRING_CHAIN);
+			return '{';
+	}
+}
+
+<SCANSTATE_STRING_JUMP>{string}	{
+				yylval->string = xstrdup(yytext);
+				scanner_pop_start_cond(yyscanner, SCANSTATE_STRING_JUMP);
+				return STRING;
+			}
+<SCANSTATE_STRING_JUMP>"{"		{
+				/* chain binding, e.g. jump { ... */
+				scanner_pop_start_cond(yyscanner, SCANSTATE_STRING_JUMP);
+				return '{';
+			}
+
+
+<SCANSTATE_STRING_TABLE,SCANSTATE_STRING_CHAIN,SCANSTATE_STRING_JUMP>{
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
@@ -1057,16 +1093,27 @@ static void scanner_push_start_cond(void *scanner, enum startcond_type type)
 
 	state->startcond_type = type;
 	yy_push_state((int)type, scanner);
+
+	if (type == SCANSTATE_STRING_CHAIN)
+		state->saw_chain = 1;
 }
 
 void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
-	if (state->startcond_type != t) {
-		if (state->startcond_type == SCANSTATE_STRING_TABLE)
+	if (t == SCANSTATE_STRING_CHAIN) {
+		if (!state->saw_chain) /* implicit chain scope: never pushed the state */
 			return;
 
+		if (state->startcond_type == t)
+			state->saw_chain = 0;
+	}
+
+	if (state->startcond_type != t) {
+		if (state->startcond_type == SCANSTATE_STRING_TABLE ||
+		    state->startcond_type == SCANSTATE_STRING_CHAIN)
+			return;
 		state->flex_state_pop++;
 		return; /* Can't pop just yet! */
 	}
@@ -1087,12 +1134,8 @@ static int scanner_handle_tablename(void *scanner, const char *token)
 	struct parser_state *state = yyget_extra(scanner);
 	int ret = STRING;
 
-	if (state->startcond_type != SCANSTATE_STRING_TABLE)
-		return STRING;
-
 	if (state->saw_family) {
 		state->saw_family = 0;
-		scanner_pop_start_cond(scanner, SCANSTATE_STRING_TABLE);
 		return STRING;
 	}
 
@@ -1112,8 +1155,20 @@ static int scanner_handle_tablename(void *scanner, const char *token)
 
 	if (ret != STRING)
 		state->saw_family = 1;
-	else
-		scanner_pop_start_cond(scanner, SCANSTATE_STRING_TABLE);
+
+	return ret;
+}
+
+static int scanner_handle_chainname(void *scanner, const char *token)
+{
+	struct parser_state *state = yyget_extra(scanner);
+	bool saw_table = state->saw_table;
+	int ret;
+
+	ret = scanner_handle_tablename(scanner, token);
+
+	if (ret == STRING && saw_table)
+		scanner_pop_start_cond(scanner, SCANSTATE_STRING_CHAIN);
 
 	return ret;
 }
-- 
2.26.2

