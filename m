From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] src: xml: add versioning
Date: Mon, 27 May 2013 19:16:34 +0200
Message-ID: <20130527171634.4562.53398.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38953 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754379Ab3E0RQl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 13:16:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All XML chunks now have a "version" attribute to help in future changes.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/chain.c    |   18 +++++++++++++++---
 src/internal.h |    4 ++++
 src/rule.c     |   17 +++++++++++++++--
 src/table.c    |   18 ++++++++++++++++--
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 4146e6a..95c8807 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -14,6 +14,7 @@
 #include <endian.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <limits.h>
 #include <string.h>
 #include <netinet/in.h>
 #include <errno.h>
@@ -469,6 +470,17 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 	if (tree == NULL)
 		return -1;
 
+	/* Validate version */
+	if (mxmlElementGetAttr(tree, "version") == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
+	if (tmp == LLONG_MAX || *endptr || tmp != NFT_CHAIN_XML_VERSION) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	/* Get and set <chain name="xxx" ... >*/
 	if (mxmlElementGetAttr(tree, "name") == NULL) {
 		mxmlDelete(tree);
@@ -643,7 +655,7 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 {
 	return snprintf(buf, size,
 		"<chain name=\"%s\" handle=\"%lu\""
-			" bytes=\"%lu\" packets=\"%lu\">"
+			" bytes=\"%lu\" packets=\"%lu\" version=\"%d\" >"
 			"<properties>"
 				"<type>%s</type>"
 				"<table>%s</table>"
@@ -655,8 +667,8 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 			"</properties>"
 		"</chain>",
 			c->name, c->handle, c->bytes, c->packets,
-			c->type, c->table, c->prio, c->use, c->hooknum,
-			c->policy, c->family);
+			NFT_CHAIN_XML_VERSION, c->type, c->table,
+			c->prio, c->use, c->hooknum, c->policy, c->family);
 }
 
 static int nft_chain_snprintf_default(char *buf, size_t size, struct nft_chain *c)
diff --git a/src/internal.h b/src/internal.h
index b3c3642..3ad5e89 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -17,6 +17,10 @@
 #include <mxml.h>
 #endif
 
+#define NFT_TABLE_XML_VERSION 0
+#define NFT_CHAIN_XML_VERSION 0
+#define NFT_RULE_XML_VERSION 0
+
 struct expr_ops;
 
 struct nft_rule_expr {
diff --git a/src/rule.c b/src/rule.c
index 318ae07..9785c24 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -14,6 +14,7 @@
 #include <endian.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <limits.h>
 #include <string.h>
 #include <netinet/in.h>
 #include <errno.h>
@@ -454,6 +455,17 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 	if (tree == NULL)
 		return -1;
 
+	/* validate XML version <rule ... version=X ... > */
+	if (mxmlElementGetAttr(tree, "version") == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+	tmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
+	if (tmp == LLONG_MAX || *endptr || tmp != NFT_RULE_XML_VERSION) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	/* get and set <rule ... family=X ... > */
 	if (mxmlElementGetAttr(tree, "family") == NULL) {
 		mxmlDelete(tree);
@@ -629,9 +641,10 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 
 	ret = snprintf(buf, size,
 		"<rule family=\"%u\" table=\"%s\" "
-			"chain=\"%s\" handle=\"%llu\"> ",
+			"chain=\"%s\" handle=\"%llu\" version=\"%d\"> ",
 				r->family, r->table, r->chain,
-				(unsigned long long)r->handle);
+				(unsigned long long)r->handle,
+				NFT_RULE_XML_VERSION);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<rule_flags>%u</rule_flags>"
diff --git a/src/table.c b/src/table.c
index 70f482d..a868da4 100644
--- a/src/table.c
+++ b/src/table.c
@@ -203,6 +203,7 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 	mxml_node_t *node = NULL;
 	char *endptr = NULL;
 	uint64_t tmp;
+	int64_t stmp;
 
 	/* NOTE: all XML nodes are mandatory */
 
@@ -211,6 +212,18 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 	if (tree == NULL)
 		return -1;
 
+	/* Check the version of the XML */
+	if (mxmlElementGetAttr(tree, "version") == NULL) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+	stmp = strtoll(mxmlElementGetAttr(tree, "version"), &endptr, 10);
+	if (stmp == LLONG_MAX || *endptr || stmp != NFT_TABLE_XML_VERSION) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
 	/* Get and set the name of the table */
 	if (mxmlElementGetAttr(tree, "name") == NULL) {
 		mxmlDelete(tree);
@@ -290,13 +303,14 @@ EXPORT_SYMBOL(nft_table_parse);
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
 	return snprintf(buf, size,
-			"<table name=\"%s\">"
+			"<table name=\"%s\" version=\"%d\">"
 				"<properties>"
 					"<family>%u</family>"
 					"<table_flags>%d</table_flags>"
 				"</properties>"
 			"</table>" ,
-			t->name, t->family, t->table_flags);
+			t->name, NFT_TABLE_XML_VERSION,
+			t->family, t->table_flags);
 }
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)

