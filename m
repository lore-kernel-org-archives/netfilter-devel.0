From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 3/3] src: add low-level ruleset API
Date: Mon, 30 Sep 2013 17:06:02 +0200
Message-ID: <20130930150602.32124.86409.stgit@nfdev.cica.es>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43587 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755991Ab3I3PGK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:06:10 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id B61DA51ED61
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 15:06:07 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QlZoE5VVq-6W for <netfilter-devel@vger.kernel.org>;
	Mon, 30 Sep 2013 17:06:07 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id A544C51ED66
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 17:06:06 +0200 (CEST)
In-Reply-To: <20130930150551.32124.23680.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a low level ruleset API for libnftables.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 0 files changed

diff --git a/include/libnftables/Makefile.am b/include/libnftables/Makefile.am
index b052992..e243f32 100644
--- a/include/libnftables/Makefile.am
+++ b/include/libnftables/Makefile.am
@@ -2,4 +2,5 @@ pkginclude_HEADERS = table.h		\
 		     chain.h		\
 		     rule.h		\
 		     expr.h		\
-		     set.h
+		     set.h		\
+		     ruleset.h
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
new file mode 100644
index 0000000..a4a1279
--- /dev/null
+++ b/include/libnftables/ruleset.h
@@ -0,0 +1,45 @@
+#ifndef _RULESET_H_
+#define _RULESET_H_
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+struct nft_ruleset;
+
+struct nft_ruleset *nft_ruleset_alloc(void);
+void nft_ruleset_free(struct nft_ruleset *r);
+
+enum {
+	NFT_RULESET_ATTR_TABLELIST = 0,
+	NFT_RULESET_ATTR_CHAINLIST,
+	NFT_RULESET_ATTR_SETLIST,
+	NFT_RULESET_ATTR_RULELIST,
+};
+
+bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr);
+void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr);
+void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
+const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
+
+enum {
+	NFT_RULESET_O_DEFAULT	= 0,
+	NFT_RULESET_O_XML,
+	NFT_RULESET_O_JSON,
+};
+
+enum nft_ruleset_parse_type {
+	NFT_RULESET_PARSE_NONE	= 0,
+	NFT_RULESET_PARSE_XML,
+	NFT_RULESET_PARSE_JSON,
+	NFT_RULESET_PARSE_MAX,
+};
+
+int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_ruleset_parse_type type, const char *data);
+int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
+
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
+#endif /* _RULESET_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index 51b40a2..474dbf0 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -10,6 +10,7 @@ libnftables_la_SOURCES = utils.c		\
 			 rule.c			\
 			 set.c			\
 			 set_elem.c		\
+			 ruleset.c		\
 			 mxml.c			\
 			 jansson.c		\
 			 expr.c			\
diff --git a/src/chain.c b/src/chain.c
index 874116a..f831479 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -506,7 +506,7 @@ static inline int nft_str2hooknum(int family, const char *hook)
 }
 
 #ifdef JSON_PARSING
-static int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree)
+int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree)
 {
 	json_t *root;
 	uint64_t uval64;
diff --git a/src/internal.h b/src/internal.h
index df64dd8..b29288a 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -71,6 +71,14 @@ int nft_jansson_data_reg_parse(json_t *root, const char *tag,
 			       union nft_data_reg *data_reg);
 struct nft_set_elem;
 int nft_set_elem_json_parse(struct nft_set_elem *e, json_t *root);
+struct nft_table;
+int nft_jansson_parse_table(struct nft_table *t, json_t *tree);
+struct nft_chain;
+int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree);
+struct nft_rule;
+int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree);
+struct nft_set;
+int nft_jansson_parse_set(struct nft_set *s, json_t *tree);
 #endif
 
 const char *nft_family2str(uint32_t family);
diff --git a/src/libnftables.map b/src/libnftables.map
index 963c03e..1223403 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -168,5 +168,14 @@ global:
   nft_set_elems_iter_next;
   nft_set_elems_iter_destroy;
 
