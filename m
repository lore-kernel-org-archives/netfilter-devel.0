From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/4 v8] src: add support to import json/xml with the new command syntax
Date: Mon,  9 Feb 2015 21:09:54 +0100
Message-ID: <1423512596-29777-3-git-send-email-alvaroneay@gmail.com>
References: <1423512596-29777-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54368 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbbBIUJn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2015 15:09:43 -0500
Received: by mail-wi0-f174.google.com with SMTP id em10so3814939wid.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2015 12:09:41 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ub1sm17729984wjc.43.2015.02.09.12.09.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Feb 2015 12:09:40 -0800 (PST)
In-Reply-To: <1423512596-29777-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to parse the new syntax in xml/json. This patch adds two
new different functions nft_ruleset_parse_*_cb. The ruleset contais differents
objects (tables, chains, set and rules) of nftables. With these functions,
we can pass a callback functions as parameter and we can call for each objects.

These functions use a new structure as parameter called nft_parse_ctx. This
structure contains the command associated, the type of the object (table, chain,
rule, set or set element) and the object.

Also, with this changes, we support to parse another new ruleset syntax:

	{"nftables":[{"add":[{"element":{"name":"blackhole","table":"filter"
	"family":"ip","key_type":7,"key_len":4,"set_elem":[{"key":{
	"reg":{"type":"value","len":4,"data0":"0x0403a8c0"}}}]}}]}]}

With this new "element", we can make incremental changes to set elements.

In short, these functions offer us the possibility to make incremental changes
to the ruleset.

Moreover, this patch consolidate the code in the ruleset xml/json import
support.

Another interesting goal is extend (in the future) the ruleset
structure with information like the command associated to each object.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v8]
 * Removed the unused function nft_ruleset_ctx_unset
 * Don't release the set structure in the function nft_ruleset_parse_set
 * Don't set the errno in the malloc errors
 * Get a better code, setting up the function returning in to variable and later
   return it.
 * Changed the function nft_ruleset_init_ruleset to nft_ruleset_cb. Moreover,
   removed the local variable setting up with the ruleset lists.

 include/libnftnl/ruleset.h |   32 ++
 src/internal.h             |    3 +
 src/libnftnl.map           |    8 +
 src/ruleset.c              |  795 +++++++++++++++++++++++++++-----------------
 src/set.c                  |   12 +
 src/utils.c                |   16 +
 6 files changed, 553 insertions(+), 313 deletions(-)

diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index 1a3e22f..aa1d92d 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -25,11 +25,43 @@ enum {
 	NFT_RULESET_ATTR_RULELIST,
 };
 
+enum nft_ruleset_type {
+	NFT_RULESET_UNSPEC = 0,
+	NFT_RULESET_RULESET,
+	NFT_RULESET_TABLE,
+	NFT_RULESET_CHAIN,
+	NFT_RULESET_RULE,
+	NFT_RULESET_SET,
+	NFT_RULESET_SET_ELEMS,
+};
+
 bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr);
 void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr);
 void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
 void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
 
+enum {
+	NFT_RULESET_CTX_CMD = 0,
+	NFT_RULESET_CTX_TYPE,
+	NFT_RULESET_CTX_TABLE,
+	NFT_RULESET_CTX_CHAIN,
+	NFT_RULESET_CTX_RULE,
+	NFT_RULESET_CTX_SET,
+	NFT_RULESET_CTX_DATA,
+};
+
+struct nft_parse_ctx;
+bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr);
+void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr);
+uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx,
+				 uint16_t attr);
+
+int nft_ruleset_parse_file_cb(enum nft_parse_type type, FILE *fp,
+			      struct nft_parse_err *err, void *data,
+			      int (*cb)(const struct nft_parse_ctx *ctx));
+int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
+				struct nft_parse_err *err, void *data,
+				int (*cb)(const struct nft_parse_ctx *ctx));
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
 		      const char *data, struct nft_parse_err *err);
 int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
diff --git a/src/internal.h b/src/internal.h
index 431af11..9ebf7d7 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -139,6 +139,8 @@ int nft_jansson_parse_rule(struct nft_rule *r, json_t *tree,
 struct nft_set;
 int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 			  struct nft_parse_err *err);
+int nft_jansson_parse_elem(struct nft_set *s, json_t *tree,
+			   struct nft_parse_err *err);
 #endif
 
 const char *nft_family2str(uint32_t family);
