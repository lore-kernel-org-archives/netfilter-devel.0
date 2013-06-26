From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 03/21] rule: xml: conditional compat info
Date: Wed, 26 Jun 2013 13:36:59 +0200
Message-ID: <20130626113659.23511.43891.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54653 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751992Ab3FZLhI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:08 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The compat XML info is now conditional both when printing and parsing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |   59 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 380b9ae..53b0e3b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -571,37 +571,33 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	r->rule_flags = (uint32_t)tmp;
 	r->flags |= (1 << NFT_RULE_ATTR_FLAGS);
 
-	/* get and set <compat_proto> */
+	/* <compat_proto> is optional */
 	node = mxmlFindElement(tree, tree, "compat_proto", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node != NULL) {
+		tmp = strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
 
-	r->compat.proto = (uint32_t)tmp;
-	r->flags |= (1 << NFT_RULE_ATTR_COMPAT_PROTO);
+		r->compat.proto = tmp;
+		r->flags |= (1 << NFT_RULE_ATTR_COMPAT_PROTO);
+	}
 
-	/* get and set <compat_flags> */
+	/* <compat_flags> is optional */
 	node = mxmlFindElement(tree, tree, "compat_flags", NULL, NULL,
 			       MXML_DESCEND);
-	if (node == NULL) {
-		mxmlDelete(tree);
-		return -1;
-	}
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
-		mxmlDelete(tree);
-		return -1;
-	}
+	if (node != NULL) {
+		tmp = strtoull(node->child->value.opaque, &endptr, 10);
+		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+			mxmlDelete(tree);
+			return -1;
+		}
 
-	r->compat.flags = (uint32_t)tmp;
-	r->flags |= (1 << NFT_RULE_ATTR_COMPAT_FLAGS);
+		r->compat.flags = tmp;
+		r->flags |= (1 << NFT_RULE_ATTR_COMPAT_FLAGS);
+	}
 
 	/* Iterating over <expr> */
 	for (node = mxmlFindElement(tree, tree, "expr", "type",
@@ -684,13 +680,18 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 				NFT_RULE_XML_VERSION);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>"
-					"<compat_flags>%u</compat_flags>"
-					"<compat_proto>%u</compat_proto>",
-					r->rule_flags,
-					r->compat.flags, r->compat.proto);
+	ret = snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>",
+		       r->rule_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (r->compat.flags != 0 || r->compat.proto != 0) {
+		ret = snprintf(buf+offset, len,
+			       "<compat_flags>%u</compat_flags>"
+			       "<compat_proto>%u</compat_proto>",
+			       r->compat.flags, r->compat.proto);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	list_for_each_entry(expr, &r->expr_list, head) {
 		ret = snprintf(buf+offset, len,
 				"<expr type=\"%s\">", expr->ops->name);

