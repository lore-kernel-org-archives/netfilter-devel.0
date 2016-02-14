From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_tos: Add translation to nft
Date: Sun, 14 Feb 2016 19:55:00 +0530
Message-ID: <20160214142500.GA3397@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34767 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbcBNOZH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Feb 2016 09:25:07 -0500
Received: by mail-pa0-f49.google.com with SMTP id fy10so32323876pac.1
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Feb 2016 06:25:07 -0800 (PST)
Received: from gmail.com ([223.176.165.115])
        by smtp.gmail.com with ESMTPSA id xg9sm15801079pac.9.2016.02.14.06.25.04
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 14 Feb 2016 06:25:06 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for match tos to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m tos --tos 0x02  -j ACCEPT
nft add rule ip filter INPUT ip tos 0x02 counter accept

$ sudo iptables-translate -A INPUT -m tos --tos 0x02/0x04  -j ACCEPT
nft add rule ip filter INPUT ip tos and 0x02 == 0x04 counter accept

$ sudo iptables-translate -A INPUT -m tos ! --tos 0x02/0x04  -j ACCEPT
nft add rule ip filter INPUT ip tos and 0x02 != 0x04 counter accept

Details:
This patch was sent by Ana, Shivani modified it as per the current
nftables structure, applied it to the latest branch and tested it.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Ana Rey <anarey@gmail.com>
---
 extensions/libxt_tos.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 81c096f..577e9cb 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -121,6 +121,23 @@ static void tos_mt_save(const void *ip, const struct xt_entry_match *match)
 	printf(" --tos 0x%02x/0x%02x", info->tos_value, info->tos_mask);
 }
 
+static int tos_mt_xlate(const struct xt_entry_match *match,
+			struct xt_xlate *xl, int numeric)
+{
+	const struct xt_tos_match_info *info = (const void *)match->data;
+
+	xt_xlate_add(xl, "ip tos ");
+
+	if (info->tos_mask == 0xff)
+		xt_xlate_add(xl, "%s0x%02x ", info->invert ? "!= " : "",
+			     info->tos_value);
+	else
+		xt_xlate_add(xl, "and 0x%02x %s 0x%02x ", info->tos_value,
+			     info->invert ? "!=" : "==", info->tos_mask);
+
+	return 1;
+}
+
 static struct xtables_match tos_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -147,6 +164,7 @@ static struct xtables_match tos_mt_reg[] = {
 		.save          = tos_mt_save,
 		.x6_parse      = tos_mt_parse,
 		.x6_options    = tos_mt_opts,
+		.xlate	       = tos_mt_xlate,
 	},
 };
 
-- 
1.9.1

