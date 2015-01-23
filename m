From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/5] src: add support to import json/xml with the new syntax
Date: Fri, 23 Jan 2015 15:49:53 +0100
Message-ID: <1422024596-8839-3-git-send-email-alvaroneay@gmail.com>
References: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:50753 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbbAWOtp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:49:45 -0500
Received: by mail-we0-f169.google.com with SMTP id u56so8029874wes.0
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2015 06:49:43 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ev7sm2462989wjb.47.2015.01.23.06.49.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Jan 2015 06:49:42 -0800 (PST)
In-Reply-To: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to parse the new syntax in xml/json. This patch adds two
new different functions nft_ruleset_parse_*_cb. With these functions, we can
pass a callback functions like parameter and we can call with each element.

These functions use a new structure like parameter called nft_parse_ctx. This
structure contains the command associated to the ruleset, the type of the
element (table, chain, rule, set or set element) and the object.

Also, with this changes, we have support to parse another new ruleset element:

	{"nftables":[{"add":[{"element":{"name":"blackhole","table":"filter"
	"family":"ip","key_type":7,"key_len":4,"set_elem":[{"key":{
	"reg":{"type":"value","len":4,"data0":"0x0403a8c0"}}}]}}]}]}

With this new element, we can make incremental changes with set elements like
add or delete elements inside a set.

In short, these functions offer us the possibility to make incremental changes
with the ruleset elements.

Another interesting goal is extend (in the future) the ruleset
structure with information like the command associated to each element.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftnl/ruleset.h |   36 ++
 src/internal.h             |    3 +
 src/libnftnl.map           |    6 +
 src/ruleset.c              |  809 +++++++++++++++++++++++++++++---------------
 src/set.c                  |   12 +
 src/utils.c                |   23 ++
 6 files changed, 613 insertions(+), 276 deletions(-)

diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
index cec6cd6..b240f83 100644
--- a/include/libnftnl/ruleset.h
+++ b/include/libnftnl/ruleset.h
@@ -25,11 +25,47 @@ enum {
 	NFT_RULESET_ATTR_RULELIST,
 };
 
+enum nft_ruleset_type {
+	NFT_RULESET_TYPE_UNSPEC = 0,
+	NFT_RULESET_TYPE_RULESET,
+	NFT_RULESET_TYPE_TABLE,
+	NFT_RULESET_TYPE_CHAIN,
+	NFT_RULESET_TYPE_RULE,
+	NFT_RULESET_TYPE_SET,
+	NFT_RULESET_TYPE_SET_ELEMS,
+};
+
 bool nft_ruleset_attr_is_set(const struct nft_ruleset *r, uint16_t attr);
 void nft_ruleset_attr_unset(struct nft_ruleset *r, uint16_t attr);
 void nft_ruleset_attr_set(struct nft_ruleset *r, uint16_t attr, void *data);
 void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr);
 
+struct nft_parse_ctx;
+
+struct nft_parse_ctx *nft_ruleset_ctx_alloc(void);
+void nft_ruleset_ctx_free(struct nft_parse_ctx *ctx);
+
+enum {
+	NFT_RULESET_CTX_CMD = 0,
+	NFT_RULESET_CTX_TYPE,
+	NFT_RULESET_CTX_TABLE,
+	NFT_RULESET_CTX_CHAIN,
+	NFT_RULESET_CTX_RULE,
+	NFT_RULESET_CTX_SET,
+};
+
+bool nft_ruleset_ctx_attr_is_set(struct nft_parse_ctx *ctx, uint16_t attr);
+void nft_ruleset_ctx_attr_unset(struct nft_parse_ctx *ctx, uint16_t attr);
+void nft_ruleset_ctx_attr_set(struct nft_parse_ctx *ctx, uint16_t attr,
+			      void *data);
+void *nft_ruleset_ctx_attr_get(struct nft_parse_ctx *ctx, uint16_t attr);
+
+int nft_ruleset_parse_file_cb(enum nft_parse_type type, FILE *fp,
+			      struct nft_parse_err *err, void *data,
+			      int (*cb)(struct nft_parse_ctx *ctx));
+int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
+				struct nft_parse_err *err, void *data,
+				int (*cb)(struct nft_parse_ctx *ctx));
 int nft_ruleset_parse(struct nft_ruleset *rs, enum nft_parse_type type,
 		      const char *data, struct nft_parse_err *err);
 int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
diff --git a/src/internal.h b/src/internal.h
index 44cfc5d..0c7f491 100644
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
@@ -148,6 +150,7 @@ const char *nft_verdict2str(uint32_t verdict);
 int nft_str2verdict(const char *verdict, int *verdict_num);
 int nft_flag2cmd(uint32_t flags, uint32_t *cmd);
 int nft_get_value(enum nft_type type, void *val, void *out);
