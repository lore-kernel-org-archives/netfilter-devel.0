From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_CLASSIFY: Add translation to nft
Date: Sun, 21 Aug 2016 22:34:55 +0800
Message-ID: <1471790095-29856-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:48700 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751549AbcHUOfs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2016 10:35:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

For examples:
  # iptables-translate -A OUTPUT -j CLASSIFY --set-class 0:0
  nft add rule ip filter OUTPUT counter meta priority set none
  # iptables-translate -A OUTPUT -j CLASSIFY --set-class ffff:ffff
  nft add rule ip filter OUTPUT counter meta priority set root
  # iptables-translate -A OUTPUT -j CLASSIFY --set-class 1:234
  nft add rule ip filter OUTPUT counter meta priority set 1:234

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_CLASSIFY.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index cd016d8..ba88f75 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -80,6 +80,31 @@ arpCLASSIFY_print(const void *ip, const struct xt_entry_target *target,
 	CLASSIFY_save(ip, target);
 }
 
+static int CLASSIFY_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_tg_params *params)
+{
+	const struct xt_classify_target_info *clinfo =
+		(const struct xt_classify_target_info *)params->target->data;
+	__u32 handle = clinfo->priority;
+
+	xt_xlate_add(xl, "meta priority set ");
+
+	switch (handle) {
+	case TC_H_ROOT:
+		xt_xlate_add(xl, "root");
+		break;
+	case TC_H_UNSPEC:
+		xt_xlate_add(xl, "none");
+		break;
+	default:
+		xt_xlate_add(xl, "%0x:%0x", TC_H_MAJ(handle) >> 16,
+			     TC_H_MIN(handle));
+		break;
+	}
+
+	return 1;
+}
+
 static struct xtables_target classify_target[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -92,6 +117,7 @@ static struct xtables_target classify_target[] = {
 		.save		= CLASSIFY_save,
 		.x6_parse	= CLASSIFY_parse,
 		.x6_options	= CLASSIFY_opts,
+		.xlate		= CLASSIFY_xlate,
 	},
 	{
 		.family		= NFPROTO_ARP,
@@ -103,6 +129,7 @@ static struct xtables_target classify_target[] = {
 		.print		= arpCLASSIFY_print,
 		.x6_parse	= CLASSIFY_parse,
 		.x6_options	= CLASSIFY_opts,
+		.xlate		= CLASSIFY_xlate,
 	},
 };
 
-- 
2.5.5


