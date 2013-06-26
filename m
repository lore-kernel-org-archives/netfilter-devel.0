From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 10/21] ct: xml: use key's name string instead of
	numbers
Date: Wed, 26 Jun 2013 13:37:08 +0200
Message-ID: <20130626113708.23511.54545.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54683 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751941Ab3FZLhQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:16 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now ct expr will use a string representation instead of a numerical one in the <key> node.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/ct.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 3605ecc..2955353 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -22,6 +22,10 @@
 #include <libnftables/rule.h>
 #include "expr_ops.h"
 
+#ifndef NFT_CT_MAX
+#define NFT_CT_MAX (NFT_CT_PROTO_DST + 1)
+#endif
+
 struct nft_expr_ct {
 	enum nft_ct_keys        key;
 	uint32_t		dreg;	/* enum nft_registers */
@@ -150,6 +154,40 @@ nft_rule_expr_ct_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+const char *ctkey2str_array[NFT_CT_MAX] = {
+	[NFT_CT_STATE]		= "state",
+	[NFT_CT_DIRECTION]	= "direction",
+	[NFT_CT_STATUS]		= "status",
+	[NFT_CT_MARK]		= "mark",
+	[NFT_CT_SECMARK]	= "secmark",
+	[NFT_CT_EXPIRATION]	= "expiration",
+	[NFT_CT_HELPER]		= "helper",
+	[NFT_CT_PROTOCOL]	= "protocol",
+	[NFT_CT_SRC]		= "src",
+	[NFT_CT_DST]		= "dst",
+	[NFT_CT_PROTO_SRC]	= "proto_src",
+	[NFT_CT_PROTO_DST]	= "proto_dst"
+};
+
+static const char *ctkey2str(uint32_t ctkey)
+{
+	if (ctkey > NFT_CT_MAX)
+		return "unknown";
+
+	return ctkey2str_array[ctkey];
+}
+
+static int str2ctkey(char *ctkey)
+{
+	int i;
+
+	for (i = 0; i < NFT_CT_MAX; i++)
+		if (strcmp(ctkey2str_array[i], ctkey) == 0)
+			return i;
+
+	return -1;
+}
+
 static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, char *xml)
 {
 #ifdef XML_PARSING
@@ -188,11 +226,10 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, char *xml)
 	if (node == NULL)
 		goto err;
 
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
+	if (str2ctkey(node->child->value.opaque) < 0)
 		goto err;
 
-	ct->key = tmp;
+	ct->key = str2ctkey(node->child->value.opaque);
 	e->flags |= (1 << NFT_EXPR_CT_KEY);
 
 	node = mxmlFindElement(tree, tree, "dir", NULL, NULL, MXML_DESCEND);
@@ -229,13 +266,13 @@ nft_rule_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 
 	switch(type) {
 	case NFT_RULE_O_DEFAULT:
-		return snprintf(buf, len, "dreg=%u key=%u dir=%u ",
-				ct->dreg, ct->key, ct->dir);
+		return snprintf(buf, len, "dreg=%u key=%s dir=%u ",
+				ct->dreg, ctkey2str(ct->key), ct->dir);
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%u</key>"
+					  "<key>%s</key>"
 					  "<dir>%u</dir>",
-				ct->dreg, ct->key, ct->dir);
+				ct->dreg, ctkey2str(ct->key), ct->dir);
 	default:
 		break;
 	}

