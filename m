Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC77C4332E
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5654364F0F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhCPXlQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 19:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCPXlF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 19:41:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D455EC06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2021 16:41:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lMJJ8-00058E-SA; Wed, 17 Mar 2021 00:41:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/6] scanner: support arbitary table names
Date:   Wed, 17 Mar 2021 00:40:37 +0100
Message-Id: <20210316234039.15677-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210316234039.15677-1-fw@strlen.de>
References: <20210316234039.15677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add exclusive start condition that only recognizes strings, then
switch to it from table keyword.

This prevents

table foo {

... from breaking when a foo expression keyword would be added to nft
in the future.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h |  3 ++
 src/scanner.l    | 72 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/include/parser.h b/include/parser.h
index d890ab223c52..0843aa1adb6a 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -25,6 +25,7 @@ struct parser_state {
 
 	unsigned int			flex_state_pop;
 	unsigned int			startcond_type;
+	unsigned int			saw_family:1;
 	struct list_head		*cmds;
 };
 
@@ -49,6 +50,8 @@ enum startcond_type {
 	PARSER_SC_EXPR_SOCKET,
 
 	PARSER_SC_STMT_LOG,
+
+	PARSER_SC_STRING_TABLE,
 };
 
 struct mnl_socket;
diff --git a/src/scanner.l b/src/scanner.l
index 0082b3eeca29..bf6f290db3db 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -98,6 +98,8 @@ static void reset_pos(struct parser_state *state, struct location *loc)
 	state->indesc->column		= 1;
 }
 
+static int scanner_handle_tablename(void *scanner, const char *token);
+
 static void scanner_push_start_cond(void *scanner, enum startcond_type type);
 
 #define YY_USER_ACTION {					\
@@ -216,6 +218,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 %s SCANSTATE_STMT_LOG
 
+%x SCANSTATE_STRING_TABLE
 %%
 
 "=="			{ return EQ; }
@@ -272,7 +275,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "hook"			{ return HOOK; }
 "device"		{ return DEVICE; }
 "devices"		{ return DEVICES; }
-"table"			{ return TABLE; }
+"table"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STRING_TABLE); return TABLE; }
 "tables"		{ return TABLES; }
 "chain"			{ return CHAIN; }
 "chains"		{ return CHAINS; }
@@ -712,6 +715,34 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 .			{ return JUNK; }
 
+<SCANSTATE_STRING_TABLE>{string}		{
+				int token = scanner_handle_tablename(yyscanner, yytext);
+
+				if (token != STRING)
+					return token;
+
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
+
+<SCANSTATE_STRING_TABLE>{
+\\{newline}		{
+				reset_pos(yyget_extra(yyscanner), yylloc);
+			}
+
+{newline}		{
+				reset_pos(yyget_extra(yyscanner), yylloc);
+				return NEWLINE;
+			}
+
+{tab}+
+{space}+
+{comment}
+"$"			{ return '$'; }
+
+.			{ return JUNK; }
+}
+
 %%
 
 static void scanner_push_indesc(struct parser_state *state,
@@ -1033,6 +1064,9 @@ void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 	struct parser_state *state = yyget_extra(scanner);
 
 	if (state->startcond_type != t) {
+		if (state->startcond_type == SCANSTATE_STRING_TABLE)
+			return;
+
 		state->flex_state_pop++;
 		return; /* Can't pop just yet! */
 	}
@@ -1047,3 +1081,39 @@ void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 	yy_pop_state(scanner);
 	(void)yy_top_state(scanner); /* suppress gcc warning wrt. unused function */
 }
+
+static int scanner_handle_tablename(void *scanner, const char *token)
+{
+	struct parser_state *state = yyget_extra(scanner);
+	int ret = STRING;
+
+	if (state->startcond_type != SCANSTATE_STRING_TABLE)
+		return STRING;
+
+	if (state->saw_family) {
+		state->saw_family = 0;
+		scanner_pop_start_cond(scanner, SCANSTATE_STRING_TABLE);
+		return STRING;
+	}
+
+	if (strcmp(token, "ip") == 0) {
+		ret = IP;
+	} else if (strcmp(token, "ip6") == 0) {
+		ret = IP6;
+	} else if (strcmp(token, "inet") == 0) {
+		ret = INET;
+	} else if (strcmp(token, "bridge") == 0) {
+		ret = BRIDGE;
+	} else if (strcmp(token, "arp") == 0) {
+		ret = ARP;
+	} else if (strcmp(token, "netdev") == 0) {
+		ret = NETDEV;
+	}
+
+	if (ret != STRING)
+		state->saw_family = 1;
+	else
+		scanner_pop_start_cond(scanner, SCANSTATE_STRING_TABLE);
+
+	return ret;
+}
-- 
2.26.2

