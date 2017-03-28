From: Gargi Sharma <gs051095@gmail.com>
Subject: [RFC] extensions: libxt_TOS: Add translation to nft
Date: Tue, 28 Mar 2017 21:16:12 +0530
Message-ID: <1490715972-30517-1-git-send-email-gs051095@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Gargi Sharma <gs051095@gmail.com>
To: gsoc2013@lists.netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33628 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751651AbdC1Pqb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 11:46:31 -0400
Received: by mail-pg0-f67.google.com with SMTP id 79so22322468pgf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 08:46:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for TOS to nftables.

Examples:

$ iptables-translate -t mangle -A PREROUTING -p TCP --dport 22 -j TOS --set-tos 0x10
nft add rule ip mangle PREROUTING tcp dport 22 counter --set-tos 0x10/0xff

$ iptables-translate -A PREROUTING -t mangle -p tcp --sport ftp-data -j TOS --set-tos 0x02/0x10
nft add rule ip mangle PREROUTING tcp sport 20 counter --set-tos 0x02/0x10

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/libxt_TOS.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index cef5876..408918b 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -183,6 +183,26 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --set-tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
 }
 
+static int tos_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params)
+{
+	const struct ipt_tos_target_info *info = 
+			(struct ipt_tos_target_info *) params->target->data;
+	xt_xlate_add(xl, " --set-tos 0x%02x", info->tos);
+
+	return 1;
+}
+
+static int tos_xlate6(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params)
+{
+	const struct xt_tos_target_info *info = 
+			(struct xt_tos_target_info *) params->target->data;
+	xt_xlate_add(xl, " --set-tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
+
+	return 1;
+}
+
 static struct xtables_target tos_tg_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -197,6 +217,7 @@ static struct xtables_target tos_tg_reg[] = {
 		.x6_parse      = tos_tg_parse_v0,
 		.x6_fcheck     = tos_tg_check,
 		.x6_options    = tos_tg_opts_v0,
+		.xlate	       = tos_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -211,6 +232,7 @@ static struct xtables_target tos_tg_reg[] = {
 		.x6_parse      = tos_tg_parse,
 		.x6_fcheck     = tos_tg_check,
 		.x6_options    = tos_tg_opts,
+		.xlate	       = tos_xlate6,
 	},
 };
 
-- 
2.7.4

