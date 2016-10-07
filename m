From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 7/8] extensions: libxt_DSCP: add translation to nft
Date: Fri,  7 Oct 2016 19:08:55 +0800
Message-ID: <1475838536-28816-8-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59414 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752385AbcJGLKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:01 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

For example:
  # iptables-translate -A OUTPUT -j DSCP --set-dscp 1
  nft add rule ip filter OUTPUT counter ip dscp set 0x01

  # ip6tables-translate -A OUTPUT -j DSCP --set-dscp 6
  nft add rule ip6 filter OUTPUT counter ip6 dscp set 0x06

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_DSCP.c | 64 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index e16e93c..cae0d83 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -92,21 +92,59 @@ static void DSCP_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --set-dscp 0x%02x", dinfo->dscp);
 }
 
-static struct xtables_target dscp_target = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "DSCP",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
-	.help		= DSCP_help,
-	.print		= DSCP_print,
-	.save		= DSCP_save,
-	.x6_parse	= DSCP_parse,
-	.x6_fcheck	= DSCP_check,
-	.x6_options	= DSCP_opts,
+
+static int DSCP_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_tg_params *params)
+{
+	const struct xt_DSCP_info *dinfo =
+		(struct xt_DSCP_info *)params->target->data;
+
+	xt_xlate_add(xl, "ip dscp set 0x%02x", dinfo->dscp);
+	return 1;
+}
+
+static int DSCP_xlate6(struct xt_xlate *xl,
+		       const struct xt_xlate_tg_params *params)
+{
+	const struct xt_DSCP_info *dinfo =
+		(struct xt_DSCP_info *)params->target->data;
+
+	xt_xlate_add(xl, "ip6 dscp set 0x%02x", dinfo->dscp);
+	return 1;
+}
+
+static struct xtables_target dscp_target[] = {
+	{
+		.family		= NFPROTO_IPV4,
+		.name		= "DSCP",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+		.help		= DSCP_help,
+		.print		= DSCP_print,
+		.save		= DSCP_save,
+		.x6_parse	= DSCP_parse,
+		.x6_fcheck	= DSCP_check,
+		.x6_options	= DSCP_opts,
+		.xlate		= DSCP_xlate,
+	},
+	{
+		.family		= NFPROTO_IPV6,
+		.name		= "DSCP",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
+		.help		= DSCP_help,
+		.print		= DSCP_print,
+		.save		= DSCP_save,
+		.x6_parse	= DSCP_parse,
+		.x6_fcheck	= DSCP_check,
+		.x6_options	= DSCP_opts,
+		.xlate		= DSCP_xlate6,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&dscp_target);
+	xtables_register_targets(dscp_target, ARRAY_SIZE(dscp_target));
 }
-- 
2.5.5


