From: Jan Engelhardt <jengelh@medozas.de>
Subject: [NETFILTER]: Change IFNAMSIZ to 16
Date: Wed, 30 Jul 2008 08:34:58 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807300834080.5659@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48230 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYG3MfA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:35:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 280d718a7686c0b709cebd18328f9a85d447eb9a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jul 29 17:01:51 2008 -0400

[NETFILTER]: Change IFNAMSIZ to 16

The protocol for communication with userspace is fixed; using
IFNAMSIZ would indicate this was changable, which it is not.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_RATEEST.h    |    2 +-
 include/linux/netfilter/xt_hashlimit.h  |    4 ++--
 include/linux/netfilter/xt_physdev.h    |    8 ++++----
 include/linux/netfilter/xt_rateest.h    |    4 ++--
 include/linux/netfilter_ipv4/ipt_ULOG.h |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index f79e313..969e219 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -2,7 +2,7 @@
 #define _XT_RATEEST_TARGET_H
 
 struct xt_rateest_target_info {
-	char			name[IFNAMSIZ];
+	char			name[16];
 	int8_t			interval;
 	u_int8_t		ewma_log;
 
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 51b18d8..dcca2db 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -30,7 +30,7 @@ struct hashlimit_cfg {
 };
 
 struct xt_hashlimit_info {
-	char name [IFNAMSIZ];		/* name */
+	char name [16];		/* name */
 	struct hashlimit_cfg cfg;
 
 	/* Used internally by the kernel */
@@ -56,7 +56,7 @@ struct hashlimit_cfg1 {
 };
 
 struct xt_hashlimit_mtinfo1 {
-	char name[IFNAMSIZ];
+	char name[16];
 	struct hashlimit_cfg1 cfg;
 
 	/* Used internally by the kernel */
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 25a7a18..1cceb14 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -13,10 +13,10 @@
 #define XT_PHYSDEV_OP_MASK		(0x20 - 1)
 
 struct xt_physdev_info {
-	char physindev[IFNAMSIZ];
-	char in_mask[IFNAMSIZ];
-	char physoutdev[IFNAMSIZ];
-	char out_mask[IFNAMSIZ];
+	char physindev[16];
+	char in_mask[16];
+	char physoutdev[16];
+	char out_mask[16];
 	u_int8_t invert;
 	u_int8_t bitmask;
 };
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index 2010cb7..4f7c071 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -18,8 +18,8 @@ enum xt_rateest_match_mode {
 };
 
 struct xt_rateest_match_info {
-	char			name1[IFNAMSIZ];
-	char			name2[IFNAMSIZ];
+	char			name1[16];
+	char			name2[16];
 	u_int16_t		flags;
 	u_int16_t		mode;
 	u_int32_t		bps1;
diff --git a/include/linux/netfilter_ipv4/ipt_ULOG.h b/include/linux/netfilter_ipv4/ipt_ULOG.h
index 417aad2..4c0776f 100644
--- a/include/linux/netfilter_ipv4/ipt_ULOG.h
+++ b/include/linux/netfilter_ipv4/ipt_ULOG.h
@@ -37,8 +37,8 @@ typedef struct ulog_packet_msg {
 	long timestamp_sec;
 	long timestamp_usec;
 	unsigned int hook;
-	char indev_name[IFNAMSIZ];
-	char outdev_name[IFNAMSIZ];
+	char indev_name[16];
+	char outdev_name[16];
 	size_t data_len;
 	char prefix[ULOG_PREFIX_LEN];
 	unsigned char mac_len;

