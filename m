From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] parser: simplify monitor command parsing
Date: Wed, 17 Sep 2014 09:45:07 +0200
Message-ID: <1410939907-10180-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53538 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaIQHpK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:45:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add tokens for "new" and "destroy". Split up the monitor flags into an
event and an object to avoid lots of duplicated code.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y  | 181 ++++++++++++----------------------------------------------
 src/scanner.l |   3 +
 2 files changed, 39 insertions(+), 145 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 6737aad..653c764 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -93,21 +93,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
-enum {
-	NFT_EVENT_NEW	= 0,
-	NFT_EVENT_DEL,
-};
-
-static int monitor_lookup_event(const char *event)
-{
-	if (strcmp(event, "new") == 0)
-		return NFT_EVENT_NEW;
-	else if (strcmp(event, "destroy") == 0)
-		return NFT_EVENT_DEL;
-
-	return -1;
-}
-
 %}
 
 /* Declaration section */
@@ -209,6 +194,9 @@ static int monitor_lookup_event(const char *event)
 %token GOTO			"goto"
 %token RETURN			"return"
 
+%token NEW			"new"
+%token DESTROY			"destroy"
+
 %token CONSTANT			"constant"
 %token INTERVAL			"interval"
 %token ELEMENTS			"elements"
@@ -525,7 +513,7 @@ static int monitor_lookup_event(const char *event)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key
 
-%type <val>			export_format	output_format	monitor_flags
+%type <val>			export_format	output_format	monitor_event monitor_object
 
 %%
 
@@ -797,16 +785,16 @@ export_cmd		:	export_format
 			}
 			;
 
-monitor_cmd		:	monitor_flags	output_format
+monitor_cmd		:	monitor_event	monitor_object	output_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
 				$$ = cmd_alloc(CMD_MONITOR, CMD_OBJ_RULESET, &h, &@$, NULL);
-				$$->monitor_flags = $1;
-				$$->format = $2;
+				$$->monitor_flags = $1 & $2;
+				$$->format = $3;
 			}
 			;
 
-monitor_flags		:	/* empty */
+monitor_event		:	/* empty */
 			{
 				$$ = (1 << NFT_MSG_NEWRULE)	|
 				     (1 << NFT_MSG_DELRULE)	|
@@ -819,159 +807,62 @@ monitor_flags		:	/* empty */
 				     (1 << NFT_MSG_NEWTABLE)	|
 				     (1 << NFT_MSG_DELTABLE);
 			}
-			|	STRING
+			|	NEW
 			{
-				int event;
-
-				event = monitor_lookup_event($1);
-				if (event < 0) {
-					erec_queue(error(&@1, "unknown event type %s", $1),
-						   state->msgs);
-					YYERROR;
-				}
+				$$ = (1 << NFT_MSG_NEWTABLE)	|
+				     (1 << NFT_MSG_NEWCHAIN)	|
+				     (1 << NFT_MSG_NEWRULE)	|
+				     (1 << NFT_MSG_NEWSET)	|
+				     (1 << NFT_MSG_NEWSETELEM);
+			}
+			|	DESTROY
+			{
+				$$ = (1 << NFT_MSG_DELTABLE)	|
+				     (1 << NFT_MSG_DELCHAIN)	|
+				     (1 << NFT_MSG_DELRULE)	|
+				     (1 << NFT_MSG_DELSET)	|
+				     (1 << NFT_MSG_DELSETELEM);
+			}
+			;
 
-				switch (event) {
-				case NFT_EVENT_NEW:
-					$$ = (1 << NFT_MSG_NEWTABLE)	|
-					     (1 << NFT_MSG_NEWCHAIN)	|
-					     (1 << NFT_MSG_NEWRULE)	|
-					     (1 << NFT_MSG_NEWSET)	|
-					     (1 << NFT_MSG_NEWSETELEM);
-					break;
-				case NFT_EVENT_DEL:
-					$$ = (1 << NFT_MSG_DELTABLE)	|
-					     (1 << NFT_MSG_DELCHAIN)	|
-					     (1 << NFT_MSG_DELRULE)	|
-					     (1 << NFT_MSG_DELSET)	|
-					     (1 << NFT_MSG_DELSETELEM);
-					break;
-				}
+monitor_object		:	/* empty */
+			{
+				$$ = (1 << NFT_MSG_NEWRULE)	|
+				     (1 << NFT_MSG_DELRULE)	|
+				     (1 << NFT_MSG_NEWSET)	|
+				     (1 << NFT_MSG_DELSET)	|
+				     (1 << NFT_MSG_NEWSETELEM)	|
+				     (1 << NFT_MSG_DELSETELEM)	|
+				     (1 << NFT_MSG_NEWCHAIN)	|
+				     (1 << NFT_MSG_DELCHAIN)	|
+				     (1 << NFT_MSG_NEWTABLE)	|
+				     (1 << NFT_MSG_DELTABLE);
 			}
 			|	TABLES
 			{
 				$$ = (1 << NFT_MSG_NEWTABLE) |
 				     (1 << NFT_MSG_DELTABLE);
 			}
