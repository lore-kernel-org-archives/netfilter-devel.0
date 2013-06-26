From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 17/21] exthdr: xml: use string for type node
Date: Wed, 26 Jun 2013 13:37:17 +0200
Message-ID: <20130626113716.23511.49932.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54706 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752118Ab3FZLhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:25 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements using a string for the <type> node.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/exthdr.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 762facd..3cccc28 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -25,6 +25,10 @@
 
 #include "expr_ops.h"
 
+#ifndef IPPROTO_MH
+#define IPPROTO_MH 135
+#endif
+
 struct nft_expr_exthdr {
 	enum nft_registers	dreg;
 	uint8_t			type;
@@ -171,6 +175,41 @@ nft_rule_expr_exthdr_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+static const char *exthdr_type2str(uint32_t type)
+{
+	switch (type) {
+	case IPPROTO_HOPOPTS:
+		return "hopopts";
+	case IPPROTO_ROUTING:
+		return "routing";
+	case IPPROTO_FRAGMENT:
+		return "fragment";
+	case IPPROTO_DSTOPTS:
+		return "dstopts";
+	case IPPROTO_MH:
+		return "mh";
+	default:
+		return "unknown";
+	}
+}
+
+static int str2exthdr_type(char *str)
+{
+	if (strcmp(str, "hopopts") == 0)
+		return IPPROTO_HOPOPTS;
+	else if (strcmp(str, "routing") == 0)
+		return IPPROTO_ROUTING;
+	else if (strcmp(str, "fragment") == 0)
+		return IPPROTO_FRAGMENT;
+	else if (strcmp(str, "dstopts") == 0)
+		return IPPROTO_DSTOPTS;
+	else if (strcmp(str, "mh") == 0)
+		return IPPROTO_MH;
+
+	return -1;
+}
+
+
 static int
 nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, char *xml)
 {
@@ -226,13 +265,12 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+	if (str2exthdr_type(node->child->value.opaque) < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	exthdr->type = tmp;
+	exthdr->type = str2exthdr_type(node->child->value.opaque);
 	e->flags |= (1 << NFT_EXPR_EXTHDR_TYPE);
 
 	/* Get and set <offset> */
@@ -285,9 +323,10 @@ nft_rule_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 	switch(type) {
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<type>%u</type><offset>%u</offset>"
+					  "<type>%s</type><offset>%u</offset>"
 					  "<len>%u</len>",
-					exthdr->dreg, exthdr->type,
+					exthdr->dreg,
+					exthdr_type2str(exthdr->type),
 					exthdr->offset, exthdr->len);
 
 	case NFT_RULE_O_DEFAULT:

