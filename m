From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/3] parsing: rework and generalize the
	build/parse system
Date: Thu, 09 Jan 2014 12:19:06 +0100
Message-ID: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42309 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755229AbaAILTO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:19:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The intention behind this patch is to allow adding more input sources in the
near future.
For this to happen without duplicating many code, we need to generalize
the build/parse system.

The path flow is now as follow:
 * API func: here we decide what kind of input we have.
	nft_table_parse()

 * Common function to decide what format to parse (JSON/XML).
	nft_table_do_parse()

 * Common function per format to order the build of the tree and launch the
   parsing:
	nft_table_xml_parse()
	nft_table_json_parse()

 * Common function per format to build the tree (here more builders can be
   easily implemented):
	nft_mxml_build_tree()
	nft_jansson_create_root()

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/chain.c b/src/chain.c
index a4ddb06..a7a6d99 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -591,14 +591,14 @@ err:
 }
 #endif
 
-static int nft_chain_json_parse(struct nft_chain *c, const char *json,
-				struct nft_parse_err *err)
+static int nft_chain_json_parse(struct nft_chain *c, const void *json,
+				struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = nft_jansson_create_root(json, &error, err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -708,12 +708,12 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 }
 #endif
 
-static int nft_chain_xml_parse(struct nft_chain *c, const char *xml,
-			       struct nft_parse_err *err)
+static int nft_chain_xml_parse(struct nft_chain *c, const void *xml,
+			       struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "chain", err);
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "chain", err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -726,18 +726,19 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml,
 #endif
 }
 
-int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
-		    const char *data, struct nft_parse_err *err)
+static int nft_chain_do_parse(struct nft_chain *c, enum nft_parse_type type,
+			      const void *data, struct nft_parse_err *err,
+			      uint32_t buildsrc)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_chain_xml_parse(c, data, &perr);
+		ret = nft_chain_xml_parse(c, data, &perr, buildsrc);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_chain_json_parse(c, data, &perr);
+		ret = nft_chain_json_parse(c, data, &perr, buildsrc);
 		break;
 	default:
 		ret = -1;
@@ -750,6 +751,11 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 
 	return ret;
 }
+int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err)
+{
+	return nft_chain_do_parse(c, type, data, err, NFT_PARSE_BUFFER);
+}
 EXPORT_SYMBOL(nft_chain_parse);
 
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
diff --git a/src/internal.h b/src/internal.h
index 5fef6d6..8850736 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -38,12 +38,16 @@ struct nft_parse_err {
 	const char *node_name;
 };
 
+enum {
+	NFT_PARSE_BUFFER,
+};
+
 #ifdef XML_PARSING
 #include <mxml.h>
 #define NFT_XML_MAND 0
 #define NFT_XML_OPT (1 << 0)
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
-				 struct nft_parse_err *err);
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
+				 struct nft_parse_err *err, uint32_t buildsrc);
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 					  struct nft_parse_err *err);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags,
@@ -88,8 +92,8 @@ int nft_jansson_parse_val(json_t *root, const char *node_name, int type,
 const char *nft_jansson_parse_str(json_t *root, const char *node_name,
 				  struct nft_parse_err *err);
 bool nft_jansson_node_exist(json_t *root, const char *node_name);
-json_t *nft_jansson_create_root(const char *json, json_error_t *error,
-				struct nft_parse_err *err);
+json_t *nft_jansson_create_root(const void *json, json_error_t *error,
+				struct nft_parse_err *err, uint32_t buildsrc);
 json_t *nft_jansson_get_node(json_t *root, const char *node_name,
 			     struct nft_parse_err *err);
 void nft_jansson_free_root(json_t *root);
diff --git a/src/jansson.c b/src/jansson.c
index e62116b..cb6212b 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -89,22 +89,31 @@ bool nft_jansson_node_exist(json_t *root, const char *node_name)
 	return json_object_get(root, node_name) != NULL;
 }
 
