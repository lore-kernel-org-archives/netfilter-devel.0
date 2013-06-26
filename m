From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 18/21] meta: xml: use string to represent key
	attribute
Date: Wed, 26 Jun 2013 13:37:18 +0200
Message-ID: <20130626113718.23511.96954.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54706 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab3FZLh0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:26 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a string for <key> node instead of a number.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/meta.c          |   50 +++++++++++++++++++++++++++++++++++++++++-----
 test/nft-rule-xml-add.sh |    2 +-
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/src/expr/meta.c b/src/expr/meta.c
index 41fcff1..f3170e3 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -21,6 +21,10 @@
 #include <libnftables/rule.h>
 #include "expr_ops.h"
 
+#ifndef NFT_META_MAX
+#define NFT_META_MAX (NFT_META_SECMARK + 1)
+#endif
+
 struct nft_expr_meta {
 	uint8_t			key;	/* enum nft_meta_keys */
 	uint8_t			dreg;	/* enum nft_registers */
@@ -126,6 +130,43 @@ nft_rule_expr_meta_parse(struct nft_rule_expr *e, struct nlattr *attr)
 	return 0;
 }
 
+const char *meta_key2str_array[NFT_META_MAX] = {
+	[NFT_META_LEN]		= "len",
+	[NFT_META_PROTOCOL]	= "protocol",
+	[NFT_META_PRIORITY]	= "priority",
+	[NFT_META_MARK]		= "mark",
+	[NFT_META_IIF]		= "iif",
+	[NFT_META_OIF]		= "oif",
+	[NFT_META_IIFNAME]	= "iifname",
+	[NFT_META_OIFNAME]	= "oifname",
+	[NFT_META_IIFTYPE]	= "iiftype",
+	[NFT_META_OIFTYPE]	= "oiftype",
+	[NFT_META_SKUID]	= "skuid",
+	[NFT_META_SKGID]	= "skgid",
+	[NFT_META_NFTRACE]	= "nftrace",
+	[NFT_META_RTCLASSID]	= "rtclassid",
+	[NFT_META_SECMARK]	= "secmark",
+};
+
+static const char *meta_key2str(uint8_t key)
+{
+	if (key < NFT_META_MAX)
+		return meta_key2str_array[key];
+
+	return "unknown";
+}
+
+static int str2meta_key(const char *str)
+{
+	int i;
+
+	for (i = 0; i < NFT_META_MAX; i++)
+		if (strcmp(str, meta_key2str_array[i]) == 0)
+			return i;
+
+	return -1;
+}
+
 static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, char *xml)
 {
 #ifdef XML_PARSING
@@ -178,13 +219,12 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+	if (str2meta_key(node->child->value.opaque) < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	meta->key = (uint8_t)tmp;
+	meta->key = str2meta_key(node->child->value.opaque);
 	e->flags |= (1 << NFT_EXPR_META_KEY);
 
 	mxmlDelete(tree);
@@ -204,8 +244,8 @@ nft_rule_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 	switch(type) {
 	case NFT_RULE_O_XML:
 		return snprintf(buf, len, "<dreg>%u</dreg>"
-					  "<key>%u</key>",
-				meta->dreg, meta->key);
+					  "<key>%s</key>",
+				meta->dreg, meta_key2str(meta->key));
 	case NFT_RULE_O_DEFAULT:
 		return snprintf(buf, len, "dreg=%u key=%u ",
 				meta->dreg, meta->key);
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
index e1e35d9..2a052b2 100755
--- a/test/nft-rule-xml-add.sh
+++ b/test/nft-rule-xml-add.sh
@@ -39,7 +39,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
   <compat_proto>0</compat_proto>
   <expr type=\"meta\">
     <dreg>1</dreg>
-    <key>4</key>
+    <key>iif</key>
   </expr>
   <expr type=\"cmp\">
     <sreg>1</sreg>

