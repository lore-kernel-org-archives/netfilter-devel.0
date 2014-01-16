From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] set: make set flags output parsable
Date: Thu, 16 Jan 2014 20:16:25 +0000
Message-ID: <1389903386-20612-2-git-send-email-kaber@trash.net>
References: <1389903386-20612-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58919 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaAPUQh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:16:37 -0500
In-Reply-To: <1389903386-20612-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes two problems:

- the output of "nft list table ..." is not parsable if sets are included
  because the parser can't parse the flags.

- set flags can't be specified during set creation.

To fix this, the set output is changed to:

- not print each flag on a single line
- prefix the flags with "flags "
- only show the interval flag since all others are for internal use only

The parser is changed to parse the flags specified in a set declaration.
This allows to parse empty sets. The following patch will take care of
parsing sets that are already populated.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser.y  | 24 ++++++++++++++++++++++++
 src/rule.c    | 15 +++++++++------
 src/scanner.l |  2 ++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/src/parser.y b/src/parser.y
index 5cd8ef6..1b09e61 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -182,6 +182,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RETURN			"return"
 %token QUEUE			"queue"
 
+%token INTERVAL			"interval"
+
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
@@ -353,6 +355,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <rule>			rule
 %destructor { rule_free($$); }	rule
 
+%type <val>			set_flag_list	set_flag
+
 %type <set>			set_block_alloc set_block
 %destructor { set_free($$); }	set_block_alloc
 
@@ -737,6 +741,21 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				}
 				$$ = $1;
 			}
+			|	set_block	FLAGS		set_flag_list	stmt_seperator
+			{
+				$1->flags = $3;
+				$$ = $1;
+			}
+			;
+
+set_flag_list		:	set_flag_list	COMMA		set_flag
+			{
+				$$ = $1 | $3;
+			}
+			|	set_flag
+			;
+
+set_flag		:	INTERVAL	{ $$ = SET_F_INTERVAL; }
 			;
 
 map_block_alloc		:	/* empty */
@@ -769,6 +788,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 
 				$$ = $1;
 			}
+			|	map_block	FLAGS		set_flag_list	stmt_seperator
+			{
+				$1->flags = $3;
+				$$ = $1;
+			}
 			;
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
diff --git a/src/rule.c b/src/rule.c
index 04dd6c7..0f7f4b5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -89,6 +89,7 @@ struct set *set_lookup(const struct table *table, const char *name)
 
 void set_print(const struct set *set)
 {
+	const char *delim = "";
 	const char *type;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
@@ -99,12 +100,14 @@ void set_print(const struct set *set)
 		printf(" : %s", set->datatype->name);
 	printf("\n");
 
-	if (set->flags & SET_F_ANONYMOUS)
-		printf("\t\tanonymous\n");
-	if (set->flags & SET_F_CONSTANT)
-		printf("\t\tconstant\n");
-	if (set->flags & SET_F_INTERVAL)
-		printf("\t\tinterval\n");
+	if (set->flags & (SET_F_INTERVAL)) {
+		printf("\t\tflags ");
+		if (set->flags & SET_F_INTERVAL) {
+			printf("%sinterval", delim);
+			delim = ",";
+		}
+		printf("\n");
+	}
 
 	if (set->init != NULL && set->init->size > 0) {
 		printf("\t\telements = ");
diff --git a/src/scanner.l b/src/scanner.l
index 25fbc61..904d6fb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -256,6 +256,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "position"		{ return POSITION; }
 
+"interval"		{ return INTERVAL; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
-- 
1.8.4.2

