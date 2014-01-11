From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH libnftables] meta: Let user specify any combination of sreg/dreg
Date: Sat, 11 Jan 2014 14:03:17 +0100
Message-ID: <1389445397-26132-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58553 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaAKNDg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jan 2014 08:03:36 -0500
Received: by mail-lb0-f179.google.com with SMTP id w7so4174356lbi.10
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2014 05:03:34 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

libnftables should not mask kernel errors. Let user specify any combination of
parameters and leave the error-checking to the kernel. The kernel will return
-EINVAL and users will know that they have to fix their code. This patch also a
removes a redundant variable that was passed to the snprintf-functions (flag).

A second iteration might be needed. I was not sure how to deal with
snprintf_default in the case of both sreg and dreg.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 src/expr/meta.c | 89 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 31 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index 490d64a..af9ca61 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -28,10 +28,8 @@
 
 struct nft_expr_meta {
 	uint8_t			key;	/* enum nft_meta_keys */
-	union {
-		uint8_t		dreg;	/* enum nft_registers */
-		uint8_t		sreg;   /* enum nft_registers */
-	};
+	enum nft_registers	dreg;
+	enum nft_registers	sreg;
 };
 
 static int
@@ -108,7 +106,7 @@ nft_rule_expr_meta_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_META_KEY, htonl(meta->key));
 	if (e->flags & (1 << NFT_EXPR_META_DREG))
 		mnl_attr_put_u32(nlh, NFTA_META_DREG, htonl(meta->dreg));
-	else if (e->flags & (1 << NFT_EXPR_META_SREG))
+	if (e->flags & (1 << NFT_EXPR_META_SREG))
 		mnl_attr_put_u32(nlh, NFTA_META_SREG, htonl(meta->sreg));
 }
 
@@ -128,7 +126,8 @@ nft_rule_expr_meta_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	if (tb[NFTA_META_DREG]) {
 		meta->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_META_DREG]));
 		e->flags |= (1 << NFT_EXPR_META_DREG);
-	} else if (tb[NFTA_META_SREG]) {
+	}
+	if (tb[NFTA_META_SREG]) {
 		meta->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_META_SREG]));
 		e->flags |= (1 << NFT_EXPR_META_SREG);
 	}
@@ -199,7 +198,9 @@ static int nft_rule_expr_meta_json_parse(struct nft_rule_expr *e, json_t *root)
 			return -1;
 
 		nft_rule_expr_set_u32(e, NFT_EXPR_META_DREG, reg);
-	} else if (nft_jansson_node_exist(root, "sreg")) {
+	}
+
+	if (nft_jansson_node_exist(root, "sreg")) {
 		if (nft_jansson_parse_reg(root, "sreg",
 					  NFT_TYPE_U32, &sreg) < 0)
 			return -1;
@@ -239,11 +240,10 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 	if (reg >= 0) {
 		meta->dreg = reg;
 		e->flags |= (1 << NFT_EXPR_META_DREG);
-	} else {
-		reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
-		if (reg < 0)
-			return -1;
+	}
 
+	reg = nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND_FIRST);
+	if (reg >= 0) {
 		meta->sreg = reg;
 		e->flags |= (1 << NFT_EXPR_META_SREG);
 	}
@@ -256,7 +256,7 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 }
 
 static int
-nft_rule_expr_meta_snprintf_default(char *buf, size_t len, uint32_t flags,
+nft_rule_expr_meta_snprintf_default(char *buf, size_t len,
 				    struct nft_rule_expr *e)
 {
 	struct nft_expr_meta *meta = nft_expr_data(e);
@@ -270,32 +270,62 @@ nft_rule_expr_meta_snprintf_default(char *buf, size_t len, uint32_t flags,
 }
 
 static int
-nft_rule_expr_meta_snprintf_xml(char *buf, size_t len, uint32_t flags,
+nft_rule_expr_meta_snprintf_xml(char *buf, size_t size,
 				struct nft_rule_expr *e)
 {
+	int ret, len = size, offset = 0;
 	struct nft_expr_meta *meta = nft_expr_data(e);
 
-	if (e->flags & (1 << NFT_EXPR_META_SREG))
-		return snprintf(buf, len, "<key>%s</key><sreg>%u</sreg>",
-				meta_key2str(meta->key), meta->sreg);
+	if (e->flags & (1 << NFT_EXPR_META_KEY)) {
+		ret = snprintf(buf+offset, len, "<key>%s</key>",
+						meta_key2str(meta->key));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_META_SREG)) {
+		ret = snprintf(buf+offset, len, "<sreg>%u</sreg>",
+			       meta->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_META_DREG)) {
+		ret = snprintf(buf+offset, len, "<dreg>%u</dreg>",
+			       meta->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
-	return snprintf(buf, len, "<dreg>%u</dreg><key>%s</key>",
-			meta->dreg, meta_key2str(meta->key));
+	return offset;
 }
 
 static int
-nft_rule_expr_meta_snprintf_json(char *buf, size_t len, uint32_t flags,
+nft_rule_expr_meta_snprintf_json(char *buf, size_t size,
 				 struct nft_rule_expr *e)
 {
+	int ret, len = size, offset = 0;
 	struct nft_expr_meta *meta = nft_expr_data(e);
 
-	if (e->flags & (1 << NFT_EXPR_META_SREG))
-		return snprintf(buf, len, "\"key\":\"%s\","
-				"\"sreg\":%u",
-				meta_key2str(meta->key), meta->sreg);
+	if (e->flags & (1 << NFT_EXPR_META_KEY)) {
+		ret = snprintf(buf+offset, len, "\"key\":\"%s\",",
+						meta_key2str(meta->key));
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_META_SREG)) {
+		ret = snprintf(buf+offset, len, "\"sreg\":%u\",",
+			       meta->sreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (e->flags & (1 << NFT_EXPR_META_DREG)) {
+		ret = snprintf(buf+offset, len, "\"dreg\":%u\",",
+			       meta->dreg);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	/* Remove the last separator characther */
+	buf[offset-1] = '\0';
 
-	return snprintf(buf, len, "\"dreg\":%u,\"key\":\"%s\"",
-			meta->dreg, meta_key2str(meta->key));
+	return offset-1;
 }
 
 static int
@@ -304,14 +334,11 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 {
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return nft_rule_expr_meta_snprintf_default(buf, len,
-							   flags, e);
+		return nft_rule_expr_meta_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return nft_rule_expr_meta_snprintf_xml(buf, len,
-						       flags, e);
+		return nft_rule_expr_meta_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
-		return nft_rule_expr_meta_snprintf_json(buf, len,
-							flags, e);
+		return nft_rule_expr_meta_snprintf_json(buf, len, e);
 	default:
 		break;
 	}
-- 
1.8.3.2

