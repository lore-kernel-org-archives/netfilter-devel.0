From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 6/6] IPv4/IPv6 specific extensions
Date: Sun, 21 Jun 2009 00:02:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210001410.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:35834 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbZFTWC4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:02:56 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 090551F4287
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:02:58 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h+bkTGfxRMEy for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:02:57 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id CAA6F1F424C
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:02:57 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The IPv4/IPv6 extensions with the new error reporting methods.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 include/linux/netfilter/xt_CLASSIFY.h    |    7 ++++
 include/linux/netfilter/xt_CONNMARK.h    |    8 ++++
 include/linux/netfilter/xt_CONNSECMARK.h |    8 ++++
 include/linux/netfilter/xt_LED.h         |    8 ++++
 include/linux/netfilter/xt_MARK.h        |    8 ++++
 include/linux/netfilter/xt_NFLOG.h       |    7 ++++
 include/linux/netfilter/xt_NFQUEUE.h     |    7 ++++
 include/linux/netfilter/xt_NOTRACK.h     |   10 +++++
 include/linux/netfilter/xt_RATEEST.h     |    8 ++++
 include/linux/netfilter/xt_SECMARK.h     |   11 ++++++
 include/linux/netfilter/xt_TCPMSS.h      |    8 ++++
 include/linux/netfilter/xt_TCPOPTSTRIP.h |    7 ++++
 include/linux/netfilter/xt_TPROXY.h      |    8 ++++
 include/linux/netfilter/xt_TRACE.h       |   10 +++++
 include/linux/netfilter/xt_cluster.h     |    7 ++++
 include/linux/netfilter/xt_connbytes.h   |    8 ++++
 include/linux/netfilter/xt_connlimit.h   |    7 ++++
 include/linux/netfilter/xt_connmark.h    |    7 ++++
 include/linux/netfilter/xt_conntrack.h   |    6 +++
 include/linux/netfilter/xt_dccp.h        |    8 ++++
 include/linux/netfilter/xt_dscp.h        |    8 ++++
 include/linux/netfilter/xt_esp.h         |    7 ++++
 include/linux/netfilter/xt_hashlimit.h   |   12 ++++++
 include/linux/netfilter/xt_helper.h      |    6 +++
 include/linux/netfilter/xt_limit.h       |    7 ++++
 include/linux/netfilter/xt_mac.h         |    6 +++
 include/linux/netfilter/xt_mark.h        |    6 +++
 include/linux/netfilter/xt_multiport.h   |    9 +++++
 include/linux/netfilter/xt_osf.h         |    7 ++++
 include/linux/netfilter/xt_owner.h       |    7 ++++
 include/linux/netfilter/xt_physdev.h     |    8 ++++
 include/linux/netfilter/xt_policy.h      |    9 +++++
 include/linux/netfilter/xt_quota.h       |    7 ++++
 include/linux/netfilter/xt_rateest.h     |   10 +++++
 include/linux/netfilter/xt_realm.h       |    6 +++
 include/linux/netfilter/xt_recent.h      |   12 ++++++
 include/linux/netfilter/xt_sctp.h        |    9 +++++
 include/linux/netfilter/xt_socket.h      |    6 +++
 include/linux/netfilter/xt_state.h       |    6 +++
 include/linux/netfilter/xt_statistic.h   |    8 ++++
 include/linux/netfilter/xt_string.h      |   10 +++++
 include/linux/netfilter/xt_tcpmss.h      |    6 +++
 include/linux/netfilter/xt_tcpudp.h      |    7 ++++
 include/linux/netfilter/xt_time.h        |    6 +++
 net/netfilter/xt_CLASSIFY.c              |   25 +++++++++++--
 net/netfilter/xt_CONNMARK.c              |   32 ++++++++--------
 net/netfilter/xt_CONNSECMARK.c           |   20 +++++-----
 net/netfilter/xt_DSCP.c                  |   44 ++++++++++++++++------
 net/netfilter/xt_HL.c                    |   36 +++++++++++-------
 net/netfilter/xt_LED.c                   |   22 ++++++-----
 net/netfilter/xt_MARK.c                  |   45 ++++++++++++++---------
 net/netfilter/xt_NFLOG.c                 |   14 ++++---
 net/netfilter/xt_NFQUEUE.c               |    8 ++--
 net/netfilter/xt_NOTRACK.c               |   14 +++++++
 net/netfilter/xt_RATEEST.c               |   19 ++++++----
 net/netfilter/xt_SECMARK.c               |   49 +++++++++++++------------
 net/netfilter/xt_TCPMSS.c                |   38 +++++++++++--------
 net/netfilter/xt_TCPOPTSTRIP.c           |   21 +++++++++--
 net/netfilter/xt_TPROXY.c                |   29 +++++++++------
 net/netfilter/xt_TRACE.c                 |   14 +++++++
 net/netfilter/xt_cluster.c               |   19 +++++-----
 net/netfilter/xt_connbytes.c             |   14 ++++---
 net/netfilter/xt_connlimit.c             |   12 +++---
 net/netfilter/xt_connmark.c              |   24 ++++++------
 net/netfilter/xt_conntrack.c             |   10 +++--
 net/netfilter/xt_dccp.c                  |   21 +++++++----
 net/netfilter/xt_dscp.c                  |    8 ++--
 net/netfilter/xt_esp.c                   |   17 +++++----
 net/netfilter/xt_hashlimit.c             |   40 +++++++++++---------
 net/netfilter/xt_helper.c                |   10 +++--
 net/netfilter/xt_limit.c                 |   10 +++--
 net/netfilter/xt_mac.c                   |   19 +++++++++-
 net/netfilter/xt_mark.c                  |    8 ++--
 net/netfilter/xt_multiport.c             |   59 ++++++++++++------------------
 net/netfilter/xt_osf.c                   |   23 ++++++++++--
 net/netfilter/xt_owner.c                 |   42 +++++++++++++--------
 net/netfilter/xt_physdev.c               |   19 ++++++----
 net/netfilter/xt_policy.c                |   26 +++++++------
 net/netfilter/xt_quota.c                 |   12 ++++--
 net/netfilter/xt_rateest.c               |   24 +++++++++---
 net/netfilter/xt_realm.c                 |   18 ++++++++-
 net/netfilter/xt_recent.c                |   28 +++++++++-----
 net/netfilter/xt_sctp.c                  |   32 ++++++++++------
 net/netfilter/xt_socket.c                |   16 +++++++-
 net/netfilter/xt_state.c                 |   10 +++--
 net/netfilter/xt_statistic.c             |   17 +++++----
 net/netfilter/xt_string.c                |   22 +++++++----
 net/netfilter/xt_tcpmss.c                |   13 ++++++-
 net/netfilter/xt_tcpudp.c                |   54 ++++++++++++++++++++-------
 net/netfilter/xt_time.c                  |   10 +++--
 90 files changed, 1002 insertions(+), 408 deletions(-)

diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_CLASSIFY.h
index a813bf1..350e5d8 100644
--- a/include/linux/netfilter/xt_CLASSIFY.h
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -3,6 +3,13 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_CLASSIFY_ERR_NONE,
+	XT_CLASSIFY_ERR_MANGLE_TABLE,
+	XT_CLASSIFY_ERR_HOOKS_234,
+	XT_CLASSIFY_ERR_MAX,
+};
+
 struct xt_classify_target_info {
 	__u32 priority;
 };
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 7635c8f..9410032 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -13,6 +13,14 @@
  */
 
 enum {
+	XT_CONNMARK_ERR_NONE,
+	XT_CONNMARK_ERR_MANGLE_TABLE,
+	XT_CONNMARK_ERR_32BIT_MARK,
+	XT_CONNMARK_ERR_CONNTRACK,
+	XT_CONNMARK_ERR_MAX,
+};	
+
+enum {
 	XT_CONNMARK_SET = 0,
 	XT_CONNMARK_SAVE,
 	XT_CONNMARK_RESTORE
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_CONNSECMARK.h
index b973ff8..756cc91 100644
--- a/include/linux/netfilter/xt_CONNSECMARK.h
+++ b/include/linux/netfilter/xt_CONNSECMARK.h
@@ -4,6 +4,14 @@
 #include <linux/types.h>
 
 enum {
+	XT_CONNSECMARK_ERR_NONE,
+	XT_CONNSECMARK_ERR_MANGLE_SECURITY_TABLES,
+	XT_CONNSECMARK_ERR_MODE,
+	XT_CONNSECMARK_ERR_CONNTRACK,
+	XT_CONNSECMARK_ERR_MAX,
+};
+
+enum {
 	CONNSECMARK_SAVE = 1,
 	CONNSECMARK_RESTORE,
 };
diff --git a/include/linux/netfilter/xt_LED.h b/include/linux/netfilter/xt_LED.h
index f5509e7..1a8ed12 100644
--- a/include/linux/netfilter/xt_LED.h
+++ b/include/linux/netfilter/xt_LED.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_LED_ERR_NONE,
+	XT_LED_ERR_ID,
+	XT_LED_ERR_ALLOC,
+	XT_LED_ERR_REGISTER,
+	XT_LED_ERR_MAX,
+};
+
 struct xt_led_info {
 	char id[27];        /* Unique ID for this trigger in the LED class */
 	__u8 always_blink;  /* Blink even if the LED is already on */
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt_MARK.h
index 028304b..59f404d 100644
--- a/include/linux/netfilter/xt_MARK.h
+++ b/include/linux/netfilter/xt_MARK.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_MARK_ERR_NONE,
+	XT_MARK_ERR_MANGLE_TABLE,
+	XT_MARK_ERR_32BIT_MARK,
+	XT_MARK_ERR_MODE,
+	XT_MARK_ERR_MAX,
+};
+
 /* Version 0 */
 struct xt_mark_target_info {
 	unsigned long mark;
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index 87b5831..5ba31a5 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -8,6 +8,13 @@
 
 #define XT_NFLOG_MASK			0x0
 
+enum {
+	XT_NFLOG_ERR_NONE,
+	XT_NFLOG_ERR_FLAGS,
+	XT_NFLOG_ERR_PREFIXLEN,
+	XT_NFLOG_ERR_MAX,
+};
+
 struct xt_nflog_info {
 	__u32	len;
 	__u16	group;
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
index 2584f4a..f74d5a7 100644
--- a/include/linux/netfilter/xt_NFQUEUE.h
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -10,6 +10,13 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_NFQUEUE_ERR_NONE,
+	XT_NFQUEUE_ERR_TOTAL_QUEUES,
+	XT_NFQUEUE_ERR_RANGE,
+	XT_NFQUEUE_ERR_MAX,
+};
+
 /* target info */
 struct xt_NFQ_info {
 	__u16 queuenum;
diff --git a/include/linux/netfilter/xt_NOTRACK.h b/include/linux/netfilter/xt_NOTRACK.h
new file mode 100644
index 0000000..a095f97
--- /dev/null
+++ b/include/linux/netfilter/xt_NOTRACK.h
@@ -0,0 +1,10 @@
+#ifndef _X_NOTRACK_H
+#define _X_NOTRACK_H
+
+enum {
+	XT_NOTRACK_ERR_NONE,
+	XT_NOTRACK_ERR_RAW_TABLE,
+	XT_NOTRACK_ERR_MAX,
+};
+
+#endif /*_X_NOTRACK_H */
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index 6605e20..7dcd191 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_RATEEST_ERR_NONE,
+	XT_RATEEST_ERR_NAME,
+	XT_RATEEST_ERR_ALLOC,
+	XT_RATEEST_ERR_GEN_NEW,
+	XT_RATEEST_ERR_MAX,
+};
+
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
 	__s8			interval;
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index 6fcd344..44ed105 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -13,6 +13,17 @@
 #define SECMARK_MODE_SEL	0x01		/* SELinux */
 #define SECMARK_SELCTX_MAX	256
 
+enum {
+	XT_SECMARK_ERR_NONE,
+	XT_SECMARK_ERR_MANGLE_SECURITY_TABLE,
+	XT_SECMARK_ERR_MIXED_MODE,
+	XT_SECMARK_ERR_INVALID_MODE,
+	XT_SECMARK_ERR_CONTEXT,
+	XT_SECMARK_ERR_MAP_CONTEXT,
+	XT_SECMARK_ERR_PERM,
+	XT_SECMARK_ERR_MAX,
+};
+
 struct xt_secmark_target_selinux_info {
 	__u32 selsid;
 	char selctx[SECMARK_SELCTX_MAX];
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
index 9a6960a..a623da6 100644
--- a/include/linux/netfilter/xt_TCPMSS.h
+++ b/include/linux/netfilter/xt_TCPMSS.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_TCPMSS_ERR_NONE,
+	XT_TCPMSS_ERR_PROTO,
+	XT_TCPMSS_ERR_HOOKS_234,
+	XT_TCPMSS_ERR_SYN,
+	XT_TCPMSS_ERR_MAX,
+};
+
 struct xt_tcpmss_info {
 	__u16 mss;
 };
diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
index 2db5432..0cec1e1 100644
--- a/include/linux/netfilter/xt_TCPOPTSTRIP.h
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -6,6 +6,13 @@
 #define tcpoptstrip_test_bit(bmap, idx) \
 	(((1U << (idx & 31)) & bmap[(idx) >> 5]) != 0)
 
+enum {
+	XT_TCPOPTSTRIP_ERR_NONE,
+	XT_TCPOPTSTRIP_ERR_MANGLE_TABLE,
+	XT_TCPOPTSTRIP_ERR_PROTO,
+	XT_TCPOPTSTRIP_ERR_MAX,
+};
+
 struct xt_tcpoptstrip_target_info {
 	u_int32_t strip_bmap[8];
 };
diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_TPROXY.h
index 152e8f9..068a385 100644
--- a/include/linux/netfilter/xt_TPROXY.h
+++ b/include/linux/netfilter/xt_TPROXY.h
@@ -1,6 +1,14 @@
 #ifndef _XT_TPROXY_H_target
 #define _XT_TPROXY_H_target
 
+enum {
+	XT_TPROXY_ERR_NONE,
+	XT_TPROXY_ERR_MANGLE_TABLE,
+	XT_TPROXY_ERR_HOOKS_0,
+	XT_TPROXY_ERR_PROTO,
+	XT_TPROXY_ERR_MAX,
+};
+
 /* TPROXY target is capable of marking the packet to perform
  * redirection. We can get rid of that whenever we get support for
  * mutliple targets in the same rule. */
diff --git a/include/linux/netfilter/xt_TRACE.h b/include/linux/netfilter/xt_TRACE.h
new file mode 100644
index 0000000..1440c1a
--- /dev/null
+++ b/include/linux/netfilter/xt_TRACE.h
@@ -0,0 +1,10 @@
+#ifndef _X_TRACE_H
+#define _X_TRACE_H
+
+enum {
+	XT_TRACE_ERR_NONE,
+	XT_TRACE_ERR_RAW_TABLE,
+	XT_TRACE_ERR_MAX,
+};
+
+#endif /*_X_TRACE_H */
diff --git a/include/linux/netfilter/xt_cluster.h b/include/linux/netfilter/xt_cluster.h
index 8866826..978b688 100644
--- a/include/linux/netfilter/xt_cluster.h
+++ b/include/linux/netfilter/xt_cluster.h
@@ -1,6 +1,13 @@
 #ifndef _XT_CLUSTER_MATCH_H
 #define _XT_CLUSTER_MATCH_H
 
+enum {
+	XT_CLUSTER_ERR_NONE,
+	XT_CLUSTER_ERR_TOTAL_NODES,
+	XT_CLUSTER_ERR_NODE_MASK,
+	XT_CLUSTER_ERR_MAX,
+};
+
 enum xt_cluster_flags {
 	XT_CLUSTER_F_INV	= (1 << 0)
 };
diff --git a/include/linux/netfilter/xt_connbytes.h b/include/linux/netfilter/xt_connbytes.h
index 52bd615..9799627 100644
--- a/include/linux/netfilter/xt_connbytes.h
+++ b/include/linux/netfilter/xt_connbytes.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_CONNBYTES_ERR_NONE,
+	XT_CONNBYTES_ERR_WHAT,
+	XT_CONNBYTES_ERR_DIR,
+	XT_CONNBYTES_ERR_CONNTRACK,
+	XT_CONNBYTES_ERR_MAX,
+};
+
 enum xt_connbytes_what {
 	XT_CONNBYTES_PKTS,
 	XT_CONNBYTES_BYTES,
diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 7e3284b..fe04450 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -1,6 +1,13 @@
 #ifndef _XT_CONNLIMIT_H
 #define _XT_CONNLIMIT_H
 
+enum {
+	XT_CONNLIMIT_ERR_NONE,
+	XT_CONNLIMIT_ERR_CONNTRACK,
+	XT_CONNLIMIT_ERR_INIT,
+	XT_CONNLIMIT_ERR_MAX,
+};
+
 struct xt_connlimit_data;
 
 struct xt_connlimit_info {
diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netfilter/xt_connmark.h
index 571e266..8efc278 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -12,6 +12,13 @@
  * (at your option) any later version.
  */
 
+enum {
+	XT_CONNMARK_ERR_NONE,
+	XT_CONNMARK_ERR_32BIT_MARK,
+	XT_CONNMARK_ERR_CONNTRACK,
+	XT_CONNMARK_ERR_MAX,
+};
+
 struct xt_connmark_info {
 	unsigned long mark, mask;
 	__u8 invert;
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 3430c77..aa27123 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -15,6 +15,12 @@
 #define XT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
 #define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
 
+enum {
+	XT_CONNTRACK_ERR_NONE,
+	XT_CONNTRACK_ERR_CONNTRACK,
+	XT_CONNTRACK_ERR_MAX,
+};
+
 /* flags, invflags: */
 enum {
 	XT_CONNTRACK_STATE        = 1 << 0,
diff --git a/include/linux/netfilter/xt_dccp.h b/include/linux/netfilter/xt_dccp.h
index a579e1b..f5f0c81 100644
--- a/include/linux/netfilter/xt_dccp.h
+++ b/include/linux/netfilter/xt_dccp.h
@@ -10,6 +10,14 @@
 
 #define XT_DCCP_VALID_FLAGS		0x0f
 
+enum {
+	XT_DCCP_ERR_NONE,
+	XT_DCCP_ERR_PROTO,
+	XT_DCCP_ERR_INVALID_FLAGS,
+	XT_DCCP_ERR_FLAG_INVFLAG,
+	XT_DCCP_ERR_MAX,
+};
+
 struct xt_dccp_info {
 	__u16 dpts[2];  /* Min, Max */
 	__u16 spts[2];  /* Min, Max */
diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
index 15f8932..876a2a2 100644
--- a/include/linux/netfilter/xt_dscp.h
+++ b/include/linux/netfilter/xt_dscp.h
@@ -16,6 +16,14 @@
 #define XT_DSCP_SHIFT	2
 #define XT_DSCP_MAX	0x3f	/* 00111111 */
 
+enum {
+	XT_DSCP_ERR_NONE,
+	XT_DSCP_ERR_MANGLE_TABLE,
+	XT_DSCP_ERR_RANGE,
+	XT_DSCP_ERR_VALUE,
+	XT_DSCP_ERR_MAX,
+};
+
 /* match info */
 struct xt_dscp_info {
 	__u8 dscp;
diff --git a/include/linux/netfilter/xt_esp.h b/include/linux/netfilter/xt_esp.h
index ef6fa47..7c77f0a 100644
--- a/include/linux/netfilter/xt_esp.h
+++ b/include/linux/netfilter/xt_esp.h
@@ -3,6 +3,13 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_ESP_ERR_NONE,
+	XT_ESP_ERR_PROTO,
+	XT_ESP_ERR_FLAGS,
+	XT_ESP_ERR_MAX,
+};
+
 struct xt_esp
 {
 	__u32 spis[2];	/* Security Parameter Index */
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index b1925b5..3c299b9 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -8,6 +8,18 @@
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 
+enum {
+	XT_HASHLIMIT_ERR_NONE,
+	XT_HASHLIMIT_ERR_OVERFLOW,
+	XT_HASHLIMIT_ERR_MODE,
+	XT_HASHLIMIT_ERR_INTERVAL,
+	XT_HASHLIMIT_ERR_EXPIRE,
+	XT_HASHLIMIT_ERR_NAMELEN,
+	XT_HASHLIMIT_ERR_INIT,
+	XT_HASHLIMIT_ERR_NETMASK,
+	XT_HASHLIMIT_ERR_MAX,
+};
+
 /* details of this structure hidden by the implementation */
 struct xt_hashlimit_htable;
 
diff --git a/include/linux/netfilter/xt_helper.h b/include/linux/netfilter/xt_helper.h
index 6b42763..1b43471 100644
--- a/include/linux/netfilter/xt_helper.h
+++ b/include/linux/netfilter/xt_helper.h
@@ -1,6 +1,12 @@
 #ifndef _XT_HELPER_H
 #define _XT_HELPER_H
 
+enum {
+	XT_HELPER_ERR_NONE,
+	XT_HELPER_ERR_CONNTRACK,
+	XT_HELPER_ERR_MAX,
+};
+
 struct xt_helper_info {
 	int invert;
 	char name[30];
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/xt_limit.h
index bb47fc4..dfb666a 100644
--- a/include/linux/netfilter/xt_limit.h
+++ b/include/linux/netfilter/xt_limit.h
@@ -6,6 +6,13 @@
 /* timings are in milliseconds. */
 #define XT_LIMIT_SCALE 10000
 
+enum {
+	XT_LIMIT_ERR_NONE,
+	XT_LIMIT_ERR_OVERFLOW,
+	XT_LIMIT_ERR_ALLOC,
+	XT_LIMIT_ERR_MAX,
+};
+
 struct xt_limit_priv;
 
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
diff --git a/include/linux/netfilter/xt_mac.h b/include/linux/netfilter/xt_mac.h
index b892cdc..c91695c 100644
--- a/include/linux/netfilter/xt_mac.h
+++ b/include/linux/netfilter/xt_mac.h
@@ -1,6 +1,12 @@
 #ifndef _XT_MAC_H
 #define _XT_MAC_H
 
+enum {
+	XT_MAC_ERR_NONE,
+	XT_MAC_ERR_HOOKS_012,
+	XT_MAC_ERR_MAX,
+};
+
 struct xt_mac_info {
     unsigned char srcaddr[ETH_ALEN];
     int invert;
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt_mark.h
index 6fa460a..93d8ba0 100644
--- a/include/linux/netfilter/xt_mark.h
+++ b/include/linux/netfilter/xt_mark.h
@@ -3,6 +3,12 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_MARK_ERR_NONE,
+	XT_MARK_ERR_32BIT_MARK,
+	XT_MARK_ERR_MAX,
+};
+
 struct xt_mark_info {
     unsigned long mark, mask;
     __u8 invert;
diff --git a/include/linux/netfilter/xt_multiport.h b/include/linux/netfilter/xt_multiport.h
index 185db49..6a75eb0 100644
--- a/include/linux/netfilter/xt_multiport.h
+++ b/include/linux/netfilter/xt_multiport.h
@@ -3,6 +3,15 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_MULTIPORT_ERR_NONE,
+	XT_MULTIPORT_ERR_PROTO,
+	XT_MULTIPORT_ERR_INV_PROTO,
+	XT_MULTIPORT_ERR_FLAGS,
+	XT_MULTIPORT_ERR_COUNT,
+	XT_MULTIPORT_ERR_MAX,
+};
+
 enum xt_multiport_flags
 {
 	XT_MULTIPORT_SOURCE,
diff --git a/include/linux/netfilter/xt_osf.h b/include/linux/netfilter/xt_osf.h
index fd2272e..a9ccb76 100644
--- a/include/linux/netfilter/xt_osf.h
+++ b/include/linux/netfilter/xt_osf.h
@@ -35,6 +35,13 @@
 #define XT_OSF_TTL_LESS		1	/* Check if ip TTL is less than fingerprint one */
 #define XT_OSF_TTL_NOCHECK	2	/* Do not compare ip and fingerprint TTL at all */
 
+enum {
+	XT_OSF_ERR_NONE,
+	XT_OSF_ERR_HOOKS_012,
+	XT_OSF_ERR_NOT_TCP,
+	XT_OSF_ERR_MAX,
+};
+
 struct xt_osf_info {
 	char			genre[MAXGENRELEN];
 	__u32			len;
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index 2081761..5e2eaa5 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -4,6 +4,13 @@
 #include <linux/types.h>
 
 enum {
+	XT_OWNER_ERR_NONE,
+	XT_OWNER_ERR_HOOKS_34,
+	XT_OWNER_ERR_UNSUPPORTED,
+	XT_OWNER_ERR_MAX,
+};
+
+enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
 	XT_OWNER_SOCKET = 1 << 2,
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 8555e39..04b0b74 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -14,6 +14,14 @@
 #define XT_PHYSDEV_OP_ISOUT		0x10
 #define XT_PHYSDEV_OP_MASK		(0x20 - 1)
 
+enum {
+	XT_PHYSDEV_ERR_NONE,
+	XT_PHYSDEV_ERR_MASK,
+	XT_PHYSDEV_ERR_UNKNOWN,
+	XT_PHYSDEV_ERR_UNSUPPORTED_HOOKS_234,
+	XT_PHYSDEV_ERR_MAX,
+};
+
 struct xt_physdev_info {
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index 7bb64e7..ffc0201 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -5,6 +5,15 @@
 
 #define XT_POLICY_MAX_ELEM	4
 
+enum {
+	XT_POLICY_ERR_NONE,
+	XT_POLICY_ERR_FLAGS,
+	XT_POLICY_ERR_INVALID_OUTPUT_HOOKS_01,
+	XT_POLICY_ERR_INVALID_INPUT_HOOKS_34,
+	XT_POLICY_ERR_MAX_ELEM,
+	XT_POLICY_ERR_MAX,
+};
+
 enum xt_policy_flags
 {
 	XT_POLICY_MATCH_IN	= 0x1,
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index 8dc89df..a09db05 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -1,6 +1,13 @@
 #ifndef _XT_QUOTA_H
 #define _XT_QUOTA_H
 
+enum {
+	XT_QUOTA_ERR_NONE,
+	XT_QUOTA_ERR_FLAGS,
+	XT_QUOTA_ERR_ALLOC,
+	XT_QUOTA_ERR_MAX,
+};
+
 enum xt_quota_flags {
 	XT_QUOTA_INVERT		= 0x1,
 };
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index d40a619..4a10786 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -3,6 +3,16 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_RATEEST_ERR_NONE,
+	XT_RATEEST_ERR_ABS,
+	XT_RATEEST_ERR_BPS,
+	XT_RATEEST_ERR_MODE,
+	XT_RATEEST_ERR_NAME1,
+	XT_RATEEST_ERR_NAME2,
+	XT_RATEEST_ERR_MAX,
+};
+
 enum xt_rateest_match_flags {
 	XT_RATEEST_MATCH_INVERT	= 1<<0,
 	XT_RATEEST_MATCH_ABS	= 1<<1,
diff --git a/include/linux/netfilter/xt_realm.h b/include/linux/netfilter/xt_realm.h
index d4a82ee..3a93459 100644
--- a/include/linux/netfilter/xt_realm.h
+++ b/include/linux/netfilter/xt_realm.h
@@ -3,6 +3,12 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_REALM_ERR_NONE,
+	XT_REALM_ERR_HOOKS_1234,
+	XT_REALM_ERR_MAX,
+};
+
 struct xt_realm_info {
 	__u32 id;
 	__u32 mask;
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index d2c2766..b516d2f 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -4,6 +4,18 @@
 #include <linux/types.h>
 
 enum {
+	XT_RECENT_ERR_NONE,
+	XT_RECENT_ERR_CHECK_SET,
+	XT_RECENT_ERR_SET,
+	XT_RECENT_ERR_HIT_COUNT,
+	XT_RECENT_ERR_NAME,
+	XT_RECENT_ERR_ALLOC,
+	XT_RECENT_ERR_PROC,
+	XT_RECENT_ERR_PROC_ENTRY,
+	XT_RECENT_ERR_MAX,
+};
+
+enum {
 	XT_RECENT_CHECK    = 1 << 0,
 	XT_RECENT_SET      = 1 << 1,
 	XT_RECENT_UPDATE   = 1 << 2,
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index 29287be..c3f18b0 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -9,6 +9,15 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
+enum {
+	XT_SCTP_ERR_NONE,
+	XT_SCTP_ERR_PROTO,
+	XT_SCTP_ERR_INVALID_FLAGS,
+	XT_SCTP_ERR_FLAG_INVFLAG,
+	XT_SCTP_ERR_CHUNK,
+	XT_SCTP_ERR_MAX,
+};
+
 struct xt_sctp_flag_info {
 	__u8 chunktype;
 	__u8 flag;
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
index 6f475b8..3b80991 100644
--- a/include/linux/netfilter/xt_socket.h
+++ b/include/linux/netfilter/xt_socket.h
@@ -2,6 +2,12 @@
 #define _XT_SOCKET_H
 
 enum {
+	XT_SOCKET_ERR_NONE,
+	XT_SOCKET_ERR_HOOKS_0,
+	XT_SOCKET_ERR_MAX,
+};
+
+enum {
 	XT_SOCKET_TRANSPARENT = 1 << 0,
 };
 
diff --git a/include/linux/netfilter/xt_state.h b/include/linux/netfilter/xt_state.h
index c06f32e..14c9ea1 100644
--- a/include/linux/netfilter/xt_state.h
+++ b/include/linux/netfilter/xt_state.h
@@ -6,6 +6,12 @@
 
 #define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
 
+enum {
+	XT_STATE_ERR_NONE,
+	XT_STATE_ERR_CONNTRACK,
+	XT_STATE_ERR_MAX,
+};
+
 struct xt_state_info
 {
 	unsigned int statemask;
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index 4e983ef..6974972 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_STATISTIC_ERR_NONE,
+	XT_STATISTIC_ERR_MODE,
+	XT_STATISTIC_ERR_FLAGS,
+	XT_STATISTIC_ERR_ALLOC,
+	XT_STATISTIC_ERR_MAX,
+};
+
 enum xt_statistic_mode {
 	XT_STATISTIC_MODE_RANDOM,
 	XT_STATISTIC_MODE_NTH,
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index ecbb95f..7a98cb9 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -7,6 +7,16 @@
 #define XT_STRING_MAX_ALGO_NAME_SIZE 16
 
 enum {
+	XT_STRING_ERR_NONE,
+	XT_STRING_ERR_OFFSET,
+	XT_STRING_ERR_ALGO_NAME,
+	XT_STRING_ERR_PATLEN,
+	XT_STRING_ERR_IGNORECASE,
+	XT_STRING_ERR_PREPARE,
+	XT_STRING_ERR_MAX,
+};
+
+enum {
 	XT_STRING_FLAG_INVERT		= 0x01,
 	XT_STRING_FLAG_IGNORECASE	= 0x02
 };
diff --git a/include/linux/netfilter/xt_tcpmss.h b/include/linux/netfilter/xt_tcpmss.h
index fbac56b..9d5ba56 100644
--- a/include/linux/netfilter/xt_tcpmss.h
+++ b/include/linux/netfilter/xt_tcpmss.h
@@ -3,6 +3,12 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_TCPMSS_ERR_NONE,
+	XT_TCPMSS_ERR_PROTO,
+	XT_TCPMSS_ERR_MAX,
+};
+
 struct xt_tcpmss_match_info {
     __u16 mss_min, mss_max;
     __u8 invert;
diff --git a/include/linux/netfilter/xt_tcpudp.h b/include/linux/netfilter/xt_tcpudp.h
index a490a0b..bbf4d65 100644
--- a/include/linux/netfilter/xt_tcpudp.h
+++ b/include/linux/netfilter/xt_tcpudp.h
@@ -3,6 +3,13 @@
 
 #include <linux/types.h>
 
+enum {
+	XT_TCPUDP_ERR_NONE,
+	XT_TCPUDP_ERR_PROTO,
+	XT_TCPUDP_ERR_FLAGS,
+	XT_TCPUDP_ERR_MAX,
+};
+
 /* TCP matching stuff */
 struct xt_tcp
 {
diff --git a/include/linux/netfilter/xt_time.h b/include/linux/netfilter/xt_time.h
index 14b6df4..dae46c2 100644
--- a/include/linux/netfilter/xt_time.h
+++ b/include/linux/netfilter/xt_time.h
@@ -1,6 +1,12 @@
 #ifndef _XT_TIME_H
 #define _XT_TIME_H 1
 
+enum {
+	XT_TIME_ERR_NONE,
+	XT_TIME_ERR_INVALID,
+	XT_TIME_ERR_MAX,
+};
+
 struct xt_time_info {
 	u_int32_t date_start;
 	u_int32_t date_stop;
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 011bc80..ad183ef 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -35,13 +35,32 @@ classify_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+static unsigned int
+classify_tg_check(const struct xt_tgchk_param *par)
+{
+	unsigned int valid_hooks =
+		(1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
+		(1 << NF_INET_POST_ROUTING);
+
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "CLASSIFY target can only be used in the "
+			      "\"mangle\" table.");
+	    	return XT_CLASSIFY_ERR_MANGLE_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "CLASSIFY target can only be used in the "
+			      "FORWARD, OUTPUT and POSTROUTING chains.");
+		return XT_CLASSIFY_ERR_HOOKS_234;
+	}
+
+	return XT_CLASSIFY_ERR_NONE;
+}
+
 static struct xt_target classify_tg_reg __read_mostly = {
 	.name       = "CLASSIFY",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
-	.table      = "mangle",
-	.hooks      = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
-		      (1 << NF_INET_POST_ROUTING),
+	.checkentry = classify_tg_check,
 	.target     = classify_tg,
 	.targetsize = sizeof(struct xt_classify_target_info),
 	.me         = THIS_MODULE,
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index d6e5ab4..1285cb6 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -112,38 +112,38 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
+static unsigned int connmark_tg_check_v0(const struct xt_tgchk_param *par)
 {
 	const struct xt_connmark_target_info *matchinfo = par->targinfo;
 
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
 		if (strcmp(par->table, "mangle") != 0) {
-			printk(KERN_WARNING "CONNMARK: restore can only be "
-			       "called from \"mangle\" table, not \"%s\"\n",
-			       par->table);
-			return false;
+			xt_compat_log(par, "CONNMARK: restore can only be "
+				"called from \"mangle\" table, not \"%s\"",
+				par->table);
+			return XT_CONNMARK_ERR_MANGLE_TABLE;
 		}
 	}
 	if (matchinfo->mark > 0xffffffff || matchinfo->mask > 0xffffffff) {
-		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
-		return false;
+		xt_compat_log(par, "CONNMARK: Only supports 32bit mark");
+		return XT_CONNMARK_ERR_32BIT_MARK;
 	}
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNMARK_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_CONNMARK_ERR_NONE;
 }
 
-static bool connmark_tg_check(const struct xt_tgchk_param *par)
+static unsigned int connmark_tg_check(const struct xt_tgchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "cannot load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNMARK_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_CONNMARK_ERR_NONE;
 }
 
 static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index b54c375..1ad4f16 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -85,15 +85,15 @@ connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
+static unsigned int connsecmark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_connsecmark_target_info *info = par->targinfo;
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
-		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
-		       "or \'security\' tables, not \'%s\'.\n", par->table);
-		return false;
+		xt_compat_log(par, PFX "target only valid in the \'mangle\' "
+			"or \'security\' tables, not \'%s\'.", par->table);
+		return XT_CONNSECMARK_ERR_MANGLE_SECURITY_TABLES;
 	}
 
 	switch (info->mode) {
@@ -102,16 +102,16 @@ static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
 		break;
 
 	default:
-		printk(KERN_INFO PFX "invalid mode: %hu\n", info->mode);
-		return false;
+		xt_compat_log(par, PFX "invalid mode: %hu", info->mode);
+		return XT_CONNSECMARK_ERR_MODE;
 	}
 
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNSECMARK_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_CONNSECMARK_ERR_NONE;
 }
 
 static void connsecmark_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 6a347e7..e4ebc71 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -61,15 +61,20 @@ dscp_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool dscp_tg_check(const struct xt_tgchk_param *par)
+static unsigned int dscp_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_DSCP_info *info = par->targinfo;
 
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "DSCP target can only be used in the "
+			      "\"mangle\" table.");
+	    	return XT_DSCP_ERR_MANGLE_TABLE;
+	}
 	if (info->dscp > XT_DSCP_MAX) {
-		printk(KERN_WARNING "DSCP: dscp %x out of range\n", info->dscp);
-		return false;
+		xt_compat_log(par, "DSCP: dscp %x out of range", info->dscp);
+		return XT_DSCP_ERR_RANGE;
 	}
-	return true;
+	return XT_DSCP_ERR_NONE;
 }
 
 static unsigned int
@@ -92,19 +97,24 @@ tos_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool tos_tg_check_v0(const struct xt_tgchk_param *par)
+static unsigned int tos_tg_check_v0(const struct xt_tgchk_param *par)
 {
 	const struct ipt_tos_target_info *info = par->targinfo;
 	const uint8_t tos = info->tos;
 
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "TOS target can only be used in the "
+			      "\"mangle\" table.");
+	    	return XT_DSCP_ERR_MANGLE_TABLE;
+	}
 	if (tos != IPTOS_LOWDELAY && tos != IPTOS_THROUGHPUT &&
 	    tos != IPTOS_RELIABILITY && tos != IPTOS_MINCOST &&
 	    tos != IPTOS_NORMALSVC) {
-		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
-		return false;
+		xt_compat_log(par, "TOS: bad tos value %#x\n", tos);
+		return XT_DSCP_ERR_VALUE;
 	}
 
-	return true;
+	return XT_DSCP_ERR_NONE;
 }
 
 static unsigned int
@@ -147,6 +157,17 @@ tos_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+static unsigned int tos_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "TOS target can only be used in the "
+			      "\"mangle\" table.");
+	    	return XT_DSCP_ERR_MANGLE_TABLE;
+	}
+
+	return XT_DSCP_ERR_NONE;
+}
+
 static struct xt_target dscp_tg_reg[] __read_mostly = {
 	{
 		.name		= "DSCP",
@@ -154,7 +175,6 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 		.checkentry	= dscp_tg_check,
 		.target		= dscp_tg,
 		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
@@ -163,14 +183,12 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 		.checkentry	= dscp_tg_check,
 		.target		= dscp_tg6,
 		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "TOS",
 		.revision	= 0,
 		.family		= NFPROTO_IPV4,
-		.table		= "mangle",
 		.target		= tos_tg_v0,
 		.targetsize	= sizeof(struct ipt_tos_target_info),
 		.checkentry	= tos_tg_check_v0,
@@ -180,18 +198,18 @@ static struct xt_target dscp_tg_reg[] __read_mostly = {
 		.name		= "TOS",
 		.revision	= 1,
 		.family		= NFPROTO_IPV4,
-		.table		= "mangle",
 		.target		= tos_tg,
 		.targetsize	= sizeof(struct xt_tos_target_info),
+		.checkentry	= tos_tg_check_v1,
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "TOS",
 		.revision	= 1,
 		.family		= NFPROTO_IPV6,
-		.table		= "mangle",
 		.target		= tos_tg6,
 		.targetsize	= sizeof(struct xt_tos_target_info),
+		.checkentry	= tos_tg_check_v1,
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 10e789e..9dfa47e 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -101,35 +101,45 @@ hl_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool ttl_tg_check(const struct xt_tgchk_param *par)
+static unsigned int ttl_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct ipt_TTL_info *info = par->targinfo;
 
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "TTL target can only be used in the "
+			      "\"mangle\" table.");
+	    	return XT_HL_ERR_MANGLE_TABLE;
+	}
 	if (info->mode > IPT_TTL_MAXMODE) {
-		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",
+		xt_compat_log(par, "ipt_TTL: invalid or unknown Mode %u",
 			info->mode);
-		return false;
+		return XT_HL_ERR_MODE;
 	}
 	if (info->mode != IPT_TTL_SET && info->ttl == 0)
-		return false;
-	return true;
+		return XT_HL_ERR_SET;
+	return XT_HL_ERR_NONE;
 }
 
-static bool hl_tg6_check(const struct xt_tgchk_param *par)
+static unsigned int hl_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_HL_info *info = par->targinfo;
 
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "HL target can only be used in the "
+			      "\"mangle\" table.");
+	    	return XT_HL_ERR_MANGLE_TABLE;
+	}
 	if (info->mode > IP6T_HL_MAXMODE) {
-		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",
+		xt_compat_log(par, "ip6t_HL: invalid or unknown Mode %u",
 			info->mode);
-		return false;
+		return XT_HL_ERR_MODE;
 	}
 	if (info->mode != IP6T_HL_SET && info->hop_limit == 0) {
-		printk(KERN_WARNING "ip6t_HL: increment/decrement doesn't "
-			"make sense with value 0\n");
-		return false;
+		xt_compat_log(par, "ip6t_HL: increment/decrement doesn't "
+			"make sense with value 0");
+		return XT_HL_ERR_SET;
 	}
-	return true;
+	return XT_HL_ERR_NONE;
 }
 
 static struct xt_target hl_tg_reg[] __read_mostly = {
@@ -139,7 +149,6 @@ static struct xt_target hl_tg_reg[] __read_mostly = {
 		.family     = NFPROTO_IPV4,
 		.target     = ttl_tg,
 		.targetsize = sizeof(struct ipt_TTL_info),
-		.table      = "mangle",
 		.checkentry = ttl_tg_check,
 		.me         = THIS_MODULE,
 	},
@@ -149,7 +158,6 @@ static struct xt_target hl_tg_reg[] __read_mostly = {
 		.family     = NFPROTO_IPV6,
 		.target     = hl_tg6,
 		.targetsize = sizeof(struct ip6t_HL_info),
-		.table      = "mangle",
 		.checkentry = hl_tg6_check,
 		.me         = THIS_MODULE,
 	},
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 8ff7843..0caad04 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -80,32 +80,32 @@ static void led_timeout_callback(unsigned long data)
 	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
 }
 
