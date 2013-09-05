From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: xml: get rid of mxml parsing flags
Date: Thu, 05 Sep 2013 02:24:33 +0200
Message-ID: <20130905002433.23456.7982.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56862 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752966Ab3IEAYp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:24:45 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 6D67251ED2D
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2013 00:24:42 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ksdvVOLd8M6k for <netfilter-devel@vger.kernel.org>;
	Thu,  5 Sep 2013 02:24:35 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id C4E6951ECFD
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2013 02:24:35 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, most XML parsing functions lost one argument, making the code clearer.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/chain.c b/src/chain.c
index 1761772..33488b9 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -591,32 +591,32 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 	if (strcmp(tree->value.opaque, "chain") != 0)
 		goto err;
 
-	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST);
+	name = nft_mxml_str_parse(tree, "name");
 	if (name == NULL)
 		goto err;
 
 	strncpy(c->name, name, NFT_CHAIN_MAXNAMELEN);
 	c->flags |= (1 << NFT_CHAIN_ATTR_NAME);
 
-	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "handle", BASE_DEC,
 			       &c->handle, NFT_TYPE_U64) != 0)
 		goto err;
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_HANDLE);
 
-	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "bytes", BASE_DEC,
 			       &c->bytes, NFT_TYPE_U64) != 0)
 		goto err;
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_BYTES);
 
-	if (nft_mxml_num_parse(tree, "packets", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "packets", BASE_DEC,
 			       &c->packets, NFT_TYPE_U64) != 0)
 		goto err;
 
 	c->flags |= (1 << NFT_CHAIN_ATTR_PACKETS);
 
-	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST);
+	table = nft_mxml_str_parse(tree, "table");
 	if (table == NULL)
 		goto err;
 
@@ -626,14 +626,14 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 	c->table = strdup(table);
 	c->flags |= (1 << NFT_CHAIN_ATTR_TABLE);
 
-	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
+	family = nft_mxml_family_parse(tree, "family");
 	if (family < 0)
 		goto err;
 
 	c->family = family;
 	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
 
-	hooknum_str = nft_mxml_str_parse(tree, "hooknum", MXML_DESCEND_FIRST);
+	hooknum_str = nft_mxml_str_parse(tree, "hooknum");
 	if (hooknum_str != NULL) {
 		hooknum = nft_str2hooknum(hooknum_str);
 		if (hooknum < 0)
@@ -642,7 +642,7 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 		c->hooknum = hooknum;
 		c->flags |= (1 << NFT_CHAIN_ATTR_HOOKNUM);
 
-		type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST);
+		type = nft_mxml_str_parse(tree, "type");
 		if (type == NULL)
 			goto err;
 
@@ -653,13 +653,13 @@ static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 		c->flags |= (1 << NFT_CHAIN_ATTR_TYPE);
 
 
-		if (nft_mxml_num_parse(tree, "prio", MXML_DESCEND, BASE_DEC,
+		if (nft_mxml_num_parse(tree, "prio", BASE_DEC,
 				       &c->prio, NFT_TYPE_S32) != 0)
 			goto err;
 
 		c->flags |= (1 << NFT_CHAIN_ATTR_PRIO);
 
-		policy_str = nft_mxml_str_parse(tree, "policy", MXML_DESCEND);
+		policy_str = nft_mxml_str_parse(tree, "policy");
 		if (policy_str == NULL)
 			goto err;
 
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 11738a7..5e832a0 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -231,22 +231,22 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	struct nft_expr_bitwise *bitwise = nft_expr_data(e);
 	int32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "sreg");
 	if (reg < 0)
 		return -1;
 
 	bitwise->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_BITWISE_SREG);
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
 	bitwise->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_BITWISE_DREG);
 
-	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST,
-			       BASE_DEC, &bitwise->len, NFT_TYPE_U8) != 0)
+	if (nft_mxml_num_parse(tree, "len", BASE_DEC,
+			       &bitwise->len, NFT_TYPE_U8) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_BITWISE_LEN);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 0277812..133f635 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -246,21 +246,21 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	const char *op;
 	int32_t reg, ntoh;
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "sreg");
 	if (reg < 0)
 		return -1;
 
 	byteorder->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_SREG);
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
 	byteorder->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_DREG);
 