+int nft_str2cmd(const char *cmd, uint32_t *cmd_num);
 
 #include <stdio.h>
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
diff --git a/src/libnftnl.map b/src/libnftnl.map
index be7b998..f8abcdb 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -182,8 +182,14 @@ global:
   nft_ruleset_attr_unset;
   nft_ruleset_attr_set;
   nft_ruleset_attr_get;
+  nft_ruleset_ctx_attr_is_set;
+  nft_ruleset_ctx_attr_unset;
+  nft_ruleset_ctx_attr_set;
+  nft_ruleset_ctx_attr_get;
   nft_ruleset_parse;
   nft_ruleset_parse_file;
+  nft_ruleset_parse_file_cb;
+  nft_ruleset_parse_buffer_cb;
   nft_ruleset_snprintf;
   nft_ruleset_fprintf;
 
diff --git a/src/ruleset.c b/src/ruleset.c
index 3fb381d..a3e4b20 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -32,6 +32,30 @@ struct nft_ruleset {
 	uint16_t		flags;
 };
 
+struct nft_parse_ctx {
+	uint32_t cmd;
+	uint32_t type;
+	union {
+		struct nft_table *table;
+		struct nft_chain *chain;
+		struct nft_rule *rule;
+		struct nft_set *set;
+		struct nft_set_elem *set_elem;
+	};
+	union {
+		json_t *json;
+		mxml_node_t *xml;
+	};
+
+	uint32_t set_id;
+	struct nft_set_list *set_list;
+
+	void *data;
+
+	int (*cb)(struct nft_parse_ctx *ctx);
+	uint16_t flags;
+};
+
 struct nft_ruleset *nft_ruleset_alloc(void)
 {
 	return calloc(1, sizeof(struct nft_ruleset));
@@ -131,231 +155,347 @@ void *nft_ruleset_attr_get(const struct nft_ruleset *r, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_ruleset_attr_get);
 
-#ifdef JSON_PARSING
-static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_t *array,
-					 struct nft_parse_err *err)
+struct nft_parse_ctx *nft_ruleset_ctx_alloc(void)
 {
-	int i, len;
-	json_t *node;
-	struct nft_table *table;
-	struct nft_table_list *list = nft_table_list_alloc();
+	return calloc(1, sizeof(struct nft_parse_ctx));
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_alloc);
 
-	if (list == NULL) {
-		errno = ENOMEM;
-		return -1;
+void nft_ruleset_ctx_free(struct nft_parse_ctx *ctx)
+{
+	xfree(ctx);
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_free);
+
+bool nft_ruleset_ctx_attr_is_set(struct nft_parse_ctx *ctx, uint16_t attr)
+{
+	return ctx->flags & (1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_attr_is_set);
+
+void nft_ruleset_ctx_attr_unset(struct nft_parse_ctx *ctx, uint16_t attr)
+{
+	if (!(ctx->flags & (1 << attr)))
+		return;
+
+	switch (attr) {
+	case NFT_RULESET_CTX_CMD:
+	case NFT_RULESET_CTX_TYPE:
+		break;
+	case NFT_RULESET_CTX_TABLE:
+		ctx->table = NULL;
+		break;
+	case NFT_RULESET_CTX_CHAIN:
+		ctx->chain = NULL;
+		break;
+	case NFT_RULESET_CTX_RULE:
+		ctx->rule = NULL;
+		break;
+	case NFT_RULESET_CTX_SET:
+		ctx->set = NULL;
+		break;
 	}
+	ctx->flags &= ~(1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_attr_unset);
 
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
-			goto err;
-		}
+void nft_ruleset_ctx_attr_set(struct nft_parse_ctx *ctx, uint16_t attr,
+			      void *data)
+{
+	switch (attr) {
+	case NFT_RULESET_CTX_CMD:
+		nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_CMD);
+		ctx->cmd = *((uint32_t *)data);
+		break;
+	case NFT_RULESET_CTX_TYPE:
+		nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_TYPE);
+		ctx->type = *((uint32_t *)data);
+		break;
+	case NFT_RULESET_CTX_TABLE:
+		nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_TABLE);
+		ctx->table = data;
+		break;
+	case NFT_RULESET_CTX_CHAIN:
+		nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_CHAIN);
+		ctx->chain = data;
+		break;
+	case NFT_RULESET_CTX_RULE:
+		nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_RULE);
+		ctx->rule = data;
+		break;
+	case NFT_RULESET_CTX_SET:
+		nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_SET);
+		ctx->set = data;
+		break;
+	}
+	ctx->flags |= (1 << attr);
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_attr_set);
 
