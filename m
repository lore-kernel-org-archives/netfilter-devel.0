From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] meta: don't require "meta" keyword for a subset of meta expressions
Date: Wed, 15 Jan 2014 11:16:25 +0000
Message-ID: <1389784585-17603-3-git-send-email-kaber@trash.net>
References: <1389784585-17603-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43728 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaAOLQd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:16:33 -0500
In-Reply-To: <1389784585-17603-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't require the meta keyword for mark, iif, oif, iifname, oifname,
skuid, skgid, nftrace, rtclassid and secmark.

The protocol and length types still need the meta keyword to avoid
grammar conflicts.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/meta.c   | 13 ++++++++++++-
 src/parser.y | 20 +++++++++++++++++---
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 6d42525..098728b 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -335,7 +335,18 @@ static const struct meta_template meta_templates[] = {
 
 static void meta_expr_print(const struct expr *expr)
 {
-	printf("meta %s", meta_templates[expr->meta.key].token);
+	switch (expr->meta.key) {
+	case NFT_META_LEN:
+	case NFT_META_NFPROTO:
+	case NFT_META_L4PROTO:
+	case NFT_META_PROTOCOL:
+	case NFT_META_PRIORITY:
+		printf("meta %s", meta_templates[expr->meta.key].token);
+		break;
+	default:
+		printf("%s", meta_templates[expr->meta.key].token);
+		break;
+	}
 }
 
 static void meta_expr_clone(struct expr *new, const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 2e5f6c1..632970b 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -463,7 +463,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			meta_expr
 %destructor { expr_free($$); }	meta_expr
-%type <val>			meta_key
+%type <val>			meta_key	meta_key_qualified	meta_key_unqualified
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
@@ -1374,14 +1374,24 @@ meta_expr		:	META	meta_key
 			{
 				$$ = meta_expr_alloc(&@$, $2);
 			}
+			|	meta_key_unqualified
+			{
+				$$ = meta_expr_alloc(&@$, $1);
+			}
+			;
+
+meta_key		:	meta_key_qualified
+			|	meta_key_unqualified
 			;
 
-meta_key		:	LENGTH		{ $$ = NFT_META_LEN; }
+meta_key_qualified	:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	NFPROTO		{ $$ = NFT_META_NFPROTO; }
 			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
-			|	MARK		{ $$ = NFT_META_MARK; }
+			;
+
+meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|	IIF		{ $$ = NFT_META_IIF; }
 			|	IIFNAME		{ $$ = NFT_META_IIFNAME; }
 			|	IIFTYPE		{ $$ = NFT_META_IIFTYPE; }
@@ -1398,6 +1408,10 @@ meta_stmt		:	META	meta_key	SET	expr
 			{
 				$$ = meta_stmt_alloc(&@$, $2, $4);
 			}
+			|	meta_key_unqualified	SET	expr
+			{
+				$$ = meta_stmt_alloc(&@$, $1, $3);
+			}
 			;
 
 ct_expr			:	CT	ct_key
-- 
1.8.4.2

