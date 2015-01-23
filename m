From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 3/5] ruleset: consolidate code in json/xml import support
Date: Fri, 23 Jan 2015 15:49:54 +0100
Message-ID: <1422024596-8839-4-git-send-email-alvaroneay@gmail.com>
References: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49351 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbAWOtp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:49:45 -0500
Received: by mail-wg0-f48.google.com with SMTP id x12so7884307wgg.7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2015 06:49:44 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id ev7sm2462989wjb.47.2015.01.23.06.49.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Jan 2015 06:49:43 -0800 (PST)
In-Reply-To: <1422024596-8839-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/ruleset.c |  266 +++++++++++++++++++++++----------------------------------
 1 file changed, 109 insertions(+), 157 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index a3e4b20..3233e46 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -35,6 +35,7 @@ struct nft_ruleset {
 struct nft_parse_ctx {
 	uint32_t cmd;
 	uint32_t type;
+	uint32_t format;
 	union {
 		struct nft_table *table;
 		struct nft_chain *chain;
@@ -256,8 +257,8 @@ void *nft_ruleset_ctx_attr_get(struct nft_parse_ctx *ctx, uint16_t attr)
 }
 EXPORT_SYMBOL(nft_ruleset_ctx_attr_get);
 
-#ifdef JSON_PARSING
-static int nft_ruleset_json_parse_tables(struct nft_parse_ctx *ctx,
+#if defined(JSON_PARSING) || defined(XML_PARSING)
+static int nft_ruleset_parse_tables(struct nft_parse_ctx *ctx,
 					 struct nft_parse_err *err)
 {
 	struct nft_table *table;
@@ -271,8 +272,22 @@ static int nft_ruleset_json_parse_tables(struct nft_parse_ctx *ctx,
 		return -1;
 	}
 
-	if (nft_jansson_parse_table(table, ctx->json, err) < 0)
-		goto err;
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
+	}
 
 	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TABLE, table);
 	if (ctx->cb(ctx) < 0)
@@ -285,7 +300,7 @@ err:
 	return -1;
 }
 
-static int nft_ruleset_json_parse_chains(struct nft_parse_ctx *ctx,
+static int nft_ruleset_parse_chains(struct nft_parse_ctx *ctx,
 					 struct nft_parse_err *err)
 {
 	struct nft_chain *chain;
@@ -299,8 +314,22 @@ static int nft_ruleset_json_parse_chains(struct nft_parse_ctx *ctx,
 		return -1;
 	}
 
-	if (nft_jansson_parse_chain(chain, ctx->json, err) < 0)
-		goto err;
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_chain(chain, ctx->json, err) < 0)
+			goto err;
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_chain_parse(ctx->xml, chain, err) < 0)
+			goto err;
+#endif
+		break;
+	default:
+		return -1;
+	}
 
 	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_CHAIN, chain);
 	if (ctx->cb(ctx) < 0)
@@ -313,7 +342,7 @@ err:
 	return -1;
 }
 
-static int nft_ruleset_json_parse_set(struct nft_parse_ctx *ctx,
+static int nft_ruleset_parse_set(struct nft_parse_ctx *ctx,
 				      struct nft_set *set, int type,
 				      struct nft_parse_err *err)
 {
@@ -332,7 +361,7 @@ err:
 	return -1;
 }
 
-static int nft_ruleset_json_parse_set_elems(struct nft_parse_ctx *ctx,
+static int nft_ruleset_parse_set_elems(struct nft_parse_ctx *ctx,
 					    struct nft_parse_err *err)
 {
 	struct nft_set *set;
@@ -343,18 +372,30 @@ static int nft_ruleset_json_parse_set_elems(struct nft_parse_ctx *ctx,
 		return -1;
 	}
 
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_elem(set, ctx->json, err) < 0)
+			goto err;
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_set_parse(ctx->xml, set, err) < 0)
+			goto err;
+#endif
+		break;
+	default:
+		return -1;
+	}
 
-	if (nft_jansson_parse_elem(set, ctx->json, err) < 0)
-		goto err;
-
-	return nft_ruleset_json_parse_set(ctx, set, NFT_RULESET_TYPE_SET_ELEMS,
-					  err);
+	return nft_ruleset_parse_set(ctx, set, NFT_RULESET_TYPE_SET_ELEMS, err);
 err:
 	nft_set_free(set);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_sets(struct nft_parse_ctx *ctx,
+static int nft_ruleset_parse_sets(struct nft_parse_ctx *ctx,
 				       struct nft_parse_err *err)
 {
 	struct nft_set *set;
@@ -365,16 +406,30 @@ static int nft_ruleset_json_parse_sets(struct nft_parse_ctx *ctx,
 		return -1;
 	}
 
-	if (nft_jansson_parse_set(set, ctx->json, err) < 0)
-		goto err;
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
+		if (nft_jansson_parse_set(set, ctx->json, err) < 0)
+			goto err;
+#endif
+		break;
+	case NFT_OUTPUT_XML:
+#ifdef XML_PARSING
+		if (nft_mxml_set_parse(ctx->xml, set, err) < 0)
+			goto err;
+#endif
+		break;
+	default:
+		return -1;
+	}
 
-	return nft_ruleset_json_parse_set(ctx, set, NFT_RULESET_TYPE_SET, err);
+	return nft_ruleset_parse_set(ctx, set, NFT_RULESET_TYPE_SET, err);
 err:
 	nft_set_free(set);
 	return -1;
 }
 
-static int nft_ruleset_json_parse_rules(struct nft_parse_ctx *ctx,
+static int nft_ruleset_parse_rules(struct nft_parse_ctx *ctx,
 					struct nft_parse_err *err)
 {
 	struct nft_rule *rule;
@@ -388,8 +443,23 @@ static int nft_ruleset_json_parse_rules(struct nft_parse_ctx *ctx,
 		return -1;
 	}
 
-	if (nft_jansson_parse_rule(rule, ctx->json, err, ctx->set_list) < 0)
-		goto err;
+	switch (ctx->format) {
+	case NFT_OUTPUT_JSON:
+#ifdef JSON_PARSING
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
+		return -1;
+	}
 
 	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_RULE, rule);
 	if (ctx->cb(ctx) < 0)
@@ -423,19 +493,19 @@ static int nft_ruleset_json_parse_ruleset(struct nft_parse_ctx *ctx,
 
 		ctx->json = node;
 		if (nft_jansson_node_exist(node, "table")) {
-			if (nft_ruleset_json_parse_tables(ctx, err) < 0)
+			if (nft_ruleset_parse_tables(ctx, err) < 0)
 				return -1;
 		} else if (nft_jansson_node_exist(node, "chain")) {
-			if (nft_ruleset_json_parse_chains(ctx, err) < 0)
+			if (nft_ruleset_parse_chains(ctx, err) < 0)
 				return -1;
 		} else if (nft_jansson_node_exist(node, "set")) {
-			if (nft_ruleset_json_parse_sets(ctx, err) < 0)
+			if (nft_ruleset_parse_sets(ctx, err) < 0)
 				return -1;
 		} else if (nft_jansson_node_exist(node, "rule")) {
-			if (nft_ruleset_json_parse_rules(ctx, err) < 0)
+			if (nft_ruleset_parse_rules(ctx, err) < 0)
 				return -1;
 		} else if (nft_jansson_node_exist(node, "elements")) {
-			if (nft_ruleset_json_parse_set_elems(ctx, err) < 0)
+			if (nft_ruleset_parse_set_elems(ctx, err) < 0)
 				return -1;
 		} else {
 			return -1;
@@ -481,7 +551,8 @@ err:
 
 static int nft_ruleset_json_parse(const void *json,
 				  struct nft_parse_err *err,
-				  enum nft_parse_input input, void *arg,
+				  enum nft_parse_input input,
+				  enum nft_parse_type type, void *arg,
 				  int (*cb)(struct nft_parse_ctx *ctx))
 {
 #ifdef JSON_PARSING
@@ -496,6 +567,7 @@ static int nft_ruleset_json_parse(const void *json,
 
 	ctx->cb = cb;
 	ctx->data = arg;
+	ctx->format = type;
 	root = nft_jansson_create_root(json, &error, err, input);
 	if (root == NULL)
 		return -1;
@@ -536,128 +608,6 @@ err:
 }
 
 #ifdef XML_PARSING
-static int
-nft_ruleset_xml_parse_tables(struct nft_parse_ctx *ctx,
-			     struct nft_parse_err *err)
-{
-	struct nft_table *table;
-	uint32_t type = NFT_RULESET_TYPE_TABLE;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
-
-	table = nft_table_alloc();
-	if (table == NULL)
-		return -1;
-
-	if (nft_mxml_table_parse(ctx->xml, table, err) != 0)
-		goto err;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TABLE, table);
-	if (ctx->cb(ctx) < 0)
-		goto err;
-	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_TABLE);
-
-	return 0;
-err:
-	nft_table_free(table);
-	return -1;
-}
-
-static int
-nft_ruleset_xml_parse_chains(struct nft_parse_ctx *ctx,
-			     struct nft_parse_err *err)
-{
-	struct nft_chain *chain;
-	uint32_t type = NFT_RULESET_TYPE_CHAIN;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
-
-	chain = nft_chain_alloc();
-	if (chain == NULL)
-		return -1;
-
-	if (nft_mxml_chain_parse(ctx->xml, chain, err) != 0)
-		goto err;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_CHAIN, chain);
-	if (ctx->cb(ctx) < 0)
-		goto err;
-	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_CHAIN);
-
-	return 0;
-err:
-	nft_chain_free(chain);
-	return -1;
-}
-
-static int
-nft_ruleset_xml_parse_set(struct nft_parse_ctx *ctx, int type,
-			  struct nft_parse_err *err)
-{
-	struct nft_set *set;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
-	set = nft_set_alloc();
-	if (set == NULL)
-		return -1;
-
-	if (nft_mxml_set_parse(ctx->xml, set, err) != 0)
-		goto err;
-
-	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
-	nft_set_list_add_tail(set, ctx->set_list);
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_SET, set);
-	if (ctx->cb(ctx) < 0)
-		goto err;
-	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_SET);
-
-	return 0;
-err:
-	nft_set_free(set);
-	return -1;
-}
-
-static int
-nft_ruleset_xml_parse_set_elems(struct nft_parse_ctx *ctx,
-			   struct nft_parse_err *err)
-{
-	return nft_ruleset_xml_parse_set(ctx, NFT_RULESET_TYPE_SET, err);
-}
-
-static int
-nft_ruleset_xml_parse_sets(struct nft_parse_ctx *ctx,
-			   struct nft_parse_err *err)
-{
-	return nft_ruleset_xml_parse_set(ctx, NFT_RULESET_TYPE_SET, err);
-}
-
-static int
-nft_ruleset_xml_parse_rules(struct nft_parse_ctx *ctx,
-			    struct nft_parse_err *err)
-{
-	struct nft_rule *rule;
-	uint32_t type = NFT_RULESET_TYPE_RULE;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_TYPE, &type);
-
-	rule = nft_rule_alloc();
-	if (rule == NULL)
-		return -1;
-
-	if (nft_mxml_rule_parse(ctx->xml, rule, err, ctx->set_list) != 0)
-		goto err;
-
-	nft_ruleset_ctx_attr_set(ctx, NFT_RULESET_CTX_RULE, rule);
-	if (ctx->cb(ctx) < 0)
-		goto err;
-	nft_ruleset_ctx_attr_unset(ctx, NFT_RULESET_CTX_RULE);
-
-	return 0;
-err:
-	nft_rule_free(rule);
-	return -1;
-}
-
 static int nft_ruleset_xml_parse_ruleset(struct nft_parse_ctx *ctx,
 					 struct nft_parse_err *err)
 {
@@ -681,19 +631,19 @@ static int nft_ruleset_xml_parse_ruleset(struct nft_parse_ctx *ctx,
 		node_type = node->value.opaque;
 		ctx->xml = node;
 		if (strcmp(node_type, "table") == 0) {
-			if (nft_ruleset_xml_parse_tables(ctx, err) != 0)
+			if (nft_ruleset_parse_tables(ctx, err) != 0)
 				return -1;
 		} else if (strcmp(node_type, "chain") == 0) {
-			if (nft_ruleset_xml_parse_chains(ctx, err) != 0)
+			if (nft_ruleset_parse_chains(ctx, err) != 0)
 				return -1;
 		} else if (strcmp(node_type, "set") == 0) {
-			if (nft_ruleset_xml_parse_sets(ctx, err) != 0)
+			if (nft_ruleset_parse_sets(ctx, err) != 0)
 				return -1;
 		} else if (strcmp(node_type, "rule") == 0) {
-			if (nft_ruleset_xml_parse_rules(ctx, err) != 0)
+			if (nft_ruleset_parse_rules(ctx, err) != 0)
 				return -1;
 		} else if (strcmp(node_type, "elements") == 0) {
-			if (nft_ruleset_xml_parse_set_elems(ctx, err) != 0)
+			if (nft_ruleset_parse_set_elems(ctx, err) != 0)
 				return -1;
 		} else
 			return -1;
@@ -735,7 +685,8 @@ err:
 #endif
 
 static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
-				 enum nft_parse_input input, void *arg,
+				 enum nft_parse_input input,
+				 enum nft_parse_type type, void *arg,
 				 int (*cb)(struct nft_parse_ctx *ctx))
 {
 #ifdef XML_PARSING
@@ -748,6 +699,7 @@ static int nft_ruleset_xml_parse(const void *xml, struct nft_parse_err *err,
 
 	ctx->cb = cb;
 	ctx->data = arg;
+	ctx->format = type;
 	tree = nft_mxml_build_tree(xml, "nftables", err, input);
 	if (tree == NULL)
 		return -1;
@@ -784,10 +736,10 @@ nft_ruleset_do_parse(enum nft_parse_type type, const void *data,
 
 	switch (type) {
 	case NFT_PARSE_XML:
-		ret = nft_ruleset_xml_parse(data, err, input, arg, cb);
+		ret = nft_ruleset_xml_parse(data, err, input, type, arg, cb);
 		break;
 	case NFT_PARSE_JSON:
-		ret = nft_ruleset_json_parse(data, err, input, arg, cb);
+		ret = nft_ruleset_json_parse(data, err, input, type, arg, cb);
 		break;
 	default:
 		ret = -1;
-- 
1.7.10.4

