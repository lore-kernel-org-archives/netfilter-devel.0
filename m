From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: restore nft {import,export} ruleset
Date: Wed, 14 Feb 2018 19:32:44 +0100
Message-ID: <20180214183244.16184-1-pablo@netfilter.org>
Cc: mayhs11saini@gmail.com, anthonyryan1@gmail.com, phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162181AbeBNSc5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 13:32:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33C411A09A1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 19:32:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26935DA787
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 19:32:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Restore original syntax for the yet experimental VM low-level json
representation.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1224
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I asked for this change to make room for the high-level json
representation, but we can use -j options for this instead.  Given there
are more users for the json representation that I expected, I'm fixing
it myself by restoring the former behaviour.

 src/parser_bison.y | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 578bfdc10429..4cfc54cfd7b2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1186,7 +1186,7 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 			}
 			;
 
-import_cmd			:       RULESET         markup_format
+import_cmd		:       RULESET         markup_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
 				struct markup *markup = markup_alloc($2);
@@ -1198,7 +1198,6 @@ import_cmd			:       RULESET         markup_format
 				struct markup *markup = markup_alloc($1);
 				$$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
-			|	JSON		{ $$ = NULL; }
 			;
 
 export_cmd		:	RULESET		markup_format
@@ -1213,7 +1212,6 @@ export_cmd		:	RULESET		markup_format
 				struct markup *markup = markup_alloc($1);
 				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
 			}
-			|	JSON		{ $$ = NULL; }
 			;
 
 monitor_cmd		:	monitor_event	monitor_object	monitor_format
@@ -1241,10 +1239,10 @@ monitor_object		:	/* empty */	{ $$ = CMD_MONITOR_OBJ_ANY; }
 
 monitor_format		:	/* empty */	{ $$ = NFTNL_OUTPUT_DEFAULT; }
 			|	markup_format
-			|	JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			;
 
 markup_format		: 	XML 		{ $$ = NFTNL_OUTPUT_XML; }
+			|	JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			|	VM JSON		{ $$ = NFTNL_OUTPUT_JSON; }
 			;
 
-- 
2.11.0

