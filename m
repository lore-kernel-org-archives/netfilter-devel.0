From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nft 1/3] parser_bison: simplify hook_spec rule
Date: Tue, 15 Mar 2016 17:33:16 +0100
Message-ID: <1458059598-7470-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33691 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192AbcCOQdf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 12:33:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F28C8114F4D
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DBF4CDA38A
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CBCBDDA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 17:33:25 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Consolidate this rule by introducing the dev_spec and prio_spec, we save
50 LOC with this patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 66 +++++++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 51 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 90978ab..24c0969 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -423,7 +423,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
-%type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy
+%type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy prio_spec
+
+%type <string>			dev_spec
+%destructor { xfree($$); }	dev_spec
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
@@ -1096,41 +1099,7 @@ type_identifier		:	STRING	{ $$ = $1; }
 			|	MARK	{ $$ = xstrdup("mark"); }
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
-			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown chain type %s", $2),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				if ($<chain>0->hookstr == NULL) {
-					erec_queue(error(&@4, "unknown chain hook %s", $4),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->priority	= $6;
-				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
-			}
-			|	TYPE		STRING		HOOK		STRING		PRIORITY	DASH	NUM
-			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown type name %s", $2),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				if ($<chain>0->hookstr == NULL) {
-					erec_queue(error(&@4, "unknown hook name %s", $4),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->priority	= -$7;
-				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
-			}
-			|	TYPE		STRING		HOOK		STRING		DEVICE	STRING	PRIORITY	NUM
+hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	PRIORITY	prio_spec
 			{
 				$<chain>0->type		= chain_type_name_lookup($2);
 				if ($<chain>0->type == NULL) {
@@ -1144,25 +1113,20 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->dev		= $6;
-				$<chain>0->priority	= $8;
-				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
-			}
-			|	TYPE		STRING		HOOK		STRING		DEVICE	STRING	PRIORITY	DASH	NUM
-			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown type name %s", $2),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				$<chain>0->dev		= $6;
-				$<chain>0->priority	= -$9;
+				$<chain>0->dev		= $5;
+				$<chain>0->priority	= $7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
 			;
 
+prio_spec		:	NUM			{ $$ = $1; }
+			|	DASH	NUM		{ $$ = -$2; }
+			;
+
+dev_spec		:	DEVICE	STRING		{ $$ = $2; }
+			|	/* empty */		{ $$ = NULL; }
+			;
+
 policy_spec		:	POLICY		chain_policy
 			{
 				if ($<chain>0->policy != -1) {
-- 
2.1.4

