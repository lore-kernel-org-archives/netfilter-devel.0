From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nftables] make set initializer parsable
Date: Thu, 16 Jan 2014 19:39:52 +0000
Message-ID: <20140116193951.GA19036@macbook.localnet>
References: <20140116192249.GA18252@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAPTj4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:39:56 -0500
Content-Disposition: inline
In-Reply-To: <20140116192249.GA18252@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 92dfa9b19853c367efbb083d5ad1b7cb56ce3d8a
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jan 16 19:37:53 2014 +0000

    set: make set initializer parsable
    
    If a set contains elements, the output is not parsable since the
    elements = { ... } is not understood by the parser. Fix this and
    also add support for creating constant sets (which only makes sense
    when using an initializer).
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/src/parser.y b/src/parser.y
index eab973c..34d14ec 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -183,7 +183,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RETURN			"return"
 %token QUEUE			"queue"
 
+%token CONSTANT			"constant"
 %token INTERVAL			"interval"
+%token ELEMENTS			"elements"
 
 %token <val> NUM		"number"
 %token <string> STRING		"string"
@@ -747,6 +749,11 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags = $3;
 				$$ = $1;
 			}
+			|	set_block	ELEMENTS	'='		set_expr
+			{
+				$1->init = $4;
+				$$ = $1;
+			}
 			;
 
 set_flag_list		:	set_flag_list	COMMA		set_flag
@@ -756,7 +763,8 @@ set_flag_list		:	set_flag_list	COMMA		set_flag
 			|	set_flag
 			;
 
-set_flag		:	INTERVAL	{ $$ = SET_F_INTERVAL; }
+set_flag		:	CONSTANT	{ $$ = SET_F_CONSTANT; }
+			|	INTERVAL	{ $$ = SET_F_INTERVAL; }
 			;
 
 map_block_alloc		:	/* empty */
@@ -794,6 +802,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags = $3;
 				$$ = $1;
 			}
+			|	map_block	ELEMENTS	'='		set_expr
+			{
+				$1->init = $4;
+				$$ = $1;
+			}
 			;
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
diff --git a/src/rule.c b/src/rule.c
index f1fe355..acdddcb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -100,8 +100,12 @@ void set_print(const struct set *set)
 		printf(" => %s", set->datatype->name);
 	printf("\n");
 
-	if (set->flags & (SET_F_INTERVAL)) {
+	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
 		printf("\t\tflags ");
+		if (set->flags & SET_F_CONSTANT) {
+			printf("%sconstant", delim);
+			delim = ",";
+		}
 		if (set->flags & SET_F_INTERVAL) {
 			printf("%sinterval", delim);
 			delim = ",";
diff --git a/src/scanner.l b/src/scanner.l
index f22fbe8..721b551 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -257,7 +257,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "position"		{ return POSITION; }
 
+"constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
+"elements"		{ return ELEMENTS; }
 
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
