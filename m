From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: xml: refactor XML parsing code
Date: Mon, 16 Sep 2013 20:24:51 +0200
Message-ID: <20130916182451.17068.80471.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42120 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751353Ab3IPSZA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:25:00 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 1C5B551ED25
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2013 18:24:59 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XkRCFq5Hqp4D for <netfilter-devel@vger.kernel.org>;
	Mon, 16 Sep 2013 20:24:53 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 9BE9351ED17
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2013 20:24:53 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch refactors nft_*_xml_parse to provide a new intermediate function
nft_mxml_parse_* which will allow us to navigate an entire XML tree
containing a ruleset without xml2text2xml conversions.

While at it, I added a helper to build the XML tree and validate the top node
name.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/chain.c b/src/chain.c
index 09ab5e3..8c0d804 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -612,50 +612,42 @@ static int nft_chain_json_parse(struct nft_chain *c, const char *json)
 #endif
 }
 
-static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
-{
 #ifdef XML_PARSING
-	mxml_node_t *tree;
+int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c)
+{
 	const char *table, *name, *hooknum_str, *policy_str, *type;
 	int family, hooknum, policy;
 
-	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL)
-		return -1;
-
-	if (strcmp(tree->value.opaque, "chain") != 0)
-		goto err;
-
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND);
 	if (name == NULL)
-		goto err;
+		return -1;
 
 	strncpy(c->name, name, NFT_CHAIN_MAXNAMELEN);
 	c->flags |= (1 << NFT_CHAIN_ATTR_NAME);
 
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
 			       &c->handle, NFT_TYPE_U64, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
 
 	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
 			       &c->bytes, NFT_TYPE_U64, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_BYTES);
 
 	if (nft_mxml_num_parse(tree, "packets", MXML_DESCEND_FIRST, BASE_DEC,
 			       &c->packets, NFT_TYPE_U64, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_PACKETS);
 
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND);
 	if (table == NULL)
-		goto err;
+		return -1;
 
 	if (c->table)
 		xfree(c->table);
@@ -666,7 +658,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND);
 	if (family < 0)
-		goto err;
+		return -1;
 
 	c->family = family;
 	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
@@ -676,7 +668,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 	if (hooknum_str != NULL) {
 		hooknum = nft_str2hooknum(c->family, hooknum_str);
 		if (hooknum < 0)
-			goto err;
+			return -1;
 
 		c->hooknum = hooknum;
 		c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
@@ -684,7 +676,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 		type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
 					  NFT_XML_MAND);
 		if (type == NULL)
-			goto err;
+			return -1;
 
 		if (c->type)
 			xfree(c->type);
@@ -696,7 +688,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 		if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
 				       &c->prio, NFT_TYPE_S32,
 				       NFT_XML_MAND) != 0)
-			goto err;
+			return -1;
 
 		c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
 
@@ -704,21 +696,31 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 						MXML_DESCEND_FIRST,
 						NFT_XML_MAND);
 		if (policy_str == NULL)
-			goto err;
+			return -1;
 
 		policy = nft_str2verdict(policy_str);
 		if (policy == -1)
-			goto err;
+			return -1;
 
 		c->policy = policy;
 		c->flags |= (1 << NFT_CHAIN_ATTR_POLICY);
 	}
 
-	mxmlDelete(tree);
 	return 0;
-err:
+}
+#endif
+
+static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
+{
+#ifdef XML_PARSING
+	int ret;
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "chain");
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_mxml_chain_parse(tree, c);
 	mxmlDelete(tree);
-	return -1;
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/internal.h b/src/internal.h
index 3d749b3..df64dd8 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -32,6 +32,7 @@ enum nft_type {
 #include <mxml.h>
 #define NFT_XML_MAND 0
 #define NFT_XML_OPT (1 << 0)
+mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename);
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags);
 union nft_data_reg;
@@ -42,6 +43,14 @@ int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name, uint32_t mxm
 
 struct nft_set_elem;
 int nft_mxml_set_elem_parse(mxml_node_t *node, struct nft_set_elem *e);
+struct nft_table;
+int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t);
+struct nft_chain;
+int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c);
+struct nft_rule;
+int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r);
+struct nft_set;
+int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s);
 #endif
 
 #ifdef JSON_PARSING