-static bool led_tg_check(const struct xt_tgchk_param *par)
+static unsigned int led_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_led_info *ledinfo = par->targinfo;
 	struct xt_led_info_internal *ledinternal;
 	int err;
 
 	if (ledinfo->id[0] == '\0') {
-		printk(KERN_ERR KBUILD_MODNAME ": No 'id' parameter given.\n");
-		return false;
+		xt_compat_log(par, KBUILD_MODNAME ": No 'id' parameter given.");
+		return XT_LED_ERR_ID;
 	}
 
 	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
 	if (!ledinternal) {
-		printk(KERN_CRIT KBUILD_MODNAME ": out of memory\n");
-		return false;
+		xt_compat_log(par, KBUILD_MODNAME ": out of memory");
+		return XT_LED_ERR_ALLOC;
 	}
 
 	ledinternal->netfilter_led_trigger.name = ledinfo->id;
 
 	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
 	if (err) {
-		printk(KERN_CRIT KBUILD_MODNAME
-			": led_trigger_register() failed\n");
+		xt_compat_log(par, KBUILD_MODNAME
+			": led_trigger_register() failed");
 		if (err == -EEXIST)
-			printk(KERN_ERR KBUILD_MODNAME
-				": Trigger name is already in use.\n");
+			xt_compat_log(par, KBUILD_MODNAME
+				": Trigger name is already in use.");
 		goto exit_alloc;
 	}
 
