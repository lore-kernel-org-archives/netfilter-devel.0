From: Jan Engelhardt <jengelh@medozas.de>
Subject: [3/5] netfilter: xtables: case-sensitivity avoidance (3/5)
Date: Tue, 18 Jan 2011 16:39:58 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181639460.15657@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38343 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1ARPj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:39:59 -0500
In-Reply-To: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent b31552c3fd36bc862d8505f9f00f2ac7cc4dd8bf (v2.6.37-3810-gb31552c)
commit 497bdc4ad9f727d41df3e2e4868cb692b701116f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 18 08:45:11 2011 +0100

netfilter: xtables: case-sensitivity avoidance (3/5)

Process include/linux/netfilter_ipv[46]/ and use common header files
for targets with same name and lowercase.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/Kbuild                     |    7 ++
 .../ipt_CLUSTERIP.h => netfilter/xt_clusterip.h}   |    0
 .../ipt_ECN.h => netfilter/xt_ecn.h}               |   18 ++++
 include/linux/netfilter/xt_hl.h                    |   58 ++++++++++++
 include/linux/netfilter/xt_log.h                   |   34 +++++++
 include/linux/netfilter/xt_reject.h                |   34 +++++++
 .../ipt_SAME.h => netfilter/xt_same.h}             |    0
 .../ipt_ULOG.h => netfilter/xt_ulog.h}             |    0
 include/linux/netfilter_ipv4/Kbuild                |    9 --
 include/linux/netfilter_ipv4/ipt_LOG.h             |   19 ----
 include/linux/netfilter_ipv4/ipt_REJECT.h          |   20 ----
 include/linux/netfilter_ipv4/ipt_TTL.h             |   21 ----
 include/linux/netfilter_ipv4/ipt_ecn.h             |   33 -------
 include/linux/netfilter_ipv4/ipt_ttl.h             |   21 ----
 include/linux/netfilter_ipv6/Kbuild                |    4 -
 include/linux/netfilter_ipv6/ip6t_HL.h             |   22 -----
 include/linux/netfilter_ipv6/ip6t_LOG.h            |   19 ----
 include/linux/netfilter_ipv6/ip6t_REJECT.h         |   18 ----
 include/linux/netfilter_ipv6/ip6t_hl.h             |   22 -----
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    2 +-
 net/ipv4/netfilter/ipt_ECN.c                       |    2 +-
 net/ipv4/netfilter/ipt_LOG.c                       |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |    2 +-
 net/ipv4/netfilter/ipt_ecn.c                       |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/netfilter/xt_HL.c                              |    3 +-
 net/netfilter/xt_hl.c                              |    3 +-
 29 files changed, 161 insertions(+), 220 deletions(-)
 rename include/linux/{netfilter_ipv4/ipt_CLUSTERIP.h => netfilter/xt_clusterip.h} (100%)
 rename include/linux/{netfilter_ipv4/ipt_ECN.h => netfilter/xt_ecn.h} (74%)
 create mode 100644 include/linux/netfilter/xt_hl.h
 create mode 100644 include/linux/netfilter/xt_log.h
 create mode 100644 include/linux/netfilter/xt_reject.h
 rename include/linux/{netfilter_ipv4/ipt_SAME.h => netfilter/xt_same.h} (100%)
 rename include/linux/{netfilter_ipv4/ipt_ULOG.h => netfilter/xt_ulog.h} (100%)
 delete mode 100644 include/linux/netfilter_ipv4/ipt_LOG.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_REJECT.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_TTL.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_ecn.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_ttl.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_HL.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_LOG.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_REJECT.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_hl.h

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 4d96f22..05e9e5c 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -13,6 +13,7 @@ header-y += xt_audit.h
 header-y += xt_checksum.h
 header-y += xt_classify.h
 header-y += xt_cluster.h
+header-y += xt_clusterip.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
 header-y += xt_connlimit.h
