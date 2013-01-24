From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5/8] extensions: S/DNPT: add missing save function
Date: Thu, 24 Jan 2013 20:37:55 +0100
Message-ID: <1359056278-27618-6-git-send-email-jengelh@inai.de>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40474 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab3AXTiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:38:10 -0500
In-Reply-To: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jean-Michel DILLY reports that `ip6tables -S` exits with

	Target `DNPT' is missing save function

when a DNPT rule is invoked. Fix this omission.

References: http://marc.info/?l=netfilter&m=135904831220440&w=2
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libip6t_DNPT.c |   19 +++++++++++++++++++
 extensions/libip6t_SNPT.c |   19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/extensions/libip6t_DNPT.c b/extensions/libip6t_DNPT.c
index 7439816..703adf6 100644
--- a/extensions/libip6t_DNPT.c
+++ b/extensions/libip6t_DNPT.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <string.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_NPT.h>
@@ -53,6 +54,23 @@ static void DNPT_print(const void *ip, const struct xt_entry_target *target,
 				 npt->dst_pfx_len);
 }
 
+static void DNPT_save(const void *ip, const struct xt_entry_target *target)
+{
+	static const struct in6_addr zero_addr;
+	const struct ip6t_npt_tginfo *info = (const void *)target->data;
+
+	if (memcmp(&info->src_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
+	    info->src_pfx_len != 0)
+		printf("--src-pfx %s/%u ",
+		       xtables_ip6addr_to_numeric(&info->src_pfx.in6),
+		       info->src_pfx_len);
+	if (memcmp(&info->dst_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
+	    info->dst_pfx_len != 0)
+		printf("--dst-pfx %s/%u ",
+		       xtables_ip6addr_to_numeric(&info->dst_pfx.in6),
+		       info->dst_pfx_len);
+}
+
 static struct xtables_target snpt_tg_reg = {
 	.name		= "DNPT",
 	.version	= XTABLES_VERSION,
@@ -62,6 +80,7 @@ static struct xtables_target snpt_tg_reg = {
 	.help		= DNPT_help,
 	.x6_parse	= DNPT_parse,
 	.print		= DNPT_print,
+	.save		= DNPT_save,
 	.x6_options	= DNPT_options,
 };
 
diff --git a/extensions/libip6t_SNPT.c b/extensions/libip6t_SNPT.c
index 26a86c5..7ed80b2 100644
--- a/extensions/libip6t_SNPT.c
+++ b/extensions/libip6t_SNPT.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <string.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_NPT.h>
@@ -53,6 +54,23 @@ static void SNPT_print(const void *ip, const struct xt_entry_target *target,
 				 npt->dst_pfx_len);
 }
 
+static void SNPT_save(const void *ip, const struct xt_entry_target *target)
+{
+	static const struct in6_addr zero_addr;
+	const struct ip6t_npt_tginfo *info = (const void *)target->data;
+
+	if (memcmp(&info->src_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
+	    info->src_pfx_len != 0)
+		printf("--src-pfx %s/%u ",
+		       xtables_ip6addr_to_numeric(&info->src_pfx.in6),
+		       info->src_pfx_len);
+	if (memcmp(&info->dst_pfx.in6, &zero_addr, sizeof(zero_addr)) != 0 ||
+	    info->dst_pfx_len != 0)
+		printf("--dst-pfx %s/%u ",
+		       xtables_ip6addr_to_numeric(&info->dst_pfx.in6),
+		       info->dst_pfx_len);
+}
+
 static struct xtables_target snpt_tg_reg = {
 	.name		= "SNPT",
 	.version	= XTABLES_VERSION,
@@ -62,6 +80,7 @@ static struct xtables_target snpt_tg_reg = {
 	.help		= SNPT_help,
 	.x6_parse	= SNPT_parse,
 	.print		= SNPT_print,
+	.save		= SNPT_save,
 	.x6_options	= SNPT_options,
 };
 
-- 
1.7.10.4