-	op = nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST);
+	op = nft_mxml_str_parse(tree, "op");
 	if (op == NULL)
 		return -1;
 
@@ -271,13 +271,13 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	byteorder->op = ntoh;
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_OP);
 
-	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "len", BASE_DEC,
 			       &byteorder->len, NFT_TYPE_U8) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_BYTEORDER_LEN);
 
-	if (nft_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "size", BASE_DEC,
 			       &byteorder->size, NFT_TYPE_U8) != 0)
 		return -1;
 
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 543f774..e9ff58d 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -217,14 +217,14 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	const char *op;
 	int32_t reg, op_value;
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "sreg");
 	if (reg < 0)
 		return -1;
 
 	cmp->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_CMP_SREG);
 
-	op = nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST);
+	op = nft_mxml_str_parse(tree, "op");
 	if (op == NULL)
 		return -1;
 
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 53dc526..2fa2e86 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -147,13 +147,13 @@ nft_rule_expr_counter_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 #ifdef XML_PARSING
 	struct nft_expr_counter *ctr = nft_expr_data(e);
 
-	if (nft_mxml_num_parse(tree, "pkts", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "pkts", BASE_DEC,
                                &ctr->pkts, NFT_TYPE_U64) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_CTR_PACKETS);
 
-	if (nft_mxml_num_parse(tree, "bytes", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "bytes", BASE_DEC,
                                &ctr->bytes, NFT_TYPE_U64) != 0)
 		return -1;
 
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 4655a96..9d4c424 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -234,14 +234,14 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	int key;
 	uint8_t dir;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
 	ct->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_CT_DREG);
 
-	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST);
+	key_str = nft_mxml_str_parse(tree, "key");
 	if (key_str == NULL)
 		return -1;
 
@@ -252,7 +252,7 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	ct->key = key;
 	e->flags |= (1 << NFT_EXPR_CT_KEY);
 
-	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC, &dir,
+	if (nft_mxml_num_parse(tree, "dir", BASE_DEC, &dir,
 			       NFT_TYPE_U8) != 0)
 		return -1;
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 34537a7..bfa7c0b 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -133,7 +133,7 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 	}
 
 	/* Get and set <verdict> */
-	verdict_str = nft_mxml_str_parse(tree, "verdict", MXML_DESCEND);
+	verdict_str = nft_mxml_str_parse(node, "verdict");
 	if (verdict_str == NULL) {
 		mxmlDelete(tree);
 		return -1;
@@ -183,7 +183,7 @@ static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)
 	if (reg->chain)
 		xfree(reg->chain);
 
-	reg->chain = nft_mxml_str_parse(tree, "chain", MXML_DESCEND);
+	reg->chain = nft_mxml_str_parse(node, "chain");
 	if (reg->chain == NULL) {
 		mxmlDelete(tree);
 		return -1;
@@ -233,8 +233,8 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 		return -1;
 	}
 
-	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND, BASE_DEC, &reg->len,
-			       NFT_TYPE_U8) != 0) {
+	if (nft_mxml_num_parse(node, "len", BASE_DEC,
+			       &reg->len, NFT_TYPE_U8) != 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
@@ -243,8 +243,9 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
 		sprintf(node_name, "data%d", i);
 
-		if (nft_mxml_num_parse(tree, node_name, MXML_DESCEND, BASE_HEX,
-				       &reg->val[i], NFT_TYPE_U32) != 0) {
+		if (nft_mxml_num_parse(node, node_name,
+				       BASE_HEX, &reg->val[i],
+				       NFT_TYPE_U32) != 0) {
 			mxmlDelete(tree);
 			return -1;
 		}
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index af9d6bf..cc09d6d 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -241,15 +241,14 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	int32_t reg;
 	int type;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
 	exthdr->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_EXTHDR_DREG);
 
-	exthdr_type = nft_mxml_str_parse(tree, "exthdr_type",
-					 MXML_DESCEND_FIRST);
+	exthdr_type = nft_mxml_str_parse(tree, "exthdr_type");
 	if (exthdr_type == NULL)
 		return -1;
 
@@ -261,14 +260,14 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	e->flags |= (1 << NFT_EXPR_EXTHDR_TYPE);
 
 	/* Get and set <offset> */
-	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "offset", BASE_DEC,
 			       &exthdr->offset, NFT_TYPE_U32) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_EXTHDR_OFFSET);
 
 	/* Get and set <len> */
-	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "len", BASE_DEC,
 			       &exthdr->len, NFT_TYPE_U32) != 0)
 		return -1;
 
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 0556999..ae1c8ad 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -224,7 +224,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	int datareg_type;
 	int32_t reg;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
diff --git a/src/expr/limit.c b/src/expr/limit.c
index bd92cd1..913e594 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -145,13 +145,13 @@ static int nft_rule_expr_limit_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 #ifdef XML_PARSING
 	struct nft_expr_limit *limit = nft_expr_data(e);
 
-	if (nft_mxml_num_parse(tree, "rate", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "rate", BASE_DEC,
 			       &limit->rate, NFT_TYPE_U64) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_LIMIT_RATE);
 
-	if (nft_mxml_num_parse(tree, "depth", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "depth", BASE_DEC,
 			       &limit->depth, NFT_TYPE_U64) != 0)
 		return -1;
 
diff --git a/src/expr/log.c b/src/expr/log.c
index bbbd5b9..e286546 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -198,27 +198,27 @@ static int nft_rule_expr_log_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	struct nft_expr_log *log = nft_expr_data(e);
 	const char *prefix;
 
-	prefix = nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST);
+	prefix = nft_mxml_str_parse(tree, "prefix");
 	if (prefix == NULL)
 		return -1;
 
 	log->prefix = strdup(prefix);
 	e->flags |= (1 << NFT_EXPR_LOG_PREFIX);
 
-	if (nft_mxml_num_parse(tree, "group", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "group", BASE_DEC,
 			       &log->group, NFT_TYPE_U16) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_LOG_GROUP);
 
-	if (nft_mxml_num_parse(tree, "snaplen", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "snaplen", BASE_DEC,
 			       &log->snaplen, NFT_TYPE_U32) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_LOG_SNAPLEN);
 
-	if (nft_mxml_num_parse(tree, "qthreshold", MXML_DESCEND_FIRST,
-			       BASE_DEC, &log->qthreshold, NFT_TYPE_U16) != 0)
+	if (nft_mxml_num_parse(tree, "qthreshold", BASE_DEC,
+			       &log->qthreshold, NFT_TYPE_U16) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_LOG_QTHRESHOLD);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 56ab253..1cf225a 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -180,7 +180,7 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	const char *set_name;
 	int32_t reg;
 
-	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST);
+	set_name = nft_mxml_str_parse(tree, "set");
 	if (set_name == NULL)
 		return -1;
 
@@ -188,14 +188,14 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	lookup->set_name[IFNAMSIZ-1] = '\0';
 	e->flags |= (1 << NFT_EXPR_LOOKUP_SET);
 
-	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "sreg");
 	if (reg < 0)
 		return -1;
 
 	lookup->sreg = reg;
 	e->flags |= (1 << NFT_EXPR_LOOKUP_SREG);
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
diff --git a/src/expr/match.c b/src/expr/match.c
index b18d594..419caed 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -195,7 +195,7 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 	struct nft_expr_match *mt = nft_expr_data(e);
 	const char *name;
 
-	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST);
+	name = nft_mxml_str_parse(tree, "name");
 	if (name == NULL)
 		return -1;
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index d914569..c1a9508 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -198,14 +198,14 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 	int32_t reg;
 	int key;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
                 return -1;
 
 	meta->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_META_DREG);
 
-	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST);
+	key_str = nft_mxml_str_parse(tree, "key");
 	if (key_str == NULL)
 		return -1;
 
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 1ebecda..bb4b85b 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -262,7 +262,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	int32_t reg;
 	int family, nat_type_value;
 
-	nat_type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST);
+	nat_type = nft_mxml_str_parse(tree, "type");
 	if (nat_type == NULL)
 		return -1;
 