@@ -23,15 +24,18 @@ header-y += xt_cpu.h
 header-y += xt_ct.h
 header-y += xt_dccp.h
 header-y += xt_dscp.h
+header-y += xt_ecn.h
 header-y += xt_esp.h
 header-y += xt_hashlimit.h
 header-y += xt_helper.h
+header-y += xt_hl.h
 header-y += xt_idletimer.h
 header-y += xt_iprange.h
 header-y += xt_ipvs.h
 header-y += xt_led.h
 header-y += xt_length.h
 header-y += xt_limit.h
+header-y += xt_log.h
 header-y += xt_mac.h
 header-y += xt_mark.h
 header-y += xt_multiport.h
@@ -46,6 +50,8 @@ header-y += xt_quota.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_recent.h
+header-y += xt_reject.h
+header-y += xt_same.h
 header-y += xt_sctp.h
 header-y += xt_secmark.h
 header-y += xt_socket.h
@@ -59,6 +65,7 @@ header-y += xt_tee.h
 header-y += xt_time.h
 header-y += xt_tproxy.h
 header-y += xt_u32.h
+header-y += xt_ulog.h
 # old files
 header-y += xt_AUDIT.h xt_CHECKSUM.h xt_CLASSIFY.h xt_CONNMARK.h
 header-y += xt_CONNSECMARK.h xt_CT.h xt_DSCP.h xt_IDLETIMER.h xt_LED.h
diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter/xt_clusterip.h
similarity index 100%
rename from include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
rename to include/linux/netfilter/xt_clusterip.h
diff --git a/include/linux/netfilter_ipv4/ipt_ECN.h b/include/linux/netfilter/xt_ecn.h
similarity index 74%
rename from include/linux/netfilter_ipv4/ipt_ECN.h
rename to include/linux/netfilter/xt_ecn.h
index b5c779d..b50a4a5 100644
--- a/include/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/linux/netfilter/xt_ecn.h
@@ -28,4 +28,22 @@ struct ipt_ECN_info {
 	} proto;
 };
 
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
 #endif /* _IPT_ECN_TARGET_H */
