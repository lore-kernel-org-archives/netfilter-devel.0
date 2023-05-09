Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27349C77B7C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 May 2023 15:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjEIPs5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 May 2023 11:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjEIPs4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2023 11:48:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF65F3598
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 08:48:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] datatype: add hint on error handler
Date:   Tue,  9 May 2023 17:48:45 +0200
Message-Id: <20230509154845.39141-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230509154845.39141-1-pablo@netfilter.org>
References: <20230509154845.39141-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user provides a symbol that cannot be parsed and the datatype provides
an error handler, provide a hint through the misspell infrastructure.

For instance:

 # cat test.nft
 table ip x {
        map y {
                typeof ip saddr : verdict
                elements = { 1.2.3.4 : filter_server1 }
        }
 }
 # nft -f test.nft
 test.nft:4:26-39: Error: Could not parse netfilter verdict; did you mean `jump filter_server1'?
                 elements = { 1.2.3.4 : filter_server1 }
                                        ^^^^^^^^^^^^^^

While at it, normalize error to "Could not parse symbolic %s expression".

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |  1 +
 src/datatype.c     | 41 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 391d6ac8b4bd..4b59790b67f9 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -167,6 +167,7 @@ struct datatype {
 	struct error_record		*(*parse)(struct parse_ctx *ctx,
 						  const struct expr *sym,
 						  struct expr **res);
+	struct error_record		*(*err)(const struct expr *sym);
 	void				(*describe)(struct output_ctx *octx);
 	const struct symbol_table	*sym_tbl;
 	unsigned int			refcnt;
diff --git a/src/datatype.c b/src/datatype.c
index 2cefd0f3f10e..da802a18bccd 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -124,6 +124,7 @@ struct error_record *symbol_parse(struct parse_ctx *ctx, const struct expr *sym,
 				  struct expr **res)
 {
 	const struct datatype *dtype = sym->dtype;
+	struct error_record *erec;
 
 	assert(sym->etype == EXPR_SYMBOL);
 
@@ -137,8 +138,14 @@ struct error_record *symbol_parse(struct parse_ctx *ctx, const struct expr *sym,
 						       res);
 	} while ((dtype = dtype->basetype));
 
-	return error(&sym->location,
-		     "Can't parse symbolic %s expressions",
+	dtype = sym->dtype;
+	if (dtype->err) {
+		erec = dtype->err(sym);
+		if (erec)
+			return erec;
+	}
+
+	return error(&sym->location, "Could not parse symbolic %s expression",
 		     sym->dtype->desc);
 }
 
@@ -367,11 +374,41 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 	}
 }
 
+static struct error_record *verdict_type_error(const struct expr *sym)
+{
+	/* Skip jump and goto from fuzzy match to provide better error
+	 * reporting, fall back to `jump chain' if no clue.
+	 */
+	static const char *verdict_array[] = {
+		"continue", "break", "return", "accept", "drop", "queue",
+		"stolen", NULL,
+	};
+	struct string_misspell_state st;
+	int i;
+
+	string_misspell_init(&st);
+
+	for (i = 0; verdict_array[i] != NULL; i++) {
+		string_misspell_update(sym->identifier, verdict_array[i],
+				       (void *)verdict_array[i], &st);
+	}
+
+	if (st.obj) {
+		return error(&sym->location, "Could not parse %s; did you mean `%s'?",
+			     sym->dtype->desc, st.obj);
+	}
+
+	/* assume user would like to jump to chain as a hint. */
+	return error(&sym->location, "Could not parse %s; did you mean `jump %s'?",
+		     sym->dtype->desc, sym->identifier);
+}
+
 const struct datatype verdict_type = {
 	.type		= TYPE_VERDICT,
 	.name		= "verdict",
 	.desc		= "netfilter verdict",
 	.print		= verdict_type_print,
+	.err		= verdict_type_error,
 };
 
 static const struct symbol_table nfproto_tbl = {
-- 
2.30.2