@@ -116,12 +116,12 @@ static bool led_tg_check(const struct xt_tgchk_param *par)
 
 	ledinfo->internal_data = ledinternal;
 
-	return true;
+	return XT_LED_ERR_NONE;
 
 exit_alloc:
 	kfree(ledinternal);
 
-	return false;
+	return XT_LED_ERR_REGISTER;
 }
 
 static void led_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 67574bc..0a5629d 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -66,33 +66,46 @@ mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool mark_tg_check_v0(const struct xt_tgchk_param *par)
+static unsigned int mark_tg_check_v0(const struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info *markinfo = par->targinfo;
-
+	const struct xt_mark_target_info *markinfo =
+		(struct xt_mark_target_info *) par->targinfo;
+
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "MARK: can only be "
+			"called from \"mangle\" table, not \"%s\"",
+			par->table);
+		return XT_MARK_ERR_MANGLE_TABLE;
+	}
 	if (markinfo->mark > 0xffffffff) {
-		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
-		return false;
+		xt_compat_log(par, "MARK: Only supports 32bit wide mark");
+		return XT_MARK_ERR_32BIT_MARK;
 	}
-	return true;
+	return XT_MARK_ERR_NONE;
 }
 
-static bool mark_tg_check_v1(const struct xt_tgchk_param *par)
+static unsigned int mark_tg_check_v1(const struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info_v1 *markinfo = par->targinfo;
-
+	const struct xt_mark_target_info_v1 *markinfo = 
+		(struct xt_mark_target_info_v1 *) par->targinfo;
+
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "MARK: can only be "
+			"called from \"mangle\" table, not \"%s\"",
+			par->table);
+		return XT_MARK_ERR_MANGLE_TABLE;
+	}
 	if (markinfo->mode != XT_MARK_SET
 	    && markinfo->mode != XT_MARK_AND
 	    && markinfo->mode != XT_MARK_OR) {
-		printk(KERN_WARNING "MARK: unknown mode %u\n",
-		       markinfo->mode);
-		return false;
+		xt_compat_log(par, "MARK: unknown mode %u", markinfo->mode);
+		return XT_MARK_ERR_MODE;
 	}
 	if (markinfo->mark > 0xffffffff) {
-		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
-		return false;
+		xt_compat_log(par, "MARK: Only supports 32bit wide mark");
+		return XT_MARK_ERR_32BIT_MARK;
 	}
-	return true;
+	return XT_MARK_ERR_NONE;
 }
 
 #ifdef CONFIG_COMPAT
@@ -159,7 +172,6 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.compat_from_user = mark_tg_compat_from_user_v0,
 		.compat_to_user	= mark_tg_compat_to_user_v0,
 #endif
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
@@ -174,7 +186,6 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.compat_from_user = mark_tg_compat_from_user_v1,
 		.compat_to_user	= mark_tg_compat_to_user_v1,
 #endif
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index a57c5cf..9e5b08e 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -37,15 +37,17 @@ nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool nflog_tg_check(const struct xt_tgchk_param *par)
+static unsigned int nflog_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_nflog_info *info = par->targinfo;
+	struct xt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
-		return false;
-	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
-		return false;
-	return true;
+		return XT_NFLOG_ERR_FLAGS;
+	if (info->prefix[sizeof(info->prefix) - 1] != '\0') {
+		info->prefix[sizeof(info->prefix) - 1] = '\0';
+		return XT_NFLOG_ERR_PREFIXLEN;
+	}
+	return XT_NFLOG_ERR_NONE;
 }
 
 static struct xt_target nflog_tg_reg __read_mostly = {
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 498b451..52a6187 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -85,22 +85,22 @@ nfqueue_tg6_v1(struct sk_buff *skb, const struct xt_target_param *par)
 }
 #endif
 
-static bool nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
+static unsigned int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_NFQ_info_v1 *info = par->targinfo;
 	u32 maxid;
 
 	if (info->queues_total == 0) {
 		pr_err("NFQUEUE: number of total queues is 0\n");
-		return false;
+		return XT_NFQUEUE_ERR_TOTAL_QUEUES;
 	}
 	maxid = info->queues_total - 1 + info->queuenum;
 	if (maxid > 0xffff) {
 		pr_err("NFQUEUE: number of queues (%u) out of range (got %u)\n",
 		       info->queues_total, maxid);
-		return false;
+		return XT_NFQUEUE_ERR_RANGE;
 	}
-	return true;
+	return XT_NFQUEUE_ERR_NONE;
 }
 
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index e7a0a54..2c8ef92 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -5,6 +5,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_NOTRACK.h>
 #include <net/netfilter/nf_conntrack.h>
 
 MODULE_DESCRIPTION("Xtables: Disabling connection tracking for packets");
@@ -30,12 +31,23 @@ notrack_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+static unsigned int notrack_tg_check(const struct xt_tgchk_param *par)
+{
+	if (strcmp(par->table, "raw") != 0) {
+		xt_compat_log(par, "NOTRACK: can only be "
+			"called from \"raw\" table, not \"%s\"",
+			par->table);
+		return XT_NOTRACK_ERR_RAW_TABLE;
+	}
+	return XT_NOTRACK_ERR_NONE;
+}
+
 static struct xt_target notrack_tg_reg __read_mostly = {
 	.name     = "NOTRACK",
 	.revision = 0,
 	.family   = NFPROTO_UNSPEC,
 	.target   = notrack_tg,
-	.table    = "raw",
+	.checkentry = notrack_tg_check,
 	.me       = THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 43f5676..3696fa9 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -84,7 +84,7 @@ xt_rateest_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
+static unsigned int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 {
 	struct xt_rateest_target_info *info = par->targinfo;
 	struct xt_rateest *est;
@@ -92,6 +92,7 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		struct nlattr		opt;
 		struct gnet_estimator	est;
 	} cfg;
+	unsigned int ret;
 
 	est = xt_rateest_lookup(info->name);
 	if (est) {
@@ -103,15 +104,17 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		    (info->interval != est->params.interval ||
 		     info->ewma_log != est->params.ewma_log)) {
 			xt_rateest_put(est);
-			return false;
+			return XT_RATEEST_ERR_NAME;
 		}
 		info->est = est;
-		return true;
+		return XT_RATEEST_ERR_NONE;
 	}
 
 	est = kzalloc(sizeof(*est), GFP_KERNEL);
-	if (!est)
+	if (!est) {
+		ret = XT_RATEEST_ERR_ALLOC;
 		goto err1;
+	}
 
 	strlcpy(est->name, info->name, sizeof(est->name));
 	spin_lock_init(&est->lock);
@@ -125,18 +128,20 @@ static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	cfg.est.ewma_log	= info->ewma_log;
 
 	if (gen_new_estimator(&est->bstats, &est->rstats, &est->lock,
-			      &cfg.opt) < 0)
+			      &cfg.opt) < 0) {
+		ret = XT_RATEEST_ERR_GEN_NEW;
 		goto err2;
+	}
 
 	info->est = est;
 	xt_rateest_hash_insert(est);
 
-	return true;
+	return XT_RATEEST_ERR_NONE;
 
 err2:
 	kfree(est);
 err1:
-	return false;
+	return ret;
 }
 
 static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 7a6f9e6..00eb056 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -49,7 +49,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool checkentry_selinux(struct xt_secmark_target_info *info)
+static unsigned int checkentry_selinux(struct xt_secmark_target_info *info)
 {
 	int err;
 	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
@@ -59,58 +59,59 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 	err = selinux_string_to_sid(sel->selctx, &sel->selsid);
 	if (err) {
 		if (err == -EINVAL)
-			printk(KERN_INFO PFX "invalid SELinux context \'%s\'\n",
-			       sel->selctx);
-		return false;
+			xt_compat_log(par, PFX "invalid SELinux context \'%s\'",
+				      sel->selctx);
+		return XT_SECMARK_ERR_CONTEXT;
 	}
 
 	if (!sel->selsid) {
-		printk(KERN_INFO PFX "unable to map SELinux context \'%s\'\n",
-		       sel->selctx);
-		return false;
+		xt_compat_log(par, PFX "unable to map SELinux context \'%s\'",
+			      sel->selctx);
+		return XT_SECMARK_ERR_MAP_CONTEXT;
 	}
 
 	err = selinux_secmark_relabel_packet_permission(sel->selsid);
 	if (err) {
-		printk(KERN_INFO PFX "unable to obtain relabeling permission\n");
-		return false;
+		xt_compat_log(par, PFX "unable to obtain relabeling permission");
+		return XT_SECMARK_ERR_PERM;
 	}
 
 	selinux_secmark_refcount_inc();
-	return true;
+	return XT_SECMARK_ERR_NONE;
 }
 
