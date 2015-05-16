From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_queue PATCH 1/4] Sync with kernel headers
Date: Sat, 16 May 2015 14:24:41 +0200
Message-ID: <20150516120128.GT14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:33652 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbEPMZM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 08:25:12 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id A626722B47C1
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:25:10 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpm5f1x7Tz5vN8
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:25:10 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnetfilter_queue/linux_nfnetlink_queue.h | 71 +++++++++++-----------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index f732201..5b6ae95 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -5,50 +5,51 @@
 #define aligned_u64 unsigned long long __attribute__((aligned(8)))
 #endif
 
+#include <linux/types.h>
 #include <libnfnetlink/linux_nfnetlink.h>
 
 enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
 	NFQNL_MSG_VERDICT,		/* verdict from userspace to kernel */
 	NFQNL_MSG_CONFIG,		/* connect to a particular queue */
-	NFQNL_MSG_VERDICT_BATCH,	/* batch verdict from userspace to kernel */
+	NFQNL_MSG_VERDICT_BATCH,	/* batchv from userspace to kernel */
 
 	NFQNL_MSG_MAX
 };
 
 struct nfqnl_msg_packet_hdr {
-	u_int32_t	packet_id;	/* unique ID of packet in queue */
-	u_int16_t	hw_protocol;	/* hw protocol (network order) */
-	u_int8_t	hook;		/* netfilter hook */
+	__be32		packet_id;	/* unique ID of packet in queue */
+	__be16		hw_protocol;	/* hw protocol (network order) */
+	__u8	hook;		/* netfilter hook */
 } __attribute__ ((packed));
 
 struct nfqnl_msg_packet_hw {
-	u_int16_t	hw_addrlen;
-	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
-} __attribute__ ((packed));
+	__be16		hw_addrlen;
+	__u16	_pad;
+	__u8	hw_addr[8];
+};
 
 struct nfqnl_msg_packet_timestamp {
-	aligned_u64	sec;
-	aligned_u64	usec;
-} __attribute__ ((packed));
+	__aligned_be64	sec;
+	__aligned_be64	usec;
+};
 
 enum nfqnl_attr_type {
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
 	NFQA_CT,			/* nf_conntrack_netlink.h */
 	NFQA_CT_INFO,			/* enum ip_conntrack_info */
-	NFQA_CAP_LEN,                   /* __u32 length of captured packet */
-	NFQA_SKB_INFO,                  /* __u32 skb meta information */
+	NFQA_CAP_LEN,			/* __u32 length of captured packet */
+	NFQA_SKB_INFO,			/* __u32 skb meta information */
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
@@ -58,9 +59,9 @@ enum nfqnl_attr_type {
 #define NFQA_MAX (__NFQA_MAX - 1)
 
 struct nfqnl_msg_verdict_hdr {
-	u_int32_t verdict;
-	u_int32_t id;
-} __attribute__ ((packed));
+	__be32 verdict;
+	__be32 id;
+};
 
 
 enum nfqnl_msg_config_cmds {
@@ -72,10 +73,10 @@ enum nfqnl_msg_config_cmds {
 };
 
 struct nfqnl_msg_config_cmd {
-	u_int8_t	command;	/* nfqnl_msg_config_cmds */
-	u_int8_t	_pad;
-	u_int16_t	pf;		/* AF_xxx for PF_[UN]BIND */
-} __attribute__ ((packed));
+	__u8	command;	/* nfqnl_msg_config_cmds */
+	__u8	_pad;
+	__be16		pf;		/* AF_xxx for PF_[UN]BIND */
+};
 
 enum nfqnl_config_mode {
 	NFQNL_COPY_NONE,
@@ -84,8 +85,8 @@ enum nfqnl_config_mode {
 };
 
 struct nfqnl_msg_config_params {
-	u_int32_t	copy_range;
-	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
+	__be32		copy_range;
+	__u8	copy_mode;	/* enum nfqnl_config_mode */
 } __attribute__ ((packed));
 
 
@@ -93,24 +94,26 @@ enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
-	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
+	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
 	NFQA_CFG_MASK,			/* identify which flags to change */
 	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
 
-/* Flags/options for NFQA_CFG_FLAGS */
-#define NFQA_CFG_F_FAIL_OPEN		(1 << 0)
-#define NFQA_CFG_F_CONNTRACK		(1 << 1)
-#define NFQA_CFG_F_GSO			(1 << 2)
-#define NFQA_CFG_F_UID_GID		(1 << 3)
-#define NFQA_CFG_F_MAX			(1 << 4)
+/* Flags for NFQA_CFG_FLAGS */
+#define NFQA_CFG_F_FAIL_OPEN			(1 << 0)
+#define NFQA_CFG_F_CONNTRACK			(1 << 1)
+#define NFQA_CFG_F_GSO				(1 << 2)
+#define NFQA_CFG_F_UID_GID			(1 << 3)
+#define NFQA_CFG_F_MAX				(1 << 4)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
 #define NFQA_SKB_CSUMNOTREADY (1 << 0)
 /* packet is GSO (i.e., exceeds device mtu) */
 #define NFQA_SKB_GSO (1 << 1)
+/* csum not validated (incoming device doesn't support hw checksum, etc.) */
+#define NFQA_SKB_CSUM_NOTVERIFIED (1 << 2)
 
 #endif /* _NFNETLINK_QUEUE_H */
-- 
2.3.6