diff --git a/include/linux/netfilter/xt_hl.h b/include/linux/netfilter/xt_hl.h
new file mode 100644
index 0000000..66361ac
--- /dev/null
+++ b/include/linux/netfilter/xt_hl.h
@@ -0,0 +1,58 @@
+/* Hop Limit modification module for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ * Based on HW's TTL module */
+
+#ifndef _IP6T_HL_H
+#define _IP6T_HL_H
+
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
+
+enum {
+	IP6T_HL_EQ = 0,		/* equals */
+	IP6T_HL_NE,		/* not equals */
+	IP6T_HL_LT,		/* less than */
+	IP6T_HL_GT,		/* greater than */
+};
+
+struct ip6t_hl_info {
+	__u8	mode;
+	__u8	hop_limit;
+};
+
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
+
+enum {
+	IPT_TTL_EQ = 0,		/* equals */
+	IPT_TTL_NE,		/* not equals */
+	IPT_TTL_LT,		/* less than */
+	IPT_TTL_GT,		/* greater than */
+};
+
+struct ipt_ttl_info {
+	__u8	mode;
+	__u8	ttl;
+};
+
+#endif
diff --git a/include/linux/netfilter/xt_log.h b/include/linux/netfilter/xt_log.h
new file mode 100644
index 0000000..58a4683
--- /dev/null
+++ b/include/linux/netfilter/xt_log.h
@@ -0,0 +1,34 @@
+#ifndef _IP6T_LOG_H
+#define _IP6T_LOG_H
+
+/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+#define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
+#define IP6T_LOG_IPOPT		0x04	/* Log IP options */
+#define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
+#define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
+#define IP6T_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define IP6T_LOG_MASK		0x2f
+
+struct ip6t_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
+#define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
+#define IPT_LOG_IPOPT		0x04	/* Log IP options */
+#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
+#define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define IPT_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define IPT_LOG_MASK		0x2f
+
+struct ipt_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /*_IPT_LOG_H*/
diff --git a/include/linux/netfilter/xt_reject.h b/include/linux/netfilter/xt_reject.h
new file mode 100644
index 0000000..773915c
--- /dev/null
+++ b/include/linux/netfilter/xt_reject.h
@@ -0,0 +1,34 @@
+#ifndef _IP6T_REJECT_H
+#define _IP6T_REJECT_H
+
+enum ip6t_reject_with {
+	IP6T_ICMP6_NO_ROUTE,
+	IP6T_ICMP6_ADM_PROHIBITED,
+	IP6T_ICMP6_NOT_NEIGHBOUR,
+	IP6T_ICMP6_ADDR_UNREACH,
+	IP6T_ICMP6_PORT_UNREACH,
+	IP6T_ICMP6_ECHOREPLY,
+	IP6T_TCP_RESET
+};
+
+struct ip6t_reject_info {
+	__u32	with;	/* reject type */
+};
+
+enum ipt_reject_with {
+	IPT_ICMP_NET_UNREACHABLE,
+	IPT_ICMP_HOST_UNREACHABLE,
+	IPT_ICMP_PROT_UNREACHABLE,
+	IPT_ICMP_PORT_UNREACHABLE,
+	IPT_ICMP_ECHOREPLY,
+	IPT_ICMP_NET_PROHIBITED,
+	IPT_ICMP_HOST_PROHIBITED,
+	IPT_TCP_RESET,
+	IPT_ICMP_ADMIN_PROHIBITED
+};
+
+struct ipt_reject_info {
+	enum ipt_reject_with with;      /* reject type */
+};
+
+#endif /*_IP6T_REJECT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_SAME.h b/include/linux/netfilter/xt_same.h
similarity index 100%
rename from include/linux/netfilter_ipv4/ipt_SAME.h
rename to include/linux/netfilter/xt_same.h
diff --git a/include/linux/netfilter_ipv4/ipt_ULOG.h b/include/linux/netfilter/xt_ulog.h
similarity index 100%
rename from include/linux/netfilter_ipv4/ipt_ULOG.h
rename to include/linux/netfilter/xt_ulog.h
diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index f9930c8..e2c887e 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -1,14 +1,5 @@
 header-y += ip_queue.h
 header-y += ip_tables.h
-header-y += ipt_CLUSTERIP.h
-header-y += ipt_ECN.h
-header-y += ipt_LOG.h
-header-y += ipt_REJECT.h
-header-y += ipt_SAME.h
-header-y += ipt_TTL.h
-header-y += ipt_ULOG.h
 header-y += ipt_addrtype.h
 header-y += ipt_ah.h
-header-y += ipt_ecn.h
 header-y += ipt_realm.h
