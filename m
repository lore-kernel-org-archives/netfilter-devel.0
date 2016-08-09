From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH, v2] Constify iterators
Date: Tue,  9 Aug 2016 13:42:17 +0200
Message-ID: <20160809114217.16093-1-carlosfg@riseup.net>
References: <20160809071704.GB1866@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:59176 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbcHILm1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 07:42:27 -0400
In-Reply-To: <20160809071704.GB1866@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Iterators do not modify objects which they iterate, so input pointer must
be const.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/libnftnl/chain.h |  4 ++--
 include/libnftnl/rule.h  |  8 ++++----
 include/libnftnl/set.h   | 16 ++++++++--------
 include/libnftnl/table.h |  4 ++--
 src/chain.c              |  6 +++---
 src/rule.c               |  8 ++++----
 src/set.c                |  6 +++---
 src/set_elem.c           | 10 +++++-----
 src/table.c              |  6 +++---
 9 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index ed21e48..26460a6 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -81,7 +81,7 @@ void nftnl_chain_list_del(struct nftnl_chain *c);
 
 struct nftnl_chain_list_iter;
 
-struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(struct nftnl_chain_list *l);
+struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(const struct nftnl_chain_list *l);
 struct nftnl_chain *nftnl_chain_list_iter_next(struct nftnl_chain_list_iter *iter);
 void nftnl_chain_list_iter_destroy(struct nftnl_chain_list_iter *iter);
 
@@ -158,7 +158,7 @@ void nft_chain_list_del(struct nft_chain *c);
 
 struct nft_chain_list_iter;
 
-struct nft_chain_list_iter *nft_chain_list_iter_create(struct nft_chain_list *l);
+struct nft_chain_list_iter *nft_chain_list_iter_create(const struct nft_chain_list *l);
 struct nft_chain *nft_chain_list_iter_next(struct nft_chain_list_iter *iter);
 void nft_chain_list_iter_destroy(struct nft_chain_list_iter *iter);
 
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
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 5266b6f..adeb16c 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -71,8 +71,8 @@ void nftnl_set_list_del(struct nftnl_set *s);
 int nftnl_set_list_foreach(struct nftnl_set_list *set_list, int (*cb)(struct nftnl_set *t, void *data), void *data);
 
 struct nftnl_set_list_iter;
-struct nftnl_set_list_iter *nftnl_set_list_iter_create(struct nftnl_set_list *l);
-struct nftnl_set *nftnl_set_list_iter_cur(struct nftnl_set_list_iter *iter);
+struct nftnl_set_list_iter *nftnl_set_list_iter_create(const struct nftnl_set_list *l);
+struct nftnl_set *nftnl_set_list_iter_cur(const struct nftnl_set_list_iter *iter);
 struct nftnl_set *nftnl_set_list_iter_next(struct nftnl_set_list_iter *iter);
 void nftnl_set_list_iter_destroy(const struct nftnl_set_list_iter *iter);
 
@@ -133,8 +133,8 @@ int nftnl_set_elem_fprintf(FILE *fp, struct nftnl_set_elem *se, uint32_t type, u
 int nftnl_set_elem_foreach(struct nftnl_set *s, int (*cb)(struct nftnl_set_elem *e, void *data), void *data);
 
 struct nftnl_set_elems_iter;
-struct nftnl_set_elems_iter *nftnl_set_elems_iter_create(struct nftnl_set *s);
-struct nftnl_set_elem *nftnl_set_elems_iter_cur(struct nftnl_set_elems_iter *iter);
+struct nftnl_set_elems_iter *nftnl_set_elems_iter_create(const struct nftnl_set *s);
+struct nftnl_set_elem *nftnl_set_elems_iter_cur(const struct nftnl_set_elems_iter *iter);
 struct nftnl_set_elem *nftnl_set_elems_iter_next(struct nftnl_set_elems_iter *iter);
 void nftnl_set_elems_iter_destroy(struct nftnl_set_elems_iter *iter);
 
@@ -207,8 +207,8 @@ void nft_set_list_del(struct nft_set *s);
 int nft_set_list_foreach(struct nft_set_list *set_list, int (*cb)(struct nft_set *t, void *data), void *data);
 
 struct nft_set_list_iter;
-struct nft_set_list_iter *nft_set_list_iter_create(struct nft_set_list *l);
-struct nft_set *nft_set_list_iter_cur(struct nft_set_list_iter *iter);
+struct nft_set_list_iter *nft_set_list_iter_create(const struct nft_set_list *l);
+struct nft_set *nft_set_list_iter_cur(const struct nft_set_list_iter *iter);
 struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter);
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
 
@@ -269,8 +269,8 @@ int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint3
 int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_elem *e, void *data), void *data);
 
 struct nft_set_elems_iter;
-struct nft_set_elems_iter *nft_set_elems_iter_create(struct nft_set *s);
-struct nft_set_elem *nft_set_elems_iter_cur(struct nft_set_elems_iter *iter);
+struct nft_set_elems_iter *nft_set_elems_iter_create(const struct nft_set *s);
+struct nft_set_elem *nft_set_elems_iter_cur(const struct nft_set_elems_iter *iter);
 struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter);
 void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter);
 
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 1f9ab1c..296667b 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -69,7 +69,7 @@ void nftnl_table_list_del(struct nftnl_table *r);
 
 struct nftnl_table_list_iter;
 
