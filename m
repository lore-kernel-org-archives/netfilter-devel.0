From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] src: improve printing of XML/JSON event wrapper
 header/footer
Date: Mon, 25 Aug 2014 15:02:27 +0200
Message-ID: <20140825130227.23329.41536.stgit@nfdev.cica.es>
References: <20140825130221.23329.86583.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38774 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755458AbaHYNCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:02:37 -0400
In-Reply-To: <20140825130221.23329.86583.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the nft_fprintf() helper. The helper handles \0 properly.

Before this patch, we get trash in the output due to the buffer being printed
without any \0.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/common.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/src/common.c b/src/common.c
index 3ceb811..a6f2508 100644
--- a/src/common.c
+++ b/src/common.c
@@ -114,14 +114,15 @@ int nft_event_header_snprintf(char *buf, size_t size, uint32_t type,
 	return ret;
 }
 
-int nft_event_header_fprintf(FILE *fp, uint32_t type, uint32_t flags)
+static int nft_event_header_fprintf_cb(char *buf, size_t size, void *unused,
+				       uint32_t type, uint32_t flags)
 {
-	char buf[64]; /* enough for the maximum string length above */
-
-	nft_event_header_snprintf(buf, sizeof(buf), type, flags);
-	buf[sizeof(buf) - 1] = '\0';
+	return nft_event_header_snprintf(buf, size, type, flags);
+}
 
-	return fprintf(fp, "%s", buf);
+int nft_event_header_fprintf(FILE *fp, uint32_t type, uint32_t flags)
+{
+	return nft_fprintf(fp, NULL, type, flags, nft_event_header_fprintf_cb);
 }
 
 int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
@@ -140,6 +141,17 @@ int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
 	}
 }
 
+static int nft_event_footer_fprintf_cb(char *buf, size_t size, void *unused,
+				       uint32_t type, uint32_t flags)
+{
+	return nft_event_footer_snprintf(buf, size, type, flags);
+}
+
+int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
+{
+	return nft_fprintf(fp, NULL, type, flags, nft_event_footer_fprintf_cb);
+}
+
 static void nft_batch_build_hdr(char *buf, uint16_t type, uint32_t seq)
 {
 	struct nlmsghdr *nlh;
@@ -168,16 +180,6 @@ void nft_batch_end(char *buf, uint32_t seq)
 }
 EXPORT_SYMBOL(nft_batch_end);
 
-int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
-{
-	char buf[32]; /* enough for the maximum string length above */
-
-	nft_event_footer_snprintf(buf, sizeof(buf), type, flags);
-	buf[sizeof(buf) - 1] = '\0';
-
-	return fprintf(fp, "%s", buf);
-}
-
 int nft_batch_is_supported(void)
 {
 	struct mnl_socket *nl;

