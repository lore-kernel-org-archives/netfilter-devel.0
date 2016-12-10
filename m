From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3] datatype: Display pre-defined inet_service values in
 host byte order
Date: Fri, 9 Dec 2016 22:35:13 -0200
Message-ID: <20161210003513.GA30388@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33195 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbcLJAfV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 19:35:21 -0500
Received: by mail-vk0-f65.google.com with SMTP id l126so1718327vkh.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Dec 2016 16:35:20 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft describe displays, to the user, which values are available for a selector,
then the values should be in host byte order.

Variable size was replaced by len to better match the common pattern.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: ccc5da470e76 ("datatype: Replace getnameinfo() by internal lookup table")
Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: Used a function to convert different types and number of bytes
 v3: Created a function on src/gmputil.c to switch byteorder of numbers

 include/datatype.h |  3 ++-
 include/gmputil.h  |  2 ++
 src/datatype.c     | 16 ++++++++++++----
 src/expression.c   |  3 ++-
 src/gmputil.c      | 10 ++++++++++
 5 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index d4fe817..a7db1df 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -191,7 +191,8 @@ extern struct error_record *symbolic_constant_parse(const struct expr *sym,
 extern void symbolic_constant_print(const struct symbol_table *tbl,
 				    const struct expr *expr, bool quotes);
 extern void symbol_table_print(const struct symbol_table *tbl,
-			       const struct datatype *dtype);
+			       const struct datatype *dtype,
+			       enum byteorder byteorder);
 
 extern struct symbol_table *rt_symbol_table_init(const char *filename);
 extern void rt_symbol_table_free(struct symbol_table *tbl);
diff --git a/include/gmputil.h b/include/gmputil.h
index 1bf696a..dc6f89e 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -58,4 +58,6 @@ extern void mpz_import_data(mpz_t rop, const void *data,
 			    unsigned int len);
 extern void mpz_switch_byteorder(mpz_t rop, unsigned int len);
 
+extern void switch_byteorder(void *data, unsigned int len);
+
 #endif /* NFTABLES_GMPUTIL_H */
diff --git a/src/datatype.c b/src/datatype.c
index b5d73bc..16af9bf 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -181,14 +181,22 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 }
 
 void symbol_table_print(const struct symbol_table *tbl,
-			const struct datatype *dtype)
+			const struct datatype *dtype,
+			enum byteorder byteorder)
 {
 	const struct symbolic_constant *s;
-	unsigned int size = 2 * dtype->size / BITS_PER_BYTE;
+	unsigned int len = dtype->size / BITS_PER_BYTE;
+	uint64_t value;
+
+	for (s = tbl->symbols; s->identifier != NULL; s++) {
+		value = s->value;
+
+		if (byteorder == BYTEORDER_BIG_ENDIAN)
+			switch_byteorder(&value, len);
 
-	for (s = tbl->symbols; s->identifier != NULL; s++)
 		printf("\t%-30s\t0x%.*" PRIx64 "\n",
-		       s->identifier, size, s->value);
+		       s->identifier, 2 * len, value);
+	}
 }
 
 static void invalid_type_print(const struct expr *expr)
diff --git a/src/expression.c b/src/expression.c
index a10af5d..2aada77 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -115,7 +115,8 @@ void expr_describe(const struct expr *expr)
 
 	if (expr->dtype->sym_tbl != NULL) {
 		printf("\npre-defined symbolic constants:\n");
-		symbol_table_print(expr->dtype->sym_tbl, expr->dtype);
+		symbol_table_print(expr->dtype->sym_tbl, expr->dtype,
+				   expr->byteorder);
 	}
 }
 
diff --git a/src/gmputil.c b/src/gmputil.c
index c763792..b266c06 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -146,6 +146,16 @@ void mpz_switch_byteorder(mpz_t rop, unsigned int len)
 	mpz_import_data(rop, data, BYTEORDER_HOST_ENDIAN, len);
 }
 
+void switch_byteorder(void *data, unsigned int len)
+{
+	mpz_t op;
+
+	mpz_init(op);
+	mpz_import_data(op, data, BYTEORDER_BIG_ENDIAN, len);
+	mpz_export_data(data, op, BYTEORDER_HOST_ENDIAN, len);
+	mpz_clear(op);
+}
+
 #ifndef HAVE_LIBGMP
 /* mini-gmp doesn't have a gmp_printf so we use our own minimal
  * variant here which is able to format a single mpz_t.
-- 
2.7.4

