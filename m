From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 2/2] extensions: libxt_dccp/libxt_sctp: enable debug tracing by
 DEBUG define
Date: Thu, 04 Jul 2013 11:26:18 +0400
Message-ID: <1372922778-12997-3-git-send-email-a.perevalov@samsung.com>
References: <1372922778-12997-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63513 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3GDH0j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:26:39 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPE0083FI00UT00@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 04 Jul 2013 08:26:37 +0100 (BST)
In-reply-to: <1372922778-12997-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 extensions/libxt_dccp.c |    4 ++--
 extensions/libxt_sctp.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index a35cabb..06cd23d 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -16,11 +16,11 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_dccp.h>
 
-#if 0
+#ifdef DEBUG
 #define DEBUGP(format, first...) printf(format, ##first)
 #define static
 #else
-#define DEBUGP(format, fist...) 
+#define DEBUGP(format, fist...)
 #endif
 
 enum {
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 56a4cdf..f5959cb 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -20,11 +20,11 @@
 
 #include <linux/netfilter/xt_sctp.h>
 
-#if 0
+#if DEBUG
 #define DEBUGP(format, first...) printf(format, ##first)
 #define static
 #else
-#define DEBUGP(format, fist...) 
+#define DEBUGP(format, fist...)
 #endif
 
 static void
-- 
1.7.9.5

