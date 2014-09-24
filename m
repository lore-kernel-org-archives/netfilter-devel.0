From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] parser: rearrange monitor/export rules
Date: Wed, 24 Sep 2014 14:20:32 +0200
Message-ID: <1411561232-20204-4-git-send-email-kaber@trash.net>
References: <1411561232-20204-1-git-send-email-kaber@trash.net>
Cc: eric@regit.org, arturo.borrero.glez@gmail.com,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56700 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaIXMUh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:20:37 -0400
In-Reply-To: <1411561232-20204-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move the output format rules next to the monitor and export command rules,
format them similar to other simple value mappings and unify their naming.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index cf1f42b..32d5455 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -513,7 +513,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format	output_format	monitor_event monitor_object
+%type <val>			export_format
+%type <val>			monitor_event	monitor_object		monitor_format
 
 %%
 
@@ -780,7 +781,7 @@ export_cmd		:	export_format
 			}
 			;
 
-monitor_cmd		:	monitor_event	monitor_object	output_format
+monitor_cmd		:	monitor_event	monitor_object	monitor_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
 				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_RULESET, &h, &@$, NULL);
@@ -860,6 +861,14 @@ monitor_object		:	/* empty */
 			}
 			;
 
+monitor_format		:	/* empty */	{ $$ = NFT_OUTPUT_DEFAULT; }
+			|	export_format
+			;
+
+export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
+			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
+			;
+
 describe_cmd		:	primary_expr
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
@@ -868,13 +877,6 @@ describe_cmd		:	primary_expr
 			}
 			;
 
-output_format		:	/* empty */
-			{
-				$$ = NFT_OUTPUT_DEFAULT;
-			}
-			|	export_format
-			;
-
 table_block_alloc	:	/* empty */
 			{
 				$$ = table_alloc();
@@ -2168,7 +2170,4 @@ mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
 
-export_format		: 	XML 		{ $$ = NFT_OUTPUT_XML; }
-			|	JSON		{ $$ = NFT_OUTPUT_JSON; }
-			;
 %%
-- 
1.9.3

