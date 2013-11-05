From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH] src: Fix a build issue on header inclusion in internal.h
Date: Tue,  5 Nov 2013 10:03:39 +0200
Message-ID: <1383638619-10735-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15572 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab3KEIEH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:04:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes:
In file included from utils.c:11:0:
./internal.h:93:17: error: unknown type name 'FILE'
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int
 (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type,
 uint32_t flags));

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/internal.h b/src/internal.h
index 6449a9f..a10d874 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -90,6 +90,7 @@ const char *nft_verdict2str(uint32_t verdict);
 int nft_str2verdict(const char *verdict);
 int nft_get_value(enum nft_type type, void *val, void *out);
 
+#include <stdio.h>
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
 
 void xfree(const void *ptr);
-- 
1.8.4.2