@@ -149,6 +151,7 @@ int nft_str2verdict(const char *verdict, int *verdict_num);
 int nft_get_value(enum nft_type type, void *val, void *out);
 enum nft_cmd_type nft_flag2cmd(uint32_t flags);
 const char *nft_cmd2tag(enum nft_cmd_type cmd);
+uint32_t nft_str2cmd(const char *cmd);
 
 #include <stdio.h>
 int nft_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index be7b998..7c74fbc 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -227,3 +227,11 @@ LIBNFTNL_1.2 {
   nft_gen_snprintf;
   nft_gen_fprintf;
 } LIBNFTNL_1.1;
+
+LIBNFTNL_1.2.0 {
+  nft_ruleset_ctx_is_set;
+  nft_ruleset_ctx_get;
+  nft_ruleset_ctx_get_u32;
+  nft_ruleset_parse_file_cb;
+  nft_ruleset_parse_buffer_cb;
+} LIBNFTNL_1.2;
diff --git a/src/ruleset.c b/src/ruleset.c
index d05f907..15e84cf 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -32,6 +32,32 @@ struct nft_ruleset {
 	uint16_t		flags;
 };
 
+struct nft_parse_ctx {
+	enum nft_cmd_type cmd;
+	enum nft_ruleset_type type;
+	union {
+		struct nft_table	*table;
+		struct nft_chain	*chain;
+		struct nft_rule		*rule;
+		struct nft_set		*set;
+		struct nft_set_elem	*set_elem;
+	};
+	void *data;
+
+	/* These fields below are not exposed to the user */
+	union {
+		json_t			*json;
+		mxml_node_t		*xml;
+	};
+
+	uint32_t format;
+	uint32_t set_id;
+	struct nft_set_list *set_list;
+
+	int (*cb)(const struct nft_parse_ctx *ctx);
+	uint16_t flags;
+};
+
 struct nft_ruleset *nft_ruleset_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_ruleset));
@@ -131,453 +157,518 @@ void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_ruleset_attr_get);
 
-#ifdef JSON_PARSING
-static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_t *array,
-					 struct nft_parse_err *err)
+bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr)
 {
-	int i, len;
-	json_t *node;
-	struct nft_table *table;
-	struct nft_table_list *list = nft_table_list_alloc();
+	return ctx->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_is_set);
 
-	if (list == NULL) {
-		errno = ENOMEM;
-		return -1;
+void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr)
+{
+	if (!(ctx->flags & (1 << attr)))
+		return NULL;
+
+	switch (attr) {
+	case NFT_RULESET_CTX_CMD:
+		return (void *)&ctx->cmd;
+	case NFT_RULESET_CTX_TYPE:
+		return (void *)&ctx->type;
+	case NFT_RULESET_CTX_TABLE:
+		return ctx->table;
+	case NFT_RULESET_CTX_CHAIN:
+		return ctx->chain;
+	case NFT_RULESET_CTX_RULE:
+		return ctx->rule;
+	case NFT_RULESET_CTX_SET:
+		return ctx->set;
+	case NFT_RULESET_CTX_DATA:
+		return ctx->data;
+	default:
+		return NULL;
 	}
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_get);
 
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
-			goto err;
-		}
+uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx, uint16_t attr)
+{
+	const void *ret = nft_ruleset_ctx_get(ctx, attr);
+	return ret == NULL ? 0 : *((uint32_t *)ret);
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_get_u32);
 
-		if (!(nft_jansson_node_exist(node, "table")))
-			continue;
+#if defined(JSON_PARSING) || defined(XML_PARSING)
+static void nft_ruleset_ctx_set(struct nft_parse_ctx *ctx, uint16_t attr,
+				void *data)
+{
+	switch (attr) {
+	case NFT_RULESET_CTX_CMD:
+		ctx->cmd = *((uint32_t *)data);
+		break;
+	case NFT_RULESET_CTX_TYPE:
+		ctx->type = *((uint32_t *)data);
+		break;
+	case NFT_RULESET_CTX_TABLE:
+		ctx->table = data;
+		break;
+	case NFT_RULESET_CTX_CHAIN:
+		ctx->chain = data;
+		break;
+	case NFT_RULESET_CTX_RULE:
+		ctx->rule = data;
+		break;
+	case NFT_RULESET_CTX_SET:
+		ctx->set = data;
+		break;
+	case NFT_RULESET_CTX_DATA:
+		ctx->data = data;
+		break;
+	}
+	ctx->flags |= (1 << attr);
+}
 
