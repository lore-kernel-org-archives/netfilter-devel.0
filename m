From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: Remove unnecessary spaces
Date: Sun,  8 Oct 2017 15:55:51 +0530
Message-ID: <20171008102551.16175-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35059 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdJHK2E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Oct 2017 06:28:04 -0400
Received: by mail-pf0-f193.google.com with SMTP id i23so21358857pfi.2
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Oct 2017 03:28:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove spaces before tab and at the start of a line

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
There are other such files but I am breaking it down to make review 
easy.
 src/datatype.c | 4 ++--
 src/evaluate.c | 2 +-
 src/gmputil.c  | 4 ++--
 src/main.c     | 2 +-
 src/meta.c     | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 94b1224..efbba47 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -370,7 +370,7 @@ static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 }
 
 static struct error_record *string_type_parse(const struct expr *sym,
-	      				      struct expr **res)
+					      struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
 				   BYTEORDER_HOST_ENDIAN,
@@ -849,7 +849,7 @@ void time_print(uint64_t seconds, struct output_ctx *octx)
 enum {
 	DAY	= (1 << 0),
 	HOUR	= (1 << 1),
-	MIN 	= (1 << 2),
+	MIN	= (1 << 2),
 	SECS	= (1 << 3),
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 193ea1c..3ad2219 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -132,7 +132,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 		return 0;
 	if (expr_basetype(*expr)->type != TYPE_INTEGER)
 		return expr_error(ctx->msgs, *expr,
-			 	  "Byteorder mismatch: expected %s, got %s",
+				  "Byteorder mismatch: expected %s, got %s",
 				  byteorder_names[byteorder],
 				  byteorder_names[(*expr)->byteorder]);
 
diff --git a/src/gmputil.c b/src/gmputil.c
index 3cc4e61..a817bb8 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -50,11 +50,11 @@ void mpz_rshift_ui(mpz_t rop, unsigned int n)
 
 #define mpz_get_type(type, endian, op)					\
 ({									\
- 	type ret = 0;							\
+	type ret = 0;							\
 	size_t cnt;							\
 	mpz_export(&ret, &cnt, MPZ_LSWF, sizeof(ret), endian, 0, op);	\
 	assert(cnt <= 1);						\
- 	ret;								\
+	ret;								\
  })
 
 uint64_t mpz_get_uint64(const mpz_t op)
diff --git a/src/main.c b/src/main.c
index b59c932..406e3b0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -119,7 +119,7 @@ static void show_help(const char *name)
 "  -i, --interactive		Read input from interactive CLI\n"
 "\n"
 "  -n, --numeric			When specified once, show network addresses numerically (default behaviour).\n"
-"  				Specify twice to also show Internet services (port numbers) numerically.\n"
+"				Specify twice to also show Internet services (port numbers) numerically.\n"
 "				Specify three times to also show protocols, user IDs, and group IDs numerically.\n"
 "  -s, --stateless		Omit stateful information of ruleset.\n"
 "  -N				Translate IP addresses to names.\n"
diff --git a/src/meta.c b/src/meta.c
index 56b9e29..e387028 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -625,8 +625,8 @@ struct stmt *meta_stmt_meta_iiftype(const struct location *loc, uint16_t type)
 }
 
 struct error_record *meta_key_parse(const struct location *loc,
-                                    const char *str,
-                                    unsigned int *value)
+				    const char *str,
+				    unsigned int *value)
 {
 	int ret, len, offset = 0;
 	const char *sep = "";
-- 
2.11.0

