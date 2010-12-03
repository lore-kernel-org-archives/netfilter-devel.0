From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] include: update files with headers from Linux 2.6.37-rc1
Date: Fri,  3 Dec 2010 22:58:41 +0100
Message-ID: <1291413524-15016-4-git-send-email-jengelh@medozas.de>
References: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44585 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0LCV6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:58:50 -0500
In-Reply-To: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also includes the type change to __u{8,16,32} kernel types already.
---
 extensions/libxt_SECMARK.c               |    8 ++++----
 extensions/libxt_time.c                  |    1 +
 include/linux/netfilter/xt_CHECKSUM.h    |    8 +++++---
 include/linux/netfilter/xt_CT.h          |   10 +++++-----
 include/linux/netfilter/xt_IDLETIMER.h   |    2 +-
 include/linux/netfilter/xt_SECMARK.h     |   12 +++---------
 include/linux/netfilter/xt_TCPOPTSTRIP.h |    2 +-
 include/linux/netfilter/xt_TPROXY.h      |   17 ++++++++++++-----
 include/linux/netfilter/xt_cluster.h     |    8 ++++----
 include/linux/netfilter/xt_connlimit.h   |    2 ++
 include/linux/netfilter/xt_ipvs.h        |    2 ++
 include/linux/netfilter/xt_physdev.h     |    3 +++
 include/linux/netfilter/xt_policy.h      |   11 +++++++++++
 include/linux/netfilter/xt_quota.h       |    6 +++---
 include/linux/netfilter/xt_sctp.h        |    4 ++--
 include/linux/netfilter/xt_socket.h      |   12 ++++++++++++
 include/linux/netfilter/xt_time.h        |   14 +++++++-------
 include/linux/netfilter/xt_u32.h         |   16 ++++++++--------
 18 files changed, 86 insertions(+), 52 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h

diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 9e231ee..7bf4ff0 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -40,13 +40,13 @@ static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Can't specify --selctx twice");
 		info->mode = SECMARK_MODE_SEL;
 
-		if (strlen(optarg) > SECMARK_SELCTX_MAX-1)
+		if (strlen(optarg) > SECMARK_SECCTX_MAX-1)
 			xtables_error(PARAMETER_PROBLEM, PFX
 				   "Maximum length %u exceeded by --selctx"
 				   " parameter (%zu)",
-				   SECMARK_SELCTX_MAX-1, strlen(optarg));
+				   SECMARK_SECCTX_MAX-1, strlen(optarg));
 
-		strcpy(info->u.sel.selctx, optarg);
+		strcpy(info->secctx, optarg);
 		*flags |= SECMARK_MODE_SEL;
 		break;
 	default:
