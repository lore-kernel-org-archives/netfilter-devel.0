From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v4] extensions: libxt_mark: Add translation to nft
Date: Sun, 20 Dec 2015 08:44:12 +0530
Message-ID: <20151220031412.GA8273@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36381 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbbLTDOT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 22:14:19 -0500
Received: by mail-pf0-f194.google.com with SMTP id n128so7407247pfn.3
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 19:14:19 -0800 (PST)
Received: from gmail.com ([223.176.166.180])
        by smtp.gmail.com with ESMTPSA id xz6sm30735148pab.42.2015.12.19.19.14.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 19 Dec 2015 19:14:18 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for metainformation mark to nftables.

Examples:

$ sudo iptables-translate -I INPUT -m mark --mark 12
nft insert rule ip filter INPUT mark  0xc counter

$ sudo iptables-translate -A FORWARD -m mark --mark 22 -j ACCEPT
nft add rule ip filter FORWARD mark  0x16 counter accept

$ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 4600 -m mark --mark 0x40
nft add rule ip mangle PREROUTING tcp dport 4600 mark  0x40 counter

$ sudo iptables-translate -A FORWARD -m mark --mark 0x400/0x400 -j ACCEPT
nft add rule ip filter FORWARD mark  and 0x400 == 0x400 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v4:
	Fix indentation errors shown by checkpatch
	Add tested and verified examples in commit message

 extensions/libxt_mark.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 7f8c995..4eb5ef8 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -75,7 +75,7 @@ mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 	if (info->invert)
 		printf(" !");
-	
+
 	print_mark(info->mark, info->mask);
 }
 
@@ -97,11 +97,47 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 
 	if (info->invert)
 		printf(" !");
-	
+
 	printf(" --mark");
 	print_mark(info->mark, info->mask);
 }
 
+static void
+print_mark_xlate(struct xt_buf *buf,
+		 unsigned int mark, unsigned int mask)
+{
+	if (mask != 0xffffffffU)
+		xt_buf_add(buf, " and 0x%x == 0x%x", mark, mask);
+	else
+		xt_buf_add(buf, " 0x%x", mark);
+}
+
+static int
+mark_mt_xlate(const struct xt_entry_match *match,
+	      struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	xt_buf_add(buf, "mark %s", info->invert ? " !=" : "");
+	print_mark_xlate(buf, info->mark, info->mask);
+	xt_buf_add(buf, " ");
+
+	return 1;
+}
+
+static int
+mark_xlate(const struct xt_entry_match *match,
+	   struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_info *info = (const void *)match->data;
+
+	xt_buf_add(buf, "mark %s", info->invert ? " !=" : "");
+	print_mark_xlate(buf, info->mark, info->mask);
+	xt_buf_add(buf, " ");
+
+	return 1;
+}
+
 static struct xtables_match mark_mt_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
@@ -115,6 +151,7 @@ static struct xtables_match mark_mt_reg[] = {
 		.save          = mark_save,
 		.x6_parse      = mark_parse,
 		.x6_options    = mark_mt_opts,
+		.xlate	       = mark_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -128,6 +165,7 @@ static struct xtables_match mark_mt_reg[] = {
 		.save          = mark_mt_save,
 		.x6_parse      = mark_mt_parse,
 		.x6_options    = mark_mt_opts,
+		.xlate	       = mark_mt_xlate,
 	},
 };
 
-- 
1.9.1