-		if (!(nft_jansson_node_exist(node, "table")))
-			continue;
+void *nft_ruleset_ctx_attr_get(struct nft_parse_ctx *ctx, uint16_t attr)
+{
+	if (!(ctx->flags & (1 << attr)))
+		return NULL;
 
-		table = nft_table_alloc();
-		if (table == NULL) {
-			errno = ENOMEM;
-			goto err;
-		}
+	switch (attr) {
+	case NFT_RULESET_CTX_CMD:
+		return &ctx->cmd;
+	case NFT_RULESET_CTX_TYPE:
+		return &ctx->type;
+	case NFT_RULESET_CTX_TABLE:
+		return ctx->table;
+	case NFT_RULESET_CTX_CHAIN:
+		return ctx->chain;
+	case NFT_RULESET_CTX_RULE:
+		return ctx->rule;
+	case NFT_RULESET_CTX_SET:
+		return ctx->set;
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL(nft_ruleset_ctx_attr_get);
 
-		if (nft_jansson_parse_table(table, node, err) < 0) {
-			nft_table_free(table);
-			goto err;
-		}
+#ifdef JSON_PARSING
+static int nft_ruleset_json_parse_tables(struct nft_parse_ctx *ctx,
+					 struct nft_parse_err *err)
+{
+	struct nft_table *table;
+	uint32_t type = NFT_RULESET_TYPE_TABLE;
+
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
 
-		nft_table_list_add_tail(table, list);
+	table = nft_table_alloc();
+	if (table == NULL) {
+		errno = ENOMEM;
+		return -1;
 	}
 
-	if (!nft_table_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, list);
-	else
-		nft_table_list_free(list);
+	if (nft_jansson_parse_table(table, ctx->json, err) < 0)
+		goto err;
+
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TABLE, table);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_TABLE);
 
 	return 0;
 err:
-	nft_table_list_free(list);
+	nft_table_free(table);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_t *array,
+static int nft_ruleset_json_parse_chains(struct nft_parse_ctx *ctx,
 					 struct nft_parse_err *err)
 {
-	int i, len;
-	json_t *node;
 	struct nft_chain *chain;
-	struct nft_chain_list *list = nft_chain_list_alloc();
+	uint32_t type = NFT_RULESET_TYPE_CHAIN;
 
-	if (list == NULL) {
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
+
+	chain = nft_chain_alloc();
+	if (chain == NULL) {
 		errno = ENOMEM;
 		return -1;
 	}
 
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
-			goto err;
-		}
-
-		if (!(nft_jansson_node_exist(node, "chain")))
-			continue;
+	if (nft_jansson_parse_chain(chain, ctx->json, err) < 0)
+		goto err;
 
-		chain = nft_chain_alloc();
-		if (chain == NULL) {
-			errno = ENOMEM;
-			goto err;
-		}
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_CHAIN, chain);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_CHAIN);
 
-		if (nft_jansson_parse_chain(chain, node, err) < 0) {
-			nft_chain_free(chain);
-			goto err;
-		}
+	return 0;
+err:
+	nft_chain_free(chain);
+	return -1;
+}
 
-		nft_chain_list_add_tail(chain, list);
-	}
+static int nft_ruleset_json_parse_set(struct nft_parse_ctx *ctx,
+				      struct nft_set *set, int type,
+				      struct nft_parse_err *err)
+{
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
 
-	if (!nft_chain_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, list);
-	else
-		nft_chain_list_free(list);
+	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_SET, set);
+	nft_set_list_add_tail(set, ctx->set_list);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_SET);
 
 	return 0;
 err:
