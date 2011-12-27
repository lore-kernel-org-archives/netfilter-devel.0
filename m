From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] netfilter: xtables: move ipt_ecn to xt_ecn
Date: Tue, 27 Dec 2011 19:57:49 +0100
Message-ID: <1325012273-11779-2-git-send-email-jengelh@medozas.de>
References: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35711 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1L0S54 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:57:56 -0500
In-Reply-To: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepare the ECN match for augmentation by an IPv6 counterpart. Since
no symbol dependencies to ipv6.ko are added, having a single ecn match
module is the more so welcome.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/xt_ecn.h                   |   35 ++++++++++++++++++++
 include/linux/netfilter_ipv4/ipt_ecn.h             |   31 +-----------------
 net/ipv4/netfilter/Kconfig                         |   10 +++---
 net/ipv4/netfilter/Makefile                        |    1 -
 net/netfilter/Kconfig                              |    9 +++++
 net/netfilter/Makefile                             |    1 +
 .../netfilter/ipt_ecn.c => netfilter/xt_ecn.c}     |    1 +
 8 files changed, 53 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ecn.h
 rename net/{ipv4/netfilter/ipt_ecn.c => netfilter/xt_ecn.c} (99%)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index e630a2e..e144f54 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -43,6 +43,7 @@ header-y += xt_cpu.h
 header-y += xt_dccp.h
 header-y += xt_devgroup.h
 header-y += xt_dscp.h
+header-y += xt_ecn.h
 header-y += xt_esp.h
 header-y += xt_hashlimit.h
 header-y += xt_helper.h
diff --git a/include/linux/netfilter/xt_ecn.h b/include/linux/netfilter/xt_ecn.h
new file mode 100644
index 0000000..065c1a5
--- /dev/null
+++ b/include/linux/netfilter/xt_ecn.h
@@ -0,0 +1,35 @@
+/* iptables module for matching the ECN header in IPv4 and TCP header
+ *
+ * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ * 
+ * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
+*/
+#ifndef _XT_ECN_H
+#define _XT_ECN_H
+
+#include <linux/types.h>
+#include <linux/netfilter/xt_dscp.h>
+
+#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
+
+#define IPT_ECN_OP_MATCH_IP	0x01
+#define IPT_ECN_OP_MATCH_ECE	0x10
+#define IPT_ECN_OP_MATCH_CWR	0x20
+
+#define IPT_ECN_OP_MATCH_MASK	0xce
+
+/* match info */
+struct ipt_ecn_info {
+	__u8 operation;
+	__u8 invert;
+	__u8 ip_ect;
+	union {
+		struct {
+			__u8 ect;
+		} tcp;
+	} proto;
+};
+
+#endif /* _XT_ECN_H */
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
index eabf95f..b1124ec 100644
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/linux/netfilter_ipv4/ipt_ecn.h
@@ -1,35 +1,6 @@
-/* iptables module for matching the ECN header in IPv4 and TCP header
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
-*/
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H
 
-#include <linux/types.h>
-#include <linux/netfilter/xt_dscp.h>
-
-#define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
-
-#define IPT_ECN_OP_MATCH_IP	0x01
-#define IPT_ECN_OP_MATCH_ECE	0x10
-#define IPT_ECN_OP_MATCH_CWR	0x20
-
-#define IPT_ECN_OP_MATCH_MASK	0xce
-
-/* match info */
-struct ipt_ecn_info {
-	__u8 operation;
-	__u8 invert;
-	__u8 ip_ect;
-	union {
-		struct {
-			__u8 ect;
-		} tcp;
-	} proto;
-};
+#include <linux/netfilter/xt_ecn.h>
 
 #endif /* _IPT_ECN_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 7e1f5cd..53b9c79 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -76,11 +76,11 @@ config IP_NF_MATCH_AH
 config IP_NF_MATCH_ECN
 	tristate '"ecn" match support'
 	depends on NETFILTER_ADVANCED
-	help
-	  This option adds a `ECN' match, which allows you to match against
-	  the IPv4 and TCP header ECN fields.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	select NETFILTER_XT_MATCH_ECN
+	---help---
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_MATCH_ECN.
 
 config IP_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 123dd88..213a462 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -49,7 +49,6 @@ obj-$(CONFIG_IP_NF_SECURITY) += iptable_security.o
 
 # matches
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
-obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_RPFILTER) += ipt_rpfilter.o
 
 # targets
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index bac93ba..20388a9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -778,6 +778,15 @@ config NETFILTER_XT_MATCH_DSCP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_ECN
+	tristate '"ecn" match support'
+	depends on NETFILTER_ADVANCED
+	---help---
+	This option adds an "ECN" match, which allows you to match against
+	the IPv4 and TCP header ECN fields.
+
+	To compile it as a module, choose M here. If unsure, say N.
+
 config NETFILTER_XT_MATCH_ESP
 	tristate '"esp" match support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b2eee4d..40f4c3d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CPU) += xt_cpu.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DEVGROUP) += xt_devgroup.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_ECN) += xt_ecn.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/netfilter/xt_ecn.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_ecn.c
rename to net/netfilter/xt_ecn.c
index 2b57e52..2c198f5 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -21,6 +21,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag match for IPv4");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_ecn");
 
 static inline bool match_ip(const struct sk_buff *skb,
 			    const struct ipt_ecn_info *einfo)
-- 
1.7.3.4

