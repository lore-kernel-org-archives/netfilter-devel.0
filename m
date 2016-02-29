From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libxt_statistic: Add translation to nft
Date: Mon, 29 Feb 2016 22:22:20 +0100
Message-ID: <20160229212216.GA29706@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38678 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbcB2VWY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 16:22:24 -0500
Received: by mail-wm0-f52.google.com with SMTP id l68so7518697wml.1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:22:23 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for random to nftables.

Examples:

$ iptables-translate -A INPUT -m statistic --mode random --probability
0.1 -j ACCEPT
nft add rule ip filter INPUT meta random 0.10000000009 counter accept

$ iptables-translate -A INPUT -m statistic --mode random ! --probability
0.1 -j ACCEPT
nft add rule ip filter INPUT meta random != 0.10000000009 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libxt_statistic.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index b6ae5f5..95d588c 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -133,6 +133,20 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
 	print_match(info, "--");
 }
 
+static int statistic_xlate(const struct xt_entry_match *match,
+			   struct xt_xlate *xl, int numeric)
+{
+	const struct xt_statistic_info *info = (void *)match->data;
+
+	if (info->mode == XT_STATISTIC_MODE_RANDOM) {
+		xt_xlate_add(xl, "meta random%s %.11f ",
+			     (info->flags & XT_STATISTIC_INVERT) ? " !=" : "",
+			     1.0 * info->u.random.probability / 0x80000000);
+	}
+
+	return 1;
+}
+
 static struct xtables_match statistic_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "statistic",
@@ -145,6 +159,7 @@ static struct xtables_match statistic_match = {
 	.print		= statistic_print,
 	.save		= statistic_save,
 	.x6_options	= statistic_opts,
+	.xlate		= statistic_xlate,
 };
 
 void _init(void)
-- 
2.7.0

