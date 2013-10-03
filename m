From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH] lixtables: Fixes option issues in libxt_mangle.c
Date: Thu,  3 Oct 2013 14:28:05 +0300
Message-ID: <1380799685-11091-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25708 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab3JCL2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:28:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- use proper option IDs
- remove irrelevant flags on setting options mandatory

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 extensions/libxt_mangle.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/extensions/libxt_mangle.c b/extensions/libxt_mangle.c
index 822033c..4b20feb 100644
--- a/extensions/libxt_mangle.c
+++ b/extensions/libxt_mangle.c
@@ -33,22 +33,21 @@ static void mangle_help(void)
 	);
 }
 
-#define MANGLE_IPS    '1'
-#define MANGLE_IPT    '2'
-#define MANGLE_DEVS   '3'
-#define MANGLE_DEVT   '4'
-#define MANGLE_TARGET '5'
+enum {
+	MANGLE_IPS    = 0,
+	MANGLE_IPT    = 1,
+	MANGLE_DEVS   = 2,
+	MANGLE_DEVT   = 3,
+	MANGLE_TARGET = 4,
+};
+
 static const struct xt_option_entry mangle_opts[] = {
-	{ .name = "mangle-ip-s", .id = MANGLE_IPS, .type = XTTYPE_STRING,
-	  .flags = XTOPT_MAND },
-	{ .name = "mangle-ip-d", .id = MANGLE_IPT, .type = XTTYPE_STRING,
-	  .flags = XTOPT_MAND },
-	{ .name = "mangle-mac-s", .id = MANGLE_DEVS, .type = XTTYPE_STRING,
-	  .flags = XTOPT_MAND },
-	{ .name = "mangle-mac-d", .id = MANGLE_DEVT, .type = XTTYPE_STRING,
-	  .flags = XTOPT_MAND },
-	{ .name = "mangle-target", .id = MANGLE_TARGET, .type = XTTYPE_STRING,
-	  .flags = XTOPT_MAND },
+	{ .name = "mangle-ip-s", .id = MANGLE_IPS, .type = XTTYPE_STRING },
+	{ .name = "mangle-ip-d", .id = MANGLE_IPT, .type = XTTYPE_STRING },
+	{ .name = "mangle-mac-s", .id = MANGLE_DEVS, .type = XTTYPE_STRING },
+	{ .name = "mangle-mac-d", .id = MANGLE_DEVT, .type = XTTYPE_STRING },
+	{ .name = "mangle-target", .id = MANGLE_TARGET,
+	  .type = XTTYPE_STRING },
 	XTOPT_TABLEEND,
 };
 
-- 
1.8.3.2

