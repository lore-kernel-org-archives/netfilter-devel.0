From: Gargi Sharma <gs051095@gmail.com>
Subject: [RFC v2] extensions: libxt_TOS: Add translation to nft
Date: Wed, 29 Mar 2017 00:20:18 +0530
Message-ID: <1490727018-25703-1-git-send-email-gs051095@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Gargi Sharma <gs051095@gmail.com>
To: gsoc2013@lists.netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35157 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753130AbdC1Su7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 14:50:59 -0400
Received: by mail-pg0-f65.google.com with SMTP id g2so23254379pge.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 11:50:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for TOS to nftables. TOS is deprecated
ans DSCP is ued in place of it. The first 6 bits of
TOS specify the DSCP value.

Examples:

$ iptables-translate -t mangle -A PREROUTING -p TCP --dport 22 -j TOS --set-tos 0x10
nft add rule ip mangle PREROUTING tcp dport 22 counter  ip6 dscp set 0x04

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
Changes in v2:
	- Added DSCP conversion.
---
 extensions/libxt_TOS.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index cef5876..f284d83 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -183,6 +183,30 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --set-tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
 }
 
+static int tos_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params)
+{
+	const struct ipt_tos_target_info *info =
+			(struct ipt_tos_target_info *) params->target->data;
+
+	__u8 dscp = (info->tos)>>2;
+	xt_xlate_add(xl, "ip dscp set 0x%02x", dscp);
+
+	return 1;
+}
+
+static int tos_xlate6(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params)
+{
+	const struct ipt_tos_target_info *info =
+			(struct ipt_tos_target_info *) params->target->data;
+
+	__u8 dscp = (info->tos)>>2;
+	xt_xlate_add(xl, " ip6 dscp set 0x%02x", dscp);
+
+	return 1;
+}
+
 static struct xtables_target tos_tg_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -197,6 +221,7 @@ static struct xtables_target tos_tg_reg[] = {
 		.x6_parse      = tos_tg_parse_v0,
 		.x6_fcheck     = tos_tg_check,
 		.x6_options    = tos_tg_opts_v0,
+		.xlate	       = tos_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -211,6 +236,7 @@ static struct xtables_target tos_tg_reg[] = {
 		.x6_parse      = tos_tg_parse,
 		.x6_fcheck     = tos_tg_check,
 		.x6_options    = tos_tg_opts,
+		.xlate	       = tos_xlate6,
 	},
 };
 
-- 
2.7.4

