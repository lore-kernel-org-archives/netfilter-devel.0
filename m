From: Jan Engelhardt <jengelh@medozas.de>
Subject: [1/5] netfilter: xtables: avoid case-sensitive filenames (1/5)
Date: Tue, 18 Jan 2011 16:39:35 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181639170.15657@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38334 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab1ARPjg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:39:36 -0500
In-Reply-To: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 0b8ad876275c74e4bfb6ec3150793f3c0ecfcee2 (v2.6.37-3808-g0b8ad87)
commit 10fc4644d17ccace699f2c62f9b15f8f024ddb4d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 18 07:46:55 2011 +0100

netfilter: xtables: avoid case-sensitive filenames (1/5)

This problem is well known, and though people have been told to get
real and use a case-sensitive filesystem, I think this move should be
done nevertheless. Since userspace has its own copies of header files,
this should work out in the general case.

Part 1: Process header files from include/linux/netfilter/, turning
their names into lowercase.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=694
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild                     |   30 +++++-------
 include/linux/netfilter/xt_DSCP.h                  |   26 ----------
 include/linux/netfilter/xt_RATEEST.h               |   15 ------
 include/linux/netfilter/xt_TCPMSS.h                |   12 -----
 include/linux/netfilter/{xt_AUDIT.h => xt_audit.h} |    0
 .../netfilter/{xt_CHECKSUM.h => xt_checksum.h}     |    0
 .../netfilter/{xt_CLASSIFY.h => xt_classify.h}     |    0
 .../{xt_CONNSECMARK.h => xt_connsecmark.h}         |    0
 include/linux/netfilter/{xt_CT.h => xt_ct.h}       |    0
 include/linux/netfilter/xt_dscp.h                  |   10 ++++
 .../netfilter/{xt_IDLETIMER.h => xt_idletimer.h}   |    0
 include/linux/netfilter/{xt_LED.h => xt_led.h}     |    0
 include/linux/netfilter/{xt_NFLOG.h => xt_nflog.h} |    0
 .../linux/netfilter/{xt_NFQUEUE.h => xt_nfqueue.h} |    0
 include/linux/netfilter/xt_rateest.h               |    9 ++++
 .../linux/netfilter/{xt_SECMARK.h => xt_secmark.h} |    0
 include/linux/netfilter/xt_tcpmss.h                |    6 ++
 .../{xt_TCPOPTSTRIP.h => xt_tcpoptstrip.h}         |    0
 include/linux/netfilter/{xt_TEE.h => xt_tee.h}     |    0
 .../linux/netfilter/{xt_TPROXY.h => xt_tproxy.h}   |    0
 include/linux/netfilter_ipv4/ipt_ECN.h             |    2 +-
 net/netfilter/xt_AUDIT.c                           |    2 +-
 net/netfilter/xt_CHECKSUM.c                        |    2 +-
 net/netfilter/xt_CLASSIFY.c                        |    2 +-
 net/netfilter/xt_CONNSECMARK.c                     |    2 +-
 net/netfilter/xt_CT.c                              |    2 +-
 net/netfilter/xt_DSCP.c                            |    2 +-
 net/netfilter/xt_IDLETIMER.c                       |    2 +-
 net/netfilter/xt_LED.c                             |    2 +-
 net/netfilter/xt_NFLOG.c                           |    2 +-
 net/netfilter/xt_NFQUEUE.c                         |    2 +-
 net/netfilter/xt_RATEEST.c                         |    2 +-
 net/netfilter/xt_SECMARK.c                         |    2 +-
 net/netfilter/xt_TCPMSS.c                          |    2 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |    2 +-
 net/netfilter/xt_TEE.c                             |    2 +-
 net/netfilter/xt_TPROXY.c                          |    2 +-
 37 files changed, 54 insertions(+), 88 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_DSCP.h
 delete mode 100644 include/linux/netfilter/xt_RATEEST.h
 delete mode 100644 include/linux/netfilter/xt_TCPMSS.h
 rename include/linux/netfilter/{xt_AUDIT.h => xt_audit.h} (100%)
 rename include/linux/netfilter/{xt_CHECKSUM.h => xt_checksum.h} (100%)
 rename include/linux/netfilter/{xt_CLASSIFY.h => xt_classify.h} (100%)
 rename include/linux/netfilter/{xt_CONNSECMARK.h => xt_connsecmark.h} (100%)
 rename include/linux/netfilter/{xt_CT.h => xt_ct.h} (100%)
 rename include/linux/netfilter/{xt_IDLETIMER.h => xt_idletimer.h} (100%)
 rename include/linux/netfilter/{xt_LED.h => xt_led.h} (100%)
 rename include/linux/netfilter/{xt_NFLOG.h => xt_nflog.h} (100%)
 rename include/linux/netfilter/{xt_NFQUEUE.h => xt_nfqueue.h} (100%)
 rename include/linux/netfilter/{xt_SECMARK.h => xt_secmark.h} (100%)
 rename include/linux/netfilter/{xt_TCPOPTSTRIP.h => xt_tcpoptstrip.h} (100%)
 rename include/linux/netfilter/{xt_TEE.h => xt_tee.h} (100%)
 rename include/linux/netfilter/{xt_TPROXY.h => xt_tproxy.h} (100%)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index fc4e0aa..b938380 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -9,43 +9,34 @@ header-y += nfnetlink_conntrack.h
 header-y += nfnetlink_log.h
 header-y += nfnetlink_queue.h
 header-y += x_tables.h
