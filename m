From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/13] include: add cplusplus guards for extern
Date: Sat, 23 Oct 2010 07:44:48 +0200
Message-ID: <1287812691-14470-12-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55129 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0JWFpL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:11 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index d766183..b64306a 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -6,6 +6,10 @@
 #include <sys/socket.h> /* for sa_family_t */
 #include <linux/netlink.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * Netlink socket API
  */
@@ -156,4 +160,8 @@ extern int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 #define SOL_NETLINK	270
 #endif
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 #endif
-- 
1.7.1