diff --git a/src/mxml.c b/src/mxml.c
index 6b7ca68..82156b7 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -15,11 +15,30 @@
 #include <limits.h>
 
 #include <linux/netfilter/nf_tables.h>
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
 #include <libnftables/set.h>
 
 #ifdef XML_PARSING
+mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename)
+{
+	mxml_node_t *tree;
+
+	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	if (tree == NULL)
+		goto err;
+
+	if (strcmp(tree->value.opaque, treename) == 0)
+		return tree;
+
+	mxmlDelete(tree);
+err:
+	errno = EINVAL;
+	return NULL;
+}
+
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node)
 {
 	mxml_node_t *tree;
diff --git a/src/rule.c b/src/rule.c
index a381469..555e724 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -577,25 +577,18 @@ static int nft_rule_json_parse(struct nft_rule *r, const char *json)
 #endif
 }
 
-static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
-{
 #ifdef XML_PARSING
-	mxml_node_t *tree, *node, *save;
+int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r)
+{
+	mxml_node_t *node;
 	struct nft_rule_expr *e;
 	const char *table, *chain;
 	int family;
 
-	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL)
-		return -1;
-
-	if (strcmp(tree->value.opaque, "rule") != 0)
-		goto err;
-
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND);
 	if (family < 0)
-		goto err;
+		return -1;
 
 	r->family = family;
 	r->flags |= (1 << NFT_RULE_ATTR_FAMILY);
@@ -603,7 +596,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND);
 	if (table == NULL)
-		goto err;
+		return -1;
 
 	if (r->table)
 		xfree(r->table);
@@ -614,7 +607,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 	chain = nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND);
 	if (chain == NULL)
-		goto err;
+		return -1;
 
 	if (r->chain)
 		xfree(r->chain);
@@ -624,14 +617,14 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
 			       &r->handle, NFT_TYPE_U64, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	r->flags |= (1 << NFT_RULE_ATTR_HANDLE);
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->rule_flags, NFT_TYPE_U32,
 			       NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	r->flags |= (1 << NFT_RULE_ATTR_FLAGS);
 
@@ -648,7 +641,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 	if (nft_rule_attr_is_set(r, NFT_RULE_ATTR_COMPAT_PROTO) !=
 			nft_rule_attr_is_set(r, NFT_RULE_ATTR_COMPAT_FLAGS)) {
 		errno = EINVAL;
-		goto err;
+		return -1;
 	}
 
 	if (nft_mxml_num_parse(tree, "position", MXML_DESCEND_FIRST,
@@ -662,26 +655,28 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 		node != NULL;
 		node = mxmlFindElement(node, tree, "expr", "type",
 				       NULL, MXML_DESCEND)) {
-
-		/* This is a hack for mxml to print just the current node */
-		save = node->next;
-		node->next = NULL;
-
 		e = nft_mxml_expr_parse(node);
 		if (e == NULL)
-			goto err;
+			return -1;
 
 		nft_rule_add_expr(r, e);
-
-		node->next = save;
-		save = NULL;
 	}
 
-	mxmlDelete(tree);
 	return 0;
-err:
+}
+#endif
+
+static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
+{
+#ifdef XML_PARSING
+	int ret;
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "rule");
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_mxml_rule_parse(tree, r);
 	mxmlDelete(tree);
-	return -1;
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/set.c b/src/set.c
index 7f2ee57..98f357c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -409,28 +409,18 @@ static int nft_set_json_parse(struct nft_set *s, const char *json)
 #endif
 }
 
-static int nft_set_xml_parse(struct nft_set *s, const char *xml)
-{
 #ifdef XML_PARSING
-	mxml_node_t *tree;
+int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s)
+{
 	mxml_node_t *node = NULL;
 	struct nft_set_elem *elem;
 	const char *name, *table;
 	int family;
 
-	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL) {
-		errno = EINVAL;
-		return -1;
-	}
-
-	if (strcmp(tree->value.opaque, "set") != 0)
-		goto err;
-
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND);
 	if (name == NULL)
-		goto err;
+		return -1;
 
 	if (s->name)
 		xfree(s->name);
@@ -441,7 +431,7 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND);
 	if (table == NULL)
-		goto err;
+		return -1;
 
 	if (s->table)
 		xfree(s->table);
