From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/2] src: internal set id allocation from nft_ruleset_parse*()
Date: Fri,  3 Oct 2014 20:02:40 +0200
Message-ID: <1412359360-30695-2-git-send-email-alvaroneay@gmail.com>
References: <1412359360-30695-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60976 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaJCSC3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:02:29 -0400
Received: by mail-wi0-f177.google.com with SMTP id fb4so2917039wid.4
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Oct 2014 11:02:28 -0700 (PDT)
Received: from localhost.localdomain (152.88.221.87.dynamic.jazztel.es. [87.221.88.152])
        by mx.google.com with ESMTPSA id lf1sm8681623wjb.24.2014.10.03.11.02.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Oct 2014 11:02:27 -0700 (PDT)
In-Reply-To: <1412359360-30695-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extends this function to attach the set to the rule through the set_id. If it
doesn't exist in the list, maybe the set exists in the kernel. In that case, we
don't set any id.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/internal.h |   17 +++++++++++++----
 src/jansson.c  |   11 +++++++++--
 src/mxml.c     |   11 +++++++++--
 src/rule.c     |   26 ++++++++++++++++----------
 src/ruleset.c  |    9 +++++----
 src/set.c      |   43 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 95 insertions(+), 22 deletions(-)

diff --git a/src/internal.h b/src/internal.h
index c8dea7e..d2f944e 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -52,8 +52,10 @@ enum nft_parse_input {
 #define NFT_XML_OPT (1 << 0)
 mxml_node_t *nft_mxml_build_tree(const void *data, const char *treename,
 				 struct nft_parse_err *err, enum nft_parse_input input);
+struct nft_set_list;
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
-					  struct nft_parse_err *err);
+					  struct nft_parse_err *err,
+					  struct nft_set_list *set_list);
 int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t *reg,
 		       uint32_t mxmlflags, uint32_t flags,
 		       struct nft_parse_err *err);
@@ -83,12 +85,16 @@ int nft_mxml_chain_parse(mxml_node_t *tree, struct nft_chain *c,
 			 struct nft_parse_err *err);
 struct nft_rule;
 int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
-			struct nft_parse_err *err);
+			struct nft_parse_err *err,
+			struct nft_set_list *set_list);
 struct nft_set;
 int nft_mxml_set_parse(mxml_node_t *tree, struct nft_set *s,
 		       struct nft_parse_err *err);
 #endif
 
+int nft_set_lookup_id(struct nft_rule_expr *e, struct nft_set_list *set_list,
+		      uint32_t *set_id);
+
 #ifdef JSON_PARSING
 #include <jansson.h>
 
@@ -108,7 +114,8 @@ int nft_jansson_str2num(json_t *root, const char *node_name, int base, void *out
 int nft_jansson_parse_reg(json_t *root, const char *node_name, int type,
 			  void *out, struct nft_parse_err *err);
 struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
-					     struct nft_parse_err *err);
+					     struct nft_parse_err *err,
+					     struct nft_set_list *set_list);
 union nft_data_reg;
 int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 			       union nft_data_reg *data_reg,
@@ -123,8 +130,10 @@ struct nft_chain;
 int nft_jansson_parse_chain(struct nft_chain *c, json_t *tree,
 			    struct nft_parse_err *err);
 struct nft_rule;
+struct nft_set_list;
 int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
-			   struct nft_parse_err *err);
+			   struct nft_parse_err *err,
+			   struct nft_set_list *set_list);
 struct nft_set;
 int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			  struct nft_parse_err *err);
diff --git a/src/jansson.c b/src/jansson.c
index 377d06e..728de12 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -187,11 +187,13 @@ int nft_jansson_str2num(json_t *root, const char *node_name, int base,
 }
 
 struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
-					     struct nft_parse_err *err)
+					     struct nft_parse_err *err,
+					     struct nft_set_list *set_list)
 {
 	struct nft_rule_expr *e;
 	const char *type;
-	int ret;
+	struct nft_set *set_cur = NULL;
+	int ret, set_id;
 
 	type = nft_jansson_parse_str(root, "type", err);
 	if (type == NULL)
@@ -205,6 +207,11 @@ struct nft_rule_expr *nft_jansson_expr_parse(json_t *root,
 
 	ret = e->ops->json_parse(e, root, err);
 
+	if (set_list != NULL &&
+	    strcmp(type, "lookup") == 0 &&
+	    nft_set_lookup_id(e, set_list, &set_id))
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SET_ID, set_id);
+
 	return ret < 0 ? NULL : e;
 }
 
