From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 2/2] parser_bison: extend nft to delete chain via chain handle
Date: Wed, 10 Jan 2018 00:29:42 +0530
Message-ID: <d979fe20be1631d5aba7dc4f158cca0d1a3791c3.1515521150.git.harshasharmaiitr@gmail.com>
References: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33029 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932310AbeAITAG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 14:00:06 -0500
Received: by mail-pf0-f194.google.com with SMTP id y89so9219753pfk.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jan 2018 11:00:06 -0800 (PST)
In-Reply-To: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows deletion of chains via unique chain handles which
can be listed with '-a' option and table name and family.
For eg.

nft delete chain [<family>] <table-name> [handle <handle>]

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/parser_bison.y | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a5c47c2..dbe80a5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -495,8 +495,8 @@ int nft_lex(void *, void *, void *);
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
 
-%type <handle>			table_spec tableid_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
-%destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
+%type <handle>			table_spec tableid_spec chain_spec chainid_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
+%destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chainid_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec
 %type <handle>			set_spec set_identifier obj_spec obj_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier obj_spec obj_identifier
 %type <val>			family_spec family_spec_explicit chain_policy prio_spec
@@ -986,6 +986,10 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
+			| 	CHAIN 		chainid_spec
+			{
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
+			}
 			|	RULE		ruleid_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
@@ -1680,6 +1684,14 @@ chain_spec		:	table_spec	identifier
 			}
 			;
 
+chainid_spec 		: 	table_spec 	HANDLE NUM
+			{
+				$$ 			= $1;
+				$$.handle.location 	= @$;
+				$$.handle.id 		= $3;
+			}
+			;
+
 chain_identifier	:	identifier
 			{
 				memset(&$$, 0, sizeof($$));
-- 
2.11.0