-		table = nft_table_alloc();
-		if (table == NULL) {
-			errno = ENOMEM;
-			goto err;
-		}
+static void nft_ruleset_ctx_set_u32(struct nft_parse_ctx *ctx, uint16_t attr,
+				    uint32_t val)
+{
+	nft_ruleset_ctx_set(ctx, attr, &val);
+}
 
-		if (nft_jansson_parse_table(table, node, err) < 0) {
-			nft_table_free(table);
-			goto err;
-		}
+static int nft_ruleset_parse_tables(struct nft_parse_ctx *ctx,
+				    struct nft_parse_err *err)
+{
+	struct nft_table *table;
 
-		nft_table_list_add_tail(table, list);
+	table = nft_table_alloc();
+	if (table == NULL)
+		return -1;
+
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_table(table, ctx->json, err) < 0)
+			goto err;
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_table_parse(ctx->xml, table, err) < 0)
+			goto err;
+#endif
+		break;
+	default:
+		return -1;
 	}
 
-	if (!nft_table_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, list);
-	else
-		nft_table_list_free(list);
+	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, NFT_RULESET_TABLE);
+	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_TABLE, table);
+	if (ctx->cb(ctx) < 0)
+		goto err;
 
 	return 0;
 err:
-	nft_table_list_free(list);
+	nft_table_free(table);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_t *array,
-					 struct nft_parse_err *err)
+static int nft_ruleset_parse_chains(struct nft_parse_ctx *ctx,
+				    struct nft_parse_err *err)
 {
-	int i, len;
-	json_t *node;
 	struct nft_chain *chain;
-	struct nft_chain_list *list = nft_chain_list_alloc();
 
-	if (list == NULL) {
-		errno = ENOMEM;
+	chain = nft_chain_alloc();
+	if (chain == NULL)
 		return -1;
-	}
 
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_chain(chain, ctx->json, err) < 0)
 			goto err;
-		}
-
-		if (!(nft_jansson_node_exist(node, "chain")))
-			continue;
-
-		chain = nft_chain_alloc();
-		if (chain == NULL) {
-			errno = ENOMEM;
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_chain_parse(ctx->xml, chain, err) < 0)
 			goto err;
-		}
+#endif
+		break;
+	default:
+		return -1;
+	}
 
-		if (nft_jansson_parse_chain(chain, node, err) < 0) {
-			nft_chain_free(chain);
-			goto err;
-		}
+	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, NFT_RULESET_CHAIN);
+	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_CHAIN, chain);
+	if (ctx->cb(ctx) < 0)
+		goto err;
 
-		nft_chain_list_add_tail(chain, list);
-	}
+	return 0;
+err:
+	nft_chain_free(chain);
+	return -1;
+}
 
-	if (!nft_chain_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, list);
-	else
-		nft_chain_list_free(list);
+static int nft_ruleset_parse_set(struct nft_parse_ctx *ctx,
+				 struct nft_set *set, uint32_t type,
+				 struct nft_parse_err *err)
+{
+	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
+	nft_set_list_add_tail(set, ctx->set_list);
+
+	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, type);
+	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_SET, set);
+	if (ctx->cb(ctx) < 0)
+		goto err;
 
 	return 0;
 err:
-	nft_chain_list_free(list);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array,
+static int nft_ruleset_parse_set_elems(struct nft_parse_ctx *ctx,
 				       struct nft_parse_err *err)
 {
-	int i, len;
-	uint32_t set_id = 0;
-	json_t *node;
 	struct nft_set *set;
-	struct nft_set_list *list = nft_set_list_alloc();
 
-	if (list == NULL) {
-		errno = ENOMEM;
+	set = nft_set_alloc();
+	if (set == NULL)
 		return -1;
-	}
-
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
-			goto err;
-		}
-
-		if (!(nft_jansson_node_exist(node, "set")))
-			continue;
 
-		set = nft_set_alloc();
-		if (set == NULL) {
-			errno = ENOMEM;
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_elem(set, ctx->json, err) < 0)
 			goto err;
-		}
-
-		if (nft_jansson_parse_set(set, node, err) < 0) {
-			nft_set_free(set);
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_set_parse(ctx->xml, set, err) < 0)
 			goto err;
