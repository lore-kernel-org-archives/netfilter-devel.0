From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: conditional XML code for snprintf_xml
Date: Tue, 28 May 2013 17:06:21 +0200
Message-ID: <20130528150621.5259.2187.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53531 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934512Ab3E1PGX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 11:06:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Having or not XML parsing support doesn't break XML printing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index c0a048c..24497ff 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -262,7 +262,6 @@ static
 int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 				    union nft_data_reg *reg, uint32_t flags)
 {
-#ifdef XML_PARSING
 	int len = size, offset = 0, ret, i, j;
 	uint8_t *tmp;
 	int data_len = reg->len/sizeof(uint32_t);
@@ -292,10 +291,6 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
-#else
-	errno = EOPNOTSUPP;
-	return -1;
-#endif
 }
 
 static int

