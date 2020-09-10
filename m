Return-Path: <SRS0=FHqp=CT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F845C43461
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Sep 2020 16:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583AC206DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Sep 2020 16:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="WuUbGjwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgIJQrh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Sep 2020 12:47:37 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50050 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgIJQnI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Sep 2020 12:43:08 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BnPnm2qVBzFp9N;
        Thu, 10 Sep 2020 09:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1599756172; bh=szZ6DContk3zBQ7vNrw6nipCFTUzOUQ3IZtdSDgzemk=;
        h=From:To:Subject:Date:From;
        b=WuUbGjwOonxnwj+MmFCCE520ZJe0PuSIE0W+URW7Ndvef5y10xEsgcp2XylUXIPmX
         zAYcnLuxgMd98E5YKHDHVA7QqrMvr4UiVRnGPV+h3M+HNwPPX9a8dH6Emsajm4Vyzh
         ScVokhjVq5dq7T3Ds6Tyfv2Bku4rcO4R7hsrxPrA=
X-Riseup-User-ID: 61851462058C165EC56E0570B17CC6384D06056D185205CCF09287DD131DA6A9
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BnPnl3tjcz8wwJ;
        Thu, 10 Sep 2020 09:42:51 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: [PATCH nftables] parser_bison: fail when specifying multiple comments
Date:   Thu, 10 Sep 2020 18:40:20 +0200
Message-Id: <20200910164019.86192-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before this patch grammar supported specifying multiple comments, and
only the last value would be assigned.

This patch adds a function to test if an attribute is already assigned
and, if so, calls erec_queue with this attribute location.

Use this function in order to check for duplication (or more) of comments
for actions that support it.

> nft add table inet filter { flags "dormant"\; comment "test"\; comment "another"\;}

Error: You can only specify this once. This statement is duplicated.
add table inet filter { flags dormant; comment test; comment another;}
                                                     ^^^^^^^^^^^^^^^^

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 src/parser_bison.y | 64 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7242c4c3..c7ea520c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -121,6 +121,18 @@ static struct expr *handle_concat_expr(const struct location *loc,
 	return expr;
 }
 
+static bool already_set(const void *attr, const struct location *loc,
+			struct parser_state *state)
+{
+	if (attr != NULL) {
+		erec_queue(error(loc, "You can only specify this once. This statement is duplicated."),
+			   state->msgs);
+		return true;
+	}
+
+	return false;
+}
+
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
 #define symbol_value(loc, str) \
@@ -1556,6 +1568,10 @@ table_options		:	FLAGS		STRING
 			}
 			|	comment_spec
 			{
+				if (already_set($<table>0->comment, &@$, state)) {
+					xfree($1);
+					YYERROR;
+				}
 				$<table>0->comment = $1;
 			}
 			;
@@ -1795,6 +1811,10 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	set_mechanism	stmt_separator
 			|	set_block	comment_spec	stmt_separator
 			{
+				if (already_set($1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$1->comment = $2;
 				$$ = $1;
 			}
@@ -1923,6 +1943,10 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	comment_spec	stmt_separator
 			{
+				if (already_set($1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$1->comment = $2;
 				$$ = $1;
 			}
@@ -2061,6 +2085,10 @@ counter_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			|	counter_block	  comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2074,6 +2102,10 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			|	quota_block	comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2087,6 +2119,10 @@ ct_helper_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			|       ct_helper_block     comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2104,6 +2140,10 @@ ct_timeout_block	:	/*empty */
 			}
 			|       ct_timeout_block     comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2117,6 +2157,10 @@ ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
 			}
 			|       ct_expect_block     comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2130,6 +2174,10 @@ limit_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			|       limit_block     comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2143,6 +2191,10 @@ secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			|       secmark_block     comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -2156,6 +2208,10 @@ synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
 			}
 			|       synproxy_block     comment_spec
 			{
+				if (already_set($<obj>1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
 				$<obj>1->comment = $2;
 			}
 			;
@@ -4000,6 +4056,10 @@ set_elem_option		:	TIMEOUT			time_spec
 			}
 			|	comment_spec
 			{
+				if (already_set($<expr>0->comment, &@1, state)) {
+					xfree($1);
+					YYERROR;
+				}
 				$<expr>0->comment = $1;
 			}
 			;
@@ -4034,6 +4094,10 @@ set_elem_expr_option	:	TIMEOUT			time_spec
 			}
 			|	comment_spec
 			{
+				if (already_set($<expr>0->comment, &@1, state)) {
+					xfree($1);
+					YYERROR;
+				}
 				$<expr>0->comment = $1;
 			}
 			;
-- 
2.27.0

