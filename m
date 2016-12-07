From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v2] datatype: Display pre-defined inet_service values in
 host byte order
Date: Wed, 7 Dec 2016 17:03:31 -0200
Message-ID: <20161207190331.GA7206@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:36544 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932940AbcLGTDi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2016 14:03:38 -0500
Received: by mail-ua0-f195.google.com with SMTP id 12so40092742uas.3
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Dec 2016 11:03:38 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft describe displays, to the user, which values are available for a selector,
then the values should be in host byte order.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: ccc5da470e76 ("datatype: Replace getnameinfo() by internal lookup table")
Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: Created a function to convert different types and number of bytes

 include/datatype.h |  3 ++-
 src/datatype.c     | 27 ++++++++++++++++++++++++---
 src/expression.c   |  3 ++-
 3 files changed, 28 insertions(+), 5 deletions(-)

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
diff --git a/src/datatype.c b/src/datatype.c
index b5d73bc..c884171 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -180,15 +180,36 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 		printf("%s", s->identifier);
 }
 
+static void big_to_host_byteorder(void *value, const unsigned int nbytes)
+{
+	unsigned char *p = value;
+	unsigned int i;
+
+	for (i = 0; i < nbytes / 2; i++) {
+		p[i] ^= p[nbytes - 1 - i];
+		p[nbytes - 1 - i] ^= p[i];
+		p[i] ^= p[nbytes - 1 - i];
+	}
+}
+
 void symbol_table_print(const struct symbol_table *tbl,
-			const struct datatype *dtype)
+			const struct datatype *dtype,
+			enum byteorder byteorder)
 {
 	const struct symbolic_constant *s;
 	unsigned int size = 2 * dtype->size / BITS_PER_BYTE;
+	unsigned long int value;
+
+	for (s = tbl->symbols; s->identifier != NULL; s++) {
+		value = s->value;
+
+		if (byteorder == BYTEORDER_BIG_ENDIAN)
+			big_to_host_byteorder(&value,
+					      dtype->size / BITS_PER_BYTE);
 
-	for (s = tbl->symbols; s->identifier != NULL; s++)
 		printf("\t%-30s\t0x%.*" PRIx64 "\n",
-		       s->identifier, size, s->value);
+		       s->identifier, size, value);
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
 
-- 
2.7.4

