From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/2] ruleset: clean up the variable names in the xml/json parsing functions
Date: Fri,  9 Jan 2015 13:47:41 +0100
Message-ID: <1420807661-29751-2-git-send-email-alvaroneay@gmail.com>
References: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36888 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbbAIMrV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:47:21 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so2077798wiw.3
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Jan 2015 04:47:19 -0800 (PST)
Received: from localhost.localdomain (129.166.216.87.static.jazztel.es. [87.216.166.129])
        by mx.google.com with ESMTPSA id wr8sm9919145wjc.10.2015.01.09.04.47.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jan 2015 04:47:18 -0800 (PST)
In-Reply-To: <1420807661-29751-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rename variables to use more intuitive name like table, chain, rule or set.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/ruleset.c |  100 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index 6bb7582..a397824 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -137,7 +137,7 @@ static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_t *array,
 {
 	int i, len;
 	json_t *node;
-	struct nft_table *o;
+	struct nft_table *table;
 	struct nft_table_list *list = nft_table_list_alloc();
 
 	if (list == NULL) {
@@ -156,18 +156,18 @@ static int nft_ruleset_json_parse_tables(struct nft_ruleset *rs, json_t *array,
 		if (!(nft_jansson_node_exist(node, "table")))
 			continue;
 
-		o = nft_table_alloc();
-		if (o == NULL) {
+		table = nft_table_alloc();
+		if (table == NULL) {
 			errno = ENOMEM;
 			goto err;
 		}
 
-		if (nft_jansson_parse_table(o, node, err) < 0) {
-			nft_table_free(o);
+		if (nft_jansson_parse_table(table, node, err) < 0) {
+			nft_table_free(table);
 			goto err;
 		}
 
-		nft_table_list_add_tail(o, list);
+		nft_table_list_add_tail(table, list);
 	}
 
 	if (!nft_table_list_is_empty(list))
@@ -186,7 +186,7 @@ static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_t *array,
 {
 	int i, len;
 	json_t *node;
-	struct nft_chain *o;
+	struct nft_chain *chain;
 	struct nft_chain_list *list = nft_chain_list_alloc();
 
 	if (list == NULL) {
@@ -205,18 +205,18 @@ static int nft_ruleset_json_parse_chains(struct nft_ruleset *rs, json_t *array,
 		if (!(nft_jansson_node_exist(node, "chain")))
 			continue;
 
-		o = nft_chain_alloc();
-		if (o == NULL) {
+		chain = nft_chain_alloc();
+		if (chain == NULL) {
 			errno = ENOMEM;
 			goto err;
 		}
 
-		if (nft_jansson_parse_chain(o, node, err) < 0) {
-			nft_chain_free(o);
+		if (nft_jansson_parse_chain(chain, node, err) < 0) {
+			nft_chain_free(chain);
 			goto err;
 		}
 
-		nft_chain_list_add_tail(o, list);
+		nft_chain_list_add_tail(chain, list);
 	}
 
 	if (!nft_chain_list_is_empty(list))
@@ -236,7 +236,7 @@ static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array,
 	int i, len;
 	uint32_t set_id = 0;
 	json_t *node;
-	struct nft_set *s = NULL;
+	struct nft_set *set;
 	struct nft_set_list *list = nft_set_list_alloc();
 
 	if (list == NULL) {
@@ -255,19 +255,19 @@ static int nft_ruleset_json_parse_sets(struct nft_ruleset *rs, json_t *array,
 		if (!(nft_jansson_node_exist(node, "set")))
 			continue;
 
-		s = nft_set_alloc();
-		if (s == NULL) {
+		set = nft_set_alloc();
+		if (set == NULL) {
 			errno = ENOMEM;
 			goto err;
 		}
 
-		if (nft_jansson_parse_set(s, node, err) < 0) {
-			nft_set_free(s);
+		if (nft_jansson_parse_set(set, node, err) < 0) {
+			nft_set_free(set);
 			goto err;
 		}
 
-		nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, set_id++);
-		nft_set_list_add_tail(s, list);
+		nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id++);
+		nft_set_list_add_tail(set, list);
 	}
 
 	if (!nft_set_list_is_empty(list))
@@ -286,7 +286,7 @@ static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t *array,
 {
 	int i, len;
 	json_t *node;
-	struct nft_rule *o = NULL;
+	struct nft_rule *rule = NULL;
 	struct nft_rule_list *list = nft_rule_list_alloc();
 
 	if (list == NULL) {
@@ -305,18 +305,18 @@ static int nft_ruleset_json_parse_rules(struct nft_ruleset *rs, json_t *array,
 		if (!(nft_jansson_node_exist(node, "rule")))
 			continue;
 
-		o = nft_rule_alloc();
-		if (o == NULL) {
+		rule = nft_rule_alloc();
+		if (rule == NULL) {
 			errno = ENOMEM;
 			goto err;
 		}
 
-		if (nft_jansson_parse_rule(o, node, err, rs->set_list) < 0) {
-			nft_rule_free(o);
+		if (nft_jansson_parse_rule(rule, node, err, rs->set_list) < 0) {
+			nft_rule_free(rule);
 			goto err;
 		}
 
-		nft_rule_list_add_tail(o, list);
+		nft_rule_list_add_tail(rule, list);
 	}
 
 	if (!nft_rule_list_is_empty(list))
@@ -378,7 +378,7 @@ nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree,
 			     struct nft_parse_err *err)
 {
 	mxml_node_t *node;
-	struct nft_table *t;
+	struct nft_table *table;
 	struct nft_table_list *table_list = nft_table_list_alloc();
 	if (table_list == NULL) {
 		errno = ENOMEM;
@@ -390,16 +390,16 @@ nft_ruleset_xml_parse_tables(struct nft_ruleset *rs, mxml_node_t *tree,
 	     node != NULL;
 	     node = mxmlFindElement(node, tree, "table", NULL, NULL,
 				    MXML_NO_DESCEND)) {
-		t = nft_table_alloc();
-		if (t == NULL)
+		table = nft_table_alloc();
+		if (table == NULL)
 			goto err_free;
 
-		if (nft_mxml_table_parse(node, t, err) != 0) {
-			nft_table_free(t);
+		if (nft_mxml_table_parse(node, table, err) != 0) {
+			nft_table_free(table);
 			goto err_free;
 		}
 
-		nft_table_list_add_tail(t, table_list);
+		nft_table_list_add_tail(table, table_list);
 	}
 
 	if (!nft_table_list_is_empty(table_list))
@@ -419,7 +419,7 @@ nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree,
 			     struct nft_parse_err *err)
 {
 	mxml_node_t *node;
-	struct nft_chain *c;
+	struct nft_chain *chain;
 	struct nft_chain_list *chain_list = nft_chain_list_alloc();
 	if (chain_list == NULL) {
 		errno = ENOMEM;
@@ -431,16 +431,16 @@ nft_ruleset_xml_parse_chains(struct nft_ruleset *rs, mxml_node_t *tree,
 	     node != NULL;
 	     node = mxmlFindElement(node, tree, "chain", NULL, NULL,
 				    MXML_NO_DESCEND)) {
-		c = nft_chain_alloc();
-		if (c == NULL)
+		chain = nft_chain_alloc();
+		if (chain == NULL)
 			goto err_free;
 
-		if (nft_mxml_chain_parse(node, c, err) != 0) {
-			nft_chain_free(c);
+		if (nft_mxml_chain_parse(node, chain, err) != 0) {
+			nft_chain_free(chain);
 			goto err_free;
 		}
 
-		nft_chain_list_add_tail(c, chain_list);
+		nft_chain_list_add_tail(chain, chain_list);
 	}
 
 	if (!nft_chain_list_is_empty(chain_list))
@@ -461,7 +461,7 @@ nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
 {
 	uint32_t set_id = 0;
 	mxml_node_t *node;
-	struct nft_set *s;
+	struct nft_set *set;
 	struct nft_set_list *set_list = nft_set_list_alloc();
 	if (set_list == NULL) {
 		errno = ENOMEM;
@@ -473,17 +473,17 @@ nft_ruleset_xml_parse_sets(struct nft_ruleset *rs, mxml_node_t *tree,
 	     node != NULL;
 	     node = mxmlFindElement(node, tree, "set", NULL, NULL,
 				    MXML_NO_DESCEND)) {
-		s = nft_set_alloc();
-		if (s == NULL)
+		set = nft_set_alloc();
+		if (set == NULL)
 			goto err_free;
 
-		if (nft_mxml_set_parse(node, s, err) != 0) {
-			nft_set_free(s);
+		if (nft_mxml_set_parse(node, set, err) != 0) {
+			nft_set_free(set);
 			goto err_free;
 		}
 
-		nft_set_attr_set_u32(s, NFT_SET_ATTR_ID, set_id++);
-		nft_set_list_add_tail(s, set_list);
+		nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, set_id++);
+		nft_set_list_add_tail(set, set_list);
 	}
 
 	if (!nft_set_list_is_empty(set_list))
@@ -503,7 +503,7 @@ nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
 			    struct nft_set_list *set_list)
 {
 	mxml_node_t *node;
-	struct nft_rule *r;
+	struct nft_rule *rule;
 	struct nft_rule_list *rule_list = nft_rule_list_alloc();
 	if (rule_list == NULL) {
 		errno = ENOMEM;
@@ -515,16 +515,16 @@ nft_ruleset_xml_parse_rules(struct nft_ruleset *rs, mxml_node_t *tree,
 	     node != NULL;
 	     node = mxmlFindElement(node, tree, "rule", NULL, NULL,
 				    MXML_NO_DESCEND)) {
-		r = nft_rule_alloc();
-		if (r == NULL)
+		rule = nft_rule_alloc();
+		if (rule == NULL)
 			goto err_free;
 
-		if (nft_mxml_rule_parse(node, r, err, set_list) != 0) {
-			nft_rule_free(r);
+		if (nft_mxml_rule_parse(node, rule, err, set_list) != 0) {
+			nft_rule_free(rule);
 			goto err_free;
 		}
 
-		nft_rule_list_add_tail(r, rule_list);
+		nft_rule_list_add_tail(rule, rule_list);
 	}
 
 	if (!nft_rule_list_is_empty(rule_list))
-- 
1.7.10.4