-static bool secmark_tg_check(const struct xt_tgchk_param *par)
+static unsigned int secmark_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_secmark_target_info *info = par->targinfo;
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
-		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
-		       "or \'security\' tables, not \'%s\'.\n", par->table);
-		return false;
+		xt_compat_log(par, PFX "target only valid in the \'mangle\' "
+			"or \'security\' tables, not \'%s\'.", par->table);
+		return XT_SECMARK_ERR_MANGLE_SECURITY_TABLE;
 	}
 
 	if (mode && mode != info->mode) {
-		printk(KERN_INFO PFX "mode already set to %hu cannot mix with "
-		       "rules for mode %hu\n", mode, info->mode);
-		return false;
+		xt_compat_log(par, PFX "mode already set to %hu cannot mix with "
+		       "rules for mode %hu", mode, info->mode);
+		return XT_SECMARK_ERR_MIXED_MODE;
 	}
 
 	switch (info->mode) {
-	case SECMARK_MODE_SEL:
-		if (!checkentry_selinux(info))
-			return false;
+	case SECMARK_MODE_SEL: {
+		unsigned int ret = checkentry_selinux(info);
+		if (ret != 0)
+			return ret;
 		break;
-
+	}
 	default:
-		printk(KERN_INFO PFX "invalid mode: %hu\n", info->mode);
-		return false;
+		xt_compat_log(par, PFX "invalid mode: %hu", info->mode);
+		return XT_SECMARK_ERR_INVALID_MODE;
 	}
 
 	if (!mode)
 		mode = info->mode;
-	return true;
+	return 0;
 }
 
 static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index eda64c1..01523f8 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -237,43 +237,51 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
-static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
+static unsigned int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
 
+	if (par->proto != IPPROTO_TCP || par->inverted) {
+		xt_compat_log(par, "TCPMSS target: only valid for protocol TCP");
+		return XT_TCPMSS_ERR_PROTO;
+	}
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		printk("xt_TCPMSS: path-MTU clamping only supported in "
-		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return false;
+		xt_compat_log(par, "xt_TCPMSS: path-MTU clamping only supported in "
+		       "FORWARD, OUTPUT and POSTROUTING chains");
+		return XT_TCPMSS_ERR_HOOKS_234;
 	}
 	if (IPT_MATCH_ITERATE(e, find_syn_match))
-		return true;
-	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
-	return false;
+		return XT_TCPMSS_ERR_NONE;
+	xt_compat_log(par, "xt_TCPMSS: Only works on TCP SYN packets");
+	return XT_TCPMSS_ERR_SYN;
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static bool tcpmss_tg6_check(const struct xt_tgchk_param *par)
+static unsigned int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
 
+	if (par->proto != IPPROTO_TCP || par->inverted) {
+		xt_compat_log(par, "TCPMSS target: only valid for protocol TCP");
+		return XT_TCPMSS_ERR_PROTO;
+	}
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		printk("xt_TCPMSS: path-MTU clamping only supported in "
-		       "FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return false;
+		xt_compat_log(par, "xt_TCPMSS: path-MTU clamping only supported in "
+		       "FORWARD, OUTPUT and POSTROUTING chains");
+		return XT_TCPMSS_ERR_HOOKS_234;
 	}
 	if (IP6T_MATCH_ITERATE(e, find_syn_match))
-		return true;
-	printk("xt_TCPMSS: Only works on TCP SYN packets\n");
-	return false;
+		return XT_TCPMSS_ERR_NONE;
+	xt_compat_log(par, "xt_TCPMSS: Only works on TCP SYN packets");
+	return XT_TCPMSS_ERR_SYN;
 }
 #endif
 
@@ -284,7 +292,6 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 		.checkentry	= tcpmss_tg4_check,
 		.target		= tcpmss_tg4,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
 	},
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
@@ -294,7 +301,6 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 		.checkentry	= tcpmss_tg6_check,
 		.target		= tcpmss_tg6,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
 	},
 #endif
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 9dd8c8e..517759b 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -99,12 +99,26 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 }
 #endif
 
+static unsigned int tcpoptstrip_tg_check(const struct xt_tgchk_param *par)
+{
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "TCPOPTSTRIP target: can only be "
+			"called from \"mangle\" table, not \"%s\"",
+			par->table);
+		return XT_TCPOPTSTRIP_ERR_MANGLE_TABLE;
+	}
+	if (par->proto != IPPROTO_TCP || par->inverted) {
+		xt_compat_log(par, "TCPOPTSTRIP target: only valid for protocol TCP");
+		return XT_TCPOPTSTRIP_ERR_PROTO;
+	}
+	return XT_TCPOPTSTRIP_ERR_NONE;
+}
+
 static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 	{
 		.name       = "TCPOPTSTRIP",
 		.family     = NFPROTO_IPV4,
-		.table      = "mangle",
-		.proto      = IPPROTO_TCP,
+		.checkentry = tcpoptstrip_tg_check,
 		.target     = tcpoptstrip_tg4,
 		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
 		.me         = THIS_MODULE,
@@ -113,8 +127,7 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 	{
 		.name       = "TCPOPTSTRIP",
 		.family     = NFPROTO_IPV6,
-		.table      = "mangle",
-		.proto      = IPPROTO_TCP,
+		.checkentry = tcpoptstrip_tg_check,
 		.target     = tcpoptstrip_tg6,
 		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
 		.me         = THIS_MODULE,
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 1340c2f..bd43b59 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -59,27 +59,34 @@ tproxy_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool tproxy_tg_check(const struct xt_tgchk_param *par)
+static unsigned int tproxy_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_ip *i = par->entryinfo;
-
-	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
-	    && !(i->invflags & IPT_INV_PROTO))
-		return true;
+	if (strcmp(par->table, "mangle") != 0) {
+		xt_compat_log(par, "TPROXY: can only be "
+			"called from \"mangle\" table, not \"%s\"",
+			par->table);
+		return XT_TPROXY_ERR_MANGLE_TABLE;
+	}
+	if ((par->hook_mask & ~(1 << NF_INET_PRE_ROUTING)) != 0) {
+		xt_compat_log(par, "TPROXY target can only be used in the "
+			      "PREROUTING chain.");
+		return XT_TPROXY_ERR_HOOKS_0;
+	}
+	if ((par->proto == IPPROTO_TCP || par->proto == IPPROTO_UDP)
+	    && !par->inverted)
+		return XT_TPROXY_ERR_NONE;
 
-	pr_info("xt_TPROXY: Can be used only in combination with "
-		"either -p tcp or -p udp\n");
-	return false;
+	xt_compat_log(par, "xt_TPROXY: Can be used only in combination with "
+		"either -p tcp or -p udp");
+	return XT_TPROXY_ERR_PROTO;
 }
 
 static struct xt_target tproxy_tg_reg __read_mostly = {
 	.name		= "TPROXY",
 	.family		= AF_INET,
-	.table		= "mangle",
 	.target		= tproxy_tg,
 	.targetsize	= sizeof(struct xt_tproxy_target_info),
 	.checkentry	= tproxy_tg_check,
-	.hooks		= 1 << NF_INET_PRE_ROUTING,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index fbb04b8..3b19f91 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -4,6 +4,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TRACE.h>
 
 MODULE_DESCRIPTION("Xtables: packet flow tracing");
 MODULE_LICENSE("GPL");
@@ -17,12 +18,23 @@ trace_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+static unsigned int trace_tg_check(const struct xt_tgchk_param *par)
+{
+	if (strcmp(par->table, "raw") != 0) {
+		xt_compat_log(par, "TRACE: can only be "
+			"called from \"raw\" table, not \"%s\"",
+			par->table);
+		return XT_TRACE_ERR_RAW_TABLE;
+	}
+	return XT_TRACE_ERR_NONE;
+}
+
 static struct xt_target trace_tg_reg __read_mostly = {
 	.name       = "TRACE",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
-	.table      = "raw",
 	.target     = trace_tg,
+	.checkentry = trace_tg_check,
 	.me         = THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 69a639f..97397ab 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -131,22 +131,23 @@ xt_cluster_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	       !!(info->flags & XT_CLUSTER_F_INV);
 }
 
-static bool xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
+static unsigned int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_cluster_match_info *info = par->matchinfo;
 
 	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
-		printk(KERN_ERR "xt_cluster: you have exceeded the maximum "
-				"number of cluster nodes (%u > %u)\n",
-				info->total_nodes, XT_CLUSTER_NODES_MAX);
-		return false;
+		info->total_nodes = XT_CLUSTER_NODES_MAX;
+		xt_compat_log(par, "xt_cluster: you have exceeded the maximum "
+			      "number of cluster nodes (%u > %u)",
+			      info->total_nodes, XT_CLUSTER_NODES_MAX);
+		return XT_CLUSTER_ERR_TOTAL_NODES;
 	}
 	if (info->node_mask >= (1ULL << info->total_nodes)) {
-		printk(KERN_ERR "xt_cluster: this node mask cannot be "
-				"higher than the total number of nodes\n");
-		return false;
+		xt_compat_log(par, "xt_cluster: this node mask cannot be "
+			      "higher than the total number of nodes");
+		return XT_CLUSTER_ERR_NODE_MASK;
 	}
-	return true;
+	return XT_CLUSTER_ERR_NONE;
 }
 
 static struct xt_match xt_cluster_match __read_mostly = {
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 955e659..5aeb176 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -92,27 +92,27 @@ connbytes_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		return what >= sinfo->count.from;
 }
 
-static bool connbytes_mt_check(const struct xt_mtchk_param *par)
+static unsigned int connbytes_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
 
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
 	    sinfo->what != XT_CONNBYTES_AVGPKT)
-		return false;
+		return XT_CONNBYTES_ERR_WHAT;
 
 	if (sinfo->direction != XT_CONNBYTES_DIR_ORIGINAL &&
 	    sinfo->direction != XT_CONNBYTES_DIR_REPLY &&
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
-		return false;
+		return XT_CONNBYTES_ERR_DIR;
 
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNBYTES_ERR_CONNTRACK;
 	}
 
-	return true;
+	return XT_CONNBYTES_ERR_NONE;
 }
 
 static void connbytes_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 6809809..ae0fca8 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -223,29 +223,29 @@ connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool connlimit_mt_check(const struct xt_mtchk_param *par)
+static unsigned int connlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int i;
 
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "cannot load conntrack support for "
-		       "address family %u\n", par->family);
-		return false;
+		xt_compat_log(par, "cannot load conntrack support for "
+			      "address family %u", par->family);
+		return XT_CONNLIMIT_ERR_CONNTRACK;
 	}
 
 	/* init private data */
 	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
 	if (info->data == NULL) {
 		nf_ct_l3proto_module_put(par->family);
-		return false;
+		return XT_CONNLIMIT_ERR_INIT;
 	}
 
 	spin_lock_init(&info->data->lock);
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
 		INIT_LIST_HEAD(&info->data->iphash[i]);
 
-	return true;
+	return XT_CONNLIMIT_ERR_NONE;
 }
 
 static void connlimit_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 86cacab..3f4d5bb 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -61,30 +61,30 @@ connmark_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool connmark_mt_check_v0(const struct xt_mtchk_param *par)
+static unsigned int connmark_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct xt_connmark_info *cm = par->matchinfo;
 
 	if (cm->mark > 0xffffffff || cm->mask > 0xffffffff) {
-		printk(KERN_WARNING "connmark: only support 32bit mark\n");
-		return false;
+		xt_compat_log(par, "connmark: only support 32bit mark");
+		return XT_CONNMARK_ERR_32BIT_MARK;
 	}
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNMARK_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_CONNMARK_ERR_NONE;
 }
 
-static bool connmark_mt_check(const struct xt_mtchk_param *par)
+static unsigned int connmark_mt_check(const struct xt_mtchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "cannot load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNMARK_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_CONNMARK_ERR_NONE;
 }
 
 static void connmark_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 0b7139f..5c541f9 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -278,14 +278,14 @@ conntrack_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool conntrack_mt_check(const struct xt_mtchk_param *par)
+static unsigned int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_CONNTRACK_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_CONNTRACK_ERR_NONE;
 }
 
 static void conntrack_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 0989f29..940e9f8 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -123,13 +123,22 @@ dccp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 
-static bool dccp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int dccp_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct xt_dccp_info *info = par->matchinfo;
+	struct xt_dccp_info *info = par->matchinfo;
 
