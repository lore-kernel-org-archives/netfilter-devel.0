From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/2] src/parser_bison: fix ruleid_spec ambiguity
Date: Fri, 18 Mar 2016 20:29:29 +0100
Message-ID: <145832936930.1466.10807188686798508369.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: sander.contrib@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58477 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753464AbcCRT3j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 15:29:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, parser allows both 'handle' and 'position' as part of the
same grammar rule. But we don't combine them in any case actually.

As a result of this, deleting rules using "position" keyword deletes all
rules for chain.

Split the ruleid_spec in two types:
 * one for handles
 * one for positions

This change complies with the syntax/grammar described currently in the wiki.

Netfilter bug: http://bugzilla.netfilter.org/show_bug.cgi?id=965
Reported-by: Jesper Sander Lindgren <sander.contrib@gmail.com>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/parser_bison.y |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9e86f26..5ff69ef 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -419,8 +419,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
-%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
+%type <handle>			table_spec chain_spec chain_identifier rulehandle_spec ruleposition_spec ruleset_spec
+%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier rulehandle_spec ruleposition_spec ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
 %type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy prio_spec
@@ -704,11 +704,11 @@ add_cmd			:	TABLE		table_spec
 				close_scope(state);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &$2, &@$, $5);
 			}
-			|	RULE		ruleid_spec	rule
+			|	RULE		ruleposition_spec	rule
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$2, &@$, $3);
 			}
-			|	/* empty */	ruleid_spec	rule
+			|	/* empty */	ruleposition_spec	rule
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &$1, &@$, $2);
 			}
@@ -732,7 +732,7 @@ add_cmd			:	TABLE		table_spec
 			}
 			;
 
-replace_cmd		:	RULE		ruleid_spec	rule
+replace_cmd		:	RULE		rulehandle_spec	rule
 			{
 				$$ = cmd_alloc(CMD_REPLACE, CMD_OBJ_RULE, &$2, &@$, $3);
 			}
@@ -763,7 +763,7 @@ create_cmd		:	TABLE		table_spec
 			}
 			;
 
-insert_cmd		:	RULE		ruleid_spec	rule
+insert_cmd		:	RULE		ruleposition_spec	rule
 			{
 				$$ = cmd_alloc(CMD_INSERT, CMD_OBJ_RULE, &$2, &@$, $3);
 			}
@@ -777,7 +777,7 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
-			|	RULE		ruleid_spec
+			|	RULE		rulehandle_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
 			}
@@ -1236,11 +1236,19 @@ position_spec		:	/* empty */
 			}
 			;
 
-ruleid_spec		:	chain_spec	handle_spec	position_spec
+rulehandle_spec		:	chain_spec	handle_spec
 			{
 				$$		= $1;
 				$$.handle	= $2;
-				$$.position	= $3;
+				$$.position	= 0;
+			}
+			;
+
+ruleposition_spec	:	chain_spec	position_spec
+			{
+				$$		= $1;
+				$$.handle	= 0;
+				$$.position	= $2;
 			}
 			;
 

