From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 4/6] internal: add a selector for parsing ops
Date: Tue, 07 Jan 2014 12:47:32 +0100
Message-ID: <20140107114732.12841.11957.stgit@nfdev.cica.es>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53955 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbaAGLrl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:47:41 -0500
In-Reply-To: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a selector for parsing operations.

The selector allows to reduce code duplication in case more than
one parsing interface are used.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/chain.c b/src/chain.c
index a4ddb06..fd56629 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -592,13 +592,14 @@ err:
 #endif
 
 static int nft_chain_json_parse(struct nft_chain *c, const char *json,
-				struct nft_parse_err *err)
+				struct nft_parse_err *err,
+				const struct nft_parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = ops->jsonbuilder(json, &error, err);
 	if (tree == NULL)
 		return -1;
 
@@ -709,11 +710,12 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 #endif
 
 static int nft_chain_xml_parse(struct nft_chain *c, const char *xml,
-			       struct nft_parse_err *err)
+			       struct nft_parse_err *err,
+			       const struct nft_parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "chain", err);
+	mxml_node_t *tree = ops->xmlbuilder(xml, "chain", err);
 	if (tree == NULL)
 		return -1;
 
@@ -726,18 +728,19 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml,
 #endif
 }
 
-int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
-		    const char *data, struct nft_parse_err *err)
+static int nft_chain_do_parse(struct nft_chain *c, enum nft_parse_type type,
+			      const void *data, struct nft_parse_err *err,
+			      const struct nft_parse_ops *ops)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_chain_xml_parse(c, data, &perr);
+		ret = nft_chain_xml_parse(c, data, &perr, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_chain_json_parse(c, data, &perr);
+		ret = nft_chain_json_parse(c, data, &perr, ops);
 		break;
 	default:
 		ret = -1;
@@ -750,6 +753,12 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err)
+{
+	return nft_chain_do_parse(c, type, data, err, &nft_parse_string_ops);
+}
 EXPORT_SYMBOL(nft_chain_parse);
 
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
diff --git a/src/internal.h b/src/internal.h
index 83cb4e8..afd8816 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -46,7 +46,7 @@ struct nft_parse_err {
 
 #define NFT_XML_MAND 0
 #define NFT_XML_OPT (1 << 0)
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 				 struct nft_parse_err *err);
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 					  struct nft_parse_err *err);
@@ -95,7 +95,7 @@ int nft_jansson_parse_val(json_t *root, const char *node_name, int type,
 const char *nft_jansson_parse_str(json_t *root, const char *node_name,
 				  struct nft_parse_err *err);
 bool nft_jansson_node_exist(json_t *root, const char *node_name);
-json_t *nft_jansson_create_root(const char *json, json_error_t *error,
+json_t *nft_jansson_create_root(const void *data, json_error_t *error,
 				struct nft_parse_err *err);
 json_t *nft_jansson_get_node(json_t *root, const char *node_name,
 			     struct nft_parse_err *err);
@@ -127,6 +127,24 @@ struct nft_set;
 int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			  struct nft_parse_err *err);
 
+struct nft_parse_ops {
+	mxml_node_t *(*xmlbuilder)(const void *input_data,
+				   const char *treename,
+				   struct nft_parse_err *err);
+	json_t *(*jsonbuilder)(const void *input_data,
+			       json_error_t *jerror,
+			       struct nft_parse_err *err);
+};
+
+static const struct nft_parse_ops nft_parse_string_ops = {
+#ifdef XML_PARSING
+	.xmlbuilder = nft_mxml_build_tree,
+#endif
+#ifdef JSON_PARSING
+	.jsonbuilder = nft_jansson_create_root
+#endif
+};
+
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
 int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
diff --git a/src/jansson.c b/src/jansson.c
index e62116b..90faeca 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -89,8 +89,9 @@ bool nft_jansson_node_exist(json_t *root, const char *node_name)
 	return json_object_get(root, node_name) != NULL;
 }
 