-		}
-
-		nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id++);
-		nft_set_list_add_tail(set, list);
+#endif
+		break;
+	default:
+		return -1;
 	}
 
-	if (!nft_set_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, list);
-	else
-		nft_set_list_free(list);
+	if (nft_ruleset_parse_set(ctx, set, NFT_RULESET_SET_ELEMS, err) < 0)
+		goto err;
 
 	return 0;
 err:
-	nft_set_list_free(list);
+	nft_set_free(set);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t *array,
-					struct nft_parse_err *err)
+static int nft_ruleset_parse_sets(struct nft_parse_ctx *ctx,
+				  struct nft_parse_err *err)
 {
-	int i, len;
-	json_t *node;
-	struct nft_rule *rule = NULL;
-	struct nft_rule_list *list = nft_rule_list_alloc();
+	struct nft_set *set;
 
-	if (list == NULL) {
-		errno = ENOMEM;
+	set = nft_set_alloc();
+	if (set == NULL)
 		return -1;
-	}
 
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
-			goto err;
-		}
-
-		if (!(nft_jansson_node_exist(node, "rule")))
-			continue;
-
-		rule = nft_rule_alloc();
-		if (rule == NULL) {
-			errno = ENOMEM;
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_set(set, ctx->json, err) < 0)
 			goto err;
-		}
-
-		if (nft_jansson_parse_rule(rule, node, err, rs->set_list) < 0) {
-			nft_rule_free(rule);
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_set_parse(ctx->xml, set, err) < 0)
 			goto err;
-		}
-
-		nft_rule_list_add_tail(rule, list);
+#endif
+		break;
+	default:
+		return -1;
 	}
 
-	if (!nft_rule_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, list);
-	else
-		nft_rule_list_free(list);
+	if (nft_ruleset_parse_set(ctx, set, NFT_RULESET_SET, err) < 0)
+		goto err;
 
 	return 0;
 err:
-	nft_rule_list_free(list);
+	nft_set_free(set);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_ruleset(struct nft_ruleset *rs, json_t *array,
-					  struct nft_parse_err *err)
+static int nft_ruleset_parse_rules(struct nft_parse_ctx *ctx,
+				   struct nft_parse_err *err)
 {
-	if (nft_ruleset_json_parse_tables(rs, array, err) != 0)
-		return -1;
-
-	if (nft_ruleset_json_parse_chains(rs, array, err) != 0)
-		return -1;
-
-	if (nft_ruleset_json_parse_sets(rs, array, err) != 0)
-		return -1;
+	struct nft_rule *rule;
 
-	if (nft_ruleset_json_parse_rules(rs, array, err) != 0)
+	rule = nft_rule_alloc();
+	if (rule == NULL)
 		return -1;
 
-	return 0;
-}
-#endif
-
-static int nft_ruleset_json_parse(struct nft_ruleset *rs, const void *json,
-				  struct nft_parse_err *err, enum nft_parse_input input)
-{
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
 #ifdef JSON_PARSING
-	json_t *root, *array;
-	json_error_t error;
-
-	root = nft_jansson_create_root(json, &error, err, input);
-	if (root == NULL)
+		if (nft_jansson_parse_rule(rule, ctx->json, err,
+					   ctx->set_list) < 0)
+			goto err;
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_rule_parse(ctx->xml, rule, err, ctx->set_list) < 0)
+			goto err;
+#endif
+		break;
+	default:
 		return -1;
-
-	array = json_object_get(root, "nftables");
-	if (array == NULL) {
-		errno = EINVAL;
-		goto err;
 	}
 
-	if (nft_ruleset_json_parse_ruleset(rs, array, err) != 0)
+	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, NFT_RULESET_RULE);
+	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_RULE, rule);
+	if (ctx->cb(ctx) < 0)
 		goto err;
 
-	nft_jansson_free_root(root);
 	return 0;
 err:
-	nft_jansson_free_root(root);
-	return -1;
-#else
-	errno = EOPNOTSUPP;
+	nft_rule_free(rule);
 	return -1;
-#endif
 }
+#endif
 
