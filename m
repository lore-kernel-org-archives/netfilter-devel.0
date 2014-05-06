From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] data_reg: fix bad buffer size bounds
Date: Tue, 06 May 2014 19:19:46 +0200
Message-ID: <20140506171946.4163.82349.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56275 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751111AbaEFRUA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 13:20:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These calls need to use the new buffer size, instead of the
size that the buffer originally had.

Bugs introduced by myself at dec68741 [data_reg: fix verdict format approach].

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 0523cb7..44281f7 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -304,7 +304,7 @@ nft_data_reg_verdict_snprintf_def(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (reg->chain != NULL) {
-		ret = snprintf(buf+offset, size, "-> %s ", reg->chain);
+		ret = snprintf(buf+offset, len, "-> %s ", reg->chain);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
@@ -322,12 +322,12 @@ nft_data_reg_verdict_snprintf_xml(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (reg->chain != NULL) {
-		ret = snprintf(buf+offset, size, "<chain>%s</chain>",
+		ret = snprintf(buf+offset, len, "<chain>%s</chain>",
 			       reg->chain);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "</data_reg>");
+	ret = snprintf(buf+offset, len, "</data_reg>");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
@@ -344,12 +344,12 @@ nft_data_reg_verdict_snprintf_json(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (reg->chain != NULL) {
-		ret = snprintf(buf+offset, size, ",\"chain\":\"%s\"",
+		ret = snprintf(buf+offset, len, ",\"chain\":\"%s\"",
 			       reg->chain);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf+offset, size, "}");
+	ret = snprintf(buf+offset, len, "}");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;

