From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH] rule: Constify rule iterators
Date: Mon,  8 Aug 2016 20:10:16 +0200
Message-ID: <20160808181016.4411-1-carlosfg@riseup.net>
References: <20160808144834.GB6264@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50599 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbcHHSKd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 14:10:33 -0400
In-Reply-To: <20160808144834.GB6264@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Iterators do not modify objects which they iterate, so input pointer must
be const.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/libnftnl/rule.h | 8 ++++----
 src/rule.c              | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 2776a77..e3bd6b8 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -70,7 +70,7 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
 
 struct nftnl_expr_iter;
 
-struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r);
+struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r);
 struct nftnl_expr *nftnl_expr_iter_next(struct nftnl_expr_iter *iter);
 void nftnl_expr_iter_destroy(struct nftnl_expr_iter *iter);
 
@@ -86,7 +86,7 @@ int nftnl_rule_list_foreach(struct nftnl_rule_list *rule_list, int (*cb)(struct
 
 struct nftnl_rule_list_iter;
 
-struct nftnl_rule_list_iter *nftnl_rule_list_iter_create(struct nftnl_rule_list *l);
+struct nftnl_rule_list_iter *nftnl_rule_list_iter_create(const struct nftnl_rule_list *l);
 struct nftnl_rule *nftnl_rule_list_iter_cur(struct nftnl_rule_list_iter *iter);
 struct nftnl_rule *nftnl_rule_list_iter_next(struct nftnl_rule_list_iter *iter);
 void nftnl_rule_list_iter_destroy(const struct nftnl_rule_list_iter *iter);
@@ -153,7 +153,7 @@ int nft_rule_expr_foreach(struct nft_rule *r,
 
 struct nft_rule_expr_iter;
 
-struct nft_rule_expr_iter *nft_rule_expr_iter_create(struct nft_rule *r);
+struct nft_rule_expr_iter *nft_rule_expr_iter_create(const struct nft_rule *r);
 struct nft_rule_expr *nft_rule_expr_iter_next(struct nft_rule_expr_iter *iter);
 void nft_rule_expr_iter_destroy(struct nft_rule_expr_iter *iter);
 
@@ -169,7 +169,7 @@ int nft_rule_list_foreach(struct nft_rule_list *rule_list, int (*cb)(struct nft_
 
 struct nft_rule_list_iter;
 
-struct nft_rule_list_iter *nft_rule_list_iter_create(struct nft_rule_list *l);
+struct nft_rule_list_iter *nft_rule_list_iter_create(const struct nft_rule_list *l);
 struct nft_rule *nft_rule_list_iter_cur(struct nft_rule_list_iter *iter);
 struct nft_rule *nft_rule_list_iter_next(struct nft_rule_list_iter *iter);
 void nft_rule_list_iter_destroy(struct nft_rule_list_iter *iter);
diff --git a/src/rule.c b/src/rule.c
index a0edca7..11fceca 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1026,11 +1026,11 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
 EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
 
 struct nftnl_expr_iter {
-	struct nftnl_rule		*r;
+	const struct nftnl_rule	*r;
 	struct nftnl_expr	*cur;
 };
 
-struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r)
+struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r)
 {
 	struct nftnl_expr_iter *iter;
 
@@ -1142,11 +1142,11 @@ int nftnl_rule_list_foreach(struct nftnl_rule_list *rule_list,
 EXPORT_SYMBOL_ALIAS(nftnl_rule_list_foreach, nft_rule_list_foreach);
 
 struct nftnl_rule_list_iter {
-	struct nftnl_rule_list	*list;
+	const struct nftnl_rule_list	*list;
 	struct nftnl_rule		*cur;
 };
 
-struct nftnl_rule_list_iter *nftnl_rule_list_iter_create(struct nftnl_rule_list *l)
+struct nftnl_rule_list_iter *nftnl_rule_list_iter_create(const struct nftnl_rule_list *l)
 {
 	struct nftnl_rule_list_iter *iter;
 
-- 
2.8.3

