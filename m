From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 11/21] exthdr: xml: fix mandatory elements
Date: Wed, 26 Jun 2013 13:37:09 +0200
Message-ID: <20130626113709.23511.24896.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54687 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab3FZLhR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:17 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to net/netfilter/nft_exthdr.c: nft_exthdr_init(),
all of dreg, type, offset and len are mandatory:

if (tb[NFTA_EXTHDR_DREG] == NULL ||
    tb[NFTA_EXTHDR_TYPE] == NULL ||
    tb[NFTA_EXTHDR_OFFSET] == NULL ||
    tb[NFTA_EXTHDR_LEN] == NULL)
	return -EINVAL;

So the XML parser must make sure the equivalent nodes exists.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/exthdr.c |   95 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 40 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 7e16878..762facd 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -195,64 +195,79 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
-	/* Get and set <dreg>. Not mandatory */
+	/* All nodes are mandatory */
+
+	/* Get and set <dreg> */
 	node = mxmlFindElement(tree, tree, "dreg", NULL, NULL,
 			       MXML_DESCEND_FIRST);
-	if (node != NULL) {
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
+	if (node == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
 
-		if (tmp > NFT_REG_MAX) {
-			mxmlDelete(tree);
-			return -1;
-		}
+	tmp = strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
+	}
 
-		exthdr->dreg = tmp;
-		e->flags |= (1 << NFT_EXPR_EXTHDR_DREG);
+	if (tmp > NFT_REG_MAX) {
+		mxmlDelete(tree);
+		return -1;
 	}
 
-	/* Get and set <type>. Not mandatory */
+	exthdr->dreg = tmp;
+	e->flags |= (1 << NFT_EXPR_EXTHDR_DREG);
+
+	/* Get and set <type> */
 	node = mxmlFindElement(tree, tree, "type", NULL, NULL, MXML_DESCEND);
-	if (node != NULL) {
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
+	if (node == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
 
-		exthdr->type = tmp;
-		e->flags |= (1 << NFT_EXPR_EXTHDR_TYPE);
+	tmp = strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
 	}
 
-	/* Get and set <offset>. Not mandatory */
+	exthdr->type = tmp;
+	e->flags |= (1 << NFT_EXPR_EXTHDR_TYPE);
+
+	/* Get and set <offset> */
 	node = mxmlFindElement(tree, tree, "offset", NULL, NULL,
 			       MXML_DESCEND);
-	if (node != NULL) {
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT_MAX || tmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
+	if (node == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
 
-		exthdr->offset = tmp;
-		e->flags |= (1 << NFT_EXPR_EXTHDR_OFFSET);
+	tmp = strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
 	}
 
-	/* Get and set <len>. Not mandatory */
+	exthdr->offset = tmp;
+	e->flags |= (1 << NFT_EXPR_EXTHDR_OFFSET);
+
+	/* Get and set <len> */
 	node = mxmlFindElement(tree, tree, "len", NULL, NULL, MXML_DESCEND);
-	if (node != NULL) {
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT_MAX || tmp < 0 || *endptr) {
-			mxmlDelete(tree);
-			return -1;
-		}
+	if (node == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
 
-		exthdr->len = tmp;
-		e->flags |= (1 << NFT_EXPR_EXTHDR_LEN);
+	tmp = strtoull(node->child->value.opaque, &endptr, 10);
+	if (tmp > UINT_MAX || tmp < 0 || *endptr) {
+		mxmlDelete(tree);
+		return -1;
 	}
+
+	exthdr->len = tmp;
+	e->flags |= (1 << NFT_EXPR_EXTHDR_LEN);
+
 	mxmlDelete(tree);
 	return 0;
 #else