@@ -273,7 +273,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	nat->type = nat_type_value;
 	e->flags |= (1 << NFT_EXPR_NAT_TYPE);
 
-	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
+	family = nft_mxml_family_parse(tree, "family");
 	if (family < 0) {
 		mxmlDelete(tree);
 		return -1;
@@ -282,28 +282,28 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	nat->family = family;
 	e->flags |= (1 << NFT_EXPR_NAT_FAMILY);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_addr_min", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "sreg_addr_min");
 	if (reg < 0)
 		return -1;
 
 	nat->sreg_addr_min = reg;
 	e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MIN);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_addr_max", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "sreg_addr_max");
 	if (reg < 0)
 		return -1;
 
 	nat->sreg_addr_max = reg;
 	e->flags |= (1 << NFT_EXPR_NAT_REG_ADDR_MAX);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_proto_min", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "sreg_proto_min");
 	if (reg < 0)
 		return -1;
 
 	nat->sreg_proto_min = reg;
 	e->flags |= (1 << NFT_EXPR_NAT_REG_PROTO_MIN);
 
-	reg = nft_mxml_reg_parse(tree, "sreg_proto_max", MXML_DESCEND);
+	reg = nft_mxml_reg_parse(tree, "sreg_proto_max");
 	if (reg < 0)
 		return -1;
 
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 38362c4..35115f8 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -241,14 +241,14 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	const char *base_str;
 	int32_t reg, base;
 
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+	reg = nft_mxml_reg_parse(tree, "dreg");
 	if (reg < 0)
 		return -1;
 
 	payload->dreg = reg;
 	e->flags |= (1 << NFT_EXPR_PAYLOAD_DREG);
 
-	base_str = nft_mxml_str_parse(tree, "base", MXML_DESCEND_FIRST);
+	base_str = nft_mxml_str_parse(tree, "base");
 	if (base_str == NULL)
 		return -1;
 
@@ -259,13 +259,13 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	payload->base = base;
 	e->flags |= (1 << NFT_EXPR_PAYLOAD_BASE);
 
-	if (nft_mxml_num_parse(tree, "offset", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "offset", BASE_DEC,
 			       &payload->offset, NFT_TYPE_U8) != 0)
 		return -1;
 
 	e->flags |= (1 << NFT_EXPR_PAYLOAD_OFFSET);
 
-	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "len", BASE_DEC,
 			       &payload->len, NFT_TYPE_U8) != 0)
 		return -1;
 
diff --git a/src/expr/target.c b/src/expr/target.c
index a6645ff..8eef284 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -196,7 +196,7 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 	struct nft_expr_target *tg = nft_expr_data(e);
 	const char *name;
 
-	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST);
+	name = nft_mxml_str_parse(tree, "name");
 	if (name == NULL)
 		return -1;
 
diff --git a/src/internal.h b/src/internal.h
index 2a36543..e9e737a 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -31,12 +31,12 @@ enum nft_type {
 #ifdef XML_PARSING
 #include <mxml.h>
 struct nft_rule_expr *nft_mxml_expr_parse(mxml_node_t *node);
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags);
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name);
 union nft_data_reg;
 int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, union nft_data_reg *data_reg);
-int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name, uint32_t mxml_flags, int base, void *number, enum nft_type type);
-const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name, uint32_t mxml_flags);
-int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name, uint32_t mxml_flags);
+int nft_mxml_num_parse(mxml_node_t *tree, const char *node_name, int base, void *number, enum nft_type type);
+const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name);
+int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name);
 
 struct nft_set_elem;
 int nft_mxml_set_elem_parse(mxml_node_t *node, struct nft_set_elem *e);
diff --git a/src/mxml.c b/src/mxml.c
index b77936a..4d869f4 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -58,12 +58,13 @@ err:
 	return NULL;
 }
 
