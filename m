From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] erec: Make __stmt_binary_error a little more versatile
Date: Thu, 27 Apr 2017 15:24:38 +0200
Message-ID: <20170427132439.9443-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:55873 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162129AbdD0NY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Apr 2017 09:24:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to allow for printing (at least) also warnings, rename
__stmt_binary_error to __stmt_binary_msg and pass the severity as first
parameter. Then create __stmt_binary_error macro to reestablish the old
signature.

Finally, add similar macros for printing warnings. And since these are
supposed to be non-fatal, make __stmt_binary_msg return 0 if a severity
below EREC_ERROR was given. This allows to still use it in return
statements.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/erec.h | 16 ++++++++++++----
 src/erec.c     | 13 +++++++------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 36e0efa4fc1d9..0babfc0ff488c 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -63,11 +63,19 @@ extern void erec_print_list(FILE *f, struct list_head *list);
 
 struct eval_ctx;
 
-extern int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
-						 const struct location *l1,
-						 const struct location *l2,
-						 const char *fmt, ...);
+extern int __fmtstring(5, 6) __stmt_binary_msg(enum error_record_types type,
+					       struct eval_ctx *ctx,
+					       const struct location *l1,
+					       const struct location *l2,
+					       const char *fmt, ...);
 
+#define __stmt_binary_warning(ctx, l1, l2, fmt, args...) \
+	__stmt_binary_msg(EREC_WARNING, ctx, l1, l2, fmt, ## args)
+#define stmt_warning(ctx, s1, fmt, args...) \
+	__stmt_binary_warning(ctx, &(s1)->location, NULL, fmt, ## args)
+
+#define __stmt_binary_error(ctx, l1, l2, fmt, args...) \
+	__stmt_binary_msg(EREC_ERROR, ctx, l1, l2, fmt, ## args)
 #define stmt_error(ctx, s1, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define stmt_binary_error(ctx, s1, s2, fmt, args...) \
diff --git a/src/erec.c b/src/erec.c
index eacdd97a21cbc..7b9c2420d416c 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -208,19 +208,20 @@ void erec_print_list(FILE *f, struct list_head *list)
 	}
 }
 
-int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
-					  const struct location *l1,
-					  const struct location *l2,
-					  const char *fmt, ...)
+int __fmtstring(5, 6) __stmt_binary_msg(enum error_record_types type,
+					struct eval_ctx *ctx,
+					const struct location *l1,
+					const struct location *l2,
+					const char *fmt, ...)
 {
 	struct error_record *erec;
 	va_list ap;
 
 	va_start(ap, fmt);
-	erec = erec_vcreate(EREC_ERROR, l1, fmt, ap);
+	erec = erec_vcreate(type, l1, fmt, ap);
 	if (l2 != NULL)
 		erec_add_location(erec, l2);
 	va_end(ap);
 	erec_queue(erec, ctx->msgs);
-	return -1;
+	return type >= EREC_ERROR ? -1 : 0;
 }
-- 
2.11.0

