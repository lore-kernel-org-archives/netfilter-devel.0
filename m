From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] ct: fix dir, is optional
Date: Fri, 17 Jan 2014 02:15:06 +0100
Message-ID: <20140117011505.11704.46463.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60394 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310AbaAQBPS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:15:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dir attribute is optional as stated in the kernel sources.

Previous to this patch, using XML/JSON to manage this expr produces some
undefined and erroneous behaviours.

While at it, fix also the default output format.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/ct.c |   63 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index e960134..3442f06 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -258,14 +258,12 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 	e->flags |= (1 << NFT_EXPR_CT_KEY);
 
 	if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_DEC,
-			       &dir, NFT_TYPE_U8, NFT_XML_MAND, err) != 0)
-		return -1;
-
-	if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
-		goto err;
+			       &dir, NFT_TYPE_U8, NFT_XML_OPT, err) == 0) {
+		if (dir != IP_CT_DIR_ORIGINAL && dir != IP_CT_DIR_REPLY)
+			goto err;
 
-	ct->dir = dir;
-	e->flags |= (1 << NFT_EXPR_CT_DIR);
+		nft_rule_expr_set_u8(e, NFT_EXPR_CT_DIR, dir);
+	}
 
 	return 0;
 err:
@@ -292,30 +290,63 @@ nft_expr_ct_snprintf_json(char *buf, size_t size, struct nft_rule_expr *e)
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	if (e->flags & (1 << NFT_EXPR_CT_DIR)) {
+	if (nft_rule_expr_is_set(e, NFT_EXPR_CT_DIR)) {
 		ret = snprintf(buf+offset, len, ",\"dir\":%u", ct->dir);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	return offset;
+}
 
+static int
+nft_expr_ct_snprintf_xml(char *buf, size_t size, struct nft_rule_expr *e)
+{
+	int ret, len = size, offset = 0;
+	struct nft_expr_ct *ct = nft_expr_data(e);
+
+	ret = snprintf(buf, len, "<dreg>%u</dreg>", ct->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, len, "<key>%s</key>",
+		       ctkey2str(ct->key));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (nft_rule_expr_is_set(e, NFT_EXPR_CT_DIR)) {
+		ret = snprintf(buf+offset, len, "<dir>%u</dir>", ct->dir);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
 }
 
 static int
-nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
-			    uint32_t flags, struct nft_rule_expr *e)
+nft_expr_ct_snprintf_default(char *buf, size_t size, struct nft_rule_expr *e)
 {
+	int ret, len = size, offset = 0;
 	struct nft_expr_ct *ct = nft_expr_data(e);
 
+	ret = snprintf(buf, len, "load %s => reg %u ",
+		       ctkey2str(ct->key), ct->dreg);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+
+	if (nft_rule_expr_is_set(e, NFT_EXPR_CT_DIR)) {
+		ret = snprintf(buf+offset, len, "dir %u ", ct->dir);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int
+nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
+			    uint32_t flags, struct nft_rule_expr *e)
+{
 	switch(type) {
 	case NFT_OUTPUT_DEFAULT:
-		return snprintf(buf, len, "load %s => reg %u dir %u ",
-				ctkey2str(ct->key), ct->dreg, ct->dir);
+		return nft_expr_ct_snprintf_default(buf, len, e);
 	case NFT_OUTPUT_XML:
-		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%s</key>"
-					  "<dir>%u</dir>",
-				ct->dreg, ctkey2str(ct->key), ct->dir);
+		return nft_expr_ct_snprintf_xml(buf, len, e);
 	case NFT_OUTPUT_JSON:
 		return nft_expr_ct_snprintf_json(buf, len, e);
 	default:

