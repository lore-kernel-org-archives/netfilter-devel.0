From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 14:10:25 +0100
Message-ID: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49651 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaAJNKd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:10:33 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so1120210wgh.14
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 05:10:32 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds userspace support for setting properties of tracked connections.
Currently, the connection mark is supported. This can be used to implemented the
same functionality as iptables -j CONNMARK --save-mark.

v1->v2:
- Fixed a style error.
- Improved error handling. Fail if neither sreg nor dreg is set (was already
  present when parsing XML).

v2->v3:
- Set sreg type to enum nft_registers.
- Let user specify any combination of sreg and dreg, and let the kernel do the
  error checking (and return -EINVAL). We avoid masking any errors and users
  will know that they have to fix their code.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/libnftables/expr.h          |   1 +
 include/linux/netfilter/nf_tables.h |   2 +
 src/expr/ct.c                       | 120 ++++++++++++++++++++++++++++--------
 3 files changed, 99 insertions(+), 24 deletions(-)

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 25455e4..653bbb0 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -124,6 +124,7 @@ enum {
 	NFT_EXPR_CT_DREG	= NFT_RULE_EXPR_ATTR_BASE,
 	NFT_EXPR_CT_KEY,
 	NFT_EXPR_CT_DIR,
+	NFT_EXPR_CT_SREG,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e08f80e..1b6362c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -526,12 +526,14 @@ enum nft_ct_keys {
  * @NFTA_CT_DREG: destination register (NLA_U32)
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
+ * @NFTA_CT_SREG: source register (NLA_U32)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
 	NFTA_CT_DREG,
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
+	NFTA_CT_SREG,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 46e3cef..02a073e 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -24,7 +24,8 @@
 
 struct nft_expr_ct {
 	enum nft_ct_keys        key;
-	uint32_t		dreg;	/* enum nft_registers */
+	enum nft_registers	dreg;
+	enum nft_registers	sreg;
 	uint8_t			dir;
 };
 
@@ -51,6 +52,9 @@ nft_rule_expr_ct_set(struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_CT_DREG:
 		ct->dreg = *((uint32_t *)data);
 		break;
+	case NFT_EXPR_CT_SREG:
+		ct->sreg = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -73,6 +77,9 @@ nft_rule_expr_ct_get(const struct nft_rule_expr *e, uint16_t type,
 	case NFT_EXPR_CT_DREG:
 		*data_len = sizeof(ct->dreg);
 		return &ct->dreg;
+	case NFT_EXPR_CT_SREG:
+		*data_len = sizeof(ct->sreg);
+		return &ct->sreg;
 	}
 	return NULL;
 }
@@ -88,6 +95,7 @@ static int nft_rule_expr_ct_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_CT_KEY:
 	case NFTA_CT_DREG:
+	case NFTA_CT_SREG:
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -116,6 +124,8 @@ nft_rule_expr_ct_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_CT_DREG, htonl(ct->dreg));
 	if (e->flags & (1 << NFT_EXPR_CT_DIR))
 		mnl_attr_put_u8(nlh, NFTA_CT_DIRECTION, ct->dir);
+	if (e->flags & (1 << NFT_EXPR_CT_SREG))
+		mnl_attr_put_u32(nlh, NFTA_CT_SREG, htonl(ct->sreg));
 }
 
 static int
@@ -131,13 +141,17 @@ nft_rule_expr_ct_parse(struct nft_rule_expr *e, struct nlattr *attr)
 		ct->key = ntohl(mnl_attr_get_u32(tb[NFTA_CT_KEY]));
 		e->flags |= (1 << NFT_EXPR_CT_KEY);
 	}
+	if (tb[NFTA_CT_DIRECTION]) {
+		ct->dir = mnl_attr_get_u8(tb[NFTA_CT_DIRECTION]);
+		e->flags |= (1 << NFT_EXPR_CT_DIR);
+	}
 	if (tb[NFTA_CT_DREG]) {
 		ct->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_CT_DREG]));
 		e->flags |= (1 << NFT_EXPR_CT_DREG);
 	}
