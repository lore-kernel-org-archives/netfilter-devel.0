From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/3] expr: data_reg: use 'reg' instead of 'data_reg'
Date: Mon, 10 Nov 2014 14:26:19 +0100
Message-ID: <1415625979-29079-3-git-send-email-pablo@netfilter.org>
References: <1415625979-29079-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53261 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaKJNYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:24:39 -0500
In-Reply-To: <1415625979-29079-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

data_reg is unnecessarily long name and it always has to be
wrapped by another data node. This will allow us to represent
data not only as registers if needed.

Get rid of 'cmpdata' and 'immediatedata' too and use 'data'
instead to wrap 'reg' so these are consistent with the bitwise
expression. No reason for such specific tag per expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/cmp.c                           |    4 ++--
 src/expr/data_reg.c                      |   27 ++++++++-------------------
 src/expr/immediate.c                     |    4 ++--
 src/jansson.c                            |    4 ++--
 tests/jsonfiles/14-chain.json            |    2 +-
 tests/jsonfiles/20-rule-bitwise.json     |    2 +-
 tests/jsonfiles/22-rule-cmp.json         |    2 +-
 tests/jsonfiles/24-rule-ct.json          |    2 +-
 tests/jsonfiles/26-rule-immediate.json   |    2 +-
 tests/jsonfiles/31-rule-meta.json        |    2 +-
 tests/jsonfiles/34-rule-payload.json     |    2 +-
 tests/jsonfiles/36-rule-real.json        |    2 +-
 tests/jsonfiles/37-rule-real.json        |    2 +-
 tests/jsonfiles/38-rule-real.json        |    2 +-
 tests/jsonfiles/39-rule-real.json        |    2 +-
 tests/jsonfiles/40-rule-real.json        |    2 +-
 tests/jsonfiles/41-rule-real.json        |    2 +-
 tests/jsonfiles/42-rule-real.json        |    2 +-
 tests/jsonfiles/43-rule-real.json        |    2 +-
 tests/jsonfiles/44-rule-real.json        |    2 +-
 tests/jsonfiles/45-rule-real.json        |    2 +-
 tests/jsonfiles/46-rule-real.json        |    2 +-
 tests/jsonfiles/47-rule-real.json        |    2 +-
 tests/jsonfiles/48-rule-real.json        |    2 +-
 tests/jsonfiles/49-rule-real.json        |    2 +-
 tests/jsonfiles/50-rule-real.json        |    2 +-
 tests/jsonfiles/51-rule-real.json        |    2 +-
 tests/jsonfiles/52-rule-real.json        |    2 +-
 tests/jsonfiles/53-rule-real.json        |    2 +-
 tests/jsonfiles/54-rule-real.json        |    2 +-
 tests/jsonfiles/55-rule-real.json        |    2 +-
 tests/jsonfiles/56-rule-real.json        |    2 +-
 tests/jsonfiles/57-rule-real.json        |    2 +-
 tests/jsonfiles/58-rule-real.json        |    2 +-
 tests/jsonfiles/59-rule-real.json        |    2 +-
 tests/jsonfiles/60-rule-real.json        |    2 +-
 tests/jsonfiles/61-rule-real.json        |    2 +-
 tests/jsonfiles/62-set.json              |    2 +-
 tests/jsonfiles/63-set.json              |    2 +-
 tests/jsonfiles/64-ruleset.json          |    2 +-
 tests/jsonfiles/65-rule-meta-target.json |    2 +-
 tests/xmlfiles/20-rule-bitwise.xml       |    2 +-
 tests/xmlfiles/22-rule-cmp.xml           |    2 +-
 tests/xmlfiles/26-rule-immediate.xml     |    2 +-
 tests/xmlfiles/36-rule-real.xml          |    2 +-
 tests/xmlfiles/37-rule-real.xml          |    2 +-
 tests/xmlfiles/38-rule-real.xml          |    2 +-
 tests/xmlfiles/39-rule-real.xml          |    2 +-
 tests/xmlfiles/40-rule-real.xml          |    2 +-
 tests/xmlfiles/41-rule-real.xml          |    2 +-
 tests/xmlfiles/42-rule-real.xml          |    2 +-
 tests/xmlfiles/43-rule-real.xml          |    2 +-
 tests/xmlfiles/44-rule-real.xml          |    2 +-
 tests/xmlfiles/45-rule-real.xml          |    2 +-
 tests/xmlfiles/46-rule-real.xml          |    2 +-
 tests/xmlfiles/47-rule-real.xml          |    2 +-
 tests/xmlfiles/48-rule-real.xml          |    2 +-
 tests/xmlfiles/49-rule-real.xml          |    2 +-
 tests/xmlfiles/50-rule-real.xml          |    2 +-
 tests/xmlfiles/51-rule-real.xml          |    2 +-
 tests/xmlfiles/52-rule-real.xml          |    2 +-
 tests/xmlfiles/53-rule-real.xml          |    2 +-
 tests/xmlfiles/54-rule-real.xml          |    2 +-
 tests/xmlfiles/55-rule-real.xml          |    2 +-
 tests/xmlfiles/56-rule-real.xml          |    2 +-
 tests/xmlfiles/57-rule-real.xml          |    2 +-
 tests/xmlfiles/58-rule-real.xml          |    2 +-
 tests/xmlfiles/59-rule-real.xml          |    2 +-
 tests/xmlfiles/60-rule-real.xml          |    2 +-
 tests/xmlfiles/61-rule-real.xml          |    2 +-
 tests/xmlfiles/62-rule-real.xml          |    2 +-
 tests/xmlfiles/63-rule-real.xml          |    2 +-
 tests/xmlfiles/64-rule-real.xml          |    2 +-
 tests/xmlfiles/65-rule-real.xml          |    2 +-
 tests/xmlfiles/66-rule-real.xml          |    2 +-
 tests/xmlfiles/67-rule-real.xml          |    2 +-
 tests/xmlfiles/68-rule-real.xml          |    2 +-
 tests/xmlfiles/70-rule-real.xml          |    2 +-
 tests/xmlfiles/71-rule-real.xml          |    2 +-
 tests/xmlfiles/73-set.xml                |    2 +-
 tests/xmlfiles/74-set.xml                |    2 +-
 tests/xmlfiles/75-ruleset.xml            |    2 +-
 82 files changed, 92 insertions(+), 103 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index b186df0..3ca4b08 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -201,7 +201,7 @@ static int nft_rule_expr_cmp_json_parse(struct nft_rule_expr *e, json_t *root,
 		nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, base);
 	}
 