diff --git a/src/mxml.c b/src/mxml.c
index 5e4f022..22d482f 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -58,13 +58,15 @@ err:
 }
 
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
-					  struct nft_parse_err *err)
+					  struct nft_parse_err *err,
+					  struct nft_set_list *set_list)
 {
 	mxml_node_t *tree;
 	struct nft_rule_expr *e;
 	const char *expr_name;
 	char *xml_text;
-	int ret;
+	struct nft_set *set_cur = NULL;
+	int ret, set_id;
 
 	expr_name = mxmlElementGetAttr(node, "type");
 	if (expr_name == NULL) {
@@ -90,6 +92,11 @@ struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node,
 	ret = e->ops->xml_parse(e, tree, err);
 	mxmlDelete(tree);
 
+	if (set_list != NULL &&
+	    strcmp(expr_name, "lookup") == 0 &&
+	    nft_set_lookup_id(e, set_list, &set_id))
+		nft_rule_expr_set_u32(e, NFT_EXPR_LOOKUP_SET_ID, set_id);
+
 	return ret < 0 ? NULL : e;
 err_expr:
 	nft_rule_expr_free(e);
diff --git a/src/rule.c b/src/rule.c
index ec5f9a8..c974f8b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -26,6 +26,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libnftnl/rule.h>
+#include <libnftnl/set.h>
 #include <libnftnl/expr.h>
 
 #include "linux_list.h"
@@ -511,7 +512,8 @@ EXPORT_SYMBOL(nft_rule_nlmsg_parse);
 
 #ifdef JSON_PARSING
 int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
-			   struct nft_parse_err *err)
+			   struct nft_parse_err *err,
+			   struct nft_set_list *set_list)
 {
 	json_t *root, *array;
 	struct nft_rule_expr *e;
@@ -587,7 +589,8 @@ int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
 
 	for (i = 0; i < json_array_size(array); ++i) {
 
-		e = nft_jansson_expr_parse(json_array_get(array, i), err);
+		e = nft_jansson_expr_parse(json_array_get(array, i), err,
+					   set_list);
 		if (e == NULL)
 			goto err;
 
@@ -604,7 +607,8 @@ err:
 
 static int nft_rule_json_parse(struct nft_rule *r, const void *json,
 			       struct nft_parse_err *err,
-			       enum nft_parse_input input)
+			       enum nft_parse_input input,
+			       struct nft_set_list *set_list)
 {
 #ifdef JSON_PARSING
 	json_t *tree;
@@ -614,7 +618,7 @@ static int nft_rule_json_parse(struct nft_rule *r, const void *json,
 	if (tree == NULL)
 		return -1;
 
-	return nft_jansson_parse_rule(r, tree, err);
+	return nft_jansson_parse_rule(r, tree, err, set_list);
 #else
 	errno = EOPNOTSUPP;
 	return -1;
@@ -623,7 +627,8 @@ static int nft_rule_json_parse(struct nft_rule *r, const void *json,
 
 #ifdef XML_PARSING
 int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
-			struct nft_parse_err *err)
+			struct nft_parse_err *err,
+			struct nft_set_list *set_list)
 {
 	mxml_node_t *node;
 	struct nft_rule_expr *e;
@@ -675,7 +680,7 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
 		node != NULL;
 		node = mxmlFindElement(node, tree, "expr", "type",
 				       NULL, MXML_DESCEND)) {
-		e = nft_mxml_expr_parse(node, err);
+		e = nft_mxml_expr_parse(node, err, set_list);
 		if (e == NULL)
 			return -1;
 
@@ -688,7 +693,8 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct nft_rule *r,
 
 static int nft_rule_xml_parse(struct nft_rule *r, const void *xml,
 			      struct nft_parse_err *err,
-			      enum nft_parse_input input)
+			      enum nft_parse_input input,
+			      struct nft_set_list *set_list)
 {
 #ifdef XML_PARSING
 	int ret;
@@ -696,7 +702,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, const void *xml,
 	if (tree == NULL)
 		return -1;
 
-	ret = nft_mxml_rule_parse(tree, r, err);
+	ret = nft_mxml_rule_parse(tree, r, err, set_list);
 	mxmlDelete(tree);
 	return ret;
 #else
@@ -714,10 +720,10 @@ static int nft_rule_do_parse(struct nft_rule *r, enum nft_parse_type type,
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_rule_xml_parse(r, data, &perr, input);
+		ret = nft_rule_xml_parse(r, data, &perr, input, NULL);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_rule_json_parse(r, data, &perr, input);
+		ret = nft_rule_json_parse(r, data, &perr, input, NULL);
 		break;
 	default:
 		ret = -1;
diff --git a/src/ruleset.c b/src/ruleset.c
index 8cc0c40..4cfeee6 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -311,7 +311,7 @@ static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t *array,
 			goto err;
 		}
 
-		if (nft_jansson_parse_rule(o, node, err) < 0) {
+		if (nft_jansson_parse_rule(o, node, err, rs->set_list) < 0) {
 			nft_rule_free(o);
 			goto err;
 		}
@@ -499,7 +499,8 @@ err_free:
 
 static int
 nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
-			    struct nft_parse_err *err)
+			    struct nft_parse_err *err,
+			    struct nft_set_list *set_list)
 {
 	mxml_node_t *node;
 	struct nft_rule *r;
@@ -518,7 +519,7 @@ nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
 		if (r == NULL)
 			goto err_free;
 
-		if (nft_mxml_rule_parse(node, r, err) != 0) {
+		if (nft_mxml_rule_parse(node, r, err, set_list) != 0) {
 			nft_rule_free(r);
 			goto err_free;
 		}
@@ -557,7 +558,7 @@ static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const void *xml,
 	if (nft_ruleset_xml_parse_sets(rs, tree, err) != 0)
 		goto err;
 
-	if (nft_ruleset_xml_parse_rules(rs, tree, err) != 0)
+	if (nft_ruleset_xml_parse_rules(rs, tree, err, rs->set_list) != 0)
 		goto err;
 
 	mxmlDelete(tree);
diff --git a/src/set.c b/src/set.c
index 3fc7a21..4421cfd 100644
--- a/src/set.c
+++ b/src/set.c
@@ -24,6 +24,7 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libnftnl/set.h>
+#include <libnftnl/expr.h>
 
 #include "linux_list.h"
 #include "expr/data_reg.h"
@@ -1059,3 +1060,45 @@ void nft_set_list_iter_destroy(struct nft_set_list_iter *iter)
 	xfree(iter);
 }
 EXPORT_SYMBOL(nft_set_list_iter_destroy);
+
+static struct nft_set *nft_set_lookup(const char *this_set_name,
+				      struct nft_set_list *set_list)
+{
+	struct nft_set_list_iter *iter;
+	struct nft_set *s;
+	const char *set_name;
+
+	iter = nft_set_list_iter_create(set_list);
+	if (iter == NULL)
+		return NULL;
+
+	s = nft_set_list_iter_cur(iter);
+	while (s != NULL) {
+		set_name  = nft_set_attr_get_str(s, NFT_SET_ATTR_NAME);
+		if (strcmp(this_set_name, set_name) == 0)
+			break;
+
+		s = nft_set_list_iter_next(iter);
+	}
+	nft_set_list_iter_destroy(iter);
+
+	return s;
+}
+
+int nft_set_lookup_id(struct nft_rule_expr *e,
+		      struct nft_set_list *set_list, uint32_t *set_id)
+{
+	const char *set_name;
+	struct nft_set *s;
+
+	set_name = nft_rule_expr_get_str(e, NFT_EXPR_LOOKUP_SET);
+	if (set_name == NULL)
+		return 0;
+
+	s = nft_set_lookup(set_name, set_list);
+	if (s == NULL)
+		return 0;
+
+	*set_id = nft_set_attr_get_u32(s, NFT_SET_ATTR_ID);
+	return 1;
+}
-- 
1.7.10.4

