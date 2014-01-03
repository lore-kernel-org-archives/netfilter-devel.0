From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] parsing: add interface to parse from file
Date: Fri, 03 Jan 2014 13:33:51 +0100
Message-ID: <20140103123145.27058.77216.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58973 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbaACMeE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 07:34:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds API interfaces to parse nft objects from a given stream.

I found this useful in `nft', where I'm trying to parse XML/JSON from a file.

about the implementation:
 * a small selector is added in src/internal.h to avoid duplicating so
   much code.
 * The ifdef/endif logic in internal.h is reworked, looking for a cleaner
   file, and also allowing us to use without fear XML/JSON internal datatypes.

Examples will be updated in a separated patch, but the test infraestructure is
updated, using this new file-parsing approach.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v1: initial release, using a filename/path as input.
v2: rework the patch and use a FILE *stream as input. Implement the
    struct parse_ops and update nft-parsing-test to include tests for this
    new API.

 include/libnftables/chain.h   |    1 +
 include/libnftables/rule.h    |    1 +
 include/libnftables/ruleset.h |    1 +
 include/libnftables/set.h     |    2 +
 include/libnftables/table.h   |    1 +
 src/chain.c                   |   30 ++++++++++++----
 src/internal.h                |   45 ++++++++++++++++++++++--
 src/jansson.c                 |   25 +++++++++++++
 src/libnftables.map           |    6 +++
 src/mxml.c                    |   31 ++++++++++++++++
 src/rule.c                    |   28 +++++++++++----
 src/ruleset.c                 |   30 ++++++++++++----
 src/set.c                     |   29 +++++++++++----
 src/set_elem.c                |   46 ++++++++++++++++++++++--
 src/table.c                   |   31 ++++++++++++----
 tests/jsonfiles/01-table.json |    1 -
 tests/nft-parsing-test.c      |   78 ++++++++++++++++++++++++-----------------
 17 files changed, 301 insertions(+), 85 deletions(-)
 delete mode 100644 tests/jsonfiles/01-table.json

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 8b4eab9..2cffd35 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -52,6 +52,7 @@ struct nlmsghdr;
 void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain *t);
 
 int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *data);
+int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type, FILE *fp);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 86dbc17..5f2fa5e 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -48,6 +48,7 @@ struct nlmsghdr;
 void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
 
 int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type, const char *data);
+int nft_rule_fparse(struct nft_rule *r, enum nft_parse_type type, FILE *fp);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index 1ec3059..1501fc2 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -31,6 +31,7 @@ void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
 const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
 
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type, const char *data);
+int nft_ruleset_fparse(struct nft_ruleset *rs, enum nft_parse_type type, FILE *fp);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 13ac857..ec12769 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -61,6 +61,7 @@ struct nft_set *nft_set_list_iter_next(struct nft_set_list_iter *iter);
 void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
 
 int nft_set_parse(struct nft_set *s, enum nft_parse_type type, const char *data);
+int nft_set_fparse(struct nft_set *s, enum nft_parse_type type, FILE *fp);
 
 /*
  * Set elements
@@ -99,6 +100,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s);
 
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type, const char *data);
+int nft_set_elem_fparse(struct nft_set_elem *e, enum nft_parse_type type, FILE *fp);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
 int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 1d2be07..8758289 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -41,6 +41,7 @@ struct nlmsghdr;
 void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table *t);
 
 int nft_table_parse(struct nft_table *t, enum nft_parse_type type, const char *data);
+int nft_table_fparse(struct nft_table *t, enum nft_parse_type type, FILE *fp);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
 
diff --git a/src/chain.c b/src/chain.c
index a0004b5..45af8db 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -587,13 +587,14 @@ err:
 }
 #endif
 
-static int nft_chain_json_parse(struct nft_chain *c, const char *json)
+static int nft_chain_json_buildparse(struct nft_chain *c, const char *json,
+				     const struct parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error);
+	tree = ops->jsonbuilder(json, &error);
 	if (tree == NULL)
 		return -1;
 
@@ -702,11 +703,12 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c)
 }
 #endif
 
-static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
+static int nft_chain_xml_buildparse(struct nft_chain *c, const char *xml,
+				    const struct parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "chain");
+	mxml_node_t *tree = ops->xmlbuilder(xml, "chain");
 	if (tree == NULL)
 		return -1;
 
@@ -719,17 +721,17 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 #endif
 }
 
-int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
-		    const char *data)
+static int nft_chain_do_parse(struct nft_chain *c, enum nft_parse_type type,
+			      const void *data, const struct parse_ops *ops)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_chain_xml_parse(c, data);
+		ret = nft_chain_xml_buildparse(c, data, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_chain_json_parse(c, data);
+		ret = nft_chain_json_buildparse(c, data, ops);
 		break;
 	default:
 		ret = -1;
@@ -739,8 +741,20 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type, const char *data)
+{
+	return nft_chain_do_parse(c, type, data, &parse_string_ops);
+}
 EXPORT_SYMBOL(nft_chain_parse);
 
+int nft_chain_fparse(struct nft_chain *c, enum nft_parse_type type, FILE *fp)
+{
+	return nft_chain_do_parse(c, type, fp, &parse_stream_ops);
+}
+EXPORT_SYMBOL(nft_chain_fparse);
+
+
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
diff --git a/src/internal.h b/src/internal.h
index a10d874..e0b9761 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -32,9 +32,14 @@ enum nft_type {
 
 #ifdef XML_PARSING
 #include <mxml.h>
+#else
+#define mxml_node_t void
+#endif /*XML_PARSING */
+
 #define NFT_XML_MAND 0
 #define NFT_XML_OPT (1 << 0)
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename);
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename);
+mxml_node_t *nft_mxml_build_tree_file(const void *data, const char *treename);
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags);
 union nft_data_reg;
@@ -53,14 +58,19 @@ struct nft_rule;
 int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r);
 struct nft_set;
 int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s);
-#endif
 
 #ifdef JSON_PARSING
 #include <jansson.h>
+#else
+#define json_t void
+#define json_err_t void
+#endif /* JSON_PARSING */
+
 int nft_jansson_parse_val(json_t *root, const char *tag, int type, void *out);
 const char *nft_jansson_parse_str(json_t *root, const char *tag);
 bool nft_jansson_node_exist(json_t *root, const char *tag);
-json_t *nft_jansson_create_root(const char *json, json_error_t *err);
+json_t *nft_jansson_create_root(const void *data, void *err);
+json_t *nft_jansson_create_root_file(const void *data, void *err);
 json_t *nft_jansson_get_node(json_t *root, const char *tag);
 void nft_jansson_free_root(json_t *root);
 int nft_jansson_parse_family(json_t *root, void *out);
@@ -81,7 +91,29 @@ struct nft_rule;
 int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree);
 struct nft_set;
 int nft_jansson_parse_set(struct nft_set *s, json_t *tree);
+
+struct parse_ops {
+	mxml_node_t *(*xmlbuilder)(const void *input_data, const char *treename);
+	json_t *(*jsonbuilder)(const void *input_data, void *err);
+};
+
+static const struct parse_ops parse_string_ops = {
+#ifdef XML_PARSING
+	.xmlbuilder = nft_mxml_build_tree,
+#endif
+#ifdef JSON_PARSING
+	.jsonbuilder = nft_jansson_create_root
+#endif
+};
+
+static const struct parse_ops parse_stream_ops = {
+#ifdef XML_PARSING
+	.xmlbuilder = nft_mxml_build_tree_file,
 #endif
+#ifdef JSON_PARSING
+	.jsonbuilder = nft_jansson_create_root_file,
+#endif
+};
 
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
@@ -91,8 +123,13 @@ int nft_str2verdict(const char *verdict);
 int nft_get_value(enum nft_type type, void *val, void *out);
 
 #include <stdio.h>
-int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <fcntl.h>
 
+#include <libnftables/common.h>
+int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
 void xfree(const void *ptr);
 
 struct expr_ops;
diff --git a/src/jansson.c b/src/jansson.c
index 04146e2..53c9272 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -76,7 +76,7 @@ bool nft_jansson_node_exist(json_t *root, const char *tag)
 	return json_object_get(root, tag) != NULL;
 }
 
-json_t *nft_jansson_create_root(const char *json, json_error_t *err)
+static json_t *nft_jansson_do_create_root(const char *json, json_error_t *err)
 {
 	json_t *root;
 
@@ -89,6 +89,29 @@ json_t *nft_jansson_create_root(const char *json, json_error_t *err)
 	return root;
 }
 
+json_t *nft_jansson_create_root(const void *data, void *err)
+{
+	return nft_jansson_do_create_root(data, err);
+}
+
+static json_t *nft_jansson_do_create_root_file(FILE *f, json_error_t *err)
+{
+	json_t *root;
+
+	root = json_loadf(f, 0, err);
+	if (root == NULL) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	return root;
+}
+
+json_t *nft_jansson_create_root_file(const void *data, void *err)
+{
+	return nft_jansson_do_create_root_file((FILE *)data, err);
+}
+
 json_t *nft_jansson_get_node(json_t *root, const char *tag)
 {
 	json_t *node;
diff --git a/src/libnftables.map b/src/libnftables.map
index 7dc9aee..eb5ed5c 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -13,6 +13,7 @@ global:
   nft_table_attr_get_u32;
   nft_table_attr_get_str;
   nft_table_parse;
+  nft_table_fparse;
   nft_table_snprintf;
   nft_table_fprintf;
   nft_table_nlmsg_build_payload;
@@ -45,6 +46,7 @@ global:
   nft_chain_attr_get_u64;
   nft_chain_attr_get_str;
   nft_chain_parse;
+  nft_chain_fparse;
   nft_chain_snprintf;
   nft_chain_fprintf;
   nft_chain_nlmsg_build_payload;
@@ -74,6 +76,7 @@ global:
   nft_rule_attr_get_u64;
   nft_rule_attr_get_str;
   nft_rule_parse;
+  nft_rule_fparse;
   nft_rule_snprintf;
   nft_rule_fprintf;
   nft_rule_nlmsg_build_payload;
@@ -128,6 +131,7 @@ global:
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
   nft_set_parse;
+  nft_set_fparse;
   nft_set_snprintf;
   nft_set_fprintf;
 
@@ -159,6 +163,7 @@ global:
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
+  nft_set_elem_fparse;
   nft_set_elem_snprintf;
   nft_set_elem_fprinf;
 
@@ -179,6 +184,7 @@ global:
   nft_ruleset_attr_set;
   nft_ruleset_attr_get;
   nft_ruleset_parse;
+  nft_ruleset_fparse;
   nft_ruleset_snprintf;
   nft_ruleset_fprintf;
 
diff --git a/src/mxml.c b/src/mxml.c
index 82156b7..3457207 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -22,7 +22,9 @@
 #include <libnftables/set.h>
 
 #ifdef XML_PARSING
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename)
+
+static mxml_node_t *nft_mxml_do_build_tree(const char *xml,
+					   const char *treename)
 {
 	mxml_node_t *tree;
 
@@ -39,6 +41,33 @@ err:
 	return NULL;
 }
 
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename)
+{
+	return nft_mxml_do_build_tree(data, treename);
+}
+
+static mxml_node_t *nft_mxml_do_build_tree_file(FILE *f, const char *treename)
+{
+	mxml_node_t *tree;
+
+	tree = mxmlLoadFile(NULL, f, MXML_OPAQUE_CALLBACK);
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
+mxml_node_t *nft_mxml_build_tree_file(const void *data, const char *treename)
+{
+	return nft_mxml_do_build_tree_file((void *)data, treename);
+}
+
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node)
 {
 	mxml_node_t *tree;
diff --git a/src/rule.c b/src/rule.c
index 280350a..55312e5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -521,13 +521,14 @@ err:
 }
 #endif
 
-static int nft_rule_json_parse(struct nft_rule *r, const char *json)
+static int nft_rule_json_buildparse(struct nft_rule *r, const char *json,
+				    const struct parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error);
+	tree = ops->jsonbuilder(json, &error);
 	if (tree == NULL)
 		return -1;
 
@@ -620,11 +621,12 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r)
 }
 #endif
 
-static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
+static int nft_rule_xml_buildparse(struct nft_rule *r, const char *xml,
+				   const struct parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "rule");
+	mxml_node_t *tree = ops->xmlbuilder(xml, "rule");
 	if (tree == NULL)
 		return -1;
 
@@ -637,17 +639,17 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 #endif
 }
 
-int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
-		   const char *data)
+static int nft_rule_do_parse(struct nft_rule *r, enum nft_parse_type type,
+			     const void *data, const struct parse_ops *ops)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_rule_xml_parse(r, data);
+		ret = nft_rule_xml_buildparse(r, data, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_rule_json_parse(r, data);
+		ret = nft_rule_json_buildparse(r, data, ops);
 		break;
 	default:
 		ret = -1;
@@ -657,8 +659,18 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 
 	return ret;
 }
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type, const char *data)
+{
+	return nft_rule_do_parse(r, type, data, &parse_string_ops);
+}
 EXPORT_SYMBOL(nft_rule_parse);
 
+int nft_rule_fparse(struct nft_rule *r, enum nft_parse_type type, FILE *fp)
+{
+	return nft_rule_do_parse(r, type, fp, &parse_stream_ops);
+}
+EXPORT_SYMBOL(nft_rule_fparse);
+
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 					 uint32_t type, uint32_t flags)
 {
diff --git a/src/ruleset.c b/src/ruleset.c
index f591382..953d663 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -326,13 +326,14 @@ err:
 
 #endif
 
-static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *json)
+static int nft_ruleset_json_buildparse(struct nft_ruleset *rs, const char *json,
+				       const struct parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *root, *array;
 	json_error_t error;
 
-	root = nft_jansson_create_root(json, &error);
+	root = ops->jsonbuilder(json, &error);
 	if (root == NULL)
 		return -1;
 
@@ -525,12 +526,13 @@ err_free:
 }
 #endif
 
-static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char *xml)
+static int nft_ruleset_xml_buildparse(struct nft_ruleset *rs, const char *xml,
+				      const struct parse_ops *ops)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 
-	tree = nft_mxml_build_tree(xml, "nftables");
+	tree = ops->xmlbuilder(xml, "nftables");
 	if (tree == NULL)
 		return -1;
 
@@ -557,17 +559,17 @@ err:
 #endif
 }
 
-int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
-		      const char *data)
+static int nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
+				const void *data, const struct parse_ops *ops)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_ruleset_xml_parse(r, data);
+		ret = nft_ruleset_xml_buildparse(r, data, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_ruleset_json_parse(r, data);
+		ret = nft_ruleset_json_buildparse(r, data, ops);
 		break;
 	default:
 		ret = -1;
@@ -577,8 +579,20 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
+		      const char *data)
+{
+	return nft_ruleset_do_parse(rs, type, data, &parse_string_ops);
+}
 EXPORT_SYMBOL(nft_ruleset_parse);
 
+int nft_ruleset_fparse(struct nft_ruleset *rs, enum nft_parse_type type, FILE *fp)
+{
+	return nft_ruleset_do_parse(rs, type, fp, &parse_stream_ops);
+}
+EXPORT_SYMBOL(nft_ruleset_fparse);
+
 static const char *nft_ruleset_o_opentag(uint32_t type)
 {
 	switch (type) {
diff --git a/src/set.c b/src/set.c
index c5204cc..624a659 100644
--- a/src/set.c
+++ b/src/set.c
@@ -371,13 +371,14 @@ err:
 }
 #endif
 
-static int nft_set_json_parse(struct nft_set *s, const char *json)
+static int nft_set_json_buildparse(struct nft_set *s, const char *json,
+				   const struct parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error);
+	tree = ops->jsonbuilder(json, &error);
 	if (tree == NULL)
 		return -1;
 
@@ -477,11 +478,12 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s)
 }
 #endif
 
-static int nft_set_xml_parse(struct nft_set *s, const char *xml)
+static int nft_set_xml_buildparse(struct nft_set *s, const void *data,
+				  const struct parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "set");
+	mxml_node_t *tree = ops->xmlbuilder(data, "set");
 	if (tree == NULL)
 		return -1;
 
@@ -494,17 +496,17 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 #endif
 }
 
-int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
-		  const char *data)
+static int nft_set_do_parse(struct nft_set *s, enum nft_parse_type type,
+			    const void *data, const struct parse_ops *ops)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_set_xml_parse(s, data);
+		ret = nft_set_xml_buildparse(s, data, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_set_json_parse(s, data);
+		ret = nft_set_json_buildparse(s, data, ops);
 		break;
 	default:
 		ret = -1;
@@ -514,8 +516,19 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_set_parse(struct nft_set *s, enum nft_parse_type type, const char *data)
+{
+	return nft_set_do_parse(s, type, data, &parse_string_ops);
+}
 EXPORT_SYMBOL(nft_set_parse);
 
+int nft_set_fparse(struct nft_set *s, enum nft_parse_type type, FILE *fp)
+{
+	return nft_set_do_parse(s, type, fp, &parse_stream_ops);
+}
+EXPORT_SYMBOL(nft_set_fparse);
+
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 				  uint32_t type, uint32_t flags)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index fce9c1d..b5d7f71 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -393,13 +393,14 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e)
 }
 #endif
 
-static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml)
+static int nft_set_elem_xml_buildparse(struct nft_set_elem *e, const void *data,
+				       const struct parse_ops *ops)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 	int ret;
 
-	tree = nft_mxml_build_tree(xml, "set_elem");
+	tree = ops->xmlbuilder(data, "set_elem");
 	if (tree == NULL)
 		return -1;
 
@@ -412,13 +413,36 @@ static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml)
 #endif
 }
 
-int nft_set_elem_parse(struct nft_set_elem *e,
-		       enum nft_parse_type type, const char *data) {
+static int nft_set_elem_json_buildparse(struct nft_set_elem *e, const void *data,
+					const struct parse_ops *ops)
+{
+#ifdef JSON_PARSING
+	json_t *tree;
+	json_error_t error;
+
+	tree = ops->jsonbuilder(data, &error);
+	if (tree == NULL)
+		return -1;
+
+	return nft_set_elem_json_parse(e, tree);
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
+}
+
+static int nft_set_elem_do_parse(struct nft_set_elem *e,
+				 enum nft_parse_type type, const void *data,
+				 const struct parse_ops *ops)
+{
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_set_elem_xml_parse(e, data);
+		ret = nft_set_elem_xml_buildparse(e, data, ops);
+		break;
+	case NFT_PARSE_JSON:
+		ret = nft_set_elem_json_buildparse(e, data, ops);
 		break;
 	default:
 		errno = EOPNOTSUPP;
@@ -428,8 +452,20 @@ int nft_set_elem_parse(struct nft_set_elem *e,
 
 	return ret;
 }
+
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
+		       const char *data)
+{
+	return nft_set_elem_do_parse(e, type, data, &parse_string_ops);
+}
 EXPORT_SYMBOL(nft_set_elem_parse);
 
+int nft_set_elem_fparse(struct nft_set_elem *e, enum nft_parse_type type, FILE *fp)
+{
+	return nft_set_elem_do_parse(e, type, fp, &parse_stream_ops);
+}
+EXPORT_SYMBOL(nft_set_elem_fparse);
+
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
 				      struct nft_set_elem *e, uint32_t flags)
 {
diff --git a/src/table.c b/src/table.c
index ba84264..53cb8c1 100644
--- a/src/table.c
+++ b/src/table.c
@@ -265,11 +265,13 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t)
 }
 #endif
 
-static int nft_table_xml_parse(struct nft_table *t, const char *xml)
+static int nft_table_xml_buildparse(struct nft_table *t, const void *data,
+				    const struct parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "table");
+	mxml_node_t *tree = (mxml_node_t *)ops->xmlbuilder(data, "table");
+
 	if (tree == NULL)
 		return -1;
 
@@ -318,13 +320,14 @@ err:
 }
 #endif
 
-static int nft_table_json_parse(struct nft_table *t, const char *json)
+static int nft_table_json_buildparse(struct nft_table *t, const void *data,
+				     const struct parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error);
+	tree = (json_t *)ops->jsonbuilder(data, &error);
 	if (tree == NULL)
 		return -1;
 
@@ -335,17 +338,17 @@ static int nft_table_json_parse(struct nft_table *t, const char *json)
 #endif
 }
 
-int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
-		    const char *data)
+static int nft_table_do_parse(struct nft_table *t, enum nft_parse_type type,
+			      const void *data, const struct parse_ops *ops)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_table_xml_parse(t, data);
+		ret = nft_table_xml_buildparse(t, data, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_table_json_parse(t, data);
+		ret = nft_table_json_buildparse(t, data, ops);
 		break;
 	default:
 		ret = -1;
@@ -355,8 +358,20 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
+		    const char *data)
+{
+	return nft_table_do_parse(t, type, data, &parse_string_ops);
+}
 EXPORT_SYMBOL(nft_table_parse);
 
+int nft_table_fparse(struct nft_table *t, enum nft_parse_type type, FILE *fp)
+{
+	return nft_table_do_parse(t, type, fp, &parse_stream_ops);
+}
+EXPORT_SYMBOL(nft_table_fparse);
+
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,
diff --git a/tests/jsonfiles/01-table.json b/tests/jsonfiles/01-table.json
deleted file mode 100644
index f217189..0000000
--- a/tests/jsonfiles/01-table.json
+++ /dev/null
@@ -1 +0,0 @@
-{"table":{"name":"filter","family":"ip","flags":0,"use":0}}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 6a5ab4d..3b4de75 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -73,7 +73,7 @@ static void print_detail_error(char *a, char *b)
 	}
 }
 
-static int compare_test(uint32_t type, void *input, const char *filename)
+static int compare_test(uint32_t type, void *input, const char *filename, FILE *fp)
 {
 	struct nft_table *t = NULL;
 	struct nft_chain *c = NULL;
@@ -82,7 +82,6 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 	struct nft_ruleset *rs = NULL;
 	char orig[4096];
 	char out[4096];
-	FILE *fp;
 
 	switch (type) {
 	case TEST_XML_TABLE:
@@ -148,14 +147,8 @@ static int compare_test(uint32_t type, void *input, const char *filename)
 		return -1;
 	}
 
-	fp = fopen(filename, "r");
-	if (fp == NULL) {
-		perror("open");
-		exit(EXIT_FAILURE);
-	}
-
+	rewind(fp);
 	fgets(orig, sizeof(orig), fp);
-	fclose(fp);
 
 	if (strncmp(orig, out, strlen(out)) == 0)
 		return 0;
@@ -179,6 +172,7 @@ static int test_json(const char *filename)
 	json_t *root;
 	json_error_t error;
 	char *json;
+	FILE *fp;
 
 	root = json_load_file(filename, 0, &error);
 	if (!root) {
@@ -188,11 +182,14 @@ static int test_json(const char *filename)
 
 	json = json_dumps(root, JSON_INDENT(0));
 
+	fp = fopen(filename, "r");
+
 	if (json_object_get(root, "table") != NULL) {
 		t = nft_table_alloc();
 		if (t != NULL) {
-			if (nft_table_parse(t, NFT_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_TABLE, t, filename);
+			if (nft_table_fparse(t, NFT_PARSE_JSON, fp) == 0)
+				ret = compare_test(TEST_JSON_TABLE, t,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -201,8 +198,9 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "chain") != NULL) {
 		c = nft_chain_alloc();
 		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_CHAIN, c, filename);
+			if (nft_chain_fparse(c, NFT_PARSE_JSON, fp) == 0)
+				ret = compare_test(TEST_JSON_CHAIN, c,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -211,8 +209,9 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "rule") != NULL) {
 		r = nft_rule_alloc();
 		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_RULE, r, filename);
+			if (nft_rule_fparse(r, NFT_PARSE_JSON, fp) == 0)
+				ret = compare_test(TEST_JSON_RULE, r,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -221,8 +220,9 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "set") != NULL) {
 		s = nft_set_alloc();
 		if (s != NULL) {
-			if (nft_set_parse(s, NFT_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_SET, s, filename);
+			if (nft_set_fparse(s, NFT_PARSE_JSON, fp) == 0)
+				ret = compare_test(TEST_JSON_SET, s,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -231,8 +231,9 @@ static int test_json(const char *filename)
 	} else if (json_object_get(root, "nftables") != NULL) {
 		rs = nft_ruleset_alloc();
 		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_JSON, json) == 0)
-				ret = compare_test(TEST_JSON_RULESET, rs, filename);
+			if (nft_ruleset_fparse(rs, NFT_PARSE_JSON, fp) == 0)
+				ret = compare_test(TEST_JSON_RULESET, rs,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -240,11 +241,13 @@ static int test_json(const char *filename)
 			}
 	}
 
+	fclose(fp);
 	free(json);
 	json_decref(root);
 	return ret;
 
 failparsing:
+	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
 	free(json);
@@ -271,27 +274,28 @@ static int test_xml(const char *filename)
 
 	fp = fopen(filename, "r");
 	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
-	fclose(fp);
+	rewind(fp);
 
 	if (tree == NULL) {
 		printf("unable to build XML tree from file "
 		       "%s \033[31mFAILED\e[0m\n", filename);
-		return -1;
+		goto err;
 	}
 
 	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
 	if (xml == NULL) {
 		printf("unable to alloc string from XML tree from %s "
 		       "\033[31mFAILED\e[0m\n", filename);
-		return -1;
+		goto err;
 	}
 
 	/* Check what parsing should be done */
 	if (strcmp(tree->value.opaque, "table") == 0) {
 		t = nft_table_alloc();
 		if (t != NULL) {
-			if (nft_table_parse(t, NFT_PARSE_XML, xml) == 0)
-				ret = compare_test(TEST_XML_TABLE, t, filename);
+			if (nft_table_fparse(t, NFT_PARSE_XML, fp) == 0)
+				ret = compare_test(TEST_XML_TABLE, t,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -300,8 +304,9 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "chain") == 0) {
 		c = nft_chain_alloc();
 		if (c != NULL) {
-			if (nft_chain_parse(c, NFT_PARSE_XML, xml) == 0)
-				ret = compare_test(TEST_XML_CHAIN, c, filename);
+			if (nft_chain_fparse(c, NFT_PARSE_XML, fp) == 0)
+				ret = compare_test(TEST_XML_CHAIN, c,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -310,8 +315,9 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "rule") == 0) {
 		r = nft_rule_alloc();
 		if (r != NULL) {
-			if (nft_rule_parse(r, NFT_PARSE_XML, xml) == 0)
-				ret = compare_test(TEST_XML_RULE, r, filename);
+			if (nft_rule_fparse(r, NFT_PARSE_XML, fp) == 0)
+				ret = compare_test(TEST_XML_RULE, r,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -320,8 +326,9 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "set") == 0) {
 		s = nft_set_alloc();
 		if (s != NULL) {
-			if (nft_set_parse(s, NFT_PARSE_XML, xml) == 0)
-				ret = compare_test(TEST_XML_SET, s, filename);
+			if (nft_set_fparse(s, NFT_PARSE_XML, fp) == 0)
+				ret = compare_test(TEST_XML_SET, s,
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -330,10 +337,10 @@ static int test_xml(const char *filename)
 	} else if (strcmp(tree->value.opaque, "nftables") == 0) {
 		rs = nft_ruleset_alloc();
 		if (rs != NULL) {
-			if (nft_ruleset_parse(rs, NFT_PARSE_XML,
-					      xml) == 0)
+			if (nft_ruleset_fparse(rs, NFT_PARSE_XML,
+					      fp) == 0)
 				ret = compare_test(TEST_XML_RULESET, rs,
-						   filename);
+						   filename, fp);
 			else
 				goto failparsing;
 
@@ -341,14 +348,19 @@ static int test_xml(const char *filename)
 		}
 	}
 
+	fclose(fp);
 	mxmlDelete(tree);
 	return ret;
 
 failparsing:
+	fclose(fp);
 	mxmlDelete(tree);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
 	return -1;
+err:
+	fclose(fp);
+	return -1;
 #else
 	printf("Compiled without support for XML.\n");
 	return -1;

