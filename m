From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] src: update meta expr
Date: Mon, 16 Dec 2013 17:10:56 +0100
Message-ID: <20131216160932.12928.13066.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tomasz.bursztyka@linux.intel.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33355 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754183Ab3LPQLH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:11:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds userspace support for the meta expression in the set flavour.

This expression indicates that the packet has to be set with a property,
currently one of mark, priority, nftrace or secmark.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v1: initial release of the patch
v2: address comments from Tomasz in the kernel side: respect the order of the
    enums. Also, other cleanups.

 include/libnftables/expr.h               |    1 
 include/linux/netfilter/nf_tables.h      |    4 +
 src/expr/meta.c                          |  116 ++++++++++++++++++++++++------
 tests/jsonfiles/65-rule-meta-target.json |    1 
 tests/xmlfiles/76-rule-meta_target.xml   |    1 
 5 files changed, 98 insertions(+), 25 deletions(-)
 create mode 100644 tests/jsonfiles/65-rule-meta-target.json
 create mode 100644 tests/xmlfiles/76-rule-meta_target.xml

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 54de186..36a2d1f 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -50,6 +50,7 @@ enum {
 enum {
 	NFT_EXPR_META_KEY	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_META_DREG,
+	NFT_EXPR_META_VALUE,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index fbfd229..e4c00de 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -552,12 +552,14 @@ enum nft_meta_keys {
  * enum nft_meta_attributes - nf_tables meta expression netlink attributes
  *
  * @NFTA_META_DREG: destination register (NLA_U32)
- * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
+ * @NFTA_META_KEY: meta data item to load or set (NLA_U32: nft_meta_keys)
+ * @NFTA_META_VALUE: value to set (NLA_U32)
  */
 enum nft_meta_attributes {
 	NFTA_META_UNSPEC,
 	NFTA_META_DREG,
 	NFTA_META_KEY,
+	NFTA_META_VALUE,
 	__NFTA_META_MAX
 };
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 88d2908..0c838e3 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -28,7 +28,10 @@
 
 struct nft_expr_meta {
 	uint8_t			key;	/* enum nft_meta_keys */
-	uint8_t			dreg;	/* enum nft_registers */
+	union {
+		uint8_t		dreg;	/* enum nft_registers */
+		uint32_t	value;
+	};
 };
 
 static int
@@ -44,6 +47,9 @@ nft_rule_expr_meta_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_META_DREG:
 		meta->dreg = *((uint32_t *)data);
 		break;
+	case NFT_EXPR_META_VALUE:
+		meta->value = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -63,6 +69,9 @@ nft_rule_expr_meta_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_META_DREG:
 		*data_len = sizeof(meta->dreg);
 		return &meta->dreg;
+	case NFT_EXPR_META_VALUE:
+		*data_len = sizeof(meta->value);
+		return &meta->value;
 	}
 	return NULL;
 }
@@ -78,6 +87,7 @@ static int nft_rule_expr_meta_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_META_KEY:
 	case NFTA_META_DREG:
+	case NFTA_META_VALUE:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -98,6 +108,8 @@ nft_rule_expr_meta_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_META_KEY, htonl(meta->key));
 	if (e->flags & (1 << NFT_EXPR_META_DREG))
 		mnl_attr_put_u32(nlh, NFTA_META_DREG, htonl(meta->dreg));
+	else if (e->flags & (1 << NFT_EXPR_META_VALUE))
+		mnl_attr_put_u32(nlh, NFTA_META_VALUE, htonl(meta->value));
 }
 
 static int
@@ -116,6 +128,9 @@ nft_rule_expr_meta_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	if (tb[NFTA_META_DREG]) {
 		meta->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_META_DREG]));
 		e->flags |= (1 << NFT_EXPR_META_DREG);
+	} else if (tb[NFTA_META_VALUE]) {
+		meta->value = ntohl(mnl_attr_get_u32(tb[NFTA_META_VALUE]));
+		e->flags |= (1 << NFT_EXPR_META_VALUE);
 	}
 
 	return 0;
@@ -164,14 +179,9 @@ static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json_t *root)
 {
 #ifdef JSON_PARSING
 	const char *key_str;
-	uint32_t reg;
+	uint32_t reg, value;
 	int key;
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
-                return -1;
-
-	nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
-
 	key_str = nft_jansson_parse_str(root, "key");
 	if (key_str == NULL)
 		return -1;
@@ -182,6 +192,19 @@ static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json_t *root)
 
 	nft_rule_expr_set_u32(e, NFT_EXPR_META_KEY, key);
 
