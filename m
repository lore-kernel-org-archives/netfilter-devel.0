From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl 3/3] expr: log: complete log flags support
Date: Sun, 25 Sep 2016 16:54:35 +0800
Message-ID: <1474793675-4542-4-git-send-email-zlpnobody@163.com>
References: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:41767 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940082AbcIYIzi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 04:55:38 -0400
In-Reply-To: <1474793675-4542-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If NFTNL_EXPR_LOG_FLAGS is not set, it's unnecessary to print out the
flags value. Furthermore, it's better to print out string message
instead of the hex value.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/linux/netfilter/nf_log.h | 12 ++++++++++++
 src/expr/log.c                   | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 42 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/netfilter/nf_log.h

diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
new file mode 100644
index 0000000..8be21e0
--- /dev/null
+++ b/include/linux/netfilter/nf_log.h
@@ -0,0 +1,12 @@
+#ifndef _NETFILTER_NF_LOG_H
+#define _NETFILTER_NF_LOG_H
+
+#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
+#define NF_LOG_IPOPT		0x04	/* Log IP options */
+#define NF_LOG_UID		0x08	/* Log UID owning local socket */
+#define NF_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define NF_LOG_MASK		0x2f
+
+#endif /* _NETFILTER_NF_LOG_H */
diff --git a/src/expr/log.c b/src/expr/log.c
index a231bac..b642255 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -15,6 +15,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_log.h>
 
 #include "internal.h"
 #include <libmnl/libmnl.h>
@@ -237,13 +238,37 @@ static int nftnl_expr_log_snprintf_default(char *buf, size_t size,
 
 	if (e->flags & (1 << NFTNL_EXPR_LOG_GROUP)) {
 		ret = snprintf(buf + offset, len,
-			       "group %u snaplen %u qthreshold %u",
+			       "group %u snaplen %u qthreshold %u ",
 			       log->group, log->snaplen, log->qthreshold);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	} else if (e->flags & (1 << NFTNL_EXPR_LOG_LEVEL)) {
-		ret = snprintf(buf + offset, len, "level %u flags %u",
-			       log->level, log->flags);
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else {
+		if (e->flags & (1 << NFTNL_EXPR_LOG_LEVEL)) {
+			ret = snprintf(buf + offset, len, "level %u ",
+				       log->level);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+		if (e->flags & (1 << NFTNL_EXPR_LOG_FLAGS)) {
+			if (log->flags & NF_LOG_TCPSEQ) {
+				ret = snprintf(buf + offset, len, "tcpseq ");
+				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			}
+			if (log->flags & NF_LOG_TCPOPT) {
+				ret = snprintf(buf + offset, len, "tcpopt ");
+				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			}
+			if (log->flags & NF_LOG_IPOPT) {
+				ret = snprintf(buf + offset, len, "ipopt ");
+				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			}
+			if (log->flags & NF_LOG_UID) {
+				ret = snprintf(buf + offset, len, "uid ");
+				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			}
+			if (log->flags & NF_LOG_MACDECODE) {
+				ret = snprintf(buf + offset, len, "macdecode ");
+				SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+			}
+		}
 	}
 
 	return offset;
-- 
2.5.5


