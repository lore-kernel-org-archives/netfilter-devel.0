From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4 v2] datatype: Enhance symbolic_constant_parse()
Date: Fri, 26 Sep 2014 18:50:54 +0200
Message-ID: <1411750255-7663-3-git-send-email-alvaroneay@gmail.com>
References: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56616 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaIZQuq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:50:46 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so12014115wiv.7
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 09:50:44 -0700 (PDT)
In-Reply-To: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, this function finds the symbol inside the table. If the symbol
doesn't exist we use the basetype to parse it and create the constant
expression. Otherwise, return an error message.

This a refactorization to reuse this code in a follow up patch.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v2]
* Removed the function symbolic_constant_parse_table and moved the processing to
  symbolic_constant_parse.

 src/datatype.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index fdfee54..9bfe46d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -112,6 +112,7 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 {
 	const struct symbolic_constant *s;
 	const struct datatype *dtype;
+	struct error_record *erec;
 
 	for (s = tbl->symbols; s->identifier != NULL; s++) {
 		if (!strcmp(sym->identifier, s->identifier))
@@ -119,8 +120,14 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 	}
 
 	dtype = sym->dtype;
-	if (s->identifier == NULL)
-		return error(&sym->location, "Could not parse %s", dtype->desc);
+	if (s->identifier == NULL) {
+		erec = sym->dtype->basetype->parse(sym, res);
+		if (erec != NULL)
+			return erec;
+		if (*res)
+			return error(&sym->location, "Could not parse %s",
+				     dtype->desc);
+	}
 
 	*res = constant_expr_alloc(&sym->location, dtype,
 				   dtype->byteorder, dtype->size,
@@ -660,25 +667,6 @@ static void mark_type_print(const struct expr *expr)
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
 	return symbolic_constant_parse(sym, mark_tbl, res);
 }
 
-- 
1.7.10.4

