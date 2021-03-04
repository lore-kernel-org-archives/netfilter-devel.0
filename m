Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0251C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B668564FDA
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbhCDBPX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454173AbhCDBI0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 20:08:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5DFC06175F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:07:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lHcSu-0005N2-RP; Thu, 04 Mar 2021 02:07:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] parser: squash duplicated spec/specid rules
Date:   Thu,  4 Mar 2021 02:07:33 +0100
Message-Id: <20210304010735.28683-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to have duplicate CMD rules for spec and specid: add and use
a common rule for those cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 82 +++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index a2c150180ca3..363569ffacb6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -588,10 +588,20 @@ int nft_lex(void *, void *, void *);
 %type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 %destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd insert_cmd delete_cmd get_cmd list_cmd reset_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd import_cmd
 
-%type <handle>			table_spec tableid_spec chain_spec chainid_spec flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
-%destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chainid_spec flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
-%type <handle>			set_spec setid_spec set_identifier flowtableid_spec flowtable_identifier obj_spec objid_spec obj_identifier
-%destructor { handle_free(&$$); } set_spec setid_spec set_identifier flowtableid_spec obj_spec objid_spec obj_identifier
+%type <handle>			table_spec tableid_spec table_or_id_spec
+%destructor { handle_free(&$$); } table_spec tableid_spec table_or_id_spec
+%type <handle>			chain_spec chainid_spec chain_or_id_spec
+%destructor { handle_free(&$$); } chain_spec chainid_spec chain_or_id_spec
+
+%type <handle>			flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
+%destructor { handle_free(&$$); } flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
+%type <handle>			set_spec setid_spec set_or_id_spec
+%destructor { handle_free(&$$); } set_spec setid_spec set_or_id_spec
+%type <handle>			obj_spec objid_spec obj_or_id_spec
+%destructor { handle_free(&$$); } obj_spec objid_spec obj_or_id_spec
+
+%type <handle>			set_identifier flowtableid_spec flowtable_identifier obj_identifier
+%destructor { handle_free(&$$); } set_identifier flowtableid_spec obj_identifier
 %type <val>			family_spec family_spec_explicit
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
@@ -1167,19 +1177,27 @@ insert_cmd		:	RULE		rule_position	rule
 			}
 			;
 
-delete_cmd		:	TABLE		table_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
-			}
-			|	TABLE 		tableid_spec
+table_or_id_spec	:	table_spec
+			|	tableid_spec
+			;
+
+chain_or_id_spec	:	chain_spec
+			|	chainid_spec
+			;
+
+set_or_id_spec		:	set_spec
+			|	setid_spec
+			;
+
+obj_or_id_spec		:	obj_spec
+			|	objid_spec
+			;
+
+delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
-			|	CHAIN		chain_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
-			}
-			| 	CHAIN 		chainid_spec
+			|	CHAIN		chain_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
@@ -1187,11 +1205,7 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_RULE, &$2, &@$, NULL);
 			}
-			|	SET		set_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
-			}
-			| 	SET 		setid_spec
+			|	SET		set_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
@@ -1218,19 +1232,11 @@ delete_cmd		:	TABLE		table_spec
 				handle_merge(&$3->handle, &$2);
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, $5);
 			}
-			|	COUNTER		obj_spec
+			|	COUNTER		obj_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
 			}
-			|  	COUNTER 	objid_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
-			}
-			|	QUOTA		obj_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
-			}
-			| 	QUOTA 		objid_spec
+			|	QUOTA		obj_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
@@ -1238,27 +1244,15 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
 			}
-			|	LIMIT		obj_spec
+			|	LIMIT		obj_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
 			}
-			| 	LIMIT 		objid_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_LIMIT, &$2, &@$, NULL);
-			}
-			|	SECMARK		obj_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SECMARK, &$2, &@$, NULL);
-			}
-			| 	SECMARK		objid_spec
+			|	SECMARK		obj_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
-			|	SYNPROXY	obj_spec
-			{
-				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
-			}
-			|	SYNPROXY	objid_spec
+			|	SYNPROXY	obj_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
-- 
2.26.2