-	if (nft_jansson_data_reg_parse(root, "cmpdata",
+	if (nft_jansson_data_reg_parse(root, "data",
 				       &cmp->data, err) == DATA_VALUE)
 		e->flags |= (1 << NFT_EXPR_CMP_DATA);
 
@@ -235,7 +235,7 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 		nft_rule_expr_set_u32(e, NFT_EXPR_CMP_OP, op_value);
 	}
 
-	if (nft_mxml_data_reg_parse(tree, "cmpdata",
+	if (nft_mxml_data_reg_parse(tree, "data",
 				    &cmp->data, NFT_XML_MAND,
 				    err) == DATA_VALUE)
 		e->flags |= (1 << NFT_EXPR_CMP_DATA);
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 28ad164..33b3346 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -145,21 +145,10 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg,
 	int i;
 	char node_name[6];
 
-	/*
-	* <data_reg type="value">
-	*    <len>16</len>
-	*    <data0>0xc09a002a</data0>
-	*    <data1>0x2700cac1</data1>
-	*    <data2>0x00000000</data2>
-	*    <data3>0x08000000</data3>
-	* </data_reg>
-	*/
-
 	if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_DEC,
 			       &reg->len, NFT_TYPE_U8, NFT_XML_MAND, err) != 0)
 		return DATA_NONE;
 
-	/* Get and set <dataN> */
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
 		sprintf(node_name, "data%d", i);
 
@@ -180,7 +169,7 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
 	const char *type;
 	mxml_node_t *node;
 
-	node = mxmlFindElement(tree, tree, "data_reg", "type", NULL,
+	node = mxmlFindElement(tree, tree, "reg", "type", NULL,
 			       MXML_DESCEND_FIRST);
 	if (node == NULL)
 		goto err;
@@ -198,7 +187,7 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
 	return DATA_NONE;
 err:
 	errno = EINVAL;
-	err->node_name = "data_reg";
+	err->node_name = "reg";
 	err->error = NFT_PARSE_EMISSINGNODE;
 	return DATA_NONE;
 #else
@@ -216,7 +205,7 @@ nft_data_reg_value_snprintf_json(char *buf, size_t size,
 	uint32_t utemp;
 	uint8_t *tmp;
 
-	ret = snprintf(buf, len, "\"data_reg\":{\"type\":\"value\",");
+	ret = snprintf(buf, len, "\"reg\":{\"type\":\"value\",");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "\"len\":%u,", reg->len);
@@ -252,7 +241,7 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 	uint32_t be;
 	uint8_t *tmp;
 
-	ret = snprintf(buf, len, "<data_reg type=\"value\">");
+	ret = snprintf(buf, len, "<reg type=\"value\">");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<len>%u</len>", reg->len);
@@ -274,7 +263,7 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "</data_reg>");
+	ret = snprintf(buf+offset, len, "</reg>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -317,7 +306,7 @@ nft_data_reg_verdict_snprintf_xml(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret = 0;
 
-	ret = snprintf(buf, size, "<data_reg type=\"verdict\">"
+	ret = snprintf(buf, size, "<reg type=\"verdict\">"
 		       "<verdict>%s</verdict>", nft_verdict2str(reg->verdict));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -327,7 +316,7 @@ nft_data_reg_verdict_snprintf_xml(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, len, "</data_reg>");
+	ret = snprintf(buf+offset, len, "</reg>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -339,7 +328,7 @@ nft_data_reg_verdict_snprintf_json(char *buf, size_t size,
 {
 	int len = size, offset = 0, ret = 0;
 
-	ret = snprintf(buf, size, "\"data_reg\":{\"type\":\"verdict\","
+	ret = snprintf(buf, size, "\"reg\":{\"type\":\"verdict\","
 		       "\"verdict\":\"%s\"", nft_verdict2str(reg->verdict));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index be70445..3d4e48c 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -186,7 +186,7 @@ nft_rule_expr_immediate_json_parse(struct nft_rule_expr *e, json_t *root,
 	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
 
-	datareg_type = nft_jansson_data_reg_parse(root, "immediatedata",
+	datareg_type = nft_jansson_data_reg_parse(root, "data",
 						  &imm->data, err);
 	if (datareg_type >= 0) {
 		switch (datareg_type) {
@@ -223,7 +223,7 @@ nft_rule_expr_immediate_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 			       NFT_XML_MAND, err) == 0)
 		nft_rule_expr_set_u32(e, NFT_EXPR_IMM_DREG, reg);
 
-	datareg_type = nft_mxml_data_reg_parse(tree, "immediatedata",
+	datareg_type = nft_mxml_data_reg_parse(tree, "data",
 					       &imm->data, NFT_XML_MAND, err);
 	if (datareg_type >= 0) {
 		switch (datareg_type) {
diff --git a/src/jansson.c b/src/jansson.c
index 4c7968a..b17d8a9 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -227,10 +227,10 @@ int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 	if (data == NULL)
 		data = root;
 
-	data = json_object_get(data, "data_reg");
+	data = json_object_get(data, "reg");
 	if (data == NULL) {
 		err->error = NFT_PARSE_EMISSINGNODE;
-		err->node_name = "data_reg";
+		err->node_name = "reg";
 		errno = EINVAL;
 		return -1;
 	}
diff --git a/tests/jsonfiles/14-chain.json b/tests/jsonfiles/14-chain.json
index d98dc94..6642615 100644
--- a/tests/jsonfiles/14-chain.json
+++ b/tests/jsonfiles/14-chain.json
@@ -1 +1 @@
-{"nftables":[{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}}]}
+{"nftables":[{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0}}]}
diff --git a/tests/jsonfiles/20-rule-bitwise.json b/tests/jsonfiles/20-rule-bitwise.json
index de3d9ec..af53851 100644
--- a/tests/jsonfiles/20-rule-bitwise.json
+++ b/tests/jsonfiles/20-rule-bitwise.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"data_reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":20,"expr":[{"type":"bitwise","sreg":1,"dreg":1,"len":4,"mask":{"reg":{"type":"value","len":4,"data0":"0x0000000a"}},"xor":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}}]}}]}
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule-cmp.json
index 8269b00..2a6565a 100644
--- a/tests/jsonfiles/22-rule-cmp.json
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}]}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-ct.json
index 40cfe9b..091d885 100644
--- a/tests/jsonfiles/24-rule-ct.json
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000008"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}]}
diff --git a/tests/jsonfiles/26-rule-immediate.json b/tests/jsonfiles/26-rule-immediate.json
index d416928..767052e 100644
--- a/tests/jsonfiles/26-rule-immediate.json
+++ b/tests/jsonfiles/26-rule-immediate.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"accept"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rule-meta.json
index 971a034..d39a6ed 100644
--- a/tests/jsonfiles/31-rule-meta.json
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-rule-payload.json
index 5cb566d..eec5dc9 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"accept"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rule-real.json
index 2910a67..56d6794 100644
--- a/tests/jsonfiles/36-rule-real.json
+++ b/tests/jsonfiles/36-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rule-real.json
index 0dc73fc..6eb8c7d 100644
--- a/tests/jsonfiles/37-rule-real.json
+++ b/tests/jsonfiles/37-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rule-real.json
index ffdf054..e0da26f 100644
--- a/tests/jsonfiles/38-rule-real.json
+++ b/tests/jsonfiles/38-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rule-real.json
index c555b02..b80bf42 100644
--- a/tests/jsonfiles/39-rule-real.json
+++ b/tests/jsonfiles/39-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"cmp","sreg":1,"op":"lte","data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","data":{"reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}]}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rule-real.json
index 0068325..38a8497 100644
--- a/tests/jsonfiles/40-rule-real.json
+++ b/tests/jsonfiles/40-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rule-real.json
index 8e15a45..58bc9c0 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"drop"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rule-real.json
index 4d21547..025d351 100644
--- a/tests/jsonfiles/42-rule-real.json
+++ b/tests/jsonfiles/42-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rule-real.json
index dcde606..ff4fedb 100644
--- a/tests/jsonfiles/43-rule-real.json
+++ b/tests/jsonfiles/43-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rule-real.json
index 79bc711..14c6e34 100644
--- a/tests/jsonfiles/44-rule-real.json
+++ b/tests/jsonfiles/44-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x16000004"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rule-real.json
index e6732fb..81841a7 100644
--- a/tests/jsonfiles/45-rule-real.json
+++ b/tests/jsonfiles/45-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rule-real.json
index 7f97a55..3cfb290 100644
--- a/tests/jsonfiles/46-rule-real.json
+++ b/tests/jsonfiles/46-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rule-real.json
index 556d2e0..e4160dd 100644
--- a/tests/jsonfiles/47-rule-real.json
+++ b/tests/jsonfiles/47-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rule-real.json
index 6a0b288..95e2b38 100644
--- a/tests/jsonfiles/48-rule-real.json
+++ b/tests/jsonfiles/48-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rule-real.json
index 53cca09..da0c0c5 100644
--- a/tests/jsonfiles/49-rule-real.json
+++ b/tests/jsonfiles/49-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000000"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rule-real.json
index 3979d2a..4dbc553 100644
--- a/tests/jsonfiles/50-rule-real.json
+++ b/tests/jsonfiles/50-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000001"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rule-real.json
index 1afbf82..7d510ab 100644
--- a/tests/jsonfiles/51-rule-real.json
+++ b/tests/jsonfiles/51-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rule-real.json
index 911ddd3..2809478 100644
--- a/tests/jsonfiles/52-rule-real.json
+++ b/tests/jsonfiles/52-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000001"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rule-real.json
index 6d49b19..329945c 100644
--- a/tests/jsonfiles/53-rule-real.json
+++ b/tests/jsonfiles/53-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rule-real.json
index 668bf75..b9b2383 100644
--- a/tests/jsonfiles/54-rule-real.json
+++ b/tests/jsonfiles/54-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rule-real.json
index 5338611..e79552d 100644
--- a/tests/jsonfiles/55-rule-real.json
+++ b/tests/jsonfiles/55-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rule-real.json
index ff5d4ee..a2c4b9c 100644
--- a/tests/jsonfiles/56-rule-real.json
+++ b/tests/jsonfiles/56-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000000"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rule-real.json
index f578573..b233f59 100644
--- a/tests/jsonfiles/57-rule-real.json
+++ b/tests/jsonfiles/57-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rule-real.json
index a5e7ec5..f98efd3 100644
--- a/tests/jsonfiles/58-rule-real.json
+++ b/tests/jsonfiles/58-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00000008"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rule-real.json
index 46a470b..0f92ade 100644
--- a/tests/jsonfiles/59-rule-real.json
+++ b/tests/jsonfiles/59-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000000"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rule-real.json
index 1efef1f..0a98726 100644
--- a/tests/jsonfiles/60-rule-real.json
+++ b/tests/jsonfiles/60-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000001"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rule-real.json
index 1f15c84..8b57338 100644
--- a/tests/jsonfiles/61-rule-real.json
+++ b/tests/jsonfiles/61-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/62-set.json b/tests/jsonfiles/62-set.json
index 8a8d99c..58db88b 100644
--- a/tests/jsonfiles/62-set.json
+++ b/tests/jsonfiles/62-set.json
@@ -1 +1 @@
-{"nftables":[{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type":12,"key_len":2,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}]}
+{"nftables":[{"set":{"name":"set0","table":"filter","flags":3,"family":"ip","key_type":12,"key_len":2,"set_elem":[{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001700"}}},{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}}]}}]}
diff --git a/tests/jsonfiles/63-set.json b/tests/jsonfiles/63-set.json
index 62ccd2f..d63c1cf 100644
--- a/tests/jsonfiles/63-set.json
+++ b/tests/jsonfiles/63-set.json
@@ -1 +1 @@
-{"nftables":[{"set":{"name":"map0","table":"f","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"data_reg":{"type":"verdict","verdict":"goto","chain":"o"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"set":{"name":"map0","table":"f","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"reg":{"type":"verdict","verdict":"goto","chain":"o"}}},{"flags":0,"key":{"reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-ruleset.json
index 5755cff..9b6e611 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1 +1 @@
-{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"drop"}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"counter","pkts":0,"bytes":0}
 ]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data_reg":{"type":"verdict","verdict":"drop"}}]}}]}
+{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"table":"filter","family":"ip","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"table":"filter","family":"ip","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pk
 ts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"data":{"reg":{"type":"verdict","verdict":"drop"}}}]}}]}
diff --git a/tests/jsonfiles/65-rule-meta-target.json b/tests/jsonfiles/65-rule-meta-target.json
index bf1bcaa..e6180d6 100644
--- a/tests/jsonfiles/65-rule-meta-target.json
+++ b/tests/jsonfiles/65-rule-meta-target.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"mark","sreg":1},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"mark","sreg":1},{"type":"cmp","sreg":1,"op":"eq","data":{"reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index 756b22c..9b38437 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr></rule></nftables>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index a0371a3..4e66993 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index 0079504..3eed652 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>input</chain><handle>32</handle><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index 89a37f6..6ebc8ea 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index 7896bbb..8506f19 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></expr><expr type="ct"><dreg>1</
 dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type="ct">
 <dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group></expr></rule></nftables>
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index 612383f..51b1130 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verd
 ict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x0000bb01</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg typ
 e="verdict"><verdict>accept</verdict></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index 7b67a10..35b6004 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><d
 ata1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_d
 rop</prefix><group>2</group></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>drop</verdict></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></reg></data></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0xc09a002a</d
 ata0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00003500</data0></reg></data></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="
 log"><prefix>dns_drop</prefix><group>2</group></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index 33fb75f..d516164 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index 0f7b752..3736404 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><data><reg type="value"><len>4</len><data0>0xfa00a8c0</data0></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index e76c6aa..e88d695 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index 907bfa5..4f6219f 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>drop</verdict></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>drop</verdict></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index a9bc8d9..4f12c01 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"></expr></rule></nftables>
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index fa2afac..fd2fda2 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00001600</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index a5155bc..58ebedc 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x16000004</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index 798f4f3..44f2a68 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 509a299..7f8562f 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index bc1a6ad..ce73edc 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></reg></data></expr></rule></nftables>
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index 5b100e6..0df5270 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><reg type="value"><len>4</len><data0>0x0000000a</data0></reg></mask><xor><reg type="value"><len>4</len><data0>0x00000000</data0></reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 555dddd..f00ee71 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index f86ad01..0205214 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index d257fa6..cfdac8f 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index 55280d6..7451d5f 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000064</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index e3333a1..c35eef0 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index 90d91f1..3f30f5e 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x0000001e</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 61d662f..1c5f4c0 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00707466</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index 5a7f5d7..14787f6 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index a596479..92ad83f 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>2</len><data0>0x00000008</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 7c8437f..70234a6 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index 2ed9517..786e84a 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index 1bcf040..86d3499 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index 153cd8f..af0b87d 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000001</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index 85f2cfc..f14c95c 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index 74a1ae3..b3d37b1 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index db93413..95ea4cd 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x000003e8</data0></reg></data></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index 9fa0bd2..197be85 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>4</len><data0>0x00000000</data0></reg></data></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index 07f6066..a09698d 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index 3b882b0..d35a252 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index dffa2a6..c838a60 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 1af61fa..856e1f9 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1 +1 @@
-<nftables><set><family>ip</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set></nftables>
+<nftables><set><family>ip</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>4</len><data0>0x0300a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0200a8c0</data0></reg></key></set_elem><set_elem><key><reg type="value"><len>4</len><data0>0x0100a8c0</data0></reg></key></set_elem></set></nftables>
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index a8cabaf..c5be4e5 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1 +1 @@
-<nftables><set><family>ip6</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set></nftables>
+<nftables><set><family>ip6</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></reg></key></set_elem><set_elem><key><reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></reg></key></set_elem></set></nftables>
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
index 0eb4075..363a567 100644
--- a/tests/xmlfiles/75-ruleset.xml
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><data_reg type="value"><len>2</len><data0>0x00004300</data
 0></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><expr type="counter"><pkts>0</pkts><byt
 es>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sr
 eg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00004300</data0></r
 eg></key></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00003500</data0></reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><key><reg type="value"><len>2</len><data0>0x00005000</data0></reg></key><data><reg type="verdict"><verdict>drop</verdict></reg></data></set_elem><set_elem><key><reg type="value"><len>2</len><data0>0x00001600</data0></reg></key><data><reg type="verdict"><verdict>accept</verdict></reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><dat
 a><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</len><data0>0x00000006</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data><reg type="value"><len>1</
 len><data0>0x00000011</data0></reg></data></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data><reg type="verdict"><verdict>accept</verdict></reg></data></expr></rule></nftables>
-- 
1.7.10.4

