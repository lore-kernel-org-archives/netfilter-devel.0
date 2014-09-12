From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] utils: nft_fprintf: prevent an empty buffer from
 being printed
Date: Fri, 12 Sep 2014 21:41:25 +0200
Message-ID: <20140912194125.9222.51509.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40156 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752102AbaILTlh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:41:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the snprintf_cb() printed 0 characters, no \0 exists in the buffer.
Also, in that case fprintf() is meant to print nothing, so we can just exit.

This patch addresses new cases of textual output by libnftnl with trash.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/utils.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/utils.c b/src/utils.c
index 96c8bf2..d70fbf1 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -190,7 +190,7 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 	int ret;
 
 	ret = snprintf_cb(buf, bufsiz, obj, type, flags);
-	if (ret < 0)
+	if (ret <= 0)
 		goto out;
 
 	if (ret >= NFT_SNPRINTF_BUFSIZ) {
@@ -201,7 +201,7 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 			return -1;
 
 		ret = snprintf_cb(buf, bufsiz, obj, type, flags);
-		if (ret < 0)
+		if (ret <= 0)
 			goto out;
 	}
 

