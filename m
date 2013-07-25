From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 1/4] iptables: Introduce header for keeping debug and trace
 entities
Date: Thu, 25 Jul 2013 13:23:46 +0400
Message-ID: <1374744229-5427-2-git-send-email-a.perevalov@samsung.com>
References: <1374744229-5427-1-git-send-email-a.perevalov@samsung.com>
Cc: pablo@netfilter.org, netfilter@vger.kernel.org,
	Alexey Perevalov <a.perevalov@samsung.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33144 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3GYJYC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:24:02 -0400
In-reply-to: <1374744229-5427-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/trace.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 include/trace.h

diff --git a/include/trace.h b/include/trace.h
new file mode 100644
index 0000000..4711171
--- /dev/null
+++ b/include/trace.h
@@ -0,0 +1,14 @@
+#ifndef _IPTABLES_TRACE_H
+#define _IPTABLES_TRACE_H
+
+#ifdef DEBUG
+#include <fcntl.h>
+#define DEBUGP(x, args...)      fprintf(stderr, "%s: " x, __FUNCTION__, ## args)
+#define DEBUGP_C(x, args...)    fprintf(stderr, x, ## args)
+#else
+#define DEBUGP(x, args...)
+#define DEBUGP_C(x, args...)
+#endif
+
+#endif /* _IPTABLES_TRACE_H */
+
-- 
1.7.9.5