-header-y += xt_AUDIT.h
-header-y += xt_CHECKSUM.h
-header-y += xt_CLASSIFY.h
-header-y += xt_CONNMARK.h
-header-y += xt_CONNSECMARK.h
-header-y += xt_CT.h
-header-y += xt_DSCP.h
-header-y += xt_IDLETIMER.h
-header-y += xt_LED.h
-header-y += xt_MARK.h
-header-y += xt_NFLOG.h
-header-y += xt_NFQUEUE.h
-header-y += xt_RATEEST.h
-header-y += xt_SECMARK.h
-header-y += xt_TCPMSS.h
-header-y += xt_TCPOPTSTRIP.h
-header-y += xt_TEE.h
-header-y += xt_TPROXY.h
+header-y += xt_audit.h
+header-y += xt_checksum.h
+header-y += xt_classify.h
 header-y += xt_cluster.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
 header-y += xt_connlimit.h
 header-y += xt_connmark.h
+header-y += xt_connsecmark.h
 header-y += xt_conntrack.h
 header-y += xt_cpu.h
+header-y += xt_ct.h
 header-y += xt_dccp.h
 header-y += xt_dscp.h
 header-y += xt_esp.h
 header-y += xt_hashlimit.h
 header-y += xt_helper.h
+header-y += xt_idletimer.h
 header-y += xt_iprange.h
 header-y += xt_ipvs.h
+header-y += xt_led.h
 header-y += xt_length.h
 header-y += xt_limit.h
 header-y += xt_mac.h
 header-y += xt_mark.h
 header-y += xt_multiport.h
+header-y += xt_nflog.h
+header-y += xt_nfqueue.h
 header-y += xt_osf.h
 header-y += xt_owner.h
 header-y += xt_physdev.h
@@ -62,6 +53,9 @@ header-y += xt_state.h
 header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
+header-y += xt_tcpoptstrip.h
 header-y += xt_tcpudp.h
+header-y += xt_tee.h
 header-y += xt_time.h
+header-y += xt_tproxy.h
 header-y += xt_u32.h