-header-y += ipt_ttl.h
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
deleted file mode 100644
index dcdbadf..0000000
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _IPT_LOG_H
-#define _IPT_LOG_H
-
-/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
-#define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
-#define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
-#define IPT_LOG_IPOPT		0x04	/* Log IP options */
-#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
-#define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
-#define IPT_LOG_MACDECODE	0x20	/* Decode MAC header */
-#define IPT_LOG_MASK		0x2f
-
-struct ipt_log_info {
-	unsigned char level;
-	unsigned char logflags;
-	char prefix[30];
-};
-
-#endif /*_IPT_LOG_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_REJECT.h b/include/linux/netfilter_ipv4/ipt_REJECT.h
deleted file mode 100644
index 4293a1a..0000000
--- a/include/linux/netfilter_ipv4/ipt_REJECT.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _IPT_REJECT_H
-#define _IPT_REJECT_H
-
-enum ipt_reject_with {
-	IPT_ICMP_NET_UNREACHABLE,
-	IPT_ICMP_HOST_UNREACHABLE,
-	IPT_ICMP_PROT_UNREACHABLE,
-	IPT_ICMP_PORT_UNREACHABLE,
-	IPT_ICMP_ECHOREPLY,
-	IPT_ICMP_NET_PROHIBITED,
-	IPT_ICMP_HOST_PROHIBITED,
-	IPT_TCP_RESET,
-	IPT_ICMP_ADMIN_PROHIBITED
-};
-
-struct ipt_reject_info {
-	enum ipt_reject_with with;      /* reject type */
-};
-
-#endif /*_IPT_REJECT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_TTL.h b/include/linux/netfilter_ipv4/ipt_TTL.h
deleted file mode 100644
index f6250e4..0000000
--- a/include/linux/netfilter_ipv4/ipt_TTL.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* TTL modification module for IP tables
- * (C) 2000 by Harald Welte <laforge@netfilter.org> */
-
-#ifndef _IPT_TTL_H
-#define _IPT_TTL_H
-
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
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
deleted file mode 100644
index 78b98aa..0000000
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/* iptables module for matching the ECN header in IPv4 and TCP header
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
-*/
-#ifndef _IPT_ECN_H
-#define _IPT_ECN_H
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
-
-#endif /* _IPT_ECN_H */
diff --git a/include/linux/netfilter_ipv4/ipt_ttl.h b/include/linux/netfilter_ipv4/ipt_ttl.h
deleted file mode 100644
index 93d9a06..0000000
--- a/include/linux/netfilter_ipv4/ipt_ttl.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* IP tables module for matching the value of the TTL
- * (C) 2000 by Harald Welte <laforge@gnumonks.org> */
-
-#ifndef _IPT_TTL_H
-#define _IPT_TTL_H
-
-enum {
-	IPT_TTL_EQ = 0,		/* equals */
-	IPT_TTL_NE,		/* not equals */
-	IPT_TTL_LT,		/* less than */
-	IPT_TTL_GT,		/* greater than */
-};
-
-
-struct ipt_ttl_info {
-	__u8	mode;
-	__u8	ttl;
-};
-
-
-#endif
diff --git a/include/linux/netfilter_ipv6/Kbuild b/include/linux/netfilter_ipv6/Kbuild
index bd095bc..38ba2f6 100644
--- a/include/linux/netfilter_ipv6/Kbuild
+++ b/include/linux/netfilter_ipv6/Kbuild
@@ -1,10 +1,6 @@
 header-y += ip6_tables.h
-header-y += ip6t_HL.h
-header-y += ip6t_LOG.h
-header-y += ip6t_REJECT.h
 header-y += ip6t_ah.h
 header-y += ip6t_frag.h
-header-y += ip6t_hl.h
 header-y += ip6t_ipv6header.h
 header-y += ip6t_mh.h
 header-y += ip6t_opts.h
