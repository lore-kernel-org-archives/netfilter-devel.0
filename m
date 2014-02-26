From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] src: add assertion infrastructure to validate attribute types
Date: Wed, 26 Feb 2014 02:51:54 +0100
Message-ID: <1393379519-16189-3-git-send-email-pablo@netfilter.org>
References: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40462 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaBZBwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:09 -0500
In-Reply-To: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be used to validate that the size is correct according
to the expected attribute size.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/internal.h |   13 +++++++++++++
 src/utils.c    |    7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/src/internal.h b/src/internal.h
index a3fc46f..3216bc6 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -187,4 +187,17 @@ struct nft_set_elem {
 
 #define __init __attribute__((constructor))
 
+void __nft_assert_fail(uint16_t attr, const char *filename, int line);
+
+#define nft_assert(attr, expr)				\
+  ((expr)						\
+   ? (void)0						\
+   : __nft_assert_fail(attr, __FILE__, __LINE__))
+
+#define nft_assert_validate(_validate_array, _attr, _data_len)		\
+({									\
+	if (_validate_array[_attr])					\
+		nft_assert(attr, _validate_array[_attr] == _data_len);	\
+})
+
 #endif
diff --git a/src/utils.c b/src/utils.c
index 9691c4c..18917f5 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -211,3 +211,10 @@ int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags,
 
 	return ret;
 }
+
+void __nft_assert_fail(uint16_t attr, const char *filename, int line)
+{
+	fprintf(stderr, "libnftnl: attribute %d assertion failed in %s:%d\n",
+		attr, filename, line);
+	exit(EXIT_FAILURE);
+}
-- 
1.7.10.4

