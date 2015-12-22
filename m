From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_connmark: Add translation to nft
Date: Tue, 22 Dec 2015 16:25:47 +0530
Message-ID: <20151222105547.GA5130@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35860 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbbLVKzx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 05:55:53 -0500
Received: by mail-pa0-f53.google.com with SMTP id q3so95114343pav.3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 02:55:53 -0800 (PST)
Received: from gmail.com ([171.50.109.40])
        by smtp.gmail.com with ESMTPSA id sg4sm45215305pac.48.2015.12.22.02.55.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 02:55:52 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for connmark to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m connmark --mark 1
nft add rule ip filter INPUT ct mark 0x1 counter

$ sudo iptables-translate -A INPUT -m connmark --mark 10/10 -j ACCEPT
nft add rule ip filter INPUT ct mark and 0xa == 0xa counter accept

$ sudo  sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 40 -m connmark --mark 0x40
nft add rule ip mangle PREROUTING tcp dport 40 ct mark 0x40 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_connmark.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 95477de..1865dcb 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -89,7 +89,8 @@ connmark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 }
 
 static void
-connmark_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
+connmark_mt_print(const void *ip, const struct xt_entry_match *match,
+		  int numeric)
 {
 	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
 
@@ -122,6 +123,46 @@ connmark_mt_save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask);
 }
 
+static void
+print_mark_xlate(unsigned int mark, unsigned int mask,
+	   struct xt_buf *buf)
+{
+	if (mask != 0xffffffffU)
+		xt_buf_add(buf, " and 0x%x == 0x%x ", mark, mask);
+	else
+		xt_buf_add(buf, " 0x%x ", mark);
+}
+
+static int
+connmark_xlate(const struct xt_entry_match *match,
+	       struct xt_buf *buf, int numeric)
+{
+	const struct xt_connmark_info *info = (const void *)match->data;
+
+	if (info->invert)
+		xt_buf_add(buf, " !=");
+
+	xt_buf_add(buf, "ct mark");
+	print_mark_xlate(info->mark, info->mask, buf);
+
+	return 1;
+}
+
+static int
+connmark_mt_xlate(const struct xt_entry_match *match,
+		  struct xt_buf *buf, int numeric)
+{
+	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
+
+	if (info->invert)
+		xt_buf_add(buf, " !=");
+
+	xt_buf_add(buf, "ct mark");
+	print_mark_xlate(info->mark, info->mask, buf);
+
+	return 1;
+}
+
 static struct xtables_match connmark_mt_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
@@ -135,6 +176,7 @@ static struct xtables_match connmark_mt_reg[] = {
 		.save          = connmark_save,
 		.x6_parse      = connmark_parse,
 		.x6_options    = connmark_mt_opts,
+		.xlate	       = connmark_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -148,6 +190,7 @@ static struct xtables_match connmark_mt_reg[] = {
 		.save          = connmark_mt_save,
 		.x6_parse      = connmark_mt_parse,
 		.x6_options    = connmark_mt_opts,
+		.xlate	       = connmark_mt_xlate,
 	},
 };
 
-- 
1.9.1