-struct nftnl_table_list_iter *nftnl_table_list_iter_create(struct nftnl_table_list *l);
+struct nftnl_table_list_iter *nftnl_table_list_iter_create(const struct nftnl_table_list *l);
 struct nftnl_table *nftnl_table_list_iter_next(struct nftnl_table_list_iter *iter);
 void nftnl_table_list_iter_destroy(const struct nftnl_table_list_iter *iter);
 
@@ -134,7 +134,7 @@ void nft_table_list_del(struct nft_table *r);
 
 struct nft_table_list_iter;
 
-struct nft_table_list_iter *nft_table_list_iter_create(struct nft_table_list *l);
+struct nft_table_list_iter *nft_table_list_iter_create(const struct nft_table_list *l);
 struct nft_table *nft_table_list_iter_next(struct nft_table_list_iter *iter);
 void nft_table_list_iter_destroy(struct nft_table_list_iter *iter);
 
diff --git a/src/chain.c b/src/chain.c
index 4c562fe..2c6ae70 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -1039,11 +1039,11 @@ int nftnl_chain_list_foreach(struct nftnl_chain_list *chain_list,
 EXPORT_SYMBOL_ALIAS(nftnl_chain_list_foreach, nft_chain_list_foreach);
 
 struct nftnl_chain_list_iter {
-	struct nftnl_chain_list	*list;
-	struct nftnl_chain	*cur;
+	const struct nftnl_chain_list	*list;
+	struct nftnl_chain		*cur;
 };
 
-struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(struct nftnl_chain_list *l)
+struct nftnl_chain_list_iter *nftnl_chain_list_iter_create(const struct nftnl_chain_list *l)
 {
 	struct nftnl_chain_list_iter *iter;
 
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
 
diff --git a/src/set.c b/src/set.c
index 8a592db..19ab371 100644
--- a/src/set.c
+++ b/src/set.c
@@ -1175,11 +1175,11 @@ int nftnl_set_list_foreach(struct nftnl_set_list *set_list,
 EXPORT_SYMBOL_ALIAS(nftnl_set_list_foreach, nft_set_list_foreach);
 
 struct nftnl_set_list_iter {
-	struct nftnl_set_list	*list;
+	const struct nftnl_set_list	*list;
 	struct nftnl_set		*cur;
 };
 
-struct nftnl_set_list_iter *nftnl_set_list_iter_create(struct nftnl_set_list *l)
+struct nftnl_set_list_iter *nftnl_set_list_iter_create(const struct nftnl_set_list *l)
 {
 	struct nftnl_set_list_iter *iter;
 
@@ -1197,7 +1197,7 @@ struct nftnl_set_list_iter *nftnl_set_list_iter_create(struct nftnl_set_list *l)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_list_iter_create, nft_set_list_iter_create);
 
-struct nftnl_set *nftnl_set_list_iter_cur(struct nftnl_set_list_iter *iter)
+struct nftnl_set *nftnl_set_list_iter_cur(const struct nftnl_set_list_iter *iter)
 {
 	return iter->cur;
 }
diff --git a/src/set_elem.c b/src/set_elem.c
index 7908661..ecda18f 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -274,7 +274,7 @@ void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 }
 
 static void nftnl_set_elem_nlmsg_build_def(struct nlmsghdr *nlh,
-					 struct nftnl_set *s)
+					   const struct nftnl_set *s)
 {
 	if (s->flags & (1 << NFTNL_SET_NAME))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_SET, s->name);
@@ -840,12 +840,12 @@ int nftnl_set_elem_foreach(struct nftnl_set *s,
 EXPORT_SYMBOL_ALIAS(nftnl_set_elem_foreach, nft_set_elem_foreach);
 
 struct nftnl_set_elems_iter {
-	struct nftnl_set			*set;
-	struct list_head		*list;
+	const struct nftnl_set		*set;
+	const struct list_head		*list;
 	struct nftnl_set_elem		*cur;
 };
 
-struct nftnl_set_elems_iter *nftnl_set_elems_iter_create(struct nftnl_set *s)
+struct nftnl_set_elems_iter *nftnl_set_elems_iter_create(const struct nftnl_set *s)
 {
 	struct nftnl_set_elems_iter *iter;
 
@@ -865,7 +865,7 @@ struct nftnl_set_elems_iter *nftnl_set_elems_iter_create(struct nftnl_set *s)
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elems_iter_create, nft_set_elems_iter_create);
 
-struct nftnl_set_elem *nftnl_set_elems_iter_cur(struct nftnl_set_elems_iter *iter)
+struct nftnl_set_elem *nftnl_set_elems_iter_cur(const struct nftnl_set_elems_iter *iter)
 {
 	return iter->cur;
 }
diff --git a/src/table.c b/src/table.c
index 3d4d7b9..55ec4e1 100644
--- a/src/table.c
+++ b/src/table.c
@@ -544,11 +544,11 @@ int nftnl_table_list_foreach(struct nftnl_table_list *table_list,
 EXPORT_SYMBOL_ALIAS(nftnl_table_list_foreach, nft_table_list_foreach);
 
 struct nftnl_table_list_iter {
-	struct nftnl_table_list	*list;
-	struct nftnl_table	*cur;
+	const struct nftnl_table_list	*list;
+	struct nftnl_table		*cur;
 };
 
-struct nftnl_table_list_iter *nftnl_table_list_iter_create(struct nftnl_table_list *l)
+struct nftnl_table_list_iter *nftnl_table_list_iter_create(const struct nftnl_table_list *l)
 {
 	struct nftnl_table_list_iter *iter;
 
-- 
2.8.3

