From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] xml: json: Delete a cmpdata label in xml and json file.
Date: Wed,  9 Apr 2014 11:16:19 +0200
Message-ID: <95c4de9cafead42b919ac07cca8d4f776ec3751b.1397033299.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63050 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481AbaDIJQi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:16:38 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so2117547wes.5
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 02:16:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It delete the cmpdata label in the structure of json and xml file.

Example of xmlfile:

The old structure of xml file:
[...]
<expr type="cmp">
	<sreg>1</sreg>
	<op>eq</op>
	<cmpdata>
		<data_reg type="value">
			<len>4</len>
			<data0>0x0100a8c0</data0>
		</data_reg>
	</cmpdata>
</expr>

The new structure of json file:
[...]
<expr type="cmp">
	<sreg>1</sreg>
	<op>eq</op>
	<data_reg type="value">
		<len>4</len>
		<data0>0x0100a8c0</data0>
	</data_reg>
</expr>
[...]

To generate the new testfiles, It use the option -u of nft-parsing-test
script.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/expr/cmp.c                           | 10 ++--------
 src/jansson.c                            |  9 +++------
 src/mxml.c                               | 11 +++--------
 tests/jsonfiles/22-rule-cmp.json         |  2 +-
 tests/jsonfiles/24-rule-ct.json          |  2 +-
 tests/jsonfiles/31-rule-meta.json        |  2 +-
 tests/jsonfiles/34-rule-payload.json     |  2 +-
 tests/jsonfiles/36-rule-real.json        |  2 +-
 tests/jsonfiles/37-rule-real.json        |  2 +-
 tests/jsonfiles/38-rule-real.json        |  2 +-
 tests/jsonfiles/39-rule-real.json        |  2 +-
 tests/jsonfiles/40-rule-real.json        |  2 +-
 tests/jsonfiles/41-rule-real.json        |  2 +-
 tests/jsonfiles/42-rule-real.json        |  2 +-
 tests/jsonfiles/43-rule-real.json        |  2 +-
 tests/jsonfiles/44-rule-real.json        |  2 +-
 tests/jsonfiles/45-rule-real.json        |  2 +-
 tests/jsonfiles/46-rule-real.json        |  2 +-
 tests/jsonfiles/47-rule-real.json        |  2 +-
 tests/jsonfiles/48-rule-real.json        |  2 +-
 tests/jsonfiles/49-rule-real.json        |  2 +-
 tests/jsonfiles/50-rule-real.json        |  2 +-
 tests/jsonfiles/51-rule-real.json        |  2 +-
 tests/jsonfiles/52-rule-real.json        |  2 +-
 tests/jsonfiles/53-rule-real.json        |  2 +-
 tests/jsonfiles/54-rule-real.json        |  2 +-
 tests/jsonfiles/55-rule-real.json        |  2 +-
 tests/jsonfiles/56-rule-real.json        |  2 +-
 tests/jsonfiles/57-rule-real.json        |  2 +-
 tests/jsonfiles/58-rule-real.json        |  2 +-
 tests/jsonfiles/59-rule-real.json        |  2 +-
 tests/jsonfiles/60-rule-real.json        |  2 +-
 tests/jsonfiles/61-rule-real.json        |  2 +-
 tests/jsonfiles/64-ruleset.json          |  2 +-
 tests/jsonfiles/65-rule-meta-target.json |  2 +-
 tests/xmlfiles/22-rule-cmp.xml           |  2 +-
 tests/xmlfiles/36-rule-real.xml          |  2 +-
 tests/xmlfiles/37-rule-real.xml          |  2 +-
 tests/xmlfiles/38-rule-real.xml          |  2 +-
 tests/xmlfiles/39-rule-real.xml          |  2 +-
 tests/xmlfiles/40-rule-real.xml          |  2 +-
 tests/xmlfiles/41-rule-real.xml          |  2 +-
 tests/xmlfiles/42-rule-real.xml          |  2 +-
 tests/xmlfiles/43-rule-real.xml          |  2 +-
 tests/xmlfiles/44-rule-real.xml          |  2 +-
 tests/xmlfiles/45-rule-real.xml          |  2 +-
 tests/xmlfiles/46-rule-real.xml          |  2 +-
 tests/xmlfiles/47-rule-real.xml          |  2 +-
 tests/xmlfiles/48-rule-real.xml          |  2 +-
 tests/xmlfiles/49-rule-real.xml          |  2 +-
 tests/xmlfiles/50-rule-real.xml          |  2 +-
 tests/xmlfiles/51-rule-real.xml          |  2 +-
 tests/xmlfiles/52-rule-real.xml          |  2 +-
 tests/xmlfiles/53-rule-real.xml          |  2 +-
 tests/xmlfiles/54-rule-real.xml          |  2 +-
 tests/xmlfiles/55-rule-real.xml          |  2 +-
 tests/xmlfiles/56-rule-real.xml          |  2 +-
 tests/xmlfiles/57-rule-real.xml          |  2 +-
 tests/xmlfiles/58-rule-real.xml          |  2 +-
 tests/xmlfiles/59-rule-real.xml          |  2 +-
 tests/xmlfiles/60-rule-real.xml          |  2 +-
 tests/xmlfiles/61-rule-real.xml          |  2 +-
 tests/xmlfiles/62-rule-real.xml          |  2 +-
 tests/xmlfiles/63-rule-real.xml          |  2 +-
 tests/xmlfiles/64-rule-real.xml          |  2 +-
 tests/xmlfiles/65-rule-real.xml          |  2 +-
 tests/xmlfiles/66-rule-real.xml          |  2 +-
 tests/xmlfiles/67-rule-real.xml          |  2 +-
 tests/xmlfiles/68-rule-real.xml          |  2 +-
 tests/xmlfiles/70-rule-real.xml          |  2 +-
 tests/xmlfiles/71-rule-real.xml          |  2 +-
 tests/xmlfiles/75-ruleset.xml            |  2 +-
 72 files changed, 77 insertions(+), 91 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 63250f3..2c334ab 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -258,7 +258,7 @@ nft_rule_expr_cmp_snprintf_json(char *buf, size_t size, struct nft_expr_cmp *cmp
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "\"sreg\":%u,\"op\":\"%s\",\"cmpdata\":{",
+	ret = snprintf(buf, len, "\"sreg\":%u,\"op\":\"%s\",",
 		       cmp->sreg, expr_cmp_str[cmp->op]);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -266,9 +266,6 @@ nft_rule_expr_cmp_snprintf_json(char *buf, size_t size, struct nft_expr_cmp *cmp
 				    NFT_OUTPUT_JSON, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "}");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	return offset;
 }
 
