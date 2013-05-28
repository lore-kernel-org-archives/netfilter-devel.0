From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: Fix conditional code in XML parsing
	functions
Date: Tue, 28 May 2013 17:06:31 +0200
Message-ID: <20130528150631.5282.3020.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53534 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934515Ab3E1PGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 11:06:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All the XML parsing chunk was conditional but the main function. I think is better to
do the conditional compilation by function, returning -1 and setting errno = EOPNOTSUPP.


Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 24497ff..be2b47a 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -25,9 +25,9 @@
 #include "data_reg.h"
 #include "internal.h"
 
-#ifdef XML_PARSING
 static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 {
+#ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	char *endptr;
@@ -76,12 +76,15 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+#else
 	errno = EOPNOTSUPP;
 	return -1;
+#endif
 }
 
 static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)
 {
+#ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 
@@ -128,10 +131,15 @@ static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+#else
+	errno = EOPNOTSUPP;
+	return -1;
+#endif
 }
 
 static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 {
+#ifdef XML_PARSING
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
 	int i, len;
@@ -211,10 +219,11 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
+#else
 	errno = EOPNOTSUPP;
 	return -1;
-}
 #endif
+}
 
 int nft_data_reg_xml_parse(union nft_data_reg *reg, char *xml)
 {

