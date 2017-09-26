From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v2 3/3] parser_bison: allow helper keyword in ct object kind
Date: Tue, 26 Sep 2017 19:46:21 +0200
Message-ID: <1506447981-4161-3-git-send-email-pablo@netfilter.org>
References: <1506447981-4161-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968517AbdIZRqe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 13:46:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 841D8EB464
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:46:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72276B502C
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:46:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4033FB502C
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:46:30 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1171744581E1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 19:46:30 +0200 (CEST)
In-Reply-To: <1506447981-4161-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The helper keyword clashes with the string rule, make sure we still
accept ct helper object types from the parser.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0d916190e298..970d773edc4f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -877,7 +877,7 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
+			|	CT	ct_obj_kind	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
 			{
 				struct error_record *erec;
 				int type;
@@ -961,7 +961,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
+			|	CT	ct_obj_kind	obj_spec	ct_obj_alloc	'{' ct_block '}'	stmt_separator
 			{
 				struct error_record *erec;
 				int type;
@@ -1019,7 +1019,7 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
-			|	CT	STRING	obj_spec	ct_obj_alloc
+			|	CT	ct_obj_kind	obj_spec	ct_obj_alloc
 			{
 				struct error_record *erec;
 				int type;
@@ -1123,7 +1123,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
-			|	CT		STRING	obj_spec
+			|	CT		ct_obj_kind	obj_spec
 			{
 				struct error_record *erec;
 				int type;
@@ -1137,7 +1137,7 @@ list_cmd		:	TABLE		table_spec
 
 				$$ = cmd_alloc_obj_ct(CMD_LIST, type, &$3, &@$, NULL);
 			}
-			|       CT              STRING  TABLE   table_spec
+			|       CT		ct_obj_kind	TABLE   table_spec
 			{
 				int cmd;
 
@@ -2886,6 +2886,7 @@ quota_obj		:	quota_config
 			;
 
 ct_obj_kind		:	STRING		{ $$ = $1; }
+			|	HELPER		{ $$ = xstrdup("helper"); }
 			;
 
 ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
-- 
2.1.4