-#ifdef XML_PARSING
-static int
-nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree,
-			     struct nft_parse_err *err)
+#ifdef JSON_PARSING
+static int nft_ruleset_json_parse_ruleset(struct nft_parse_ctx *ctx,
+					  struct nft_parse_err *err)
 {
-	mxml_node_t *node;
-	struct nft_table *table;
-	struct nft_table_list *table_list = nft_table_list_alloc();
-	if (table_list == NULL) {
-		errno = ENOMEM;
-		return -1;
-	}
+	json_t *node, *array = ctx->json;
+	int len, i, ret;
 
-	for (node = mxmlFindElement(tree, tree, "table", NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, tree, "table", NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		table = nft_table_alloc();
-		if (table == NULL)
-			goto err_free;
+	ctx->set_list = nft_set_list_alloc();
+	if (ctx->set_list == NULL)
+		return -1;
 
-		if (nft_mxml_table_parse(node, table, err) != 0) {
-			nft_table_free(table);
-			goto err_free;
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			return -1;
 		}
 
-		nft_table_list_add_tail(table, table_list);
+		ctx->json = node;
+		if (nft_jansson_node_exist(node, "table"))
+			ret = nft_ruleset_parse_tables(ctx, err);
+		else if (nft_jansson_node_exist(node, "chain"))
+			ret = nft_ruleset_parse_chains(ctx, err);
+		else if (nft_jansson_node_exist(node, "set"))
+			ret = nft_ruleset_parse_sets(ctx, err);
+		else if (nft_jansson_node_exist(node, "rule"))
+			ret = nft_ruleset_parse_rules(ctx, err);
+		else if (nft_jansson_node_exist(node, "element"))
+			ret = nft_ruleset_parse_set_elems(ctx, err);
+		else
+			return -1;
+
+		if (ret < 0)
+			return ret;
 	}
 
-	if (!nft_table_list_is_empty(table_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST,
-				     table_list);
-	else
-		nft_table_list_free(table_list);
+	if (len == 0 && ctx->cmd == NFT_CMD_FLUSH) {
+		nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE,
+					NFT_RULESET_RULESET);
+		if (ctx->cb(ctx) < 0)
+			return -1;
+	}
 
 	return 0;
-err_free:
-	nft_table_list_free(table_list);
-	return -1;
 }
 
-static int
-nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree,
-			     struct nft_parse_err *err)
+static int nft_ruleset_json_parse_cmd(const char *cmd,
+				      struct nft_parse_err *err,
+				      struct nft_parse_ctx *ctx)
 {
-	mxml_node_t *node;
-	struct nft_chain *chain;
-	struct nft_chain_list *chain_list = nft_chain_list_alloc();
-	if (chain_list == NULL) {
-		errno = ENOMEM;
+	uint32_t cmdnum;
+	json_t *nodecmd;
+
+	cmdnum = nft_str2cmd(cmd);
+	if (cmdnum == NFT_CMD_UNSPEC) {
+		err->error = NFT_PARSE_EMISSINGNODE;
+		err->node_name = strdup(cmd);
 		return -1;
 	}
 
-	for (node = mxmlFindElement(tree, tree, "chain", NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, tree, "chain", NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		chain = nft_chain_alloc();
-		if (chain == NULL)
-			goto err_free;
-
-		if (nft_mxml_chain_parse(node, chain, err) != 0) {
-			nft_chain_free(chain);
-			goto err_free;
-		}
+	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_CMD, cmdnum);
 
-		nft_chain_list_add_tail(chain, chain_list);
-	}
+	nodecmd = json_object_get(ctx->json, cmd);
+	if (nodecmd == NULL)
+		return 0;
 
-	if (!nft_chain_list_is_empty(chain_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST,
-				     chain_list);
-	else
-		nft_chain_list_free(chain_list);
+	ctx->json = nodecmd;
+	if (nft_ruleset_json_parse_ruleset(ctx, err) != 0)
+		goto err;
 
 	return 0;
-err_free:
-	nft_chain_list_free(chain_list);
+err:
 	return -1;
 }
+#endif
 
-static int
-nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
-			   struct nft_parse_err *err)
+static int nft_ruleset_json_parse(const void *json,
+				  struct nft_parse_err *err,
+				  enum nft_parse_input input,
+				  enum nft_parse_type type, void *arg,
+				  int (*cb)(const struct nft_parse_ctx *ctx))
 {
-	uint32_t set_id = 0;
-	mxml_node_t *node;
-	struct nft_set *set;
-	struct nft_set_list *set_list = nft_set_list_alloc();
-	if (set_list == NULL) {
-		errno = ENOMEM;
+#ifdef JSON_PARSING
+	json_t *root, *array, *node;
+	json_error_t error;
+	int i, len;
+	const char *key;
+	struct nft_parse_ctx ctx;
+
+	ctx.cb = cb;
+	ctx.format = type;
+
+	if (arg != NULL)
+		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
+
+	root = nft_jansson_create_root(json, &error, err, input);
+	if (root == NULL)
 		return -1;
-	}
 
-	for (node = mxmlFindElement(tree, tree, "set", NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, tree, "set", NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		set = nft_set_alloc();
-		if (set == NULL)
-			goto err_free;
+	array = json_object_get(root, "nftables");
+	if (array == NULL) {
+		errno = EINVAL;
+		goto err;
+	}
 
-		if (nft_mxml_set_parse(node, set, err) != 0) {
-			nft_set_free(set);
-			goto err_free;
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			goto err;
 		}
+		ctx.json = node;
+		key = json_object_iter_key(json_object_iter(node));
+		if (key == NULL)
+			goto err;
 
-		nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id++);
-		nft_set_list_add_tail(set, set_list);
+		if (nft_ruleset_json_parse_cmd(key, err, &ctx) < 0)
+			goto err;
 	}
 
-	if (!nft_set_list_is_empty(set_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, set_list);
-	else
-		nft_set_list_free(set_list);
-
+	nft_jansson_free_root(root);
 	return 0;
-err_free:
-	nft_set_list_free(set_list);
+err:
+	nft_jansson_free_root(root);
 	return -1;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
 }
 
-static int
-nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
-			    struct nft_parse_err *err,
-			    struct nft_set_list *set_list)
+#ifdef XML_PARSING
+static int nft_ruleset_xml_parse_ruleset(struct nft_parse_ctx *ctx,
+					 struct nft_parse_err *err)
 {
-	mxml_node_t *node;
-	struct nft_rule *rule;
-	struct nft_rule_list *rule_list = nft_rule_list_alloc();
-	if (rule_list == NULL) {
-		errno = ENOMEM;
+	const char *node_type;
+	mxml_node_t *node, *array = ctx->xml;
+	int len = 0, ret;
+
+	ctx->set_list = nft_set_list_alloc();
+	if (ctx->set_list == NULL)
 		return -1;
-	}
 
-	for (node = mxmlFindElement(tree, tree, "rule", NULL, NULL,
+	for (node = mxmlFindElement(array, array, NULL, NULL, NULL,
 				    MXML_DESCEND_FIRST);
 	     node != NULL;
-	     node = mxmlFindElement(node, tree, "rule", NULL, NULL,
+	     node = mxmlFindElement(node, array, NULL, NULL, NULL,
 				    MXML_NO_DESCEND)) {
-		rule = nft_rule_alloc();
-		if (rule == NULL)
-			goto err_free;
+		len++;
+		node_type = node->value.opaque;
+		ctx->xml = node;
+		if (strcmp(node_type, "table") == 0)
+			ret = nft_ruleset_parse_tables(ctx, err);
+		else if (strcmp(node_type, "chain") == 0)
+			ret = nft_ruleset_parse_chains(ctx, err);
+		else if (strcmp(node_type, "set") == 0)
+			ret = nft_ruleset_parse_sets(ctx, err);
+		else if (strcmp(node_type, "rule") == 0)
+			ret = nft_ruleset_parse_rules(ctx, err);
+		else if (strcmp(node_type, "element") == 0)
+			ret = nft_ruleset_parse_set_elems(ctx, err);
+		else
+			return -1;
 
-		if (nft_mxml_rule_parse(node, rule, err, set_list) != 0) {
-			nft_rule_free(rule);
-			goto err_free;
-		}
-
-		nft_rule_list_add_tail(rule, rule_list);
+		if (ret < 0)
+			return ret;
 	}
 
-	if (!nft_rule_list_is_empty(rule_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, rule_list);
-	else
-		nft_rule_list_free(rule_list);
+	if (len == 0 && ctx->cmd == NFT_CMD_FLUSH) {
+		nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE,
+					NFT_RULESET_RULESET);
+		if (ctx->cb(ctx) < 0)
+			return -1;
+	}
 
 	return 0;
-err_free:
-	nft_rule_list_free(rule_list);
-	return -1;
 }
 
-static int nft_ruleset_xml_parse_ruleset(struct nft_ruleset *rs,
-					 mxml_node_t *tree,
-					 struct nft_parse_err *err)
+static int nft_ruleset_xml_parse_cmd(const char *cmd, struct nft_parse_err *err,
+				     struct nft_parse_ctx *ctx)
 {
-	if (nft_ruleset_xml_parse_tables(rs, tree, err) != 0)
-		return -1;
+	uint32_t cmdnum;
+	mxml_node_t *nodecmd;
 
-	if (nft_ruleset_xml_parse_chains(rs, tree, err) != 0)
+	cmdnum = nft_str2cmd(cmd);
+	if (cmdnum == NFT_CMD_UNSPEC) {
+		err->error = NFT_PARSE_EMISSINGNODE;
+		err->node_name = strdup(cmd);
 		return -1;
+	}
 
-	if (nft_ruleset_xml_parse_sets(rs, tree, err) != 0)
-		return -1;
+	nodecmd = mxmlFindElement(ctx->xml, ctx->xml, cmd, NULL, NULL,
+				  MXML_DESCEND_FIRST);
 
-	if (nft_ruleset_xml_parse_rules(rs, tree, err, rs->set_list) != 0)
-		return -1;
+	ctx->xml = nodecmd;
+	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_CMD, cmdnum);
+
+	if (nft_ruleset_xml_parse_ruleset(ctx, err) != 0)
+		goto err;
 
 	return 0;
+err:
+	return -1;
 }
 #endif
 
-static int nft_ruleset_xml_parse(struct nft_ruleset *rs, const void *xml,
-				 struct nft_parse_err *err, enum nft_parse_input input)
+static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
+				 enum nft_parse_input input,
+				 enum nft_parse_type type, void *arg,
+				 int (*cb)(const struct nft_parse_ctx *ctx))
 {
 #ifdef XML_PARSING
-	mxml_node_t *tree;
+	mxml_node_t *tree, *nodecmd = NULL;
+	char *cmd;
+	struct nft_parse_ctx ctx;
+
+	ctx.cb = cb;
+	ctx.format = type;
+
+	if (arg != NULL)
+		nft_ruleset_ctx_set(&ctx, NFT_RULESET_CTX_DATA, arg);
 
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
 	if (tree == NULL)
 		return -1;
 
-	if (nft_ruleset_xml_parse_ruleset(rs, tree, err) != 0)
-		goto err;
+	ctx.xml = tree;
+
+	nodecmd = mxmlWalkNext(tree, tree, MXML_DESCEND_FIRST);
+	while (nodecmd != NULL) {
+		cmd = nodecmd->value.opaque;
+		if (nft_ruleset_xml_parse_cmd(cmd, err, &ctx) < 0)
+			goto err;
+		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
+	}
 
 	mxmlDelete(tree);
 	return 0;
@@ -591,18 +682,18 @@ err:
 }
 
 static int
-nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
-		     const void *data, struct nft_parse_err *err,
-		     enum nft_parse_input input)
+nft_ruleset_do_parse(enum nft_parse_type type, const void *data,
+		     struct nft_parse_err *err, enum nft_parse_input input,
+		     void *arg, int (*cb)(const struct nft_parse_ctx *ctx))
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_ruleset_xml_parse(r, data, err, input);
+		ret = nft_ruleset_xml_parse(data, err, input, type, arg, cb);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_ruleset_json_parse(r, data, err, input);
+		ret = nft_ruleset_json_parse(data, err, input, type, arg, cb);
 		break;
 	default:
 		ret = -1;
@@ -613,17 +704,95 @@ nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
 	return ret;
 }
 