-json_t *nft_jansson_create_root(const char *json, json_error_t *error,
-				struct nft_parse_err *err)
+json_t *nft_jansson_create_root(const void *json, json_error_t *error,
+				struct nft_parse_err *err, uint32_t buildsrc)
 {
 	json_t *root;
 
-	root = json_loadb(json, strlen(json), 0, error);
+	switch (buildsrc) {
+	case NFT_PARSE_BUFFER:
+		root = json_loadb(json, strlen(json), 0, error);
+		break;
+	default:
+		goto err;
+	}
+
 	if (root == NULL) {
 		err->error = NFT_PARSE_EBADINPUT;
 		err->line = error->line;
 		err->column = error->column;
 		err->node_name = error->source;
-		errno = EINVAL;
-		return NULL;
+		goto err;
 	}
 
 	return root;
+err:
+	errno = EINVAL;
+	return NULL;
 }
 
 json_t *nft_jansson_get_node(json_t *root, const char *node_name,
diff --git a/src/mxml.c b/src/mxml.c
index bc0f084..e4151ae 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -22,12 +22,19 @@
 #include <libnftables/set.h>
 
 #ifdef XML_PARSING
-mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
-				 struct nft_parse_err *err)
+mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
+				 struct nft_parse_err *err, uint32_t buildsrc)
 {
 	mxml_node_t *tree;
 
-	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
+	switch (buildsrc) {
+	case NFT_PARSE_BUFFER:
+		tree = mxmlLoadString(NULL, data, MXML_OPAQUE_CALLBACK);
+		break;
+	default:
+		goto err;
+	}
+
 	if (tree == NULL) {
 		err->error = NFT_PARSE_EBADINPUT;
 		goto err;
diff --git a/src/rule.c b/src/rule.c
index 2e35aba..0eabd45 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -526,14 +526,14 @@ err:
 }
 #endif
 
-static int nft_rule_json_parse(struct nft_rule *r, const char *json,
-			       struct nft_parse_err *err)
+static int nft_rule_json_parse(struct nft_rule *r, const void *json,
+			       struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = nft_jansson_create_root(json, &error, err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -627,12 +627,12 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
 }
 #endif
 
-static int nft_rule_xml_parse(struct nft_rule *r, const char *xml,
-			      struct nft_parse_err *err)
+static int nft_rule_xml_parse(struct nft_rule *r, const void *xml,
+			      struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "rule", err);
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "rule", err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -645,18 +645,19 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml,
 #endif
 }
 
-int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
-		   const char *data, struct nft_parse_err *err)
+static int nft_rule_do_parse(struct nft_rule *r, enum nft_parse_type type,
+			     const void *data, struct nft_parse_err *err,
+			     uint32_t buildsrc)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_rule_xml_parse(r, data, &perr);
+		ret = nft_rule_xml_parse(r, data, &perr, buildsrc);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_rule_json_parse(r, data, &perr);
+		ret = nft_rule_json_parse(r, data, &perr, buildsrc);
 		break;
 	default:
 		ret = -1;
@@ -668,6 +669,11 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 
 	return ret;
 }
+int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
+		   const char *data, struct nft_parse_err *err)
+{
+	return nft_rule_do_parse(r, type, data, err, NFT_PARSE_BUFFER);
+}
 EXPORT_SYMBOL(nft_rule_parse);
 
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
diff --git a/src/ruleset.c b/src/ruleset.c
index a12efa9..9ca15c2 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -330,14 +330,14 @@ err:
 
 #endif
 
-static int nft_ruleset_json_parse(struct nft_ruleset *rs, const char *json,
-				  struct nft_parse_err *err)
+static int nft_ruleset_json_parse(struct nft_ruleset *rs, const void *json,
+				  struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef JSON_PARSING
 	json_t *root, *array;
 	json_error_t error;
 
-	root = nft_jansson_create_root(json, &error, err);
+	root = nft_jansson_create_root(json, &error, err, buildsrc);
 	if (root == NULL)
 		return -1;
 
@@ -534,13 +534,13 @@ err_free:
 }
 #endif
 
-static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const char *xml,
-				 struct nft_parse_err *err)
+static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const void *xml,
+				 struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 
-	tree = nft_mxml_build_tree(xml, "nftables", err);
+	tree = nft_mxml_build_tree(xml, "nftables", err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -567,17 +567,19 @@ err:
 #endif
 }
 
-int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
-		      const char *data, struct nft_parse_err *err)
+static int
+nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
+		     const void *data, struct nft_parse_err *err,
+		     uint32_t buildsrc)
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_ruleset_xml_parse(r, data, err);
+		ret = nft_ruleset_xml_parse(r, data, err, buildsrc);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_ruleset_json_parse(r, data, err);
+		ret = nft_ruleset_json_parse(r, data, err, buildsrc);
 		break;
 	default:
 		ret = -1;
@@ -587,6 +589,12 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
+		      const char *data, struct nft_parse_err *err)
+{
+	return nft_ruleset_do_parse(r, type, data, err, NFT_PARSE_BUFFER);
+}
 EXPORT_SYMBOL(nft_ruleset_parse);
 
 static const char *nft_ruleset_o_opentag(uint32_t type)
diff --git a/src/set.c b/src/set.c
index 9317b9c..009128b 100644
--- a/src/set.c
+++ b/src/set.c
@@ -375,14 +375,14 @@ err:
 }
 #endif
 
-static int nft_set_json_parse(struct nft_set *s, const char *json,
-			      struct nft_parse_err *err)
+static int nft_set_json_parse(struct nft_set *s, const void *json,
+			      struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = nft_jansson_create_root(json, &error, err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -483,12 +483,12 @@ int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 }
 #endif
 
-static int nft_set_xml_parse(struct nft_set *s, const char *xml,
-			     struct nft_parse_err *err)
+static int nft_set_xml_parse(struct nft_set *s, const void *xml,
+			     struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "set", err);
+	mxml_node_t *tree = nft_mxml_build_tree(xml, "set", err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -501,18 +501,19 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml,
 #endif
 }
 
-int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
-		  const char *data, struct nft_parse_err *err)
+static int nft_set_do_parse(struct nft_set *s, enum nft_parse_type type,
+			    const void *data, struct nft_parse_err *err,
+			    uint32_t buildsrc)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_set_xml_parse(s, data, &perr);
+		ret = nft_set_xml_parse(s, data, &perr, buildsrc);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_set_json_parse(s, data, &perr);
+		ret = nft_set_json_parse(s, data, &perr, buildsrc);
 		break;
 	default:
 		ret = -1;
@@ -525,6 +526,11 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 
 	return ret;
 }
+int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
+		  const char *data, struct nft_parse_err *err)
+{
+	return nft_set_do_parse(s, type, data, err, NFT_PARSE_BUFFER);
+}
 EXPORT_SYMBOL(nft_set_parse);
 
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
diff --git a/src/set_elem.c b/src/set_elem.c
index 14bf6f4..7b18cc4 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -394,14 +394,14 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
 }
 #endif
 
-static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml,
-				  struct nft_parse_err *err)
+static int nft_set_elem_xml_parse(struct nft_set_elem *e, const void *xml,
+				  struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
 	int ret;
 
-	tree = nft_mxml_build_tree(xml, "set_elem", err);
+	tree = nft_mxml_build_tree(xml, "set_elem", err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -415,13 +415,13 @@ static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml,
 }
 
 static int nft_set_elem_json_parse(struct nft_set_elem *e, const void *json,
-				   struct nft_parse_err *err)
+				   struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = nft_jansson_create_root(json, &error, err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -432,17 +432,19 @@ static int nft_set_elem_json_parse(struct nft_set_elem *e, const void *json,
 #endif
 }
 
-int nft_set_elem_parse(struct nft_set_elem *e,
-		       enum nft_parse_type type, const char *data,
-		       struct nft_parse_err *err) {
+static int
+nft_set_elem_do_parse(struct nft_set_elem *e, enum nft_parse_type type,
+		      const void *data, struct nft_parse_err *err,
+		      uint32_t buildsrc)
+{
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_set_elem_xml_parse(e, data, err);
+		ret = nft_set_elem_xml_parse(e, data, err, buildsrc);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_set_elem_json_parse(e, data, err);
+		ret = nft_set_elem_json_parse(e, data, err, buildsrc);
 		break;
 	default:
 		errno = EOPNOTSUPP;
@@ -452,6 +454,11 @@ int nft_set_elem_parse(struct nft_set_elem *e,
 
 	return ret;
 }
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
+		       const char *data, struct nft_parse_err *err)
+{
+	return nft_set_elem_do_parse(e, type, data, err, NFT_PARSE_BUFFER);
+}
 EXPORT_SYMBOL(nft_set_elem_parse);
 
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
diff --git a/src/table.c b/src/table.c
index 9b5f5c9..8e4d17b 100644
--- a/src/table.c
+++ b/src/table.c
@@ -247,12 +247,12 @@ int nft_mxml_table_parse(mxml_node_t *tree, struct nft_table *t,
 }
 #endif
 
-static int nft_table_xml_parse(struct nft_table *t, const char *xml,
-			       struct nft_parse_err *err)
+static int nft_table_xml_parse(struct nft_table *t, const void *data,
+			       struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef XML_PARSING
 	int ret;
-	mxml_node_t *tree = nft_mxml_build_tree(xml, "table", err);
+	mxml_node_t *tree = nft_mxml_build_tree(data, "table", err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -302,14 +302,14 @@ err:
 }
 #endif
 
-static int nft_table_json_parse(struct nft_table *t, const char *json,
-				struct nft_parse_err *err)
+static int nft_table_json_parse(struct nft_table *t, const void *json,
+				struct nft_parse_err *err, uint32_t buildsrc)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
 	json_error_t error;
 
-	tree = nft_jansson_create_root(json, &error, err);
+	tree = nft_jansson_create_root(json, &error, err, buildsrc);
 	if (tree == NULL)
 		return -1;
 
@@ -320,18 +320,19 @@ static int nft_table_json_parse(struct nft_table *t, const char *json,
 #endif
 }
 
-int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
-		    const char *data, struct nft_parse_err *err)
+static int nft_table_do_parse(struct nft_table *t, enum nft_parse_type type,
+			      const void *data, struct nft_parse_err *err,
+			      uint32_t buildsrc)
 {
 	int ret;
 	struct nft_parse_err perr;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_table_xml_parse(t, data, &perr);
+		ret = nft_table_xml_parse(t, data, &perr, buildsrc);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_table_json_parse(t, data, &perr);
+		ret = nft_table_json_parse(t, data, &perr, buildsrc);
 		break;
 	default:
 		ret = -1;
@@ -344,6 +345,12 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 
 	return ret;
 }
+
+int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
+		    const char *data, struct nft_parse_err *err)
+{
+	return nft_table_do_parse(t, type, data, err, NFT_PARSE_BUFFER);
+}
 EXPORT_SYMBOL(nft_table_parse);
 
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)