+  nft_ruleset_alloc;
+  nft_ruleset_free;
+  nft_ruleset_attr_is_set;
+  nft_ruleset_attr_unset;
+  nft_ruleset_attr_set;
+  nft_ruleset_attr_get;
+  nft_ruleset_parse;
+  nft_ruleset_snprintf;
+
 local: *;
 };
diff --git a/src/rule.c b/src/rule.c
index 550b325..7f2bce6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -470,7 +470,7 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
 
 #ifdef JSON_PARSING
-static int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
+int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
 {
 	json_t *root, *array;
 	struct nft_rule_expr *e;
diff --git a/src/ruleset.c b/src/ruleset.c
new file mode 100644
index 0000000..bbfcbb0
--- /dev/null
+++ b/src/ruleset.c
@@ -0,0 +1,813 @@
+/*
+ * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2013 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <errno.h>
+
+#include "internal.h"
+
+#include <libmnl/libmnl.h>
+#include <libnftables/ruleset.h>
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/set.h>
+#include <libnftables/rule.h>
+
+struct nft_ruleset {
+	struct nft_table_list	*table_list;
+	struct nft_chain_list	*chain_list;
+	struct nft_set_list	*set_list;
+	struct nft_rule_list	*rule_list;
+
+	uint16_t		flags;
+};
+
+struct nft_ruleset *nft_ruleset_alloc(void)
+{
+	return calloc(1, sizeof(struct nft_ruleset));
+}
+EXPORT_SYMBOL(nft_ruleset_alloc);
+
+void nft_ruleset_free(struct nft_ruleset *r)
+{
+	if (r->flags & (1 << NFT_RULESET_ATTR_TABLELIST))
+		nft_table_list_free(r->table_list);
+	if (r->flags & (1 << NFT_RULESET_ATTR_CHAINLIST))
+		nft_chain_list_free(r->chain_list);
+	if (r->flags & (1 << NFT_RULESET_ATTR_SETLIST))
+		nft_set_list_free(r->set_list);
+	if (r->flags & (1 << NFT_RULESET_ATTR_RULELIST))
+		nft_rule_list_free(r->rule_list);
+	xfree(r);
+}
+EXPORT_SYMBOL(nft_ruleset_free);
+
+bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr)
+{
+	return r->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_attr_is_set);
+
+void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr)
+{
+	if (!(r->flags & (1 << attr)))
+		return;
+
+	switch (attr) {
+	case NFT_RULESET_ATTR_TABLELIST:
+		nft_table_list_free(r->table_list);
+		r->table_list = NULL;
+		break;
+	case NFT_RULESET_ATTR_CHAINLIST:
+		nft_chain_list_free(r->chain_list);
+		r->chain_list = NULL;
+		break;
+	case NFT_RULESET_ATTR_SETLIST:
+		nft_set_list_free(r->set_list);
+		r->set_list = NULL;
+		break;
+	case NFT_RULESET_ATTR_RULELIST:
+		nft_rule_list_free(r->rule_list);
+		r->rule_list = NULL;
+		break;
+	}
+	r->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_attr_unset);
+
+void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data)
+{
+	switch (attr) {
+	case NFT_RULESET_ATTR_TABLELIST:
+		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_TABLELIST);
+		r->table_list = data;
+		break;
+	case NFT_RULESET_ATTR_CHAINLIST:
+		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_CHAINLIST);
+		r->chain_list = data;
+		break;
+	case NFT_RULESET_ATTR_SETLIST:
+		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_SETLIST);
+		r->set_list = data;
+		break;
+	case NFT_RULESET_ATTR_RULELIST:
+		nft_ruleset_attr_unset(r, NFT_RULESET_ATTR_RULELIST);
+		r->rule_list = data;
+		break;
+	default:
+		return;
+	}
+	r->flags |= (1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_attr_set);
+
+const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
+{
+	if (!(r->flags & (1 << attr)))
+		return NULL;
+
+	switch (attr) {
+	case NFT_RULESET_ATTR_TABLELIST:
+		return r->table_list;
+	case NFT_RULESET_ATTR_CHAINLIST:
+		return r->chain_list;
+	case NFT_RULESET_ATTR_SETLIST:
+		return r->set_list;
+	case NFT_RULESET_ATTR_RULELIST:
+		return r->rule_list;
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL(nft_ruleset_attr_get);
+
+#ifdef JSON_PARSING
+static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_t *array)
+{
+	int i, len;
+	json_t *node;
+	struct nft_table *o;
+	struct nft_table_list *list = nft_table_list_alloc();
+
+	if (list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			goto err;
+		}
+
+		if (!(nft_jansson_node_exist(node, "table")))
+			continue;
+
+		o = nft_table_alloc();
+		if (o == NULL) {
+			errno = ENOMEM;
+			goto err;
+		}
+
+		if (nft_jansson_parse_table(o, node) < 0) {
+			nft_table_free(o);
+			goto err;
+		}
+
+		nft_table_list_add_tail(o, list);
+	}
+
+	if (!nft_table_list_is_empty(list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, list);
+	else
+		nft_table_list_free(list);
+
+	return 0;
+err:
+	nft_table_list_free(list);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_t *array)
+{
+	int i, len;
+	json_t *node;
+	struct nft_chain *o;
+	struct nft_chain_list *list = nft_chain_list_alloc();
+
+	if (list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			goto err;
+		}
+
+		if (!(nft_jansson_node_exist(node, "chain")))
+			continue;
+
+		o = nft_chain_alloc();
+		if (o == NULL) {
+			errno = ENOMEM;
+			goto err;
+		}
+
+		if (nft_jansson_parse_chain(o, node) < 0) {
+			nft_chain_free(o);
+			goto err;
+		}
+
+		nft_chain_list_add_tail(o, list);
+	}
+
+	if (!nft_chain_list_is_empty(list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, list);
+	else
+		nft_chain_list_free(list);
+
+	return 0;
+err:
+	nft_chain_list_free(list);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array)
+{
+	int i, len;
+	json_t *node;
+	struct nft_set *s = NULL;
+	struct nft_set_list *list = nft_set_list_alloc();
+
+	if (list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			goto err;
+		}
+
+		if (!(nft_jansson_node_exist(node, "set")))
+			continue;
+
+		s = nft_set_alloc();
+		if (s == NULL) {
+			errno = ENOMEM;
+			goto err;
+		}
+
+		if (nft_jansson_parse_set(s, node) < 0) {
+			nft_set_free(s);
+			goto err;
+		}
+
+		nft_set_list_add_tail(s, list);
+	}
+
+	if (!nft_set_list_is_empty(list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, list);
+	else
+		nft_set_list_free(list);
+
+	return 0;
+err:
+	nft_set_list_free(list);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t *array)
+{
+	int i, len;
+	json_t *node;
+	struct nft_rule *o = NULL;
+	struct nft_rule_list *list = nft_rule_list_alloc();
+
+	if (list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			goto err;
+		}
+
+		if (!(nft_jansson_node_exist(node, "rule")))
+			continue;
+
+		o = nft_rule_alloc();
+		if (o == NULL) {
+			errno = ENOMEM;
+			goto err;
+		}
+
+		if (nft_jansson_parse_rule(o, node) < 0) {
+			nft_rule_free(o);
+			goto err;
+		}
+
+		nft_rule_list_add_tail(o, list);
+	}
+
+	if (!nft_rule_list_is_empty(list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, list);
+	else
+		nft_rule_list_free(list);
+
+	return 0;
+err:
+	nft_rule_list_free(list);
+	return -1;
+}
+
+#endif
+
+static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *json)
+{
+#ifdef JSON_PARSING
+	json_t *root, *array;
+	json_error_t error;
+
+	root = nft_jansson_create_root(json, &error);
+	if (root == NULL)
+		return -1;
+
+	array = json_object_get(root, "nftables");
+	if (array == NULL) {
+		errno = EINVAL;
+		goto err;
+	}
+
+	if (nft_ruleset_json_parse_tables(rs, array) != 0)
+		goto err;
+
+	if (nft_ruleset_json_parse_chains(rs, array) != 0)
+		goto err;
+
+	if (nft_ruleset_json_parse_sets(rs, array) != 0)
+		goto err;
+
+	if (nft_ruleset_json_parse_rules(rs, array) != 0)
+		goto err;
+
+	nft_jansson_free_root(root);
+	return 0;
+err:
+	nft_jansson_free_root(root);
+	return -1;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+#ifdef XML_PARSING
+static int
+nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree)
+{
+	mxml_node_t *node;
+	struct nft_table *t;
+	struct nft_table_list *table_list = nft_table_list_alloc();
+	if (table_list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	for (node = mxmlFindElement(tree, tree, "table", NULL, NULL,
+				    MXML_DESCEND_FIRST);
+	     node != NULL;
+	     node = mxmlFindElement(node, tree, "table", NULL, NULL,
+				    MXML_NO_DESCEND)) {
+		t = nft_table_alloc();
+		if (t == NULL)
+			goto err_free;
+
+		if (nft_mxml_table_parse(node, t) != 0) {
+			nft_table_free(t);
+			goto err_free;
+		}
+
+		nft_table_list_add_tail(t, table_list);
+	}
+
+	if (!nft_table_list_is_empty(table_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST,
+				     table_list);
+	else
+		nft_table_list_free(table_list);
+
+	return 0;
+err_free:
+	nft_table_list_free(table_list);
+	return -1;
+}
+
+static int
+nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree)
+{
+	mxml_node_t *node;
+	struct nft_chain *c;
+	struct nft_chain_list *chain_list = nft_chain_list_alloc();
+	if (chain_list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	for (node = mxmlFindElement(tree, tree, "chain", NULL, NULL,
+				    MXML_DESCEND_FIRST);
+	     node != NULL;
+	     node = mxmlFindElement(node, tree, "chain", NULL, NULL,
+				    MXML_NO_DESCEND)) {
+		c = nft_chain_alloc();
+		if (c == NULL)
+			goto err_free;
+
+		if (nft_mxml_chain_parse(node, c) != 0) {
+			nft_chain_free(c);
+			goto err_free;
+		}
+
+		nft_chain_list_add_tail(c, chain_list);
+	}
+
+	if (!nft_chain_list_is_empty(chain_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST,
+				     chain_list);
+	else
+		nft_chain_list_free(chain_list);
+
+	return 0;
+err_free:
+	nft_chain_list_free(chain_list);
+	return -1;
+}
+
+static int
+nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree)
+{
+	mxml_node_t *node;
+	struct nft_set *s;
+	struct nft_set_list *set_list = nft_set_list_alloc();
+	if (set_list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	for (node = mxmlFindElement(tree, tree, "set", NULL, NULL,
+				    MXML_DESCEND_FIRST);
+	     node != NULL;
+	     node = mxmlFindElement(node, tree, "set", NULL, NULL,
+				    MXML_NO_DESCEND)) {
+		s = nft_set_alloc();
+		if (s == NULL)
+			goto err_free;
+
+		if (nft_mxml_set_parse(node, s) != 0) {
+			nft_set_free(s);
+			goto err_free;
+		}
+
+		nft_set_list_add_tail(s, set_list);
+	}
+
+	if (!nft_set_list_is_empty(set_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, set_list);
+	else
+		nft_set_list_free(set_list);
+
+	return 0;
+err_free:
+	nft_set_list_free(set_list);
+	return -1;
+}
+
+static int
+nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree)
+{
+	mxml_node_t *node;
+	struct nft_rule *r;
+	struct nft_rule_list *rule_list = nft_rule_list_alloc();
+	if (rule_list == NULL) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	for (node = mxmlFindElement(tree, tree, "rule", NULL, NULL,
+				    MXML_DESCEND_FIRST);
+	     node != NULL;
+	     node = mxmlFindElement(node, tree, "rule", NULL, NULL,
+				    MXML_NO_DESCEND)) {
+		r = nft_rule_alloc();
+		if (r == NULL)
+			goto err_free;
+
+		if (nft_mxml_rule_parse(node, r) != 0) {
+			nft_rule_free(r);
+			goto err_free;
+		}
+
+		nft_rule_list_add_tail(r, rule_list);
+	}
+
+	if (!nft_rule_list_is_empty(rule_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, rule_list);
+	else
+		nft_rule_list_free(rule_list);
+
+	return 0;
+err_free:
+	nft_rule_list_free(rule_list);
+	return -1;
+}
+#endif
+
+static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char *xml)
+{
+#ifdef XML_PARSING
+	mxml_node_t *tree;
+
+	tree = nft_mxml_build_tree(xml, "nftables");
+	if (tree == NULL)
+		return -1;
+
+	if (nft_ruleset_xml_parse_tables(rs, tree) != 0)
+		goto err;
+
+	if (nft_ruleset_xml_parse_chains(rs, tree) != 0)
+		goto err;
+
+	if (nft_ruleset_xml_parse_sets(rs, tree) != 0)
+		goto err;
+
+	if (nft_ruleset_xml_parse_rules(rs, tree) != 0)
+		goto err;
+
+	mxmlDelete(tree);
+	return 0;
+err:
+	mxmlDelete(tree);
+	return -1;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+int nft_ruleset_parse(struct nft_ruleset *r, enum nft_ruleset_parse_type type,
+		      const char *data)
+{
+	int ret;
+
+	switch (type) {
+	case NFT_RULESET_PARSE_XML:
+		ret = nft_ruleset_xml_parse(r, data);
+		break;
+	case NFT_RULESET_PARSE_JSON:
+		ret = nft_ruleset_json_parse(r, data);
+		break;
+	default:
+		ret = -1;
+		errno = EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_ruleset_parse);
+
+static int separator_snprintf(char *buf, size_t size, void *obj, uint32_t type)
+{
+	if (obj == NULL)
+		return 0;
+
+	switch (type) {
+	case NFT_RULESET_O_JSON:
+		return snprintf(buf, size, ",");
+	case NFT_RULESET_O_DEFAULT:
+		return snprintf(buf, size, "\n");
+	default:
+		return 0;
+	}
+}
+
+static int
+nft_ruleset_snprintf_table(char *buf, size_t size,
+			   const struct nft_ruleset *rs, uint32_t type,
+			   uint32_t flags)
+{
+	struct nft_table *t;
+	struct nft_table_list_iter *ti;
+	int ret, len = size, offset = 0;
+
+	ti = nft_table_list_iter_create(rs->table_list);
+	if (ti == NULL)
+		return 0;
+
+	t = nft_table_list_iter_next(ti);
+	while (t != NULL) {
+		ret = nft_table_snprintf(buf+offset, len, t, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		t = nft_table_list_iter_next(ti);
+		ret = separator_snprintf(buf+offset, len, t, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	nft_table_list_iter_destroy(ti);
+
+	return offset;
+}
+
+static int
+nft_ruleset_snprintf_chain(char *buf, size_t size,
+			   const struct nft_ruleset *rs, uint32_t type,
+			   uint32_t flags)
+{
+	struct nft_chain *c;
+	struct nft_chain_list_iter *ci;
+	int ret, len = size, offset = 0;
+
+	ci = nft_chain_list_iter_create(rs->chain_list);
+	if (ci == NULL)
+		return 0;
+
+	c = nft_chain_list_iter_next(ci);
+	while (c != NULL) {
+		ret = nft_chain_snprintf(buf+offset, len, c, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		c = nft_chain_list_iter_next(ci);
+		ret = separator_snprintf(buf+offset, len, c, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	nft_chain_list_iter_destroy(ci);
+
+	return offset;
+}
+
+static int
+nft_ruleset_snprintf_set(char *buf, size_t size,
+			 const struct nft_ruleset *rs, uint32_t type,
+			 uint32_t flags)
+{
+	struct nft_set *s;
+	struct nft_set_list_iter *si;
+	int ret, len = size, offset = 0;
+
+	si = nft_set_list_iter_create(rs->set_list);
+	if (si == NULL)
+		return 0;
+
+	s = nft_set_list_iter_next(si);
+	while (s != NULL) {
+		ret = nft_set_snprintf(buf+offset, len, s, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		s = nft_set_list_iter_next(si);
+		ret = separator_snprintf(buf+offset, len, s, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	nft_set_list_iter_destroy(si);
+
+	return offset;
+}
+
+static int
+nft_ruleset_snprintf_rule(char *buf, size_t size,
+			  const struct nft_ruleset *rs, uint32_t type,
+			  uint32_t flags)
+{
+	struct nft_rule *r;
+	struct nft_rule_list_iter *ri;
+	int ret, len = size, offset = 0;
+
+	ri = nft_rule_list_iter_create(rs->rule_list);
+	if (ri == NULL)
+		return 0;
+
+	r = nft_rule_list_iter_next(ri);
+	while (r != NULL) {
+		ret = nft_rule_snprintf(buf+offset, len, r, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		r = nft_rule_list_iter_next(ri);
+		ret = separator_snprintf(buf+offset, len, r, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+	nft_rule_list_iter_destroy(ri);
+
+	return offset;
+}
+
+static int
+nft_ruleset_do_snprintf(char *buf, size_t size, const struct nft_ruleset *rs,
+			uint32_t type, uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+	void *prev = NULL;
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST) && 
+	    (!nft_table_list_is_empty(rs->table_list))) {
+		ret = nft_ruleset_snprintf_table(buf+offset, len, rs,
+						 type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (ret > 0)
+			prev = rs->table_list;
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST) &&
+	    (!nft_chain_list_is_empty(rs->chain_list))) {
+		ret = separator_snprintf(buf+offset, len, prev, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_ruleset_snprintf_chain(buf+offset, len, rs,
+						 type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (ret > 0)
+			prev = rs->chain_list;
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST) &&
+	    (!nft_set_list_is_empty(rs->set_list))) {
+		ret = separator_snprintf(buf+offset, len, prev, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_ruleset_snprintf_set(buf+offset, len, rs,
+					       type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		if (ret > 0)
+			prev = rs->set_list;
+	}
+
+	if (nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST) &&
+	    (!nft_rule_list_is_empty(rs->rule_list))) {
+		ret = separator_snprintf(buf+offset, len, prev, type);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_ruleset_snprintf_rule(buf+offset, len, rs,
+						type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int
+nft_ruleset_snprintf_xml(char *buf, size_t size, const struct nft_ruleset *rs,
+			 uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size, "<nftables>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_ruleset_do_snprintf(buf+offset, len, rs, NFT_RULESET_O_XML,
+				      flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, "</nftables>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
+nft_ruleset_snprintf_json(char *buf, size_t size, const struct nft_ruleset *rs,
+			  uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size, "{ \"nftables\": [");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_ruleset_do_snprintf(buf+offset, len, rs, NFT_RULESET_O_JSON,
+				      flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, "]}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *r,
+			 uint32_t type, uint32_t flags)
+{
+	switch (type) {
+	case NFT_RULESET_O_DEFAULT:
+		return nft_ruleset_do_snprintf(buf, size, r, type, flags);
+	case NFT_RULESET_O_XML:
+		return nft_ruleset_snprintf_xml(buf, size, r, flags);
+	case NFT_RULESET_O_JSON:
+		return nft_ruleset_snprintf_json(buf, size, r, flags);
+	default:
+		break;
+	}
+	return -1;
+}
+EXPORT_SYMBOL(nft_ruleset_snprintf);
diff --git a/src/set.c b/src/set.c
index 1b81c6c..31185a0 100644
--- a/src/set.c
+++ b/src/set.c
@@ -304,7 +304,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
 
 #ifdef JSON_PARSING
-static int nft_jansson_parse_set(struct nft_set *s, json_t *tree)
+int nft_jansson_parse_set(struct nft_set *s, json_t *tree)
 {
 	json_t *root, *array, *json_elem;
 	uint32_t uval32;
diff --git a/src/table.c b/src/table.c
index 93d7745..5046d44 100644
--- a/src/table.c
+++ b/src/table.c
@@ -272,7 +272,7 @@ static int nft_table_xml_parse(struct nft_table *t, const char *xml)
 }
 
 #ifdef JSON_PARSING
-static int nft_jansson_parse_table(struct nft_table *t, json_t *tree)
+int nft_jansson_parse_table(struct nft_table *t, json_t *tree)
 {
 	json_t *root;
 	uint32_t flags;
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-ruleset.json
new file mode 100644
index 0000000..b68b19c
--- /dev/null
+++ b/tests/jsonfiles/64-ruleset.json
@@ -0,0 +1,2 @@
+{ "nftables": [{ "table" : {"name" : "filter","family" : "ip","flags" : 0}},{ "table" : {"name" : "filter2","family" : "ip6","flags" : 0}},{ "chain": {"name": "input","handle": 1,"bytes": 10681449,"packets": 16216,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum": "input","prio": 0,"policy": "accept"}},{ "chain": {"name": "forward","handle": 2,"bytes": 0,"packets": 0,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum": "forward","prio": 0,"policy": "accept"}},{ "chain": {"name": "output","handle": 3,"bytes": 2375830,"packets": 15184,"family": "ip","table": "filter","use": 0,"type": "filter","hooknum": "output","prio": 0,"policy": "accept"}},{ "chain": {"name": "chain1","handle": 4,"bytes": 0,"packets": 0,"family": "ip","table": "filter","use": 0}},{ "se
 t": { "name": "set0","table": "filter","flags": 3,"family": "ip","key_type": 12,"key_len": 2}},{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", "handle" : 6,"flags" : 0,
  "expr" : [ { "type" : "payload", "dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}, { "type" : "immediate", "dreg" : 0, "immediatedata" : {"data_reg": {"type" : "verdict", "verdict" : "drop"}}}]}},{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", "handle" : 9,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, "offset" : 9, "len" : 1, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 1, "data0" : "0x00000006"}}}, { "type" : "payload", "dreg" : 1, "offset" : 2, "len" : 2, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" 
 : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 2, "data0" : "0x00001600"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}},{ "rule": { "family" : "ip", "table" : "filter", 
 "chain"  : "output", "handle" : 10,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}]}},{ "rule": { "family" : "ip", "table" : "filter", "chain"  : "output", "handle" : 11,"flags" : 0, "expr" : [ { "type" : "payload", "dreg" : 1, "offset" : 16, "len" : 4, "base" : "link"}, { "type" : "cmp", "sreg" : 1, "op" : "eq", "cmpdata" : {"data_reg": { "type" : "value", "len" : 4, "data0" : "0x0100a8c0"}}}, { "type" : "counter", "pkts" : 0, "bytes" : 0}, { "type" : "immediate", "dreg" : 0, "immediatedata" : {"data_reg": {"type" : "verdict", "verdict" : "drop"}}}]}}]}
+
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 4e3b508..1eec547 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -6,6 +6,7 @@
 #include <errno.h>
 
 #include <libmnl/libmnl.h> /*nlmsghdr*/
+#include <libnftables/ruleset.h>
 #include <libnftables/table.h>
 #include <libnftables/chain.h>
 #include <libnftables/rule.h>
@@ -24,10 +25,12 @@ enum {
 	TEST_XML_CHAIN,
 	TEST_XML_RULE,
 	TEST_XML_SET,
+	TEST_XML_RULESET,
 	TEST_JSON_TABLE,
 	TEST_JSON_CHAIN,
 	TEST_JSON_RULE,
 	TEST_JSON_SET,
+	TEST_JSON_RULESET,
 };
 
 #if defined(XML_PARSING) || defined(JSON_PARSING)
@@ -76,6 +79,7 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	struct nft_chain *c = NULL;
 	struct nft_rule *r = NULL;
 	struct nft_set *s = NULL;
+	struct nft_ruleset *rs = NULL;
 	char orig[4096];
 	char out[4096];
 	FILE *fp;
@@ -97,6 +101,10 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	case TEST_JSON_SET:
 		s = (struct nft_set *)input;
 		break;
+	case TEST_XML_RULESET:
+	case TEST_JSON_RULESET:
+		rs = (struct nft_ruleset *)input;
+		break;
 	default:
 		errno = EINVAL;
 		return -1;
@@ -127,6 +135,14 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	case TEST_JSON_SET:
 		nft_set_snprintf(out, sizeof(out), s, NFT_SET_O_JSON, 0);
 		break;
+	case TEST_XML_RULESET:
+		nft_ruleset_snprintf(out, sizeof(out), rs,
+				     NFT_RULESET_O_XML, 0);
+		break;
+	case TEST_JSON_RULESET:
+		nft_ruleset_snprintf(out, sizeof(out), rs,
+				     NFT_RULESET_O_JSON, 0);
+		break;
 	default:
 		errno = EINVAL;
 		return -1;
@@ -144,6 +160,8 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	if (strncmp(orig, out, strlen(out)) == 0)
 		return 0;
 
+	printf("out: %s\n", out);
+
 	errno = EBADMSG;
 	print_detail_error(orig, out);
 	return -1;
@@ -158,6 +176,7 @@ static int test_json(const char *filename)
 	struct nft_chain *c;
 	struct nft_rule *r;
 	struct nft_set *s;
+	struct nft_ruleset *rs;
 	json_t *root;
 	json_error_t error;
 	char *json;
@@ -210,6 +229,16 @@ static int test_json(const char *filename)
 
 			nft_set_free(s);
 			}
