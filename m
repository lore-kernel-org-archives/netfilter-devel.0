Return-Path: <SRS0=W4zY=YF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3845CC4360C
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Oct 2019 22:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA95D206CD
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Oct 2019 22:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfJLWrR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Oct 2019 18:47:17 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33418 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727109AbfJLWrR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Oct 2019 18:47:17 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iJQAM-0002d7-12; Sun, 13 Oct 2019 00:47:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] expression: extend 'nft describe' to allow listing data types
Date:   Sun, 13 Oct 2019 00:17:52 +0200
Message-Id: <20191012221752.4812-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft describe ct_status
before:
symbol expression, datatype invalid (invalid), 0 bits

after:
datatype ct_status (conntrack status) (basetype bitmask, integer), 32 bits

pre-defined symbolic constants (in hexadecimal):
        expected                        0x00000001
        seen-reply                      0x00000002
	[..]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt                | 15 ++++++++++++++-
 doc/primary-expression.txt |  2 ++
 src/expression.c           | 34 +++++++++++++++++++++++++---------
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 482e55b97002..610d91e9e1a4 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -658,9 +658,11 @@ representation of symbolic values and type compatibility with other expressions.
 DESCRIBE COMMAND
 ~~~~~~~~~~~~~~~~
 [verse]
-*describe* 'expression'
+*describe* 'expression' | 'data type'
 
 The *describe* command shows information about the type of an expression and its data type.
+A data type may also be given, in which nft will display more information
+about the type.
 
 .The describe command
 ---------------------
@@ -686,6 +688,17 @@ and type compatibility of expressions. A number of global data types exist, in
 addition some expression types define further data types specific to the
 expression type. Most data types have a fixed size, some however may have a
 dynamic size, f.i. the string type. +
+Some types also have predefined symbolic constants.  Those can be listed
+using the nft *describe* command:
+
+---------------------
+$ nft describe ct_state
+datatype ct_state (conntrack state) (basetype bitmask, integer), 32 bits
+
+pre-defined symbolic constants (in hexadecimal):
+invalid                         0x00000001
+new ...
+---------------------
 
 Types may be derived from lower order types, f.i. the IPv4 address type is
 derived from the integer type, meaning an IPv4 address can also be specified as
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index c5d25eee3c37..0316a7e1ab8e 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -292,6 +292,8 @@ Address type |
 fib_addrtype
 |=======================
 
+Use *nft* *describe* *fib_addrtype* to get a list of all address types.
+
 .Using fib expressions
 ----------------------
 # drop packets without a reverse path
diff --git a/src/expression.c b/src/expression.c
index cb49e0b73f5a..e456010ff8b0 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -122,11 +122,24 @@ const char *expr_name(const struct expr *e)
 
 void expr_describe(const struct expr *expr, struct output_ctx *octx)
 {
-	const struct datatype *dtype = expr->dtype;
+	const struct datatype *dtype = expr->dtype, *edtype = NULL;
+	unsigned int len = expr->len;
 	const char *delim = "";
 
-	nft_print(octx, "%s expression, datatype %s (%s)",
-		  expr_name(expr), dtype->name, dtype->desc);
+	if (dtype == &invalid_type &&
+	    expr->etype == EXPR_SYMBOL)
+		edtype = datatype_lookup_byname(expr->identifier);
+
+	if (edtype) {
+		dtype = edtype;
+		nft_print(octx, "datatype %s (%s)",
+			  dtype->name, dtype->desc);
+		len = dtype->size;
+	} else {
+		nft_print(octx, "%s expression, datatype %s (%s)",
+			  expr_name(expr), dtype->name, dtype->desc);
+	}
+
 	if (dtype->basetype != NULL) {
 		nft_print(octx, " (basetype ");
 		for (dtype = dtype->basetype; dtype != NULL;
@@ -138,23 +151,26 @@ void expr_describe(const struct expr *expr, struct output_ctx *octx)
 	}
 
 	if (expr_basetype(expr)->type == TYPE_STRING) {
-		if (expr->len)
+		if (len)
 			nft_print(octx, ", %u characters",
-				  expr->len / BITS_PER_BYTE);
+				  len / BITS_PER_BYTE);
 		else
 			nft_print(octx, ", dynamic length");
 	} else
-		nft_print(octx, ", %u bits", expr->len);
+		nft_print(octx, ", %u bits", len);
+
+	if (!edtype)
+		edtype = expr->dtype;
 
 	nft_print(octx, "\n");
 
-	if (expr->dtype->sym_tbl != NULL) {
+	if (edtype->sym_tbl != NULL) {
 		nft_print(octx, "\npre-defined symbolic constants ");
-		if (expr->dtype->sym_tbl->base == BASE_DECIMAL)
+		if (edtype->sym_tbl->base == BASE_DECIMAL)
 			nft_print(octx, "(in decimal):\n");
 		else
 			nft_print(octx, "(in hexadecimal):\n");
-		symbol_table_print(expr->dtype->sym_tbl, expr->dtype,
+		symbol_table_print(edtype->sym_tbl, edtype,
 				   expr->byteorder, octx);
 	}
 }
-- 
2.21.0

