From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 4/5] expr: xml: don't print target&match info
Date: Mon, 03 Jun 2013 22:44:55 +0200
Message-ID: <20130603204455.27713.59163.stgit@nfdev.cica.es>
References: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42352 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758113Ab3FCUo5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:44:57 -0400
In-Reply-To: <20130603204451.27713.51887.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As is not supported in parsing, don't print at all target&match <info> attribute.

However, I think this could be easily supported, with the drawback of having a XML file full of binary data.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/match.c  |   12 +-----------
 src/expr/target.c |   12 +-----------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index edb78ea..4f8d8fc 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -245,22 +245,12 @@ static int nft_rule_expr_match_snprintf_xml(char *buf, size_t len,
 					    struct nft_expr_match *mt)
 {
 	int ret, size=len;
-	int i;
 	int offset = 0;
-	uint8_t *data = (uint8_t *)mt->data;
 
-	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev><info>0x",
+	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev>",
 				mt->name, mt->rev);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	for (i=0; i < mt->data_len; i++) {
-	        ret = snprintf(buf+offset, len, "%x", data[i] & 0xff);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = snprintf(buf+offset, len, "</info>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	return offset;
 }
 
diff --git a/src/expr/target.c b/src/expr/target.c
index 6652c47..bcdf034 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -249,22 +249,12 @@ int nft_rule_exp_target_snprintf_xml(char *buf, size_t len,
 				struct nft_expr_target *tg)
 {
 	int ret, size=len;
-	int i;
 	int offset = 0;
-	uint8_t *data = (uint8_t *)tg->data;
 
-	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev><info>0x",
+	ret = snprintf(buf, len, "<name>%s</name><rev>%u</rev>",
 			tg->name, tg->rev);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-	for (i=0; i < tg->data_len; i++) {
-		ret = snprintf(buf+offset, len, "%x", data[i] & 0xff);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	ret = snprintf(buf+offset, len, "</info>");
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-
 	return offset;
 }
 

