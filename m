Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304DAC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Dec 2021 16:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381979AbhLCQLi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381970AbhLCQLi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 11:11:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12170C061751
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Dec 2021 08:08:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mtB6a-00027V-LC; Fri, 03 Dec 2021 17:08:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] iptopt: fix crash with invalid field/type combo
Date:   Fri,  3 Dec 2021 17:07:55 +0100
Message-Id: <20211203160755.8720-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203160755.8720-1-fw@strlen.de>
References: <20211203160755.8720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

% nft describe ip option rr value
segmentation fault

after this fix, this exits with 'Error: unknown ip option type/field'.

Problem is that 'rr' doesn't have a value template, so the template struct is
all-zeroes, so we crash when trying to use tmpl->dtype (its NULL).

Furthermore, expr_describe tries to print expr->identifier but expr is
exthdr, not symbol: ->identifier contains garbage.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expression.c                       | 8 ++++----
 src/ipopt.c                            | 3 +++
 src/parser_bison.y                     | 4 ++++
 tests/shell/testcases/parsing/describe | 7 +++++++
 4 files changed, 18 insertions(+), 4 deletions(-)
 create mode 100755 tests/shell/testcases/parsing/describe

diff --git a/src/expression.c b/src/expression.c
index 4c0874fe9950..f1cca8845376 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -135,12 +135,12 @@ void expr_describe(const struct expr *expr, struct output_ctx *octx)
 		nft_print(octx, "datatype %s (%s)",
 			  dtype->name, dtype->desc);
 		len = dtype->size;
-	} else if (dtype != &invalid_type) {
+	} else {
 		nft_print(octx, "%s expression, datatype %s (%s)",
 			  expr_name(expr), dtype->name, dtype->desc);
-	} else {
-		nft_print(octx, "datatype %s is invalid\n", expr->identifier);
-		return;
+
+		if (dtype == &invalid_type)
+			return;
 	}
 
 	if (dtype->basetype != NULL) {
diff --git a/src/ipopt.c b/src/ipopt.c
index 42ea41cd705b..67e904ff3d88 100644
--- a/src/ipopt.c
+++ b/src/ipopt.c
@@ -78,6 +78,9 @@ struct expr *ipopt_expr_alloc(const struct location *loc, uint8_t type,
 	if (!tmpl)
 		return NULL;
 
+	if (!tmpl->len)
+		return NULL;
+
 	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
 			  BYTEORDER_BIG_ENDIAN, tmpl->len);
 	expr->exthdr.desc   = desc;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 357850dececc..16607bb79bdd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5332,6 +5332,10 @@ ip_hdr_expr		:	IP	ip_hdr_field	close_scope_ip
 			|	IP	OPTION	ip_option_type ip_option_field	close_scope_ip
 			{
 				$$ = ipopt_expr_alloc(&@$, $3, $4);
+				if (!$$) {
+					erec_queue(error(&@1, "unknown ip option type/field"), state->msgs);
+					YYERROR;
+				}
 			}
 			|	IP	OPTION	ip_option_type close_scope_ip
 			{
diff --git a/tests/shell/testcases/parsing/describe b/tests/shell/testcases/parsing/describe
new file mode 100755
index 000000000000..2ee072e820fd
--- /dev/null
+++ b/tests/shell/testcases/parsing/describe
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+errmsg='Error: unknown ip option type/field'
+
+str=$($NFT describe ip option rr value 2>&1 | head -n 1)
+
+[ "$str" = "$errmsg" ] && exit 0
-- 
2.32.0

