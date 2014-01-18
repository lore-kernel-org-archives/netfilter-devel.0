From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] data_reg: fix verdict format approach
Date: Sat, 18 Jan 2014 17:56:45 +0100
Message-ID: <20140118165454.23517.40740.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51240 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbaARQ45 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 11:56:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick reports that the XML/JSON formats of the data_reg object
are not accuarate.

This patch updates these formats, so they are now as follow:

 * <data_reg type=value> with raw data (this doesn't change).
 * <data_reg type=verdict> with a concrete verdict (eg drop accept) and an
  optional <chain>, with destination.

In XML:
	<data_reg type="verdict">
		<verdict>goto</verdict>
		<chain>output</chain>
	</data_reg>

In JSON:
	"data_reg" : {
		"type" : "verdict",
		"verdict" : "goto"
		"chain" : "output",
	}

The default output format is updated to reflect these changes (minor collateral
thing).

When parsing set_elems, to know if we need to add the NFT_SET_ELEM_ATTR_CHAIN
flag, a basic check for the chain not being NULL is done, instead of evaluating
if the result of the parsing was DATA_CHAIN. The DATA_CHAIN symbol is no longer
used in the data_reg XML/JSON parsing zone.

While at it, I updated the error reporting stuff regarding data_reg/verdict, in
order to leave a consistent state in the library.

A JSON testfile is updated as well.

Reported-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: fixed a phrase in the description.

 src/expr/data_reg.c         |  171 +++++++++++++++++++++++++------------------
 src/jansson.c               |   27 ++-----
 src/set_elem.c              |    6 +-
 tests/jsonfiles/63-set.json |    2 -
 tests/nft-parsing-test.c    |    1 
 5 files changed, 110 insertions(+), 97 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 8812daf..a755948 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -32,10 +32,11 @@ static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, json_t *data
 {
 	int verdict;
 	const char *verdict_str;
+	const char *chain;
 
 	verdict_str = nft_jansson_parse_str(data, "verdict", err);
 	if (verdict_str == NULL)
-		return -1;
+		return DATA_NONE;
 
 	if (nft_str2verdict(verdict_str, &verdict) != 0) {
 		err->node_name = "verdict";
@@ -46,18 +47,15 @@ static int nft_data_reg_verdict_json_parse(union nft_data_reg *reg, json_t *data
 
 	reg->verdict = (uint32_t)verdict;
 
-	return 0;
-}
+	if (nft_jansson_node_exist(data, "chain")) {
+		chain = nft_jansson_parse_str(data, "chain", err);
+		if (chain == NULL)
+			return DATA_NONE;
 
-static int nft_data_reg_chain_json_parse(union nft_data_reg *reg, json_t *data,
-					 struct nft_parse_err *err)
-{
-	reg->chain = strdup(nft_jansson_parse_str(data, "chain", err));
-	if (reg->chain == NULL) {
-		return -1;
+		reg->chain = strdup(chain);
 	}
 
-	return 0;
+	return DATA_VERDICT;
 }
 
 static int nft_data_reg_value_json_parse(union nft_data_reg *reg, json_t *data,
@@ -67,17 +65,17 @@ static int nft_data_reg_value_json_parse(union nft_data_reg *reg, json_t *data,
 	char node_name[6];
 
 	if (nft_jansson_parse_val(data, "len", NFT_TYPE_U8, &reg->len, err) < 0)
-			return -1;
+			return DATA_NONE;
 
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
 		sprintf(node_name, "data%d", i);
 
 		if (nft_jansson_str2num(data, node_name, BASE_HEX,
 					&reg->val[i], NFT_TYPE_U32, err) != 0)
-			return -1;
+			return DATA_NONE;
 	}
 
-	return 0;
+	return DATA_VALUE;
 }
 #endif
 
@@ -93,15 +91,12 @@ int nft_data_reg_json_parse(union nft_data_reg *reg, json_t *data,
 		return -1;
 
 	/* Select what type of parsing is needed */
-	if (strcmp(type, "value") == 0) {
+	if (strcmp(type, "value") == 0)
 		return nft_data_reg_value_json_parse(reg, data, err);
-	} else if (strcmp(type, "verdict") == 0) {
+	else if (strcmp(type, "verdict") == 0)
 		return nft_data_reg_verdict_json_parse(reg, data, err);
-	} else if (strcmp(type, "chain") == 0) {
-		return nft_data_reg_chain_json_parse(reg, data, err);
-	}
 
-	return 0;
+	return DATA_NONE;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
@@ -115,6 +110,7 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg,
 {
 	int verdict;
 	const char *verdict_str;
+	const char *chain;
 
 	verdict_str = nft_mxml_str_parse(tree, "verdict", MXML_DESCEND_FIRST,
 					 NFT_XML_MAND, err);
@@ -130,25 +126,16 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg,
 
 	reg->verdict = (uint32_t)verdict;
 
-	return DATA_VERDICT;
-}
-
-static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg,
-					mxml_node_t *tree,
-					struct nft_parse_err *err)
-{
-	const char *chain;
-
 	chain = nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
-				   NFT_XML_MAND, err);
-	if (chain == NULL)
-		return DATA_NONE;
+				   NFT_XML_OPT, err);
+	if (chain != NULL) {
+		if (reg->chain)
+			xfree(reg->chain);
 
-	if (reg->chain)
-		xfree(reg->chain);
+		reg->chain = strdup(chain);
+	}
 
-	reg->chain = strdup(chain);
-	return DATA_CHAIN;
+	return DATA_VERDICT;
 }
 
 static int nft_data_reg_value_xml_parse(union nft_data_reg *reg,
@@ -195,26 +182,25 @@ int nft_data_reg_xml_parse(union nft_data_reg *reg, mxml_node_t *tree,
 
 	node = mxmlFindElement(tree, tree, "data_reg", "type", NULL,
 			       MXML_DESCEND_FIRST);
-	if (node == NULL) {
-		errno = EINVAL;
-		return DATA_NONE;
-	}
+	if (node == NULL)
+		goto err;
 
 	type = mxmlElementGetAttr(node, "type");
 
-	if (type == NULL) {
-		errno = EINVAL;
-		return DATA_NONE;
-	}
+	if (type == NULL)
+		goto err;
 
 	if (strcmp(type, "value") == 0)
 		return nft_data_reg_value_xml_parse(reg, node, err);
 	else if (strcmp(type, "verdict") == 0)
 		return nft_data_reg_verdict_xml_parse(reg, node, err);
-	else if (strcmp(type, "chain") == 0)
-		return nft_data_reg_chain_xml_parse(reg, node, err);
 
 	return DATA_NONE;
+err:
+	errno = EINVAL;
+	err->node_name = "data_reg";
+	err->error = NFT_PARSE_EMISSINGNODE;
+	return DATA_NONE;
 #else
 	errno = EOPNOTSUPP;
 	return -1;
@@ -308,6 +294,67 @@ nft_data_reg_value_snprintf_default(char *buf, size_t size,
 	return offset;
 }
 
+static int
+nft_data_reg_verdict_snprintf_def(char *buf, size_t size,
+				  union nft_data_reg *reg, uint32_t flags)
+{
+	int len = size, offset = 0, ret = 0;
+
+	ret = snprintf(buf, size, "%s ", nft_verdict2str(reg->verdict));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (reg->chain != NULL) {
+		ret = snprintf(buf+offset, size, "-> %s ", reg->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int
+nft_data_reg_verdict_snprintf_xml(char *buf, size_t size,
+				  union nft_data_reg *reg, uint32_t flags)
+{
+	int len = size, offset = 0, ret = 0;
+
+	ret = snprintf(buf, size, "<data_reg type=\"verdict\">"
+		       "<verdict>%s</verdict>", nft_verdict2str(reg->verdict));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (reg->chain != NULL) {
+		ret = snprintf(buf+offset, size, "<chain>%s</chain>",
+			       reg->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf+offset, size, "</data_reg>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+static int
+nft_data_reg_verdict_snprintf_json(char *buf, size_t size,
+				   union nft_data_reg *reg, uint32_t flags)
+{
+	int len = size, offset = 0, ret = 0;
+
+	ret = snprintf(buf, size, "\"data_reg\":{\"type\":\"verdict\","
+		       "\"verdict\":\"%s\"", nft_verdict2str(reg->verdict));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (reg->chain != NULL) {
+		ret = snprintf(buf+offset, size, ",\"chain\":\"%s\"",
+			       reg->chain);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf+offset, size, "}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 			  uint32_t output_format, uint32_t flags, int reg_type)
 {
@@ -327,44 +374,24 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 			break;
 		}
 	case DATA_VERDICT:
-		switch(output_format) {
-		case NFT_OUTPUT_DEFAULT:
-			return snprintf(buf, size, "%d ", reg->verdict);
-		case NFT_OUTPUT_XML:
-			return snprintf(buf, size,
-					"<data_reg type=\"verdict\">"
-						"<verdict>%s</verdict>"
-					"</data_reg>",
-					nft_verdict2str(reg->verdict));
-		case NFT_OUTPUT_JSON:
-			return snprintf(buf, size,
-					"\"data_reg\":{"
-					"\"type\":\"verdict\","
-					"\"verdict\":\"%s\""
-					"}", nft_verdict2str(reg->verdict));
-		default:
-			break;
-		}
 	case DATA_CHAIN:
 		switch(output_format) {
 		case NFT_OUTPUT_DEFAULT:
-			return snprintf(buf, size, "%s ", reg->chain);
+			return nft_data_reg_verdict_snprintf_def(buf, size,
+								 reg, flags);
 		case NFT_OUTPUT_XML:
-			return snprintf(buf, size,
-					"<data_reg type=\"chain\">"
-						"<chain>%s</chain>"
-					"</data_reg>", reg->chain);
+			return nft_data_reg_verdict_snprintf_xml(buf, size,
+								 reg, flags);
 		case NFT_OUTPUT_JSON:
-			return snprintf(buf, size,
-					"\"data_reg\":{\"type\":\"chain\","
-					"\"chain\":\"%s\""
-					"}", reg->chain);
+			return nft_data_reg_verdict_snprintf_json(buf, size,
+								  reg, flags);
 		default:
 			break;
 		}
 	default:
 		break;
 	}
+
 	return -1;
 }
 
diff --git a/src/jansson.c b/src/jansson.c
index f446e17..26bd700 100644
--- a/src/jansson.c
+++ b/src/jansson.c
@@ -213,7 +213,6 @@ int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 			       struct nft_parse_err *err)
 {
 	json_t *data;
-	const char *type;
 	int ret;
 
 	data = json_object_get(root, node_name);
@@ -233,27 +232,12 @@ int nft_jansson_data_reg_parse(json_t *root, const char *node_name,
 	}
 
 	ret = nft_data_reg_json_parse(data_reg, data, err);
-	if (ret < 0) {
+	if (ret == DATA_NONE) {
 		errno = EINVAL;
 		return -1;
 	}
 
-	type = nft_jansson_parse_str(data, "type", err);
-	if (type == NULL)
-		return -1;
-
-	if (strcmp(type, "value") == 0)
-		return DATA_VALUE;
-	else if (strcmp(type, "verdict") == 0)
-		return DATA_VERDICT;
-	else if (strcmp(type, "chain") == 0)
-		return DATA_CHAIN;
-	else {
-		err->error = NFT_PARSE_EBADTYPE;
-		err->node_name = "type";
-		errno = EINVAL;
-		return -1;
-	}
+	return ret;
 }
 
 int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
@@ -281,10 +265,11 @@ int nft_jansson_set_elem_parse(struct nft_set_elem *e, json_t *root,
 			break;
 		case DATA_VERDICT:
 			e->flags |= (1 << NFT_SET_ELEM_ATTR_VERDICT);
+			if (e->data.chain != NULL)
+				e->flags |= (1 << NFT_SET_ELEM_ATTR_CHAIN);
+
 			break;
-		case DATA_CHAIN:
-			e->flags |= (1 << NFT_SET_ELEM_ATTR_CHAIN);
-			break;
+		case DATA_NONE:
 		default:
 			return -1;
 		}
diff --git a/src/set_elem.c b/src/set_elem.c
index 2bbfb0e..26c11d0 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -384,9 +384,9 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e,
 		break;
 	case DATA_VERDICT:
 		e->flags |= (1 << NFT_SET_ELEM_ATTR_VERDICT);
-		break;
-	case DATA_CHAIN:
-		e->flags |= (1 << NFT_SET_ELEM_ATTR_CHAIN);
+		if (e->data.chain != NULL)
+			e->flags |= (1 << NFT_SET_ELEM_ATTR_CHAIN);
+
 		break;
 	}
 
diff --git a/tests/jsonfiles/63-set.json b/tests/jsonfiles/63-set.json
index ea2fe3d..62ccd2f 100644
--- a/tests/jsonfiles/63-set.json
+++ b/tests/jsonfiles/63-set.json
@@ -1 +1 @@
-{"nftables":[{"set":{"name":"map0","table":"filter","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"data_reg":{"type":"chain","chain":"forward"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"data_reg":{"type":"chain","chain":"chain1"}}}]}}]}
+{"nftables":[{"set":{"name":"map0","table":"f","flags":11,"family":"ip","key_type":12,"key_len":2,"data_type":4294967040,"data_len":16,"set_elem":[{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001700"}},"data":{"data_reg":{"type":"verdict","verdict":"goto","chain":"o"}}},{"flags":0,"key":{"data_reg":{"type":"value","len":2,"data0":"0x00001600"}},"data":{"data_reg":{"type":"verdict","verdict":"accept"}}}]}}]}
diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index b2ad62e..df981ad 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -121,6 +121,7 @@ failparsing:
 	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+	nft_parse_perror("fail", err);
 	return -1;
 }
 

