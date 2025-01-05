Received: from smtp-out.freemail.hu (fmfe28.freemail.hu [46.107.16.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCAC647;
	Sun,  5 Jan 2025 23:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736119173; cv=none; b=dW+xT8db3YhmaVV4mq3zjpa2TpjX0kU1K/PR5gr834O2sqi8rN6mXqMXWE4SjVSuWnPCZB0Z3WwCVMuenE+UMArrD9NQUUlPrwOfuv6MONwg4ZM1dYESaGkk5uG6xgc6MofdiApWmWzmf60CQNvBS7wEDymR2zbJtuCdM1n6FH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736119173; c=relaxed/simple;
	bh=vUdIdvpbOJnFt9pPvvuAoqdFbnkH6BqKWVrLIN4k2UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/pG+UgPj4v8LHaaNftKQdysjkganIvdyYuORj9xtnr4V6jmu0hETODdHFfMlwWiAOxSDAW/7UI+OatAFvnxAQUKiYhbeLib6jwve/Dqzdx57OMsbaaxEhfr9Y+bdGTcTElx84g8AG0VvLBZaMlBS+vQgh9u62qOU4qGwdrtcKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=aq9XNPxa reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="aq9XNPxa"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRCv12PCzz15p0;
	Mon, 06 Jan 2025 00:19:25 +0100 (CET)
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
Subject: [PATCH v6 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h files which has same name.
Date: Mon,  6 Jan 2025 00:18:58 +0100
Message-ID: <20250105231900.6222-2-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250105231900.6222-1-egyszeregy@freemail.hu>
References: <20250105231900.6222-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736119166;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=18227; bh=i+jRX1gebytrbt6a1DCjiUcGfnUUdyJCuHR1B0k2q6Q=;
	b=aq9XNPxaqS1jjQNF6rQ3TnYuJiXamSgACrmfWYzyZf7WlKcwKm79N1k9cQh7G7Jp
	3vBBEBuPHlJseMUigZjwBw33vm5gXyowVW2l0z//HkQHbKu4q5EKyaiq4egeHmdfExK
	/lHo2nvDbxrfe3mCt12h/vOGEkp3rkoMQ8UJmhTjrmvI659QzbNUtptBYMXD6J4ftKR
	KEMN1NejwDLXfXbZkheGkIxcXqALCyYzlEOP/k38Nnc0fwD+hmRyUH/IvlLOAlF26jm
	EPyyzMlS4J5ej8mVVNm3tks6ufK8pM1kaoMXt3n4Agnrox1QA7/CFIDa/X3OrYbmM0F
	aOrlRRR1fg==

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