@@ -277,7 +274,7 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
 {
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "<sreg>%u</sreg><op>%s</op><cmpdata>",
+	ret = snprintf(buf, len, "<sreg>%u</sreg><op>%s</op>",
 		       cmp->sreg, expr_cmp_str[cmp->op]);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
@@ -285,9 +282,6 @@ nft_rule_expr_cmp_snprintf_xml(char *buf, size_t size, struct nft_expr_cmp *cmp)
 				    NFT_OUTPUT_XML, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "</cmpdata>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	return offset;
 }
 
diff --git a/src/jansson.c b/src/jansson.c
index 5107eb5..affe8fe 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -215,13 +215,10 @@ int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 	json_t *data;
 	int ret;
 
+	 /* It is necessary for the compatibility with cmpdata label. */
 	data = json_object_get(root, node_name);
-	if (data == NULL) {
-		err->error = NFT_PARSE_EMISSINGNODE;
-		err->node_name = node_name;
-		errno = EINVAL;
-		return -1;
-	}
+	if (data == NULL)
+		data = root;
 
 	data = json_object_get(data, "data_reg");
 	if (data == NULL) {
diff --git a/src/mxml.c b/src/mxml.c
index b2cb95e..5e4f022 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -140,15 +140,10 @@ int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name,
 
 	node = mxmlFindElement(tree, tree, node_name, NULL, NULL,
 			       MXML_DESCEND_FIRST);
-	if (node == NULL || node->child == NULL) {
-		if (!(flags & NFT_XML_OPT)) {
-			err->error = NFT_PARSE_EMISSINGNODE;
-			err->node_name = node_name;
-			errno = EINVAL;
-		}
 
-		return DATA_NONE;
-	}
+	/* It is necessary for the compatibility with cmpdata label. */
+	if (node == NULL || node->child == NULL)
+		node = tree;
 
 	return nft_data_reg_xml_parse(data_reg, node, err);
 }
