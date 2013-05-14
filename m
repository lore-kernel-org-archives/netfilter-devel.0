From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 6/7] expr: add support for expr list and capability to add it into a rule
Date: Tue, 14 May 2013 13:51:21 +0300
Message-ID: <1368528682-10041-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:38 -0400
In-Reply-To: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/expr.h |  7 +++++++
 include/libnftables/rule.h |  3 +++
 src/expr.c                 | 45 +++++++++++++++++++++++++++++++++++++++++++++
 src/internal.h             |  4 ++++
 src/libnftables.map        |  5 +++++
 src/rule.c                 | 12 ++++++++++++
 6 files changed, 76 insertions(+)

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index d899e41..4d789b4 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -27,6 +27,13 @@ uint32_t nft_rule_expr_get_u32(struct nft_rule_expr *expr, uint16_t type);
 uint64_t nft_rule_expr_get_u64(struct nft_rule_expr *expr, uint16_t type);
 const char *nft_rule_expr_get_str(struct nft_rule_expr *expr, uint16_t type);
 
+struct nft_rule_expr_list;
+
+struct nft_rule_expr_list *nft_rule_expr_list_alloc(void);
+void nft_rule_expr_list_free(struct nft_rule_expr_list *list);
+void nft_rule_expr_list_add(struct nft_rule_expr *expr, struct nft_rule_expr_list *list);
+void nft_rule_expr_list_add_list(struct nft_rule_expr_list *to_add, struct nft_rule_expr_list *list);
+
 void nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr);
 
 enum {
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index e7396a4..5c713ce 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -36,6 +36,9 @@ uint64_t nft_rule_attr_get_u64(struct nft_rule *r, uint16_t attr);
 
 void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr);
 
+struct nft_rule_expr_list;
+void nft_rule_add_expr_list(struct nft_rule *r, struct nft_rule_expr_list *list);
+
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
 
 enum {
diff --git a/src/expr.c b/src/expr.c
index 0b06aed..c73ac81 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -172,6 +172,51 @@ const char *nft_rule_expr_get_str(struct nft_rule_expr *expr, uint16_t type)
 }
 EXPORT_SYMBOL(nft_rule_expr_get_str);
 
+struct nft_rule_expr_list *nft_rule_expr_list_alloc(void)
+{
+	struct nft_rule_expr_list *list;
+
+	list = calloc(1, sizeof(struct nft_rule_expr_list));
+	if (list == NULL)
+		return NULL;
+
+	INIT_LIST_HEAD(&list->list);
+
+	return list;
+}
+EXPORT_SYMBOL(nft_rule_expr_list_alloc);
+
+void nft_rule_expr_list_free(struct nft_rule_expr_list *list)
+{
+	struct nft_rule_expr *e, *tmp;
+
+	list_for_each_entry_safe(e, tmp, &list->list, head) {
+		list_del(&e->head);
+		nft_rule_expr_free(e);
+	}
+	free(list);
+}
+EXPORT_SYMBOL(nft_rule_expr_list_free);
+
+void nft_rule_expr_list_add(struct nft_rule_expr *expr,
+			    struct nft_rule_expr_list *list)
+{
+	list_add_tail(&expr->head, &list->list);
+}
+EXPORT_SYMBOL(nft_rule_expr_list_add);
+
+void nft_rule_expr_list_add_list(struct nft_rule_expr_list *to_add,
+				 struct nft_rule_expr_list *list)
+{
+	struct nft_rule_expr *e, *tmp;
+
+	list_for_each_entry_safe(e, tmp, &to_add->list, head) {
+		list_del(&e->head);
+		list_add_tail(&e->head, &list->list);
+	}
+}
+EXPORT_SYMBOL(nft_rule_expr_list_add_list);
+
 void
 nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr)
 {
diff --git a/src/internal.h b/src/internal.h
index f5717ed..a93667e 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -22,6 +22,10 @@ struct nft_rule_expr {
 	uint8_t		data[];
 };
 
+struct nft_rule_expr_list {
+	struct list_head list;
+};
+
 struct nlattr;
 
 struct nft_set {
diff --git a/src/libnftables.map b/src/libnftables.map
index 3f98287..3cffb74 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -56,6 +56,7 @@ global:
   nft_rule_nlmsg_build_payload;
   nft_rule_nlmsg_parse;
   nft_rule_add_expr;
+  nft_rule_add_expr_list;
 
   nft_rule_expr_iter_create;
   nft_rule_expr_iter_next;
@@ -72,6 +73,10 @@ global:
   nft_rule_expr_get_u32;
   nft_rule_expr_get_u64;
   nft_rule_expr_get_str;
+  nft_rule_expr_list_alloc;
+  nft_rule_expr_list_free;
+  nft_rule_expr_list_add;
+  nft_rule_expr_list_add_list;
   nft_rule_expr_build_payload;
   nft_rule_expr_free;
 
diff --git a/src/rule.c b/src/rule.c
index 501b4f6..afc22d3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -258,6 +258,18 @@ void nft_rule_add_expr(struct nft_rule *r, struct nft_rule_expr *expr)
 }
 EXPORT_SYMBOL(nft_rule_add_expr);
 
+void nft_rule_add_expr_list(struct nft_rule *r,
+			    struct nft_rule_expr_list *list)
+{
+	struct nft_rule_expr *e, *tmp;
+
+	list_for_each_entry_safe(e, tmp, &list->list, head) {
+		list_del(&e->head);
+		list_add_tail(&e->head, &r->expr_list);
+	}
+}
+EXPORT_SYMBOL(nft_rule_add_expr_list);
+
 static int nft_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
-- 
1.8.2.1

