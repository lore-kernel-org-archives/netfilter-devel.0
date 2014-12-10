From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] dtype: remove unnecessary icmp* parse/print functions
Date: Wed, 10 Dec 2014 22:14:36 +0000
Message-ID: <1418249676-22300-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47586 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaLJWO4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:14:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just setting the .sym_tbl correctly is all we need.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 42 +++---------------------------------------
 1 file changed, 3 insertions(+), 39 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 729e63b..db3fb06 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -709,17 +709,6 @@ static const struct symbol_table icmp_code_tbl = {
 	},
 };
 
-static void icmp_code_type_print(const struct expr *expr)
-{
-	return symbolic_constant_print(&icmp_code_tbl, expr);
-}
-
-static struct error_record *icmp_code_type_parse(const struct expr *sym,
-						 struct expr **res)
-{
-	return symbolic_constant_parse(sym, &icmp_code_tbl, res);
-}
-
 const struct datatype icmp_code_type = {
 	.type		= TYPE_ICMP_CODE,
 	.name		= "icmp_code",
@@ -727,8 +716,7 @@ const struct datatype icmp_code_type = {
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
-	.print		= icmp_code_type_print,
-	.parse		= icmp_code_type_parse,
+	.sym_tbl	= &icmp_code_tbl,
 };
 
 static const struct symbol_table icmpv6_code_tbl = {
@@ -741,17 +729,6 @@ static const struct symbol_table icmpv6_code_tbl = {
 	},
 };
 
-static void icmpv6_code_type_print(const struct expr *expr)
-{
-	return symbolic_constant_print(&icmpv6_code_tbl, expr);
-}
-
-static struct error_record *icmpv6_code_type_parse(const struct expr *sym,
-						   struct expr **res)
-{
-	return symbolic_constant_parse(sym, &icmpv6_code_tbl, res);
-}
-
 const struct datatype icmpv6_code_type = {
 	.type		= TYPE_ICMPV6_CODE,
 	.name		= "icmpv6_code",
@@ -759,8 +736,7 @@ const struct datatype icmpv6_code_type = {
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
-	.print		= icmpv6_code_type_print,
-	.parse		= icmpv6_code_type_parse,
+	.sym_tbl	= &icmpv6_code_tbl,
 };
 
 static const struct symbol_table icmpx_code_tbl = {
@@ -773,17 +749,6 @@ static const struct symbol_table icmpx_code_tbl = {
 	},
 };
 
-static void icmpx_code_type_print(const struct expr *expr)
-{
-	return symbolic_constant_print(&icmpx_code_tbl, expr);
-}
-
-static struct error_record *icmpx_code_type_parse(const struct expr *sym,
-						  struct expr **res)
-{
-	return symbolic_constant_parse(sym, &icmpx_code_tbl, res);
-}
-
 const struct datatype icmpx_code_type = {
 	.type		= TYPE_ICMPX_CODE,
 	.name		= "icmpx_code",
@@ -791,8 +756,7 @@ const struct datatype icmpx_code_type = {
 	.size		= BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
-	.print		= icmpx_code_type_print,
-	.parse		= icmpx_code_type_parse,
+	.sym_tbl	= &icmpx_code_tbl,
 };
 
 static void time_type_print(const struct expr *expr)
-- 
2.1.0