@@ -452,7 +442,7 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND);
 	if (family < 0)
-		goto err;
+		return -1;
 
 	s->family = family;
 
@@ -460,31 +450,31 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BASE_DEC,
 			       &s->set_flags, NFT_TYPE_U32, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	s->flags |= (1 << NFT_SET_ATTR_FLAGS);
 
 	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST, BASE_DEC,
 			       &s->key_type, NFT_TYPE_U32, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	s->flags |= (1 << NFT_SET_ATTR_KEY_TYPE);
 
 	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST, BASE_DEC,
 			       &s->key_len, NFT_TYPE_U32, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	s->flags |= (1 << NFT_SET_ATTR_KEY_LEN);
 
 	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST, BASE_DEC,
 			       &s->data_type, NFT_TYPE_U32, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	s->flags |= (1 << NFT_SET_ATTR_DATA_TYPE);
 
 	if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST, BASE_DEC,
 			       &s->data_len, NFT_TYPE_U32, NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
 
@@ -496,19 +486,29 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 
 		elem = nft_set_elem_alloc();
 		if (elem == NULL)
-			goto err;
+			return -1;
 
 		if (nft_mxml_set_elem_parse(node, elem) < 0)
-			goto err;
+			return -1;
 
 		list_add_tail(&elem->head, &s->element_list);
 	}
 
-	mxmlDelete(tree);
 	return 0;
-err:
+}
+#endif
+
+static int nft_set_xml_parse(struct nft_set *s, const char *xml)
+{
+#ifdef XML_PARSING
+	int ret;
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "set");
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_mxml_set_parse(tree, s);
 	mxmlDelete(tree);
-	return -1;
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/set_elem.c b/src/set_elem.c
index 9ad482b..ec4a1a6 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -418,23 +418,13 @@ static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml)
 	mxml_node_t *tree;
 	int ret;
 
-	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL) {
-		errno = EINVAL;
+	tree = nft_mxml_build_tree(xml, "set_elem");
+	if (tree == NULL)
 		return -1;
-	}
-
-	if (strcmp(tree->value.opaque, "set_elem") != 0) {
-		errno = EINVAL;
-		goto err;
-	}
 
 	ret = nft_mxml_set_elem_parse(tree, e);
 	mxmlDelete(tree);
 	return ret;
-err:
-	mxmlDelete(tree);
-	return -1;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
diff --git a/src/table.c b/src/table.c
index 0b51d15..c8fff1e 100644
--- a/src/table.c
+++ b/src/table.c
@@ -218,24 +218,16 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 }
 EXPORT_SYMBOL(nft_table_nlmsg_parse);
 
-static int nft_table_xml_parse(struct nft_table *t, const char *xml)
-{
 #ifdef XML_PARSING
-	mxml_node_t *tree;
+int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t)
+{
 	const char *name;
 	int family;
 
-	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
-	if (tree == NULL)
-		return -1;
-
-	if (strcmp(tree->value.opaque, "table") != 0)
-		goto err;
-
 	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST,
 				  NFT_XML_MAND);
 	if (name == NULL)
-		goto err;
+		return -1;
 
 	if (t->name)
 		xfree(t->name);
@@ -246,7 +238,7 @@ static int nft_table_xml_parse(struct nft_table *t, const char *xml)
 	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND);
 	if (family < 0)
-		goto err;
+		return -1;
 
 	t->family = family;
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
@@ -254,15 +246,25 @@ static int nft_table_xml_parse(struct nft_table *t, const char *xml)
 	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC,
 			       &t->table_flags, NFT_TYPE_U32,
 			       NFT_XML_MAND) != 0)
-		goto err;
+		return -1;
 
 	t->flags |= (1 << NFT_TABLE_ATTR_FLAGS);
 
-	mxmlDelete(tree);
 	return 0;
-err:
+}
+#endif
+
+static int nft_table_xml_parse(struct nft_table *t, const char *xml)
+{
+#ifdef XML_PARSING
+	int ret;
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "table");
+	if (tree == NULL)
+		return -1;
+
+	ret = nft_mxml_table_parse(tree, t);
 	mxmlDelete(tree);
-	return -1;
+	return ret;
 #else
 	errno = EOPNOTSUPP;
 	return -1;

