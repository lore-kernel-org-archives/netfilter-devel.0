From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] libipt_addrtype: rename to libxt_addrtype
Date: Mon,  7 Mar 2011 22:30:05 +0100
Message-ID: <1299533406-1375-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35864 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055Ab1CGVf5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:35:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fwestphal@astaro.com>

prepare for ipv6 support.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/{libipt_addrtype.c => libxt_addrtype.c} |    0
 .../{libipt_addrtype.man => libxt_addrtype.man}    |    0
 include/linux/netfilter/xt_addrtype.h              |   44 ++++++++++++++++++++
 include/linux/netfilter_ipv4/ipt_addrtype.h        |   25 -----------
 4 files changed, 44 insertions(+), 25 deletions(-)
 rename extensions/{libipt_addrtype.c => libxt_addrtype.c} (100%)
 rename extensions/{libipt_addrtype.man => libxt_addrtype.man} (100%)
 create mode 100644 include/linux/netfilter/xt_addrtype.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_addrtype.h

diff --git a/extensions/libipt_addrtype.c b/extensions/libxt_addrtype.c
similarity index 100%
rename from extensions/libipt_addrtype.c
rename to extensions/libxt_addrtype.c
diff --git a/extensions/libipt_addrtype.man b/extensions/libxt_addrtype.man
similarity index 100%
rename from extensions/libipt_addrtype.man
rename to extensions/libxt_addrtype.man
diff --git a/include/linux/netfilter/xt_addrtype.h b/include/linux/netfilter/xt_addrtype.h
new file mode 100644
index 0000000..b156baa
--- /dev/null
+++ b/include/linux/netfilter/xt_addrtype.h
@@ -0,0 +1,44 @@
+#ifndef _XT_ADDRTYPE_H
+#define _XT_ADDRTYPE_H
+
+#include <linux/types.h>
+
+enum {
+	XT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
+	XT_ADDRTYPE_INVERT_DEST		= 0x0002,
+	XT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
+	XT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
+};
+
+
+/* rtn_type enum values from rtnetlink.h, but shifted */
+enum {
+	XT_ADDRTYPE_UNSPEC = 1 << 0,
+	XT_ADDRTYPE_UNICAST = 1 << 1,	/* 1 << RTN_UNICAST */
+	XT_ADDRTYPE_LOCAL  = 1 << 2,	/* 1 << RTN_LOCAL, etc */
+	XT_ADDRTYPE_BROADCAST = 1 << 3,
+	XT_ADDRTYPE_ANYCAST = 1 << 4,
+	XT_ADDRTYPE_MULTICAST = 1 << 5,
+	XT_ADDRTYPE_BLACKHOLE = 1 << 6,
+	XT_ADDRTYPE_UNREACHABLE = 1 << 7,
+	XT_ADDRTYPE_PROHIBIT = 1 << 8,
+	XT_ADDRTYPE_THROW = 1 << 9,
+	XT_ADDRTYPE_NAT = 1 << 10,
+	XT_ADDRTYPE_XRESOLVE = 1 << 11,
+};
+
+struct xt_addrtype_info_v1 {
+	__u16	source;		/* source-type mask */
+	__u16	dest;		/* dest-type mask */
+	__u32	flags;
+};
+
+/* revision 0 */
+struct xt_addrtype_info {
+	__u16	source;		/* source-type mask */
+	__u16	dest;		/* dest-type mask */
+	__u32	invert_source;
+	__u32	invert_dest;
+};
+
+#endif
diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
deleted file mode 100644
index 446de6a..0000000
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef _IPT_ADDRTYPE_H
-#define _IPT_ADDRTYPE_H
-
-enum {
-	IPT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
-	IPT_ADDRTYPE_INVERT_DEST	= 0x0002,
-	IPT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
-	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
-};
-
-struct ipt_addrtype_info_v1 {
-	u_int16_t	source;		/* source-type mask */
-	u_int16_t	dest;		/* dest-type mask */
-	u_int32_t	flags;
-};
-
-/* revision 0 */
-struct ipt_addrtype_info {
-	u_int16_t	source;		/* source-type mask */
-	u_int16_t	dest;		/* dest-type mask */
-	u_int32_t	invert_source;
-	u_int32_t	invert_dest;
-};
-
-#endif
-- 
1.7.3.4

