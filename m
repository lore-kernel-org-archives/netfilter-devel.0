From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH v2] utils: fix buffer reallocation of nft_fprinft()
Date: Tue, 13 May 2014 11:17:49 +0200
Message-ID: <20140513091658.20413.10155.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60999 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759897AbaEMJSD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 05:18:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When _snprintf() reports it would print n characters, that n doesn't include
the trailing \0 that snprintf adds.

Thus, we need to [re]allocate n+1 characters.

While at it, change the reallocation trigger. If the length of the buffer we
used is equals to the expanded string length, the output has been truncated.
In other words, if ret == bufsiz, then the trailing \0 is missing.

Also, check if _snprintf() returned < 0, which means an error ocurred.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: check if snprintf() calls failed. Replace calloc with malloc.

 src/utils.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/utils.c b/src/utils.c
index 18917f5..20a2fa3 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -195,17 +195,24 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 	int ret;
 
 	ret = snprintf_cb(buf, bufsiz, obj, type, flags);
-	if (ret > NFT_SNPRINTF_BUFSIZ) {
-		buf = calloc(1, ret);
+	if (ret < 0)
+		goto out;
+
+	if (ret >= NFT_SNPRINTF_BUFSIZ) {
+		bufsiz = ret + 1;
+
+		buf = malloc(bufsiz);
 		if (buf == NULL)
 			return -1;
 
-		bufsiz = ret;
 		ret = snprintf_cb(buf, bufsiz, obj, type, flags);
+		if (ret < 0)
+			goto out;
 	}
 
 	ret = fprintf(fp, "%s", buf);
 
+out:
 	if (buf != _buf)
 		xfree(buf);
 

