From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: add ruleset API
Date: Mon, 16 Sep 2013 22:57:25 +0200
Message-ID: <20130916205725.24822.8533.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42447 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751204Ab3IPU5h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:57:37 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 9AA3351ED32
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2013 20:57:34 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GjsT2tjZ5Urm for <netfilter-devel@vger.kernel.org>;
	Mon, 16 Sep 2013 22:57:27 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id BE34051ED1A
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2013 22:57:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a ruleset object API to libnftables.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftables/Makefile.am |    3 
 include/libnftables/ruleset.h   |   45 ++
 src/Makefile.am                 |    1 
 src/chain.c                     |    2 
 src/internal.h                  |    8 
 src/libnftables.map             |    9 
 src/rule.c                      |    2 
 src/ruleset.c                   |  759 +++++++++++++++++++++++++++++++++++++++
 src/set.c                       |    2 
 src/table.c                     |    2 
 tests/nft-parsing-test.c        |   39 ++
 tests/xmlfiles/75-ruleset.xml   |    1 
 12 files changed, 868 insertions(+), 5 deletions(-)
 create mode 100644 include/libnftables/ruleset.h
 create mode 100644 src/ruleset.c
 create mode 100644 tests/xmlfiles/75-ruleset.xml

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
index 8c0d804..e3f70e0 100644
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
index c4a1c26..270883f 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -165,5 +165,14 @@ global:
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
index 555e724..709122d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -476,7 +476,7 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
 
 #ifdef JSON_PARSING
