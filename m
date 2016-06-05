From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libxt_dscp: Add translation to nft
Date: Sun, 5 Jun 2016 19:57:23 +0200
Message-ID: <20160605175721.GA8239@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34377 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbcFER52 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2016 13:57:28 -0400
Received: by mail-wm0-f66.google.com with SMTP id n184so11236813wmn.1
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Jun 2016 10:57:27 -0700 (PDT)
Received: from sonyv (128.red-176-84-210.dynamicip.rima-tde.net. [176.84.210.128])
        by smtp.gmail.com with ESMTPSA id m5sm12829897wji.16.2016.06.05.10.57.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 05 Jun 2016 10:57:26 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for dscp to nftables, for both ipv4 and ipv6.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
nft add rule ip filter INPUT ip dscp 0x32 counter accept

$ sudo ip6tables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
nft add rule ip6 filter INPUT ip6 dscp != 0x32 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libxt_dscp.c | 92 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 02b22a4..4b88c5a 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -91,21 +91,87 @@ static void dscp_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s --dscp 0x%02x", dinfo->invert ? " !" : "", dinfo->dscp);
 }
 
-static struct xtables_match dscp_match = {
-	.family		= NFPROTO_UNSPEC,
-	.name 		= "dscp",
-	.version 	= XTABLES_VERSION,
-	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
-	.help		= dscp_help,
-	.print		= dscp_print,
-	.save		= dscp_save,
-	.x6_parse	= dscp_parse,
-	.x6_fcheck	= dscp_check,
-	.x6_options	= dscp_opts,
+static int __dscp_xlate(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct xt_dscp_info *dinfo =
+		(const struct xt_dscp_info *)match->data;
+
+	xt_xlate_add(xl, "dscp %s0x%02x ",
+		     dinfo->invert ? "!= " : "",
+		     dinfo->dscp);
+
+	return 1;
+}
+
+static int dscp_xlate(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	xt_xlate_add(xl, "ip ");
+
+	return __dscp_xlate(ip, match, xl, numeric);
+}
+
+static int dscp_xlate6(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	xt_xlate_add(xl, "ip6 ");
+
+	return __dscp_xlate(ip, match, xl, numeric);
+}
+
+static int dscp_xlate_uns(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	return 0;
+}
+
+static struct xtables_match dscp_mt_reg[] = {
+	{
+		.family		= NFPROTO_IPV4,
+		.name           = "dscp",
+		.version        = XTABLES_VERSION,
+		.size           = XT_ALIGN(sizeof(struct xt_dscp_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
+		.help		= dscp_help,
+		.print		= dscp_print,
+		.save		= dscp_save,
+		.x6_parse	= dscp_parse,
+		.x6_fcheck	= dscp_check,
+		.x6_options	= dscp_opts,
+		.xlate		= dscp_xlate,
+	},
+	{
+		.family		= NFPROTO_IPV6,
+		.name           = "dscp",
+		.version        = XTABLES_VERSION,
+		.size           = XT_ALIGN(sizeof(struct xt_dscp_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
+		.help		= dscp_help,
+		.print		= dscp_print,
+		.save		= dscp_save,
+		.x6_parse	= dscp_parse,
+		.x6_fcheck	= dscp_check,
+		.x6_options	= dscp_opts,
+		.xlate		= dscp_xlate6,
+	},
+	{
+		.family		= NFPROTO_UNSPEC,
+		.name           = "dscp",
+		.version        = XTABLES_VERSION,
+		.size           = XT_ALIGN(sizeof(struct xt_dscp_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
+		.help		= dscp_help,
+		.print		= dscp_print,
+		.save		= dscp_save,
+		.x6_parse	= dscp_parse,
+		.x6_fcheck	= dscp_check,
+		.x6_options	= dscp_opts,
+		.xlate		= dscp_xlate_uns,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&dscp_match);
+	xtables_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
 }
-- 
2.7.0