diff --git a/include/linux/netfilter/xt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
deleted file mode 100644
index 648e0b3..0000000
--- a/include/linux/netfilter/xt_DSCP.h
+++ /dev/null
@@ -1,26 +0,0 @@
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
-#ifndef _XT_DSCP_TARGET_H
-#define _XT_DSCP_TARGET_H
-#include <linux/netfilter/xt_dscp.h>
-#include <linux/types.h>
-
-/* target info */
-struct xt_DSCP_info {
-	__u8 dscp;
-};
-
-struct xt_tos_target_info {
-	__u8 tos_value;
-	__u8 tos_mask;
-};
-
-#endif /* _XT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
deleted file mode 100644
index 6605e20..0000000
--- a/include/linux/netfilter/xt_RATEEST.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _XT_RATEEST_TARGET_H
-#define _XT_RATEEST_TARGET_H
-
-#include <linux/types.h>
-
-struct xt_rateest_target_info {
-	char			name[IFNAMSIZ];
-	__s8			interval;
-	__u8		ewma_log;
-
-	/* Used internally by the kernel */
-	struct xt_rateest	*est __attribute__((aligned(8)));
-};
-
-#endif /* _XT_RATEEST_TARGET_H */
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
deleted file mode 100644
index 9a6960a..0000000
--- a/include/linux/netfilter/xt_TCPMSS.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _XT_TCPMSS_H
-#define _XT_TCPMSS_H
-
-#include <linux/types.h>
-
-struct xt_tcpmss_info {
-	__u16 mss;
-};
-
-#define XT_TCPMSS_CLAMP_PMTU 0xffff
-
-#endif /* _XT_TCPMSS_H */
diff --git a/include/linux/netfilter/xt_AUDIT.h b/include/linux/netfilter/xt_audit.h
similarity index 100%
rename from include/linux/netfilter/xt_AUDIT.h
rename to include/linux/netfilter/xt_audit.h
diff --git a/include/linux/netfilter/xt_CHECKSUM.h b/include/linux/netfilter/xt_checksum.h
similarity index 100%
rename from include/linux/netfilter/xt_CHECKSUM.h
rename to include/linux/netfilter/xt_checksum.h
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_classify.h
similarity index 100%
rename from include/linux/netfilter/xt_CLASSIFY.h
rename to include/linux/netfilter/xt_classify.h
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_connsecmark.h
similarity index 100%
rename from include/linux/netfilter/xt_CONNSECMARK.h
rename to include/linux/netfilter/xt_connsecmark.h
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_ct.h
similarity index 100%
rename from include/linux/netfilter/xt_CT.h
rename to include/linux/netfilter/xt_ct.h
diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
index 15f8932..9611dac 100644
--- a/include/linux/netfilter/xt_dscp.h
+++ b/include/linux/netfilter/xt_dscp.h
@@ -28,4 +28,14 @@ struct xt_tos_match_info {
 	__u8 invert;
 };
 
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
 #endif /* _XT_DSCP_H */
diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_idletimer.h
similarity index 100%
rename from include/linux/netfilter/xt_IDLETIMER.h
rename to include/linux/netfilter/xt_idletimer.h
diff --git a/include/linux/netfilter/xt_LED.h b/include/linux/netfilter/xt_led.h
similarity index 100%
rename from include/linux/netfilter/xt_LED.h
rename to include/linux/netfilter/xt_led.h
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_nflog.h
similarity index 100%
rename from include/linux/netfilter/xt_NFLOG.h
rename to include/linux/netfilter/xt_nflog.h
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_nfqueue.h
similarity index 100%
rename from include/linux/netfilter/xt_NFQUEUE.h
rename to include/linux/netfilter/xt_nfqueue.h
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index d40a619..54f52c2 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -34,4 +34,13 @@ struct xt_rateest_match_info {
 	struct xt_rateest	*est2 __attribute__((aligned(8)));
 };
 
+struct xt_rateest_target_info {
+	char			name[IFNAMSIZ];
+	__s8			interval;
+	__u8		ewma_log;
+
+	/* Used internally by the kernel */
+	struct xt_rateest	*est __attribute__((aligned(8)));
+};
+
 #endif /* _XT_RATEEST_MATCH_H */
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_secmark.h
similarity index 100%
rename from include/linux/netfilter/xt_SECMARK.h
rename to include/linux/netfilter/xt_secmark.h
diff --git a/include/linux/netfilter/xt_tcpmss.h b/include/linux/netfilter/xt_tcpmss.h
index fbac56b..dabdaf8 100644
--- a/include/linux/netfilter/xt_tcpmss.h
+++ b/include/linux/netfilter/xt_tcpmss.h
@@ -8,4 +8,10 @@ struct xt_tcpmss_match_info {
     __u8 invert;
 };
 
+struct xt_tcpmss_info {
+	__u16 mss;
+};
+
+#define XT_TCPMSS_CLAMP_PMTU 0xffff
+
 #endif /*_XT_TCPMSS_MATCH_H*/
diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_tcpoptstrip.h
similarity index 100%
rename from include/linux/netfilter/xt_TCPOPTSTRIP.h
rename to include/linux/netfilter/xt_tcpoptstrip.h
diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_tee.h
similarity index 100%
rename from include/linux/netfilter/xt_TEE.h
rename to include/linux/netfilter/xt_tee.h
diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_tproxy.h
similarity index 100%
rename from include/linux/netfilter/xt_TPROXY.h
rename to include/linux/netfilter/xt_tproxy.h
diff --git a/include/linux/netfilter_ipv4/ipt_ECN.h b/include/linux/netfilter_ipv4/ipt_ECN.h
index c6e3e01..b5c779d 100644
--- a/include/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/linux/netfilter_ipv4/ipt_ECN.h
@@ -8,7 +8,7 @@
 */
 #ifndef _IPT_ECN_TARGET_H
 #define _IPT_ECN_TARGET_H
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter/xt_dscp.h>
 
 #define IPT_ECN_IP_MASK	(~XT_DSCP_MASK)
 
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 81802d2..b633033 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -18,7 +18,7 @@
 #include <linux/udp.h>
 #include <linux/if_arp.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_AUDIT.h>
+#include <linux/netfilter/xt_audit.h>
 #include <net/ipv6.h>
 #include <net/ip.h>
 
diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
index 0f642ef..c78c372 100644
--- a/net/netfilter/xt_CHECKSUM.c
+++ b/net/netfilter/xt_CHECKSUM.c
@@ -14,7 +14,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_CHECKSUM.h>
+#include <linux/netfilter/xt_checksum.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael S. Tsirkin <mst@redhat.com>");
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index af9c4da..351c2e8 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_CLASSIFY.h>
+#include <linux/netfilter/xt_classify.h>
 #include <linux/netfilter_arp.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index e04dc28..9a85162 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_CONNSECMARK.h>
+#include <linux/netfilter/xt_connsecmark.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 782e519..93903b9 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_CT.h>
+#include <linux/netfilter/xt_ct.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 0a22919..8de6017 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -17,7 +17,7 @@
 #include <net/dsfield.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_DSCP.h>
+#include <linux/netfilter/xt_dscp.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 3bdd443..2492d17 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -35,7 +35,7 @@
 #include <linux/mutex.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_IDLETIMER.h>
+#include <linux/netfilter/xt_idletimer.h>
 #include <linux/kdev_t.h>
 #include <linux/kobject.h>
 #include <linux/workqueue.h>
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 993de2b..5d82913 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -26,7 +26,7 @@
 #include <linux/leds.h>
 #include <linux/mutex.h>
 
-#include <linux/netfilter/xt_LED.h>
+#include <linux/netfilter/xt_led.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Adam Nielsen <a.nielsen@shikadi.net>");
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index a17dd0f..e145531 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -11,7 +11,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_NFLOG.h>
+#include <linux/netfilter/xt_nflog.h>
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nfnetlink_log.h>
 
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 3962770..62f8c5b 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_NFQUEUE.h>
+#include <linux/netfilter/xt_nfqueue.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: packet forwarding to netlink");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index de079ab..a14c8d9 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -16,7 +16,7 @@
 #include <net/netlink.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_RATEEST.h>
+#include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
 static DEFINE_MUTEX(xt_rateest_mutex);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 9faf5e0..ade0726 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -17,7 +17,7 @@
 #include <linux/security.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_SECMARK.h>
+#include <linux/netfilter/xt_secmark.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@redhat.com>");
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index eb81c38..a7a55ea 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -24,7 +24,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_TCPMSS.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 9dc9ecf..c977fce 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -17,7 +17,7 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+#include <linux/netfilter/xt_tcpoptstrip.h>
 
 static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
 {
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 5128a6c..1aa8bc9 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -23,7 +23,7 @@
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_TEE.h>
+#include <linux/netfilter/xt_tee.h>
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 #	define WITH_CONNTRACK 1
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 640678f..d8ef64d 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -31,7 +31,7 @@
 #endif
 
 #include <net/netfilter/nf_tproxy_core.h>
-#include <linux/netfilter/xt_TPROXY.h>
+#include <linux/netfilter/xt_tproxy.h>
 
 static inline __be32
 tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
-- 
# Created with git-export-patch