-	nft_chain_list_free(list);
+	nft_set_free(set);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array,
-				       struct nft_parse_err *err)
+static int nft_ruleset_json_parse_set_elems(struct nft_parse_ctx *ctx,
+					    struct nft_parse_err *err)
 {
-	int i, len;
-	uint32_t set_id = 0;
-	json_t *node;
 	struct nft_set *set;
-	struct nft_set_list *list = nft_set_list_alloc();
 
-	if (list == NULL) {
+	set = nft_set_alloc();
+	if (set == NULL) {
 		errno = ENOMEM;
 		return -1;
 	}
 
-	len = json_array_size(array);
-	for (i = 0; i < len; i++) {
-		node = json_array_get(array, i);
-		if (node == NULL) {
-			errno = EINVAL;
-			goto err;
-		}
 
-		if (!(nft_jansson_node_exist(node, "set")))
-			continue;
+	if (nft_jansson_parse_elem(set, ctx->json, err) < 0)
+		goto err;
 
-		set = nft_set_alloc();
-		if (set == NULL) {
-			errno = ENOMEM;
-			goto err;
-		}
+	return nft_ruleset_json_parse_set(ctx, set, NFT_RULESET_TYPE_SET_ELEMS,
+					  err);
+err:
+	nft_set_free(set);
+	return -1;
+}
 
-		if (nft_jansson_parse_set(set, node, err) < 0) {
-			nft_set_free(set);
-			goto err;
-		}
+static int nft_ruleset_json_parse_sets(struct nft_parse_ctx *ctx,
+				       struct nft_parse_err *err)
+{
+	struct nft_set *set;
 
-		nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id++);
-		nft_set_list_add_tail(set, list);
+	set = nft_set_alloc();
+	if (set == NULL) {
+		errno = ENOMEM;
+		return -1;
 	}
 
-	if (!nft_set_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, list);
-	else
-		nft_set_list_free(list);
+	if (nft_jansson_parse_set(set, ctx->json, err) < 0)
+		goto err;
 
-	return 0;
+	return nft_ruleset_json_parse_set(ctx, set, NFT_RULESET_TYPE_SET, err);
 err:
-	nft_set_list_free(list);
+	nft_set_free(set);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t *array,
+static int nft_ruleset_json_parse_rules(struct nft_parse_ctx *ctx,
 					struct nft_parse_err *err)
 {
-	int i, len;
-	json_t *node;
-	struct nft_rule *rule = NULL;
-	struct nft_rule_list *list = nft_rule_list_alloc();
+	struct nft_rule *rule;
+	uint32_t type = NFT_RULESET_TYPE_RULE;
+
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
 
-	if (list == NULL) {
+	rule = nft_rule_alloc();
+	if (rule == NULL) {
 		errno = ENOMEM;
 		return -1;
 	}
 
+	if (nft_jansson_parse_rule(rule, ctx->json, err, ctx->set_list) < 0)
+		goto err;
+
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_RULE, rule);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_RULE);
+
+	return 0;
+err:
+	nft_rule_free(rule);
+	return -1;
+}
+
+static int nft_ruleset_json_parse_ruleset(struct nft_parse_ctx *ctx,
+					  struct nft_parse_err *err)
+{
+	ctx->set_list = nft_set_list_alloc();
+	json_t *node, *array = ctx->json;
+	int len, i;
+	uint32_t type;
+
+	if (ctx->set_list == NULL)
+		return -1;
+
 	len = json_array_size(array);
 	for (i = 0; i < len; i++) {
 		node = json_array_get(array, i);
 		if (node == NULL) {
 			errno = EINVAL;
-			goto err;
+			return -1;
 		}
 
-		if (!(nft_jansson_node_exist(node, "rule")))
-			continue;
-
-		rule = nft_rule_alloc();
-		if (rule == NULL) {
-			errno = ENOMEM;
-			goto err;
-		}
-
-		if (nft_jansson_parse_rule(rule, node, err, rs->set_list) < 0) {
-			nft_rule_free(rule);
-			goto err;
+		ctx->json = node;
+		if (nft_jansson_node_exist(node, "table")) {
+			if (nft_ruleset_json_parse_tables(ctx, err) < 0)
+				return -1;
+		} else if (nft_jansson_node_exist(node, "chain")) {
+			if (nft_ruleset_json_parse_chains(ctx, err) < 0)
+				return -1;
+		} else if (nft_jansson_node_exist(node, "set")) {
+			if (nft_ruleset_json_parse_sets(ctx, err) < 0)
+				return -1;
+		} else if (nft_jansson_node_exist(node, "rule")) {
+			if (nft_ruleset_json_parse_rules(ctx, err) < 0)
+				return -1;
+		} else if (nft_jansson_node_exist(node, "elements")) {
+			if (nft_ruleset_json_parse_set_elems(ctx, err) < 0)
+				return -1;
+		} else {
+			return -1;
 		}
-
-		nft_rule_list_add_tail(rule, list);
 	}
-
-	if (!nft_rule_list_is_empty(list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, list);
-	else
-		nft_rule_list_free(list);
+	if (len == 0 && ctx->cmd == NFT_CMD_FLUSH) {
+		type = NFT_RULESET_TYPE_RULESET;
+		nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
+		if (ctx->cb(ctx) < 0)
+			return -1;
+	}
 
 	return 0;
-err:
-	nft_rule_list_free(list);
-	return -1;
 }
 
-static int nft_ruleset_json_parse_ruleset(struct nft_ruleset *rs, json_t *array,
-					  struct nft_parse_err *err)
+static int nft_ruleset_json_parse_cmd(const char *cmd,
+				      struct nft_parse_err *err,
+				      struct nft_parse_ctx *ctx)
 {
-	if (nft_ruleset_json_parse_tables(rs, array, err) != 0)
-		return -1;
+	uint32_t cmdnum;
+	int ret;
+	json_t *nodecmd;
 
-	if (nft_ruleset_json_parse_chains(rs, array, err) != 0)
+	ret = nft_str2cmd(cmd, &cmdnum);
+	if (ret < 0)
 		return -1;
 
-	if (nft_ruleset_json_parse_sets(rs, array, err) != 0)
-		return -1;
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_CMD, &cmdnum);
 
-	if (nft_ruleset_json_parse_rules(rs, array, err) != 0)
-		return -1;
+	nodecmd = json_object_get(ctx->json, cmd);
+	if (nodecmd == NULL)
+		return 0;
+
+	ctx->json = nodecmd;
+	if (nft_ruleset_json_parse_ruleset(ctx, err) != 0)
+		goto err;
 
 	return 0;
+err:
+	return -1;
 }
 #endif
 
-static int nft_ruleset_json_parse(struct nft_ruleset *rs, const void *json,
-				  struct nft_parse_err *err, enum nft_parse_input input)
+static int nft_ruleset_json_parse(const void *json,
+				  struct nft_parse_err *err,
+				  enum nft_parse_input input, void *arg,
+				  int (*cb)(struct nft_parse_ctx *ctx))
 {
 #ifdef JSON_PARSING
-	json_t *root, *array;
+	json_t *root, *array, *node;
 	json_error_t error;
+	int i, len;
+	const char *key;
+	struct nft_parse_ctx *ctx = nft_ruleset_ctx_alloc();
 
+	if (ctx == NULL)
+		return -1;
+
+	ctx->cb = cb;
+	ctx->data = arg;
 	root = nft_jansson_create_root(json, &error, err, input);
 	if (root == NULL)
 		return -1;
@@ -366,13 +506,28 @@ static int nft_ruleset_json_parse(struct nft_ruleset *rs, const void *json,
 		goto err;
 	}
 
-	if (nft_ruleset_json_parse_ruleset(rs, array, err) != 0)
-		goto err;
+	len = json_array_size(array);
+	for (i = 0; i < len; i++) {
+		node = json_array_get(array, i);
+		if (node == NULL) {
+			errno = EINVAL;
+			goto err;
+		}
+		ctx->json = node;
+		key = json_object_iter_key(json_object_iter(node));
+		if (key == NULL)
+			return -1;
+
+		if (nft_ruleset_json_parse_cmd(key, err, ctx) < 0)
+			goto err;
+	}
 
 	nft_jansson_free_root(root);
+	nft_ruleset_ctx_free(ctx);
 	return 0;
 err:
 	nft_jansson_free_root(root);
+	nft_ruleset_ctx_free(ctx);
 	return -1;
 #else
 	errno = EOPNOTSUPP;
@@ -382,207 +537,237 @@ err:
 
 #ifdef XML_PARSING
 static int
-nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree,
+nft_ruleset_xml_parse_tables(struct nft_parse_ctx *ctx,
 			     struct nft_parse_err *err)
 {
-	mxml_node_t *node;
 	struct nft_table *table;
-	struct nft_table_list *table_list = nft_table_list_alloc();
-	if (table_list == NULL) {
-		errno = ENOMEM;
-		return -1;
-	}
+	uint32_t type = NFT_RULESET_TYPE_TABLE;
 
-	for (node = mxmlFindElement(tree, tree, "table", NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, tree, "table", NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		table = nft_table_alloc();
-		if (table == NULL)
-			goto err_free;
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
 
-		if (nft_mxml_table_parse(node, table, err) != 0) {
-			nft_table_free(table);
-			goto err_free;
-		}
+	table = nft_table_alloc();
+	if (table == NULL)
+		return -1;
 
-		nft_table_list_add_tail(table, table_list);
-	}
+	if (nft_mxml_table_parse(ctx->xml, table, err) != 0)
+		goto err;
 
-	if (!nft_table_list_is_empty(table_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST,
-				     table_list);
-	else
-		nft_table_list_free(table_list);
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TABLE, table);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_TABLE);
 
 	return 0;
-err_free:
-	nft_table_list_free(table_list);
+err:
+	nft_table_free(table);
 	return -1;
 }
 
 static int
-nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree,
+nft_ruleset_xml_parse_chains(struct nft_parse_ctx *ctx,
 			     struct nft_parse_err *err)
 {
-	mxml_node_t *node;
 	struct nft_chain *chain;
-	struct nft_chain_list *chain_list = nft_chain_list_alloc();
-	if (chain_list == NULL) {
-		errno = ENOMEM;
-		return -1;
-	}
+	uint32_t type = NFT_RULESET_TYPE_CHAIN;
 
-	for (node = mxmlFindElement(tree, tree, "chain", NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, tree, "chain", NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		chain = nft_chain_alloc();
-		if (chain == NULL)
-			goto err_free;
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
 
-		if (nft_mxml_chain_parse(node, chain, err) != 0) {
-			nft_chain_free(chain);
-			goto err_free;
-		}
+	chain = nft_chain_alloc();
+	if (chain == NULL)
+		return -1;
 
-		nft_chain_list_add_tail(chain, chain_list);
-	}
+	if (nft_mxml_chain_parse(ctx->xml, chain, err) != 0)
+		goto err;
 
-	if (!nft_chain_list_is_empty(chain_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST,
-				     chain_list);
-	else
-		nft_chain_list_free(chain_list);
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_CHAIN, chain);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_CHAIN);
 
 	return 0;
-err_free:
-	nft_chain_list_free(chain_list);
+err:
+	nft_chain_free(chain);
 	return -1;
 }
 
 static int
-nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
-			   struct nft_parse_err *err)
+nft_ruleset_xml_parse_set(struct nft_parse_ctx *ctx, int type,
+			  struct nft_parse_err *err)
 {
-	uint32_t set_id = 0;
-	mxml_node_t *node;
 	struct nft_set *set;
-	struct nft_set_list *set_list = nft_set_list_alloc();
-	if (set_list == NULL) {
-		errno = ENOMEM;
-		return -1;
-	}
 
-	for (node = mxmlFindElement(tree, tree, "set", NULL, NULL,
-				    MXML_DESCEND_FIRST);
-	     node != NULL;
-	     node = mxmlFindElement(node, tree, "set", NULL, NULL,
-				    MXML_NO_DESCEND)) {
-		set = nft_set_alloc();
-		if (set == NULL)
-			goto err_free;
-
-		if (nft_mxml_set_parse(node, set, err) != 0) {
-			nft_set_free(set);
-			goto err_free;
-		}
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
+	set = nft_set_alloc();
+	if (set == NULL)
+		return -1;
 
-		nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id++);
-		nft_set_list_add_tail(set, set_list);
-	}
+	if (nft_mxml_set_parse(ctx->xml, set, err) != 0)
+		goto err;
 
-	if (!nft_set_list_is_empty(set_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, set_list);
-	else
-		nft_set_list_free(set_list);
+	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
+	nft_set_list_add_tail(set, ctx->set_list);
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_SET, set);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_SET);
 
 	return 0;
-err_free:
-	nft_set_list_free(set_list);
+err:
+	nft_set_free(set);
 	return -1;
 }
 
 static int
-nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
-			    struct nft_parse_err *err,
-			    struct nft_set_list *set_list)
+nft_ruleset_xml_parse_set_elems(struct nft_parse_ctx *ctx,
+			   struct nft_parse_err *err)
+{
+	return nft_ruleset_xml_parse_set(ctx, NFT_RULESET_TYPE_SET, err);
+}
+
+static int
+nft_ruleset_xml_parse_sets(struct nft_parse_ctx *ctx,
+			   struct nft_parse_err *err)
+{
+	return nft_ruleset_xml_parse_set(ctx, NFT_RULESET_TYPE_SET, err);
+}
+
+static int
+nft_ruleset_xml_parse_rules(struct nft_parse_ctx *ctx,
+			    struct nft_parse_err *err)
 {
-	mxml_node_t *node;
 	struct nft_rule *rule;
-	struct nft_rule_list *rule_list = nft_rule_list_alloc();
-	if (rule_list == NULL) {
+	uint32_t type = NFT_RULESET_TYPE_RULE;
+
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
+
+	rule = nft_rule_alloc();
+	if (rule == NULL)
+		return -1;
+
+	if (nft_mxml_rule_parse(ctx->xml, rule, err, ctx->set_list) != 0)
+		goto err;
+
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_RULE, rule);
+	if (ctx->cb(ctx) < 0)
+		goto err;
+	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_RULE);
+
+	return 0;
+err:
+	nft_rule_free(rule);
+	return -1;
+}
+
+static int nft_ruleset_xml_parse_ruleset(struct nft_parse_ctx *ctx,
+					 struct nft_parse_err *err)
+{
+	ctx->set_list = nft_set_list_alloc();
+	const char *node_type;
+	mxml_node_t *node, *array = ctx->xml;
+	int len = 0;
+	uint32_t type;
+
+	if (ctx->set_list == NULL) {
 		errno = ENOMEM;
 		return -1;
 	}
 
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
-
-		if (nft_mxml_rule_parse(node, rule, err, set_list) != 0) {
-			nft_rule_free(rule);
-			goto err_free;
-		}
-
-		nft_rule_list_add_tail(rule, rule_list);
+		len++;
+		node_type = node->value.opaque;
+		ctx->xml = node;
+		if (strcmp(node_type, "table") == 0) {
+			if (nft_ruleset_xml_parse_tables(ctx, err) != 0)
+				return -1;
+		} else if (strcmp(node_type, "chain") == 0) {
+			if (nft_ruleset_xml_parse_chains(ctx, err) != 0)
+				return -1;
+		} else if (strcmp(node_type, "set") == 0) {
+			if (nft_ruleset_xml_parse_sets(ctx, err) != 0)
+				return -1;
+		} else if (strcmp(node_type, "rule") == 0) {
+			if (nft_ruleset_xml_parse_rules(ctx, err) != 0)
+				return -1;
+		} else if (strcmp(node_type, "elements") == 0) {
+			if (nft_ruleset_xml_parse_set_elems(ctx, err) != 0)
+				return -1;
+		} else
+			return -1;
+	}
+	if (len == 0 && ctx->cmd == NFT_CMD_FLUSH) {
+		type = NFT_RULESET_TYPE_RULESET;
+		nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
+		if (ctx->cb(ctx) < 0)
+			return -1;
 	}
