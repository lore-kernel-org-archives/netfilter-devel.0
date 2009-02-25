From: arnd@arndb.de
Subject: [patch 5/7] make netfilter use strict integer types
Date: Thu, 26 Feb 2009 00:51:43 +0100
Message-ID: <20090225235515.682333715@arndb.de>
References: <20090225235138.062045835@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
	Kyle McMartin <kyle@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
	mingo@redhat.com, dwmw2@infradead.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761975AbZBZACL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:02:11 -0500
Content-Disposition: inline; filename=0006-Use-strict-integer-types-for-netfilter.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Netfilter traditionally uses BSD integer types in its
interface headers. This changes it to use the Linux
strict integer types, like everyone else.

Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/netfilter/nf_conntrack_tcp.h |    6 +++-
 include/linux/netfilter/nfnetlink.h        |    4 +-
 include/linux/netfilter/nfnetlink_compat.h |    7 ++++-
 include/linux/netfilter/nfnetlink_log.h    |   32 ++++++++++++------------
 include/linux/netfilter/nfnetlink_queue.h  |   24 +++++++++---------
 include/linux/netfilter/x_tables.h         |   30 ++++++++++++-----------
 include/linux/netfilter/xt_CLASSIFY.h      |    4 ++-
 include/linux/netfilter/xt_CONNMARK.h      |    8 ++++--
 include/linux/netfilter/xt_CONNSECMARK.h   |    4 ++-
 include/linux/netfilter/xt_DSCP.h          |    7 +++--
 include/linux/netfilter/xt_MARK.h          |    6 +++-
 include/linux/netfilter/xt_NFLOG.h         |   12 +++++----
 include/linux/netfilter/xt_NFQUEUE.h       |    4 ++-
 include/linux/netfilter/xt_RATEEST.h       |    6 +++-
 include/linux/netfilter/xt_SECMARK.h       |    6 +++-
 include/linux/netfilter/xt_TCPMSS.h        |    4 ++-
 include/linux/netfilter/xt_connbytes.h     |    6 +++-
 include/linux/netfilter/xt_connmark.h      |    8 ++++--
 include/linux/netfilter/xt_conntrack.h     |   12 ++++----
 include/linux/netfilter/xt_dccp.h          |   14 ++++++----
 include/linux/netfilter/xt_dscp.h          |   12 +++++----
 include/linux/netfilter/xt_esp.h           |    6 +++-
 include/linux/netfilter/xt_hashlimit.h     |   32 +++++++++++++-----------
 include/linux/netfilter/xt_iprange.h       |    4 ++-
 include/linux/netfilter/xt_length.h        |    6 +++-
 include/linux/netfilter/xt_limit.h         |   10 ++++---
 include/linux/netfilter/xt_mark.h          |    8 ++++--
 include/linux/netfilter/xt_multiport.h     |   18 +++++++------
 include/linux/netfilter/xt_owner.h         |    8 ++++--
 include/linux/netfilter/xt_physdev.h       |    6 +++-
 include/linux/netfilter/xt_policy.h        |   14 ++++++----
 include/linux/netfilter/xt_rateest.h       |   14 ++++++----
 include/linux/netfilter/xt_realm.h         |    8 ++++--
 include/linux/netfilter/xt_recent.h        |   12 +++++----
 include/linux/netfilter/xt_sctp.h          |   36 ++++++++++++++-------------
 include/linux/netfilter/xt_statistic.h     |   14 ++++++----
 include/linux/netfilter/xt_string.h        |   12 +++++----
 include/linux/netfilter/xt_tcpmss.h        |    6 +++-
 include/linux/netfilter/xt_tcpudp.h        |   20 ++++++++-------
 39 files changed, 260 insertions(+), 190 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index a049df4..3066789 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -2,6 +2,8 @@
 #define _NF_CONNTRACK_TCP_H
 /* TCP tracking. */
 
