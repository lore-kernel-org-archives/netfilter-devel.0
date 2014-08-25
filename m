From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] utils: ensure \0 is in place in nft_fprintf()
Date: Mon, 25 Aug 2014 15:02:21 +0200
Message-ID: <20140825130221.23329.86583.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38769 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754311AbaHYNCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:02:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We must make sure the buffer contains a \0 in the last position,
to avoid printing trash by the last fprintf() call.

This is needed because if the internal snprintf callback prints nothing,
no \0 exists in the buffer.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/utils.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/utils.c b/src/utils.c
index 96c8bf2..8a7c521 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -189,6 +189,8 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 	size_t bufsiz = sizeof(_buf);
 	int ret;
 
+	buf[0] = '\0';
+
 	ret = snprintf_cb(buf, bufsiz, obj, type, flags);
 	if (ret < 0)
 		goto out;
@@ -200,6 +202,8 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 		if (buf == NULL)
 			return -1;
 
+		buf[0] = '\0';
+
 		ret = snprintf_cb(buf, bufsiz, obj, type, flags);
 		if (ret < 0)
 			goto out;

