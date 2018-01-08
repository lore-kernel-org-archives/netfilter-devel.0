From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v3] parser_bison: extend nft to delete table via table handle
Date: Mon,  8 Jan 2018 23:27:07 +0530
Message-ID: <20180108175707.22999-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33411 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753960AbeAHR5w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 12:57:52 -0500
Received: by mail-pg0-f68.google.com with SMTP id i196so6034621pgd.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jan 2018 09:57:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows deletion of table via unique table handles and table
family which can be listed with '-a' option.
For.eg.
nft delete table [<family>] [handle <handle>]

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v3:
 - Add tableid_spec
 - Change log message
Changes in v2:
 - remove tableid_spec

 src/parser_bison.y | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e85a62..a5c47c2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -495,8 +495,8 @@ int nft_lex(void *, void *, void *);
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
+%type <handle>			table_spec tableid_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
+%destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %type <handle>			set_spec set_identifier obj_spec obj_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier obj_spec obj_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
@@ -978,6 +978,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
+			|	TABLE 		tableid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
+			}
 			|	CHAIN		chain_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
@@ -1660,6 +1664,15 @@ table_spec		:	family_spec	identifier
 			}
 			;
 
+tableid_spec 		: 	family_spec 	HANDLE NUM
+			{
+				memset(&$$, 0, sizeof($$));
+				$$.family 		= $1;
+				$$.handle.id 		= $3;
+				$$.handle.location	= @$;
+			}
+			;
+
 chain_spec		:	table_spec	identifier
 			{
 				$$		= $1;
-- 
2.11.0

