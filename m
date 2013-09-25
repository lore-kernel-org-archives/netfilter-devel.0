From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/2] set_elem: xml: avoid code duplication
Date: Thu, 26 Sep 2013 00:13:02 +0200
Message-ID: <20130925221302.16997.17406.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34150 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755978Ab3IYWNO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:13:14 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 702D351ED83
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 22:13:10 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sg4wFVx2w45x for <netfilter-devel@vger.kernel.org>;
	Thu, 26 Sep 2013 00:13:05 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 051F751ED6B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2013 00:13:04 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes 3x code duplication in the XML snprintf function.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/set_elem.c |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index a9e0751..885893b 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -519,7 +519,7 @@ static int nft_set_elem_snprintf_default(char *buf, size_t size,
 static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 				     struct nft_set_elem *e, uint32_t flags)
 {
-	int ret, len = size, offset = 0;
+	int ret, len = size, offset = 0, type = DATA_NONE;
 
 	ret = snprintf(buf, size, "<set_elem>"
 				"<flags>%u</flags><key>",
@@ -533,33 +533,19 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
 	ret = snprintf(buf+offset, size, "</key>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA)) {
-		ret = snprintf(buf+offset, size, "<data>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
-					    NFT_RULE_O_XML, flags, DATA_VALUE);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = snprintf(buf+offset, size, "</data>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	} else if (e->flags & (1 << NFT_SET_ELEM_ATTR_VERDICT)) {
-		ret = snprintf(buf+offset, size, "<data>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
-		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
-					    NFT_RULE_O_XML, flags,
-					    DATA_VERDICT);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA))
+		type = DATA_VALUE;
+	else if (e->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN))
+		type = DATA_CHAIN;
+	else if (e->flags & (1 << NFT_SET_ELEM_ATTR_VERDICT))
+		type = DATA_VERDICT;
 
-		ret = snprintf(buf+offset, size, "</data>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	} else if (e->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN)) {
+	if (type != DATA_NONE) {
 		ret = snprintf(buf+offset, size, "<data>");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
-					    NFT_RULE_O_XML, flags, DATA_CHAIN);
+					    NFT_RULE_O_XML, flags, type);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 		ret = snprintf(buf+offset, size, "</data>");

