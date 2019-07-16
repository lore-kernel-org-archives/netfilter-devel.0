Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED595C76192
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 09:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED7320659
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 09:08:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="f9JwGDsk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfGPJIl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 05:08:41 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50236 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfGPJIl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 05:08:41 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id C50EF1A6696
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 02:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563268120; bh=UYgLfKICxCj8t3h8zlIaS41qIfEP58/S6TjDRmxQgGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9JwGDskaaUrOlsr6WCfbPCVnRddL1Uw2hnS6MsnjczhYD2fNcgYQMgdHRqOFcXZt
         nYptT5lExEMQw8nfBsMVxVU2gRQ0nQ+jnBckGLyMp/32qYhigebl/Is0kCwdIe8MpI
         //gcCzlBY1x4Cb/KWHjU1m5ibudaaxelkiVncPgo=
X-Riseup-User-ID: 6BA1BEF7B62C031C60D589BAB76C4B3FA00CFF99F61E5A0B15F87B5E3DC122C1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id ADB7B1204FF;
        Tue, 16 Jul 2019 02:08:38 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nft WIP] src: introduce prio_expr in chain priority
Date:   Tue, 16 Jul 2019 11:08:12 +0200
Message-Id: <20190716090812.873-2-ffmancera@riseup.net>
In-Reply-To: <20190716090812.873-1-ffmancera@riseup.net>
References: <20190716090812.873-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/rule.h     |  8 ++++----
 src/evaluate.c     | 29 +++++++++++++++++++----------
 src/parser_bison.y | 25 +++++++++++++++++--------
 src/rule.c         |  4 ++--
 4 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index aefb24d..4d7cec8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -173,13 +173,13 @@ enum chain_flags {
  * struct prio_spec - extendend priority specification for mixed
  *                    textual/numerical parsing.
  *
- * @str:  name of the standard priority value
- * @num:  Numerical value. This MUST contain the parsed value of str after
+ * @prio_expr:  expr of the standard priority value
+ * @num:  Numerical value. This MUST contain the parsed value of prio_expr after
  *        evaluation.
  */
 struct prio_spec {
-	const char  *str;
-	int          num;
+	struct expr	*prio_expr;
+	int		num;
 	struct location loc;
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 8086f75..cee65cd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3181,15 +3181,24 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
-static bool evaluate_priority(struct prio_spec *prio, int family, int hook)
+static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
+			      int family, int hook)
 {
 	int priority;
+	char prio_str[NFT_NAME_MAXLEN];
 
 	/* A numeric value has been used to specify priority. */
-	if (prio->str == NULL)
+	if (prio->prio_expr == NULL)
 		return true;
 
-	priority = std_prio_lookup(prio->str, family, hook);
+	if (expr_evaluate(ctx, &prio->prio_expr) < 0)
+		return false;
+	if (prio->prio_expr->etype == EXPR_VALUE)
+		mpz_export_data(prio_str, prio->prio_expr->value,
+				BYTEORDER_HOST_ENDIAN,
+				NFT_NAME_MAXLEN);
+
+	priority = std_prio_lookup(prio_str, family, hook);
 	if (priority == NF_IP_PRI_LAST)
 		return false;
 	prio->num += priority;
@@ -3211,10 +3220,10 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 	if (ft->hooknum == NF_INET_NUMHOOKS)
 		return chain_error(ctx, ft, "invalid hook %s", ft->hookstr);
 
-	if (!evaluate_priority(&ft->priority, NFPROTO_NETDEV, ft->hooknum))
+	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hooknum))
 		return __stmt_binary_error(ctx, &ft->priority.loc, NULL,
-					   "'%s' is invalid priority.",
-					   ft->priority.str);
+					   "invalid priority expression %s.",
+					   expr_name(ft->priority.prio_expr));
 
 	if (!ft->dev_expr)
 		return chain_error(ctx, ft, "Unbound flowtable not allowed (must specify devices)");
@@ -3410,11 +3419,11 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			return chain_error(ctx, chain, "invalid hook %s",
 					   chain->hookstr);
 
-		if (!evaluate_priority(&chain->priority, chain->handle.family,
-				       chain->hooknum))
+		if (!evaluate_priority(ctx, &chain->priority,
+				       chain->handle.family, chain->hooknum))
 			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
-						   "'%s' is invalid priority in this context.",
-						   chain->priority.str);
+						   "invalid priority expression %s in this context.",
+						   expr_name(chain->priority.prio_expr));
 	}
 
 	list_for_each_entry(rule, &chain->rules, list) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a4905f2..c6a43cf 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -626,8 +626,8 @@ int nft_lex(void *, void *, void *);
 %type <stmt>			meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 %destructor { stmt_free($$); }	meter_stmt meter_stmt_alloc flow_stmt_legacy_alloc
 
-%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr
-%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr
+%type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
+%destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr prio_expr
 %type <expr>			primary_expr shift_expr and_expr
 %destructor { expr_free($$); }	primary_expr shift_expr and_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
@@ -1926,30 +1926,39 @@ extended_prio_name	:	OUT
 			|	STRING
 			;
 
+prio_expr		:	extended_prio_name
+			{
+				$$ = constant_expr_alloc(&@$, &string_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 NFT_NAME_MAXLEN *
+							 BITS_PER_BYTE, $1);
+			}
+			;
+
 extended_prio_spec	:	int_num
 			{
 				struct prio_spec spec = {0};
 				spec.num = $1;
 				$$ = spec;
 			}
-			|	extended_prio_name
+			|	prio_expr
 			{
 				struct prio_spec spec = {0};
-				spec.str = $1;
+				spec.prio_expr = $1;
 				$$ = spec;
 			}
-			|	extended_prio_name PLUS NUM
+			|	prio_expr PLUS NUM
 			{
 				struct prio_spec spec = {0};
 				spec.num = $3;
-				spec.str = $1;
+				spec.prio_expr = $1;
 				$$ = spec;
 			}
-			|	extended_prio_name DASH NUM
+			|	prio_expr DASH NUM
 			{
 				struct prio_spec spec = {0};
 				spec.num = -$3;
-				spec.str = $1;
+				spec.prio_expr = $1;
 				$$ = spec;
 			}
 			;
diff --git a/src/rule.c b/src/rule.c
index 0a91917..59a97ac 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -823,7 +823,7 @@ void chain_free(struct chain *chain)
 	xfree(chain->type);
 	if (chain->dev != NULL)
 		xfree(chain->dev);
-	xfree(chain->priority.str);
+	expr_free(chain->priority.prio_expr);
 	xfree(chain);
 }
 
@@ -2020,7 +2020,7 @@ void flowtable_free(struct flowtable *flowtable)
 	if (--flowtable->refcnt > 0)
 		return;
 	handle_free(&flowtable->handle);
-	xfree(flowtable->priority.str);
+	expr_free(flowtable->priority.prio_expr);
 	xfree(flowtable);
 }
 
-- 
2.20.1

