From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH 1/2] utils: provide array allocation wrapper
Date: Mon,  2 Jan 2017 18:38:50 +0100
Message-ID: <20170102173851.2542-2-oleksandr@natalenko.name>
References: <20170102173851.2542-1-oleksandr@natalenko.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:41740 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756238AbdABRjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 12:39:00 -0500
Received: from localhost.localdomain (unknown [IPv6:2001:470:5b39:29:c99:116f:61fe:9756])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 4541B16AA54
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2017 18:38:58 +0100 (CET)
In-Reply-To: <20170102173851.2542-1-oleksandr@natalenko.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be used for allocating memory for arrays
in heap instead of keeping them on stack.

Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 include/utils.h |  1 +
 src/utils.c     | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index bb58ba4..3199388 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -138,6 +138,7 @@ extern void __memory_allocation_error(const char *filename, uint32_t line) __nor
 
 extern void xfree(const void *ptr);
 extern void *xmalloc(size_t size);
+extern void *xmalloc_array(size_t nmemb, size_t size);
 extern void *xrealloc(void *ptr, size_t size);
 extern void *xzalloc(size_t size);
 extern char *xstrdup(const char *s);
diff --git a/src/utils.c b/src/utils.c
index 65dabf4..9e8866d 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -39,6 +39,17 @@ void *xmalloc(size_t size)
 	return ptr;
 }
 
+void *xmalloc_array(size_t nmemb, size_t size)
+{
+	assert(nmemb != 0);
+	assert(size != 0);
+
+	if (nmemb > SIZE_MAX / size)
+		memory_allocation_error();
+
+	return xmalloc(nmemb * size);
+}
+
 void *xrealloc(void *ptr, size_t size)
 {
 	ptr = realloc(ptr, size);
-- 
2.11.0

