From: Felix Janda <felix.janda@posteo.de>
Subject: [libnetfilter_log PATCH 1/3] Sync with current kernel headers
Date: Sat, 16 May 2015 13:37:53 +0200
Message-ID: <20150516113524.GQ14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:33842 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbbEPLiY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 07:38:24 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id D2FFB25AF504
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:38:22 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpl3f4Thdz5vMs
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 13:38:22 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/libnetfilter_log/linux_nfnetlink_log.h | 51 +++++++++++++-------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
index 4c802c8..9f38277 100644
--- a/include/libnetfilter_log/linux_nfnetlink_log.h
+++ b/include/libnetfilter_log/linux_nfnetlink_log.h
@@ -20,33 +20,31 @@ enum nfulnl_msg_types {
 };
 
 struct nfulnl_msg_packet_hdr {
-	u_int16_t	hw_protocol;	/* hw protocol (network order) */
-	u_int8_t	hook;		/* netfilter hook */
-	u_int8_t	_pad;
-} __attribute__ ((packed));
+	__be16		hw_protocol;	/* hw protocol (network order) */
+	__u8	hook;		/* netfilter hook */
+	__u8	_pad;
+};
 
 struct nfulnl_msg_packet_hw {
-	u_int16_t	hw_addrlen;
-	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
-} __attribute__ ((packed));
+	__be16		hw_addrlen;
+	__u16	_pad;
+	__u8	hw_addr[8];
+};
 
 struct nfulnl_msg_packet_timestamp {
-	aligned_u64	sec;
-	aligned_u64	usec;
-} __attribute__ ((packed));
-
-#define NFULNL_PREFIXLEN	30	/* just like old log target */
+	__aligned_be64	sec;
+	__aligned_be64	usec;
+};
 
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
@@ -71,23 +69,23 @@ enum nfulnl_msg_config_cmds {
 };
 
 struct nfulnl_msg_config_cmd {
-	u_int8_t	command;	/* nfulnl_msg_config_cmds */
+	__u8	command;	/* nfulnl_msg_config_cmds */
 } __attribute__ ((packed));
 
 struct nfulnl_msg_config_mode {
-	u_int32_t	copy_range;
-	u_int8_t	copy_mode;
-	u_int8_t	_pad;
+	__be32		copy_range;
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
@@ -95,6 +93,7 @@ enum nfulnl_attr_config {
 #define NFULNL_COPY_NONE	0x00
 #define NFULNL_COPY_META	0x01
 #define NFULNL_COPY_PACKET	0x02
+/* 0xff is reserved, don't use it for new copy modes. */
 
 #define NFULNL_CFG_F_SEQ	0x0001
 #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
-- 
2.3.6
