From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 2/3] parsing: add interface to parse from file
Date: Thu, 09 Jan 2014 12:19:12 +0100
Message-ID: <20140109111912.32565.7315.stgit@nfdev.cica.es>
References: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42313 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbaAILTQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:19:16 -0500
In-Reply-To: <20140109111906.32565.65222.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds API interfaces to parse nft objects from a given stream.
I found this useful in `nft', where I'm trying to parse XML/JSON from a file.

In addition to the API functions, a new builder is added to handle a file.

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
index a7a6d99..e43744e 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -758,6 +758,13 @@ int nft_chain_parse(struct nft_chain *c, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_chain_parse);
 
+int nft_chain_parse_file(struct nft_chain *c, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err)
+{
+	return nft_chain_do_parse(c, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_chain_parse_file);
+
 static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 {
 	int ret, len = size, offset = 0;
diff --git a/src/internal.h b/src/internal.h
index 8850736..bf22b72 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -40,6 +40,7 @@ struct nft_parse_err {
 
 enum {
 	NFT_PARSE_BUFFER,
+	NFT_PARSE_FILE,
 };
 
 #ifdef XML_PARSING
diff --git a/src/jansson.c b/src/jansson.c
index cb6212b..1d6e739 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -98,6 +98,9 @@ json_t *nft_jansson_create_root(const void *json, json_error_t *error,
 	case NFT_PARSE_BUFFER:
 		root = json_loadb(json, strlen(json), 0, error);
 		break;
+	case NFT_PARSE_FILE:
+		root = json_loadf((FILE *)json, 0, error);
+		break;
 	default:
 		goto err;
 	}
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
index e4151ae..06cea56 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -31,6 +31,9 @@ mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 	case NFT_PARSE_BUFFER:
 		tree = mxmlLoadString(NULL, data, MXML_OPAQUE_CALLBACK);
 		break;
+	case NFT_PARSE_FILE:
+		tree = mxmlLoadFile(NULL, (FILE *)data, MXML_OPAQUE_CALLBACK);
+		break;
 	default:
 		goto err;
 	}
diff --git a/src/rule.c b/src/rule.c
index 0eabd45..60e2280 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -676,6 +676,13 @@ int nft_rule_parse(struct nft_rule *r, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_rule_parse);
 
+int nft_rule_parse_file(struct nft_rule *r, enum nft_parse_type type,
+			FILE *fp, struct nft_parse_err *err)
+{
+	return nft_rule_do_parse(r, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_rule_parse_file);
+
 static int nft_rule_snprintf_json(char *buf, size_t size, struct nft_rule *r,
 					 uint32_t type, uint32_t flags)
 {
diff --git a/src/ruleset.c b/src/ruleset.c
index 9ca15c2..1fb26a4 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -597,6 +597,13 @@ int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_ruleset_parse);
 
+int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
+			   FILE *fp, struct nft_parse_err *err)
+{
+	return nft_ruleset_do_parse(rs, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_ruleset_parse_file);
+
 static const char *nft_ruleset_o_opentag(uint32_t type)
 {
 	switch (type) {
diff --git a/src/set.c b/src/set.c
index 009128b..406af85 100644
--- a/src/set.c
+++ b/src/set.c
@@ -533,6 +533,13 @@ int nft_set_parse(struct nft_set *s, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_set_parse);
 
+int nft_set_parse_file(struct nft_set *s, enum nft_parse_type type,
+		       FILE *fp, struct nft_parse_err *err)
+{
+	return nft_set_do_parse(s, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_set_parse_file);
+
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 				  uint32_t type, uint32_t flags)
 {
diff --git a/src/set_elem.c b/src/set_elem.c
index 7b18cc4..fb67c4a 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -461,6 +461,13 @@ int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_set_elem_parse);
 
+int nft_set_elem_parse_file(struct nft_set_elem *e, enum nft_parse_type type,
+			    FILE *fp, struct nft_parse_err *err)
+{
+	return nft_set_elem_do_parse(e, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_set_elem_parse_file);
+
 static int nft_set_elem_snprintf_json(char *buf, size_t size,
 				      struct nft_set_elem *e, uint32_t flags)
 {
diff --git a/src/table.c b/src/table.c
index 8e4d17b..6e7625e 100644
--- a/src/table.c
+++ b/src/table.c
@@ -353,6 +353,13 @@ int nft_table_parse(struct nft_table *t, enum nft_parse_type type,
 }
 EXPORT_SYMBOL(nft_table_parse);
 
+int nft_table_parse_file(struct nft_table *t, enum nft_parse_type type,
+			 FILE *fp, struct nft_parse_err *err)
+{
+	return nft_table_do_parse(t, type, fp, err, NFT_PARSE_FILE);
+}
+EXPORT_SYMBOL(nft_table_parse_file);
+
 static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,

