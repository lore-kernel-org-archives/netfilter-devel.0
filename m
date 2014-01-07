From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 5/6] parsing: add interface to parse from file
Date: Tue, 07 Jan 2014 12:47:37 +0100
Message-ID: <20140107114737.12841.536.stgit@nfdev.cica.es>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46624 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750867AbaAGLrq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:47:46 -0500
In-Reply-To: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds API interfaces to parse nft objects from a given stream.

I found this useful in `nft', where I'm trying to parse XML/JSON from a file.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index dec1a77..d213bf1 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -53,6 +53,8 @@ void nft_chain_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_chain
 
 int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 		    const char *data, struct nft_parse_err *err);
+int nft_chain_parse_file(struct nft_chain *c, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
 int nft_chain_fprintf(FILE *fp, struct nft_chain *c, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 1510203..48b9974 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -49,6 +49,8 @@ void nft_rule_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_rule *t);
 
 int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 		   const char *data, struct nft_parse_err *err);
+int nft_rule_parse_file(struct nft_rule *r, enum nft_parse_type type,
+			FILE *fp, struct nft_parse_err *err);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
 int nft_rule_fprintf(FILE *fp, struct nft_rule *r, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index b523346..f916fba 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -32,6 +32,8 @@ const void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
 
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
 		      const char *data, struct nft_parse_err *err);
+int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
+			   FILE *fp, struct nft_parse_err *err);
 int nft_ruleset_snprintf(char *buf, size_t size, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 int nft_ruleset_fprintf(FILE *fp, const struct nft_ruleset *rs, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 9711729..c4b1ff6 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -62,6 +62,8 @@ void nft_set_list_iter_destroy(struct nft_set_list_iter *iter);
 
 int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 		  const char *data, struct nft_parse_err *err);
+int nft_set_parse_file(struct nft_set *s, enum nft_parse_type type,
+		       FILE *fp, struct nft_parse_err *err);
 
 /*
  * Set elements
@@ -101,6 +103,8 @@ int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s)
 
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
 		       const char *data, struct nft_parse_err *err);
+int nft_set_elem_parse_file(struct nft_set_elem *e, enum nft_parse_type type,
+			    FILE *fp, struct nft_parse_err *err);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
 int nft_set_elem_fprintf(FILE *fp, struct nft_set_elem *se, uint32_t type, uint32_t flags);
 
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 80f2349..64fbf88 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -41,6 +41,8 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
 
 int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 		    const char *data, struct nft_parse_err *err);
+int nft_table_parse_file(struct nft_table *t, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
 int nft_table_fprintf(FILE *fp, struct nft_table *t, uint32_t type, uint32_t flags);
 
diff --git a/src/chain.c b/src/chain.c
index fd56629..6d311b5 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -761,6 +761,13 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse);
 
+int nft_chain_parse_file(struct nft_chain *c, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err)
+{
+	return nft_chain_do_parse(c, type, fp, err, &nft_parse_file_ops);
+}
+EXPORT_SYMBOL(nft_chain_parse_file);
+
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
diff --git a/src/internal.h b/src/internal.h
index afd8816..1a98685 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -48,6 +48,8 @@ struct nft_parse_err {
 #define NFT_XML_OPT (1 << 0)
 mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 				 struct nft_parse_err *err);
+mxml_node_t *nft_mxml_build_tree_file(const void *data, const char *treename,
+				      struct nft_parse_err *err);
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 					  struct nft_parse_err *err);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags,
@@ -97,6 +99,8 @@ const char *nft_jansson_parse_str(json_t *root, const char *node_name,
 bool nft_jansson_node_exist(json_t *root, const char *node_name);
 json_t *nft_jansson_create_root(const void *data, json_error_t *error,
 				struct nft_parse_err *err);
+json_t *nft_jansson_create_root_file(const void *data, json_error_t *jerror,
+				     struct nft_parse_err *err);
 json_t *nft_jansson_get_node(json_t *root, const char *node_name,
 			     struct nft_parse_err *err);
 void nft_jansson_free_root(json_t *root);
@@ -145,6 +149,15 @@ static const struct nft_parse_ops nft_parse_string_ops = {
 #endif
 };
 
+static const struct nft_parse_ops nft_parse_file_ops = {
+#ifdef XML_PARSING
+	.xmlbuilder = nft_mxml_build_tree_file,
+#endif
+#ifdef JSON_PARSING
+	.jsonbuilder = nft_jansson_create_root_file
+#endif
+};
+
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
 int nft_strtoi(const char *string, int base, void *number, enum nft_type type);
diff --git a/src/jansson.c b/src/jansson.c
index 90faeca..20aa822 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -114,6 +114,30 @@ json_t *nft_jansson_create_root(const void *data, json_error_t *error,
 	return nft_jansson_do_create_root(data, error, err);
 }
 
+static json_t *nft_jansson_do_create_root_file(FILE *f, json_error_t *jerror,
+					       struct nft_parse_err *err)
+{
+	json_t *root;
+
+	root = json_loadf(f, 0, jerror);
+	if (root == NULL) {
+		err->error = NFT_PARSE_EBADINPUT;
+		err->line = jerror->line;
+		err->column = jerror->column;
+		err->node_name = jerror->source;
+		errno = EINVAL;
+		return NULL;
+	}
+
+	return root;
+}
+
+json_t *nft_jansson_create_root_file(const void *data, json_error_t *jerror,
+				     struct nft_parse_err *err)
+{
+	return nft_jansson_do_create_root_file((FILE *)data, jerror, err);
+}
+
 json_t *nft_jansson_get_node(json_t *root, const char *node_name,
 			     struct nft_parse_err *err)
 {
diff --git a/src/libnftables.map b/src/libnftables.map
index be5c783..faf0913 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -13,6 +13,7 @@ global:
   nft_table_attr_get_u32;
   nft_table_attr_get_str;
   nft_table_parse;
+  nft_table_parse_file;
   nft_table_snprintf;
   nft_table_fprintf;
   nft_table_nlmsg_build_payload;
@@ -45,6 +46,7 @@ global:
   nft_chain_attr_get_u64;
   nft_chain_attr_get_str;
   nft_chain_parse;
+  nft_chain_parse_file;
   nft_chain_snprintf;
   nft_chain_fprintf;
   nft_chain_nlmsg_build_payload;
@@ -74,6 +76,7 @@ global:
   nft_rule_attr_get_u64;
   nft_rule_attr_get_str;
   nft_rule_parse;
+  nft_rule_parse_file;
   nft_rule_snprintf;
   nft_rule_fprintf;
   nft_rule_nlmsg_build_payload;
@@ -128,6 +131,7 @@ global:
   nft_set_nlmsg_build_payload;
   nft_set_nlmsg_parse;
   nft_set_parse;
+  nft_set_parse_file;
   nft_set_snprintf;
   nft_set_fprintf;
 
@@ -159,6 +163,7 @@ global:
   nft_set_elem_nlmsg_build_payload;
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
+  nft_set_elem_parse_file;
   nft_set_elem_snprintf;
   nft_set_elem_fprinf;
 
@@ -179,6 +184,7 @@ global:
   nft_ruleset_attr_set;
   nft_ruleset_attr_get;
   nft_ruleset_parse;
+  nft_ruleset_parse_file;
   nft_ruleset_snprintf;
   nft_ruleset_fprintf;
 
diff --git a/src/mxml.c b/src/mxml.c
index 13a8b89..9851365 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -54,6 +54,37 @@ mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 	return nft_mxml_do_build_tree(data, treename, err);
 }
 
+static mxml_node_t *nft_mxml_do_build_tree_file(FILE *f, const char *treename,
+						struct nft_parse_err *err)
+{
+	mxml_node_t *tree;
+
+	tree = mxmlLoadFile(NULL, f, MXML_OPAQUE_CALLBACK);
+	if (tree == NULL) {
+		err->error = NFT_PARSE_EBADINPUT;
+		goto err;
+	}
+
+	if (strcmp(tree->value.opaque, treename) == 0)
+		return tree;
+
+	err->error = NFT_PARSE_EMISSINGNODE;
+	err->node_name = treename;
+
+	mxmlDelete(tree);
+err:
+	err->line = 0;
+	err->column = 0;
+	errno = EINVAL;
+	return NULL;
+}
+
+mxml_node_t *nft_mxml_build_tree_file(const void *data, const char *treename,
+				      struct nft_parse_err *err)
+{
+	return nft_mxml_do_build_tree_file((FILE *)data, treename, err);
+}
+
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 					  struct nft_parse_err *err)
 {
diff --git a/src/rule.c b/src/rule.c
index 6f5718d..268acbf 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -679,6 +679,13 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_rule_parse);
 
+int nft_rule_parse_file(struct nft_rule *r, enum nft_parse_type type,
+			FILE *fp, struct nft_parse_err *err)
+{
+	return nft_rule_do_parse(r, type, fp, err, &nft_parse_file_ops);
+}
+EXPORT_SYMBOL(nft_rule_parse_file);
+
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 					 uint32_t type, uint32_t flags)
 {
diff --git a/src/ruleset.c b/src/ruleset.c
index 84ada20..2676a71 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -600,6 +600,13 @@ int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_ruleset_parse);
 
+int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
+			   FILE *fp, struct nft_parse_err *err)
+{
+	return nft_ruleset_do_parse(rs, type, fp, err, &nft_parse_file_ops);
+}
+EXPORT_SYMBOL(nft_ruleset_parse_file);
+
 static const char *nft_ruleset_o_opentag(uint32_t type)
 {
 	switch (type) {
diff --git a/src/set.c b/src/set.c
index 248619c..e374e12 100644
--- a/src/set.c
+++ b/src/set.c
@@ -536,6 +536,13 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_set_parse);
 
+int nft_set_parse_file(struct nft_set *s, enum nft_parse_type type,
+		       FILE *fp, struct nft_parse_err *err)
+{
+	return nft_set_do_parse(s, type, fp, err, &nft_parse_file_ops);
+}
+EXPORT_SYMBOL(nft_set_parse_file);
+
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 				  uint32_t type, uint32_t flags)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index 1861902..95eab6d 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -466,6 +466,13 @@ int nft_set_elem_parse(struct nft_set_elem *e,
 }
 EXPORT_SYMBOL(nft_set_elem_parse);
 
+int nft_set_elem_parse_file(struct nft_set_elem *e, enum nft_parse_type type,
+			    FILE *fp, struct nft_parse_err *err)
+{
+	return nft_set_elem_do_parse(e, type, fp, err, &nft_parse_file_ops);
+}
+EXPORT_SYMBOL(nft_set_elem_parse_file);
+
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
 				      struct nft_set_elem *e, uint32_t flags)
 {
diff --git a/src/table.c b/src/table.c
index 7fb79dc..9de93e2 100644
--- a/src/table.c
+++ b/src/table.c
@@ -355,6 +355,13 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_table_parse);
 
+int nft_table_parse_file(struct nft_table *t, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err)
+{
+	return nft_table_do_parse(t, type, fp, err, &nft_parse_file_ops);
+}
+EXPORT_SYMBOL(nft_table_parse_file);
+
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,

