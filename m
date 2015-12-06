From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Sun, 6 Dec 2015 09:02:14 +0530
Message-ID: <20151206033214.GA5939@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33483 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbbLFDcX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 22:32:23 -0500
Received: by pfnn128 with SMTP id n128so46394293pfn.0
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Dec 2015 19:32:23 -0800 (PST)
Received: from gmail.com ([14.139.240.83])
        by smtp.gmail.com with ESMTPSA id u67sm25909689pfi.74.2015.12.05.19.32.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 05 Dec 2015 19:32:22 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation of the metainformation mark to nft.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Fix syntax according to nft and remove trailing whitespaces

 extensions/libxt_mark.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 7f8c995..b0c06c2 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -75,7 +75,7 @@ mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 	if (info->invert)
 		printf(" !");
-	
+
 	print_mark(info->mark, info->mask);
 }
 
@@ -97,11 +97,69 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 
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
+        if (mask != 0xffffffffU)
+                xt_buf_add(buf, " & x%x == x%x", mark, mask);
+        else
+                xt_buf_add(buf, " & x%x", mark);
+}
+
+static void
+mark_mt_xlate_print(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	if (info->invert)
+		xt_buf_add(buf, " !=");
+	print_mark_xlate(buf, info->mark, info->mask);
+}
+
+static int
+mark_mt_xlate(const struct xt_entry_match *match,
+	      struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	xt_buf_add(buf, "ct mark %s", info->invert ? " !=" : "");
+        print_mark_xlate(buf, info->mark, info->mask);
+        xt_buf_add(buf, " ");
+
+        return 1;
+}
+
+static void
+mark_xlate_print(const struct xt_entry_match *match,
+		 struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_info *info = (const void *)match->data;
+
+        if (info->invert)
+                xt_buf_add(buf, " !=");
+        print_mark_xlate(buf, info->mark, info->mask);
+}
+
+static int
+mark_xlate(const struct xt_entry_match *match,
+	   struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_info *info = (const void *)match->data;
+
+	xt_buf_add(buf, "ct mark %s", info->invert ? " !=" : "");
+	print_mark_xlate(buf, info->mark, info->mask);
+	xt_buf_add(buf, " ");
+
+	return 1;
+}
+
 static struct xtables_match mark_mt_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
@@ -115,6 +173,7 @@ static struct xtables_match mark_mt_reg[] = {
 		.save          = mark_save,
 		.x6_parse      = mark_parse,
 		.x6_options    = mark_mt_opts,
+		.xlate	       = mark_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -128,6 +187,7 @@ static struct xtables_match mark_mt_reg[] = {
 		.save          = mark_mt_save,
 		.x6_parse      = mark_mt_parse,
 		.x6_options    = mark_mt_opts,
+		.xlate         = mark_mt_xlate,
 	},
 };
 
-- 
1.9.1

