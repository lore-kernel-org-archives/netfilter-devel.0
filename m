From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 13/21] data_reg: xml: len node shows byte length
Date: Wed, 26 Jun 2013 13:37:12 +0200
Message-ID: <20130626113711.23511.78782.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54694 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751941Ab3FZLhU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:20 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous to this patch, the <len> node was 'how many <dataN> nodes we have'.

Now, the <len> node means 'how many bytes are in <dataN> nodes'.


Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c      |   13 ++++++-------
 test/nft-rule-xml-add.sh |    8 ++++----
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 5eb7f38..b8b8d66 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -132,7 +132,7 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 {
 	mxml_node_t *tree = NULL;
 	mxml_node_t *node = NULL;
-	int i, len;
+	int i;
 	int64_t tmp;
 	uint64_t utmp;
 	char *endptr;
@@ -152,7 +152,7 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 
 	/*
 	* <data_reg type="value">
-	*    <len>4</len>
+	*    <len>16</len>
 	*    <data0>0xc09a002a</data0>
 	*    <data1>0x2700cac1</data1>
 	*    <data2>0x00000000</data2>
@@ -183,11 +183,11 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 		mxmlDelete(tree);
 		return -1;
 	}
-	/* maybe also (len < 1 || len > 4) */
-	len = tmp;
+
+	reg->len = tmp;
 
 	/* Get and set <dataN> */
-	for (i = 0; i < len; i++) {
+	for (i = 0; i < reg->len/sizeof(uint32_t); i++) {
 		sprintf(node_name, "data%d", i);
 
 		node = mxmlFindElement(tree, tree, node_name, NULL,
@@ -205,7 +205,6 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 		reg->val[i] = utmp;
 	}
 
-	reg->len = sizeof(reg->val);
 
 	mxmlDelete(tree);
 	return 0;
@@ -265,7 +264,7 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 	ret = snprintf(buf, len, "<data_reg type=\"value\">");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	ret = snprintf(buf+offset, len, "<len>%d</len>", data_len);
+	ret = snprintf(buf+offset, len, "<len>%zd</len>", reg->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	for (i=0; i<data_len; i++) {
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
index 961b597..0bd08ff 100755
--- a/test/nft-rule-xml-add.sh
+++ b/test/nft-rule-xml-add.sh
@@ -46,7 +46,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
     <op>eq</op>
     <cmpdata>
       <data_reg type=\"value\">
-        <len>1</len>
+        <len>4</len>
         <data0>0x04000000</data0>
       </data_reg>
     </cmpdata>
@@ -62,7 +62,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
     <op>eq</op>
     <cmpdata>
       <data_reg type=\"value\">
-        <len>1</len>
+        <len>4</len>
         <data0>0x96d60496</data0>
       </data_reg>
     </cmpdata>
@@ -78,7 +78,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
     <op>eq</op>
     <cmpdata>
       <data_reg type=\"value\">
-        <len>1</len>
+        <len>4</len>
         <data0>0x96d60329</data0>
       </data_reg>
     </cmpdata>
@@ -94,7 +94,7 @@ XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version
     <op>eq</op>
     <cmpdata>
       <data_reg type=\"value\">
-        <len>1</len>
+        <len>4</len>
         <data0>0x06000000</data0>
       </data_reg>
     </cmpdata>

