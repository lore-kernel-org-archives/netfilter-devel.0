From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] parser: remove duplicated grammar for chain policy
Date: Wed, 25 Mar 2015 21:00:27 +0000
Message-ID: <1427317227-11313-3-git-send-email-kaber@trash.net>
References: <1427317227-11313-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51968 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbCYVAc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 17:00:32 -0400
In-Reply-To: <1427317227-11313-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser_bison.y | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ea3ff52..b86381d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -409,7 +409,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { handle_free(&$$); } table_spec tables_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
-%type <val>			handle_spec family_spec family_spec_explicit position_spec
+%type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
@@ -1071,26 +1071,21 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			}
 			;
 
-policy_spec		:	POLICY		ACCEPT
+policy_spec		:	POLICY		chain_policy
 			{
 				if ($<chain>0->policy != -1) {
 					erec_queue(error(&@$, "you cannot set chain policy twice"),
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->policy	= NF_ACCEPT;
-			}
-			|	POLICY		DROP
-			{
-				if ($<chain>0->policy != -1) {
-					erec_queue(error(&@$, "you cannot set chain policy twice"),
-						   state->msgs);
-					YYERROR;
-				}
-				$<chain>0->policy	= NF_DROP;
+				$<chain>0->policy	= $2;
 			}
 			;
 
+chain_policy		:	ACCEPT		{ $$ = NF_ACCEPT; }
+			|	DROP		{ $$ = NF_DROP;   }
+			;
+
 identifier		:	STRING
 			;
 
-- 
2.1.0

