From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser: remove the "new" and "destroy" tokens from the scanner
Date: Tue, 20 May 2014 11:17:32 +0200
Message-ID: <1400577452-6087-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58891 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaETJRo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2014 05:17:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These new tokens were introduced in f9563c0 ("src: add events reporting")
to allow filtering based on the event type.

This confuses the parser when parsing the "new" token:

test:32:33-35: Error: syntax error, unexpected new
add rule filter output ct state new,established counter
                                ^^^

This patch fixes this by replacing these event type tokens by the
generic string token, which is then interpreted during the parsing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser.y  |  209 ++++++++++++++++++++++++++++++++++++++++++++-------------
 src/scanner.l |    2 -
 2 files changed, 164 insertions(+), 47 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 9c20737..03bbb92 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -92,6 +92,21 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
+enum {
+	NFT_EVENT_NEW	= 0,
+	NFT_EVENT_DEL,
+};
+
+static int monitor_lookup_event(const char *event)
+{
+	if (strcmp(event, "new") == 0)
+		return NFT_EVENT_NEW;
+	else if (strcmp(event, "destroy") == 0)
+		return NFT_EVENT_DEL;
+
+	return -1;
+}
+
 %}
 
 /* Declaration section */
@@ -171,8 +186,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token ELEMENT			"element"
 %token MAP			"map"
 %token HANDLE			"handle"
-%token NEW			"new"
-%token DESTROY			"destroy"
 
 %token INET			"inet"
 
