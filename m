From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] expression: fix constant expression allocation on big endian
Date: Sat, 12 Apr 2014 11:09:58 +0200
Message-ID: <1397293799-2600-2-git-send-email-kaber@trash.net>
References: <1397293799-2600-1-git-send-email-kaber@trash.net>
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41748 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaDLJKD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:10:03 -0400
In-Reply-To: <1397293799-2600-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

When allocating a constant expression, a pointer to the data is passed
to the allocation function. When the variable used to store the data
is larger than the size of the data type, this fails on big endian since
the most significant bytes (being zero) come first.

Add a helper function to calculate the proper address for the cases
where this is needed.

This currently affects symbolic tables for values < u64 and payload
dependency generation for protocol values < u32.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/utils.h | 14 ++++++++++++++
 src/datatype.c  |  2 +-
 src/payload.c   |  3 ++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 88ee0c9..cc5948c 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -1,6 +1,7 @@
 #ifndef NFTABLES_UTILS_H
 #define NFTABLES_UTILS_H
 
+#include <asm/byteorder.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <stdarg.h>
@@ -46,6 +47,19 @@
 	typeof( ((type *)0)->member ) *__mptr = (ptr);		\
 	(type *)( (void *)__mptr - offsetof(type,member) );})
 
+/**
+ * Return a pointer to a constant variable of a size smaller than the variable.
+ */
+#ifdef __LITTLE_ENDIAN_BITFIELD
+#define constant_data_ptr(val, len) \
+	((void *)&(val))
+#elif defined(__BIG_ENDIAN_BITFIELD)
+#define constant_data_ptr(val, len) \
+	((void *)&(val) + sizeof(val) - (len) / BITS_PER_BYTE)
+#else
+#error "byteorder undefined"
+#endif
+
 #define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))
diff --git a/src/datatype.c b/src/datatype.c
index ac42faa..331f235 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -124,7 +124,7 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 
 	*res = constant_expr_alloc(&sym->location, dtype,
 				   dtype->byteorder, dtype->size,
-				   &s->value);
+				   constant_data_ptr(s->value, dtype->size));
 	return NULL;
 }
 
diff --git a/src/payload.c b/src/payload.c
index 427080c..a1785a5 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -209,7 +209,8 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
 				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len, &protocol);
+				    tmpl->len,
+				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
 	left->ops->pctx_update(&ctx->pctx, dep);
-- 
1.9.0