+#include <linux/types.h>
+
 /* This is exposed to userspace (ctnetlink) */
 enum tcp_conntrack {
 	TCP_CONNTRACK_NONE,
@@ -34,8 +36,8 @@ enum tcp_conntrack {
 #define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
 
 struct nf_ct_tcp_flags {
-	u_int8_t flags;
-	u_int8_t mask;
+	__u8 flags;
+	__u8 mask;
 };
 
 #ifdef __KERNEL__
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 7d8e045..e53546c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -25,8 +25,8 @@ enum nfnetlink_groups {
 /* General form of address family dependent message.
  */
 struct nfgenmsg {
-	u_int8_t  nfgen_family;		/* AF_xxx */
-	u_int8_t  version;		/* nfnetlink version */
+	__u8  nfgen_family;		/* AF_xxx */
+	__u8  version;		/* nfnetlink version */
 	__be16    res_id;		/* resource id */
 };
 
diff --git a/include/linux/netfilter/nfnetlink_compat.h b/include/linux/netfilter/nfnetlink_compat.h
index e145176..eda55ca 100644
--- a/include/linux/netfilter/nfnetlink_compat.h
+++ b/include/linux/netfilter/nfnetlink_compat.h
@@ -1,5 +1,8 @@
 #ifndef _NFNETLINK_COMPAT_H
 #define _NFNETLINK_COMPAT_H
+
+#include <linux/types.h>
+
 #ifndef __KERNEL__
 /* Old nfnetlink macros for userspace */
 
@@ -20,8 +23,8 @@
 
 struct nfattr
 {
-	u_int16_t nfa_len;
-	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
+	__u16 nfa_len;
+	__u16 nfa_type;	/* we use 15 bits for the type, and the highest
 				 * bit to indicate whether the payload is nested */
 };
 
diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index f661731..d3bab7a 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -17,14 +17,14 @@ enum nfulnl_msg_types {
 
 struct nfulnl_msg_packet_hdr {
 	__be16		hw_protocol;	/* hw protocol (network order) */
-	u_int8_t	hook;		/* netfilter hook */
-	u_int8_t	_pad;
+	__u8	hook;		/* netfilter hook */
+	__u8	_pad;
 };
 
 struct nfulnl_msg_packet_hw {
 	__be16		hw_addrlen;
-	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
+	__u16	_pad;
+	__u8	hw_addr[8];
 };
 
 struct nfulnl_msg_packet_timestamp {
@@ -35,12 +35,12 @@ struct nfulnl_msg_packet_timestamp {
 enum nfulnl_attr_type {
 	NFULA_UNSPEC,
 	NFULA_PACKET_HDR,
-	NFULA_MARK,			/* u_int32_t nfmark */
+	NFULA_MARK,			/* __u32 nfmark */
 	NFULA_TIMESTAMP,		/* nfulnl_msg_packet_timestamp */
-	NFULA_IFINDEX_INDEV,		/* u_int32_t ifindex */
-	NFULA_IFINDEX_OUTDEV,		/* u_int32_t ifindex */
-	NFULA_IFINDEX_PHYSINDEV,	/* u_int32_t ifindex */
-	NFULA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
+	NFULA_IFINDEX_INDEV,		/* __u32 ifindex */
+	NFULA_IFINDEX_OUTDEV,		/* __u32 ifindex */
+	NFULA_IFINDEX_PHYSINDEV,	/* __u32 ifindex */
+	NFULA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFULA_HWADDR,			/* nfulnl_msg_packet_hw */
 	NFULA_PAYLOAD,			/* opaque data payload */
 	NFULA_PREFIX,			/* string prefix */
@@ -65,23 +65,23 @@ enum nfulnl_msg_config_cmds {
 };
 
 struct nfulnl_msg_config_cmd {
-	u_int8_t	command;	/* nfulnl_msg_config_cmds */
+	__u8	command;	/* nfulnl_msg_config_cmds */
 } __attribute__ ((packed));
 
 struct nfulnl_msg_config_mode {
 	__be32		copy_range;
-	u_int8_t	copy_mode;
-	u_int8_t	_pad;
+	__u8	copy_mode;
+	__u8	_pad;
 } __attribute__ ((packed));
 
 enum nfulnl_attr_config {
 	NFULA_CFG_UNSPEC,
 	NFULA_CFG_CMD,			/* nfulnl_msg_config_cmd */
 	NFULA_CFG_MODE,			/* nfulnl_msg_config_mode */
-	NFULA_CFG_NLBUFSIZ,		/* u_int32_t buffer size */
-	NFULA_CFG_TIMEOUT,		/* u_int32_t in 1/100 s */
-	NFULA_CFG_QTHRESH,		/* u_int32_t */
-	NFULA_CFG_FLAGS,		/* u_int16_t */
+	NFULA_CFG_NLBUFSIZ,		/* __u32 buffer size */
+	NFULA_CFG_TIMEOUT,		/* __u32 in 1/100 s */
+	NFULA_CFG_QTHRESH,		/* __u32 */
+	NFULA_CFG_FLAGS,		/* __u16 */
 	__NFULA_CFG_MAX
 };
 #define NFULA_CFG_MAX (__NFULA_CFG_MAX -1)
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 83e7896..2455fe5 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -15,13 +15,13 @@ enum nfqnl_msg_types {
 struct nfqnl_msg_packet_hdr {
 	__be32		packet_id;	/* unique ID of packet in queue */
 	__be16		hw_protocol;	/* hw protocol (network order) */
-	u_int8_t	hook;		/* netfilter hook */
+	__u8	hook;		/* netfilter hook */
 } __attribute__ ((packed));
 
 struct nfqnl_msg_packet_hw {
 	__be16		hw_addrlen;
-	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
+	__u16	_pad;
+	__u8	hw_addr[8];
 };
 
 struct nfqnl_msg_packet_timestamp {
@@ -33,12 +33,12 @@ enum nfqnl_attr_type {
 	NFQA_UNSPEC,
 	NFQA_PACKET_HDR,
 	NFQA_VERDICT_HDR,		/* nfqnl_msg_verdict_hrd */
-	NFQA_MARK,			/* u_int32_t nfmark */
+	NFQA_MARK,			/* __u32 nfmark */
 	NFQA_TIMESTAMP,			/* nfqnl_msg_packet_timestamp */
-	NFQA_IFINDEX_INDEV,		/* u_int32_t ifindex */
-	NFQA_IFINDEX_OUTDEV,		/* u_int32_t ifindex */
-	NFQA_IFINDEX_PHYSINDEV,		/* u_int32_t ifindex */
-	NFQA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
+	NFQA_IFINDEX_INDEV,		/* __u32 ifindex */
+	NFQA_IFINDEX_OUTDEV,		/* __u32 ifindex */
+	NFQA_IFINDEX_PHYSINDEV,		/* __u32 ifindex */
+	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
 
@@ -61,8 +61,8 @@ enum nfqnl_msg_config_cmds {
 };
 
 struct nfqnl_msg_config_cmd {
-	u_int8_t	command;	/* nfqnl_msg_config_cmds */
-	u_int8_t	_pad;
+	__u8	command;	/* nfqnl_msg_config_cmds */
+	__u8	_pad;
 	__be16		pf;		/* AF_xxx for PF_[UN]BIND */
 };
 
@@ -74,7 +74,7 @@ enum nfqnl_config_mode {
 
 struct nfqnl_msg_config_params {
 	__be32		copy_range;
-	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
+	__u8	copy_mode;	/* enum nfqnl_config_mode */
 } __attribute__ ((packed));
 
 
@@ -82,7 +82,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
-	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
+	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c7ee874..33fd9c9 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -1,6 +1,8 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
 
+#include <linux/types.h>
+
 #define XT_FUNCTION_MAXNAMELEN 30
 #define XT_TABLE_MAXNAMELEN 32
 
@@ -8,22 +10,22 @@ struct xt_entry_match
 {
 	union {
 		struct {
-			u_int16_t match_size;
+			__u16 match_size;
 
 			/* Used by userspace */
 			char name[XT_FUNCTION_MAXNAMELEN-1];
 
-			u_int8_t revision;
+			__u8 revision;
 		} user;
 		struct {
-			u_int16_t match_size;
+			__u16 match_size;
 
 			/* Used inside the kernel */
 			struct xt_match *match;
 		} kernel;
 
 		/* Total length */
-		u_int16_t match_size;
+		__u16 match_size;
 	} u;
 
 	unsigned char data[0];
@@ -33,22 +35,22 @@ struct xt_entry_target
 {
 	union {
 		struct {
-			u_int16_t target_size;
+			__u16 target_size;
 
 			/* Used by userspace */
 			char name[XT_FUNCTION_MAXNAMELEN-1];
 
-			u_int8_t revision;
+			__u8 revision;
 		} user;
 		struct {
-			u_int16_t target_size;
+			__u16 target_size;
 
 			/* Used inside the kernel */
 			struct xt_target *target;
 		} kernel;
 
 		/* Total length */
-		u_int16_t target_size;
+		__u16 target_size;
 	} u;
 
 	unsigned char data[0];
@@ -74,7 +76,7 @@ struct xt_get_revision
 {
 	char name[XT_FUNCTION_MAXNAMELEN-1];
 
-	u_int8_t revision;
+	__u8 revision;
 };
 
 /* CONTINUE verdict for targets */
@@ -90,10 +92,10 @@ struct xt_get_revision
  */
 struct _xt_align
 {
-	u_int8_t u8;
-	u_int16_t u16;
-	u_int32_t u32;
-	u_int64_t u64;
+	__u8 u8;
+	__u16 u16;
+	__u32 u32;
+	__u64 u64;
 };
 
 #define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) 	\
@@ -109,7 +111,7 @@ struct _xt_align
 
 struct xt_counters
 {
-	u_int64_t pcnt, bcnt;			/* Packet and byte counters */
+	__u64 pcnt, bcnt;			/* Packet and byte counters */
 };
 
 /* The argument to IPT_SO_ADD_COUNTERS. */
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_CLASSIFY.h
index 5811135..a813bf1 100644
--- a/include/linux/netfilter/xt_CLASSIFY.h
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -1,8 +1,10 @@
 #ifndef _XT_CLASSIFY_H
 #define _XT_CLASSIFY_H
 
+#include <linux/types.h>
+
 struct xt_classify_target_info {
-	u_int32_t priority;
+	__u32 priority;
 };
 
 #endif /*_XT_CLASSIFY_H */
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 4e58ba4..7635c8f 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNMARK_H_target
 #define _XT_CONNMARK_H_target
 
+#include <linux/types.h>
+
 /* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  *
@@ -19,12 +21,12 @@ enum {
 struct xt_connmark_target_info {
 	unsigned long mark;
 	unsigned long mask;
-	u_int8_t mode;
+	__u8 mode;
 };
 
 struct xt_connmark_tginfo1 {
-	u_int32_t ctmark, ctmask, nfmask;
-	u_int8_t mode;
+	__u32 ctmark, ctmask, nfmask;
+	__u8 mode;
 };
 
 #endif /*_XT_CONNMARK_H_target*/
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_CONNSECMARK.h
index c6bd754..b973ff8 100644
--- a/include/linux/netfilter/xt_CONNSECMARK.h
+++ b/include/linux/netfilter/xt_CONNSECMARK.h
@@ -1,13 +1,15 @@
 #ifndef _XT_CONNSECMARK_H_target
 #define _XT_CONNSECMARK_H_target
 
+#include <linux/types.h>
+
 enum {
 	CONNSECMARK_SAVE = 1,
 	CONNSECMARK_RESTORE,
 };
 
 struct xt_connsecmark_target_info {
-	u_int8_t mode;
+	__u8 mode;
 };
 
 #endif /*_XT_CONNSECMARK_H_target */
diff --git a/include/linux/netfilter/xt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
index 14da196..648e0b3 100644
--- a/include/linux/netfilter/xt_DSCP.h
+++ b/include/linux/netfilter/xt_DSCP.h
@@ -11,15 +11,16 @@
 #ifndef _XT_DSCP_TARGET_H
 #define _XT_DSCP_TARGET_H
 #include <linux/netfilter/xt_dscp.h>
+#include <linux/types.h>
 
 /* target info */
 struct xt_DSCP_info {
-	u_int8_t dscp;
+	__u8 dscp;
 };
 
 struct xt_tos_target_info {
-	u_int8_t tos_value;
-	u_int8_t tos_mask;
+	__u8 tos_value;
+	__u8 tos_mask;
 };
 
 #endif /* _XT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt_MARK.h
index 778b278..028304b 100644
--- a/include/linux/netfilter/xt_MARK.h
+++ b/include/linux/netfilter/xt_MARK.h
@@ -1,6 +1,8 @@
 #ifndef _XT_MARK_H_target
 #define _XT_MARK_H_target
 
+#include <linux/types.h>
+
 /* Version 0 */
 struct xt_mark_target_info {
 	unsigned long mark;
@@ -15,11 +17,11 @@ enum {
 
 struct xt_mark_target_info_v1 {
 	unsigned long mark;
-	u_int8_t mode;
+	__u8 mode;
 };
 
 struct xt_mark_tginfo2 {
-	u_int32_t mark, mask;
+	__u32 mark, mask;
 };
 
 #endif /*_XT_MARK_H_target */
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index cdcd0ed..eaac7b5 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -1,17 +1,19 @@
 #ifndef _XT_NFLOG_TARGET
 #define _XT_NFLOG_TARGET
 
+#include <linux/types.h>
+
 #define XT_NFLOG_DEFAULT_GROUP		0x1
 #define XT_NFLOG_DEFAULT_THRESHOLD	1
 
 #define XT_NFLOG_MASK			0x0
 
 struct xt_nflog_info {
-	u_int32_t	len;
-	u_int16_t	group;
-	u_int16_t	threshold;
-	u_int16_t	flags;
-	u_int16_t	pad;
+	__u32	len;
+	__u16	group;
+	__u16	threshold;
+	__u16	flags;
+	__u16	pad;
 	char		prefix[64];
 };
 
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
index 9a9af79..982a89f 100644
--- a/include/linux/netfilter/xt_NFQUEUE.h
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -8,9 +8,11 @@
 #ifndef _XT_NFQ_TARGET_H
 #define _XT_NFQ_TARGET_H
 
+#include <linux/types.h>
+
 /* target info */
 struct xt_NFQ_info {
-	u_int16_t queuenum;
+	__u16 queuenum;
 };
 
 #endif /* _XT_NFQ_TARGET_H */
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index f79e313..6605e20 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -1,10 +1,12 @@
 #ifndef _XT_RATEEST_TARGET_H
 #define _XT_RATEEST_TARGET_H
 
+#include <linux/types.h>
+
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
-	int8_t			interval;
-	u_int8_t		ewma_log;
+	__s8			interval;
+	__u8		ewma_log;
 
 	/* Used internally by the kernel */
 	struct xt_rateest	*est __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index c53fbff..6fcd344 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -1,6 +1,8 @@
 #ifndef _XT_SECMARK_H_target
 #define _XT_SECMARK_H_target
 
+#include <linux/types.h>
+
 /*
  * This is intended for use by various security subsystems (but not
  * at the same time).
@@ -12,12 +14,12 @@
 #define SECMARK_SELCTX_MAX	256
 
 struct xt_secmark_target_selinux_info {
-	u_int32_t selsid;
+	__u32 selsid;
 	char selctx[SECMARK_SELCTX_MAX];
 };
 
 struct xt_secmark_target_info {
-	u_int8_t mode;
+	__u8 mode;
 	union {
 		struct xt_secmark_target_selinux_info sel;
 	} u;
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
index 53a292c..9a6960a 100644
--- a/include/linux/netfilter/xt_TCPMSS.h
+++ b/include/linux/netfilter/xt_TCPMSS.h
@@ -1,8 +1,10 @@
 #ifndef _XT_TCPMSS_H
 #define _XT_TCPMSS_H
 
+#include <linux/types.h>
+
 struct xt_tcpmss_info {
-	u_int16_t mss;
+	__u16 mss;
 };
 
 #define XT_TCPMSS_CLAMP_PMTU 0xffff
diff --git a/include/linux/netfilter/xt_connbytes.h b/include/linux/netfilter/xt_connbytes.h
index c022c98..52bd615 100644
--- a/include/linux/netfilter/xt_connbytes.h
+++ b/include/linux/netfilter/xt_connbytes.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNBYTES_H
 #define _XT_CONNBYTES_H
 
+#include <linux/types.h>
+
 enum xt_connbytes_what {
 	XT_CONNBYTES_PKTS,
 	XT_CONNBYTES_BYTES,
@@ -19,7 +21,7 @@ struct xt_connbytes_info
 		aligned_u64 from;	/* count to be matched */
 		aligned_u64 to;		/* count to be matched */
 	} count;
-	u_int8_t what;		/* ipt_connbytes_what */
-	u_int8_t direction;	/* ipt_connbytes_direction */
+	__u8 what;		/* ipt_connbytes_what */
+	__u8 direction;	/* ipt_connbytes_direction */
 };
 #endif
diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netfilter/xt_connmark.h
index 359ef86..571e266 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNMARK_H
 #define _XT_CONNMARK_H
 
+#include <linux/types.h>
+
 /* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  *
@@ -12,12 +14,12 @@
 
 struct xt_connmark_info {
 	unsigned long mark, mask;
-	u_int8_t invert;
+	__u8 invert;
 };
 
 struct xt_connmark_mtinfo1 {
-	u_int32_t mark, mask;
-	u_int8_t invert;
+	__u32 mark, mask;
+	__u8 invert;
 };
 
 #endif /*_XT_CONNMARK_H*/
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 8f53452..3430c77 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -63,9 +63,9 @@ struct xt_conntrack_info
 	unsigned long expires_min, expires_max;
 
 	/* Flags word */
-	u_int8_t flags;
+	__u8 flags;
 	/* Inverse flags */
-	u_int8_t invflags;
+	__u8 invflags;
 };
 
 struct xt_conntrack_mtinfo1 {
@@ -73,12 +73,12 @@ struct xt_conntrack_mtinfo1 {
 	union nf_inet_addr origdst_addr, origdst_mask;
 	union nf_inet_addr replsrc_addr, replsrc_mask;
 	union nf_inet_addr repldst_addr, repldst_mask;
-	u_int32_t expires_min, expires_max;
-	u_int16_t l4proto;
+	__u32 expires_min, expires_max;
+	__u16 l4proto;
 	__be16 origsrc_port, origdst_port;
 	__be16 replsrc_port, repldst_port;
-	u_int16_t match_flags, invert_flags;
-	u_int8_t state_mask, status_mask;
+	__u16 match_flags, invert_flags;
+	__u8 state_mask, status_mask;
 };
 
 #endif /*_XT_CONNTRACK_H*/
diff --git a/include/linux/netfilter/xt_dccp.h b/include/linux/netfilter/xt_dccp.h
index e0221b9..a579e1b 100644
--- a/include/linux/netfilter/xt_dccp.h
+++ b/include/linux/netfilter/xt_dccp.h
@@ -1,6 +1,8 @@
 #ifndef _XT_DCCP_H_
 #define _XT_DCCP_H_
 
+#include <linux/types.h>
+
 #define XT_DCCP_SRC_PORTS	        0x01
 #define XT_DCCP_DEST_PORTS	        0x02
 #define XT_DCCP_TYPE			0x04
@@ -9,14 +11,14 @@
 #define XT_DCCP_VALID_FLAGS		0x0f
 
 struct xt_dccp_info {
-	u_int16_t dpts[2];  /* Min, Max */
-	u_int16_t spts[2];  /* Min, Max */
+	__u16 dpts[2];  /* Min, Max */
+	__u16 spts[2];  /* Min, Max */
 
-	u_int16_t flags;
-	u_int16_t invflags;
+	__u16 flags;
+	__u16 invflags;
 
-	u_int16_t typemask;
-	u_int8_t option;
+	__u16 typemask;
+	__u8 option;
 };
 
 #endif /* _XT_DCCP_H_ */
diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
index f49bc1a..15f8932 100644
--- a/include/linux/netfilter/xt_dscp.h
+++ b/include/linux/netfilter/xt_dscp.h
@@ -10,20 +10,22 @@
 #ifndef _XT_DSCP_H
 #define _XT_DSCP_H
 
+#include <linux/types.h>
+
 #define XT_DSCP_MASK	0xfc	/* 11111100 */
 #define XT_DSCP_SHIFT	2
 #define XT_DSCP_MAX	0x3f	/* 00111111 */
 
 /* match info */
 struct xt_dscp_info {
-	u_int8_t dscp;
-	u_int8_t invert;
+	__u8 dscp;
+	__u8 invert;
 };
 
 struct xt_tos_match_info {
-	u_int8_t tos_mask;
-	u_int8_t tos_value;
-	u_int8_t invert;
+	__u8 tos_mask;
+	__u8 tos_value;
+	__u8 invert;
 };
 
 #endif /* _XT_DSCP_H */
diff --git a/include/linux/netfilter/xt_esp.h b/include/linux/netfilter/xt_esp.h
index 9380fb1..ef6fa47 100644
--- a/include/linux/netfilter/xt_esp.h
+++ b/include/linux/netfilter/xt_esp.h
@@ -1,10 +1,12 @@
 #ifndef _XT_ESP_H
 #define _XT_ESP_H
 
+#include <linux/types.h>
+
 struct xt_esp
 {
-	u_int32_t spis[2];	/* Security Parameter Index */
-	u_int8_t  invflags;	/* Inverse flags */
+	__u32 spis[2];	/* Security Parameter Index */
+	__u8  invflags;	/* Inverse flags */
 };
 
 /* Values for "invflags" field in struct xt_esp. */
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 51b18d8..b1925b5 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -1,6 +1,8 @@
 #ifndef _XT_HASHLIMIT_H
 #define _XT_HASHLIMIT_H
 
+#include <linux/types.h>
+
 /* timings are in milliseconds. */
 #define XT_HASHLIMIT_SCALE 10000
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
@@ -18,15 +20,15 @@ enum {
 };
 
 struct hashlimit_cfg {
-	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
+	__u32 mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
 
 	/* user specified */
-	u_int32_t size;		/* how many buckets */
-	u_int32_t max;		/* max number of entries */
-	u_int32_t gc_interval;	/* gc interval */
-	u_int32_t expire;	/* when do entries expire? */
+	__u32 size;		/* how many buckets */
+	__u32 max;		/* max number of entries */
+	__u32 gc_interval;	/* gc interval */
+	__u32 expire;	/* when do entries expire? */
 };
 
 struct xt_hashlimit_info {
@@ -42,17 +44,17 @@ struct xt_hashlimit_info {
 };
 
 struct hashlimit_cfg1 {
-	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
+	__u32 mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
 
 	/* user specified */
-	u_int32_t size;		/* how many buckets */
-	u_int32_t max;		/* max number of entries */
-	u_int32_t gc_interval;	/* gc interval */
-	u_int32_t expire;	/* when do entries expire? */
+	__u32 size;		/* how many buckets */
+	__u32 max;		/* max number of entries */
+	__u32 gc_interval;	/* gc interval */
+	__u32 expire;	/* when do entries expire? */
 
-	u_int8_t srcmask, dstmask;
+	__u8 srcmask, dstmask;
 };
 
 struct xt_hashlimit_mtinfo1 {
diff --git a/include/linux/netfilter/xt_iprange.h b/include/linux/netfilter/xt_iprange.h
index a4299c7..c1f21a7 100644
--- a/include/linux/netfilter/xt_iprange.h
+++ b/include/linux/netfilter/xt_iprange.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NETFILTER_XT_IPRANGE_H
 #define _LINUX_NETFILTER_XT_IPRANGE_H 1
 
+#include <linux/types.h>
+
 enum {
 	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
 	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
@@ -11,7 +13,7 @@ enum {
 struct xt_iprange_mtinfo {
 	union nf_inet_addr src_min, src_max;
 	union nf_inet_addr dst_min, dst_max;
-	u_int8_t flags;
+	__u8 flags;
 };
 
 #endif /* _LINUX_NETFILTER_XT_IPRANGE_H */
diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfilter/xt_length.h
index 7c2b439..b82ed7c 100644
--- a/include/linux/netfilter/xt_length.h
+++ b/include/linux/netfilter/xt_length.h
@@ -1,9 +1,11 @@
 #ifndef _XT_LENGTH_H
 #define _XT_LENGTH_H
 
+#include <linux/types.h>
+
 struct xt_length_info {
-    u_int16_t	min, max;
-    u_int8_t	invert;
+    __u16	min, max;
+    __u8	invert;
 };
 
 #endif /*_XT_LENGTH_H*/
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/xt_limit.h
index b3ce653..190e98b 100644
--- a/include/linux/netfilter/xt_limit.h
+++ b/include/linux/netfilter/xt_limit.h
@@ -1,19 +1,21 @@
 #ifndef _XT_RATE_H
 #define _XT_RATE_H
 
+#include <linux/types.h>
+
 /* timings are in milliseconds. */
 #define XT_LIMIT_SCALE 10000
 
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 struct xt_rateinfo {
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
 
 	/* Used internally by the kernel */
 	unsigned long prev;
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
+	__u32 credit;
+	__u32 credit_cap, cost;
 
 	/* Ugly, ugly fucker. */
 	struct xt_rateinfo *master;
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt_mark.h
index fae74bc..6fa460a 100644
--- a/include/linux/netfilter/xt_mark.h
+++ b/include/linux/netfilter/xt_mark.h
@@ -1,14 +1,16 @@
 #ifndef _XT_MARK_H
 #define _XT_MARK_H
 
+#include <linux/types.h>
+
 struct xt_mark_info {
     unsigned long mark, mask;
-    u_int8_t invert;
+    __u8 invert;
 };
 
 struct xt_mark_mtinfo1 {
-	u_int32_t mark, mask;
-	u_int8_t invert;
+	__u32 mark, mask;
+	__u8 invert;
 };
 
 #endif /*_XT_MARK_H*/
diff --git a/include/linux/netfilter/xt_multiport.h b/include/linux/netfilter/xt_multiport.h
index d49ee41..185db49 100644
--- a/include/linux/netfilter/xt_multiport.h
+++ b/include/linux/netfilter/xt_multiport.h
@@ -1,6 +1,8 @@
 #ifndef _XT_MULTIPORT_H
 #define _XT_MULTIPORT_H
 
+#include <linux/types.h>
+
 enum xt_multiport_flags
 {
 	XT_MULTIPORT_SOURCE,
@@ -13,18 +15,18 @@ enum xt_multiport_flags
 /* Must fit inside union xt_matchinfo: 16 bytes */
 struct xt_multiport
 {
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
+	__u8 flags;				/* Type of comparison */
+	__u8 count;				/* Number of ports */
+	__u16 ports[XT_MULTI_PORTS];	/* Ports */
 };
 
 struct xt_multiport_v1
 {
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
-	u_int8_t pflags[XT_MULTI_PORTS];	/* Port flags */
-	u_int8_t invert;			/* Invert flag */
+	__u8 flags;				/* Type of comparison */
+	__u8 count;				/* Number of ports */
+	__u16 ports[XT_MULTI_PORTS];	/* Ports */
+	__u8 pflags[XT_MULTI_PORTS];	/* Port flags */
+	__u8 invert;			/* Invert flag */
 };
 
 #endif /*_XT_MULTIPORT_H*/
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index c84e52c..2081761 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -1,6 +1,8 @@
 #ifndef _XT_OWNER_MATCH_H
 #define _XT_OWNER_MATCH_H
 
+#include <linux/types.h>
+
 enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
@@ -8,9 +10,9 @@ enum {
 };
 
 struct xt_owner_match_info {
-	u_int32_t uid_min, uid_max;
-	u_int32_t gid_min, gid_max;
-	u_int8_t match, invert;
+	__u32 uid_min, uid_max;
+	__u32 gid_min, gid_max;
+	__u8 match, invert;
 };
 
 #endif /* _XT_OWNER_MATCH_H */
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 25a7a18..8555e39 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -1,6 +1,8 @@
 #ifndef _XT_PHYSDEV_H
 #define _XT_PHYSDEV_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 #include <linux/if.h>
 #endif
@@ -17,8 +19,8 @@ struct xt_physdev_info {
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];
 	char out_mask[IFNAMSIZ];
-	u_int8_t invert;
-	u_int8_t bitmask;
+	__u8 invert;
+	__u8 bitmask;
 };
 
 #endif /*_XT_PHYSDEV_H*/
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index 053d8cc..7bb64e7 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -1,6 +1,8 @@
 #ifndef _XT_POLICY_H
 #define _XT_POLICY_H
 
+#include <linux/types.h>
+
 #define XT_POLICY_MAX_ELEM	4
 
 enum xt_policy_flags
@@ -19,7 +21,7 @@ enum xt_policy_modes
 
 struct xt_policy_spec
 {
-	u_int8_t	saddr:1,
+	__u8	saddr:1,
 			daddr:1,
 			proto:1,
 			mode:1,
@@ -55,9 +57,9 @@ struct xt_policy_elem
 #endif
 	};
 	__be32			spi;
-	u_int32_t		reqid;
-	u_int8_t		proto;
-	u_int8_t		mode;
+	__u32		reqid;
+	__u8		proto;
+	__u8		mode;
 
 	struct xt_policy_spec	match;
 	struct xt_policy_spec	invert;
@@ -66,8 +68,8 @@ struct xt_policy_elem
 struct xt_policy_info
 {
 	struct xt_policy_elem pol[XT_POLICY_MAX_ELEM];
-	u_int16_t flags;
-	u_int16_t len;
+	__u16 flags;
+	__u16 len;
 };
 
 #endif /* _XT_POLICY_H */
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index 2010cb7..d40a619 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -1,6 +1,8 @@
 #ifndef _XT_RATEEST_MATCH_H
 #define _XT_RATEEST_MATCH_H
 
+#include <linux/types.h>
+
 enum xt_rateest_match_flags {
 	XT_RATEEST_MATCH_INVERT	= 1<<0,
 	XT_RATEEST_MATCH_ABS	= 1<<1,
@@ -20,12 +22,12 @@ enum xt_rateest_match_mode {
 struct xt_rateest_match_info {
 	char			name1[IFNAMSIZ];
 	char			name2[IFNAMSIZ];
-	u_int16_t		flags;
-	u_int16_t		mode;
-	u_int32_t		bps1;
-	u_int32_t		pps1;
-	u_int32_t		bps2;
-	u_int32_t		pps2;
+	__u16		flags;
+	__u16		mode;
+	__u32		bps1;
+	__u32		pps1;
+	__u32		bps2;
+	__u32		pps2;
 
 	/* Used internally by the kernel */
 	struct xt_rateest	*est1 __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_realm.h b/include/linux/netfilter/xt_realm.h
index 220e872..d4a82ee 100644
--- a/include/linux/netfilter/xt_realm.h
+++ b/include/linux/netfilter/xt_realm.h
@@ -1,10 +1,12 @@
 #ifndef _XT_REALM_H
 #define _XT_REALM_H
 
+#include <linux/types.h>
+
 struct xt_realm_info {
-	u_int32_t id;
-	u_int32_t mask;
-	u_int8_t invert;
+	__u32 id;
+	__u32 mask;
+	__u8 invert;
 };
 
 #endif /* _XT_REALM_H */
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index 5cfeb81..d2c2766 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NETFILTER_XT_RECENT_H
 #define _LINUX_NETFILTER_XT_RECENT_H 1
 
+#include <linux/types.h>
+
 enum {
 	XT_RECENT_CHECK    = 1 << 0,
 	XT_RECENT_SET      = 1 << 1,
@@ -15,12 +17,12 @@ enum {
 };
 
 struct xt_recent_mtinfo {
-	u_int32_t seconds;
-	u_int32_t hit_count;
-	u_int8_t check_set;
-	u_int8_t invert;
+	__u32 seconds;
+	__u32 hit_count;
+	__u8 check_set;
+	__u8 invert;
 	char name[XT_RECENT_NAME_LEN];
-	u_int8_t side;
+	__u8 side;
 };
 
 #endif /* _LINUX_NETFILTER_XT_RECENT_H */
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index 32000ba..29287be 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -1,6 +1,8 @@
 #ifndef _XT_SCTP_H_
 #define _XT_SCTP_H_
 
+#include <linux/types.h>
+
 #define XT_SCTP_SRC_PORTS	        0x01
 #define XT_SCTP_DEST_PORTS	        0x02
 #define XT_SCTP_CHUNK_TYPES		0x04
@@ -8,49 +10,49 @@
 #define XT_SCTP_VALID_FLAGS		0x07
 
 struct xt_sctp_flag_info {
-	u_int8_t chunktype;
-	u_int8_t flag;
-	u_int8_t flag_mask;
+	__u8 chunktype;
+	__u8 flag;
+	__u8 flag_mask;
 };
 
 #define XT_NUM_SCTP_FLAGS	4
 
 struct xt_sctp_info {
-	u_int16_t dpts[2];  /* Min, Max */
-	u_int16_t spts[2];  /* Min, Max */
+	__u16 dpts[2];  /* Min, Max */
+	__u16 spts[2];  /* Min, Max */
 
-	u_int32_t chunkmap[256 / sizeof (u_int32_t)];  /* Bit mask of chunks to be matched according to RFC 2960 */
+	__u32 chunkmap[256 / sizeof (__u32)];  /* Bit mask of chunks to be matched according to RFC 2960 */
 
 #define SCTP_CHUNK_MATCH_ANY   0x01  /* Match if any of the chunk types are present */
 #define SCTP_CHUNK_MATCH_ALL   0x02  /* Match if all of the chunk types are present */
 #define SCTP_CHUNK_MATCH_ONLY  0x04  /* Match if these are the only chunk types present */
 
-	u_int32_t chunk_match_type;
+	__u32 chunk_match_type;
 	struct xt_sctp_flag_info flag_info[XT_NUM_SCTP_FLAGS];
 	int flag_count;
 
-	u_int32_t flags;
-	u_int32_t invflags;
+	__u32 flags;
+	__u32 invflags;
 };
 
 #define bytes(type) (sizeof(type) * 8)
 
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
-		(chunkmap)[type / bytes(u_int32_t)] |= 	\
-			1 << (type % bytes(u_int32_t));	\
+		(chunkmap)[type / bytes(__u32)] |= 	\
+			1 << (type % bytes(__u32));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
-		(chunkmap)[type / bytes(u_int32_t)] &= 		\
-			~(1 << (type % bytes(u_int32_t)));	\
+		(chunkmap)[type / bytes(__u32)] &= 		\
+			~(1 << (type % bytes(__u32)));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
-	((chunkmap)[type / bytes (u_int32_t)] & 		\
-		(1 << (type % bytes (u_int32_t)))) ? 1: 0;	\
+	((chunkmap)[type / bytes (__u32)] & 		\
+		(1 << (type % bytes (__u32)))) ? 1: 0;	\
 })
 
 #define SCTP_CHUNKMAP_RESET(chunkmap) \
@@ -65,7 +67,7 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
 	__sctp_chunkmap_is_clear((chunkmap), ARRAY_SIZE(chunkmap))
 static inline bool
-__sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
+__sctp_chunkmap_is_clear(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
 	for (i = 0; i < n; ++i)
@@ -77,7 +79,7 @@ __sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
 #define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
 	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
 static inline bool
-__sctp_chunkmap_is_all_set(const u_int32_t *chunkmap, unsigned int n)
+__sctp_chunkmap_is_all_set(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
 	for (i = 0; i < n; ++i)
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index 3d38bc9..095f3c6 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -1,6 +1,8 @@
 #ifndef _XT_STATISTIC_H
 #define _XT_STATISTIC_H
 
+#include <linux/types.h>
+
 enum xt_statistic_mode {
 	XT_STATISTIC_MODE_RANDOM,
 	XT_STATISTIC_MODE_NTH,
@@ -14,17 +16,17 @@ enum xt_statistic_flags {
 #define XT_STATISTIC_MASK		0x1
 
 struct xt_statistic_info {
-	u_int16_t			mode;
-	u_int16_t			flags;
+	__u16			mode;
+	__u16			flags;
 	union {
 		struct {
-			u_int32_t	probability;
+			__u32	probability;
 		} random;
 		struct {
-			u_int32_t	every;
-			u_int32_t	packet;
+			__u32	every;
+			__u32	packet;
 			/* Used internally by the kernel */
-			u_int32_t	count;
+			__u32	count;
 		} nth;
 	} u;
 	struct xt_statistic_info	*master __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index 8a6ba7b..ecbb95f 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -1,6 +1,8 @@
 #ifndef _XT_STRING_H
 #define _XT_STRING_H
 
+#include <linux/types.h>
+
 #define XT_STRING_MAX_PATTERN_SIZE 128
 #define XT_STRING_MAX_ALGO_NAME_SIZE 16
 
@@ -11,18 +13,18 @@ enum {
 
 struct xt_string_info
 {
-	u_int16_t from_offset;
-	u_int16_t to_offset;
+	__u16 from_offset;
+	__u16 to_offset;
 	char	  algo[XT_STRING_MAX_ALGO_NAME_SIZE];
 	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
-	u_int8_t  patlen;
+	__u8  patlen;
 	union {
 		struct {
-			u_int8_t  invert;
+			__u8  invert;
 		} v0;
 
 		struct {
-			u_int8_t  flags;
+			__u8  flags;
 		} v1;
 	} u;
 
diff --git a/include/linux/netfilter/xt_tcpmss.h b/include/linux/netfilter/xt_tcpmss.h
index e03274c..fbac56b 100644
--- a/include/linux/netfilter/xt_tcpmss.h
+++ b/include/linux/netfilter/xt_tcpmss.h
@@ -1,9 +1,11 @@
 #ifndef _XT_TCPMSS_MATCH_H
 #define _XT_TCPMSS_MATCH_H
 
+#include <linux/types.h>
+
 struct xt_tcpmss_match_info {
-    u_int16_t mss_min, mss_max;
-    u_int8_t invert;
+    __u16 mss_min, mss_max;
+    __u8 invert;
 };
 
 #endif /*_XT_TCPMSS_MATCH_H*/
diff --git a/include/linux/netfilter/xt_tcpudp.h b/include/linux/netfilter/xt_tcpudp.h
index 78bc65f..a490a0b 100644
--- a/include/linux/netfilter/xt_tcpudp.h
+++ b/include/linux/netfilter/xt_tcpudp.h
@@ -1,15 +1,17 @@
 #ifndef _XT_TCPUDP_H
 #define _XT_TCPUDP_H
 
+#include <linux/types.h>
+
 /* TCP matching stuff */
 struct xt_tcp
 {
-	u_int16_t spts[2];			/* Source port range. */
-	u_int16_t dpts[2];			/* Destination port range. */
-	u_int8_t option;			/* TCP Option iff non-zero*/
-	u_int8_t flg_mask;			/* TCP flags mask byte */
-	u_int8_t flg_cmp;			/* TCP flags compare byte */
-	u_int8_t invflags;			/* Inverse flags */
+	__u16 spts[2];			/* Source port range. */
+	__u16 dpts[2];			/* Destination port range. */
+	__u8 option;			/* TCP Option iff non-zero*/
+	__u8 flg_mask;			/* TCP flags mask byte */
+	__u8 flg_cmp;			/* TCP flags compare byte */
+	__u8 invflags;			/* Inverse flags */
 };
 
 /* Values for "inv" field in struct ipt_tcp. */
@@ -22,9 +24,9 @@ struct xt_tcp
 /* UDP matching stuff */
 struct xt_udp
 {
-	u_int16_t spts[2];			/* Source port range. */
-	u_int16_t dpts[2];			/* Destination port range. */
-	u_int8_t invflags;			/* Inverse flags */
+	__u16 spts[2];			/* Source port range. */
+	__u16 dpts[2];			/* Destination port range. */
+	__u8 invflags;			/* Inverse flags */
 };
 
 /* Values for "invflags" field in struct ipt_udp. */
-- 
1.5.6.3

-- 

