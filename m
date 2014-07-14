From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] common: events: be more strict when placing the \0
 character
Date: Mon, 14 Jul 2014 14:43:35 +0200
Message-ID: <20140714124335.13205.77982.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58381 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754250AbaGNMnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:43:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous to this patch, the code path can potentially print an empty
buffer with the \0 at the end of the buffer.

Be more strict and place the \0 character in the first position if the
buffer is empty.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/common.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/common.c b/src/common.c
index 1b600f1..c81a1d8 100644
--- a/src/common.c
+++ b/src/common.c
@@ -114,9 +114,10 @@ int nft_event_header_snprintf(char *buf, size_t size, uint32_t type,
 int nft_event_header_fprintf(FILE *fp, uint32_t type, uint32_t flags)
 {
 	char buf[64]; /* enough for the maximum string length above */
+	int ret;
 
-	nft_event_header_snprintf(buf, sizeof(buf), type, flags);
-	buf[sizeof(buf) - 1] = '\0';
+	ret = nft_event_header_snprintf(buf, sizeof(buf), type, flags);
+	buf[ret] = '\0';
 
 	return fprintf(fp, "%s", buf);
 }
@@ -140,9 +141,10 @@ int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
 int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
 {
 	char buf[32]; /* enough for the maximum string length above */
+	int ret;
 
-	nft_event_footer_snprintf(buf, sizeof(buf), type, flags);
-	buf[sizeof(buf) - 1] = '\0';
+	ret = nft_event_footer_snprintf(buf, sizeof(buf), type, flags);
+	buf[ret] = '\0';
 
 	return fprintf(fp, "%s", buf);
 }

