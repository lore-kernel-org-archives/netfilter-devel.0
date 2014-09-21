From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4] datatype: add symbolic_constant_parse_table()
Date: Sun, 21 Sep 2014 21:32:36 +0200
Message-ID: <1411327957-19379-3-git-send-email-alvaroneay@gmail.com>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60955 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIUTca (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:32:30 -0400
Received: by mail-wi0-f169.google.com with SMTP id fb4so1799350wid.2
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Sep 2014 12:32:28 -0700 (PDT)
In-Reply-To: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function finds the symbol inside the table that you pass as parameter.
If the symbol doesn't exist we use the basetype to parse it and
symbolic_constant_parse().

This a refactorization to reuse this code in a follow up patch.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/datatype.c |   47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index fdfee54..1954dd6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -128,6 +128,32 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 	return NULL;
 }
 
+static struct error_record
+*symbolic_constant_table_parse(const struct symbol_table *table,
+			       const struct expr *sym, struct expr **res)
+{
+	struct error_record *erec;
+	const struct symbolic_constant *s;
+
+	for (s = table->symbols; s->identifier != NULL; s++) {
+		if (!strcmp(sym->identifier, s->identifier)) {
+			*res = constant_expr_alloc(&sym->location, sym->dtype,
+						   sym->dtype->byteorder,
+						   sym->dtype->size,
+						   &s->value);
+			return NULL;
+		}
+	}
+
+	*res = NULL;
+	erec = sym->dtype->basetype->parse(sym, res);
+	if (erec != NULL)
+		return erec;
+	if (*res)
+		return NULL;
+	return symbolic_constant_parse(sym, table, res);
+}
+
 void symbolic_constant_print(const struct symbol_table *tbl,
 			     const struct expr *expr)
 {
@@ -660,26 +686,7 @@ static void mark_type_print(const struct expr *expr)
 static struct error_record *mark_type_parse(const struct expr *sym,
 					    struct expr **res)
 {
-	struct error_record *erec;
-	const struct symbolic_constant *s;
-
-	for (s = mark_tbl->symbols; s->identifier != NULL; s++) {
-		if (!strcmp(sym->identifier, s->identifier)) {
-			*res = constant_expr_alloc(&sym->location, sym->dtype,
-						   sym->dtype->byteorder,
-						   sym->dtype->size,
-						   &s->value);
-			return NULL;
-		}
-	}
-
-	*res = NULL;
-	erec = sym->dtype->basetype->parse(sym, res);
-	if (erec != NULL)
-		return erec;
-	if (*res)
-		return NULL;
-	return symbolic_constant_parse(sym, mark_tbl, res);
+	return symbolic_constant_table_parse(mark_tbl, sym, res);
 }
 
 const struct datatype mark_type = {
-- 
1.7.10.4

