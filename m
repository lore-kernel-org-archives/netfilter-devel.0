From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nftables] make set flags output parsable
Date: Thu, 16 Jan 2014 19:22:50 +0000
Message-ID: <20140116192249.GA18252@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58571 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaAPTW6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:22:58 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes two problems:

- the output of "nft list table ..." is not parsable if sets are included
  because the parser can't parse the flags

- set flags can't be specified during set creation

The set output is changed to:

- not print each flag on a single line
- prefix the flags with "flags "
- only show the interval flag since all others are for internal use only

The parser is changed to parse the flags specified in a set dclaration.

As usual, if no objections I'll push it to master.

diff --git a/src/parser.y b/src/parser.y
index d4a7929..bc89887 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -183,6 +183,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RETURN			"return"
 %token QUEUE			"queue"
 
+%token INTERVAL			"interval"
+
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
@@ -354,6 +356,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <rule>			rule
 %destructor { rule_free($$); }	rule
 
+%type <val>			set_flag_list	set_flag
+
 %type <set>			set_block_alloc set_block
 %destructor { set_free($$); }	set_block_alloc
 
@@ -738,6 +742,21 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
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
diff --git a/src/rule.c b/src/rule.c
index ec8b6a4..0719c8d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -89,6 +89,7 @@ struct set *set_lookup(const struct table *table, const char *name)
 
 void set_print(const struct set *set)
 {
+	const char *delim = "";
 	const char *type;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
@@ -99,12 +100,14 @@ void set_print(const struct set *set)
 		printf(" => %s", set->datatype->name);
 	printf("\n");
 
-	if (set->flags & SET_F_ANONYMOUS)
-		printf("\t\tanonymous\n");
-	if (set->flags & SET_F_CONSTANT)
-		printf("\t\tconstant\n");
-	if (set->flags & SET_F_INTERVAL)
-		printf("\t\tinterval\n");
+	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
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
index 936c035..f22fbe8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -257,6 +257,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "position"		{ return POSITION; }
 
+"interval"		{ return INTERVAL; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