+	if (nft_jansson_node_exist(root, "dreg")) {
+		if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+			return -1;
+
+		nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
+	} else {
+		if (nft_jansson_str2num(root, "value", BASE_HEX, &value,
+					NFT_TYPE_U32) < 0)
+			return -1;
+
+		nft_rule_expr_set_u32(e, NFT_EXPR_META_VALUE, value);
+	}
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -197,13 +220,7 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 	const char *key_str;
 	int32_t reg;
 	int key;
-
-	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
-	if (reg < 0)
-                return -1;
-
-	meta->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_META_DREG);
+	uint32_t value;
 
 	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
 				     NFT_XML_MAND);
@@ -217,6 +234,18 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 	meta->key = key;
 	e->flags |= (1 << NFT_EXPR_META_KEY);
 
+	if (nft_mxml_num_parse(tree, "value", MXML_DESCEND_FIRST, BASE_HEX,
+			       &value, NFT_TYPE_U32, NFT_XML_OPT) == 0) {
+		nft_rule_expr_set_u32(e, NFT_EXPR_META_VALUE, value);
+	} else {
+		reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
+		if (reg < 0)
+			return -1;
+
+		meta->dreg = reg;
+		e->flags |= (1 << NFT_EXPR_META_DREG);
+	}
+
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -225,23 +254,62 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 }
 
 static int
-nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, struct nft_rule_expr *e)
+nft_rule_expr_meta_snprintf_default(char *buf, size_t len, uint32_t flags,
+				    struct nft_rule_expr *e)
+{
+	struct nft_expr_meta *meta = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_META_VALUE))
+		return snprintf(buf, len, "set %s to value 0x%.8x ",
+				meta_key2str(meta->key), meta->value);
+
+	return snprintf(buf, len, "load %s => reg %u ",
+			meta_key2str(meta->key), meta->dreg);
+}
+
+static int
+nft_rule_expr_meta_snprintf_xml(char *buf, size_t len, uint32_t flags,
+				struct nft_rule_expr *e)
+{
+	struct nft_expr_meta *meta = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_META_VALUE))
+		return snprintf(buf, len, "<key>%s</key><value>0x%.8x</value>",
+				meta_key2str(meta->key), meta->value);
+
+	return snprintf(buf, len, "<dreg>%u</dreg><key>%s</key>",
+			meta->dreg, meta_key2str(meta->key));
+}
+
+static int
+nft_rule_expr_meta_snprintf_json(char *buf, size_t len, uint32_t flags,
+				 struct nft_rule_expr *e)
 {
 	struct nft_expr_meta *meta = nft_expr_data(e);
 
+	if (e->flags & (1 << NFT_EXPR_META_VALUE))
+		return snprintf(buf, len, "\"key\":\"%s\","
+				"\"value\":\"0x%.8x\"",
+				meta_key2str(meta->key), meta->value);
+
+	return snprintf(buf, len, "\"dreg\":%u,\"key\":\"%s\"",
+			meta->dreg, meta_key2str(meta->key));
+}
+
+static int
+nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
+			    uint32_t flags, struct nft_rule_expr *e)
+{
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "load %s => reg %u ",
-				meta_key2str(meta->key), meta->dreg);
+		return nft_rule_expr_meta_snprintf_default(buf, len,
+							   flags, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%s</key>",
-				meta->dreg, meta_key2str(meta->key));
+		return nft_rule_expr_meta_snprintf_xml(buf, len,
+						       flags, e);
 	case NFT_OUTPUT_JSON:
-		return snprintf(buf, len, "\"dreg\":%u,"
-					  "\"key\":\"%s\"",
-				meta->dreg, meta_key2str(meta->key));
+		return nft_rule_expr_meta_snprintf_json(buf, len,
+							flags, e);
 	default:
 		break;
 	}
diff --git a/tests/jsonfiles/65-rule-meta-target.json b/tests/jsonfiles/65-rule-meta-target.json
new file mode 100644
index 0000000..0e543e7
--- /dev/null
+++ b/tests/jsonfiles/65-rule-meta-target.json
@@ -0,0 +1 @@
+{"rule":{"family":"ip","table":"filter","chain":"output","handle":1,"expr":[{"type":"meta","key":"secmark","value":"0xaabbccdd"},{"type":"cmp","sreg":1,"op":"eq","cmpdata":{"data_reg":{"type":"value","len":4,"data0":"0x000003e8"}}},{"type":"counter","pkts":0,"bytes":0}]}}
diff --git a/tests/xmlfiles/76-rule-meta_target.xml b/tests/xmlfiles/76-rule-meta_target.xml
new file mode 100644
index 0000000..6580d6b
--- /dev/null
+++ b/tests/xmlfiles/76-rule-meta_target.xml
@@ -0,0 +1 @@
+<rule><family>ip6</family><table>filter</table><chain>test</chain><handle>129</handle><expr type="meta"><key>mark</key><value>0xaabbccdd</value></expr></rule>

