From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft] parser: add typeof keyword for declarations
Date: Fri, 27 Nov 2015 14:50:52 +0000
Message-ID: <1448635852-2814-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47335 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbbK0Ou4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 09:50:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a typeof keyword to automatically use the correct type in set and map
declarations.

table filter {
	set blacklist {
		typeof ip saddr
	}

	chain input {
		ip saddr @blacklist counter drop
	}
}

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/parser_bison.y | 17 +++++++++++++++++
 src/scanner.l      |  1 +
 2 files changed, 18 insertions(+)

Just a small hack since as a distraction from the tracing stuff. So far it
only supports primary types, but its still easier than remembering or looking
up the exact type names.

Please not that it is just a parser feature. The output will still use
the type keyword and the actual data type:

table ip filter {
	set blacklist { 
		type ipv4_addr
	}
	...

Any comments?

diff --git a/src/parser_bison.y b/src/parser_bison.y
index fbfe7ea..cd97424 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -163,6 +163,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token INCLUDE			"include"
 %token DEFINE			"define"
+%token TYPEOF			"typeof"
 
 %token HOOK			"hook"
 %token DEVICE			"device"
@@ -968,6 +969,12 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->keytype = $3;
 				$$ = $1;
 			}
+			|	set_block	TYPEOF		primary_expr	stmt_seperator
+			{
+				$1->keytype = $3->dtype;
+				expr_free($3);
+				$$ = $1;
+			}
 			|	set_block	FLAGS		set_flag_list	stmt_seperator
 			{
 				$1->flags = $3;
@@ -1021,6 +1028,16 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->datatype = $5;
 				$$ = $1;
 			}
+			|	map_block	TYPEOF
+						primary_expr	COLON	primary_expr
+						stmt_seperator
+			{
+				$1->keytype  = $3->dtype;
+				$1->datatype = $5->dtype;
+				expr_free($3);
+				expr_free($5);
+				$$ = $1;
+			}
 			|	map_block	FLAGS		set_flag_list	stmt_seperator
 			{
 				$1->flags = $3;
diff --git a/src/scanner.l b/src/scanner.l
index a98e7b6..e19b13b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -230,6 +230,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "include"		{ return INCLUDE; }
 "define"		{ return DEFINE; }
+"typeof"		{ return TYPEOF; }
 
 "describe"		{ return DESCRIBE; }
 
-- 
2.5.0