-static int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
+int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree)
 {
 	json_t *root, *array;
 	struct nft_rule_expr *e;
diff --git a/src/ruleset.c b/src/ruleset.c
new file mode 100644
index 0000000..2c30a56
--- /dev/null
+++ b/src/ruleset.c
@@ -0,0 +1,759 @@
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
+
+	if (r->flags & (1 << NFT_RULESET_ATTR_CHAINLIST))
+		nft_chain_list_free(r->chain_list);
+
+	if (r->flags & (1 << NFT_RULESET_ATTR_SETLIST))
+		nft_set_list_free(r->set_list);
+
+	if (r->flags & (1 << NFT_RULESET_ATTR_RULELIST))
+		nft_rule_list_free(r->rule_list);
+
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
+static int nft_ruleset_json_parse_table(struct nft_table_list *table_list,
+					json_t *root)
+{
+	struct nft_table *t;
+
+	t = nft_table_alloc();
+	if (t == NULL)
+		goto err;
+
+	if (nft_jansson_parse_table(t, root) < 0)
+		goto err;
+
+	nft_table_list_add_tail(t, table_list);
+
+	return 0;
+err:
+	nft_table_free(t);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_chain(struct nft_chain_list *chain_list,
+					json_t *root)
+{
+	struct nft_chain *c;
+
+	c = nft_chain_alloc();
+	if (c == NULL)
+		goto err;
+
+	if (nft_jansson_parse_chain(c, root) < 0)
+		goto err;
+
+	nft_chain_list_add_tail(c, chain_list);
+
+	return 0;
+err:
+	nft_chain_free(c);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_rule(struct nft_rule_list *rule_list,
+				       json_t *root)
+{
+	struct nft_rule *r;
+
+	r = nft_rule_alloc();
+	if (r == NULL)
+		goto err;
+
+	if (nft_jansson_parse_rule(r, root) < 0)
+		goto err;
+
+	nft_rule_list_add_tail(r, rule_list);
+
+	return 0;
+err:
+	nft_rule_free(r);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_set(struct nft_set_list *set_list,
+				      json_t *root)
+{
+	struct nft_set *s;
+
+	s = nft_set_alloc();
+	if (s == NULL)
+		goto err;
+
+	if (nft_jansson_parse_set(s, root) < 0)
+		goto err;
+
+	nft_set_list_add_tail(s, set_list);
+
+	return 0;
+err:
+	nft_set_free(s);
+	return -1;
+}
+
+static int nft_jansson_parse_ruleset(struct nft_ruleset *rs, json_t *tree)
+{
+	json_t *node, *array;
+	int i;
+	struct nft_table_list *table_list = nft_table_list_alloc();
+	struct nft_chain_list *chain_list = nft_chain_list_alloc();
+	struct nft_set_list *set_list = nft_set_list_alloc();
+	struct nft_rule_list *rule_list = nft_rule_list_alloc();
+
+	if (table_list == NULL || chain_list == NULL || set_list == NULL ||
+	    rule_list == NULL) {
+		errno = ENOMEM;
+		goto err;
+	}
+
+	array = nft_jansson_get_node(tree, "nftables");
+	if (array == NULL)
+		return -1;
+
+	for (i = 0; i < json_array_size(array); ++i) {
+		node = json_array_get(array, i);
+		if (nft_jansson_node_exist(node, "table"))
+			if (nft_ruleset_json_parse_table(table_list, node) < 0)
+				goto err;
+		if (nft_jansson_node_exist(node, "chain"))
+			if (nft_ruleset_json_parse_chain(chain_list, node) < 0)
+				goto err;
+		if (nft_jansson_node_exist(node, "rule"))
+			if (nft_ruleset_json_parse_rule(rule_list, node) < 0)
+				goto err;
+		if (nft_jansson_node_exist(node, "set"))
+			if (nft_ruleset_json_parse_set(set_list, node) < 0)
+				goto err;
+	}
+
+	if (nft_table_list_is_empty(table_list)
+	    && nft_chain_list_is_empty(chain_list)
+	    && nft_set_list_is_empty(set_list)
+	    && nft_rule_list_is_empty(rule_list)) {
+		errno = EINVAL;
+		goto err;
+	}
+
+	if (!nft_table_list_is_empty(table_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST,
+				     table_list);
+	else
+		nft_table_list_free(table_list);
+
+	if (!nft_chain_list_is_empty(chain_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST,
+				     chain_list);
+	else
+		nft_chain_list_free(chain_list);
+
+	if (!nft_set_list_is_empty(set_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, set_list);
+	else
+		nft_set_list_free(set_list);
+
+	if (!nft_rule_list_is_empty(rule_list))
+		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, rule_list);
+	else
+		nft_rule_list_free(rule_list);
+
+	nft_jansson_free_root(tree);
+	return 0;
+
+err:
+	if (table_list)
+		nft_table_list_free(table_list);
+	if (chain_list)
+		nft_chain_list_free(chain_list);
+	if (set_list)
+		nft_set_list_free(set_list);
+	if (rule_list)
+		nft_rule_list_free(rule_list);
+
+	nft_jansson_free_root(tree);
+	return -1;
+}
+#endif
+
+static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *json)
+{
+#ifdef JSON_PARSING
+	json_t *tree;
+	json_error_t error;
+
+	tree = nft_jansson_create_root(json, &error);
+	if (tree == NULL)
+		return -1;
+
+	return nft_jansson_parse_ruleset(rs, tree);
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
+
+	if (!(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_TABLELIST))
+		&& !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_CHAINLIST))
+		&& !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_SETLIST))
+		&& !(nft_ruleset_attr_is_set(rs, NFT_RULESET_ATTR_RULELIST))) {
+		errno = EINVAL;
+		return -1;
+	}
+
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
+	if (type == NFT_RULESET_O_JSON)
+		return snprintf(buf, size, ",");
+
+	if (type == NFT_RULESET_O_DEFAULT)
+		return snprintf(buf, size, "\n");
+
+	return 0;
+}
+
+static int
+list_separator_snprintf(char *buf, size_t size, void *prev, void *next,
+			uint32_t type)
+{
+	if (prev == NULL || next == NULL)
+		return 0;
+
+	return separator_snprintf(buf, size, prev, type);
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
+		ret = nft_table_snprintf(buf+offset, size, t, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		t = nft_table_list_iter_next(ti);
+		ret = separator_snprintf(buf+offset, size, t, type);
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
+		ret = nft_chain_snprintf(buf+offset, size, c, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		c = nft_chain_list_iter_next(ci);
+		ret = separator_snprintf(buf+offset, size, c, type);
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
+		ret = nft_set_snprintf(buf+offset, size, s, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		s = nft_set_list_iter_next(si);
+		ret = separator_snprintf(buf+offset, size, s, type);
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
+		ret = nft_rule_snprintf(buf+offset, size, r, type, flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		r = nft_rule_list_iter_next(ri);
+		ret = separator_snprintf(buf+offset, size, r, type);
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
+
+	ret = nft_ruleset_snprintf_table(buf+offset, size, rs, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = list_separator_snprintf(buf+offset, size,
+				      rs->table_list, rs->chain_list, type);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_ruleset_snprintf_chain(buf+offset, size, rs, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = list_separator_snprintf(buf+offset, size,
+				      rs->chain_list, rs->set_list, type);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_ruleset_snprintf_set(buf+offset, size, rs, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = list_separator_snprintf(buf+offset, size,
+				      rs->set_list, rs->rule_list, type);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_ruleset_snprintf_rule(buf+offset, size, rs, type, flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
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
+	ret = nft_ruleset_do_snprintf(buf+offset, size, rs, NFT_RULESET_O_XML,
+				      flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, size, "</nftables>");
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
+	ret = nft_ruleset_do_snprintf(buf+offset, size, rs, NFT_RULESET_O_JSON,
+				      flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, size, "]}\n");
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
index 98f357c..0020d25 100644
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
index c8fff1e..a4a3e1d 100644
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
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index ecde0e2..3904cfb 100644
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
@@ -211,6 +227,16 @@ static int test_json(const char *filename)
 
 			nft_set_free(s);
 			}
+	} else if (json_object_get(root, "nftables") != NULL) {
+		s = nft_set_alloc();
+		if (s != NULL) {
+			if (nft_set_parse(s, NFT_SET_PARSE_JSON, json) == 0)
+				ret = compare_test(TEST_JSON_SET, s, filename);
+			else
+				goto failparsing;
+
+			nft_set_free(s);
+			}
 	}
 
 	free(json);
@@ -237,6 +263,7 @@ static int test_xml(const char *filename)
 	struct nft_chain *c;
 	struct nft_rule *r;
 	struct nft_set *s;
+	struct nft_ruleset *rs;
 	FILE *fp;
 	mxml_node_t *tree;
 	char *xml;
@@ -293,6 +320,18 @@ static int test_xml(const char *filename)
 
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
+				goto failparsing;
+
+			nft_ruleset_free(rs);
+		}
 	}
 
 	return ret;
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
new file mode 100644
index 0000000..35a94f4
--- /dev/null
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -0,0 +1 @@
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags></table><table><name>nat</name><family>ip</family><flags>0</flags></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>pre</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>nat</table><family>ip</family></chain><set><family>ip</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x000001bb</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00000019</data0></data_reg></key></set_elem>
 <set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00000016</data0></data_reg></key></set_elem></set><set><family>ip</family><table>nat</table><name>set0</name><flags
 >3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001f90</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00000050</data0></data_reg></key></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>2</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</
 set><sreg>1</sreg><dreg>0</dreg></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule><rule><f
 amily>ip</family><table>nat</table><chain>pre</chain><handle>3</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>

