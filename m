From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] utils: fix buffer reallocation of nft_fprinft()
Date: Fri, 09 May 2014 18:45:47 +0200
Message-ID: <20140509164547.7057.94412.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48634 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754465AbaEIQqC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 12:46:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When _snprintf() reports it would print n characters, that n doesn't include
the trailing \0 that snprintf adds.

Thus, we need to [re]allocate n+1 characters.

While at it, change the reallocation trigger. If the length of the buffer we
used is equals to the expanded string length, the output has been truncated.
In other words, if ret == bufsiz, then the trailing \0 is missing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/utils.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/utils.c b/src/utils.c
index 18917f5..b8094aa 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -195,12 +195,13 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 	int ret;
 
 	ret = snprintf_cb(buf, bufsiz, obj, type, flags);
-	if (ret > NFT_SNPRINTF_BUFSIZ) {
-		buf = calloc(1, ret);
+	if (ret >= NFT_SNPRINTF_BUFSIZ) {
+		bufsiz = ret + 1;
+
+		buf = calloc(1, bufsiz);
 		if (buf == NULL)
 			return -1;
 
-		bufsiz = ret;
 		ret = snprintf_cb(buf, bufsiz, obj, type, flags);
 	}
 