diff --git a/tests/jsonfiles/22-rule-cmp.json b/tests/jsonfiles/22-rule-cmp.json
index c32d7ad..8269b00 100644
--- a/tests/jsonfiles/22-rule-cmp.json
+++ b/tests/jsonfiles/22-rule-cmp.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"forward","handle":22,"expr":[{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x6e6f6200","data2":"0x2e303164","data3":"0x00393331"}}]}}]}
diff --git a/tests/jsonfiles/24-rule-ct.json b/tests/jsonfiles/24-rule-ct.json
index 1aa3dd2..40cfe9b 100644
--- a/tests/jsonfiles/24-rule-ct.json
+++ b/tests/jsonfiles/24-rule-ct.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000008"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":24,"expr":[{"type":"ct","dreg":1,"key":"state"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000008"}}]}}]}
diff --git a/tests/jsonfiles/31-rule-meta.json b/tests/jsonfiles/31-rule-meta.json
index 96e02e5..971a034 100644
--- a/tests/jsonfiles/31-rule-meta.json
+++ b/tests/jsonfiles/31-rule-meta.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":8,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/34-rule-payload.json b/tests/jsonfiles/34-rule-payload.json
index 7eaff41..b9e9336 100644
--- a/tests/jsonfiles/34-rule-payload.json
+++ b/tests/jsonfiles/34-rule-payload.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"input","handle":26,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"network"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"transport"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/jsonfiles/36-rule-real.json b/tests/jsonfiles/36-rule-real.json
index 4c5e331..2910a67 100644
--- a/tests/jsonfiles/36-rule-real.json
+++ b/tests/jsonfiles/36-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":36,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/37-rule-real.json b/tests/jsonfiles/37-rule-real.json
index 2645328..0dc73fc 100644
--- a/tests/jsonfiles/37-rule-real.json
+++ b/tests/jsonfiles/37-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":37,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}]}}]}
diff --git a/tests/jsonfiles/38-rule-real.json b/tests/jsonfiles/38-rule-real.json
index 2a7640b..ffdf054 100644
--- a/tests/jsonfiles/38-rule-real.json
+++ b/tests/jsonfiles/38-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":38,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}]}}]}
diff --git a/tests/jsonfiles/39-rule-real.json b/tests/jsonfiles/39-rule-real.json
index 5ab4fae..c555b02 100644
--- a/tests/jsonfiles/39-rule-real.json
+++ b/tests/jsonfiles/39-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"cmp","sreg":1,"op":"lte","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":39,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"gte","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"cmp","sreg":1,"op":"lte","data_reg":{"type":"value","len":4,"data0":"0xfa00a8c0"}}]}}]}
diff --git a/tests/jsonfiles/40-rule-real.json b/tests/jsonfiles/40-rule-real.json
index 483a1a5..0068325 100644
--- a/tests/jsonfiles/40-rule-real.json
+++ b/tests/jsonfiles/40-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":40,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/41-rule-real.json b/tests/jsonfiles/41-rule-real.json
index d8ed85c..a796b58 100644
--- a/tests/jsonfiles/41-rule-real.json
+++ b/tests/jsonfiles/41-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":41,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
diff --git a/tests/jsonfiles/42-rule-real.json b/tests/jsonfiles/42-rule-real.json
index 49f9b56..4d21547 100644
--- a/tests/jsonfiles/42-rule-real.json
+++ b/tests/jsonfiles/42-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":42,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"log","prefix":"(null)","group":0,"snaplen":0,"qthreshold":0}]}}]}
diff --git a/tests/jsonfiles/43-rule-real.json b/tests/jsonfiles/43-rule-real.json
index be2c6fb..dcde606 100644
--- a/tests/jsonfiles/43-rule-real.json
+++ b/tests/jsonfiles/43-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":43,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/44-rule-real.json b/tests/jsonfiles/44-rule-real.json
index 890e529..79bc711 100644
--- a/tests/jsonfiles/44-rule-real.json
+++ b/tests/jsonfiles/44-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x16000004"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":44,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":0,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x16000004"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/45-rule-real.json b/tests/jsonfiles/45-rule-real.json
index ed61093..e6732fb 100644
--- a/tests/jsonfiles/45-rule-real.json
+++ b/tests/jsonfiles/45-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":45,"expr":[{"type":"payload","dreg":1,"offset":12,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x0100a8c0","data1":"0x6400a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/46-rule-real.json b/tests/jsonfiles/46-rule-real.json
index ed2431e..7f97a55 100644
--- a/tests/jsonfiles/46-rule-real.json
+++ b/tests/jsonfiles/46-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":46,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}]}}]}
diff --git a/tests/jsonfiles/47-rule-real.json b/tests/jsonfiles/47-rule-real.json
index 828e3ef..556d2e0 100644
--- a/tests/jsonfiles/47-rule-real.json
+++ b/tests/jsonfiles/47-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":47,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":0,"len":8,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":8,"data0":"0x16000004","data1":"0x00000000"}}]}}]}
diff --git a/tests/jsonfiles/48-rule-real.json b/tests/jsonfiles/48-rule-real.json
index 7f08637..6a0b288 100644
--- a/tests/jsonfiles/48-rule-real.json
+++ b/tests/jsonfiles/48-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":48,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/49-rule-real.json b/tests/jsonfiles/49-rule-real.json
index 26f2672..53cca09 100644
--- a/tests/jsonfiles/49-rule-real.json
+++ b/tests/jsonfiles/49-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":49,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000000"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/50-rule-real.json b/tests/jsonfiles/50-rule-real.json
index b63d722..3979d2a 100644
--- a/tests/jsonfiles/50-rule-real.json
+++ b/tests/jsonfiles/50-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":50,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000001"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/51-rule-real.json b/tests/jsonfiles/51-rule-real.json
index 441716e..1afbf82 100644
--- a/tests/jsonfiles/51-rule-real.json
+++ b/tests/jsonfiles/51-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":51,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/52-rule-real.json b/tests/jsonfiles/52-rule-real.json
index baec217..911ddd3 100644
--- a/tests/jsonfiles/52-rule-real.json
+++ b/tests/jsonfiles/52-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":52,"expr":[{"type":"meta","dreg":1,"key":"oif"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000001"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/53-rule-real.json b/tests/jsonfiles/53-rule-real.json
index bb28dea..6d49b19 100644
--- a/tests/jsonfiles/53-rule-real.json
+++ b/tests/jsonfiles/53-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":53,"expr":[{"type":"meta","dreg":1,"key":"oifname"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/54-rule-real.json b/tests/jsonfiles/54-rule-real.json
index ae3b6e8..668bf75 100644
--- a/tests/jsonfiles/54-rule-real.json
+++ b/tests/jsonfiles/54-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":54,"expr":[{"type":"meta","dreg":1,"key":"skuid"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/55-rule-real.json b/tests/jsonfiles/55-rule-real.json
index 69febc0..5338611 100644
--- a/tests/jsonfiles/55-rule-real.json
+++ b/tests/jsonfiles/55-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":55,"expr":[{"type":"meta","dreg":1,"key":"skgid"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/56-rule-real.json b/tests/jsonfiles/56-rule-real.json
index 6f5f4c5..ff5d4ee 100644
--- a/tests/jsonfiles/56-rule-real.json
+++ b/tests/jsonfiles/56-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":56,"expr":[{"type":"meta","dreg":1,"key":"secmark"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000000"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/57-rule-real.json b/tests/jsonfiles/57-rule-real.json
index da17f64..f578573 100644
--- a/tests/jsonfiles/57-rule-real.json
+++ b/tests/jsonfiles/57-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":57,"expr":[{"type":"meta","dreg":1,"key":"len"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/58-rule-real.json b/tests/jsonfiles/58-rule-real.json
index 52532f1..a5e7ec5 100644
--- a/tests/jsonfiles/58-rule-real.json
+++ b/tests/jsonfiles/58-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0":"0x00000008"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":58,"expr":[{"type":"meta","dreg":1,"key":"protocol"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00000008"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/59-rule-real.json b/tests/jsonfiles/59-rule-real.json
index aa632d3..46a470b 100644
--- a/tests/jsonfiles/59-rule-real.json
+++ b/tests/jsonfiles/59-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000000"}}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":59,"expr":[{"type":"meta","dreg":1,"key":"mark"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000000"}},{"type":"counter","pkts":55,"bytes":11407}]}}]}
diff --git a/tests/jsonfiles/60-rule-real.json b/tests/jsonfiles/60-rule-real.json
index 4b58efd..1efef1f 100644
--- a/tests/jsonfiles/60-rule-real.json
+++ b/tests/jsonfiles/60-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x00000001"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":60,"expr":[{"type":"meta","dreg":1,"key":"iif"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x00000001"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/61-rule-real.json b/tests/jsonfiles/61-rule-real.json
index c6acf03..1f15c84 100644
--- a/tests/jsonfiles/61-rule-real.json
+++ b/tests/jsonfiles/61-rule-real.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":61,"expr":[{"type":"meta","dreg":1,"key":"iifname"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":16,"data0":"0x00000000","data1":"0x00000000","data2":"0x65000000","data3":"0x00306874"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/jsonfiles/64-ruleset.json b/tests/jsonfiles/64-ruleset.json
index 3495d83..575f5ac 100644
--- a/tests/jsonfiles/64-ruleset.json
+++ b/tests/jsonfiles/64-ruleset.json
@@ -1 +1 @@
-{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":1,"data0":"0x00000006"}}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":2,"data0"
 :"0x00001600"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
+{"nftables":[{"table":{"name":"filter","family":"ip","flags":0,"use":0}},{"table":{"name":"filter2","family":"ip6","flags":0,"use":0}},{"chain":{"name":"input","handle":1,"bytes":10681449,"packets":16216,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"input","prio":0,"policy":"accept"}},{"chain":{"name":"forward","handle":2,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"forward","prio":0,"policy":"accept"}},{"chain":{"name":"output","handle":3,"bytes":2375830,"packets":15184,"family":"ip","table":"filter","use":0,"type":"filter","hooknum":"output","prio":0,"policy":"accept"}},{"chain":{"name":"chain1","handle":4,"bytes":0,"packets":0,"family":"ip","table":"filter","use":0}},{"set":{"name":"set0","table":"filter","flags":3,"family"
 :"ip","key_type":12,"key_len":2}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":6,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":9,"expr":[{"type":"payload","dreg":1,"offset":9,"len":1,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":1,"data0":"0x00000006"}},{"type":"payload","dreg":1,"offset":2,"len":2,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":2,"data0":"0x00001600"}},{"type":"counter","
 pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":10,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0}]}},{"rule":{"family":"ip","table":"filter","chain":"output","handle":11,"expr":[{"type":"payload","dreg":1,"offset":16,"len":4,"base":"link"},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x0100a8c0"}},{"type":"counter","pkts":0,"bytes":0},{"type":"immediate","dreg":0,"immediatedata":{"data_reg":{"type":"verdict","verdict":"drop"}}}]}}]}
diff --git a/tests/jsonfiles/65-rule-meta-target.json b/tests/jsonfiles/65-rule-meta-target.json
index cf036bc..bf1bcaa 100644
--- a/tests/jsonfiles/65-rule-meta-target.json
+++ b/tests/jsonfiles/65-rule-meta-target.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"mark","sreg":1},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}]}
+{"nftables":[{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"mark","sreg":1},{"type":"cmp","sreg":1,"op":"eq","data_reg":{"type":"value","len":4,"data0":"0x000003e8"}},{"type":"counter","pkts":0,"bytes":0}]}}]}
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index 308fb9f..a0371a3 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></cmpdata></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>36</handle><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x6e6f6200</data1><data2>0x2e303164</data2><data3>0x00393331</data3></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
index 5c8e075..89a37f6 100644
--- a/tests/xmlfiles/36-rule-real.xml
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
index d9293f6..331ca27 100644
--- a/tests/xmlfiles/37-rule-real.xml
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</da
 ta0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></expr><expr type="ct"><dreg>1</
 dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>testprefix</prefix><group>1</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
index b8830b0..32b3a9e 100644
--- a/tests/xmlfiles/38-rule-real.xml
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immedia
 te"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>30</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="lookup"><set>set3</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x0000bb01</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data
 _reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
index 9a69a61..da65fd4 100644
--- a/tests/xmlfiles/39-rule-real.xml
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></cmpdata></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="
 value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></cmpdata></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></
 data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_drop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>filter</table><chain>test</chain><handle>31</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x6f620000</data2><data3>0x0030646e</data3></data_reg></expr><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x62000000</data1><data2>0x31646e6f</data2><data3>0x0037322e</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>8</offset><len>16</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><d
 ata1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></expr><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>dns_d
 rop</prefix><group>2</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
index 0041ebf..33fb75f 100644
--- a/tests/xmlfiles/40-rule-real.xml
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
index bd213b0..0f7b752 100644
--- a/tests/xmlfiles/41-rule-real.xml
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><cmpdata><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></cmpdata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>3</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>gte</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="cmp"><sreg>1</sreg><op>lte</op><data_reg type="value"><len>4</len><data0>0xfa00a8c0</data0></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
index b5cc1bd..e76c6aa 100644
--- a/tests/xmlfiles/42-rule-real.xml
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>4</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
index a84f513..96f5530 100644
--- a/tests/xmlfiles/43-rule-real.xml
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>5</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>drop</verdict></data_reg></immediatedata></expr></rule></nftables>
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
index 5a99e6f..e61a763 100644
--- a/tests/xmlfiles/44-rule-real.xml
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>6</handle><expr type="payload"><dreg>1</dreg><offset>16</offset><len>4</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="log"><prefix>(null)</prefix><group>0</group><snaplen>0</snaplen><qthreshold>0</qthreshold></expr></rule></nftables>
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
index 53fa009..fa2afac 100644
--- a/tests/xmlfiles/45-rule-real.xml
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>7</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
index 0ddf6c8..a5155bc 100644
--- a/tests/xmlfiles/46-rule-real.xml
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>8</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>4</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x16000004</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
index fde6d26..798f4f3 100644
--- a/tests/xmlfiles/47-rule-real.xml
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>12</offset><len>8</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x0100a8c0</data0><data1>0x6400a8c0</data1></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
index 547a0f6..509a299 100644
--- a/tests/xmlfiles/48-rule-real.xml
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>10</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
index dc662a3..bc1a6ad 100644
--- a/tests/xmlfiles/49-rule-real.xml
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></cmpdata></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>11</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>0</offset><len>8</len><base>transport</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>8</len><data0>0x16000004</data0><data1>0x00000000</data1></data_reg></expr></rule></nftables>
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
index c52e00e..5b100e6 100644
--- a/tests/xmlfiles/50-rule-real.xml
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>12</handle><expr type="ct"><dreg>1</dreg><key>state</key><dir>original</dir></expr><expr type="bitwise"><sreg>1</sreg><dreg>1</dreg><len>4</len><mask><data_reg type="value"><len>4</len><data0>0x0000000a</data0></data_reg></mask><xor><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></xor></expr><expr type="cmp"><sreg>1</sreg><op>neq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
index 93d6632..555dddd 100644
--- a/tests/xmlfiles/51-rule-real.xml
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>13</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>5</pkts><bytes>160</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
index c6ca9ec..f86ad01 100644
--- a/tests/xmlfiles/52-rule-real.xml
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>14</handle><expr type="ct"><dreg>1</dreg><key>direction</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>50</pkts><bytes>11247</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
index 8cb0783..d257fa6 100644
--- a/tests/xmlfiles/53-rule-real.xml
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>15</handle><expr type="ct"><dreg>1</dreg><key>status</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
index 0c0dc9a..55280d6 100644
--- a/tests/xmlfiles/54-rule-real.xml
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>16</handle><expr type="ct"><dreg>1</dreg><key>mark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000064</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
index fca8c99..e3333a1 100644
--- a/tests/xmlfiles/55-rule-real.xml
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>17</handle><expr type="ct"><dreg>1</dreg><key>secmark</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
index 1ea7f0c..90d91f1 100644
--- a/tests/xmlfiles/56-rule-real.xml
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>18</handle><expr type="ct"><dreg>1</dreg><key>expiration</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x0000001e</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
index 6036973..61d662f 100644
--- a/tests/xmlfiles/57-rule-real.xml
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>19</handle><expr type="ct"><dreg>1</dreg><key>helper</key><dir>original</dir></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00707466</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
index d9bfe3a..5a7f5d7 100644
--- a/tests/xmlfiles/58-rule-real.xml
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>20</handle><expr type="meta"><dreg>1</dreg><key>len</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
index 6af8aa6..a596479 100644
--- a/tests/xmlfiles/59-rule-real.xml
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>21</handle><expr type="meta"><dreg>1</dreg><key>protocol</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>2</len><data0>0x00000008</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
index 24cf057..7c8437f 100644
--- a/tests/xmlfiles/60-rule-real.xml
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>22</handle><expr type="meta"><dreg>1</dreg><key>mark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
index 3aaad57..2ed9517 100644
--- a/tests/xmlfiles/61-rule-real.xml
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>23</handle><expr type="meta"><dreg>1</dreg><key>iif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
index d7935d1..1bcf040 100644
--- a/tests/xmlfiles/62-rule-real.xml
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>24</handle><expr type="meta"><dreg>1</dreg><key>iifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
index f2a36f4..153cd8f 100644
--- a/tests/xmlfiles/63-rule-real.xml
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>25</handle><expr type="meta"><dreg>1</dreg><key>oif</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000001</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
index 01a8708..85f2cfc 100644
--- a/tests/xmlfiles/64-rule-real.xml
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>26</handle><expr type="meta"><dreg>1</dreg><key>oifname</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>16</len><data0>0x00000000</data0><data1>0x00000000</data1><data2>0x65000000</data2><data3>0x00306874</data3></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
index 2d59190..74a1ae3 100644
--- a/tests/xmlfiles/65-rule-real.xml
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>27</handle><expr type="meta"><dreg>1</dreg><key>skuid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
index f9d9c5e..db93413 100644
--- a/tests/xmlfiles/66-rule-real.xml
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>28</handle><expr type="meta"><dreg>1</dreg><key>skgid</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x000003e8</data0></data_reg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
index 555139c..9fa0bd2 100644
--- a/tests/xmlfiles/67-rule-real.xml
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></cmpdata></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>29</handle><expr type="meta"><dreg>1</dreg><key>secmark</key></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>4</len><data0>0x00000000</data0></data_reg></expr><expr type="counter"><pkts>55</pkts><bytes>11407</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
index a0ff9ce..07f6066 100644
--- a/tests/xmlfiles/68-rule-real.xml
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>32</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr></rule></nftables>
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
index 6edd166..3b882b0 100644
--- a/tests/xmlfiles/70-rule-real.xml
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>34</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
index fba3af9..dffa2a6 100644
--- a/tests/xmlfiles/71-rule-real.xml
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>output</chain><handle>35</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map1</set><sreg>1</sreg><dreg>0</dreg></expr></rule></nftables>
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
index 9e88433..d1c34a1 100644
--- a/tests/xmlfiles/75-ruleset.xml
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>
 0x00004300</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input<
 /chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handl
 e><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>
 0x00004300</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input<
 /chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="paylo
 ad"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></immediatedata></expr></rule></nftables>
-- 
1.9.0