-	return !(info->flags & ~XT_DCCP_VALID_FLAGS)
-		&& !(info->invflags & ~XT_DCCP_VALID_FLAGS)
-		&& !(info->invflags & ~info->flags);
+	if (par->proto != IPPROTO_DCCP || par->inverted) {
+		xt_compat_log(par, "dccp match: only valid for protocol DCCP");
+		return XT_DCCP_ERR_PROTO;
+	}
+	if ((info->flags & ~XT_DCCP_VALID_FLAGS)
+	    || (info->invflags & ~XT_DCCP_VALID_FLAGS)) {
+	    	info->flags &= ~XT_DCCP_VALID_FLAGS;
+	    	info->invflags &= ~XT_DCCP_VALID_FLAGS;
+	    	return XT_DCCP_ERR_INVALID_FLAGS;
+	} else if (info->invflags & ~info->flags)
+	    	return XT_DCCP_ERR_FLAG_INVFLAG;
+	return XT_DCCP_ERR_NONE;
 }
 
 static struct xt_match dccp_mt_reg[] __read_mostly = {
@@ -139,7 +148,6 @@ static struct xt_match dccp_mt_reg[] __read_mostly = {
 		.checkentry	= dccp_mt_check,
 		.match		= dccp_mt,
 		.matchsize	= sizeof(struct xt_dccp_info),
-		.proto		= IPPROTO_DCCP,
 		.me 		= THIS_MODULE,
 	},
 	{
@@ -148,7 +156,6 @@ static struct xt_match dccp_mt_reg[] __read_mostly = {
 		.checkentry	= dccp_mt_check,
 		.match		= dccp_mt,
 		.matchsize	= sizeof(struct xt_dccp_info),
-		.proto		= IPPROTO_DCCP,
 		.me 		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index c3f8085..44cbbcb 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -43,16 +43,16 @@ dscp_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static bool dscp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int dscp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
 
 	if (info->dscp > XT_DSCP_MAX) {
-		printk(KERN_ERR "xt_dscp: dscp %x out of range\n", info->dscp);
-		return false;
+		xt_compat_log(par, "xt_dscp: dscp %x out of range", info->dscp);
+		return XT_DSCP_ERR_RANGE;
 	}
 
-	return true;
+	return XT_DSCP_ERR_NONE;
 }
 
 static bool
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 6094399..b7adc2e 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -66,16 +66,21 @@ static bool esp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			 !!(espinfo->invflags & XT_ESP_INV_SPI));
 }
 
-static bool esp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int esp_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct xt_esp *espinfo = par->matchinfo;
+	struct xt_esp *espinfo = par->matchinfo;
 
+	if (par->proto != IPPROTO_ESP || par->inverted) {
+		xt_compat_log(par, "esp match: only valid for protocol ESP");
+		return XT_ESP_ERR_PROTO;
+	}
 	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
-		duprintf("xt_esp: unknown flags %X\n", espinfo->invflags);
-		return false;
+		duprintf("xt_esp: unknown flags %X", espinfo->invflags);
+		espinfo->invflags &= ~XT_ESP_INV_MASK;
+		return XT_ESP_ERR_FLAGS;
 	}
 
-	return true;
+	return XT_ESP_ERR_NONE;
 }
 
 static struct xt_match esp_mt_reg[] __read_mostly = {
@@ -85,7 +90,6 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
 		.checkentry	= esp_mt_check,
 		.match		= esp_mt,
 		.matchsize	= sizeof(struct xt_esp),
-		.proto		= IPPROTO_ESP,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -94,7 +98,6 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
 		.checkentry	= esp_mt_check,
 		.match		= esp_mt,
 		.matchsize	= sizeof(struct xt_esp),
-		.proto		= IPPROTO_ESP,
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 219dcdb..476ed53 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -663,29 +663,31 @@ hashlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
+static unsigned int hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	struct xt_hashlimit_info *r = par->matchinfo;
 
 	/* Check for overflow. */
 	if (r->cfg.burst == 0 ||
 	    user2credits(r->cfg.avg * r->cfg.burst) < user2credits(r->cfg.avg)) {
-		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
+		xt_compat_log(par, "xt_hashlimit: overflow, try lower: %u/%u",
 		       r->cfg.avg, r->cfg.burst);
-		return false;
+		return XT_HASHLIMIT_ERR_OVERFLOW;
 	}
 	if (r->cfg.mode == 0 ||
 	    r->cfg.mode > (XT_HASHLIMIT_HASH_DPT |
 			   XT_HASHLIMIT_HASH_DIP |
 			   XT_HASHLIMIT_HASH_SIP |
 			   XT_HASHLIMIT_HASH_SPT))
-		return false;
+		return XT_HASHLIMIT_ERR_MODE;
 	if (!r->cfg.gc_interval)
-		return false;
+		return XT_HASHLIMIT_ERR_INTERVAL;
 	if (!r->cfg.expire)
-		return false;
-	if (r->name[sizeof(r->name) - 1] != '\0')
-		return false;
+		return XT_HASHLIMIT_ERR_EXPIRE;
+	if (r->name[sizeof(r->name) - 1] != '\0') {
+		r->name[sizeof(r->name) - 1] = '\0';
+		return XT_HASHLIMIT_ERR_NAMELEN;
+	}
 
 	/* This is the best we've got: We cannot release and re-grab lock,
 	 * since checkentry() is called before x_tables.c grabs xt_mutex.
@@ -697,14 +699,14 @@ static bool hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 	r->hinfo = htable_find_get(r->name, par->match->family);
 	if (!r->hinfo && htable_create_v0(r, par->match->family) != 0) {
 		mutex_unlock(&hlimit_mutex);
-		return false;
+		return XT_HASHLIMIT_ERR_INIT;
 	}
 	mutex_unlock(&hlimit_mutex);
 
-	return true;
+	return XT_HASHLIMIT_ERR_NONE;
 }
 
-static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
+static unsigned int hashlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 
@@ -712,20 +714,20 @@ static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
 	if (info->cfg.burst == 0 ||
 	    user2credits(info->cfg.avg * info->cfg.burst) <
 	    user2credits(info->cfg.avg)) {
-		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
+		xt_compat_log(par, "xt_hashlimit: overflow, try lower: %u/%u",
 		       info->cfg.avg, info->cfg.burst);
-		return false;
+		return XT_HASHLIMIT_ERR_OVERFLOW;
 	}
 	if (info->cfg.gc_interval == 0 || info->cfg.expire == 0)
-		return false;
+		return XT_HASHLIMIT_ERR_INTERVAL;
 	if (info->name[sizeof(info->name)-1] != '\0')
-		return false;
+		return XT_HASHLIMIT_ERR_NAMELEN;
 	if (par->match->family == NFPROTO_IPV4) {
 		if (info->cfg.srcmask > 32 || info->cfg.dstmask > 32)
-			return false;
+			return XT_HASHLIMIT_ERR_NETMASK;
 	} else {
 		if (info->cfg.srcmask > 128 || info->cfg.dstmask > 128)
-			return false;
+			return XT_HASHLIMIT_ERR_NETMASK;
 	}
 
 	/* This is the best we've got: We cannot release and re-grab lock,
@@ -738,10 +740,10 @@ static bool hashlimit_mt_check(const struct xt_mtchk_param *par)
 	info->hinfo = htable_find_get(info->name, par->match->family);
 	if (!info->hinfo && htable_create(info, par->match->family) != 0) {
 		mutex_unlock(&hlimit_mutex);
-		return false;
+		return XT_HASHLIMIT_ERR_INIT;
 	}
 	mutex_unlock(&hlimit_mutex);
-	return true;
+	return XT_HASHLIMIT_ERR_NONE;
 }
 
 static void
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 64fc7f2..9dd2f6d 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -54,17 +54,17 @@ helper_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool helper_mt_check(const struct xt_mtchk_param *par)
+static unsigned int helper_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_helper_info *info = par->matchinfo;
 
 	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->family);
+		return XT_HELPER_ERR_CONNTRACK;
 	}
 	info->name[29] = '\0';
-	return true;
+	return XT_HELPER_ERR_NONE;
 }
 
 static void helper_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 2e8089e..09fa7be 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -97,7 +97,7 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / XT_LIMIT_SCALE;
 }
 
-static bool limit_mt_check(const struct xt_mtchk_param *par)
+static unsigned int limit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_rateinfo *r = par->matchinfo;
 	struct xt_limit_priv *priv;
@@ -105,14 +105,14 @@ static bool limit_mt_check(const struct xt_mtchk_param *par)
 	/* Check for overflow. */
 	if (r->burst == 0
 	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
-		printk("Overflow in xt_limit, try lower: %u/%u\n",
+		xt_compat_log(par, "Overflow in xt_limit, try lower: %u/%u",
 		       r->avg, r->burst);
-		return false;
+		return XT_LIMIT_ERR_OVERFLOW;
 	}
 
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL)
-		return -ENOMEM;
+		return XT_LIMIT_ERR_ALLOC;
 
 	/* For SMP, we only want to use one set of state. */
 	r->master = priv;
@@ -124,7 +124,7 @@ static bool limit_mt_check(const struct xt_mtchk_param *par)
 		r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
 		r->cost = user2credits(r->avg);
 	}
-	return true;
+	return XT_LIMIT_ERR_NONE;
 }
 
 static void limit_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index c200711..fee1271 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -36,14 +36,29 @@ static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		^ info->invert);
 }
 
+static unsigned int
+mac_mt_check(const struct xt_mtchk_param *par)
+{
+	unsigned int valid_hooks = (1 << NF_INET_PRE_ROUTING) | 
+		(1 << NF_INET_LOCAL_IN) |
+		(1 << NF_INET_FORWARD);
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "mac match can only be used in the "
+			      "PREROUTING, INPUT and FORWARD chains.");
+		return XT_MAC_ERR_HOOKS_012;
+	}
+
+	return XT_MAC_ERR_NONE;
+}
+
 static struct xt_match mac_mt_reg __read_mostly = {
 	.name      = "mac",
 	.revision  = 0,
 	.family    = NFPROTO_UNSPEC,
 	.match     = mac_mt,
 	.matchsize = sizeof(struct xt_mac_info),
-	.hooks     = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
-	             (1 << NF_INET_FORWARD),
+	.checkentry = mac_mt_check,
 	.me        = THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 10b9e34..6180478 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -38,15 +38,15 @@ mark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool mark_mt_check_v0(const struct xt_mtchk_param *par)
+static unsigned int mark_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct xt_mark_info *minfo = par->matchinfo;
 
 	if (minfo->mark > 0xffffffff || minfo->mask > 0xffffffff) {
-		printk(KERN_WARNING "mark: only supports 32bit mark\n");
-		return false;
+		xt_compat_log(par, "mark: only supports 32bit mark");
+		return XT_MARK_ERR_32BIT_MARK;
 	}
-	return true;
+	return XT_MARK_ERR_NONE;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index d06bb2d..eec9c98 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -141,56 +141,43 @@ multiport_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
-static inline bool
+static unsigned int
 check(u_int16_t proto,
-      u_int8_t ip_invflags,
+      bool inverted,
       u_int8_t match_flags,
       u_int8_t count)
 {
 	/* Must specify supported protocol, no unknown flags or bad count */
-	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP
-		|| proto == IPPROTO_UDPLITE
-		|| proto == IPPROTO_SCTP || proto == IPPROTO_DCCP)
-		&& !(ip_invflags & XT_INV_PROTO)
-		&& (match_flags == XT_MULTIPORT_SOURCE
-		    || match_flags == XT_MULTIPORT_DESTINATION
-		    || match_flags == XT_MULTIPORT_EITHER)
-		&& count <= XT_MULTI_PORTS;
+	if (!(proto == IPPROTO_TCP
+	      || proto == IPPROTO_UDP || proto == IPPROTO_UDPLITE
+	      || proto == IPPROTO_SCTP
+	      || proto == IPPROTO_DCCP))
+	      	return XT_MULTIPORT_ERR_PROTO;
+	else if (inverted)
+		return XT_MULTIPORT_ERR_INV_PROTO;
+	else if (!(match_flags == XT_MULTIPORT_SOURCE
+		   || match_flags == XT_MULTIPORT_DESTINATION
+		   || match_flags == XT_MULTIPORT_EITHER))
+		return XT_MULTIPORT_ERR_FLAGS;
+	else if (count > XT_MULTI_PORTS)
+		return XT_MULTIPORT_ERR_COUNT;
+	
+	return XT_MULTIPORT_ERR_NONE;
 }
 
-static bool multiport_mt_check_v0(const struct xt_mtchk_param *par)
+static unsigned int multiport_mt_check_v0(const struct xt_mtchk_param *par)
 {
-	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
+	return check(par->proto, par->inverted, multiinfo->flags,
 		     multiinfo->count);
 }
 
