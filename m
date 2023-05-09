Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD38EC77B75
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 May 2023 15:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbjEIPs5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 May 2023 11:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjEIPs4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2023 11:48:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A13633594
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 08:48:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] datatype: misspell support with symbol table parser for error reporting
Date:   Tue,  9 May 2023 17:48:44 +0200
Message-Id: <20230509154845.39141-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some datatypes provide a symbol table that is parsed as an integer.
Improve error reporting by using the misspell infrastructure, to provide
a hint to the user, whenever possible.

If base datatype, usually the integer datatype, fails to parse the
symbol, then try a fuzzy match on the symbol table to provide a hint
in case the user has mistype it.

For instance:

 test.nft:3:11-14: Error: Could not parse Differentiated Services Code Point expression; did you you mean `cs0`?
                 ip dscp ccs0
                         ^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 002ed46a9931..2cefd0f3f10e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -28,6 +28,7 @@
 #include <erec.h>
 #include <netlink.h>
 #include <json.h>
+#include <misspell.h>
 
 #include <netinet/ip_icmp.h>
 
@@ -141,6 +142,43 @@ struct error_record *symbol_parse(struct parse_ctx *ctx, const struct expr *sym,
 		     sym->dtype->desc);
 }
 
+static struct error_record *__symbol_parse_fuzzy(const struct expr *sym,
+						 const struct symbol_table *tbl)
+{
+	const struct symbolic_constant *s;
+	struct string_misspell_state st;
+
+	string_misspell_init(&st);
+
+	for (s = tbl->symbols; s->identifier != NULL; s++) {
+		string_misspell_update(sym->identifier, s->identifier,
+				       (void *)s->identifier, &st);
+	}
+
+	if (st.obj) {
+		return error(&sym->location,
+			     "Could not parse %s expression; did you you mean `%s`?",
+			     sym->dtype->desc, st.obj);
+	}
+
+	return NULL;
+}
+
+static struct error_record *symbol_parse_fuzzy(const struct expr *sym,
+					       const struct symbol_table *tbl)
+{
+	struct error_record *erec;
+
+	if (!tbl)
+		return NULL;
+
+	erec = __symbol_parse_fuzzy(sym, tbl);
+	if (erec)
+		return erec;
+
+	return NULL;
+}
+
 struct error_record *symbolic_constant_parse(struct parse_ctx *ctx,
 					     const struct expr *sym,
 					     const struct symbol_table *tbl,
@@ -163,8 +201,16 @@ struct error_record *symbolic_constant_parse(struct parse_ctx *ctx,
 	do {
 		if (dtype->basetype->parse) {
 			erec = dtype->basetype->parse(ctx, sym, res);
-			if (erec != NULL)
-				return erec;
+			if (erec != NULL) {
+				struct error_record *fuzzy_erec;
+
+				fuzzy_erec = symbol_parse_fuzzy(sym, tbl);
+				if (!fuzzy_erec)
+					return erec;
+
+				erec_destroy(erec);
+				return fuzzy_erec;
+			}
 			if (*res)
 				return NULL;
 			goto out;
-- 
2.30.2

