From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/4] psd: move defines to user/kernelspace part where possible
Date: Thu, 14 Jun 2012 22:13:34 +0200
Message-ID: <1339704814-1605-5-git-send-email-fw@strlen.de>
References: <1339704814-1605-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41697 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab2FNUOz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:14:55 -0400
In-Reply-To: <1339704814-1605-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some of these defines have no meaning in userspace, so there
is no need to make those available.
---
 extensions/libxt_psd.c |    2 ++
 extensions/xt_psd.c    |    9 +++++++++
 extensions/xt_psd.h    |   11 -----------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/extensions/libxt_psd.c b/extensions/libxt_psd.c
index 483c69a..bd03480 100644
--- a/extensions/libxt_psd.c
+++ b/extensions/libxt_psd.c
@@ -30,6 +30,8 @@
 #include "xt_psd.h"
 #include "compat_user.h"
 
+#define SCAN_DELAY_THRESHOLD		300
+
 /* Function which prints out usage message. */
 static void psd_mt_help(void) {
 	printf(
diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 00ff1d4..f459605 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -40,6 +40,15 @@ MODULE_AUTHOR(" Mohd Nawawi Mohamad Jamili <nawawi@tracenetworkcorporation.com>"
 MODULE_DESCRIPTION("Xtables: PSD - portscan detection");
 MODULE_ALIAS("ipt_psd");
 
+/*
+ * Keep track of up to LIST_SIZE source addresses, using a hash table of
+ * HASH_SIZE entries for faster lookups, but limiting hash collisions to
+ * HASH_MAX source addresses per the same hash value.
+ */
+#define LIST_SIZE			0x100
+#define HASH_LOG			9
+#define HASH_SIZE			(1 << HASH_LOG)
+#define HASH_MAX			0x10
 
 /*
  * Information we keep per each target port
diff --git a/extensions/xt_psd.h b/extensions/xt_psd.h
index ac65687..89b48fe 100644
--- a/extensions/xt_psd.h
+++ b/extensions/xt_psd.h
@@ -19,17 +19,6 @@
 #define SCAN_MIN_COUNT			7
 #define SCAN_MAX_COUNT			(SCAN_MIN_COUNT * PORT_WEIGHT_PRIV)
 #define SCAN_WEIGHT_THRESHOLD		SCAN_MAX_COUNT
-#define SCAN_DELAY_THRESHOLD		(300) /* old usage of HZ here was erroneously and broke under uml */
-
-/*
- * Keep track of up to LIST_SIZE source addresses, using a hash table of
- * HASH_SIZE entries for faster lookups, but limiting hash collisions to
- * HASH_MAX source addresses per the same hash value.
- */
-#define LIST_SIZE			0x100
-#define HASH_LOG			9
-#define HASH_SIZE			(1 << HASH_LOG)
-#define HASH_MAX			0x10
 
 struct xt_psd_info {
 	__u32 weight_threshold;
-- 
1.7.3.4