-json_t *nft_jansson_create_root(const char *json, json_error_t *error,
-				struct nft_parse_err *err)
+static json_t *
+nft_jansson_do_create_root(const char *json, json_error_t *error,
+			   struct nft_parse_err *err)
 {
 	json_t *root;
 
@@ -107,6 +108,12 @@ json_t *nft_jansson_create_root(const char *json, json_error_t *error,
 	return root;
 }
 
+json_t *nft_jansson_create_root(const void *data, json_error_t *error,
+				struct nft_parse_err *err)
+{
+	return nft_jansson_do_create_root(data, error, err);
+}
+
 json_t *nft_jansson_get_node(json_t *root, const char *node_name,
 			     struct nft_parse_err *err)
 {
diff --git a/src/mxml.c b/src/mxml.c
index bc0f084..13a8b89 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -22,8 +22,9 @@
 #include <libnftables/set.h>
 
 #ifdef XML_PARSING
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
-				 struct nft_parse_err *err)
+static mxml_node_t *
+nft_mxml_do_build_tree(const char *xml, const char *treename,
+		       struct nft_parse_err *err)
 {
 	mxml_node_t *tree;
 
@@ -47,6 +48,12 @@ err:
 	return NULL;
 }
 
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
+				 struct nft_parse_err *err)
+{
+	return nft_mxml_do_build_tree(data, treename, err);
+}
+
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 					  struct nft_parse_err *err)
 {
diff --git a/src/rule.c b/src/rule.c
index 2e35aba..6f5718d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -527,13 +527,14 @@ err:
 #endif
 
 static int nft_rule_json_parse(struct nft_rule *r, const char *json,
-			       struct nft_parse_err *err)
+			       struct nft_parse_err *err,
+			       const struct nft_parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = ops->jsonbuilder(json, &error, err);
 	if (tree == NULL)
 		return -1;
 
@@ -628,11 +629,12 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
 #endif
 
 static int nft_rule_xml_parse(struct nft_rule *r, const char *xml,
-			      struct nft_parse_err *err)
+			      struct nft_parse_err *err,
+			      const struct nft_parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "rule", err);
+	mxml_node_t *tree = ops->xmlbuilder(xml, "rule", err);
 	if (tree == NULL)
 		return -1;
 
@@ -645,18 +647,19 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml,
 #endif
 }
 
-int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
-		   const char *data, struct nft_parse_err *err)
+static int nft_rule_do_parse(struct nft_rule *r, enum nft_parse_type type,
+			     const void *data, struct nft_parse_err *err,
+			     const struct nft_parse_ops *ops)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_rule_xml_parse(r, data, &perr);
+		ret = nft_rule_xml_parse(r, data, &perr, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_rule_json_parse(r, data, &perr);
+		ret = nft_rule_json_parse(r, data, &perr, ops);
 		break;
 	default:
 		ret = -1;
@@ -668,6 +671,12 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
+		   const char *data, struct nft_parse_err *err)
+{
+	return nft_rule_do_parse(r, type, data, err, &nft_parse_string_ops);
+}
 EXPORT_SYMBOL(nft_rule_parse);
 
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
diff --git a/src/ruleset.c b/src/ruleset.c
index a12efa9..84ada20 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -331,13 +331,14 @@ err:
 #endif
 
 static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *json,
-				  struct nft_parse_err *err)
+				  struct nft_parse_err *err,
+				  const struct nft_parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *root, *array;
 	json_error_t error;
 
-	root = nft_jansson_create_root(json, &error, err);
+	root = ops->jsonbuilder(json, &error, err);
 	if (root == NULL)
 		return -1;
 
@@ -535,12 +536,13 @@ err_free:
 #endif
 
 static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char *xml,
-				 struct nft_parse_err *err)
+				 struct nft_parse_err *err,
+				 const struct nft_parse_ops *ops)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 
-	tree = nft_mxml_build_tree(xml, "nftables", err);
+	tree = ops->xmlbuilder(xml, "nftables", err);
 	if (tree == NULL)
 		return -1;
 
@@ -567,17 +569,19 @@ err:
 #endif
 }
 
-int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
-		      const char *data, struct nft_parse_err *err)
+static int
+nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
+		     const void *data, struct nft_parse_err *err,
+		     const struct nft_parse_ops *ops)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_ruleset_xml_parse(r, data, err);
+		ret = nft_ruleset_xml_parse(r, data, err, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_ruleset_json_parse(r, data, err);
+		ret = nft_ruleset_json_parse(r, data, err, ops);
 		break;
 	default:
 		ret = -1;
@@ -587,6 +591,13 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
+		      const char *data, struct nft_parse_err *err)
+{
+	return nft_ruleset_do_parse(rs, type, data, err,
+				    &nft_parse_string_ops);
+}
 EXPORT_SYMBOL(nft_ruleset_parse);
 
 static const char *nft_ruleset_o_opentag(uint32_t type)
diff --git a/src/set.c b/src/set.c
index 9317b9c..248619c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -376,13 +376,14 @@ err:
 #endif
 
 static int nft_set_json_parse(struct nft_set *s, const char *json,
-			      struct nft_parse_err *err)
+			      struct nft_parse_err *err,
+			      const struct nft_parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = ops->jsonbuilder(json, &error, err);
 	if (tree == NULL)
 		return -1;
 
@@ -484,11 +485,12 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 #endif
 
 static int nft_set_xml_parse(struct nft_set *s, const char *xml,
-			     struct nft_parse_err *err)
+			     struct nft_parse_err *err,
+			     const struct nft_parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "set", err);
+	mxml_node_t *tree = ops->xmlbuilder(xml, "set", err);
 	if (tree == NULL)
 		return -1;
 
