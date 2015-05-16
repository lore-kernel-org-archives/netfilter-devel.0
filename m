From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_queue PATCH 2/4] Convert kernel to userspace types
Date: Sat, 16 May 2015 14:33:09 +0200
Message-ID: <20150516122522.GU14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:45920 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbbEPMe1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 08:34:27 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 6BEB225AF52C
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:34:26 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpmJL1v7tz5vN8
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 14:34:26 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnetfilter_queue/linux_nfnetlink_queue.h | 52 +++++++++++-----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 5b6ae95..71cc599 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -18,49 +18,49 @@ enum nfqnl_msg_types {
 };
 
 struct nfqnl_msg_packet_hdr {
-	__be32		packet_id;	/* unique ID of packet in queue */
-	__be16		hw_protocol;	/* hw protocol (network order) */
-	__u8	hook;		/* netfilter hook */
+	uint32_t		packet_id;	/* unique ID of packet in queue */
+	uint16_t		hw_protocol;	/* hw protocol (network order) */
+	uint8_t	hook;		/* netfilter hook */
 } __attribute__ ((packed));
 
 struct nfqnl_msg_packet_hw {
-	__be16		hw_addrlen;
-	__u16	_pad;
-	__u8	hw_addr[8];
+	uint16_t		hw_addrlen;
+	uint16_t	_pad;
+	uint8_t	hw_addr[8];
 };
 
 struct nfqnl_msg_packet_timestamp {
-	__aligned_be64	sec;
-	__aligned_be64	usec;
+	aligned_u64	sec;
+	aligned_u64	usec;
 };
 
 enum nfqnl_attr_type {
 	NFQA_UNSPEC,
 	NFQA_PACKET_HDR,
 	NFQA_VERDICT_HDR,		/* nfqnl_msg_verdict_hrd */
-	NFQA_MARK,			/* __u32 nfmark */
+	NFQA_MARK,			/* uint32_t nfmark */
 	NFQA_TIMESTAMP,			/* nfqnl_msg_packet_timestamp */
-	NFQA_IFINDEX_INDEV,		/* __u32 ifindex */
-	NFQA_IFINDEX_OUTDEV,		/* __u32 ifindex */
-	NFQA_IFINDEX_PHYSINDEV,		/* __u32 ifindex */
-	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
+	NFQA_IFINDEX_INDEV,		/* uint32_t ifindex */
+	NFQA_IFINDEX_OUTDEV,		/* uint32_t ifindex */
+	NFQA_IFINDEX_PHYSINDEV,		/* uint32_t ifindex */
+	NFQA_IFINDEX_PHYSOUTDEV,	/* uint32_t ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
 	NFQA_CT,			/* nf_conntrack_netlink.h */
 	NFQA_CT_INFO,			/* enum ip_conntrack_info */
-	NFQA_CAP_LEN,			/* __u32 length of captured packet */
-	NFQA_SKB_INFO,			/* __u32 skb meta information */
+	NFQA_CAP_LEN,			/* uint32_t length of captured packet */
+	NFQA_SKB_INFO,			/* uint32_t skb meta information */
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
-	NFQA_UID,			/* __u32 sk uid */
-	NFQA_GID,			/* __u32 sk gid */
+	NFQA_UID,			/* uint32_t sk uid */
+	NFQA_GID,			/* uint32_t sk gid */
 
 	__NFQA_MAX
 };
 #define NFQA_MAX (__NFQA_MAX - 1)
 
 struct nfqnl_msg_verdict_hdr {
-	__be32 verdict;
-	__be32 id;
+	uint32_t verdict;
+	uint32_t id;
 };
 
 
@@ -73,9 +73,9 @@ enum nfqnl_msg_config_cmds {
 };
 
 struct nfqnl_msg_config_cmd {
-	__u8	command;	/* nfqnl_msg_config_cmds */
-	__u8	_pad;
-	__be16		pf;		/* AF_xxx for PF_[UN]BIND */
+	uint8_t	command;	/* nfqnl_msg_config_cmds */
+	uint8_t	_pad;
+	uint16_t		pf;		/* AF_xxx for PF_[UN]BIND */
 };
 
 enum nfqnl_config_mode {
@@ -85,8 +85,8 @@ enum nfqnl_config_mode {
 };
 
 struct nfqnl_msg_config_params {
-	__be32		copy_range;
-	__u8	copy_mode;	/* enum nfqnl_config_mode */
+	uint32_t		copy_range;
+	uint8_t	copy_mode;	/* enum nfqnl_config_mode */
 } __attribute__ ((packed));
 
 
@@ -94,9 +94,9 @@ enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
-	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
+	NFQA_CFG_QUEUE_MAXLEN,		/* uint32_t */
 	NFQA_CFG_MASK,			/* identify which flags to change */
-	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
+	NFQA_CFG_FLAGS,			/* value of these flags (uint32_t) */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
-- 
2.3.6
