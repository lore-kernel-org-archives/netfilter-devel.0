From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 1/2] src: sort set elements in netlink_get_setelems()
Date: Fri, 6 Jan 2017 19:43:32 -0200
Message-ID: <20170106214331.GA3265@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34896 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753506AbdAFVnj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2017 16:43:39 -0500
Received: by mail-yw0-f194.google.com with SMTP id 17so5254041ywk.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jan 2017 13:43:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So users can better track their ruleset via git.

Without sorting, the elements can be listed in a different order
every time the set is created, generating unnecessary git changes.

Mergesort is used. Doesn't sort sets with 'flags interval' set on.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/expression.h |   1 +
 src/Makefile.am      |   1 +
 src/mergesort.c      | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c        |   4 +++
 4 files changed, 106 insertions(+)
 create mode 100644 src/mergesort.c

diff --git a/include/expression.h b/include/expression.h
index 71e9c43..ec90265 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -396,6 +396,7 @@ extern struct expr *range_expr_alloc(const struct location *loc,
 
 extern void compound_expr_add(struct expr *compound, struct expr *expr);
 extern void compound_expr_remove(struct expr *compound, struct expr *expr);
+extern void list_expr_sort(struct list_head *head);
 
 extern struct expr *concat_expr_alloc(const struct location *loc);
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 2a69e19..65cb4b4 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -53,6 +53,7 @@ nft_SOURCES =	main.c				\
 		mnl.c				\
 		iface.c				\
 		services.c			\
+		mergesort.c			\
 		scanner.l			\
 		parser_bison.y
 
diff --git a/src/mergesort.c b/src/mergesort.c
new file mode 100644
index 0000000..a835320
--- /dev/null
+++ b/src/mergesort.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2017 Elise Lennion <elise.lennion@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdint.h>
+#include <expression.h>
+#include <gmputil.h>
+#include <list.h>
+
+static int expr_msort_cmp(const struct expr *e1, const struct expr *e2);
+
+static int concat_expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+{
+	struct list_head *l = (&e2->expressions)->next;
+	const struct expr *i1, *i2;
+	int ret;
+
+	list_for_each_entry(i1, &e1->expressions, list) {
+		i2 = list_entry(l, typeof(struct expr), list);
+
+		ret = expr_msort_cmp(i1, i2);
+		if (ret)
+			return ret;
+
+		l = l->next;
+	}
+
+	return false;
+}
+
+static int expr_msort_cmp(const struct expr *e1, const struct expr *e2)
+{
+	switch (e1->ops->type) {
+	case EXPR_SET_ELEM:
+		return expr_msort_cmp(e1->key, e2->key);
+	case EXPR_VALUE:
+		return mpz_cmp(e1->value, e2->value);
+	case EXPR_CONCAT:
+		return concat_expr_msort_cmp(e1, e2);
+	case EXPR_MAPPING:
+		return expr_msort_cmp(e1->left, e2->left);
+	default:
+		BUG("Unknown expression %s\n", e1->ops->name);
+	}
+}
+
+static void list_splice_sorted(struct list_head *list, struct list_head *head)
+{
+	struct list_head *h = head->next;
+	struct list_head *l = list->next;
+
+	while (l != list) {
+		if (h == head ||
+		    expr_msort_cmp(list_entry(l, typeof(struct expr), list),
+				   list_entry(h, typeof(struct expr), list)) < 0) {
+			l = l->next;
+			list_add_tail(l->prev, h);
+			continue;
+		}
+
+		h = h->next;
+	}
+}
+
+static void list_cut_middle(struct list_head *list, struct list_head *head)
+{
+	struct list_head *s = head->next;
+	struct list_head *e = head->prev;
+
+	while (e != s) {
+		e = e->prev;
+
+		if (e != s)
+			s = s->next;
+	}
+
+	__list_cut_position(list, head, s);
+}
+
+void list_expr_sort(struct list_head *head)
+{
+	struct list_head *list;
+	LIST_HEAD(temp);
+
+	list = &temp;
+
+	if (list_empty(head) || list_is_singular(head))
+		return;
+
+	list_cut_middle(list, head);
+
+	list_expr_sort(head);
+	list_expr_sort(list);
+
+	list_splice_sorted(list, head);
+}
diff --git a/src/netlink.c b/src/netlink.c
index 5f478ff..4135f25 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1666,6 +1666,10 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	ctx->set = set;
 	set->init = set_expr_alloc(loc);
 	nftnl_set_elem_foreach(nls, list_setelem_cb, ctx);
+
+	if (!(set->flags & NFT_SET_INTERVAL))
+		list_expr_sort(&ctx->set->init->expressions);
+
 	nftnl_set_free(nls);
 	ctx->set = NULL;
 
-- 
2.7.4

