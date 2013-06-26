From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 16/21] payload: xml: use string for base attribute
Date: Wed, 26 Jun 2013 13:37:15 +0200
Message-ID: <20130626113715.23511.94435.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54703 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817Ab3FZLhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:24 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements using a string instead of a number for the <base> node.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/payload.c       |   52 ++++++++++++++++++++++++++++++++++++++--------
 test/nft-rule-xml-add.sh |    6 +++--
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/src/expr/payload.c b/src/expr/payload.c
index dc42918..6740d99 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -212,13 +212,19 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, char *xml)
 	/* Get and set <base>. Not mandatory */
 	node = mxmlFindElement(tree, tree, "base", NULL, NULL, MXML_DESCEND);
 	if (node != NULL) {
-		tmp = strtoull(node->child->value.opaque, &endptr, 10);
-		if (tmp > UINT32_MAX || tmp < 0 || *endptr) {
+
+		if (strcmp(node->child->value.opaque, "link") == 0) {
+			payload->base = NFT_PAYLOAD_LL_HEADER;
+		} else if (strcmp(node->child->value.opaque, "network") == 0) {
+			payload->base = NFT_PAYLOAD_NETWORK_HEADER;
+		} else if (strcmp(node->child->value.opaque,
+				  "transport") == 0) {
+			payload->base = NFT_PAYLOAD_TRANSPORT_HEADER;
+		} else {
 			mxmlDelete(tree);
 			return -1;
 		}
 
-		payload->base = (uint32_t)tmp;
 		e->flags |= (1 << NFT_EXPR_PAYLOAD_BASE);
 	}
 
@@ -257,6 +263,38 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, char *xml)
 }
 
 static int
+nft_rule_expr_payload_snprintf_xml(char *buf, size_t len, uint32_t flags,
+				   struct nft_expr_payload *p)
+{
+	int size = len, offset = 0, ret;
+
+	ret = snprintf(buf, len, "<dreg>%u</dreg><offset>%u</offset>"
+		       "<len>%u</len>", p->dreg, p->offset, p->len);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	/* A default option is not provided.
+	 * The <base> node will be missing; Is not mandatory.
+	 */
+
+	switch (p->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		ret = snprintf(buf+offset, len, "<base>link</base>");
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		ret = snprintf(buf+offset, len, "<base>network</base>");
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		ret = snprintf(buf+offset, len, "<base>transport</base>");
+		break;
+	}
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+
+static int
 nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 			       uint32_t flags, struct nft_rule_expr *e)
 {
@@ -264,12 +302,8 @@ nft_rule_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_XML:
-		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<base>%u</base><offset>%u</offset>"
-					  "<len>%u</len>",
-				payload->dreg, payload->base,
-					payload->offset, payload->len);
-
+		return nft_rule_expr_payload_snprintf_xml(buf, len, flags,
+							  payload);
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "dreg=%u base=%u offset=%u len=%u ",
 				payload->dreg, payload->base,
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
index 322e70c..e1e35d9 100755
--- a/test/nft-rule-xml-add.sh
+++ b/test/nft-rule-xml-add.sh
@@ -53,7 +53,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
   </expr>
   <expr type=\"payload\">
     <dreg>1</dreg>
-    <base>1</base>
+    <base>transport</base>
     <offset>12</offset>
     <len>4</len>
   </expr>
@@ -69,7 +69,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
   </expr>
   <expr type=\"payload\">
     <dreg>1</dreg>
-    <base>1</base>
+    <base>link</base>
     <offset>16</offset>
     <len>4</len>
   </expr>
@@ -85,7 +85,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
   </expr>
   <expr type=\"payload\">
     <dreg>1</dreg>
-    <base>1</base>
+    <base>network</base>
     <offset>9</offset>
     <len>1</len>
   </expr>