-int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name, uint32_t flags)
+int nft_mxml_reg_parse(mxml_node_t *tree, const char *reg_name)
 {
 	mxml_node_t *node;
 	uint64_t val;
 
-	node = mxmlFindElement(tree, tree, reg_name, NULL, NULL, flags);
+	node = mxmlFindElement(tree, tree, reg_name, NULL, NULL,
+			       MXML_DESCEND_FIRST);
 	if (node == NULL) {
 		errno = EINVAL;
 		goto err;
@@ -138,12 +139,12 @@ err:
 
 int
 nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
-		   uint32_t mxml_flags, int base, void *number,
-		   enum nft_type type)
+		   int base, void *number, enum nft_type type)
 {
 	mxml_node_t *node = NULL;
 
-	node = mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flags);
+	node = mxmlFindElement(tree, tree, node_name, NULL, NULL,
+			       MXML_DESCEND_FIRST);
 	if (node == NULL || node->child == NULL) {
 		errno = EINVAL;
 		return -1;
@@ -152,12 +153,12 @@ nft_mxml_num_parse(mxml_node_t *tree, const char *node_name,
 	return nft_strtoi(node->child->value.opaque, base, number, type);
 }
 
-const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name,
-			       uint32_t mxml_flags)
+const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name)
 {
 	mxml_node_t *node;
 
-	node = mxmlFindElement(tree, tree, node_name, NULL, NULL, mxml_flags);
+	node = mxmlFindElement(tree, tree, node_name, NULL, NULL,
+			       MXML_DESCEND_FIRST);
 	if (node == NULL || node->child == NULL) {
 		errno = EINVAL;
 		return NULL;
@@ -166,13 +167,12 @@ const char *nft_mxml_str_parse(mxml_node_t *tree, const char *node_name,
 	return node->child->value.opaque;
 }
 
-int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name,
-			  uint32_t mxml_flags)
+int nft_mxml_family_parse(mxml_node_t *tree, const char *node_name)
 {
 	const char *family_str;
 	int family;
 
-	family_str = nft_mxml_str_parse(tree, node_name, mxml_flags);
+	family_str = nft_mxml_str_parse(tree, node_name);
 	if (family_str == NULL)
 		return -1;
 
diff --git a/src/rule.c b/src/rule.c
index 2344dd6..279094c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -583,14 +583,14 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 	if (strcmp(tree->value.opaque, "rule") != 0)
 		goto err;
 
-	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
+	family = nft_mxml_family_parse(tree, "family");
 	if (family < 0)
 		goto err;
 
 	r->family = family;
 	r->flags |= (1 << NFT_RULE_ATTR_FAMILY);
 
-	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST);
+	table = nft_mxml_str_parse(tree, "table");
 	if (table == NULL)
 		goto err;
 
@@ -600,7 +600,7 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 	r->table = strdup(table);
 	r->flags |= (1 << NFT_RULE_ATTR_TABLE);
 
-	chain = nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST);
+	chain = nft_mxml_str_parse(tree, "chain");
 	if (chain == NULL)
 		goto err;
 
@@ -610,14 +610,14 @@ static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 	r->chain = strdup(chain);
 	r->flags |= (1 << NFT_RULE_ATTR_CHAIN);
 
-	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "handle", BASE_DEC,
 			       &r->handle, NFT_TYPE_U64) != 0)
 		goto err;
 
 	r->flags |= (1 << NFT_RULE_ATTR_HANDLE);
 
-	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
-			       BASE_DEC, &r->rule_flags, NFT_TYPE_U32) != 0)
+	if (nft_mxml_num_parse(tree, "flags", BASE_DEC,
+			       &r->rule_flags, NFT_TYPE_U32) != 0)
 		goto err;
 
 	r->flags |= (1 << NFT_RULE_ATTR_FLAGS);
diff --git a/src/set.c b/src/set.c
index fe30e77..b65b8b9 100644
--- a/src/set.c
+++ b/src/set.c
@@ -417,7 +417,7 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 	if (strcmp(tree->value.opaque, "set") != 0)
 		goto err;
 
-	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST);
+	name = nft_mxml_str_parse(tree, "name");
 	if (name == NULL)
 		goto err;
 
@@ -427,7 +427,7 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 	s->name = strdup(name);
 	s->flags |= (1 << NFT_SET_ATTR_NAME);
 
-	table = nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST);
+	table = nft_mxml_str_parse(tree, "table");
 	if (table == NULL)
 		goto err;
 
