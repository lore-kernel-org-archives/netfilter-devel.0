From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v3] extensions: libxt_connmark: Add translation to nft
Date: Wed, 23 Dec 2015 02:36:26 +0530
Message-ID: <20151222210626.GA15195@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33205 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897AbbLVVGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 16:06:33 -0500
Received: by mail-pa0-f65.google.com with SMTP id uo6so992987pac.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 13:06:32 -0800 (PST)
Received: from gmail.com ([223.176.190.114])
        by smtp.gmail.com with ESMTPSA id 73sm43148846pfa.3.2015.12.22.13.06.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 13:06:31 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for connmark to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m connmark --mark 2 -j ACCEPT
nft add rule ip filter INPUT ct mark 0x2 counter accept

$ sudo iptables-translate -A INPUT -m connmark ! --mark 2 -j ACCEPT
nft add rule ip filter INPUT ct mark != 0x2 counter accept

$ sudo iptables-translate -A INPUT -m connmark --mark 10/10 -j ACCEPT
nft add rule ip filter INPUT ct mark and 0xa == 0xa counter accept

$ sudo iptables-translate -A INPUT -m connmark ! --mark 10/10 -j ACCEPT
nft add rule ip filter INPUT ct mark and 0xa != 0xa counter accept

$ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 40 -m connmark --mark 0x40
nft add rule ip mangle PREROUTING tcp dport 40 ct mark 0x40 counter

Signed-off-by : Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v3:
	Fix the code for inversion of mark only

 extensions/libxt_connmark.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 95477de..6f82b65 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -22,6 +22,7 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
+#include <string.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_connmark.h>
 
@@ -89,7 +90,8 @@ connmark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 }
 
 static void
-connmark_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
+connmark_mt_print(const void *ip, const struct xt_entry_match *match,
+		  int numeric)
 {
 	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
 
@@ -122,6 +124,47 @@ connmark_mt_save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask);
 }
 
+static void print_mark_xlate(unsigned int mark, unsigned int mask,
+			     struct xt_buf *buf, const char *str)
+{
+	if (mask != 0xffffffffU)
+		xt_buf_add(buf, " and 0x%x %s 0x%x ", mark, str, mask);
+	else
+		xt_buf_add(buf, " %s0x%x ",
+			   !strcmp(str, "==") ? "" : "!= ", mark);
+}
+
+static int connmark_xlate(const struct xt_entry_match *match,
+			  struct xt_buf *buf, int numeric)
+{
+	const struct xt_connmark_info *info = (const void *)match->data;
+	const char *str = "==";
+
+	if (info->invert)
+		str = "!=";
+
+	xt_buf_add(buf, "ct mark");
+	print_mark_xlate(info->mark, info->mask, buf, str);
+
+	return 1;
+}
+
+static int
+connmark_mt_xlate(const struct xt_entry_match *match,
+		 struct xt_buf *buf, int numeric)
+{
+	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
+	const char *str = "==";
+
+	if (info->invert)
+		str = "!=";
+
+	xt_buf_add(buf, "ct mark");
+	print_mark_xlate(info->mark, info->mask, buf, str);
+
+	return 1;
+}
+
 static struct xtables_match connmark_mt_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
@@ -135,6 +178,7 @@ static struct xtables_match connmark_mt_reg[] = {
 		.save          = connmark_save,
 		.x6_parse      = connmark_parse,
 		.x6_options    = connmark_mt_opts,
+		.xlate	       = connmark_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -148,6 +192,7 @@ static struct xtables_match connmark_mt_reg[] = {
 		.save          = connmark_mt_save,
 		.x6_parse      = connmark_mt_parse,
 		.x6_options    = connmark_mt_opts,
+		.xlate	       = connmark_mt_xlate,
 	},
 };
 
-- 
1.9.1

