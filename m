Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838ECC0651F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 18:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DD4218A0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 18:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfGDSSQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 14:18:16 -0400
Received: from mail.us.es ([193.147.175.20]:46874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfGDSSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 14:18:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92C57B6C66
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2019 20:18:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 863A8DA7B6
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2019 20:18:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7BE54DA732; Thu,  4 Jul 2019 20:18:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D5DCDA704;
        Thu,  4 Jul 2019 20:18:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Jul 2019 20:18:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 35AC74265A31;
        Thu,  4 Jul 2019 20:18:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH] utils: inline xmalloc(), xzalloc() and xfree()
Date:   Thu,  4 Jul 2019 20:18:09 +0200
Message-Id: <20190704181809.31388-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

So these functions can be used from main.c and cli.c.

This patch reverts 7c0407c5ca53 ("nft: don't use xzalloc()").

Suggested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h | 29 ++++++++++++++++++++++++++---
 src/main.c      |  8 +-------
 src/utils.c     | 24 ------------------------
 3 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 647e8bbe0030..5f3f49d2e87a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -128,11 +128,34 @@ extern void __memory_allocation_error(const char *filename, uint32_t line) __nor
 #define memory_allocation_error()		\
 	__memory_allocation_error(__FILE__, __LINE__);
 
-extern void xfree(const void *ptr);
-extern void *xmalloc(size_t size);
+static inline void *xmalloc(size_t size)
+{
+	void *ptr;
+
+	ptr = malloc(size);
+	if (ptr == NULL)
+		memory_allocation_error();
+
+	return ptr;
+}
+
+static inline void *xzalloc(size_t size)
+{
+	void *ptr;
+
+	ptr = xmalloc(size);
+	memset(ptr, 0, size);
+
+	return ptr;
+}
+
+static inline void xfree(const void *ptr)
+{
+	free((void *)ptr);
+}
+
 extern void *xmalloc_array(size_t nmemb, size_t size);
 extern void *xrealloc(void *ptr, size_t size);
-extern void *xzalloc(size_t size);
 extern char *xstrdup(const char *s);
 extern void xstrunescape(const char *in, char *out);
 
diff --git a/src/main.c b/src/main.c
index 8e6c897cdd36..cbfd69a42d04 100644
--- a/src/main.c
+++ b/src/main.c
@@ -19,7 +19,6 @@
 #include <sys/types.h>
 
 #include <nftables/libnftables.h>
-#include <nftables.h>
 #include <utils.h>
 #include <cli.h>
 
@@ -303,12 +302,7 @@ int main(int argc, char * const *argv)
 		for (len = 0, i = optind; i < argc; i++)
 			len += strlen(argv[i]) + strlen(" ");
 
-		buf = calloc(1, len);
-		if (buf == NULL) {
-			fprintf(stderr, "%s:%u: Memory allocation failure\n",
-				__FILE__, __LINE__);
-			exit(NFT_EXIT_NOMEM);
-		}
+		buf = xzalloc(len);
 		for (i = optind; i < argc; i++) {
 			strcat(buf, argv[i]);
 			if (i + 1 < argc)
diff --git a/src/utils.c b/src/utils.c
index 47f5b791547b..da7547d8b989 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -24,21 +24,6 @@ void __noreturn __memory_allocation_error(const char *filename, uint32_t line)
 	exit(NFT_EXIT_NOMEM);
 }
 
-void xfree(const void *ptr)
-{
-	free((void *)ptr);
-}
-
-void *xmalloc(size_t size)
-{
-	void *ptr;
-
-	ptr = malloc(size);
-	if (ptr == NULL)
-		memory_allocation_error();
-	return ptr;
-}
-
 void *xmalloc_array(size_t nmemb, size_t size)
 {
 	assert(size != 0);
@@ -58,15 +43,6 @@ void *xrealloc(void *ptr, size_t size)
 	return ptr;
 }
 
-void *xzalloc(size_t size)
-{
-	void *ptr;
-
-	ptr = xmalloc(size);
-	memset(ptr, 0, size);
-	return ptr;
-}
-
 char *xstrdup(const char *s)
 {
 	char *res;
-- 
2.11.0

