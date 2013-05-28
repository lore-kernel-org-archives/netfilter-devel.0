From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: Delete trailing space in snprintf_xml
Date: Tue, 28 May 2013 17:07:02 +0200
Message-ID: <20130528150702.5328.73876.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53553 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934474Ab3E1PHG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 11:07:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A minor cosmetic change. Delete the space before '>'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 5ebc1de..11e4de8 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -291,7 +291,7 @@ int nft_data_reg_value_snprintf_xml(char *buf, size_t size,
 	uint8_t *tmp;
 	int data_len = reg->len/sizeof(uint32_t);
 
-	ret = snprintf(buf, len, "<data_reg type=\"value\" >");
+	ret = snprintf(buf, len, "<data_reg type=\"value\">");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<len>%d</len>", data_len);
@@ -351,7 +351,7 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 		switch(output_format) {
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
-					"<data_reg type=\"verdict\" >"
+					"<data_reg type=\"verdict\">"
 						"<verdict>%d</verdict>"
 					"</data_reg>", reg->verdict);
 		case NFT_RULE_O_DEFAULT:
@@ -363,7 +363,7 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 		switch(output_format) {
 		case NFT_RULE_O_XML:
 			return snprintf(buf, size,
-					"<data_reg type=\"chain\" >"
+					"<data_reg type=\"chain\">"
 						"<chain>%s</chain>"
 					"</data_reg>", reg->chain);
 		case NFT_RULE_O_DEFAULT:

