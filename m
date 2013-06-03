From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/5] data_reg: xml: fix bytes movements
Date: Mon, 03 Jun 2013 22:44:51 +0200
Message-ID: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42339 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757088Ab3FCUoz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:44:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There was bad bits movements and calcules when XML printing/parsing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 74ebe76..7d26175 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -15,6 +15,7 @@
 #include <limits.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <netinet/in.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
@@ -205,7 +206,7 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 		reg->val[i] = utmp;
 	}
 
-	reg->len = sizeof(reg->val);
+	reg->len = len*sizeof(reg->val[0]);
 
 	mxmlDelete(tree);
 	return 0;
@@ -259,8 +260,9 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 				    union nft_data_reg *reg, uint32_t flags)
 {
 	int len = size, offset = 0, ret, i, j;
+	uint32_t be;
 	uint8_t *tmp;
-	int data_len = reg->len/sizeof(uint32_t);
+	int data_len = reg->len/sizeof(reg->val[0]);
 
 	ret = snprintf(buf, len, "<data_reg type=\"value\">");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -272,15 +274,17 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 		ret = snprintf(buf+offset, len, "<data%d>0x", i);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-		tmp = (uint8_t *)&reg->val[i];
+		be = htonl(reg->val[i]);
+		tmp = (uint8_t *)&be;
 
-		for (j=0; j<sizeof(int); j++) {
+		for (j = 0; j < sizeof(uint32_t); j++) {
 			ret = snprintf(buf+offset, len, "%.02x", tmp[j]);
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		}
 
 		ret = snprintf(buf+offset, len, "</data%d>", i);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
 	}
 
 	ret = snprintf(buf+offset, len, "</data_reg>");

