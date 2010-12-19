From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/11] xt_set: avoid user types in exported kernel headers
Date: Sun, 19 Dec 2010 06:18:04 +0100
Message-ID: <1292735894-17534-3-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42660 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab0LSFSR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:17 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Within isolated code it would be ok, but not so in exported headers.
---
 kernel/include/linux/netfilter/xt_set.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/include/linux/netfilter/xt_set.h b/kernel/include/linux/netfilter/xt_set.h
index c6084df..69b2bd1 100644
--- a/kernel/include/linux/netfilter/xt_set.h
+++ b/kernel/include/linux/netfilter/xt_set.h
@@ -15,11 +15,11 @@
 struct xt_set_info_v0 {
 	ip_set_id_t index;
 	union {
-		u_int32_t flags[IPSET_DIM_MAX + 1];
+		__u32 flags[IPSET_DIM_MAX + 1];
 		struct {
-			u_int32_t __flags[IPSET_DIM_MAX];
-			u_int8_t dim;
-			u_int8_t flags;
+			__u32 __flags[IPSET_DIM_MAX];
+			__u8 dim;
+			__u8 flags;
 		} compat;
 	} u;
 };
@@ -38,8 +38,8 @@ struct xt_set_info_target_v0 {
 
 struct xt_set_info {
 	ip_set_id_t index;
-	u_int8_t dim;
-	u_int8_t flags;
+	__u8 dim;
+	__u8 flags;
 };
 
 /* match and target infos */
-- 
1.7.1