-	if (tb[NFTA_CT_DIRECTION]) {
-		ct->dir = mnl_attr_get_u8(tb[NFTA_CT_DIRECTION]);
-		e->flags |= (1 << NFT_EXPR_CT_DIR);
+	if (tb[NFTA_CT_SREG]) {
+		ct->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_CT_SREG]));
+		e->flags |= (1 << NFT_EXPR_CT_SREG);
 	}
 
 	return 0;
@@ -186,10 +200,19 @@ static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json_t *root)
 	uint8_t dir;
 	int key;
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
-		return -1;
+	if (nft_jansson_node_exist(root, "dreg")) {
+		if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &reg) < 0)
+			return -1;
+
+		nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
+	}
+
+	if (nft_jansson_node_exist(root, "sreg")) {
+		if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &reg) < 0)
+			return -1;
 
-	nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
+		nft_rule_expr_set_u32(e, NFT_EXPR_CT_SREG, reg);
+	}
 
 	if (nft_jansson_node_exist(root, "key")) {
 		key_str = nft_jansson_parse_str(root, "key");
@@ -235,11 +258,16 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	uint8_t dir;
 
 	reg = nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
-	if (reg < 0)
-		return -1;
+	if (reg >= 0) {
+		ct->dreg = reg;
+		e->flags |= (1 << NFT_EXPR_CT_DREG);
+	}
 
-	ct->dreg = reg;
-	e->flags |= (1 << NFT_EXPR_CT_DREG);
+	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	if (reg >= 0) {
+		ct->sreg = reg;
+		e->flags |= (1 << NFT_EXPR_CT_SREG);
+	}
 
 	key_str = nft_mxml_str_parse(tree, "key", MXML_DESCEND_FIRST,
 				     NFT_XML_MAND);
@@ -274,13 +302,64 @@ err:
 }
 
 static int
-nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
+nft_rule_expr_ct_snprintf_default(char *buf, size_t size,
+				  struct nft_rule_expr *e)
+{
+	struct nft_expr_ct *ct = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_CT_SREG))
+		return snprintf(buf, size, "set %s with reg %u ",
+				ctkey2str(ct->key), ct->sreg);
+
+	return snprintf(buf, size, "load %s => reg %u dir %u ",
+			ctkey2str(ct->key), ct->dreg, ct->dir);
+}
+
+static int
+nft_rule_expr_ct_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
+{
+	int ret, len = size, offset = 0;
+	struct nft_expr_ct *ct = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_CT_DREG)) {
+		ret = snprintf(buf, len, "<dreg>%u</dreg>", ct->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_CT_SREG)) {
+		ret = snprintf(buf, len, "<sreg>%u</sreg>", ct->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
+		ret = snprintf(buf+offset, len, "<key>%s</key>",
+			       ctkey2str(ct->key));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
+		ret = snprintf(buf+offset, len, "<dir>%u</dir>", ct->dir);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int
+nft_rule_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
 {
 	int ret, len = size, offset = 0;
 	struct nft_expr_ct *ct = nft_expr_data(e);
 
-	ret = snprintf(buf, len, "\"dreg\":%u", ct->dreg);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_EXPR_CT_DREG)) {
+		ret = snprintf(buf, len, "\"dreg\":%u", ct->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_CT_SREG)) {
+		ret = snprintf(buf, len, "\"sreg:\":%u", ct->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	if (e->flags & (1 << NFT_EXPR_CT_KEY)) {
 		ret = snprintf(buf+offset, len, ",\"key\":\"%s\"",
@@ -294,26 +373,19 @@ nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
 	}
 
 	return offset;
-
 }
 
 static int
 nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 			    uint32_t flags, struct nft_rule_expr *e)
 {
-	struct nft_expr_ct *ct = nft_expr_data(e);
-
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "load %s => reg %u dir %u ",
-				ctkey2str(ct->key), ct->dreg, ct->dir);
+		return nft_rule_expr_ct_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%s</key>"
-					  "<dir>%u</dir>",
-				ct->dreg, ctkey2str(ct->key), ct->dir);
+		return nft_rule_expr_ct_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_expr_ct_snprintf_json(buf, len, e);
+		return nft_rule_expr_ct_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
1.8.3.2

