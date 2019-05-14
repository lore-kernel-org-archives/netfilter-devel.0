Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064CFC04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 15:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C098520644
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 15:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="nNkSbh3x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfENPZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 11:25:51 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39198 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfENPZv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 11:25:51 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 164861A3E6E
        for <netfilter-devel@vger.kernel.org>; Tue, 14 May 2019 08:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557847550; bh=fKfqWv+Em+cvSf/e8aOlkiHckngG/GfeH9t7ZM0ptDk=;
        h=From:To:Cc:Subject:Date:From;
        b=nNkSbh3x5sHfm5m1YqzbXFBX6vurqfMyNtNizSs51VEGE9jMEIKdqElqVwGRT45Z1
         jNeFYFdN2xRh3Mo1GuHh3J0WsuxMUVs39b+CIOz96Ok9yKygRiYlVXb0O2VrGJsi7n
         0qnYEStkhYmg1+zT6zUDxGJjPfAdtKagyT60mN3o=
X-Riseup-User-ID: 42D97B5A6462516B020794EC69F64E9EA27149E9AED019AAF2FE8295E0D68632
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 48F37221BBC;
        Tue, 14 May 2019 08:25:49 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nft WIP v2] jump: Introduce chain_expr in jump statements
Date:   Tue, 14 May 2019 17:25:41 +0200
Message-Id: <20190514152542.23406-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now we can introduce expressions as a chain in jump and goto statements. This
is going to be used to support variables as a chain in the following patches.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/expression.h |  4 ++--
 src/datatype.c       | 10 ++++++++--
 src/evaluate.c       |  4 ++++
 src/expression.c     | 11 ++++++-----
 src/netlink.c        | 26 +++++++++++++++++++++-----
 src/parser_bison.y   | 16 ++++++++++++----
 6 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 6416ac0..ef41255 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -240,7 +240,7 @@ struct expr {
 		struct {
 			/* EXPR_VERDICT */
 			int			verdict;
-			const char		*chain;
+			struct expr		*chain;
 		};
 		struct {
 			/* EXPR_VALUE */
@@ -403,7 +403,7 @@ extern void relational_expr_pctx_update(struct proto_ctx *ctx,
 					const struct expr *expr);
 
 extern struct expr *verdict_expr_alloc(const struct location *loc,
-				       int verdict, const char *chain);
+				       int verdict, struct expr *chain);
 
 extern struct expr *symbol_expr_alloc(const struct location *loc,
 				      enum symbol_types type, struct scope *scope,
diff --git a/src/datatype.c b/src/datatype.c
index ac9f2af..6aaf9ea 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -254,6 +254,8 @@ const struct datatype invalid_type = {
 
 static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 {
+	char chain[NFT_CHAIN_MAXNAMELEN];
+
 	switch (expr->verdict) {
 	case NFT_CONTINUE:
 		nft_print(octx, "continue");
@@ -262,10 +264,14 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 		nft_print(octx, "break");
 		break;
 	case NFT_JUMP:
-		nft_print(octx, "jump %s", expr->chain);
+		mpz_export_data(chain, expr->chain->value,
+				BYTEORDER_HOST_ENDIAN, NFT_CHAIN_MAXNAMELEN);
+		nft_print(octx, "jump %s", chain);
 		break;
 	case NFT_GOTO:
-		nft_print(octx, "goto %s", expr->chain);
+		mpz_export_data(chain, expr->chain->value,
+				BYTEORDER_HOST_ENDIAN, NFT_CHAIN_MAXNAMELEN);
+		nft_print(octx, "goto %s", chain);
 		break;
 	case NFT_RETURN:
 		nft_print(octx, "return");
diff --git a/src/evaluate.c b/src/evaluate.c
index 21d9e14..8394037 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1947,6 +1947,10 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 	case EXPR_VERDICT:
 		if (stmt->expr->verdict != NFT_CONTINUE)
 			stmt->flags |= STMT_F_TERMINAL;
+		if (stmt->expr->chain != NULL) {
+			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
+				return -1;
+		}
 		break;
 	case EXPR_MAP:
 		break;
diff --git a/src/expression.c b/src/expression.c
index eece12e..55a4ad7 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -207,17 +207,18 @@ static bool verdict_expr_cmp(const struct expr *e1, const struct expr *e2)
 
 	if ((e1->verdict == NFT_JUMP ||
 	     e1->verdict == NFT_GOTO) &&
-	    strcmp(e1->chain, e2->chain))
-		return false;
+	     (expr_basetype(e1) == expr_basetype(e2) &&
+	     !mpz_cmp(e1->value, e2->value)))
+		return true;
 
-	return true;
+	return false;
 }
 
 static void verdict_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->verdict = expr->verdict;
 	if (expr->chain != NULL)
-		new->chain = xstrdup(expr->chain);
+		mpz_init_set(new->chain->value, expr->chain->value);
 }
 
 static void verdict_expr_destroy(struct expr *expr)
@@ -236,7 +237,7 @@ static const struct expr_ops verdict_expr_ops = {
 };
 
 struct expr *verdict_expr_alloc(const struct location *loc,
-				int verdict, const char *chain)
+				int verdict, struct expr *chain)
 {
 	struct expr *expr;
 
diff --git a/src/netlink.c b/src/netlink.c
index c051ae6..ef12cb0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -218,12 +218,17 @@ static void netlink_gen_constant_data(const struct expr *expr,
 static void netlink_gen_verdict(const struct expr *expr,
 				struct nft_data_linearize *data)
 {
+	char chain[NFT_CHAIN_MAXNAMELEN];
+
 	data->verdict = expr->verdict;
 
 	switch (expr->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", expr->chain);
+		mpz_export_data(chain, expr->chain->value,
+				BYTEORDER_HOST_ENDIAN,
+				NFT_CHAIN_MAXNAMELEN);
+		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
 		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
 		break;
 	}
@@ -253,12 +258,15 @@ struct expr *netlink_alloc_value(const struct location *loc,
 static struct expr *netlink_alloc_verdict(const struct location *loc,
 					  const struct nft_data_delinearize *nld)
 {
-	char *chain;
+	struct expr *chain;
 
 	switch (nld->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
-		chain = xstrdup(nld->chain);
+		chain = constant_expr_alloc(loc, &string_type,
+					    BYTEORDER_HOST_ENDIAN,
+					    NFT_CHAIN_MAXNAMELEN *
+					    BITS_PER_BYTE, nld->chain);
 		break;
 	default:
 		chain = NULL;
@@ -1153,14 +1161,22 @@ static void trace_print_expr(const struct nftnl_trace *nlt, unsigned int attr,
 static void trace_print_verdict(const struct nftnl_trace *nlt,
 				 struct output_ctx *octx)
 {
+	struct expr *chain_expr = NULL;
 	const char *chain = NULL;
 	unsigned int verdict;
 	struct expr *expr;
 
 	verdict = nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT);
-	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_JUMP_TARGET))
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_JUMP_TARGET)) {
 		chain = xstrdup(nftnl_trace_get_str(nlt, NFTNL_TRACE_JUMP_TARGET));
-	expr = verdict_expr_alloc(&netlink_location, verdict, chain);
+		chain_expr = constant_expr_alloc(&netlink_location,
+						 &string_type,
+						 BYTEORDER_HOST_ENDIAN,
+						 NFT_CHAIN_MAXNAMELEN
+						 * BITS_PER_BYTE,
+						 chain);
+	}
+	expr = verdict_expr_alloc(&netlink_location, verdict, chain_expr);
 
 	nft_print(octx, "verdict ");
 	expr_print(expr, octx);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9e632c0..69b5773 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -618,8 +618,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 
-%type <expr>			symbol_expr verdict_expr integer_expr variable_expr
-%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr
+%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr
+%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr
 %type <expr>			primary_expr shift_expr and_expr
 %destructor { expr_free($$); }	primary_expr shift_expr and_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
@@ -3827,11 +3827,11 @@ verdict_expr		:	ACCEPT
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_CONTINUE, NULL);
 			}
-			|	JUMP			identifier
+			|	JUMP			chain_expr
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_JUMP, $2);
 			}
-			|	GOTO			identifier
+			|	GOTO			chain_expr
 			{
 				$$ = verdict_expr_alloc(&@$, NFT_GOTO, $2);
 			}
@@ -3841,6 +3841,14 @@ verdict_expr		:	ACCEPT
 			}
 			;
 
+chain_expr		:	identifier
+			{
+				$$ = constant_expr_alloc(&@$, &string_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 NFT_NAME_MAXLEN * BITS_PER_BYTE, $1);
+			}
+			;
+
 meta_expr		:	META	meta_key
 			{
 				$$ = meta_expr_alloc(&@$, $2);
-- 
2.20.1

