Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6E9C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 19:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhLOT4Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 14:56:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:55878 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbhLOT4X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 14:56:23 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 98911625CF
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 20:53:53 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] optimize: merge rules with same selectors into a concatenation
Date:   Wed, 15 Dec 2021 20:56:14 +0100
Message-Id: <20211215195615.139902-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215195615.139902-1-pablo@netfilter.org>
References: <20211215195615.139902-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends the ruleset optimization infrastructure to collapse
several rules with the same selectors into a concatenation.

Transform:

  meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
  meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.5 accept
  meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.6 accept

into:

  meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.6, eth1 . 1.1.1.2 . 2.2.2.5 , eth1 . 1.1.1.3 . 2.2.2.6 } accept

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index c30000bd2397..279eabb02152 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -217,6 +217,47 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 	stmt_a->expr->right = set;
 }
 
+static void merge_multi_stmts(const struct optimize_ctx *ctx,
+			      uint32_t from, uint32_t to,
+			      const struct merge *merge)
+{
+	struct expr *concat, *expr, *elem;
+	struct stmt *stmt, *stmt_a;
+	uint32_t i, k;
+
+	stmt = ctx->stmt_matrix[from][merge->stmt[0]];
+	/* build concatenation of selectors, eg. ifname . ip daddr . tcp dport */
+	concat = concat_expr_alloc(&internal_location);
+
+	for (k = 0; k < merge->num_stmts; k++) {
+		stmt_a = ctx->stmt_matrix[from][merge->stmt[k]];
+		compound_expr_add(concat, expr_get(stmt_a->expr->left));
+	}
+	expr_free(stmt->expr->left);
+	stmt->expr->left = concat;
+
+	/* build set data contenation, eg. { eth0 . 1.1.1.1 . 22 } */
+	expr = set_expr_alloc(&internal_location, NULL);
+
+	for (i = from; i <= to; i++) {
+		concat = concat_expr_alloc(&internal_location);
+		for (k = 0; k < merge->num_stmts; k++) {
+			stmt_a = ctx->stmt_matrix[i][merge->stmt[k]];
+			compound_expr_add(concat, expr_get(stmt_a->expr->right));
+		}
+		elem = set_elem_expr_alloc(&internal_location, concat);
+		compound_expr_add(expr, elem);
+	}
+	expr_free(stmt->expr->right);
+	stmt->expr->right = expr;
+
+	for (k = 1; k < merge->num_stmts; k++) {
+		stmt_a = ctx->stmt_matrix[from][merge->stmt[k]];
+		list_del(&stmt_a->list);
+		stmt_free(stmt_a);
+	}
+}
+
 static void merge_rules(const struct optimize_ctx *ctx,
 			uint32_t from, uint32_t to,
 			const struct merge *merge)
@@ -224,7 +265,7 @@ static void merge_rules(const struct optimize_ctx *ctx,
 	uint32_t x;
 
 	if (merge->num_stmts > 1) {
-		return;
+		merge_multi_stmts(ctx, from, to, merge);
 	} else {
 		merge_stmts(ctx, from, to, merge);
 	}
-- 
2.30.2

