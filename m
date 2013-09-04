From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool v2 PATCH 3/4] src: Add priority keyword on base chain description
Date: Wed,  4 Sep 2013 12:50:21 +0300
Message-ID: <1378288222-13182-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8913 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469Ab3IDJum (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:50:42 -0400
In-Reply-To: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
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
index 73a52d4..25da452 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -767,7 +767,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
+hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			{
 				$<chain>0->type		= chain_type_name_lookup($2);
 				if ($<chain>0->type == NULL) {
@@ -781,10 +781,10 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->priority	= $5;
+				$<chain>0->priority	= $6;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
-			|	TYPE		STRING		HOOK		STRING		DASH	NUM
+			|	TYPE		STRING		HOOK		STRING		PRIORITY	DASH	NUM
 			{
 				$<chain>0->type		= chain_type_name_lookup($2);
 				if ($<chain>0->type == NULL) {
@@ -798,7 +798,7 @@ hook_spec		:	TYPE		STRING		HOOK		STRING		NUM
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->priority	= -$6;
+				$<chain>0->priority	= -$7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
 			;
diff --git a/src/rule.c b/src/rule.c
index 37dcc8c..56592e8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -314,7 +314,7 @@ static void chain_print(const struct chain *chain)
 
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		printf("\t\t type %s hook %s %u;\n", chain->type,
+		printf("\t\t type %s hook %s priority %u;\n", chain->type,
 		       hooknum2str(chain->handle.family, chain->hooknum),
 		       chain->priority);
 	}
-- 
1.8.3.2

