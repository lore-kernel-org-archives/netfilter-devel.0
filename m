Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F08AC71156
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377651AbjHROMc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377650AbjHROM0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:12:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADC130FE
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692367899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M1Fh6VHkrpEfquhm7JcKcKgMF5Nn95aaWF0vdR16D5E=;
        b=QlPIQ8Y94DxzwNZ4KZsHBlHdBST8D5dXI32cq912mA1i6Qe///li2JJfIeaYt3o65+gHWn
        repLWTsOS0NSx84rc8QW60+/chK2DbX8Lq7cVE0gWNvovrUAQJZAJqX4+GPjv1MQWPqkN1
        SPhzETtP7kLb7OSQzE2IoaiWh0hB6fI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-tqwrKDYAOfCJLszP-wdCtg-1; Fri, 18 Aug 2023 10:11:37 -0400
X-MC-Unique: tqwrKDYAOfCJLszP-wdCtg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70E25185A78B
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 14:11:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E46E340C6E8A;
        Fri, 18 Aug 2023 14:11:36 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v3 2/3] nftutils: add wrappers for getprotoby{name,number}_r(), getservbyport_r()
Date:   Fri, 18 Aug 2023 16:08:20 +0200
Message-ID: <20230818141124.859037-3-thaller@redhat.com>
In-Reply-To: <20230818141124.859037-1-thaller@redhat.com>
References: <20230818141124.859037-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We should aim to use the thread-safe variants of getprotoby{name,number}
and getservbyport(). However, they may not be available with other libc,
so it requires a configure check. As that is cumbersome, add wrappers
that do that at one place.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 configure.ac   |  4 +++
 src/nftutils.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/nftutils.h | 16 +++++++++
 3 files changed, 117 insertions(+)

diff --git a/configure.ac b/configure.ac
index b0201ac3528e..42f0dc4cf392 100644
--- a/configure.ac
+++ b/configure.ac
@@ -108,6 +108,10 @@ AC_DEFINE([HAVE_LIBJANSSON], [1], [Define if you have libjansson])
 ])
 AM_CONDITIONAL([BUILD_JSON], [test "x$with_json" != xno])
 
+AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [], [[
+#include <netdb.h>
+]])
+
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
diff --git a/src/nftutils.c b/src/nftutils.c
index 758283d1b650..13f879ddc5c7 100644
--- a/src/nftutils.c
+++ b/src/nftutils.c
@@ -3,3 +3,100 @@
 #include <config.h>
 
 #include "nftutils.h"
+
+#include <netdb.h>
+#include <string.h>
+#include <stdint.h>
+
+/* Buffer size used for getprotobynumber_r() and similar. The manual comments
+ * that a buffer of 1024 should be sufficient "for most applications"(??), so
+ * let's double it.  It still fits reasonably on the stack, so no need to
+ * choose a smaller one. */
+#define NETDB_BUFSIZE 2048
+
+bool nft_getprotobynumber(int proto, char *out_name, size_t name_len)
+{
+	const struct protoent *result;
+
+#if HAVE_DECL_GETPROTOBYNUMBER_R
+	struct protoent result_buf;
+	char buf[NETDB_BUFSIZE];
+	int r;
+
+	r = getprotobynumber_r(proto,
+	                       &result_buf,
+	                       buf,
+	                       sizeof(buf),
+	                       (struct protoent **) &result);
+	if (r != 0 || result != &result_buf)
+		result = NULL;
+#else
+	result = getprotobynumber(proto);
+#endif
+
+	if (!result)
+		return false;
+
+	if (strlen(result->p_name) >= name_len)
+		return false;
+	strcpy(out_name, result->p_name);
+	return true;
+}
+
+int nft_getprotobyname(const char *name)
+{
+	const struct protoent *result;
+
+#if HAVE_DECL_GETPROTOBYNAME_R
+	struct protoent result_buf;
+	char buf[NETDB_BUFSIZE];
+	int r;
+
+	r = getprotobyname_r(name,
+	                     &result_buf,
+	                     buf,
+	                     sizeof(buf),
+	                     (struct protoent **) &result);
+	if (r != 0 || result != &result_buf)
+		result = NULL;
+#else
+	result = getprotobyname(name);
+#endif
+
+	if (!result)
+		return -1;
+
+	if (result->p_proto < 0 || result->p_proto > UINT8_MAX)
+		return -1;
+	return (uint8_t) result->p_proto;
+}
+
+bool nft_getservbyport(int port, const char *proto, char *out_name, size_t name_len)
+{
+	const struct servent *result;
+
+#if HAVE_DECL_GETSERVBYPORT_R
+	struct servent result_buf;
+	char buf[NETDB_BUFSIZE];
+	int r;
+
+	r = getservbyport_r(port,
+	                    proto,
+	                    &result_buf,
+	                    buf,
+	                    sizeof(buf),
+	                    (struct servent**) &result);
+	if (r != 0 || result != &result_buf)
+		result = NULL;
+#else
+	result = getservbyport(port, proto);
+#endif
+
+	if (!result)
+		return false;
+
+	if (strlen(result->s_name) >= name_len)
+		return false;
+	strcpy(out_name, result->s_name);
+	return true;
+}
diff --git a/src/nftutils.h b/src/nftutils.h
index 9ad68d55ce47..cb584b9ca32b 100644
--- a/src/nftutils.h
+++ b/src/nftutils.h
@@ -2,4 +2,20 @@
 #ifndef NFTUTILS_H
 #define NFTUTILS_H
 
+#include <stdbool.h>
+#include <stddef.h>
+
+/* The maximum buffer size for (struct protoent).p_name. It is excessively large,
+ * while still reasonably fitting on the stack. Arbitrarily chosen. */
+#define NFT_PROTONAME_MAXSIZE 1024
+
+bool nft_getprotobynumber(int number, char *out_name, size_t name_len);
+int nft_getprotobyname(const char *name);
+
+/* The maximum buffer size for (struct servent).s_name. It is excessively large,
+ * while still reasonably fitting on the stack. Arbitrarily chosen. */
+#define NFT_SERVNAME_MAXSIZE 1024
+
+bool nft_getservbyport(int port, const char *proto, char *out_name, size_t name_len);
+
 #endif /* NFTUTILS_H */
-- 
2.41.0

