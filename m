From: Patrick McHardy <kaber@trash.net>
Subject: RFC: removing meta keyword
Date: Wed, 15 Jan 2014 06:46:02 +0000
Message-ID: <20140115064602.GA12074@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41325 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaAOGqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:46:12 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

One thing I wanted to discuss before the next nftables release is removal
of the meta keyword for some cases. It is only required by the grammar for
the length key to avoid a conflict with the UDP length keyword.

It seems more natural to express

filter output meta iifname eth0

as

filter output iifname eth0

To avoid potential new conflicts in the future with header fields, I'd
propose to not require it only for a subset of keys, specifically
mark, iif, oif, iifname, oifname, skuid, skgid, nftrace, secmark and
rtclassid.

nfproto and l4proto could be added but are mainly intended for internal
use, protocol and priority have to much risk of conflicts.

The same thing could also be done with a couple of ct expression keys.

The attached patch demonstrates the change to the grammar, the printing
functions would of course also need adjustment.

Any opinions?


diff --git a/src/parser.y b/src/parser.y
index 7c18875..ff4968b 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -464,7 +464,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			meta_expr
 %destructor { expr_free($$); }	meta_expr
-%type <val>			meta_key
+%type <val>			meta_key	meta_key1	meta_key2
 
 %type <expr>			ct_expr
 %destructor { expr_free($$); }	ct_expr
@@ -1375,14 +1375,24 @@ meta_expr		:	META	meta_key
 			{
 				$$ = meta_expr_alloc(&@$, $2);
 			}
+			|	meta_key2
+			{
+				$$ = meta_expr_alloc(&@$, $1);
+			}
+			;
+
+meta_key		:	meta_key1
+			|	meta_key2
 			;
 
-meta_key		:	LENGTH		{ $$ = NFT_META_LEN; }
+meta_key1		:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	NFPROTO		{ $$ = NFT_META_NFPROTO; }
 			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
-			|	MARK		{ $$ = NFT_META_MARK; }
+			;
+
+meta_key2		:	MARK		{ $$ = NFT_META_MARK; }
 			|	IIF		{ $$ = NFT_META_IIF; }
 			|	IIFNAME		{ $$ = NFT_META_IIFNAME; }
 			|	IIFTYPE		{ $$ = NFT_META_IIFTYPE; }
@@ -1400,6 +1410,10 @@ meta_stmt		:	META	meta_key	SET	expr
 			{
 				$$ = meta_stmt_alloc(&@$, $2, $4);
 			}
+			|	meta_key2	SET	expr
+			{
+				$$ = meta_stmt_alloc(&@$, $1, $3);
+			}
 			;
 
 ct_expr			:	CT	ct_key
