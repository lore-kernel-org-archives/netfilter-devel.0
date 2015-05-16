From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_log PATCH 2/3] Convert kernel to stdint types
Date: Sat, 16 May 2015 13:41:49 +0200
Message-ID: <20150516113828.GR14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:38526 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbbEPLmH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 07:42:07 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 9843C25B17E4
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:42:06 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpl7y2TqSz5vN3
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:42:06 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnetfilter_log/linux_nfnetlink_log.h | 42 +++++++++++++-------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
index 9f38277..c647581 100644
--- a/include/libnetfilter_log/linux_nfnetlink_log.h
+++ b/include/libnetfilter_log/linux_nfnetlink_log.h
@@ -20,31 +20,31 @@ enum nfulnl_msg_types {
 };
 
 struct nfulnl_msg_packet_hdr {
-	__be16		hw_protocol;	/* hw protocol (network order) */
-	__u8	hook;		/* netfilter hook */
-	__u8	_pad;
+	uint16_t		hw_protocol;	/* hw protocol (network order) */
+	uint8_t	hook;		/* netfilter hook */
+	uint8_t	_pad;
 };
 
 struct nfulnl_msg_packet_hw {
-	__be16		hw_addrlen;
-	__u16	_pad;
-	__u8	hw_addr[8];
+	uint16_t		hw_addrlen;
+	uint16_t	_pad;
+	uint8_t	hw_addr[8];
 };
 
 struct nfulnl_msg_packet_timestamp {
-	__aligned_be64	sec;
-	__aligned_be64	usec;
+	aligned_u64	sec;
+	aligned_u64	usec;
 };
 
 enum nfulnl_attr_type {
 	NFULA_UNSPEC,
 	NFULA_PACKET_HDR,
-	NFULA_MARK,			/* __u32 nfmark */
+	NFULA_MARK,			/* uint32_t nfmark */
 	NFULA_TIMESTAMP,		/* nfulnl_msg_packet_timestamp */
-	NFULA_IFINDEX_INDEV,		/* __u32 ifindex */
-	NFULA_IFINDEX_OUTDEV,		/* __u32 ifindex */
-	NFULA_IFINDEX_PHYSINDEV,	/* __u32 ifindex */
-	NFULA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
+	NFULA_IFINDEX_INDEV,		/* uint32_t ifindex */
+	NFULA_IFINDEX_OUTDEV,		/* uint32_t ifindex */
+	NFULA_IFINDEX_PHYSINDEV,	/* uint32_t ifindex */
+	NFULA_IFINDEX_PHYSOUTDEV,	/* uint32_t ifindex */
 	NFULA_HWADDR,			/* nfulnl_msg_packet_hw */
 	NFULA_PAYLOAD,			/* opaque data payload */
 	NFULA_PREFIX,			/* string prefix */
@@ -69,23 +69,23 @@ enum nfulnl_msg_config_cmds {
 };
 
 struct nfulnl_msg_config_cmd {
-	__u8	command;	/* nfulnl_msg_config_cmds */
+	uint8_t	command;	/* nfulnl_msg_config_cmds */
 } __attribute__ ((packed));
 
 struct nfulnl_msg_config_mode {
-	__be32		copy_range;
-	__u8	copy_mode;
-	__u8	_pad;
+	uint32_t		copy_range;
+	uint8_t	copy_mode;
+	uint8_t	_pad;
 } __attribute__ ((packed));
 
 enum nfulnl_attr_config {
 	NFULA_CFG_UNSPEC,
 	NFULA_CFG_CMD,			/* nfulnl_msg_config_cmd */
 	NFULA_CFG_MODE,			/* nfulnl_msg_config_mode */
-	NFULA_CFG_NLBUFSIZ,		/* __u32 buffer size */
-	NFULA_CFG_TIMEOUT,		/* __u32 in 1/100 s */
-	NFULA_CFG_QTHRESH,		/* __u32 */
-	NFULA_CFG_FLAGS,		/* __u16 */
+	NFULA_CFG_NLBUFSIZ,		/* uint32_t buffer size */
+	NFULA_CFG_TIMEOUT,		/* uint32_t in 1/100 s */
+	NFULA_CFG_QTHRESH,		/* uint32_t */
+	NFULA_CFG_FLAGS,		/* uint16_t */
 	__NFULA_CFG_MAX
 };
 #define NFULA_CFG_MAX (__NFULA_CFG_MAX -1)
-- 
2.3.6
