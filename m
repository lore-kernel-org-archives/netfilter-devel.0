From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] segtree: only use prefix expressions for ranges for selected datatypes
Date: Thu, 16 Jan 2014 16:21:51 +0000
Message-ID: <1389889312-4055-2-git-send-email-kaber@trash.net>
References: <1389889312-4055-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57339 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAPQV6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:21:58 -0500
In-Reply-To: <1389889312-4055-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is uncommon to represent f.i. port number ranges as prefix expressions.

Introduce a datatype DTYPE_F_PREFIX flag to indicate that the preferred
representation of a range is a prefix and use it for segtree decomposition
to decide whether to use a range or prefix expression.

The ipaddr, ip6addr, mark and realm datatypes are changed to include the
DTYPE_F_PREFIX flag.

This fixes completely unreadable output in cases where the ranges are
representable as prefixes, f.i. in case of port number:

{ 0/6 => jump chain1, 0/5 => jump chain2, 0/4 => continue}

becomes:

{ 0-1023 => jump chain1, 1024-2047 => jump chain2, 2048-4095 => continue}

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h | 7 +++++++
 src/datatype.c     | 3 +++
 src/meta.c         | 1 +
 src/segtree.c      | 4 +++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/datatype.h b/include/datatype.h
index 9f8b44a..9e609cf 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -85,8 +85,15 @@ enum byteorder {
 
 struct expr;
 
+/**
+ * enum datatype_flags
+ *
+ * @DTYPE_F_ALLOC:		datatype is dynamically allocated
+ * @DTYPE_F_PREFIX:		preferred representation for ranges is a prefix
+ */
 enum datatype_flags {
 	DTYPE_F_ALLOC		= (1 << 0),
+	DTYPE_F_PREFIX		= (1 << 1),
 };
 
 /**
diff --git a/src/datatype.c b/src/datatype.c
index e228f53..5e4aacd 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -398,6 +398,7 @@ const struct datatype ipaddr_type = {
 	.basetype	= &integer_type,
 	.print		= ipaddr_type_print,
 	.parse		= ipaddr_type_parse,
+	.flags		= DTYPE_F_PREFIX,
 };
 
 static void ip6addr_type_print(const struct expr *expr)
@@ -455,6 +456,7 @@ const struct datatype ip6addr_type = {
 	.basetype	= &integer_type,
 	.print		= ip6addr_type_print,
 	.parse		= ip6addr_type_parse,
+	.flags		= DTYPE_F_PREFIX,
 };
 
 static void inet_protocol_type_print(const struct expr *expr)
@@ -680,6 +682,7 @@ const struct datatype mark_type = {
 	.basefmt	= "0x%.8Zx",
 	.print		= mark_type_print,
 	.parse		= mark_type_parse,
+	.flags		= DTYPE_F_PREFIX,
 };
 
 static void time_type_print(const struct expr *expr)
diff --git a/src/meta.c b/src/meta.c
index 098728b..0a3df39 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -61,6 +61,7 @@ static const struct datatype realm_type = {
 	.basetype	= &integer_type,
 	.print		= realm_type_print,
 	.parse		= realm_type_parse,
+	.flags		= DTYPE_F_PREFIX,
 };
 
 static void tchandle_type_print(const struct expr *expr)
diff --git a/src/segtree.c b/src/segtree.c
index 5426e24..e3bca4c 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -552,7 +552,9 @@ void interval_map_decompose(struct expr *set)
 
 		if (!mpz_cmp_ui(range, 0))
 			compound_expr_add(set, low);
-		else if (!range_is_prefix(range) || mpz_cmp_ui(p, 0)) {
+		else if ((!range_is_prefix(range) ||
+			  !(i->dtype->flags & DTYPE_F_PREFIX)) ||
+			 mpz_cmp_ui(p, 0)) {
 			struct expr *tmp;
 
 			tmp = constant_expr_alloc(&low->location, low->dtype,
-- 
1.8.4.2