-static bool multiport_mt_check(const struct xt_mtchk_param *par)
+static unsigned int multiport_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count);
-}
-
-static bool multiport_mt6_check_v0(const struct xt_mtchk_param *par)
-{
-	const struct ip6t_ip6 *ip = par->entryinfo;
-	const struct xt_multiport *multiinfo = par->matchinfo;
-
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count);
-}
-
-static bool multiport_mt6_check(const struct xt_mtchk_param *par)
-{
-	const struct ip6t_ip6 *ip = par->entryinfo;
-	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
-
-	return check(ip->proto, ip->invflags, multiinfo->flags,
+	return check(par->proto, par->inverted, multiinfo->flags,
 		     multiinfo->count);
 }
 
@@ -217,7 +204,7 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 		.name		= "multiport",
 		.family		= NFPROTO_IPV6,
 		.revision	= 0,
-		.checkentry	= multiport_mt6_check_v0,
+		.checkentry	= multiport_mt_check_v0,
 		.match		= multiport_mt_v0,
 		.matchsize	= sizeof(struct xt_multiport),
 		.me		= THIS_MODULE,
@@ -226,7 +213,7 @@ static struct xt_match multiport_mt_reg[] __read_mostly = {
 		.name		= "multiport",
 		.family		= NFPROTO_IPV6,
 		.revision	= 1,
-		.checkentry	= multiport_mt6_check,
+		.checkentry	= multiport_mt_check,
 		.match		= multiport_mt,
 		.matchsize	= sizeof(struct xt_multiport_v1),
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index 863e409..075dd54 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -356,16 +356,31 @@ static bool xt_osf_match_packet(const struct sk_buff *skb,
 	return fmatch == FMATCH_OK;
 }
 
+static unsigned int xt_osf_match_check(const struct xt_mtchk_param *par)
+{
+	unsigned int valid_hooks = (1 << NF_INET_LOCAL_IN) |
+		(1 << NF_INET_PRE_ROUTING) |
+		(1 << NF_INET_FORWARD);
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "osf match can only be used in the "
+			      "INPUT, PREROUTING and FORWARD chains.");
+		return XT_OSF_ERR_HOOKS_012;
+	}
+	if (par->proto != IPPROTO_TCP || par->inverted) {
+		xt_compat_log(par, "osf match invalid for non-tcp packets");
+		return XT_OSF_ERR_NOT_TCP;
+	}
+	return XT_OSF_ERR_NONE;
+}
+
 static struct xt_match xt_osf_match = {
 	.name 		= "osf",
 	.revision	= 0,
 	.family		= NFPROTO_IPV4,
-	.proto		= IPPROTO_TCP,
-	.hooks      	= (1 << NF_INET_LOCAL_IN) |
-				(1 << NF_INET_PRE_ROUTING) |
-				(1 << NF_INET_FORWARD),
 	.match 		= xt_osf_match_packet,
 	.matchsize	= sizeof(struct xt_osf_info),
+	.checkentry	= xt_osf_match_check,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 22b2a5e..32fe7c5 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -107,31 +107,47 @@ owner_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool owner_mt_check_v0(const struct xt_mtchk_param *par)
+static unsigned int owner_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct ipt_owner_info *info = par->matchinfo;
+	unsigned int valid_hooks = (1 << NF_INET_LOCAL_OUT) |
+		(1 << NF_INET_POST_ROUTING);
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "owner match can only be used in the "
+			      "OUTPUT and POSTROUTING chains.");
+		return XT_OWNER_ERR_HOOKS_34;
+	}
 
 	if (info->match & (IPT_OWNER_PID | IPT_OWNER_SID | IPT_OWNER_COMM)) {
-		printk(KERN_WARNING KBUILD_MODNAME
+		xt_compat_log(par, KBUILD_MODNAME
 		       ": PID, SID and command matching is not "
-		       "supported anymore\n");
-		return false;
+		       "supported anymore");
+		return XT_OWNER_ERR_UNSUPPORTED;
 	}
 
-	return true;
+	return XT_OWNER_ERR_NONE;
 }
 
-static bool owner_mt6_check_v0(const struct xt_mtchk_param *par)
+static unsigned int owner_mt6_check_v0(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_owner_info *info = par->matchinfo;
+	unsigned int valid_hooks = (1 << NF_INET_LOCAL_OUT) |
+		(1 << NF_INET_POST_ROUTING);
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "owner match can only be used in the "
+			      "OUTPUT and POSTROUTING chains.");
+		return XT_OWNER_ERR_HOOKS_34;
+	}
 
 	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
-		printk(KERN_WARNING KBUILD_MODNAME
-		       ": PID and SID matching is not supported anymore\n");
-		return false;
+		xt_compat_log(par, KBUILD_MODNAME
+		       ": PID and SID matching is not supported anymore");
+		return XT_OWNER_ERR_UNSUPPORTED;
 	}
 
-	return true;
+	return XT_OWNER_ERR_NONE;
 }
 
 static struct xt_match owner_mt_reg[] __read_mostly = {
@@ -142,8 +158,6 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 		.match      = owner_mt_v0,
 		.matchsize  = sizeof(struct ipt_owner_info),
 		.checkentry = owner_mt_check_v0,
-		.hooks      = (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
 		.me         = THIS_MODULE,
 	},
 	{
@@ -153,8 +167,6 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 		.match      = owner_mt6_v0,
 		.matchsize  = sizeof(struct ip6t_owner_info),
 		.checkentry = owner_mt6_check_v0,
-		.hooks      = (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
 		.me         = THIS_MODULE,
 	},
 	{
@@ -163,8 +175,6 @@ static struct xt_match owner_mt_reg[] __read_mostly = {
 		.family     = NFPROTO_UNSPEC,
 		.match      = owner_mt,
 		.matchsize  = sizeof(struct xt_owner_match_info),
-		.hooks      = (1 << NF_INET_LOCAL_OUT) |
-		              (1 << NF_INET_POST_ROUTING),
 		.me         = THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 8d28ca5..e3f5a74 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -83,25 +83,28 @@ match_outdev:
 	return (!!ret ^ !(info->invert & XT_PHYSDEV_OP_OUT));
 }
 
-static bool physdev_mt_check(const struct xt_mtchk_param *par)
+static unsigned int physdev_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_physdev_info *info = par->matchinfo;
 
-	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
-	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
-		return false;
+	if (!(info->bitmask & XT_PHYSDEV_OP_MASK))
+		return XT_PHYSDEV_ERR_MASK;
+	else if (info->bitmask & ~XT_PHYSDEV_OP_MASK) {
+		info->bitmask &= ~XT_PHYSDEV_OP_MASK;
+		return XT_PHYSDEV_ERR_UNKNOWN;
+	}
 	if (info->bitmask & XT_PHYSDEV_OP_OUT &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
 	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
 	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
-		printk(KERN_WARNING "physdev match: using --physdev-out in the "
+		xt_compat_log(par, "physdev match: using --physdev-out in the "
 		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
-		       "traffic is not supported anymore.\n");
+		       "traffic is not supported anymore.");
 		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
-			return false;
+			return XT_PHYSDEV_ERR_UNSUPPORTED_HOOKS_234;
 	}
-	return true;
+	return XT_PHYSDEV_ERR_NONE;
 }
 
 static struct xt_match physdev_mt_reg __read_mostly = {
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 4cbfebd..7e81dc3 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -128,32 +128,32 @@ policy_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool policy_mt_check(const struct xt_mtchk_param *par)
+static unsigned int policy_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_policy_info *info = par->matchinfo;
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
-		printk(KERN_ERR "xt_policy: neither incoming nor "
-				"outgoing policy selected\n");
-		return false;
+		xt_compat_log(par, "xt_policy: neither incoming nor "
+			      "outgoing policy selected");
+		return XT_POLICY_ERR_FLAGS;
 	}
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) && info->flags & XT_POLICY_MATCH_OUT) {
-		printk(KERN_ERR "xt_policy: output policy not valid in "
-				"PRE_ROUTING and INPUT\n");
-		return false;
+		xt_compat_log(par, "xt_policy: output policy not valid in "
+			      "PREROUTING and INPUT chains");
+		return XT_POLICY_ERR_INVALID_OUTPUT_HOOKS_01;
 	}
 	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
 	    (1 << NF_INET_LOCAL_OUT)) && info->flags & XT_POLICY_MATCH_IN) {
-		printk(KERN_ERR "xt_policy: input policy not valid in "
-				"POST_ROUTING and OUTPUT\n");
-		return false;
+		xt_compat_log(par, "xt_policy: input policy not valid in "
+			      "POSTROUTING and OUTPUT chains");
+		return XT_POLICY_ERR_INVALID_INPUT_HOOKS_34;
 	}
 	if (info->len > XT_POLICY_MAX_ELEM) {
-		printk(KERN_ERR "xt_policy: too many policy elements\n");
-		return false;
+		xt_compat_log(par, "xt_policy: too many policy elements");
+		return XT_POLICY_ERR_MAX_ELEM;
 	}
-	return true;
+	return XT_POLICY_ERR_NONE;
 }
 
 static struct xt_match policy_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 01dd07b..132610a 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -43,18 +43,20 @@ quota_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool quota_mt_check(const struct xt_mtchk_param *par)
+static unsigned int quota_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_quota_info *q = par->matchinfo;
 
-	if (q->flags & ~XT_QUOTA_MASK)
-		return false;
+	if (q->flags & ~XT_QUOTA_MASK) {
+		q->flags &= ~XT_QUOTA_MASK;
+		return XT_QUOTA_ERR_FLAGS;
+	}
 
 	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
 	if (q->master == NULL)
-		return -ENOMEM;
+		return XT_QUOTA_ERR_ALLOC;
 
-	return true;
+	return XT_QUOTA_ERR_NONE;
 }
 
 static void quota_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 220a1d5..aabcae6 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -74,17 +74,22 @@ xt_rateest_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
+static unsigned int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_rateest_match_info *info = par->matchinfo;
 	struct xt_rateest *est1, *est2;
+	unsigned int ret = XT_RATEEST_ERR_NONE;
 
 	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
-				     XT_RATEEST_MATCH_REL)) != 1)
+				     XT_RATEEST_MATCH_REL)) != 1) {
+		ret = XT_RATEEST_ERR_ABS;
 		goto err1;
+	}
 
-	if (!(info->flags & (XT_RATEEST_MATCH_BPS | XT_RATEEST_MATCH_PPS)))
+	if (!(info->flags & (XT_RATEEST_MATCH_BPS | XT_RATEEST_MATCH_PPS))) {
+		ret = XT_RATEEST_ERR_BPS;
 		goto err1;
+	}
 
 	switch (info->mode) {
 	case XT_RATEEST_MATCH_EQ:
@@ -92,29 +97,34 @@ static bool xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 	case XT_RATEEST_MATCH_GT:
 		break;
 	default:
+		ret = XT_RATEEST_ERR_MODE;
 		goto err1;
 	}
 
 	est1 = xt_rateest_lookup(info->name1);
-	if (!est1)
+	if (!est1) {
+		ret = XT_RATEEST_ERR_NAME1;
 		goto err1;
+	}
 
 	if (info->flags & XT_RATEEST_MATCH_REL) {
 		est2 = xt_rateest_lookup(info->name2);
-		if (!est2)
+		if (!est2) {
+			ret = XT_RATEEST_ERR_NAME2;
 			goto err2;
+		}
 	} else
 		est2 = NULL;
 
 
 	info->est1 = est1;
 	info->est2 = est2;
-	return true;
+	return XT_RATEEST_ERR_NONE;
 
 err2:
 	xt_rateest_put(est1);
 err1:
-	return false;
+	return ret;
 }
 
 static void xt_rateest_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 484d168..ad459b8 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -30,12 +30,26 @@ realm_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
+static unsigned int realm_mt_check(const struct xt_mtchk_param *par)
+{
+	unsigned int valid_hooks = (1 << NF_INET_POST_ROUTING) |
+		(1 << NF_INET_FORWARD) |
+		(1 << NF_INET_LOCAL_OUT) |
+		(1 << NF_INET_LOCAL_IN);
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "realm match can only be used in the "
+			      "POSTROUTING, FORWARD, INPUT and OUTPUT chains.");
+		return XT_REALM_ERR_HOOKS_1234;
+	}
+	return XT_REALM_ERR_NONE;
+}
+
 static struct xt_match realm_mt_reg __read_mostly = {
 	.name		= "realm",
 	.match		= realm_mt,
 	.matchsize	= sizeof(struct xt_realm_info),
-	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
+	.checkentry	= realm_mt_check,
 	.family		= NFPROTO_UNSPEC,
 	.me		= THIS_MODULE
 };
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index eb0ceb8..51bbad1 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -277,41 +277,45 @@ out:
 	return ret;
 }
 
-static bool recent_mt_check(const struct xt_mtchk_param *par)
+static unsigned int recent_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct xt_recent_mtinfo *info = par->matchinfo;
+	struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *pde;
 #endif
 	unsigned i;
-	bool ret = false;
+	unsigned int ret = XT_RECENT_ERR_NONE;
 
 	if (hweight8(info->check_set &
 		     (XT_RECENT_SET | XT_RECENT_REMOVE |
 		      XT_RECENT_CHECK | XT_RECENT_UPDATE)) != 1)
-		return false;
+		return XT_RECENT_ERR_CHECK_SET;
 	if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
-		return false;
-	if (info->hit_count > ip_pkt_list_tot)
-		return false;
+		return XT_RECENT_ERR_SET;
+	if (info->hit_count > ip_pkt_list_tot) {
+		info->hit_count = ip_pkt_list_tot;
+		return XT_RECENT_ERR_HIT_COUNT;
+	}
 	if (info->name[0] == '\0' ||
 	    strnlen(info->name, XT_RECENT_NAME_LEN) == XT_RECENT_NAME_LEN)
-		return false;
+		return XT_RECENT_ERR_NAME;
 
 	mutex_lock(&recent_mutex);
 	t = recent_table_lookup(info->name);
 	if (t != NULL) {
 		t->refcnt++;
-		ret = true;
+		ret = XT_RECENT_ERR_NONE;
 		goto out;
 	}
 
 	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
 		    GFP_KERNEL);
-	if (t == NULL)
+	if (t == NULL) {
+		ret = XT_RECENT_ERR_ALLOC;
 		goto out;
+	}
 	t->refcnt = 1;
 	strcpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
