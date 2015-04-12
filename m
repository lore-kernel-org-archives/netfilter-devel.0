From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/3] set: print set elem timeout information
Date: Sun, 12 Apr 2015 20:24:47 +0100
Message-ID: <1428866689-17679-2-git-send-email-kaber@trash.net>
References: <1428866689-17679-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61667 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbbDLTYy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:24:54 -0400
In-Reply-To: <1428866689-17679-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/set.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/set.c b/src/set.c
index d58c9e1..b07c4d9 100644
--- a/src/set.c
+++ b/src/set.c
@@ -15,6 +15,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
+#include <inttypes.h>
 #include <netinet/in.h>
 #include <limits.h>
 #include <errno.h>
@@ -870,6 +871,18 @@ static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
 			s->name, s->table, s->set_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (s->flags & (1 << NFT_SET_ATTR_TIMEOUT)) {
+		ret = snprintf(buf + offset, len, " timeout %"PRIu64"ms",
+			       s->timeout);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	if (s->flags & (1 << NFT_SET_ATTR_GC_INTERVAL)) {
+		ret = snprintf(buf + offset, len, " gc_interval %ums",
+			       s->gc_interval);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (s->flags & (1 << NFT_SET_ATTR_POLICY)) {
 		ret = snprintf(buf + offset, len, " policy %u", s->policy);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-- 
2.1.0

