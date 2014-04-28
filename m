From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnetfilter_acct] src: fix broken output handling
Date: Mon, 28 Apr 2014 15:14:24 +0200
Message-ID: <1398690864-28322-1-git-send-email-pablo@netfilter.org>
Cc: mathieu.poirier@linaro.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46888 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbaD1NOe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:14:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In 948fa3b ("Extend accounting capabilities to support quotas"), the
error handling of snprintf is incorrect since this function may
return -1 on error. Add a new SNPRINTF_CHECK() macro to offload the
complicated handling of snprintf.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/internal.h          |   11 +++++++++++
 src/libnetfilter_acct.c |   21 ++++++++-------------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/src/internal.h b/src/internal.h
index 2106401..f0cc2e1 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -21,4 +21,15 @@
 #	endif
 #endif
 
+#define SNPRINTF_CHECK(ret, rem, offset, len)			\
+do {								\
+	if (ret < 0)						\
+		return ret;					\
+	len += ret;						\
+	if (ret > rem)						\
+		ret = rem;					\
+	offset += ret;						\
+	rem -= ret;						\
+} while (0)
+
 #endif
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 0c1a758..7f539b6 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -256,42 +256,37 @@ static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		      uint16_t flags)
 {
-	int ret, temp;
-	char *walking_buf;
-
-	temp = rem;
-	walking_buf = buf;
+	int ret, offset = 0, len = 0;
 
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
-		ret = snprintf(walking_buf, temp,
+		ret = snprintf(buf, rem,
 			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64"",
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES));
+		SNPRINTF_CHECK(ret, rem, offset, len);
 
 		if (nfacct->flags) {
 			uint32_t mode;
 
 			mode = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_FLAGS);
 
-			walking_buf += ret;
-			temp -= ret;
-			ret = snprintf(walking_buf, temp,
+			ret = snprintf(buf + offset, rem,
 				", quota = %.20"PRIu64", mode = %s",
 				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_QUOTA),
 				mode == NFACCT_F_QUOTA_BYTES ?
 				"byte" : "packet");
+			SNPRINTF_CHECK(ret, rem, offset, len);
 		}
 
-		walking_buf += ret;
-		temp -= ret;
-		ret = snprintf(walking_buf, temp, " } = %s;",
+		ret = snprintf(buf + offset, rem, " } = %s;",
 			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	} else {
 		ret = snprintf(buf, rem, "%s\n",
 			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	}
+	SNPRINTF_CHECK(ret, rem, offset, len);
 
-	return ret;
+	return len;
 }
 
 #define BUFFER_SIZE(ret, size, rem, offset)		\
-- 
1.7.10.4

