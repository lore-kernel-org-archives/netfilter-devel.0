Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321F7C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1574D613B6
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhEUMKY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 08:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhEUMKW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 08:10:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97B4C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 05:08:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lk3xZ-0005eo-Fk; Fri, 21 May 2021 14:08:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] scanner: add list cmd parser scope
Date:   Fri, 21 May 2021 14:08:44 +0200
Message-Id: <20210521120846.1140-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210521120846.1140-1-fw@strlen.de>
References: <20210521120846.1140-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Followup patch will add new 'hooks' keyword for
  nft list hooks

Add a scope for list to avoid exposure of the new keyword in nft
rulesets.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  3 ++-
 src/scanner.l      | 15 +++++++++------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 1a272ee25b4c..e8635b4c0feb 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -41,6 +41,7 @@ enum startcond_type {
 	PARSER_SC_SCTP,
 	PARSER_SC_SECMARK,
 	PARSER_SC_VLAN,
+	PARSER_SC_CMD_LIST,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3a11e6971177..f6c92feb7661 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -913,6 +913,7 @@ close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
+close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
@@ -1004,7 +1005,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	INSERT		insert_cmd	{ $$ = $2; }
 			|	DELETE		delete_cmd	{ $$ = $2; }
 			|	GET		get_cmd		{ $$ = $2; }
-			|	LIST		list_cmd	{ $$ = $2; }
+			|	LIST		list_cmd	close_scope_list	{ $$ = $2; }
 			|	RESET		reset_cmd	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
diff --git a/src/scanner.l b/src/scanner.l
index 5c493e390c2c..c1bc21aa7ecc 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -207,6 +207,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_SCTP
 %s SCANSTATE_SECMARK
 %s SCANSTATE_VLAN
+%s SCANSTATE_CMD_LIST
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
@@ -317,7 +318,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "insert"		{ return INSERT; }
 "delete"		{ return DELETE; }
 "get"			{ return GET; }
-"list"			{ return LIST; }
+"list"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_LIST); return LIST; }
 "reset"			{ return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
@@ -346,9 +347,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flow"			{ return FLOW; }
 "offload"		{ return OFFLOAD; }
 "meter"			{ return METER; }
-"meters"		{ return METERS; }
 
-"flowtables"		{ return FLOWTABLES; }
+<SCANSTATE_CMD_LIST>{
+	"meters"		{ return METERS; }
+	"flowtables"		{ return FLOWTABLES; }
+	"limits"		{ return LIMITS; }
+	"secmarks"		{ return SECMARKS; }
+	"synproxys"		{ return SYNPROXYS; }
+}
 
 "counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
 "name"			{ return NAME; }
@@ -357,8 +363,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "counters"		{ return COUNTERS; }
 "quotas"		{ return QUOTAS; }
-"limits"		{ return LIMITS; }
-"synproxys"		{ return SYNPROXYS; }
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
 "prefix"		{ return PREFIX; }
@@ -687,7 +691,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
-"secmarks"		{ return SECMARKS; }
 
 {addrstring}		{
 				yylval->string = xstrdup(yytext);
-- 
2.26.3

