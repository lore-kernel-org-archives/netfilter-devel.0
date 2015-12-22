From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_mark: Fix inversion code
Date: Wed, 23 Dec 2015 02:51:37 +0530
Message-ID: <20151222212137.GA15975@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35638 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbbLVVVn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 16:21:43 -0500
Received: by mail-pf0-f195.google.com with SMTP id e65so1872644pfe.2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 13:21:43 -0800 (PST)
Received: from gmail.com ([223.176.190.114])
        by smtp.gmail.com with ESMTPSA id x10sm43171389pfa.14.2015.12.22.13.21.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 13:21:42 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the code associated with invert flag.

Examples:

$ sudo iptables-translate -I INPUT -p tcp -m mark ! --mark 0xa/0xa
nft insert rule ip filter INPUT ip protocol tcp mark and 0xa != 0xa counter

$ sudo iptables-translate -I INPUT -p tcp -m mark ! --mark 0x1
nft insert rule ip filter INPUT ip protocol tcp mark != 0x1 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_mark.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 3b96a34..3beccc8 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -1,5 +1,6 @@
 #include <stdbool.h>
 #include <stdio.h>
+#include <string.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_mark.h>
 
@@ -103,13 +104,14 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static void
-print_mark_xlate(struct xt_buf *buf,
-		 unsigned int mark, unsigned int mask)
+print_mark_xlate(struct xt_buf *buf, unsigned int mark,
+		 unsigned int mask, const char *str)
 {
 	if (mask != 0xffffffffU)
-		xt_buf_add(buf, " and 0x%x == 0x%x ", mark, mask);
+		xt_buf_add(buf, " and 0x%x %s 0x%x ", mark, str, mask);
 	else
-		xt_buf_add(buf, " 0x%x ", mark);
+		xt_buf_add(buf, " %s0x%x ",
+			   !strcmp(str, "==") ? "" : "!= ", mark);
 }
 
 static int
@@ -117,9 +119,13 @@ mark_mt_xlate(const struct xt_entry_match *match,
 	      struct xt_buf *buf, int numeric)
 {
 	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+	const char *str = "==";
 
-	xt_buf_add(buf, "mark%s", info->invert ? " !=" : "");
-	print_mark_xlate(buf, info->mark, info->mask);
+	if (info->invert)
+		str = "!=";
+
+	xt_buf_add(buf, "mark");
+	print_mark_xlate(buf, info->mark, info->mask, str);
 
 	return 1;
 }
@@ -129,9 +135,13 @@ mark_xlate(const struct xt_entry_match *match,
 	   struct xt_buf *buf, int numeric)
 {
 	const struct xt_mark_info *info = (const void *)match->data;
+	const char *str = "==";
+
+	if (info->invert)
+		str = "!=";
 
-	xt_buf_add(buf, "mark%s", info->invert ? " !=" : "");
-	print_mark_xlate(buf, info->mark, info->mask);
+	xt_buf_add(buf, "mark");
+	print_mark_xlate(buf, info->mark, info->mask, str);
 
 	return 1;
 }
-- 
1.9.1

