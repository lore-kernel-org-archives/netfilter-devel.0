From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH 3/5] syntax: Add priority keyword on base chain description
Date: Wed, 28 Aug 2013 11:33:09 +0300
Message-ID: <1377678791-7616-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:28313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab3H1IdU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:33:20 -0400
In-Reply-To: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of:
add chain foo bar { type route hook input 0; }

it should be now:
add chain foo bar { type route hook input priority 0; }

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/parser.y | 8 ++++----
 src/rule.c   | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 4df7d44..9a91490 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -765,11 +765,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
+hook_spec		:	TYPE	STRING	HOOK	STRING	PRIORITY	NUM
 			{
 				$<chain>0->type		= $2;
 				$<chain>0->hooknum	= str2hooknum($4);
-				$<chain>0->priority	= $5;
+				$<chain>0->priority	= $6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 
 				if ($<chain>0->hooknum == HOOK_NUMHOOKS) {
@@ -778,11 +778,11 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 					YYERROR;	
 				}
 			}
-			|	TYPE		STRING		HOOK		STRING		DASH	NUM
+			|	TYPE	STRING	HOOK	STRING	PRIORITY	DASH	NUM
 			{
 				$<chain>0->type		= $2;
 				$<chain>0->hooknum	= str2hooknum($4);
-				$<chain>0->priority	= -$6;
+				$<chain>0->priority	= -$7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 
 				if ($<chain>0->hooknum == HOOK_NUMHOOKS) {
diff --git a/src/rule.c b/src/rule.c
index 23b64a7..28a52b0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -262,7 +262,7 @@ static void chain_print(const struct chain *chain)
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\t type %s hook %s %u;\n", chain->type,
+		printf("\t\t type %s hook %s priority %u;\n", chain->type,
 		       hooknum2str(chain->hooknum), chain->priority);
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
-- 
1.8.3.2

