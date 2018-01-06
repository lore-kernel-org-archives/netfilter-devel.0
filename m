From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] parser_bison: extend nft to delete table via table handle
Date: Sat,  6 Jan 2018 23:57:29 +0530
Message-ID: <20180106182729.11454-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42494 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbeAFS23 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 13:28:29 -0500
Received: by mail-pl0-f65.google.com with SMTP id bd8so5099751plb.9
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jan 2018 10:28:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows deletion of table via unique table handles which can
be listed with '-a' option.
For.eg.
nft delete table handle 4

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/parser_bison.y | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6e85a62..a7c8bbf 100644
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
@@ -1660,6 +1664,12 @@ table_spec		:	family_spec	identifier
 			}
 			;
 
+tableid_spec		:	handle_spec
+			{
+
+			}
+			;
+
 chain_spec		:	table_spec	identifier
 			{
 				$$		= $1;
-- 
2.11.0

