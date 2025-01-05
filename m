Received: from smtp-out.freemail.hu (fmfe33.freemail.hu [46.107.16.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE7A29;
	Sun,  5 Jan 2025 20:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736109833; cv=none; b=lB3DsAeyG6jzZIuUDRq5L1r0d/Jsm9Uq23iewiXPX6xAbf5VzDNdM1U+AnwRIVfl4tMwpjpnpuCRhBezPXkgm0PEqadZLeGyglFzL2YOskw6ycq3f48P+wW2Ic0nN2saFa1DpT0dR/c0MiyDDhv91/QqNNH+RriYeLVGGLlVQqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736109833; c=relaxed/simple;
	bh=pL85uzdEr23E+BkIGwpRQr37t16/2VI/QBOZSmNa9w8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eCV4O6329w9NhxDqtfxCzVNDWBqaY8p1/Ptg9pvNeC4/MdTnVafEMmYSA6/0aMkoCWoWMPLPvKUhId2Z/Cp64h5mDs5pjgRVSLN+Ic7fM0spb2+SY2Ps9ZKQKU8SL8+fE4WGWUH8SReUujfpclD0KKnWvjnNzXFI85m4FIjgkcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=M/Z4R6df reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="M/Z4R6df"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YR8FJ1QjBzTS5;
	Sun, 05 Jan 2025 21:35:00 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH v5 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h files which has same name.
Date: Sun,  5 Jan 2025 21:34:52 +0100
Message-ID: <20250105203452.101067-1-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736109301;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=91475; bh=WiuJW7HD3T6iucdtBIxA/Tg/8zwbJ9kHpgEZsTY9zy4=;
	b=M/Z4R6dfQEecZ2BETk5MMlc5BipxKVLbN2MiPBOzQHa+RtQK8Ou6n3KQyKTwkvRH
	beBdVeYDuE7evGYZNncXmPNYOYwQxGKq/+7ciTndNa8nGN/UxN0gya8bLWmR4FW3isF
	3rBfmXTN5/TNO087WOKJD7UqNnE23cxIsL/0tFkgA5Q8dAQul0n0tNM09iY91gNgIKL
	+USAuwa1E1G97MHXksafDWPyKpbLDMp5XV9FfWEaUWlVmcL3PTRQtmVaCfB/VR6IKHt
	oghpjLvMzawHt1xef4TJCcIDAEqIyqOTZdN2w4hq2dzmGIrggq7GEzpCPEvwP7DtY8/
	arEkOwd8qg==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
same upper and lower case name format.

Add #pragma message about recommended to use
header files with lower case format in the future.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_CONNMARK.h  |  8 +++---
 include/uapi/linux/netfilter/xt_DSCP.h      | 22 ++--------------
 include/uapi/linux/netfilter/xt_MARK.h      |  8 +++---
 include/uapi/linux/netfilter/xt_RATEEST.h   | 12 ++-------
 include/uapi/linux/netfilter/xt_TCPMSS.h    | 14 ++++------
 include/uapi/linux/netfilter/xt_connmark.h  |  7 +++--
 include/uapi/linux/netfilter/xt_dscp.h      | 20 +++++++++++---
 include/uapi/linux/netfilter/xt_mark.h      |  6 ++---
 include/uapi/linux/netfilter/xt_rateest.h   | 15 ++++++++---
 include/uapi/linux/netfilter/xt_tcpmss.h    | 12 ++++++---
 include/uapi/linux/netfilter_ipv4/ipt_ECN.h | 29 ++-------------------
 include/uapi/linux/netfilter_ipv4/ipt_TTL.h | 25 ++++--------------
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h | 26 ++++++++++++++++++
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h | 23 +++++++++++++---
 include/uapi/linux/netfilter_ipv6/ip6t_HL.h | 26 ++++--------------
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h | 22 +++++++++++++---
 net/ipv4/netfilter/ipt_ECN.c                |  2 +-
 net/netfilter/xt_DSCP.c                     |  2 +-
 net/netfilter/xt_HL.c                       |  4 +--
 net/netfilter/xt_RATEEST.c                  |  2 +-
 net/netfilter/xt_TCPMSS.c                   |  2 +-
 21 files changed, 143 insertions(+), 144 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_CONNMARK.h b/include/uapi/linux/netfilter/xt_CONNMARK.h
index 36cc956ead1a..1bc991fd546a 100644
--- a/include/uapi/linux/netfilter/xt_CONNMARK.h
+++ b/include/uapi/linux/netfilter/xt_CONNMARK.h
@@ -1,7 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_CONNMARK_H_target
-#define _XT_CONNMARK_H_target
+#ifndef _XT_CONNMARK_TARGET_H
+#define _XT_CONNMARK_TARGET_H
 
 #include <linux/netfilter/xt_connmark.h>
 
-#endif /*_XT_CONNMARK_H_target*/
+#pragma message("xt_CONNMARK.h header is deprecated. Use xt_connmark.h instead.")
+
+#endif /* _XT_CONNMARK_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_DSCP.h b/include/uapi/linux/netfilter/xt_DSCP.h
index 223d635e8b6f..bd550292803d 100644
--- a/include/uapi/linux/netfilter/xt_DSCP.h
+++ b/include/uapi/linux/netfilter/xt_DSCP.h
@@ -1,27 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* x_tables module for setting the IPv4/IPv6 DSCP field
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- * This software is distributed under GNU GPL v2, 1991
- *
- * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
-*/
 #ifndef _XT_DSCP_TARGET_H
 #define _XT_DSCP_TARGET_H
-#include <linux/netfilter/xt_dscp.h>
-#include <linux/types.h>
 
-/* target info */
-struct xt_DSCP_info {
-	__u8 dscp;
-};
+#include <linux/netfilter/xt_dscp.h>
 
-struct xt_tos_target_info {
-	__u8 tos_value;
-	__u8 tos_mask;
-};
+#pragma message("xt_DSCP.h header is deprecated. Use xt_dscp.h instead.")
 
 #endif /* _XT_DSCP_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_MARK.h b/include/uapi/linux/netfilter/xt_MARK.h
index f1fe2b4be933..9f6c03e26c96 100644
--- a/include/uapi/linux/netfilter/xt_MARK.h
+++ b/include/uapi/linux/netfilter/xt_MARK.h
@@ -1,7 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_MARK_H_target
-#define _XT_MARK_H_target
+#ifndef _XT_MARK_H_TARGET_H
+#define _XT_MARK_H_TARGET_H
 
 #include <linux/netfilter/xt_mark.h>
 
-#endif /*_XT_MARK_H_target */
+#pragma message("xt_MARK.h header is deprecated. Use xt_mark.h instead.")
+
+#endif /* _XT_MARK_H_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/linux/netfilter/xt_RATEEST.h
index 2b87a71e6266..ec3d68f67b2f 100644
--- a/include/uapi/linux/netfilter/xt_RATEEST.h
+++ b/include/uapi/linux/netfilter/xt_RATEEST.h
@@ -2,16 +2,8 @@
 #ifndef _XT_RATEEST_TARGET_H
 #define _XT_RATEEST_TARGET_H
 
-#include <linux/types.h>
-#include <linux/if.h>
+#include <linux/netfilter/xt_rateest.h>
 
-struct xt_rateest_target_info {
-	char			name[IFNAMSIZ];
-	__s8			interval;
-	__u8		ewma_log;
-
-	/* Used internally by the kernel */
-	struct xt_rateest	*est __attribute__((aligned(8)));
-};
+#pragma message("xt_RATEEST.h header is deprecated. Use xt_rateest.h instead.")
 
 #endif /* _XT_RATEEST_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_TCPMSS.h b/include/uapi/linux/netfilter/xt_TCPMSS.h
index 65ea6c9dab4b..826060264766 100644
--- a/include/uapi/linux/netfilter/xt_TCPMSS.h
+++ b/include/uapi/linux/netfilter/xt_TCPMSS.h
@@ -1,13 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_TCPMSS_H
-#define _XT_TCPMSS_H
+#ifndef _XT_TCPMSS_TARGET_H
+#define _XT_TCPMSS_TARGET_H
 
-#include <linux/types.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
-struct xt_tcpmss_info {
-	__u16 mss;
-};
+#pragma message("xt_TCPMSS.h header is deprecated. Use xt_tcpmss.h instead.")
 
-#define XT_TCPMSS_CLAMP_PMTU 0xffff
-
-#endif /* _XT_TCPMSS_H */
+#endif /* _XT_TCPMSS_TARGET_H */
diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index 41b578ccd03b..a3f03729805b 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -2,9 +2,8 @@
 /* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  */
-
-#ifndef _XT_CONNMARK_H
-#define _XT_CONNMARK_H
+#ifndef _UAPI_XT_CONNMARK_H
+#define _UAPI_XT_CONNMARK_H
 
 #include <linux/types.h>
 
@@ -34,4 +33,4 @@ struct xt_connmark_mtinfo1 {
 	__u8 invert;
 };
 
-#endif /*_XT_CONNMARK_H*/
+#endif /* _UAPI_XT_CONNMARK_H */
diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
index 7594e4df8587..01e8611cd26e 100644
--- a/include/uapi/linux/netfilter/xt_dscp.h
+++ b/include/uapi/linux/netfilter/xt_dscp.h
@@ -1,15 +1,17 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* x_tables module for matching the IPv4/IPv6 DSCP field
+/* x_tables module for setting the IPv4/IPv6 DSCP field
  *
  * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
  * This software is distributed under GNU GPL v2, 1991
  *
  * See RFC2474 for a description of the DSCP field within the IP Header.
  *
+ * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
  * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
 */
-#ifndef _XT_DSCP_H
-#define _XT_DSCP_H
+#ifndef _UAPI_XT_DSCP_H
+#define _UAPI_XT_DSCP_H
 
 #include <linux/types.h>
 
@@ -29,4 +31,14 @@ struct xt_tos_match_info {
 	__u8 invert;
 };
 
-#endif /* _XT_DSCP_H */
+/* target info */
+struct xt_DSCP_info {
+	__u8 dscp;
+};
+
+struct xt_tos_target_info {
+	__u8 tos_value;
+	__u8 tos_mask;
+};
+
+#endif /* _UAPI_XT_DSCP_H */
diff --git a/include/uapi/linux/netfilter/xt_mark.h b/include/uapi/linux/netfilter/xt_mark.h
index 9d0526ced8f0..adcd90b00786 100644
--- a/include/uapi/linux/netfilter/xt_mark.h
+++ b/include/uapi/linux/netfilter/xt_mark.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_MARK_H
-#define _XT_MARK_H
+#ifndef _UAPI_XT_MARK_H
+#define _UAPI_XT_MARK_H
 
 #include <linux/types.h>
 
@@ -13,4 +13,4 @@ struct xt_mark_mtinfo1 {
 	__u8 invert;
 };
 
-#endif /*_XT_MARK_H*/
+#endif /* _UAPI_XT_MARK_H */
diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/linux/netfilter/xt_rateest.h
index 52a37bdc1837..da9727fa527b 100644
--- a/include/uapi/linux/netfilter/xt_rateest.h
+++ b/include/uapi/linux/netfilter/xt_rateest.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_RATEEST_MATCH_H
-#define _XT_RATEEST_MATCH_H
+#ifndef _UAPI_XT_RATEEST_H
+#define _UAPI_XT_RATEEST_H
 
 #include <linux/types.h>
 #include <linux/if.h>
@@ -36,4 +36,13 @@ struct xt_rateest_match_info {
 	struct xt_rateest	*est2 __attribute__((aligned(8)));
 };
 
-#endif /* _XT_RATEEST_MATCH_H */
+struct xt_rateest_target_info {
+	char		name[IFNAMSIZ];
+	__s8		interval;
+	__u8		ewma_log;
+
+	/* Used internally by the kernel */
+	struct xt_rateest	*est __attribute__((aligned(8)));
+};
+
+#endif /* _UAPI_XT_RATEEST_H */
diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/linux/netfilter/xt_tcpmss.h
index 2268f58b4dec..3ee4acaa6e03 100644
--- a/include/uapi/linux/netfilter/xt_tcpmss.h
+++ b/include/uapi/linux/netfilter/xt_tcpmss.h
@@ -1,12 +1,18 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _XT_TCPMSS_MATCH_H
-#define _XT_TCPMSS_MATCH_H
+#ifndef _UAPI_XT_TCPMSS_H
+#define _UAPI_XT_TCPMSS_H
 
 #include <linux/types.h>
 
+#define XT_TCPMSS_CLAMP_PMTU	0xffff
+
 struct xt_tcpmss_match_info {
     __u16 mss_min, mss_max;
     __u8 invert;
 };
 
-#endif /*_XT_TCPMSS_MATCH_H*/
+struct xt_tcpmss_info {
+	__u16 mss;
+};
+
+#endif /* _UAPI_XT_TCPMSS_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
index e3630fd045b8..42317fb3a4e9 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ECN.h
@@ -1,34 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* Header file for iptables ipt_ECN target
- *
- * (C) 2002 by Harald Welte <laforge@gnumonks.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
-*/
 #ifndef _IPT_ECN_TARGET_H
 #define _IPT_ECN_TARGET_H
 
-#include <linux/types.h>
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter_ipv4/ipt_ecn.h>
 
-#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
-
-#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
-#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
-#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
-
-#define IPT_ECN_OP_MASK		0xce
-
-struct ipt_ECN_info {
-	__u8 operation;	/* bitset of operations */
-	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
-	union {
-		struct {
-			__u8 ece:1, cwr:1; /* TCP ECT bits */
-		} tcp;
-	} proto;
-};
+#pragma message("ipt_ECN.h header is deprecated. Use ipt_ecn.h instead.")
 
 #endif /* _IPT_ECN_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
index 57d2fc67a943..1663493e4951 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_TTL.h
@@ -1,24 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* TTL modification module for IP tables
- * (C) 2000 by Harald Welte <laforge@netfilter.org> */
+#ifndef _IPT_TTL_TARGET_H
+#define _IPT_TTL_TARGET_H
 
-#ifndef _IPT_TTL_H
-#define _IPT_TTL_H
+#include <linux/netfilter_ipv4/ipt_ttl.h>
 
-#include <linux/types.h>
+#pragma message("ipt_TTL.h header is deprecated. Use ipt_ttl.h instead.")
 
-enum {
-	IPT_TTL_SET = 0,
-	IPT_TTL_INC,
-	IPT_TTL_DEC
-};
-
-#define IPT_TTL_MAXMODE	IPT_TTL_DEC
-
-struct ipt_TTL_info {
-	__u8	mode;
-	__u8	ttl;
-};
-
-
-#endif
+#endif /* _IPT_TTL_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
index 8121bec47026..a6d479aece21 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
@@ -1,10 +1,26 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Header file for iptables ipt_ECN target and match
+ *
+ * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ *
+ * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
+ */
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H
 
+#include <linux/types.h>
+#include <linux/netfilter/xt_dscp.h>
 #include <linux/netfilter/xt_ecn.h>
+
 #define ipt_ecn_info xt_ecn_info
 
+#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
+#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
+#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
+#define IPT_ECN_OP_MASK		0xce
+
 enum {
 	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
 	IPT_ECN_OP_MATCH_IP   = XT_ECN_OP_MATCH_IP,
@@ -13,4 +29,14 @@ enum {
 	IPT_ECN_OP_MATCH_MASK = XT_ECN_OP_MATCH_MASK,
 };
 
+struct ipt_ECN_info {
+	__u8 operation;	/* bitset of operations */
+	__u8 ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
+	union {
+		struct {
+			__u8 ece:1, cwr:1; /* TCP ECT bits */
+		} tcp;
+	} proto;
+};
+
 #endif /* IPT_ECN_H */
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
index ad0226a8629b..e7b8d6c58264 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
@@ -1,7 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* IP tables module for matching the value of the TTL
- * (C) 2000 by Harald Welte <laforge@gnumonks.org> */
-
+/* TTL modification module for IP tables
+ * IP tables module for matching the value of the TTL
+ *
+ * (C) 2000 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2000 by Harald Welte <laforge@netfilter.org>
+ */
 #ifndef _IPT_TTL_H
 #define _IPT_TTL_H
 
@@ -20,5 +23,17 @@ struct ipt_ttl_info {
 	__u8	ttl;
 };
 
+enum {
+	IPT_TTL_SET = 0,
+	IPT_TTL_INC,
+	IPT_TTL_DEC
+};
+
+#define IPT_TTL_MAXMODE	IPT_TTL_DEC
+
+struct ipt_TTL_info {
+	__u8	mode;
+	__u8	ttl;
+};
 
-#endif
+#endif /* _IPT_TTL_H */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
index eaed56a287b4..55f08e20acd2 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_HL.h
@@ -1,25 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* Hop Limit modification module for ip6tables
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's TTL module */
+#ifndef _IP6T_HL_TARGET_H
+#define _IP6T_HL_TARGET_H
 
-#ifndef _IP6T_HL_H
-#define _IP6T_HL_H
+#include <linux/netfilter_ipv6/ip6t_hl.h>
 
-#include <linux/types.h>
+#pragma message("ip6t_HL.h header is deprecated. Use ip6t_hl.h instead.")
 
-enum {
-	IP6T_HL_SET = 0,
-	IP6T_HL_INC,
-	IP6T_HL_DEC
-};
-
-#define IP6T_HL_MAXMODE	IP6T_HL_DEC
-
-struct ip6t_HL_info {
-	__u8	mode;
-	__u8	hop_limit;
-};
-
-
-#endif
+#endif /* _IP6T_HL_TARGET_H */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
index 6b62f9418eb2..cace0c7b649f 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
@@ -1,8 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/* ip6tables module for matching the Hop Limit value
+/* Hop Limit modification module for ip6tables
+ * ip6tables module for matching the Hop Limit value
+ *
  * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's ttl module */
-
+ * Based on HW's ttl module
+ */
 #ifndef _IP6T_HL_H
 #define _IP6T_HL_H
 
@@ -21,5 +23,17 @@ struct ip6t_hl_info {
 	__u8	hop_limit;
 };
 
+enum {
+	IP6T_HL_SET = 0,
+	IP6T_HL_INC,
+	IP6T_HL_DEC
+};
+
+#define IP6T_HL_MAXMODE	IP6T_HL_DEC
+
+struct ip6t_HL_info {
+	__u8	mode;
+	__u8	hop_limit;
+};
 
-#endif
+#endif /* _IP6T_HL_H */
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 5930d3b02555..1370069a5cac 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -14,7 +14,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ECN.h>
+#include <linux/netfilter_ipv4/ipt_ecn.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index cfa44515ab72..90f24a6a26c5 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -14,7 +14,7 @@
 #include <net/dsfield.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter/xt_dscp.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 7873b834c300..a847d7a7eacd 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -14,8 +14,8 @@
 #include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_TTL.h>
-#include <linux/netfilter_ipv6/ip6t_HL.h>
+#include <linux/netfilter_ipv4/ipt_ttl.h>
+#include <linux/netfilter_ipv6/ip6t_hl.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 4f49cfc27831..a86bb0e4bb42 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -14,7 +14,7 @@
 #include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_RATEEST.h>
+#include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
 #define RATEEST_HSIZE	16
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 116a885adb3c..3dc1320237c2 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_TCPMSS.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-- 
2.43.5


From 4d137c653149780b0ad08b7f1205a3b0e422955e Mon Sep 17 00:00:00 2001
From: Benjamin Szőke <egyszeregy@freemail.hu>
Date: Sun, 5 Jan 2025 18:34:25 +0100
Subject: [PATCH v5 2/3] netfilter: x_tables: Merge xt_*.c files which has same
 name.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Merge xt_*.c source files, which has same upper and
lower case name format. Combining these modules should
provide some decent code size and memory savings.

Merge licenses, codes and adjuste Kconfig and Makefile
for backwards-compatibility.

test-build:
$ mkdir build
$ wget -O ./build/.config https://pastebin.com/raw/teShg1sp
$ make O=./build/ ARCH=x86 -j 16

x86_64-before:
text    data     bss     dec     hex filename
 716     432       0    1148     47c xt_dscp.o
1142     432       0    1574     626 xt_DSCP.o
 593     224       0     817     331 xt_hl.o
 934     224       0    1158     486 xt_HL.o
1099     120       0    1219     4c3 xt_rateest.o
2126     365       4    2495     9bf xt_RATEEST.o
 747     224       0     971     3cb xt_tcpmss.o
2824     352       0    3176     c68 xt_TCPMSS.o
total data: 2373

x86_64-after:
text    data     bss     dec     hex filename
1709     848       0    2557     9fd xt_dscp.o
1352     448       0    1800     708 xt_hl.o
3075     481       4    3560     de8 xt_rateest.o
3423     576       0    3999     f9f xt_tcpmss.o
total data: 2353

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/Kconfig      |  84 +++++++++
 net/netfilter/Makefile     |  12 +-
 net/netfilter/xt_DSCP.c    | 161 -----------------
 net/netfilter/xt_HL.c      | 159 -----------------
 net/netfilter/xt_RATEEST.c | 248 --------------------------
 net/netfilter/xt_TCPMSS.c  | 345 ------------------------------------
 net/netfilter/xt_dscp.c    | 156 +++++++++++++++-
 net/netfilter/xt_hl.c      | 160 ++++++++++++++++-
 net/netfilter/xt_rateest.c | 253 ++++++++++++++++++++++++--
 net/netfilter/xt_tcpmss.c  | 353 +++++++++++++++++++++++++++++++++++--
 10 files changed, 971 insertions(+), 960 deletions(-)
 delete mode 100644 net/netfilter/xt_DSCP.c
 delete mode 100644 net/netfilter/xt_HL.c
 delete mode 100644 net/netfilter/xt_RATEEST.c
 delete mode 100644 net/netfilter/xt_TCPMSS.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df2dc21304ef..34fbdfdbdde9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -802,6 +802,51 @@ config NETFILTER_XT_SET
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_DSCP
+	tristate '"DSCP" and "TOS" target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "DSCP" target and "dscp" match.
+
+	  Netfilter dscp matching which allows you to match against the
+	  IPv4/IPv6 header DSCP field (differentiated services codepoint).
+	  The target allows you to manipulate the IPv4/IPv6
+	  header DSCP field (differentiated services codepoint).
+
+config NETFILTER_XT_HL
+	tristate '"HL" hoplimit target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "HL" target and "hl" match.
+
+	  Netfilter hl matching allows you to match packets based on
+	  the hoplimit in the IPv6 header, or the time-to-live field in
+	  the IPv4 header of the packet.
+	  The target allows you to change the hoplimit/time-to-live
+	  value of the IP header.
+
+config NETFILTER_XT_RATEEST
+	tristate '"RATEEST" target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "RATEEST" target and "rateest" match.
+
+	  Netfilter rateest matching allows you to match on the rate
+	  estimated by the RATEEST target.
+	  The target allows you to measure rates similar to TC estimators.
+
+config NETFILTER_XT_TCPMSS
+	tristate '"TCPMSS" target and match support'
+	depends on IPV6 || IPV6=n
+	default m if NETFILTER_ADVANCED=n
+	help
+	  This option adds the "TCPMSS" target and "tcpmss" match.
+
+	  Netfilter tcpmss matching allows you to examine the MSS value of
+	  TCP SYN packets, which control the maximum packet size for that connection.
+	  The target allows you to alter the MSS value of TCP SYN packets,
+	  to control the maximum size for that connection.
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
@@ -882,6 +927,7 @@ config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_DSCP
 	help
 	  This option adds a `DSCP' target, which allows you to manipulate
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -892,12 +938,17 @@ config NETFILTER_XT_TARGET_DSCP
 	  the "mangle" table which alter the Type Of Service field of an IPv4
 	  or the Priority field of an IPv6 packet, prior to routing.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_DSCP (combined dscp/DSCP module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_HL
 	tristate '"HL" hoplimit target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_HL
 	help
 	This option adds the "HL" (for IPv6) and "TTL" (for IPv4)
 	targets, which enable the user to change the
@@ -909,6 +960,10 @@ config NETFILTER_XT_TARGET_HL
 	since you can easily create immortal packets that loop
 	forever on the network.
 
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_HL (combined hl/HL module).
+
 config NETFILTER_XT_TARGET_HMARK
 	tristate '"HMARK" target support'
 	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
@@ -1029,11 +1084,16 @@ config NETFILTER_XT_TARGET_NOTRACK
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_RATEEST
 	help
 	  This option adds a `RATEEST' target, which allows to measure
 	  rates similar to TC estimators. The `rateest' match can be
 	  used to match on the measured rates.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_RATEEST (combined rateest/RATEEST module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_REDIRECT
@@ -1122,6 +1182,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on IPV6 || IPV6=n
 	default m if NETFILTER_ADVANCED=n
+	select NETFILTER_XT_TCPMSS
 	help
 	  This option adds a `TCPMSS' target, which allows you to alter the
 	  MSS value of TCP SYN packets, to control the maximum size for that
@@ -1143,6 +1204,10 @@ config NETFILTER_XT_TARGET_TCPMSS
 	  iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
 	                 -j TCPMSS --clamp-mss-to-pmtu
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TCPMSS (combined tcpmss/TCPMSS module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
@@ -1301,6 +1366,7 @@ config NETFILTER_XT_MATCH_DEVGROUP
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"dscp" and "tos" match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_DSCP
 	help
 	  This option adds a `DSCP' match, which allows you to match against
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -1311,6 +1377,10 @@ config NETFILTER_XT_MATCH_DSCP
 	  based on the Type Of Service fields of the IPv4 packet (which share
 	  the same bits as DSCP).
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_DSCP (combined dscp/DSCP module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_ECN
@@ -1359,11 +1429,16 @@ config NETFILTER_XT_MATCH_HELPER
 config NETFILTER_XT_MATCH_HL
 	tristate '"hl" hoplimit/TTL match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_HL
 	help
 	HL matching allows you to match packets based on the hoplimit
 	in the IPv6 header, or the time-to-live field in the IPv4
 	header of the packet.
 
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_HL (combined hl/HL module).
+
 config NETFILTER_XT_MATCH_IPCOMP
 	tristate '"ipcomp" match support'
 	depends on NETFILTER_ADVANCED
@@ -1533,6 +1608,10 @@ config NETFILTER_XT_MATCH_RATEEST
 	  This option adds a `rateest' match, which allows to match on the
 	  rate estimated by the RATEEST target.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_RATEEST (combined rateest/RATEEST module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_REALM
@@ -1625,11 +1704,16 @@ config NETFILTER_XT_MATCH_STRING
 config NETFILTER_XT_MATCH_TCPMSS
 	tristate '"tcpmss" match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_TCPMSS
 	help
 	  This option adds a `tcpmss' match, which allows you to examine the
 	  MSS value of TCP SYN packets, which control the maximum packet size
 	  for that connection.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TCPMSS (combined tcpmss/TCPMSS module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_TIME
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f0aa4d7ef499..df6bfa46e6ab 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -160,6 +160,10 @@ obj-$(CONFIG_NETFILTER_XT_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
 obj-$(CONFIG_NETFILTER_XT_NAT) += xt_nat.o
+obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o
+obj-$(CONFIG_NETFILTER_XT_HL) += xt_hl.o
+obj-$(CONFIG_NETFILTER_XT_RATEEST) += xt_rateest.o
+obj-$(CONFIG_NETFILTER_XT_TCPMSS) += xt_tcpmss.o
 
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
@@ -167,20 +171,16 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_CHECKSUM.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HMARK) += xt_HMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LOG) += xt_LOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NETMAP) += xt_NETMAP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
@@ -198,12 +198,10 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CPU) += xt_cpu.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DEVGROUP) += xt_devgroup.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ECN) += xt_ecn.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_HL) += xt_hl.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPCOMP) += xt_ipcomp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPRANGE) += xt_iprange.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPVS) += xt_ipvs.o
@@ -220,7 +218,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
@@ -228,7 +225,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
deleted file mode 100644
index 90f24a6a26c5..000000000000
--- a/net/netfilter/xt_DSCP.c
+++ /dev/null
@@ -1,161 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
- *
- * (C) 2002 by Harald Welte <laforge@netfilter.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- *
- * See RFC2474 for a description of the DSCP field within the IP Header.
-*/
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/dsfield.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_dscp.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_DSCP");
-MODULE_ALIAS("ip6t_DSCP");
-MODULE_ALIAS("ipt_TOS");
-MODULE_ALIAS("ip6t_TOS");
-
-#define XT_DSCP_ECN_MASK	3u
-
-static unsigned int
-dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	if (dscp != dinfo->dscp) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-
-		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
-				    dinfo->dscp << XT_DSCP_SHIFT);
-
-	}
-	return XT_CONTINUE;
-}
-
-static unsigned int
-dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	if (dscp != dinfo->dscp) {
-		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
-			return NF_DROP;
-
-		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
-				    dinfo->dscp << XT_DSCP_SHIFT);
-	}
-	return XT_CONTINUE;
-}
-
-static int dscp_tg_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_DSCP_info *info = par->targinfo;
-
-	if (info->dscp > XT_DSCP_MAX)
-		return -EDOM;
-	return 0;
-}
-
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_tos_target_info *info = par->targinfo;
-	struct iphdr *iph = ip_hdr(skb);
-	u_int8_t orig, nv;
-
-	orig = ipv4_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-
-	if (orig != nv) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ip_hdr(skb);
-		ipv4_change_dsfield(iph, 0, nv);
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_tos_target_info *info = par->targinfo;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-	u_int8_t orig, nv;
-
-	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-
-	if (orig != nv) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ipv6_hdr(skb);
-		ipv6_change_dsfield(iph, 0, nv);
-	}
-
-	return XT_CONTINUE;
-}
-
-static struct xt_target dscp_tg_reg[] __read_mostly = {
-	{
-		.name		= "DSCP",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= dscp_tg_check,
-		.target		= dscp_tg,
-		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "DSCP",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= dscp_tg_check,
-		.target		= dscp_tg6,
-		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TOS",
-		.revision	= 1,
-		.family		= NFPROTO_IPV4,
-		.table		= "mangle",
-		.target		= tos_tg,
-		.targetsize	= sizeof(struct xt_tos_target_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TOS",
-		.revision	= 1,
-		.family		= NFPROTO_IPV6,
-		.table		= "mangle",
-		.target		= tos_tg6,
-		.targetsize	= sizeof(struct xt_tos_target_info),
-		.me		= THIS_MODULE,
-	},
-};
-
-static int __init dscp_tg_init(void)
-{
-	return xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
-}
-
-static void __exit dscp_tg_exit(void)
-{
-	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
-}
-
-module_init(dscp_tg_init);
-module_exit(dscp_tg_exit);
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
deleted file mode 100644
index a847d7a7eacd..000000000000
--- a/net/netfilter/xt_HL.c
+++ /dev/null
@@ -1,159 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * TTL modification target for IP tables
- * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
- *
- * Hop Limit modification target for ip6tables
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_ttl.h>
-#include <linux/netfilter_ipv6/ip6t_hl.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL Limit field modification target");
-MODULE_LICENSE("GPL");
-
-static unsigned int
-ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct iphdr *iph;
-	const struct ipt_TTL_info *info = par->targinfo;
-	int new_ttl;
-
-	if (skb_ensure_writable(skb, sizeof(*iph)))
-		return NF_DROP;
-
-	iph = ip_hdr(skb);
-
-	switch (info->mode) {
-	case IPT_TTL_SET:
-		new_ttl = info->ttl;
-		break;
-	case IPT_TTL_INC:
-		new_ttl = iph->ttl + info->ttl;
-		if (new_ttl > 255)
-			new_ttl = 255;
-		break;
-	case IPT_TTL_DEC:
-		new_ttl = iph->ttl - info->ttl;
-		if (new_ttl < 0)
-			new_ttl = 0;
-		break;
-	default:
-		new_ttl = iph->ttl;
-		break;
-	}
-
-	if (new_ttl != iph->ttl) {
-		csum_replace2(&iph->check, htons(iph->ttl << 8),
-					   htons(new_ttl << 8));
-		iph->ttl = new_ttl;
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct ipv6hdr *ip6h;
-	const struct ip6t_HL_info *info = par->targinfo;
-	int new_hl;
-
-	if (skb_ensure_writable(skb, sizeof(*ip6h)))
-		return NF_DROP;
-
-	ip6h = ipv6_hdr(skb);
-
-	switch (info->mode) {
-	case IP6T_HL_SET:
-		new_hl = info->hop_limit;
-		break;
-	case IP6T_HL_INC:
-		new_hl = ip6h->hop_limit + info->hop_limit;
-		if (new_hl > 255)
-			new_hl = 255;
-		break;
-	case IP6T_HL_DEC:
-		new_hl = ip6h->hop_limit - info->hop_limit;
-		if (new_hl < 0)
-			new_hl = 0;
-		break;
-	default:
-		new_hl = ip6h->hop_limit;
-		break;
-	}
-
-	ip6h->hop_limit = new_hl;
-
-	return XT_CONTINUE;
-}
-
-static int ttl_tg_check(const struct xt_tgchk_param *par)
-{
-	const struct ipt_TTL_info *info = par->targinfo;
-
-	if (info->mode > IPT_TTL_MAXMODE)
-		return -EINVAL;
-	if (info->mode != IPT_TTL_SET && info->ttl == 0)
-		return -EINVAL;
-	return 0;
-}
-
-static int hl_tg6_check(const struct xt_tgchk_param *par)
-{
-	const struct ip6t_HL_info *info = par->targinfo;
-
-	if (info->mode > IP6T_HL_MAXMODE)
-		return -EINVAL;
-	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
-		return -EINVAL;
-	return 0;
-}
-
-static struct xt_target hl_tg_reg[] __read_mostly = {
-	{
-		.name       = "TTL",
-		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = ttl_tg,
-		.targetsize = sizeof(struct ipt_TTL_info),
-		.table      = "mangle",
-		.checkentry = ttl_tg_check,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "HL",
-		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = hl_tg6,
-		.targetsize = sizeof(struct ip6t_HL_info),
-		.table      = "mangle",
-		.checkentry = hl_tg6_check,
-		.me         = THIS_MODULE,
-	},
-};
-
-static int __init hl_tg_init(void)
-{
-	return xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
-}
-
-static void __exit hl_tg_exit(void)
-{
-	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
-}
-
-module_init(hl_tg_init);
-module_exit(hl_tg_exit);
-MODULE_ALIAS("ipt_TTL");
-MODULE_ALIAS("ip6t_HL");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
deleted file mode 100644
index a86bb0e4bb42..000000000000
--- a/net/netfilter/xt_RATEEST.c
+++ /dev/null
@@ -1,248 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (C) 2007 Patrick McHardy <kaber@trash.net>
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/gen_stats.h>
-#include <linux/jhash.h>
-#include <linux/rtnetlink.h>
-#include <linux/random.h>
-#include <linux/slab.h>
-#include <net/gen_stats.h>
-#include <net/netlink.h>
-#include <net/netns/generic.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_rateest.h>
-#include <net/netfilter/xt_rateest.h>
-
-#define RATEEST_HSIZE	16
-
-struct xt_rateest_net {
-	struct mutex hash_lock;
-	struct hlist_head hash[RATEEST_HSIZE];
-};
-
-static unsigned int xt_rateest_id;
-
-static unsigned int jhash_rnd __read_mostly;
-
-static unsigned int xt_rateest_hash(const char *name)
-{
-	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
-	       (RATEEST_HSIZE - 1);
-}
-
-static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
-				   struct xt_rateest *est)
-{
-	unsigned int h;
-
-	h = xt_rateest_hash(est->name);
-	hlist_add_head(&est->list, &xn->hash[h]);
-}
-
-static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
-					      const char *name)
-{
-	struct xt_rateest *est;
-	unsigned int h;
-
-	h = xt_rateest_hash(name);
-	hlist_for_each_entry(est, &xn->hash[h], list) {
-		if (strcmp(est->name, name) == 0) {
-			est->refcnt++;
-			return est;
-		}
-	}
-
-	return NULL;
-}
-
-struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-	struct xt_rateest *est;
-
-	mutex_lock(&xn->hash_lock);
-	est = __xt_rateest_lookup(xn, name);
-	mutex_unlock(&xn->hash_lock);
-	return est;
-}
-EXPORT_SYMBOL_GPL(xt_rateest_lookup);
-
-void xt_rateest_put(struct net *net, struct xt_rateest *est)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-
-	mutex_lock(&xn->hash_lock);
-	if (--est->refcnt == 0) {
-		hlist_del(&est->list);
-		gen_kill_estimator(&est->rate_est);
-		/*
-		 * gen_estimator est_timer() might access est->lock or bstats,
-		 * wait a RCU grace period before freeing 'est'
-		 */
-		kfree_rcu(est, rcu);
-	}
-	mutex_unlock(&xn->hash_lock);
-}
-EXPORT_SYMBOL_GPL(xt_rateest_put);
-
-static unsigned int
-xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_rateest_target_info *info = par->targinfo;
-	struct gnet_stats_basic_sync *stats = &info->est->bstats;
-
-	spin_lock_bh(&info->est->lock);
-	u64_stats_add(&stats->bytes, skb->len);
-	u64_stats_inc(&stats->packets);
-	spin_unlock_bh(&info->est->lock);
-
-	return XT_CONTINUE;
-}
-
-static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
-{
-	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
-	struct xt_rateest_target_info *info = par->targinfo;
-	struct xt_rateest *est;
-	struct {
-		struct nlattr		opt;
-		struct gnet_estimator	est;
-	} cfg;
-	int ret;
-
-	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
-		return -ENAMETOOLONG;
-
-	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
-
-	mutex_lock(&xn->hash_lock);
-	est = __xt_rateest_lookup(xn, info->name);
-	if (est) {
-		mutex_unlock(&xn->hash_lock);
-		/*
-		 * If estimator parameters are specified, they must match the
-		 * existing estimator.
-		 */
-		if ((!info->interval && !info->ewma_log) ||
-		    (info->interval != est->params.interval ||
-		     info->ewma_log != est->params.ewma_log)) {
-			xt_rateest_put(par->net, est);
-			return -EINVAL;
-		}
-		info->est = est;
-		return 0;
-	}
-
-	ret = -ENOMEM;
-	est = kzalloc(sizeof(*est), GFP_KERNEL);
-	if (!est)
-		goto err1;
-
-	gnet_stats_basic_sync_init(&est->bstats);
-	strscpy(est->name, info->name, sizeof(est->name));
-	spin_lock_init(&est->lock);
-	est->refcnt		= 1;
-	est->params.interval	= info->interval;
-	est->params.ewma_log	= info->ewma_log;
-
-	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
-	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
-	cfg.est.interval	= info->interval;
-	cfg.est.ewma_log	= info->ewma_log;
-
-	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
-				&est->lock, NULL, &cfg.opt);
-	if (ret < 0)
-		goto err2;
-
-	info->est = est;
-	xt_rateest_hash_insert(xn, est);
-	mutex_unlock(&xn->hash_lock);
-	return 0;
-
-err2:
-	kfree(est);
-err1:
-	mutex_unlock(&xn->hash_lock);
-	return ret;
-}
-
-static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
-{
-	struct xt_rateest_target_info *info = par->targinfo;
-
-	xt_rateest_put(par->net, info->est);
-}
-
-static struct xt_target xt_rateest_tg_reg[] __read_mostly = {
-	{
-		.name       = "RATEEST",
-		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = xt_rateest_tg,
-		.checkentry = xt_rateest_tg_checkentry,
-		.destroy    = xt_rateest_tg_destroy,
-		.targetsize = sizeof(struct xt_rateest_target_info),
-		.usersize   = offsetof(struct xt_rateest_target_info, est),
-		.me         = THIS_MODULE,
-	},
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	{
-		.name       = "RATEEST",
-		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = xt_rateest_tg,
-		.checkentry = xt_rateest_tg_checkentry,
-		.destroy    = xt_rateest_tg_destroy,
-		.targetsize = sizeof(struct xt_rateest_target_info),
-		.usersize   = offsetof(struct xt_rateest_target_info, est),
-		.me         = THIS_MODULE,
-	},
-#endif
-};
-
-static __net_init int xt_rateest_net_init(struct net *net)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-	int i;
-
-	mutex_init(&xn->hash_lock);
-	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
-		INIT_HLIST_HEAD(&xn->hash[i]);
-	return 0;
-}
-
-static struct pernet_operations xt_rateest_net_ops = {
-	.init = xt_rateest_net_init,
-	.id   = &xt_rateest_id,
-	.size = sizeof(struct xt_rateest_net),
-};
-
-static int __init xt_rateest_tg_init(void)
-{
-	int err = register_pernet_subsys(&xt_rateest_net_ops);
-
-	if (err)
-		return err;
-	return xt_register_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
-}
-
-static void __exit xt_rateest_tg_fini(void)
-{
-	xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
-	unregister_pernet_subsys(&xt_rateest_net_ops);
-}
-
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Xtables: packet rate estimator");
-MODULE_ALIAS("ipt_RATEEST");
-MODULE_ALIAS("ip6t_RATEEST");
-module_init(xt_rateest_tg_init);
-module_exit(xt_rateest_tg_fini);
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
deleted file mode 100644
index 3dc1320237c2..000000000000
--- a/net/netfilter/xt_TCPMSS.c
+++ /dev/null
@@ -1,345 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * This is a module which is used for setting the MSS option in TCP packets.
- *
- * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
- * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/gfp.h>
-#include <linux/ipv6.h>
-#include <linux/tcp.h>
-#include <net/dst.h>
-#include <net/flow.h>
-#include <net/ipv6.h>
-#include <net/route.h>
-#include <net/tcp.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_tcpmss.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment");
-MODULE_ALIAS("ipt_TCPMSS");
-MODULE_ALIAS("ip6t_TCPMSS");
-
-static inline unsigned int
-optlen(const u_int8_t *opt, unsigned int offset)
-{
-	/* Beware zero-length options: make finite progress */
-	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
-		return 1;
-	else
-		return opt[offset+1];
-}
-
-static u_int32_t tcpmss_reverse_mtu(struct net *net,
-				    const struct sk_buff *skb,
-				    unsigned int family)
-{
-	struct flowi fl;
-	struct rtable *rt = NULL;
-	u_int32_t mtu     = ~0U;
-
-	if (family == PF_INET) {
-		struct flowi4 *fl4 = &fl.u.ip4;
-		memset(fl4, 0, sizeof(*fl4));
-		fl4->daddr = ip_hdr(skb)->saddr;
-	} else {
-		struct flowi6 *fl6 = &fl.u.ip6;
-
-		memset(fl6, 0, sizeof(*fl6));
-		fl6->daddr = ipv6_hdr(skb)->saddr;
-	}
-
-	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
-	if (rt != NULL) {
-		mtu = dst_mtu(&rt->dst);
-		dst_release(&rt->dst);
-	}
-	return mtu;
-}
-
-static int
-tcpmss_mangle_packet(struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     unsigned int family,
-		     unsigned int tcphoff,
-		     unsigned int minlen)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	struct tcphdr *tcph;
-	int len, tcp_hdrlen;
-	unsigned int i;
-	__be16 oldval;
-	u16 newmss;
-	u8 *opt;
-
-	/* This is a fragment, no TCP header is available */
-	if (par->fragoff != 0)
-		return 0;
-
-	if (skb_ensure_writable(skb, skb->len))
-		return -1;
-
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr))
-		return -1;
-
-	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
-	tcp_hdrlen = tcph->doff * 4;
-
-	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
-		return -1;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
-		struct net *net = xt_net(par);
-		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
-		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
-
-		if (min_mtu <= minlen) {
-			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
-					    min_mtu);
-			return -1;
-		}
-		newmss = min_mtu - minlen;
-	} else
-		newmss = info->mss;
-
-	opt = (u_int8_t *)tcph;
-	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
-		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
-			u_int16_t oldmss;
-
-			oldmss = (opt[i+2] << 8) | opt[i+3];
-
-			/* Never increase MSS, even when setting it, as
-			 * doing so results in problems for hosts that rely
-			 * on MSS being set correctly.
-			 */
-			if (oldmss <= newmss)
-				return 0;
-
-			opt[i+2] = (newmss & 0xff00) >> 8;
-			opt[i+3] = newmss & 0x00ff;
-
-			inet_proto_csum_replace2(&tcph->check, skb,
-						 htons(oldmss), htons(newmss),
-						 false);
-			return 0;
-		}
-	}
-
-	/* There is data after the header so the option can't be added
-	 * without moving it, and doing so may make the SYN packet
-	 * itself too large. Accept the packet unmodified instead.
-	 */
-	if (len > tcp_hdrlen)
-		return 0;
-
-	/* tcph->doff has 4 bits, do not wrap it to 0 */
-	if (tcp_hdrlen >= 15 * 4)
-		return 0;
-
-	/*
-	 * MSS Option not found ?! add it..
-	 */
-	if (skb_tailroom(skb) < TCPOLEN_MSS) {
-		if (pskb_expand_head(skb, 0,
-				     TCPOLEN_MSS - skb_tailroom(skb),
-				     GFP_ATOMIC))
-			return -1;
-		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
-	}
-
-	skb_put(skb, TCPOLEN_MSS);
-
-	/*
-	 * IPv4: RFC 1122 states "If an MSS option is not received at
-	 * connection setup, TCP MUST assume a default send MSS of 536".
-	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
-	 * length IPv6 header of 60, ergo the default MSS value is 1220
-	 * Since no MSS was provided, we must use the default values
-	 */
-	if (xt_family(par) == NFPROTO_IPV4)
-		newmss = min(newmss, (u16)536);
-	else
-		newmss = min(newmss, (u16)1220);
-
-	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
-	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
-
-	inet_proto_csum_replace2(&tcph->check, skb,
-				 htons(len), htons(len + TCPOLEN_MSS), true);
-	opt[0] = TCPOPT_MSS;
-	opt[1] = TCPOLEN_MSS;
-	opt[2] = (newmss & 0xff00) >> 8;
-	opt[3] = newmss & 0x00ff;
-
-	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
-
-	oldval = ((__be16 *)tcph)[6];
-	tcph->doff += TCPOLEN_MSS/4;
-	inet_proto_csum_replace2(&tcph->check, skb,
-				 oldval, ((__be16 *)tcph)[6], false);
-	return TCPOLEN_MSS;
-}
-
-static unsigned int
-tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct iphdr *iph = ip_hdr(skb);
-	__be16 newlen;
-	int ret;
-
-	ret = tcpmss_mangle_packet(skb, par,
-				   PF_INET,
-				   iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
-	if (ret < 0)
-		return NF_DROP;
-	if (ret > 0) {
-		iph = ip_hdr(skb);
-		newlen = htons(ntohs(iph->tot_len) + ret);
-		csum_replace2(&iph->check, iph->tot_len, newlen);
-		iph->tot_len = newlen;
-	}
-	return XT_CONTINUE;
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static unsigned int
-tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	u8 nexthdr;
-	__be16 frag_off, oldlen, newlen;
-	int tcphoff;
-	int ret;
-
-	nexthdr = ipv6h->nexthdr;
-	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
-	if (tcphoff < 0)
-		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, par,
-				   PF_INET6,
-				   tcphoff,
-				   sizeof(*ipv6h) + sizeof(struct tcphdr));
-	if (ret < 0)
-		return NF_DROP;
-	if (ret > 0) {
-		ipv6h = ipv6_hdr(skb);
-		oldlen = ipv6h->payload_len;
-		newlen = htons(ntohs(oldlen) + ret);
-		if (skb->ip_summed == CHECKSUM_COMPLETE)
-			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
-					     (__force __wsum)newlen);
-		ipv6h->payload_len = newlen;
-	}
-	return XT_CONTINUE;
-}
-#endif
-
-/* Must specify -p tcp --syn */
-static inline bool find_syn_match(const struct xt_entry_match *m)
-{
-	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
-
-	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
-	    tcpinfo->flg_cmp & TCPHDR_SYN &&
-	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
-		return true;
-
-	return false;
-}
-
-static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
-	if (par->nft_compat)
-		return 0;
-
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
-	pr_info_ratelimited("Only works on TCP SYN packets\n");
-	return -EINVAL;
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ip6t_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
-	if (par->nft_compat)
-		return 0;
-
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
-	pr_info_ratelimited("Only works on TCP SYN packets\n");
-	return -EINVAL;
-}
-#endif
-
-static struct xt_target tcpmss_tg_reg[] __read_mostly = {
-	{
-		.family		= NFPROTO_IPV4,
-		.name		= "TCPMSS",
-		.checkentry	= tcpmss_tg4_check,
-		.target		= tcpmss_tg4,
-		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
-		.me		= THIS_MODULE,
-	},
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	{
-		.family		= NFPROTO_IPV6,
-		.name		= "TCPMSS",
-		.checkentry	= tcpmss_tg6_check,
-		.target		= tcpmss_tg6,
-		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
-		.me		= THIS_MODULE,
-	},
-#endif
-};
-
-static int __init tcpmss_tg_init(void)
-{
-	return xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
-}
-
-static void __exit tcpmss_tg_exit(void)
-{
-	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
-}
-
-module_init(tcpmss_tg_init);
-module_exit(tcpmss_tg_exit);
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f9bb..232ecc82ec28 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -1,7 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* IP tables module for matching the value of the IPv4/IPv6 DSCP field
+/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
+ * IP tables module for matching and setting the value of the IPv4/IPv6 DSCP field
  *
  * (C) 2002 by Harald Welte <laforge@netfilter.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
@@ -14,12 +18,19 @@
 #include <linux/netfilter/xt_dscp.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field match");
+MODULE_DESCRIPTION("Xtables: DSCP/TOS field match and target modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 MODULE_ALIAS("ipt_tos");
 MODULE_ALIAS("ip6t_tos");
+MODULE_ALIAS("ipt_DSCP");
+MODULE_ALIAS("ip6t_DSCP");
+MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
+MODULE_ALIAS("xt_DSCP");
+
+#define XT_DSCP_ECN_MASK	3u
 
 static bool
 dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -96,15 +107,146 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init dscp_mt_init(void)
+static unsigned int
+dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_DSCP_info *dinfo = par->targinfo;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static unsigned int
+dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	const struct xt_DSCP_info *dinfo = par->targinfo;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
+			return NF_DROP;
+
+		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static int dscp_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_DSCP_info *info = par->targinfo;
+
+	if (info->dscp > XT_DSCP_MAX)
+		return -EDOM;
+	return 0;
+}
+
+static unsigned int
+tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u8 orig, nv;
+
+	orig = ipv4_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ip_hdr(skb);
+		ipv4_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	u8 orig, nv;
+
+	orig = ipv6_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ipv6_hdr(skb);
+		ipv6_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target dscp_tg_reg[] __read_mostly = {
+	{
+		.name		= "DSCP",
+		.family		= NFPROTO_IPV4,
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "DSCP",
+		.family		= NFPROTO_IPV6,
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg6,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= NFPROTO_IPV4,
+		.table		= "mangle",
+		.target		= tos_tg,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= NFPROTO_IPV6,
+		.table		= "mangle",
+		.target		= tos_tg6,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init dscp_init(void)
+{
+	int ret;
+
+	ret = xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit dscp_mt_exit(void)
+static void __exit dscp_exit(void)
 {
 	xt_unregister_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
 }
 
-module_init(dscp_mt_init);
-module_exit(dscp_mt_exit);
+module_init(dscp_init);
+module_exit(dscp_exit);
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0441..5b7aabab3031 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -5,22 +5,33 @@
  *
  * Hop Limit matching module
  * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ *
+ * TTL modification target for IP tables
+ * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * Hop Limit modification target for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
-
-#include <linux/ip.h>
-#include <linux/ipv6.h>
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match");
+MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match and target modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_ttl");
 MODULE_ALIAS("ip6t_hl");
+MODULE_ALIAS("ipt_TTL");
+MODULE_ALIAS("ip6t_HL");
+MODULE_ALIAS("xt_HL");
 
 static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -79,15 +90,146 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init hl_mt_init(void)
+static unsigned int
+ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph;
+	const struct ipt_TTL_info *info = par->targinfo;
+	int new_ttl;
+
+	if (skb_ensure_writable(skb, sizeof(*iph)))
+		return NF_DROP;
+
+	iph = ip_hdr(skb);
+
+	switch (info->mode) {
+	case IPT_TTL_SET:
+		new_ttl = info->ttl;
+		break;
+	case IPT_TTL_INC:
+		new_ttl = iph->ttl + info->ttl;
+		if (new_ttl > 255)
+			new_ttl = 255;
+		break;
+	case IPT_TTL_DEC:
+		new_ttl = iph->ttl - info->ttl;
+		if (new_ttl < 0)
+			new_ttl = 0;
+		break;
+	default:
+		new_ttl = iph->ttl;
+		break;
+	}
+
+	if (new_ttl != iph->ttl) {
+		csum_replace2(&iph->check, htons(iph->ttl << 8), htons(new_ttl << 8));
+		iph->ttl = new_ttl;
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ip6h;
+	const struct ip6t_HL_info *info = par->targinfo;
+	int new_hl;
+
+	if (skb_ensure_writable(skb, sizeof(*ip6h)))
+		return NF_DROP;
+
+	ip6h = ipv6_hdr(skb);
+
+	switch (info->mode) {
+	case IP6T_HL_SET:
+		new_hl = info->hop_limit;
+		break;
+	case IP6T_HL_INC:
+		new_hl = ip6h->hop_limit + info->hop_limit;
+		if (new_hl > 255)
+			new_hl = 255;
+		break;
+	case IP6T_HL_DEC:
+		new_hl = ip6h->hop_limit - info->hop_limit;
+		if (new_hl < 0)
+			new_hl = 0;
+		break;
+	default:
+		new_hl = ip6h->hop_limit;
+		break;
+	}
+
+	ip6h->hop_limit = new_hl;
+
+	return XT_CONTINUE;
+}
+
+static int ttl_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct ipt_TTL_info *info = par->targinfo;
+
+	if (info->mode > IPT_TTL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IPT_TTL_SET && info->ttl == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int hl_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct ip6t_HL_info *info = par->targinfo;
+
+	if (info->mode > IP6T_HL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static struct xt_target hl_tg_reg[] __read_mostly = {
+	{
+		.name       = "TTL",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.target     = ttl_tg,
+		.targetsize = sizeof(struct ipt_TTL_info),
+		.table      = "mangle",
+		.checkentry = ttl_tg_check,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "HL",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.target     = hl_tg6,
+		.targetsize = sizeof(struct ip6t_HL_info),
+		.table      = "mangle",
+		.checkentry = hl_tg6_check,
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init hl_init(void)
 {
-	return xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	int ret;
+
+	ret = xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit hl_mt_exit(void)
+static void __exit hl_exit(void)
 {
 	xt_unregister_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
 }
 
-module_init(hl_mt_init);
-module_exit(hl_mt_exit);
+module_init(hl_init);
+module_exit(hl_exit);
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 72324bd976af..c0153b5b47a0 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -5,11 +5,28 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/gen_stats.h>
+#include <linux/jhash.h>
+#include <linux/rtnetlink.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <net/gen_stats.h>
+#include <net/netlink.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
+#define RATEEST_HSIZE	16
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("xtables packet rate estimator");
+MODULE_ALIAS("ipt_rateest");
+MODULE_ALIAS("ip6t_rateest");
+MODULE_ALIAS("ipt_RATEEST");
+MODULE_ALIAS("ip6t_RATEEST");
+MODULE_ALIAS("xt_RATEEST");
 
 static bool
 xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -134,20 +151,236 @@ static struct xt_match xt_rateest_mt_reg __read_mostly = {
 	.me         = THIS_MODULE,
 };
 
-static int __init xt_rateest_mt_init(void)
+struct xt_rateest_net {
+	/* To synchronize concurrent synchronous rate estimator operations. */
+	struct mutex hash_lock;
+	struct hlist_head hash[RATEEST_HSIZE];
+};
+
+static unsigned int xt_rateest_id;
+
+static unsigned int jhash_rnd __read_mostly;
+
+static unsigned int xt_rateest_hash(const char *name)
+{
+	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
+	       (RATEEST_HSIZE - 1);
+}
+
+static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
+				   struct xt_rateest *est)
+{
+	unsigned int h;
+
+	h = xt_rateest_hash(est->name);
+	hlist_add_head(&est->list, &xn->hash[h]);
+}
+
+static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
+					      const char *name)
 {
-	return xt_register_match(&xt_rateest_mt_reg);
+	struct xt_rateest *est;
+	unsigned int h;
+
+	h = xt_rateest_hash(name);
+	hlist_for_each_entry(est, &xn->hash[h], list) {
+		if (strcmp(est->name, name) == 0) {
+			est->refcnt++;
+			return est;
+		}
+	}
+
+	return NULL;
 }
 
-static void __exit xt_rateest_mt_fini(void)
+struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	struct xt_rateest *est;
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, name);
+	mutex_unlock(&xn->hash_lock);
+	return est;
+}
+EXPORT_SYMBOL_GPL(xt_rateest_lookup);
+
+void xt_rateest_put(struct net *net, struct xt_rateest *est)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+
+	mutex_lock(&xn->hash_lock);
+	if (--est->refcnt == 0) {
+		hlist_del(&est->list);
+		gen_kill_estimator(&est->rate_est);
+		/*
+		 * gen_estimator est_timer() might access est->lock or bstats,
+		 * wait a RCU grace period before freeing 'est'
+		 */
+		kfree_rcu(est, rcu);
+	}
+	mutex_unlock(&xn->hash_lock);
+}
+EXPORT_SYMBOL_GPL(xt_rateest_put);
+
+static unsigned int
+xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_rateest_target_info *info = par->targinfo;
+	struct gnet_stats_basic_sync *stats = &info->est->bstats;
+
+	spin_lock_bh(&info->est->lock);
+	u64_stats_add(&stats->bytes, skb->len);
+	u64_stats_inc(&stats->packets);
+	spin_unlock_bh(&info->est->lock);
+
+	return XT_CONTINUE;
+}
+
+static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
+	struct xt_rateest_target_info *info = par->targinfo;
+	struct xt_rateest *est;
+	struct {
+		struct nlattr		opt;
+		struct gnet_estimator	est;
+	} cfg;
+	int ret;
+
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
+	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, info->name);
+	if (est) {
+		mutex_unlock(&xn->hash_lock);
+		/*
+		 * If estimator parameters are specified, they must match the
+		 * existing estimator.
+		 */
+		if ((!info->interval && !info->ewma_log) ||
+		    (info->interval != est->params.interval ||
+		     info->ewma_log != est->params.ewma_log)) {
+			xt_rateest_put(par->net, est);
+			return -EINVAL;
+		}
+		info->est = est;
+		return 0;
+	}
+
+	ret = -ENOMEM;
+	est = kzalloc(sizeof(*est), GFP_KERNEL);
+	if (!est)
+		goto err1;
+
+	gnet_stats_basic_sync_init(&est->bstats);
+	strscpy(est->name, info->name, sizeof(est->name));
+	spin_lock_init(&est->lock);
+	est->refcnt		= 1;
+	est->params.interval	= info->interval;
+	est->params.ewma_log	= info->ewma_log;
+
+	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
+	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
+	cfg.est.interval	= info->interval;
+	cfg.est.ewma_log	= info->ewma_log;
+
+	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
+				&est->lock, NULL, &cfg.opt);
+	if (ret < 0)
+		goto err2;
+
+	info->est = est;
+	xt_rateest_hash_insert(xn, est);
+	mutex_unlock(&xn->hash_lock);
+	return 0;
+
+err2:
+	kfree(est);
+err1:
+	mutex_unlock(&xn->hash_lock);
+	return ret;
+}
+
+static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	struct xt_rateest_target_info *info = par->targinfo;
+
+	xt_rateest_put(par->net, info->est);
+}
+
+static struct xt_target xt_rateest_tg_reg[] __read_mostly = {
+	{
+		.name       = "RATEEST",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.target     = xt_rateest_tg,
+		.checkentry = xt_rateest_tg_checkentry,
+		.destroy    = xt_rateest_tg_destroy,
+		.targetsize = sizeof(struct xt_rateest_target_info),
+		.usersize   = offsetof(struct xt_rateest_target_info, est),
+		.me         = THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.name       = "RATEEST",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.target     = xt_rateest_tg,
+		.checkentry = xt_rateest_tg_checkentry,
+		.destroy    = xt_rateest_tg_destroy,
+		.targetsize = sizeof(struct xt_rateest_target_info),
+		.usersize   = offsetof(struct xt_rateest_target_info, est),
+		.me         = THIS_MODULE,
+	},
+#endif
+};
+
+static __net_init int xt_rateest_net_init(struct net *net)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	int i;
+
+	mutex_init(&xn->hash_lock);
+	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
+		INIT_HLIST_HEAD(&xn->hash[i]);
+	return 0;
+}
+
+static struct pernet_operations xt_rateest_net_ops = {
+	.init = xt_rateest_net_init,
+	.id   = &xt_rateest_id,
+	.size = sizeof(struct xt_rateest_net),
+};
+
+static int __init xt_rateest_init(void)
+{
+	int ret = register_pernet_subsys(&xt_rateest_net_ops);
+
+	if (ret)
+		return ret;
+
+	ret = xt_register_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_match(&xt_rateest_mt_reg);
+	if (ret < 0) {
+		xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+		unregister_pernet_subsys(&xt_rateest_net_ops);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit xt_rateest_exit(void)
 {
 	xt_unregister_match(&xt_rateest_mt_reg);
+	xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+	unregister_pernet_subsys(&xt_rateest_net_ops);
 }
 
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("xtables rate estimator match");
-MODULE_ALIAS("ipt_rateest");
-MODULE_ALIAS("ip6t_rateest");
-module_init(xt_rateest_mt_init);
-module_exit(xt_rateest_mt_fini);
+module_init(xt_rateest_init);
+module_exit(xt_rateest_exit);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab01799..b33c13b7bc01 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -1,25 +1,38 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Kernel module to match TCP MSS values. */
-
-/* Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+/* Kernel module to match TCP MSS values.
+ * This is a module which is used for setting the MSS option in TCP packets.
+ *
+ * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
  * Portions (C) 2005 by Harald Welte <laforge@netfilter.org>
+ * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/gfp.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/dst.h>
+#include <net/flow.h>
+#include <net/ipv6.h>
+#include <net/route.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter/xt_tcpmss.h>
-#include <linux/netfilter/x_tables.h>
-
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP MSS match");
+MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment and match");
 MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
+MODULE_ALIAS("ipt_TCPMSS");
+MODULE_ALIAS("ip6t_TCPMSS");
+MODULE_ALIAS("xt_TCPMSS");
 
 static bool
 tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -93,15 +106,329 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init tcpmss_mt_init(void)
+static inline unsigned int
+optlen(const u8 *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset + 1] == 0)
+		return 1;
+	else
+		return opt[offset + 1];
+}
+
+static u_int32_t tcpmss_reverse_mtu(struct net *net,
+				    const struct sk_buff *skb,
+				    unsigned int family)
+{
+	struct flowi fl;
+	struct rtable *rt = NULL;
+	u32 mtu     = ~0U;
+
+	if (family == PF_INET) {
+		struct flowi4 *fl4 = &fl.u.ip4;
+
+		memset(fl4, 0, sizeof(*fl4));
+		fl4->daddr = ip_hdr(skb)->saddr;
+	} else {
+		struct flowi6 *fl6 = &fl.u.ip6;
+
+		memset(fl6, 0, sizeof(*fl6));
+		fl6->daddr = ipv6_hdr(skb)->saddr;
+	}
+
+	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
+	if (rt) {
+		mtu = dst_mtu(&rt->dst);
+		dst_release(&rt->dst);
+	}
+	return mtu;
+}
+
+static int
+tcpmss_mangle_packet(struct sk_buff *skb,
+		     const struct xt_action_param *par,
+		     unsigned int family,
+		     unsigned int tcphoff,
+		     unsigned int minlen)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	struct tcphdr *tcph;
+	int len, tcp_hdrlen;
+	unsigned int i;
+	__be16 oldval;
+	u16 newmss;
+	u8 *opt;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return 0;
+
+	if (skb_ensure_writable(skb, skb->len))
+		return -1;
+
+	len = skb->len - tcphoff;
+	if (len < (int)sizeof(struct tcphdr))
+		return -1;
+
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	tcp_hdrlen = tcph->doff * 4;
+
+	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
+		return -1;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
+		struct net *net = xt_net(par);
+		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
+		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
+
+		if (min_mtu <= minlen) {
+			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
+					    min_mtu);
+			return -1;
+		}
+		newmss = min_mtu - minlen;
+	} else {
+		newmss = info->mss;
+	}
+
+	opt = (u_int8_t *)tcph;
+	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
+		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
+			u16 oldmss;
+
+			oldmss = (opt[i + 2] << 8) | opt[i + 3];
+
+			/* Never increase MSS, even when setting it, as
+			 * doing so results in problems for hosts that rely
+			 * on MSS being set correctly.
+			 */
+			if (oldmss <= newmss)
+				return 0;
+
+			opt[i + 2] = (newmss & 0xff00) >> 8;
+			opt[i + 3] = newmss & 0x00ff;
+
+			inet_proto_csum_replace2(&tcph->check, skb,
+						 htons(oldmss), htons(newmss),
+						 false);
+			return 0;
+		}
+	}
+
+	/* There is data after the header so the option can't be added
+	 * without moving it, and doing so may make the SYN packet
+	 * itself too large. Accept the packet unmodified instead.
+	 */
+	if (len > tcp_hdrlen)
+		return 0;
+
+	/* tcph->doff has 4 bits, do not wrap it to 0 */
+	if (tcp_hdrlen >= 15 * 4)
+		return 0;
+
+	/*
+	 * MSS Option not found ?! add it..
+	 */
+	if (skb_tailroom(skb) < TCPOLEN_MSS) {
+		if (pskb_expand_head(skb, 0,
+				     TCPOLEN_MSS - skb_tailroom(skb),
+				     GFP_ATOMIC))
+			return -1;
+		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	}
+
+	skb_put(skb, TCPOLEN_MSS);
+
+	/*
+	 * IPv4: RFC 1122 states "If an MSS option is not received at
+	 * connection setup, TCP MUST assume a default send MSS of 536".
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
+	 */
+	if (xt_family(par) == NFPROTO_IPV4)
+		newmss = min(newmss, (u16)536);
+	else
+		newmss = min(newmss, (u16)1220);
+
+	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
+
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 htons(len), htons(len + TCPOLEN_MSS), true);
+	opt[0] = TCPOPT_MSS;
+	opt[1] = TCPOLEN_MSS;
+	opt[2] = (newmss & 0xff00) >> 8;
+	opt[3] = newmss & 0x00ff;
+
+	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
+
+	oldval = ((__be16 *)tcph)[6];
+	tcph->doff += TCPOLEN_MSS / 4;
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 oldval, ((__be16 *)tcph)[6], false);
+	return TCPOLEN_MSS;
+}
+
+static unsigned int
+tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	__be16 newlen;
+	int ret;
+
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET,
+				   iph->ihl * 4,
+				   sizeof(*iph) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		iph = ip_hdr(skb);
+		newlen = htons(ntohs(iph->tot_len) + ret);
+		csum_replace2(&iph->check, iph->tot_len, newlen);
+		iph->tot_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static unsigned int
+tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	u8 nexthdr;
+	__be16 frag_off, oldlen, newlen;
+	int tcphoff;
+	int ret;
+
+	nexthdr = ipv6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
+	if (tcphoff < 0)
+		return NF_DROP;
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET6,
+				   tcphoff,
+				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		ipv6h = ipv6_hdr(skb);
+		oldlen = ipv6h->payload_len;
+		newlen = htons(ntohs(oldlen) + ret);
+		if (skb->ip_summed == CHECKSUM_COMPLETE)
+			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
+					     (__force __wsum)newlen);
+		ipv6h->payload_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+#endif
+
+/* Must specify -p tcp --syn */
+static inline bool find_syn_match(const struct xt_entry_match *m)
+{
+	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
+
+	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
+	    tcpinfo->flg_cmp & TCPHDR_SYN &&
+	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
+		return true;
+
+	return false;
+}
+
+static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+#endif
+
+static struct xt_target tcpmss_tg_reg[] __read_mostly = {
+	{
+		.family		= NFPROTO_IPV4,
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg4_check,
+		.target		= tcpmss_tg4,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.family		= NFPROTO_IPV6,
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg6_check,
+		.target		= tcpmss_tg6,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+#endif
+};
+
+static int __init tcpmss_init(void)
 {
-	return xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	int ret;
+
+	ret = xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit tcpmss_mt_exit(void)
+static void __exit tcpmss_exit(void)
 {
 	xt_unregister_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
 }
 
-module_init(tcpmss_mt_init);
-module_exit(tcpmss_mt_exit);
+module_init(tcpmss_init);
+module_exit(tcpmss_exit);
-- 
2.43.5


From b95947d9978f24989b3a6b89da7142fe153ca6e9 Mon Sep 17 00:00:00 2001
From: Benjamin Szőke <egyszeregy@freemail.hu>
Date: Sun, 5 Jan 2025 21:03:48 +0100
Subject: [PATCH v5 3/3] netfilter: x_tables: Adjust code style for xt_*.h/c
 and ipt_*.h files.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

- Change to use u8, u16 and u32 types.
- Adjust tab indents
- Fix #define macros format

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 include/uapi/linux/netfilter/xt_dscp.h      |  6 +++---
 include/uapi/linux/netfilter/xt_rateest.h   |  4 ++--
 include/uapi/linux/netfilter/xt_tcpmss.h    |  6 +++---
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h |  8 ++++----
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h |  3 +--
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h |  3 +--
 net/netfilter/xt_dscp.c                     |  6 +++---
 net/netfilter/xt_rateest.c                  |  4 ++--
 net/netfilter/xt_tcpmss.c                   | 10 ++++------
 9 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
index 01e8611cd26e..70d724612485 100644
--- a/include/uapi/linux/netfilter/xt_dscp.h
+++ b/include/uapi/linux/netfilter/xt_dscp.h
@@ -15,9 +15,9 @@
 
 #include <linux/types.h>
 
-#define XT_DSCP_MASK	0xfc	/* 11111100 */
-#define XT_DSCP_SHIFT	2
-#define XT_DSCP_MAX	0x3f	/* 00111111 */
+#define XT_DSCP_MASK	(0xfc)	/* 11111100 */
+#define XT_DSCP_SHIFT	(2)
+#define XT_DSCP_MAX		(0x3f)	/* 00111111 */
 
 /* match info */
 struct xt_dscp_info {
diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/linux/netfilter/xt_rateest.h
index da9727fa527b..f719bd501d1a 100644
--- a/include/uapi/linux/netfilter/xt_rateest.h
+++ b/include/uapi/linux/netfilter/xt_rateest.h
@@ -22,8 +22,8 @@ enum xt_rateest_match_mode {
 };
 
 struct xt_rateest_match_info {
-	char			name1[IFNAMSIZ];
-	char			name2[IFNAMSIZ];
+	char		name1[IFNAMSIZ];
+	char		name2[IFNAMSIZ];
 	__u16		flags;
 	__u16		mode;
 	__u32		bps1;
diff --git a/include/uapi/linux/netfilter/xt_tcpmss.h b/include/uapi/linux/netfilter/xt_tcpmss.h
index 3ee4acaa6e03..ad858ae93e6a 100644
--- a/include/uapi/linux/netfilter/xt_tcpmss.h
+++ b/include/uapi/linux/netfilter/xt_tcpmss.h
@@ -4,11 +4,11 @@
 
 #include <linux/types.h>
 
-#define XT_TCPMSS_CLAMP_PMTU	0xffff
+#define XT_TCPMSS_CLAMP_PMTU	(0xffff)
 
 struct xt_tcpmss_match_info {
-    __u16 mss_min, mss_max;
-    __u8 invert;
+	__u16 mss_min, mss_max;
+	__u8 invert;
 };
 
 struct xt_tcpmss_info {
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
index a6d479aece21..0594dd49d13f 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ecn.h
@@ -16,10 +16,10 @@
 
 #define ipt_ecn_info xt_ecn_info
 
-#define IPT_ECN_OP_SET_IP	0x01	/* set ECN bits of IPv4 header */
-#define IPT_ECN_OP_SET_ECE	0x10	/* set ECE bit of TCP header */
-#define IPT_ECN_OP_SET_CWR	0x20	/* set CWR bit of TCP header */
-#define IPT_ECN_OP_MASK		0xce
+#define IPT_ECN_OP_SET_IP	(0x01)	/* set ECN bits of IPv4 header */
+#define IPT_ECN_OP_SET_ECE	(0x10)	/* set ECE bit of TCP header */
+#define IPT_ECN_OP_SET_CWR	(0x20)	/* set CWR bit of TCP header */
+#define IPT_ECN_OP_MASK		(0xce)
 
 enum {
 	IPT_ECN_IP_MASK       = XT_ECN_IP_MASK,
diff --git a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
index e7b8d6c58264..fda5296f3e10 100644
--- a/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
+++ b/include/uapi/linux/netfilter_ipv4/ipt_ttl.h
@@ -11,13 +11,12 @@
 #include <linux/types.h>
 
 enum {
-	IPT_TTL_EQ = 0,		/* equals */
+	IPT_TTL_EQ = 0,	/* equals */
 	IPT_TTL_NE,		/* not equals */
 	IPT_TTL_LT,		/* less than */
 	IPT_TTL_GT,		/* greater than */
 };
 
-
 struct ipt_ttl_info {
 	__u8	mode;
 	__u8	ttl;
diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
index cace0c7b649f..a5db7c630674 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_hl.h
@@ -11,13 +11,12 @@
 #include <linux/types.h>
 
 enum {
-	IP6T_HL_EQ = 0,		/* equals */
+	IP6T_HL_EQ = 0,	/* equals */
 	IP6T_HL_NE,		/* not equals */
 	IP6T_HL_LT,		/* less than */
 	IP6T_HL_GT,		/* greater than */
 };
 
-
 struct ip6t_hl_info {
 	__u8	mode;
 	__u8	hop_limit;
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 232ecc82ec28..2f0e51a836e7 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -30,13 +30,13 @@ MODULE_ALIAS("ipt_TOS");
 MODULE_ALIAS("ip6t_TOS");
 MODULE_ALIAS("xt_DSCP");
 
-#define XT_DSCP_ECN_MASK	3u
+#define XT_DSCP_ECN_MASK	(3u)
 
 static bool
 dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
@@ -45,7 +45,7 @@ static bool
 dscp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index c0153b5b47a0..b31458079c3e 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
-#define RATEEST_HSIZE	16
+#define RATEEST_HSIZE	(16)
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
@@ -33,7 +33,7 @@ xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est64 sample = {0};
-	u_int32_t bps1, bps2, pps1, pps2;
+	u32 bps1, bps2, pps1, pps2;
 	bool ret = true;
 
 	gen_estimator_read(&info->est1->rate_est, &sample);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index b33c13b7bc01..3bf8e6387af9 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -41,7 +41,7 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	const u_int8_t *op;
+	const u8 *op;
 	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
@@ -116,9 +116,7 @@ optlen(const u8 *opt, unsigned int offset)
 		return opt[offset + 1];
 }
 
-static u_int32_t tcpmss_reverse_mtu(struct net *net,
-				    const struct sk_buff *skb,
-				    unsigned int family)
+static u32 tcpmss_reverse_mtu(struct net *net, const struct sk_buff *skb, unsigned int family)
 {
 	struct flowi fl;
 	struct rtable *rt = NULL;
@@ -191,7 +189,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		newmss = info->mss;
 	}
 
-	opt = (u_int8_t *)tcph;
+	opt = (u8 *)tcph;
 	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
 		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
 			u16 oldmss;
@@ -251,7 +249,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	else
 		newmss = min(newmss, (u16)1220);
 
-	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	opt = (u8 *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
 
 	inet_proto_csum_replace2(&tcph->check, skb,
-- 
2.43.5

