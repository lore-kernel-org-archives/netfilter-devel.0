From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/5, V2, libnftnl] rule: Implement internal expression iterator
Date: Mon,  8 Aug 2016 14:42:32 +0200
Message-ID: <20160808124235.11135-2-carlosfg@riseup.net>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808124235.11135-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50006 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbcHHMnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 08:43:12 -0400
In-Reply-To: <20160808124235.11135-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce nftnl_expr_iter_init() to allow stack allocated iterators for
internal use.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/rule.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 30b8b5e..35b0f29 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -29,6 +29,14 @@
 #include <libnftnl/set.h>
 #include <libnftnl/expr.h>
 
+struct nftnl_expr_iter {
+	const struct nftnl_rule	*r;
+	struct nftnl_expr	*cur;
+};
+
+static void nftnl_expr_iter_init(const struct nftnl_rule *r,
+				 struct nftnl_expr_iter *iter);
+
 struct nftnl_rule {
 	struct list_head head;
 
@@ -1025,10 +1033,16 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
 }
 EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
 
-struct nftnl_expr_iter {
-	const struct nftnl_rule	*r;
-	struct nftnl_expr	*cur;
-};
+static void nftnl_expr_iter_init(const struct nftnl_rule *r,
+				 struct nftnl_expr_iter *iter)
+{
+	iter->r = r;
+	if (list_empty(&r->expr_list))
+		iter->cur = NULL;
+	else
+		iter->cur = list_entry(r->expr_list.next, struct nftnl_expr,
+				       head);
+}
 
 struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r)
 {
@@ -1037,13 +1051,7 @@ struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r)
 	iter = calloc(1, sizeof(struct nftnl_expr_iter));
 	if (iter == NULL)
 		return NULL;
-
-	iter->r = r;
-	if (list_empty(&r->expr_list))
-		iter->cur = NULL;
-	else
-		iter->cur = list_entry(r->expr_list.next, struct nftnl_expr,
-				       head);
+	nftnl_expr_iter_init(r, iter);
 
 	return iter;
 }
-- 
2.8.3

