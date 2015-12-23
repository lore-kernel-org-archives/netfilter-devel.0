From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_MARK: Add translation to nft
Date: Wed, 23 Dec 2015 21:03:53 +0530
Message-ID: <20151223153353.GA17748@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35272 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbbLWPeA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 10:34:00 -0500
Received: by mail-pf0-f169.google.com with SMTP id 78so51621243pfw.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 07:34:00 -0800 (PST)
Received: from gmail.com ([223.176.130.107])
        by smtp.gmail.com with ESMTPSA id g88sm14079329pfj.91.2015.12.23.07.33.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 07:33:59 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target MARK to nftables.

Examples:

$ sudo iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 12
nft add rule ip mangle PREROUTING counter mark set 0xc

$ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 22 -j MARK --set-mark 2
nft add rule ip mangle PREROUTING tcp dport 22 counter mark set 0x2

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_MARK.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 556dbde..c5de763 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -242,7 +242,24 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_mark_tginfo2 *info = (const void *)target->data;
 
-	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
+	printf(" --set mark 0x%x/0x%x", info->mark, info->mask);
+}
+
+static void
+print_mark_xlate(unsigned long mark, struct xt_buf *buf)
+{
+	xt_buf_add(buf, " 0x%lx", mark);
+}
+
+static int mark_tg_xlate(const struct xt_entry_target *target,
+			  struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_tginfo2 *info = (const void *)target->data;
+
+	xt_buf_add(buf, "mark set");
+	print_mark_xlate(info->mark, buf);
+
+	return 1;
 }
 
 static struct xtables_target mark_tg_reg[] = {
@@ -259,6 +276,7 @@ static struct xtables_target mark_tg_reg[] = {
 		.x6_parse      = MARK_parse_v0,
 		.x6_fcheck     = MARK_check,
 		.x6_options    = MARK_opts,
+		.xlate	       = mark_tg_xlate,
 	},
 	{
 		.family        = NFPROTO_IPV4,
@@ -273,6 +291,7 @@ static struct xtables_target mark_tg_reg[] = {
 		.x6_parse      = MARK_parse_v1,
 		.x6_fcheck     = MARK_check,
 		.x6_options    = MARK_opts,
+		.xlate	       = mark_tg_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -287,6 +306,7 @@ static struct xtables_target mark_tg_reg[] = {
 		.x6_parse      = mark_tg_parse,
 		.x6_fcheck     = mark_tg_check,
 		.x6_options    = mark_tg_opts,
+		.xlate	       = mark_tg_xlate,
 	},
 };
 
-- 
1.9.1

