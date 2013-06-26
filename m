From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 14/21] data_reg: xml: fix bytes movements
Date: Wed, 26 Jun 2013 13:37:13 +0200
Message-ID: <20130626113713.23511.47779.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54697 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752091Ab3FZLhV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:21 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix wrong arithmetics when printing and parsing data registers in XML:

Previous to this patch, a uin32_t containing the number 2864434397
(0xaabbccdd) will be printed this way under some circumstances:

<data>0xddccbbaa</data>

Now, the data is ordered, the MSB position is controlled and snprintf prints:

<data>0xaabbccdd</data>

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index b8b8d66..c123d88 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -15,6 +15,7 @@
 #include <limits.h>
 #include <arpa/inet.h>
 #include <errno.h>
+#include <netinet/in.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter.h>
@@ -205,7 +206,6 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 		reg->val[i] = utmp;
 	}
 
-
 	mxmlDelete(tree);
 	return 0;
 }
@@ -258,6 +258,7 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 				    union nft_data_reg *reg, uint32_t flags)
 {
 	int len = size, offset = 0, ret, i, j;
+	uint32_t be;
 	uint8_t *tmp;
 	int data_len = reg->len/sizeof(uint32_t);
 
@@ -271,9 +272,10 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
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

