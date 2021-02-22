Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C143FC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 13:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B39664E12
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 13:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhBVNUJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Feb 2021 08:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhBVNSE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Feb 2021 08:18:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE83C06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 05:17:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lEB5S-0006P2-Ha; Mon, 22 Feb 2021 14:17:18 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Frank Myhr <fmyhr@fhmtech.com>
Subject: [PATCH nft] src: allow use of 'verdict' in typeof definitions
Date:   Mon, 22 Feb 2021 14:17:13 +0100
Message-Id: <20210222131713.25767-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'verdict' cannot be used as part of a map typeof-based key definition,
its a datatype and not an expression, e.g.:

  typeof iifname . ip protocol . th dport : verdic

... will fail.

Make the parser convert a 'verdict' symbol to a verdict expression
and allow to store its presence as part of the typeof key definition.

Reported-by: Frank Myhr <fmyhr@fhmtech.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c                              | 17 +++++++++++
 src/parser_bison.y                            | 29 +++++++++++++++++--
 .../testcases/maps/dumps/typeof_maps_0.nft    |  4 +++
 tests/shell/testcases/maps/typeof_maps_0      |  4 +++
 4 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index a90a89ca9f74..8c6beef9a5e5 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -252,6 +252,21 @@ static void verdict_expr_destroy(struct expr *expr)
 	expr_free(expr->chain);
 }
 
+static int verdict_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				    const struct expr *expr)
+{
+	return 0;
+}
+
+static struct expr *verdict_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	struct expr *e = verdict_expr_alloc(&internal_location, 0, NULL);
+
+	e = symbol_expr_alloc(&internal_location, SYMBOL_VALUE, NULL, "verdict");
+	e->len = NFT_REG_SIZE * BITS_PER_BYTE;
+	return e;
+}
+
 static const struct expr_ops verdict_expr_ops = {
 	.type		= EXPR_VERDICT,
 	.name		= "verdict",
@@ -260,6 +275,8 @@ static const struct expr_ops verdict_expr_ops = {
 	.cmp		= verdict_expr_cmp,
 	.clone		= verdict_expr_clone,
 	.destroy	= verdict_expr_destroy,
+	.build_udata	= verdict_expr_build_udata,
+	.parse_udata	= verdict_expr_parse_udata,
 };
 
 struct expr *verdict_expr_alloc(const struct location *loc,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 11e899ff2f20..3c8013b2493e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -672,8 +672,8 @@ int nft_lex(void *, void *, void *);
 
 %type <expr>			symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr variable_expr chain_expr policy_expr
-%type <expr>			primary_expr shift_expr and_expr typeof_expr
-%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr
+%type <expr>			primary_expr shift_expr and_expr typeof_expr typeof_data_expr
+%destructor { expr_free($$); }	primary_expr shift_expr and_expr typeof_expr typeof_data_expr
 %type <expr>			exclusive_or_expr inclusive_or_expr
 %destructor { expr_free($$); }	exclusive_or_expr inclusive_or_expr
 %type <expr>			basic_expr
@@ -1739,6 +1739,29 @@ subchain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			}
 			;
 
+typeof_data_expr	:	primary_expr
+			{
+				struct expr *e = $1;
+
+				if (e->etype == EXPR_SYMBOL &&
+				    strcmp("verdict", e->identifier) == 0) {
+					struct expr *v = verdict_expr_alloc(&@1, NF_ACCEPT, NULL);
+
+					expr_free(e);
+					v->flags &= ~EXPR_F_CONSTANT;
+					e = v;
+				}
+
+				if (expr_ops(e)->build_udata == NULL) {
+					erec_queue(error(&@1, "map data type '%s' lacks typeof serialization", expr_ops(e)->name),
+						   state->msgs);
+					expr_free(e);
+					YYERROR;
+				}
+				$$ = e;
+			}
+			;
+
 typeof_expr		:	primary_expr
 			{
 				if (expr_ops($1)->build_udata == NULL) {
@@ -1878,7 +1901,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$$ = $1;
 			}
 			|	map_block	TYPEOF
-						typeof_expr	COLON	typeof_expr
+						typeof_expr	COLON	typeof_data_expr
 						stmt_separator
 			{
 				$1->key = $3;
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
index faa73cd1af84..438b9829db90 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
@@ -15,6 +15,10 @@ table inet t {
 			     2.3.4.5 . 6.7.8.9 : 0x00000002 }
 	}
 
+	map m4 {
+		typeof iifname . ip protocol . th dport : verdict
+	}
+
 	chain c {
 		ct mark set osf name map @m1
 		meta mark set vlan id map @m2
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
index e1c4bba9f182..f024ebe0f9f6 100755
--- a/tests/shell/testcases/maps/typeof_maps_0
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -22,6 +22,10 @@ EXPECTED="table inet t {
 			     2.3.4.5 . 6.7.8.9 : 0x00000002 }
 	}
 
+	map m4 {
+		typeof        iifname . ip protocol . th dport : verdict
+	}
+
 	chain c {
 		ct mark set osf name map @m1
 		ether type vlan meta mark set vlan id map @m2
-- 
2.26.2

