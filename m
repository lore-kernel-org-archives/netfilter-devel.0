From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Tue, 1 Mar 2016 21:40:45 +0100
Message-ID: <20160301204042.GA15382@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, fw@strlen.de, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33408 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbcCAUku (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 15:40:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id n186so6153575wmn.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 12:40:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for random mode to nftables. The nth mode is not
supported yet.

Examples:

$ iptables-translate -A INPUT -m statistic --mode random --probability
0.1 -j ACCEPT
nft add rule ip filter INPUT meta random 0.10000000009 counter accept

$ iptables-translate -A INPUT -m statistic --mode random ! --probability
0.1 -j ACCEPT
nft add rule ip filter INPUT meta random != 0.10000000009 counter accept

The .xlate indirection returns 0 if the translation is not available.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
	- Return 0 if the translation is not supported, as Pablo suggested.
	- Include not supported modes in the commit message, as Shivani suggested.
Changes in v3:
	- Fix wrong email format.

 extensions/libxt_statistic.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index b6ae5f5..c771363 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -133,6 +133,22 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
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
+	} else {
+		return 0;
+	}
+
+	return 1;
+}
+
 static struct xtables_match statistic_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "statistic",
@@ -145,6 +161,7 @@ static struct xtables_match statistic_match = {
 	.print		= statistic_print,
 	.save		= statistic_save,
 	.x6_options	= statistic_opts,
+	.xlate		= statistic_xlate,
 };
 
 void _init(void)
-- 
2.7.0