@@ -501,18 +503,19 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml,
 #endif
 }
 
-int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
-		  const char *data, struct nft_parse_err *err)
+static int nft_set_do_parse(struct nft_set *s, enum nft_parse_type type,
+			    const void *data, struct nft_parse_err *err,
+			    const struct nft_parse_ops *ops)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_set_xml_parse(s, data, &perr);
+		ret = nft_set_xml_parse(s, data, &perr, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_set_json_parse(s, data, &perr);
+		ret = nft_set_json_parse(s, data, &perr, ops);
 		break;
 	default:
 		ret = -1;
@@ -525,6 +528,12 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
+		  const char *data, struct nft_parse_err *err)
+{
+	return nft_set_do_parse(s, type, data, err, &nft_parse_string_ops);
+}
 EXPORT_SYMBOL(nft_set_parse);
 
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
diff --git a/src/set_elem.c b/src/set_elem.c
index 14bf6f4..1861902 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -395,13 +395,14 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
 #endif
 
 static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml,
-				  struct nft_parse_err *err)
+				  struct nft_parse_err *err,
+				  const struct nft_parse_ops *ops)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 	int ret;
 
-	tree = nft_mxml_build_tree(xml, "set_elem", err);
+	tree = ops->xmlbuilder(xml, "set_elem", err);
 	if (tree == NULL)
 		return -1;
 
@@ -415,13 +416,14 @@ static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml,
 }
 
 static int nft_set_elem_json_parse(struct nft_set_elem *e, const void *json,
-				   struct nft_parse_err *err)
+				   struct nft_parse_err *err,
+				   const struct nft_parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = ops->jsonbuilder(json, &error, err);
 	if (tree == NULL)
 		return -1;
 
@@ -432,17 +434,19 @@ static int nft_set_elem_json_parse(struct nft_set_elem *e, const void *json,
 #endif
 }
 
-int nft_set_elem_parse(struct nft_set_elem *e,
-		       enum nft_parse_type type, const char *data,
-		       struct nft_parse_err *err) {
+static int
+nft_set_elem_do_parse(struct nft_set_elem *e, enum nft_parse_type type,
+		      const void *data, struct nft_parse_err *err,
+		      const struct nft_parse_ops *ops)
+{
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_set_elem_xml_parse(e, data, err);
+		ret = nft_set_elem_xml_parse(e, data, err, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_set_elem_json_parse(e, data, err);
+		ret = nft_set_elem_json_parse(e, data, err, ops);
 		break;
 	default:
 		errno = EOPNOTSUPP;
@@ -452,6 +456,14 @@ int nft_set_elem_parse(struct nft_set_elem *e,
 
 	return ret;
 }
+
+int nft_set_elem_parse(struct nft_set_elem *e,
+		       enum nft_parse_type type, const char *data,
+		       struct nft_parse_err *err)
+{
+	return nft_set_elem_do_parse(e, type, data, err,
+				     &nft_parse_string_ops);
+}
 EXPORT_SYMBOL(nft_set_elem_parse);
 
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
diff --git a/src/table.c b/src/table.c
index 9b5f5c9..7fb79dc 100644
--- a/src/table.c
+++ b/src/table.c
@@ -248,11 +248,12 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 #endif
 
 static int nft_table_xml_parse(struct nft_table *t, const char *xml,
-			       struct nft_parse_err *err)
+			       struct nft_parse_err *err,
+			       const struct nft_parse_ops *ops)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "table", err);
+	mxml_node_t *tree = ops->xmlbuilder(xml, "table", err);
 	if (tree == NULL)
 		return -1;
 
@@ -303,13 +304,14 @@ err:
 #endif
 
 static int nft_table_json_parse(struct nft_table *t, const char *json,
-				struct nft_parse_err *err)
+				struct nft_parse_err *err,
+				const struct nft_parse_ops *ops)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = ops->jsonbuilder(json, &error, err);
 	if (tree == NULL)
 		return -1;
 
@@ -320,18 +322,19 @@ static int nft_table_json_parse(struct nft_table *t, const char *json,
 #endif
 }
 
-int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
-		    const char *data, struct nft_parse_err *err)
+static int nft_table_do_parse(struct nft_table *t, enum nft_parse_type type,
+			      const void *data, struct nft_parse_err *err,
+			      const struct nft_parse_ops *ops)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_table_xml_parse(t, data, &perr);
+		ret = nft_table_xml_parse(t, data, &perr, ops);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_table_json_parse(t, data, &perr);
+		ret = nft_table_json_parse(t, data, &perr, ops);
 		break;
 	default:
 		ret = -1;
@@ -344,6 +347,12 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err)
+{
+	return nft_table_do_parse(t, type, data, err, &nft_parse_string_ops);
+}
 EXPORT_SYMBOL(nft_table_parse);
 
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)

