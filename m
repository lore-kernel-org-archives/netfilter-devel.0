From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] set: make set initializer parsable
Date: Thu, 16 Jan 2014 20:16:26 +0000
Message-ID: <1389903386-20612-3-git-send-email-kaber@trash.net>
References: <1389903386-20612-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58921 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaAPUQm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:16:42 -0500
In-Reply-To: <1389903386-20612-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a set contains elements, the output is not parsable since the
elements = { ... } is not understood by the parser. Fix this and
also add support for creating constant sets (which only makes sense
when using an initializer).

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/evaluate.c |  6 ++++++
 src/parser.y   | 15 ++++++++++++++-
 src/rule.c     |  6 +++++-
 src/scanner.l  |  2 ++
 4 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 94fee64..21ca558 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1210,6 +1210,12 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return set_error(ctx, set, "unqualified key data type "
 				 "specified in %s definition", type);
 
+	if (set->init != NULL) {
+		expr_set_context(&ctx->ectx, set->keytype, set->keylen);
+		if (expr_evaluate(ctx, &set->init) < 0)
+			return -1;
+	}
+
 	if (!(set->flags & SET_F_MAP))
 		return 0;
 
diff --git a/src/parser.y b/src/parser.y
index 1b09e61..345d8d0 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -182,7 +182,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token RETURN			"return"
 %token QUEUE			"queue"
 
+%token CONSTANT			"constant"
 %token INTERVAL			"interval"
+%token ELEMENTS			"elements"
 
 %token <val> NUM		"number"
 %token <string> STRING		"string"
@@ -746,6 +748,11 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
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
@@ -755,7 +762,8 @@ set_flag_list		:	set_flag_list	COMMA		set_flag
 			|	set_flag
 			;
 
-set_flag		:	INTERVAL	{ $$ = SET_F_INTERVAL; }
+set_flag		:	CONSTANT	{ $$ = SET_F_CONSTANT; }
+			|	INTERVAL	{ $$ = SET_F_INTERVAL; }
 			;
 
 map_block_alloc		:	/* empty */
@@ -793,6 +801,11 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
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
index 0f7f4b5..9f6c04b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -100,8 +100,12 @@ void set_print(const struct set *set)
 		printf(" : %s", set->datatype->name);
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
index 904d6fb..c47e610 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -256,7 +256,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "position"		{ return POSITION; }
 
+"constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
+"elements"		{ return ELEMENTS; }
 
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
-- 
1.8.4.2