-
-	if (!nft_rule_list_is_empty(rule_list))
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, rule_list);
-	else
-		nft_rule_list_free(rule_list);
 
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
+	int ret;
+	mxml_node_t *nodecmd;
 
-	if (nft_ruleset_xml_parse_chains(rs, tree, err) != 0)
+	ret = nft_str2cmd(cmd, &cmdnum);
+	if (ret < 0)
 		return -1;
 
-	if (nft_ruleset_xml_parse_sets(rs, tree, err) != 0)
-		return -1;
+	nodecmd = mxmlFindElement(ctx->xml, ctx->xml, cmd, NULL, NULL,
+				  MXML_DESCEND_FIRST);
 
-	if (nft_ruleset_xml_parse_rules(rs, tree, err, rs->set_list) != 0)
-		return -1;
+	ctx->xml = nodecmd;
+	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_CMD, &cmdnum);
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
+				 enum nft_parse_input input, void *arg,
+				 int (*cb)(struct nft_parse_ctx *ctx))
 {
 #ifdef XML_PARSING
-	mxml_node_t *tree;
+	mxml_node_t *tree, *nodecmd = NULL;
+	char *cmd;
+	struct nft_parse_ctx *ctx = nft_ruleset_ctx_alloc();
 
+	if (ctx == NULL)
+		return -1;
+
+	ctx->cb = cb;
+	ctx->data = arg;
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
 	if (tree == NULL)
 		return -1;
 
-	if (nft_ruleset_xml_parse_ruleset(rs, tree, err) != 0)
-		goto err;
+	ctx->xml = tree;
+
+	nodecmd = mxmlWalkNext(tree, tree, MXML_DESCEND_FIRST);
+	while (nodecmd != NULL) {
+		cmd = nodecmd->value.opaque;
+		if (nft_ruleset_xml_parse_cmd(cmd, err, ctx) < 0)
+			goto err;
+		nodecmd = mxmlWalkNext(tree, tree, MXML_NO_DESCEND);
+	}
 
 	mxmlDelete(tree);
+	nft_ruleset_ctx_free(ctx);
 	return 0;
 err:
 	mxmlDelete(tree);
+	nft_ruleset_ctx_free(ctx);
 	return -1;
 #else
 	errno = EOPNOTSUPP;
@@ -591,18 +776,18 @@ err:
 }
 
 static int
-nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
-		     const void *data, struct nft_parse_err *err,
-		     enum nft_parse_input input)
+nft_ruleset_do_parse(enum nft_parse_type type, const void *data,
+		     struct nft_parse_err *err, enum nft_parse_input input,
+		     void *arg, int (*cb)(struct nft_parse_ctx *ctx))
 {
 	int ret;
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_ruleset_xml_parse(r, data, err, input);
+		ret = nft_ruleset_xml_parse(data, err, input, arg, cb);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_ruleset_json_parse(r, data, err, input);
+		ret = nft_ruleset_json_parse(data, err, input, arg, cb);
 		break;
 	default:
 		ret = -1;
@@ -613,17 +798,89 @@ nft_ruleset_do_parse(struct nft_ruleset *r, enum nft_parse_type type,
 	return ret;
 }
 
+int nft_ruleset_parse_file_cb(enum nft_parse_type type, FILE *fp,
+			      struct nft_parse_err *err, void *data,
+			      int (*cb)(struct nft_parse_ctx *ctx))
+{
+	return nft_ruleset_do_parse(type, fp, err, NFT_PARSE_FILE, data, cb);
+}
+EXPORT_SYMBOL(nft_ruleset_parse_file_cb);
+
+int nft_ruleset_parse_buffer_cb(enum nft_parse_type type, const char *buffer,
+				struct nft_parse_err *err, void *data,
+				int (*cb)(struct nft_parse_ctx *ctx))
+{
+	return nft_ruleset_do_parse(type, buffer, err, NFT_PARSE_BUFFER, data,
+				    cb);
+}
+EXPORT_SYMBOL(nft_ruleset_parse_buffer_cb);
+
+static int nft_ruleset_init_ruleset(struct nft_parse_ctx *ctx)
+{
+	struct nft_ruleset *r = ctx->data;
+	struct nft_table_list *table_list = r->table_list;
+	struct nft_chain_list *chain_list = r->chain_list;
+	struct nft_rule_list *rule_list = r->rule_list;
+	struct nft_set_list *set_list = r->set_list;
+
+	if (ctx->cmd != NFT_CMD_ADD)
+		return -1;
+
+	switch (ctx->type) {
+	case NFT_RULESET_TYPE_TABLE:
+		if (table_list == NULL) {
+			table_list = nft_table_list_alloc();
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_TABLELIST,
+					     table_list);
+		}
+		nft_table_list_add_tail(ctx->table, table_list);
+		break;
+	case NFT_RULESET_TYPE_CHAIN:
+		if (chain_list == NULL) {
+			chain_list = nft_chain_list_alloc();
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_CHAINLIST,
+					     chain_list);
+		}
+		nft_chain_list_add_tail(ctx->chain, chain_list);
+		break;
+	case NFT_RULESET_TYPE_SET:
+		if (set_list == NULL) {
+			set_list = nft_set_list_alloc();
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_SETLIST,
+					     set_list);
+		}
+		nft_set_list_add_tail(ctx->set, set_list);
+		break;
+	case NFT_RULESET_TYPE_RULE:
+		if (rule_list == NULL) {
+			rule_list = nft_rule_list_alloc();
+			nft_ruleset_attr_set(r, NFT_RULESET_ATTR_RULELIST,
+					     rule_list);
+		}
+		nft_rule_list_add_tail(ctx->rule, rule_list);
+		break;
+	case NFT_RULESET_TYPE_RULESET:
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
+	return nft_ruleset_parse_buffer_cb(type, data, err, r,
+					   nft_ruleset_init_ruleset);
 }
 EXPORT_SYMBOL(nft_ruleset_parse);
 
 int nft_ruleset_parse_file(struct nft_ruleset *rs, enum nft_parse_type type,
 			   FILE *fp, struct nft_parse_err *err)
 {
-	return nft_ruleset_do_parse(rs, type, fp, err, NFT_PARSE_FILE);
+	return nft_ruleset_parse_file_cb(type, fp, err, rs,
+					 nft_ruleset_init_ruleset);
 }
 EXPORT_SYMBOL(nft_ruleset_parse_file);
 
diff --git a/src/set.c b/src/set.c
index ba42b91..3fa4794 100644
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
index 5890115..87eaa61 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <buffer.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
@@ -193,6 +194,28 @@ int nft_flag2cmd(uint32_t flags, uint32_t *cmd)
 	return -1;
 }
 
+int nft_str2cmd(const char *cmd, uint32_t *cmd_num)
+{
+	if (strcmp(cmd, ADD) == 0) {
+		*cmd_num = NFT_CMD_ADD;
+		return 0;
+	} else if (strcmp(cmd, INSERT) == 0) {
+		*cmd_num = NFT_CMD_INSERT;
+		return 0;
+	} else if (strcmp(cmd, DELETE) == 0) {
+		*cmd_num = NFT_CMD_DELETE;
+		return 0;
+	} else if (strcmp(cmd, REPLACE) == 0) {
+		*cmd_num = NFT_CMD_REPLACE;
+		return 0;
+	} else if (strcmp(cmd, FLUSH) == 0) {
+		*cmd_num = NFT_CMD_FLUSH;
+		return 0;
+	}
+
+	return -1;
+}
+
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 		int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj,
 				   uint32_t type, uint32_t flags))
-- 
1.7.10.4