diff --git a/include/linux/netfilter_ipv6/ip6t_HL.h b/include/linux/netfilter_ipv6/ip6t_HL.h
deleted file mode 100644
index 81cdaf0..0000000
--- a/include/linux/netfilter_ipv6/ip6t_HL.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* Hop Limit modification module for ip6tables
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's TTL module */
-
-#ifndef _IP6T_HL_H
-#define _IP6T_HL_H
-
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
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
deleted file mode 100644
index 9dd5579..0000000
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _IP6T_LOG_H
-#define _IP6T_LOG_H
-
-/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
-#define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
-#define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
-#define IP6T_LOG_IPOPT		0x04	/* Log IP options */
-#define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
-#define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
-#define IP6T_LOG_MACDECODE	0x20	/* Decode MAC header */
-#define IP6T_LOG_MASK		0x2f
-
-struct ip6t_log_info {
-	unsigned char level;
-	unsigned char logflags;
-	char prefix[30];
-};
-
-#endif /*_IPT_LOG_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_REJECT.h b/include/linux/netfilter_ipv6/ip6t_REJECT.h
deleted file mode 100644
index b999aa4..0000000
--- a/include/linux/netfilter_ipv6/ip6t_REJECT.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef _IP6T_REJECT_H
-#define _IP6T_REJECT_H
-
-enum ip6t_reject_with {
-	IP6T_ICMP6_NO_ROUTE,
-	IP6T_ICMP6_ADM_PROHIBITED,
-	IP6T_ICMP6_NOT_NEIGHBOUR,
-	IP6T_ICMP6_ADDR_UNREACH,
-	IP6T_ICMP6_PORT_UNREACH,
-	IP6T_ICMP6_ECHOREPLY,
-	IP6T_TCP_RESET
-};
-
-struct ip6t_reject_info {
-	__u32	with;	/* reject type */
-};
-
-#endif /*_IP6T_REJECT_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_hl.h b/include/linux/netfilter_ipv6/ip6t_hl.h
deleted file mode 100644
index c6fddcb..0000000
--- a/include/linux/netfilter_ipv6/ip6t_hl.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* ip6tables module for matching the Hop Limit value
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- * Based on HW's ttl module */
-
-#ifndef _IP6T_HL_H
-#define _IP6T_HL_H
-
-enum {
-	IP6T_HL_EQ = 0,		/* equals */
-	IP6T_HL_NE,		/* not equals */
-	IP6T_HL_LT,		/* less than */
-	IP6T_HL_GT,		/* greater than */
-};
-
-
-struct ip6t_hl_info {
-	__u8	mode;
-	__u8	hop_limit;
-};
-
-
-#endif
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1e26a48..ed812b1 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -25,7 +25,7 @@
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_CLUSTERIP.h>
+#include <linux/netfilter/xt_clusterip.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/net_namespace.h>
 #include <net/checksum.h>
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 4bf3dc4..a8ee93e 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -17,7 +17,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ECN.h>
+#include <linux/netfilter/xt_ecn.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index d76d6c9..710a08f 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -22,7 +22,7 @@
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_LOG.h>
+#include <linux/netfilter/xt_log.h>
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/xt_log.h>
 
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 1ff79e5..c7e4854 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -23,7 +23,7 @@
 #include <net/dst.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <linux/netfilter/xt_reject.h>
 #ifdef CONFIG_BRIDGE_NETFILTER
 #include <linux/netfilter_bridge.h>
 #endif
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 446e0f4..293dbe3 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -43,7 +43,7 @@
 #include <linux/moduleparam.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_ULOG.h>
+#include <linux/netfilter/xt_ulog.h>
 #include <net/netfilter/nf_log.h>
 #include <net/sock.h>
 #include <linux/bitops.h>
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index af6e9c7..58cbe94 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -16,7 +16,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_ecn.h>
+#include <linux/netfilter/xt_ecn.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag match for IPv4");
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 05027b7..a48698e 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -21,6 +21,7 @@
 #include <net/ipv6.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_log.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/xt_log.h>
@@ -31,7 +32,6 @@ MODULE_LICENSE("GPL");
 
 struct in_device;
 #include <net/route.h>
-#include <linux/netfilter_ipv6/ip6t_LOG.h>
 
 /* One level of recursion won't kill us */
 static void dump_packet(struct sbuff *m,
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index bf998fe..19b2052 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -30,7 +30,7 @@
 #include <net/flow.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_REJECT.h>
+#include <linux/netfilter/xt_reject.h>
 
 MODULE_AUTHOR("Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>");
 MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv6");
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 95b0848..ed63552 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -17,8 +17,7 @@
 #include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_TTL.h>
-#include <linux/netfilter_ipv6/ip6t_HL.h>
+#include <linux/netfilter/xt_hl.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index 7d12221..8375bb9 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -16,8 +16,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_ttl.h>
-#include <linux/netfilter_ipv6/ip6t_hl.h>
+#include <linux/netfilter/xt_hl.h>
 
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
 MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match");
-- 
# Created with git-export-patch