@@ -322,6 +326,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 		  &recent_mt_fops, t);
 	if (pde == NULL) {
 		kfree(t);
+		ret = XT_RECENT_ERR_PROC;
 		goto out;
 	}
 	pde->uid = ip_list_uid;
@@ -332,6 +337,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	if (pde == NULL) {
 		remove_proc_entry(t->name, proc_old_dir);
 		kfree(t);
+		ret = XT_RECENT_ERR_PROC_ENTRY;
 		goto out;
 	}
 	pde->uid = ip_list_uid;
@@ -341,7 +347,7 @@ static bool recent_mt_check(const struct xt_mtchk_param *par)
 	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &tables);
 	spin_unlock_bh(&recent_lock);
-	ret = true;
+	ret = XT_RECENT_ERR_NONE;
 out:
 	mutex_unlock(&recent_mutex);
 	return ret;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index a189ada..abe28c3 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -147,18 +147,28 @@ sctp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
-static bool sctp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int sctp_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct xt_sctp_info *info = par->matchinfo;
+	struct xt_sctp_info *info = par->matchinfo;
 
-	return !(info->flags & ~XT_SCTP_VALID_FLAGS)
-		&& !(info->invflags & ~XT_SCTP_VALID_FLAGS)
-		&& !(info->invflags & ~info->flags)
-		&& ((!(info->flags & XT_SCTP_CHUNK_TYPES)) ||
-			(info->chunk_match_type &
-				(SCTP_CHUNK_MATCH_ALL
-				| SCTP_CHUNK_MATCH_ANY
-				| SCTP_CHUNK_MATCH_ONLY)));
+	if (par->proto != IPPROTO_SCTP || par->inverted) {
+		xt_compat_log(par, "sctp match: only valid for protocol SCTP");
+		return XT_SCTP_ERR_PROTO;
+	}
+	if ((info->flags & ~XT_SCTP_VALID_FLAGS)
+	    || (info->invflags & ~XT_SCTP_VALID_FLAGS)) {
+	    	info->flags &= ~XT_SCTP_VALID_FLAGS;
+	    	info->invflags &= ~XT_SCTP_VALID_FLAGS;
+	    	return XT_SCTP_ERR_INVALID_FLAGS;
+	} else if (info->invflags & ~info->flags)
+	    	return XT_SCTP_ERR_FLAG_INVFLAG;
+	else if ((info->flags & XT_SCTP_CHUNK_TYPES) 
+		 && !(info->chunk_match_type &
+		      (SCTP_CHUNK_MATCH_ALL
+		       | SCTP_CHUNK_MATCH_ANY
+		       | SCTP_CHUNK_MATCH_ONLY)))
+		return XT_SCTP_ERR_CHUNK;
+	return XT_SCTP_ERR_NONE;
 }
 
 static struct xt_match sctp_mt_reg[] __read_mostly = {
@@ -168,7 +178,6 @@ static struct xt_match sctp_mt_reg[] __read_mostly = {
 		.checkentry	= sctp_mt_check,
 		.match		= sctp_mt,
 		.matchsize	= sizeof(struct xt_sctp_info),
-		.proto		= IPPROTO_SCTP,
 		.me		= THIS_MODULE
 	},
 	{
@@ -177,7 +186,6 @@ static struct xt_match sctp_mt_reg[] __read_mostly = {
 		.checkentry	= sctp_mt_check,
 		.match		= sctp_mt,
 		.matchsize	= sizeof(struct xt_sctp_info),
-		.proto		= IPPROTO_SCTP,
 		.me		= THIS_MODULE
 	},
 };
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index ebf00ad..7c90f2f 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -186,13 +186,25 @@ socket_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
 	return socket_match(skb, par, par->matchinfo);
 }
 
+static unsigned int socket_mt_check(const struct xt_mtchk_param *par)
+{
+	unsigned int valid_hooks = 1 << NF_INET_PRE_ROUTING;
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "socket match can only be used in the "
+			      "PREROUTING chain.");
+		return XT_SOCKET_ERR_HOOKS_0;
+	}
+	return XT_SOCKET_ERR_NONE;
+}
+
 static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name		= "socket",
 		.revision	= 0,
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt_v0,
-		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.checkentry	= socket_mt_check,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -201,7 +213,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt_v1,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
-		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.checkentry	= socket_mt_check,
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 4c946cb..fe013af 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -37,14 +37,14 @@ state_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return (sinfo->statemask & statebit);
 }
 
-static bool state_mt_check(const struct xt_mtchk_param *par)
+static unsigned int state_mt_check(const struct xt_mtchk_param *par)
 {
 	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->match->family);
-		return false;
+		xt_compat_log(par, "can't load conntrack support for "
+			      "proto=%u", par->match->family);
+		return XT_STATE_ERR_CONNTRACK;
 	}
-	return true;
+	return XT_STATE_ERR_NONE;
 }
 
 static void state_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index d8c0f8f..bae6280 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -52,22 +52,25 @@ statistic_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return ret;
 }
 
-static bool statistic_mt_check(const struct xt_mtchk_param *par)
+static unsigned int statistic_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_statistic_info *info = par->matchinfo;
 
-	if (info->mode > XT_STATISTIC_MODE_MAX ||
-	    info->flags & ~XT_STATISTIC_MASK)
-		return false;
+	if (info->mode > XT_STATISTIC_MODE_MAX)
+		return XT_STATISTIC_ERR_MODE;
+	else if (info->flags & ~XT_STATISTIC_MASK) {
+	    	info->flags &= ~XT_STATISTIC_MASK;
+		return XT_STATISTIC_ERR_FLAGS;
+	}
 
 	info->master = kzalloc(sizeof(*info->master), GFP_KERNEL);
 	if (info->master == NULL) {
-		printk(KERN_ERR KBUILD_MODNAME ": Out of memory\n");
-		return false;
+		xt_compat_log(par, KBUILD_MODNAME ": Out of memory");
+		return XT_STATISTIC_ERR_ALLOC;
 	}
 	info->master->count = info->u.nth.count;
 
-	return true;
+	return XT_STATISTIC_ERR_NONE;
 }
 
 static void statistic_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index b4d7741..405db58 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -40,7 +40,7 @@ string_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
 
-static bool string_mt_check(const struct xt_mtchk_param *par)
+static unsigned int string_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_string_info *conf = par->matchinfo;
 	struct ts_config *ts_conf;
@@ -48,26 +48,30 @@ static bool string_mt_check(const struct xt_mtchk_param *par)
 
 	/* Damn, can't handle this case properly with iptables... */
 	if (conf->from_offset > conf->to_offset)
-		return false;
-	if (conf->algo[XT_STRING_MAX_ALGO_NAME_SIZE - 1] != '\0')
-		return false;
-	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
-		return false;
+		return XT_STRING_ERR_OFFSET;
+	if (conf->algo[XT_STRING_MAX_ALGO_NAME_SIZE - 1] != '\0') {
+		conf->algo[XT_STRING_MAX_ALGO_NAME_SIZE - 1] = '\0';
+		return XT_STRING_ERR_ALGO_NAME;
+	}
+	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE) {
+		conf->patlen = XT_STRING_MAX_PATTERN_SIZE;
+		return XT_STRING_ERR_PATLEN;
+	}
 	if (par->match->revision == 1) {
 		if (conf->u.v1.flags &
 		    ~(XT_STRING_FLAG_IGNORECASE | XT_STRING_FLAG_INVERT))
-			return false;
+			return XT_STRING_ERR_IGNORECASE;
 		if (conf->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
 			flags |= TS_IGNORECASE;
 	}
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
 				     GFP_KERNEL, flags);
 	if (IS_ERR(ts_conf))
-		return false;
+		return XT_STRING_ERR_PREPARE;
 
 	conf->config = ts_conf;
 
-	return true;
+	return XT_STRING_ERR_NONE;
 }
 
 static void string_mt_destroy(const struct xt_mtdtor_param *par)
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 4809b34..447ca08 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -77,13 +77,22 @@ dropit:
 	return false;
 }
 
+static unsigned int tcpmss_mt_check(const struct xt_mtchk_param *par)
+{
+	if (par->proto != IPPROTO_TCP || par->inverted) {
+		xt_compat_log(par, "tcpmss match: only valid for protocol TCP");
+		return XT_TCPMSS_ERR_PROTO;
+	}
+	return XT_TCPMSS_ERR_NONE;
+}
+
 static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= NFPROTO_IPV4,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
-		.proto		= IPPROTO_TCP,
+		.checkentry	= tcpmss_mt_check,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -91,7 +100,7 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
-		.proto		= IPPROTO_TCP,
+		.checkentry	= tcpmss_mt_check,
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 1ebdc49..72eb982 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -126,12 +126,20 @@ static bool tcp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool tcp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int tcp_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct xt_tcp *tcpinfo = par->matchinfo;
+	struct xt_tcp *tcpinfo = par->matchinfo;
 
+	if (par->proto != IPPROTO_TCP || par->inverted) {
+		xt_compat_log(par, "tcp match: only valid for protocol TCP");
+		return XT_TCPUDP_ERR_PROTO;
+	}
 	/* Must specify no unknown invflags */
-	return !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
+	if (tcpinfo->invflags & ~XT_TCP_INV_MASK) {
+		tcpinfo->invflags &= ~XT_TCP_INV_MASK;
+		return XT_TCPUDP_ERR_FLAGS;
+	}
+	return XT_TCPUDP_ERR_NONE;
 }
 
 static bool udp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
@@ -161,12 +169,36 @@ static bool udp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 			      !!(udpinfo->invflags & XT_UDP_INV_DSTPT));
 }
 
-static bool udp_mt_check(const struct xt_mtchk_param *par)
+static unsigned int udp_mt_check(const struct xt_mtchk_param *par)
 {
-	const struct xt_udp *udpinfo = par->matchinfo;
+	struct xt_udp *udpinfo = par->matchinfo;
 
+	if (par->proto != IPPROTO_UDP || par->inverted) {
+		xt_compat_log(par, "udp match: only valid for protocol UDP");
+		return XT_TCPUDP_ERR_PROTO;
+	}
 	/* Must specify no unknown invflags */
-	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);
+	if (udpinfo->invflags & ~XT_UDP_INV_MASK) {
+		udpinfo->invflags &= ~XT_UDP_INV_MASK;
+		return XT_TCPUDP_ERR_FLAGS;
+	}
+	return XT_TCPUDP_ERR_NONE;
+}
+
+static unsigned int udplite_mt_check(const struct xt_mtchk_param *par)
+{
+	struct xt_udp *udpinfo = par->matchinfo;
+
+	if (par->proto != IPPROTO_UDPLITE || par->inverted) {
+		xt_compat_log(par, "udplite match: only valid for protocol UDPLITE");
+		return XT_TCPUDP_ERR_PROTO;
+	}
+	/* Must specify no unknown invflags */
+	if (udpinfo->invflags & ~XT_UDP_INV_MASK) {
+		udpinfo->invflags &= ~XT_UDP_INV_MASK;
+		return XT_TCPUDP_ERR_FLAGS;
+	}
+	return XT_TCPUDP_ERR_NONE;
 }
 
 static struct xt_match tcpudp_mt_reg[] __read_mostly = {
@@ -176,7 +208,6 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 		.checkentry	= tcp_mt_check,
 		.match		= tcp_mt,
 		.matchsize	= sizeof(struct xt_tcp),
-		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -185,7 +216,6 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 		.checkentry	= tcp_mt_check,
 		.match		= tcp_mt,
 		.matchsize	= sizeof(struct xt_tcp),
-		.proto		= IPPROTO_TCP,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -194,7 +224,6 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 		.checkentry	= udp_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
-		.proto		= IPPROTO_UDP,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -203,25 +232,22 @@ static struct xt_match tcpudp_mt_reg[] __read_mostly = {
 		.checkentry	= udp_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
-		.proto		= IPPROTO_UDP,
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "udplite",
 		.family		= NFPROTO_IPV4,
-		.checkentry	= udp_mt_check,
+		.checkentry	= udplite_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
-		.proto		= IPPROTO_UDPLITE,
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "udplite",
 		.family		= NFPROTO_IPV6,
-		.checkentry	= udp_mt_check,
+		.checkentry	= udplite_mt_check,
 		.match		= udp_mt,
 		.matchsize	= sizeof(struct xt_udp),
-		.proto		= IPPROTO_UDPLITE,
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 93acaa5..59f8375 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -218,18 +218,18 @@ time_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 	return true;
 }
 
-static bool time_mt_check(const struct xt_mtchk_param *par)
+static unsigned int time_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_time_info *info = par->matchinfo;
 
 	if (info->daytime_start > XT_TIME_MAX_DAYTIME ||
 	    info->daytime_stop > XT_TIME_MAX_DAYTIME) {
-		printk(KERN_WARNING "xt_time: invalid argument - start or "
-		       "stop time greater than 23:59:59\n");
-		return false;
+		xt_compat_log(par, "xt_time: invalid argument - start or "
+		       "stop time greater than 23:59:59");
+		return XT_TIME_ERR_INVALID;
 	}
 
-	return true;
+	return XT_TIME_ERR_NONE;
 }
 
 static struct xt_match xt_time_mt_reg __read_mostly = {


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
