From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] expr: remove secmark from ct and meta expression
Date: Wed, 15 Jan 2014 11:16:24 +0000
Message-ID: <1389784585-17603-2-git-send-email-kaber@trash.net>
References: <1389784585-17603-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43723 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaAOLQg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:16:36 -0500
In-Reply-To: <1389784585-17603-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The secctx should be used instead of the secmark. Remove for now.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/ct.c      | 3 ---
 src/meta.c    | 2 --
 src/parser.y  | 3 ---
 src/scanner.l | 1 -
 4 files changed, 9 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index b8f7632..f893df9 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -104,9 +104,6 @@ static const struct ct_template ct_templates[] = {
 	[NFT_CT_MARK]		= CT_TEMPLATE("mark",	    &mark_type,
 					      BYTEORDER_HOST_ENDIAN,
 					      4 * BITS_PER_BYTE),
-	[NFT_CT_SECMARK]	= CT_TEMPLATE("secmark",    &integer_type,
-					      BYTEORDER_HOST_ENDIAN,
-					      4 * BITS_PER_BYTE),
 	[NFT_CT_EXPIRATION]	= CT_TEMPLATE("expiration", &time_type,
 					      BYTEORDER_HOST_ENDIAN,
 					      4 * BITS_PER_BYTE),
diff --git a/src/meta.c b/src/meta.c
index d7b024b..6d42525 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -331,8 +331,6 @@ static const struct meta_template meta_templates[] = {
 						1    , BYTEORDER_HOST_ENDIAN),
 	[NFT_META_RTCLASSID]	= META_TEMPLATE("rtclassid", &realm_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
-	[NFT_META_SECMARK]	= META_TEMPLATE("secmark",   &integer_type,
-						4 * 8, BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 7c18875..2e5f6c1 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -294,7 +294,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token SKGID			"skgid"
 %token NFTRACE			"nftrace"
 %token RTCLASSID		"rtclassid"
-%token SECMARK			"secmark"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1393,7 +1392,6 @@ meta_key		:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	SKGID		{ $$ = NFT_META_SKGID; }
 			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
-			|	SECMARK		{ $$ = NFT_META_SECMARK; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
@@ -1412,7 +1410,6 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	DIRECTION	{ $$ = NFT_CT_DIRECTION; }
 			|	STATUS		{ $$ = NFT_CT_STATUS; }
 			|	MARK		{ $$ = NFT_CT_MARK; }
-			|	SECMARK		{ $$ = NFT_CT_SECMARK; }
 			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
 			|	HELPER		{ $$ = NFT_CT_HELPER; }
 			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
diff --git a/src/scanner.l b/src/scanner.l
index 0b8abac..e813140 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -384,7 +384,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "skgid"			{ return SKGID; }
 "nftrace"		{ return NFTRACE; }
 "rtclassid"		{ return RTCLASSID; }
-"secmark"		{ return SECMARK; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
1.8.4.2