-			|	STRING 	TABLES
-			{
-				int event;
-
-				event = monitor_lookup_event($1);
-				if (event < 0) {
-					erec_queue(error(&@1, "unknown event type %s", $1),
-						   state->msgs);
-					YYERROR;
-				}
-
-				switch (event) {
-				case NFT_EVENT_NEW:
-					$$ = (1 << NFT_MSG_NEWTABLE);
-					break;
-				case NFT_EVENT_DEL:
-					$$ = (1 << NFT_MSG_DELTABLE);
-					break;
-				}
-			}
 			|	CHAINS
 			{
 				$$ = (1 << NFT_MSG_NEWCHAIN) |
 				     (1 << NFT_MSG_DELCHAIN);
 			}
-			|	STRING	CHAINS
-			{
-				int event;
-
-				event = monitor_lookup_event($1);
-				if (event < 0) {
-					erec_queue(error(&@1, "unknown event type %s", $1),
-						   state->msgs);
-					YYERROR;
-				}
-
-				switch (event) {
-				case NFT_EVENT_NEW:
-					$$ = (1 << NFT_MSG_NEWCHAIN);
-					break;
-				case NFT_EVENT_DEL:
-					$$ = (1 << NFT_MSG_DELCHAIN);
-					break;
-				}
-			}
 			|	SETS
 			{
 				$$ = (1 << NFT_MSG_NEWSET) |
 				     (1 << NFT_MSG_DELSET);
 			}
-			|	STRING	SETS
-			{
-				int event;
-
-				event = monitor_lookup_event($1);
-				if (event < 0) {
-					erec_queue(error(&@1, "unknown event type %s", $1),
-						   state->msgs);
-					YYERROR;
-				}
-
-				switch (event) {
-				case NFT_EVENT_NEW:
-					$$ = (1 << NFT_MSG_NEWSET);
-					break;
-				case NFT_EVENT_DEL:
-					$$ = (1 << NFT_MSG_DELSET);
-					break;
-				}
-			}
 			|	RULES
 			{
 				$$ = (1 << NFT_MSG_NEWRULE) |
 				     (1 << NFT_MSG_DELRULE);
 			}
-			|	STRING 	RULES
-			{
-				int event;
-
-				event = monitor_lookup_event($1);
-				if (event < 0) {
-					erec_queue(error(&@1, "unknown event type %s", $1),
-						   state->msgs);
-					YYERROR;
-				}
-
-				switch (event) {
-				case NFT_EVENT_NEW:
-					$$ = (1 << NFT_MSG_NEWRULE);
-					break;
-				case NFT_EVENT_DEL:
-					$$ = (1 << NFT_MSG_DELRULE);
-					break;
-				}
-			}
 			|	ELEMENTS
 			{
 				$$ = (1 << NFT_MSG_NEWSETELEM) |
 				     (1 << NFT_MSG_DELSETELEM);
 			}
-			|	STRING	ELEMENTS
-			{
-				int event;
-
-				event = monitor_lookup_event($1);
-				if (event < 0) {
-					erec_queue(error(&@1, "unknown event type %s", $1),
-						   state->msgs);
-					YYERROR;
-				}
-
-				switch (event) {
-				case NFT_EVENT_NEW:
-					$$ = (1 << NFT_MSG_NEWSETELEM);
-					break;
-				case NFT_EVENT_DEL:
-					$$ = (1 << NFT_MSG_DELSETELEM);
-					break;
-				}
-			}
 			;
 
 output_format		:	/* empty */
diff --git a/src/scanner.l b/src/scanner.l
index 601ea3c..8aab38f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -261,6 +261,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "export"		{ return EXPORT; }
 "monitor"		{ return MONITOR; }
 
+"new"			{ return NEW; }
+"destroy"		{ return DESTROY; }
+
 "position"		{ return POSITION; }
 "comment"		{ return COMMENT; }
 
-- 
1.9.3