+int nft_ruleset_parse_file_cb(enum nft_parse_type type, FILE *fp,
+			      struct nft_parse_err *err, void *data,
+			      int (*cb)(const struct nft_parse_ctx *ctx))
+{
+	return nft_ruleset_do_parse(type, fp, err, NFT_PARSE_FILE, data, cb);
+}
+EXPORT_SYMBOL(nft_ruleset_parse_file_cb);
+
+int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
+				struct nft_parse_err *err, void *data,
+				int (*cb)(const struct nft_parse_ctx *ctx))
+{
+	return nft_ruleset_do_parse(type, buffer, err, NFT_PARSE_BUFFER, data,
+				    cb);
+}
+EXPORT_SYMBOL(nft_ruleset_parse_buffer_cb);
+
+static int nft_ruleset_cb(const struct nft_parse_ctx *ctx)
+{
+	struct nft_ruleset *r = ctx->data;
+
+	if (ctx->cmd != NFT_CMD_ADD)
+		return -1;
+
+	switch (ctx->type) {
+	case NFT_RULESET_TABLE:
+		if (r->table_list == NULL) {
+			r->table_list = nft_table_list_alloc();
+			if (r->table_list == NULL)
+				return -1;
+
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_TABLELIST,
+					     r->table_list);
+		}
+		nft_table_list_add_tail(ctx->table, r->table_list);
+		break;
+	case NFT_RULESET_CHAIN:
+		if (r->chain_list == NULL) {
+			r->chain_list = nft_chain_list_alloc();
+			if (r->chain_list == NULL)
+				return -1;
+
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_CHAINLIST,
+					     r->chain_list);
+		}
+		nft_chain_list_add_tail(ctx->chain, r->chain_list);
+		break;
+	case NFT_RULESET_SET:
+		if (r->set_list == NULL) {
+			r->set_list = nft_set_list_alloc();
+			if (r->set_list == NULL)
+				return -1;
+
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_SETLIST,
+					     r->set_list);
+		}
+		nft_set_list_add_tail(ctx->set, r->set_list);
+		break;
+	case NFT_RULESET_RULE:
+		if (r->rule_list == NULL) {
+			r->rule_list = nft_rule_list_alloc();
+			if (r->rule_list == NULL)
+				return -1;
+
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_RULELIST,
+					     r->rule_list);
+		}
+		nft_rule_list_add_tail(ctx->rule, r->rule_list);
+		break;
+	case NFT_RULESET_RULESET:
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
 int nft_ruleset_parse(struct nft_ruleset *r, enum nft_parse_type type,
 		      const char *data, struct nft_parse_err *err)
 {
-	return nft_ruleset_do_parse(r, type, data, err, NFT_PARSE_BUFFER);
+	return nft_ruleset_parse_buffer_cb(type, data, err, r, nft_ruleset_cb);
 }
 EXPORT_SYMBOL(nft_ruleset_parse);
 
 int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
 			   FILE *fp, struct nft_parse_err *err)
 {
-	return nft_ruleset_do_parse(rs, type, fp, err, NFT_PARSE_FILE);
+	return nft_ruleset_parse_file_cb(type, fp, err, rs, nft_ruleset_cb);
 }
 EXPORT_SYMBOL(nft_ruleset_parse_file);
 
