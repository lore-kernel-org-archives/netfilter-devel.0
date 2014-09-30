From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4 v3] datatype: Enhance symbolic_constant_parse()
Date: Tue, 30 Sep 2014 17:21:39 +0200
Message-ID: <1412090500-4564-3-git-send-email-alvaroneay@gmail.com>
References: <1412090500-4564-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50465 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaI3PVk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:21:40 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so15749038wgh.24
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2014 08:21:38 -0700 (PDT)
In-Reply-To: <1412090500-4564-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, this function finds the symbol inside the table. If the symbol
doesn't exist we use the basetype to parse it and create the constant
expression. Otherwise, return an error message.

This a refactorization to reuse this code in a follow up patch.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
* Forgot to initialize res to NULL before to use basetype to parse it.

 src/datatype.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index fdfee54..7090b0b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -112,6 +112,7 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 {
 	const struct symbolic_constant *s;
 	const struct datatype *dtype;
+	struct error_record *erec;
 
 	for (s = tbl->symbols; s->identifier != NULL; s++) {
 		if (!strcmp(sym->identifier, s->identifier))
@@ -119,8 +120,16 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 	}
 
 	dtype = sym->dtype;
-	if (s->identifier == NULL)
+	if (s->identifier == NULL) {
+		*res = NULL;
+		erec = sym->dtype->basetype->parse(sym, res);
+		if (erec != NULL)
+			return erec;
+		if (*res)
+			return NULL;
+
 		return error(&sym->location, "Could not parse %s", dtype->desc);
+	}
 
 	*res = constant_expr_alloc(&sym->location, dtype,
 				   dtype->byteorder, dtype->size,
@@ -660,25 +669,6 @@ static void mark_type_print(const struct expr *expr)
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