@@ -777,64 +790,170 @@ monitor_cmd		:	monitor_flags	output_format
 
 monitor_flags		:	/* empty */
 			{
-				$$ |= (1 << NFT_MSG_NEWRULE);
-				$$ |= (1 << NFT_MSG_DELRULE);
-				$$ |= (1 << NFT_MSG_NEWSET);
-				$$ |= (1 << NFT_MSG_DELSET);
-				$$ |= (1 << NFT_MSG_NEWSETELEM);
-				$$ |= (1 << NFT_MSG_DELSETELEM);
-				$$ |= (1 << NFT_MSG_NEWCHAIN);
-				$$ |= (1 << NFT_MSG_DELCHAIN);
-				$$ |= (1 << NFT_MSG_NEWTABLE);
-				$$ |= (1 << NFT_MSG_DELTABLE);
-			}
-			|	NEW
-			{
-				$$ |= (1 << NFT_MSG_NEWRULE);
-				$$ |= (1 << NFT_MSG_NEWSET);
-				$$ |= (1 << NFT_MSG_NEWSETELEM);
-				$$ |= (1 << NFT_MSG_NEWCHAIN);
-				$$ |= (1 << NFT_MSG_NEWTABLE);
-			}
-			|	DESTROY
-			{
-				$$ |= (1 << NFT_MSG_DELRULE);
-				$$ |= (1 << NFT_MSG_DELSET);
-				$$ |= (1 << NFT_MSG_DELSETELEM);
-				$$ |= (1 << NFT_MSG_DELCHAIN);
-				$$ |= (1 << NFT_MSG_DELTABLE);
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
+			}
+			|	STRING
+			{
+				int event;
+
+				event = monitor_lookup_event($1);
+				if (event < 0) {
+					erec_queue(error(&@1, "unknown event type %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				switch (event) {
+				case NFT_EVENT_NEW:
+					$$ = (1 << NFT_MSG_NEWTABLE)	|
+					     (1 << NFT_MSG_NEWCHAIN)	|
+					     (1 << NFT_MSG_NEWRULE)	|
+					     (1 << NFT_MSG_NEWSET)	|
+					     (1 << NFT_MSG_NEWSETELEM);
+					break;
+				case NFT_EVENT_DEL:
+					$$ = (1 << NFT_MSG_DELTABLE)	|
+					     (1 << NFT_MSG_DELCHAIN)	|
+					     (1 << NFT_MSG_DELRULE)	|
+					     (1 << NFT_MSG_DELSET)	|
+					     (1 << NFT_MSG_DELSETELEM);
+					break;
+				}
 			}
 			|	TABLES
 			{
-				$$ |= (1 << NFT_MSG_NEWTABLE);	$$ |= (1 << NFT_MSG_DELTABLE);
+				$$ = (1 << NFT_MSG_NEWTABLE) |
+				     (1 << NFT_MSG_DELTABLE);
 			}
-			|	NEW 	TABLES 	{	$$ |= (1 << NFT_MSG_NEWTABLE); }
-			|	DESTROY	TABLES	{	$$ |= (1 << NFT_MSG_DELTABLE); }
-			|	CHAIN
+			|	STRING 	TABLES
 			{
-				$$ |= (1 << NFT_MSG_NEWCHAIN);	$$ |= (1 << NFT_MSG_DELCHAIN);
+				int event;
+
+				event = monitor_lookup_event($1);
+				if (event < 0) {
+					erec_queue(error(&@1, "unknown event type %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				switch (event) {
+				case NFT_EVENT_NEW:
+					$$ = (1 << NFT_MSG_NEWTABLE);
+					break;
+				case NFT_EVENT_DEL:
+					$$ = (1 << NFT_MSG_DELTABLE);
+					break;
+				}
+			}
+			|	CHAINS
+			{
+				$$ = (1 << NFT_MSG_NEWCHAIN) |
+				     (1 << NFT_MSG_DELCHAIN);
+			}
+			|	STRING	CHAINS
+			{
+				int event;
+
+				event = monitor_lookup_event($1);
+				if (event < 0) {
+					erec_queue(error(&@1, "unknown event type %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				switch (event) {
+				case NFT_EVENT_NEW:
+					$$ = (1 << NFT_MSG_NEWCHAIN);
+					break;
+				case NFT_EVENT_DEL:
+					$$ = (1 << NFT_MSG_DELCHAIN);
+					break;
+				}
 			}
-			|	NEW	CHAINS	{	$$ |= (1 << NFT_MSG_NEWCHAIN); }
-			|	DESTROY	CHAINS	{	$$ |= (1 << NFT_MSG_DELCHAIN); }
 			|	SETS
 			{
-				$$ |= (1 << NFT_MSG_NEWSET);	$$ |= (1 << NFT_MSG_DELSET);
+				$$ = (1 << NFT_MSG_NEWSET) |
+				     (1 << NFT_MSG_DELSET);
+			}
+			|	STRING	SETS
+			{
+				int event;
+
+				event = monitor_lookup_event($1);
+				if (event < 0) {
+					erec_queue(error(&@1, "unknown event type %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				switch (event) {
+				case NFT_EVENT_NEW:
+					$$ = (1 << NFT_MSG_NEWSET);
+					break;
+				case NFT_EVENT_DEL:
+					$$ = (1 << NFT_MSG_DELSET);
+					break;
+				}
 			}
-			|	NEW	SETS 	{ 	$$ |= (1 << NFT_MSG_NEWSET); }
-			|	DESTROY SETS	{	$$ |= (1 << NFT_MSG_DELSET); }
 			|	RULE
 			{
-				$$ |= (1 << NFT_MSG_NEWRULE);	$$ |= (1 << NFT_MSG_DELRULE);
+				$$ = (1 << NFT_MSG_NEWRULE) |
+				     (1 << NFT_MSG_DELRULE);
+			}
+			|	STRING 	RULES
+			{
+				int event;
+
+				event = monitor_lookup_event($1);
+				if (event < 0) {
+					erec_queue(error(&@1, "unknown event type %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				switch (event) {
+				case NFT_EVENT_NEW:
+					$$ = (1 << NFT_MSG_NEWRULE);
+					break;
+				case NFT_EVENT_DEL:
+					$$ = (1 << NFT_MSG_DELRULE);
+					break;
+				}
 			}
-			|	NEW 	RULES	{	$$ |= (1 << NFT_MSG_NEWRULE); }
-			|	DESTROY RULES	{	$$ |= (1 << NFT_MSG_DELRULE); }
 			|	ELEMENTS
 			{
-				$$ |= (1 << NFT_MSG_NEWSETELEM);
-				$$ |= (1 << NFT_MSG_DELSETELEM);
+				$$ = (1 << NFT_MSG_NEWSETELEM) |
+				     (1 << NFT_MSG_DELSETELEM);
+			}
+			|	STRING	ELEMENTS
+			{
+				int event;
+
+				event = monitor_lookup_event($1);
+				if (event < 0) {
+					erec_queue(error(&@1, "unknown event type %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				switch (event) {
+				case NFT_EVENT_NEW:
+					$$ = (1 << NFT_MSG_NEWSETELEM);
+					break;
+				case NFT_EVENT_DEL:
+					$$ = (1 << NFT_MSG_DELSETELEM);
+					break;
+				}
 			}
-			|	NEW	ELEMENTS	{	$$ |= (1 << NFT_MSG_NEWSETELEM); }
-			|	DESTROY ELEMENTS	{	$$ |= (1 << NFT_MSG_DELSETELEM); }
 			;
 
 output_format		:	/* empty */
diff --git a/src/scanner.l b/src/scanner.l
index 801c030..86bc519 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -240,8 +240,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
 "handle"		{ return HANDLE; }
-"new"			{ return NEW; }
-"destroy"		{ return DESTROY; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
-- 
1.7.10.4