diff --git a/src/set.c b/src/set.c
index 1c56e68..c6c3301 100644
--- a/src/set.c
+++ b/src/set.c
@@ -511,6 +511,18 @@ int nft_jansson_parse_set(struct nft_set *s, json_t *tree,
 
 	return nft_jansson_parse_set_info(s, root, err);
 }
+
+int nft_jansson_parse_elem(struct nft_set *s, json_t *tree,
+			   struct nft_parse_err *err)
+{
+	json_t *root;
+
+	root = nft_jansson_get_node(tree, "element", err);
+	if (root == NULL)
+		return -1;
+
+	return nft_jansson_parse_set_info(s, root, err);
+}
 #endif
 
 static int nft_set_json_parse(struct nft_set *s, const void *json,
diff --git a/src/utils.c b/src/utils.c
index 7a6039b..24481a2 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -204,6 +204,22 @@ const char *nft_cmd2tag(enum nft_cmd_type cmd)
 	return cmd2tag[cmd];
 }
 
+uint32_t nft_str2cmd(const char *cmd)
+{
+	if (strcmp(cmd, ADD) == 0)
+		return NFT_CMD_ADD;
+	else if (strcmp(cmd, INSERT) == 0)
+		return NFT_CMD_INSERT;
+	else if (strcmp(cmd, DELETE) == 0)
+		return NFT_CMD_DELETE;
+	else if (strcmp(cmd, REPLACE) == 0)
+		return NFT_CMD_REPLACE;
+	else if (strcmp(cmd, FLUSH) == 0)
+		return NFT_CMD_FLUSH;
+
+	return NFT_CMD_UNSPEC;
+}
+
 int nft_fprintf(FILE *fp, void *obj, uint32_t cmd, uint32_t type, uint32_t flags,
 		int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj,
 				   uint32_t cmd, uint32_t type, uint32_t flags))
-- 
1.7.10.4