+	} else if (json_object_get(root, "nftables") != NULL) {
+		rs = nft_ruleset_alloc();
+		if (rs != NULL) {
+			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_JSON, json) == 0)
+				ret = compare_test(TEST_JSON_RULESET, rs, filename);
+			else
+				ret = -1;
+
+			nft_ruleset_free(rs);
+			}
 	}
 
 	free(json);
@@ -229,6 +258,7 @@ static int test_xml(const char *filename)
 	struct nft_chain *c;
 	struct nft_rule *r;
 	struct nft_set *s;
+	struct nft_ruleset *rs;
 	FILE *fp;
 	mxml_node_t *tree;
 	char *xml;
@@ -238,16 +268,17 @@ static int test_xml(const char *filename)
 	fclose(fp);
 
 	if (tree == NULL) {
-		printf("Unable to build XML tree.");
+		printf("Unable to build XML tree. ");
 		return -1;
 	}
 
 	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
 	if (xml == NULL) {
-		printf("Unable to save alloc string from XML tree.");
+		printf("Unable to save alloc string from XML tree. ");
 		return -1;
 	}
 
+
 	/* Check what parsing should be done */
 	if (strcmp(tree->value.opaque, "table") == 0) {
 		t = nft_table_alloc();
@@ -289,6 +320,18 @@ static int test_xml(const char *filename)
 
 			nft_set_free(s);
 		}
+	} else if (strcmp(tree->value.opaque, "nftables") == 0) {
+		rs = nft_ruleset_alloc();
+		if (rs != NULL) {
+			if (nft_ruleset_parse(rs, NFT_RULESET_PARSE_XML,
+					      xml) == 0)
+				ret = compare_test(TEST_XML_RULESET, rs,
+						   filename);
+			else
+				ret = -1;
+
+			nft_ruleset_free(rs);
+		}
 	}
 
 	free(xml);
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
new file mode 100644
index 0000000..21e72b8
--- /dev/null
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -0,0 +1 @@
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags></table><table><name>filter2</name><family>ip</family><flags>0</flags></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>3</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><set><family>ip</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001900</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><
 /set_elem></set><set><family>ip</family><table>filter</table><name>set1</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_el
 em><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x0000c800</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00006300</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>set2</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x0000c800</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00006300</data0></data_reg></key></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>2</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offse
 t><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type
 ="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set1</set><sreg>1</sreg><dreg>0</dreg></expr><expr 
 type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x01010101
 </data0></data_reg></cmpdata></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set2</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x01010101</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0
 </pkts><bytes>0</bytes></expr><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000004</da
 ta0></data_reg></cmpdata></expr></rule></nftables>

