Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD873C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 14:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiCCO54 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 09:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiCCO5r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 09:57:47 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0584B18FAD1
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 06:57:02 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4DF5460743
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 15:55:27 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3 3/3] optimize: do not merge unsupported statement expressions
Date:   Thu,  3 Mar 2022 15:56:49 +0100
Message-Id: <20220303145649.843320-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220303145649.843320-1-pablo@netfilter.org>
References: <20220303145649.843320-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only value, range, prefix, set and list are supported at this stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: EXPR_VALUE is possible, keep it

 src/optimize.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 6ba7e5a10cf8..f8dd7f8d159f 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -91,6 +91,23 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 	return true;
 }
 
+static bool stmt_expr_supported(const struct expr *expr)
+{
+	switch (expr->right->etype) {
+	case EXPR_SYMBOL:
+	case EXPR_RANGE:
+	case EXPR_PREFIX:
+	case EXPR_SET:
+	case EXPR_LIST:
+	case EXPR_VALUE:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 {
 	struct expr *expr_a, *expr_b;
@@ -103,6 +120,10 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b)
 		expr_a = stmt_a->expr;
 		expr_b = stmt_b->expr;
 
+		if (!stmt_expr_supported(expr_a) ||
+		    !stmt_expr_supported(expr_b))
+			return false;
+
 		return __expr_cmp(expr_a->left, expr_b->left);
 	case STMT_COUNTER:
 	case STMT_NOTRACK:
-- 
2.30.2

