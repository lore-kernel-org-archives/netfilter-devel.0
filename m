From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/4] expression: Introduce compound_expr_last
Date: Wed, 12 Jul 2017 14:36:57 +0200
Message-ID: <20170712123658.25363-4-phil@nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43589 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756759AbdGLMhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:37:36 -0400
In-Reply-To: <20170712123658.25363-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function retrieves the last element in a compound expression.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/expression.h | 1 +
 src/expression.c     | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 68a36e8af792a..13ff5e981bed7 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -403,6 +403,7 @@ extern struct expr *range_expr_alloc(const struct location *loc,
 
 extern void compound_expr_add(struct expr *compound, struct expr *expr);
 extern void compound_expr_remove(struct expr *compound, struct expr *expr);
+extern struct expr *compound_expr_last(struct expr *compound);
 extern void list_expr_sort(struct list_head *head);
 
 extern struct expr *concat_expr_alloc(const struct location *loc);
diff --git a/src/expression.c b/src/expression.c
index d41ada39cc0ff..ac1373a7f11b6 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -700,6 +700,13 @@ void compound_expr_remove(struct expr *compound, struct expr *expr)
 	list_del(&expr->list);
 }
 
+struct expr *compound_expr_last(struct expr *compound)
+{
+	if (!compound->size)
+		return NULL;
+	return list_last_entry(&compound->expressions, struct expr, list);
+}
+
 static void concat_expr_destroy(struct expr *expr)
 {
 	concat_type_destroy(expr->dtype);
-- 
2.13.1

