From: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] libxt_TCPMSS.c: unbreak build without ipv6 after ea2a02f7
Date: Fri, 22 Jul 2011 07:24:20 +0200
Message-ID: <1311312260-16102-1-git-send-email-jacmet@sunsite.dk>
Cc: Peter Korsgaard <jacmet@sunsite.dk>
To: netfilter-devel@vger.kernel.org, jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1GVFYb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2011 01:24:31 -0400
Received: by wyg8 with SMTP id 8so1264820wyg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2011 22:24:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ea2a02f7 (libxt_TCPMSS: use guided option parser) added an netinet/ip6.h
include, which is not available on systems without ipv6.

The ip.h / ipv6.h includes are only used to know the size of struct
iphdr / ip6_hdr, so simply hardcode those instead.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 extensions/libxt_TCPMSS.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 2266326..310dd17 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -4,8 +4,6 @@
 */
 #include <stdio.h>
 #include <xtables.h>
-#include <netinet/ip.h>
-#include <netinet/ip6.h>
 #include <linux/netfilter/xt_TCPMSS.h>
 
 enum {
@@ -13,6 +11,9 @@ enum {
 	O_CLAMP_MSS,
 };
 
+#define IPHDRSIZE	20	/* sizeof(struct iphdr) */
+#define IP6HDRSIZE	40	/* sizeof(struct ip6_hdr) */
+
 struct mssinfo {
 	struct xt_entry_target t;
 	struct xt_tcpmss_info mss;
@@ -29,17 +30,17 @@ hdrsize);
 
 static void TCPMSS_help(void)
 {
-	__TCPMSS_help(sizeof(struct iphdr));
+	__TCPMSS_help(IPHDRSIZE);
 }
 
 static void TCPMSS_help6(void)
 {
-	__TCPMSS_help(sizeof(struct ip6_hdr));
+	__TCPMSS_help(IP6HDRSIZE);
 }
 
 static const struct xt_option_entry TCPMSS4_opts[] = {
 	{.name = "set-mss", .id = O_SET_MSS, .type = XTTYPE_UINT16,
-	 .min = 0, .max = UINT16_MAX - sizeof(struct iphdr),
+	 .min = 0, .max = UINT16_MAX - IPHDRSIZE,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_tcpmss_info, mss)},
 	{.name = "clamp-mss-to-pmtu", .id = O_CLAMP_MSS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
@@ -47,7 +48,7 @@ static const struct xt_option_entry TCPMSS4_opts[] = {
 
 static const struct xt_option_entry TCPMSS6_opts[] = {
 	{.name = "set-mss", .id = O_SET_MSS, .type = XTTYPE_UINT16,
-	 .min = 0, .max = UINT16_MAX - sizeof(struct ip6_hdr),
+	 .min = 0, .max = UINT16_MAX - IP6HDRSIZE,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(struct xt_tcpmss_info, mss)},
 	{.name = "clamp-mss-to-pmtu", .id = O_CLAMP_MSS, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
-- 
1.7.5.4