@@ -66,7 +66,7 @@ static void print_secmark(const struct xt_secmark_target_info *info)
 {
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
-		printf("selctx %s ", info->u.sel.selctx);\
+		printf("selctx %s ", info->secctx);
 		break;
 	
 	default:
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 9f12266..5462d93 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -20,6 +20,7 @@
 #include <time.h>
 #include <limits.h>
 
+#include <linux/types.h>
 #include <linux/netfilter/xt_time.h>
 #include <xtables.h>
 
diff --git a/include/linux/netfilter/xt_CHECKSUM.h b/include/linux/netfilter/xt_CHECKSUM.h
index 3b4fb77..9a2e466 100644
--- a/include/linux/netfilter/xt_CHECKSUM.h
+++ b/include/linux/netfilter/xt_CHECKSUM.h
@@ -6,8 +6,10 @@
  *
  * This software is distributed under GNU GPL v2, 1991
 */
-#ifndef _IPT_CHECKSUM_TARGET_H
-#define _IPT_CHECKSUM_TARGET_H
+#ifndef _XT_CHECKSUM_TARGET_H
+#define _XT_CHECKSUM_TARGET_H
+
+#include <linux/types.h>
 
 #define XT_CHECKSUM_OP_FILL	0x01	/* fill in checksum in IP header */
 
@@ -15,4 +17,4 @@ struct xt_CHECKSUM_info {
 	__u8 operation;	/* bitset of operations */
 };
 
-#endif /* _IPT_CHECKSUM_TARGET_H */
+#endif /* _XT_CHECKSUM_TARGET_H */
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
index 1b56410..fbf4c56 100644
--- a/include/linux/netfilter/xt_CT.h
+++ b/include/linux/netfilter/xt_CT.h
@@ -4,11 +4,11 @@
 #define XT_CT_NOTRACK	0x1
 
 struct xt_ct_target_info {
-	u_int16_t	flags;
-	u_int16_t	zone;
-	u_int32_t	ct_events;
-	u_int32_t	exp_events;
-	char		helper[16];
+	__u16 flags;
+	__u16 zone;
+	__u32 ct_events;
+	__u32 exp_events;
+	char helper[16];
 
 	/* Used internally by the kernel */
 	struct nf_conn	*ct __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_IDLETIMER.h
index 3e1aa1b..208ae93 100644
--- a/include/linux/netfilter/xt_IDLETIMER.h
+++ b/include/linux/netfilter/xt_IDLETIMER.h
@@ -39,7 +39,7 @@ struct idletimer_tg_info {
 	char label[MAX_IDLETIMER_LABEL_SIZE];
 
 	/* for kernel module internal use only */
-	struct idletimer_tg *timer __attribute((aligned(8)));
+	struct idletimer_tg *timer __attribute__((aligned(8)));
 };
 
 #endif
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index 6fcd344..989092b 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -11,18 +11,12 @@
  * packets are being marked for.
  */
 #define SECMARK_MODE_SEL	0x01		/* SELinux */
-#define SECMARK_SELCTX_MAX	256
-
-struct xt_secmark_target_selinux_info {
-	__u32 selsid;
-	char selctx[SECMARK_SELCTX_MAX];
-};
+#define SECMARK_SECCTX_MAX	256
 
 struct xt_secmark_target_info {
 	__u8 mode;
-	union {
-		struct xt_secmark_target_selinux_info sel;
-	} u;
+	__u32 secid;
+	char secctx[SECMARK_SECCTX_MAX];
 };
 
 #endif /*_XT_SECMARK_H_target */
diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
index 2db5432..342ef14 100644
--- a/include/linux/netfilter/xt_TCPOPTSTRIP.h
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -7,7 +7,7 @@
 	(((1U << (idx & 31)) & bmap[(idx) >> 5]) != 0)
 
 struct xt_tcpoptstrip_target_info {
-	u_int32_t strip_bmap[8];
+	__u32 strip_bmap[8];
 };
 
 #endif /* _XT_TCPOPTSTRIP_H */
diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_TPROXY.h
index 152e8f9..8097e0b 100644
--- a/include/linux/netfilter/xt_TPROXY.h
+++ b/include/linux/netfilter/xt_TPROXY.h
@@ -1,14 +1,21 @@
-#ifndef _XT_TPROXY_H_target
-#define _XT_TPROXY_H_target
+#ifndef _XT_TPROXY_H
+#define _XT_TPROXY_H
 
 /* TPROXY target is capable of marking the packet to perform
  * redirection. We can get rid of that whenever we get support for
  * mutliple targets in the same rule. */
 struct xt_tproxy_target_info {
-	u_int32_t mark_mask;
-	u_int32_t mark_value;
+	__u32 mark_mask;
+	__u32 mark_value;
 	__be32 laddr;
 	__be16 lport;
 };
 
-#endif /* _XT_TPROXY_H_target */
+struct xt_tproxy_target_info_v1 {
+	__u32 mark_mask;
+	__u32 mark_value;
+	union nf_inet_addr laddr;
+	__be16 lport;
+};
+
+#endif /* _XT_TPROXY_H */
diff --git a/include/linux/netfilter/xt_cluster.h b/include/linux/netfilter/xt_cluster.h
index 8866826..66cfa3c 100644
--- a/include/linux/netfilter/xt_cluster.h
+++ b/include/linux/netfilter/xt_cluster.h
@@ -6,10 +6,10 @@ enum xt_cluster_flags {
 };
 
 struct xt_cluster_match_info {
-	u_int32_t		total_nodes;
-	u_int32_t		node_mask;
-	u_int32_t		hash_seed;
-	u_int32_t		flags;
+	__u32 total_nodes;
+	__u32 node_mask;
+	__u32 hash_seed;
+	__u32 flags;
 };
 
 #define XT_CLUSTER_NODES_MAX	32
diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 9ba54e4..7e3284b 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -6,10 +6,12 @@ struct xt_connlimit_data;
 struct xt_connlimit_info {
 	union {
 		union nf_inet_addr mask;
+#ifndef __KERNEL__
 		union {
 			__be32 v4_mask;
 			__be32 v6_mask[4];
 		};
+#endif
 	};
 	unsigned int limit, inverse;
 
diff --git a/include/linux/netfilter/xt_ipvs.h b/include/linux/netfilter/xt_ipvs.h
index 1167aeb..eff34ac 100644
--- a/include/linux/netfilter/xt_ipvs.h
+++ b/include/linux/netfilter/xt_ipvs.h
@@ -1,6 +1,8 @@
 #ifndef _XT_IPVS_H
 #define _XT_IPVS_H
 
+#include <linux/types.h>
+
 enum {
 	XT_IPVS_IPVS_PROPERTY =	1 << 0, /* all other options imply this one */
 	XT_IPVS_PROTO =		1 << 1,
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 7d53660..8555e39 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -3,6 +3,9 @@
 
 #include <linux/types.h>
 
+#ifdef __KERNEL__
+#include <linux/if.h>
+#endif
 
 #define XT_PHYSDEV_OP_IN		0x01
 #define XT_PHYSDEV_OP_OUT		0x02
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index d246eac..be8ead0 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -26,19 +26,30 @@ struct xt_policy_spec {
 			reqid:1;
 };
 
+#ifndef __KERNEL__
 union xt_policy_addr {
 	struct in_addr	a4;
 	struct in6_addr	a6;
 };
+#endif
 
 struct xt_policy_elem {
 	union {
+#ifdef __KERNEL__
+		struct {
+			union nf_inet_addr saddr;
+			union nf_inet_addr smask;
+			union nf_inet_addr daddr;
+			union nf_inet_addr dmask;
+		};
+#else
 		struct {
 			union xt_policy_addr saddr;
 			union xt_policy_addr smask;
 			union xt_policy_addr daddr;
 			union xt_policy_addr dmask;
 		};
+#endif
 	};
 	__be32			spi;
 	__u32		reqid;
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index b0d28c6..8bda65f 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -9,9 +9,9 @@ enum xt_quota_flags {
 struct xt_quota_priv;
 
 struct xt_quota_info {
-	u_int32_t		flags;
-	u_int32_t		pad;
-	aligned_u64		quota;
+	__u32 flags;
+	__u32 pad;
+	aligned_u64 quota;
 
 	/* Used internally by the kernel */
 	struct xt_quota_priv	*master;
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index a501e61..29287be 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -66,7 +66,7 @@ struct xt_sctp_info {
 
 #define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
 	__sctp_chunkmap_is_clear((chunkmap), ARRAY_SIZE(chunkmap))
-static __inline__ bool
+static inline bool
 __sctp_chunkmap_is_clear(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
@@ -78,7 +78,7 @@ __sctp_chunkmap_is_clear(const __u32 *chunkmap, unsigned int n)
 
 #define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
 	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
-static __inline__ bool
+static inline bool
 __sctp_chunkmap_is_all_set(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..6f475b8
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,12 @@
+#ifndef _XT_SOCKET_H
+#define _XT_SOCKET_H
+
+enum {
+	XT_SOCKET_TRANSPARENT = 1 << 0,
+};
+
+struct xt_socket_mtinfo1 {
+	__u8 flags;
+};
+
+#endif /* _XT_SOCKET_H */
diff --git a/include/linux/netfilter/xt_time.h b/include/linux/netfilter/xt_time.h
index 14b6df4..b8bd456 100644
--- a/include/linux/netfilter/xt_time.h
+++ b/include/linux/netfilter/xt_time.h
@@ -2,13 +2,13 @@
 #define _XT_TIME_H 1
 
 struct xt_time_info {
-	u_int32_t date_start;
-	u_int32_t date_stop;
-	u_int32_t daytime_start;
-	u_int32_t daytime_stop;
-	u_int32_t monthdays_match;
-	u_int8_t weekdays_match;
-	u_int8_t flags;
+	__u32 date_start;
+	__u32 date_stop;
+	__u32 daytime_start;
+	__u32 daytime_stop;
+	__u32 monthdays_match;
+	__u8 weekdays_match;
+	__u8 flags;
 };
 
 enum {
diff --git a/include/linux/netfilter/xt_u32.h b/include/linux/netfilter/xt_u32.h
index 9947f56..e8c3d87 100644
--- a/include/linux/netfilter/xt_u32.h
+++ b/include/linux/netfilter/xt_u32.h
@@ -9,13 +9,13 @@ enum xt_u32_ops {
 };
 
 struct xt_u32_location_element {
-	u_int32_t number;
-	u_int8_t nextop;
+	__u32 number;
+	__u8 nextop;
 };
 
 struct xt_u32_value_element {
-	u_int32_t min;
-	u_int32_t max;
+	__u32 min;
+	__u32 max;
 };
 
 /*
@@ -27,14 +27,14 @@ struct xt_u32_value_element {
 struct xt_u32_test {
 	struct xt_u32_location_element location[XT_U32_MAXSIZE+1];
 	struct xt_u32_value_element value[XT_U32_MAXSIZE+1];
-	u_int8_t nnums;
-	u_int8_t nvalues;
+	__u8 nnums;
+	__u8 nvalues;
 };
 
 struct xt_u32 {
 	struct xt_u32_test tests[XT_U32_MAXSIZE+1];
-	u_int8_t ntests;
-	u_int8_t invert;
+	__u8 ntests;
+	__u8 invert;
 };
 
 #endif /* _XT_U32_H */
-- 
1.7.1