@@ -437,7 +437,7 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 	s->table = strdup(table);
 	s->flags |= (1 << NFT_SET_ATTR_TABLE);
 
-	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
+	family = nft_mxml_family_parse(tree, "family");
 	if (family < 0)
 		goto err;
 
@@ -445,32 +445,32 @@ static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 
 	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
 
-	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
-			       BASE_DEC, &s->set_flags, NFT_TYPE_U32) != 0)
+	if (nft_mxml_num_parse(tree, "flags", BASE_DEC,
+			       &s->set_flags, NFT_TYPE_U32) != 0)
 		goto err;
 
 	s->flags |= (1 << NFT_SET_ATTR_FLAGS);
 
-	if (nft_mxml_num_parse(tree, "key_type", MXML_DESCEND_FIRST,
-			       BASE_DEC, &s->key_type, NFT_TYPE_U32) != 0)
+	if (nft_mxml_num_parse(tree, "key_type", BASE_DEC,
+			       &s->key_type, NFT_TYPE_U32) != 0)
 		goto err;
 
 	s->flags |= (1 << NFT_SET_ATTR_KEY_TYPE);
 
-	if (nft_mxml_num_parse(tree, "key_len", MXML_DESCEND_FIRST,
-			       BASE_DEC, &s->key_len, NFT_TYPE_U32) != 0)
+	if (nft_mxml_num_parse(tree, "key_len", BASE_DEC,
+			       &s->key_len, NFT_TYPE_U32) != 0)
 		goto err;
 
 	s->flags |= (1 << NFT_SET_ATTR_KEY_LEN);
 
-	if (nft_mxml_num_parse(tree, "data_type", MXML_DESCEND_FIRST,
-			       BASE_DEC, &s->data_type, NFT_TYPE_U32) != 0)
+	if (nft_mxml_num_parse(tree, "data_type", BASE_DEC,
+			       &s->data_type, NFT_TYPE_U32) != 0)
 		goto err;
 
 	s->flags |= (1 << NFT_SET_ATTR_DATA_TYPE);
 
-	if (nft_mxml_num_parse(tree, "data_len", MXML_DESCEND_FIRST,
-			       BASE_DEC, &s->data_len, NFT_TYPE_U32) != 0)
+	if (nft_mxml_num_parse(tree, "data_len", BASE_DEC,
+			       &s->data_len, NFT_TYPE_U32) != 0)
 		goto err;
 
 	s->flags |= (1 << NFT_SET_ATTR_DATA_LEN);
diff --git a/src/set_elem.c b/src/set_elem.c
index 2b2e414..b19e434 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -381,8 +381,7 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e)
 	mxml_node_t *node;
 	int set_elem_data;
 
-	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST,
-			       BASE_DEC, &e->set_elem_flags,
+	if (nft_mxml_num_parse(tree, "flags", BASE_DEC, &e->set_elem_flags,
 			       NFT_TYPE_U32) != 0)
 		return -1;
 
diff --git a/src/table.c b/src/table.c
index 8d20be5..8a34986 100644
--- a/src/table.c
+++ b/src/table.c
@@ -232,7 +232,7 @@ static int nft_table_xml_parse(struct nft_table *t, const char *xml)
 	if (strcmp(tree->value.opaque, "table") != 0)
 		goto err;
 
-	name = nft_mxml_str_parse(tree, "name", MXML_DESCEND_FIRST);
+	name = nft_mxml_str_parse(tree, "name");
 	if (name == NULL)
 		goto err;
 
@@ -242,14 +242,14 @@ static int nft_table_xml_parse(struct nft_table *t, const char *xml)
 	t->name = strdup(name);
 	t->flags |= (1 << NFT_TABLE_ATTR_NAME);
 
-	family = nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
+	family = nft_mxml_family_parse(tree, "family");
 	if (family < 0)
 		goto err;
 
 	t->family = family;
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
 
-	if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND, BASE_DEC,
+	if (nft_mxml_num_parse(tree, "flags", BASE_DEC,
 			       &t->table_flags, NFT_TYPE_U32) != 0)
 		goto err;
 

