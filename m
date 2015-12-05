From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_mark: Add translation to nft
Date: Sat,  5 Dec 2015 18:49:36 +0530
Message-ID: <1449321576-20705-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36707 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbLENb6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 08:31:58 -0500
Received: by pfbc17 with SMTP id c17so3049932pfb.3
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Dec 2015 05:31:57 -0800 (PST)
Received: from shivani.smvdu.ac.in ([14.139.240.83])
        by smtp.googlemail.com with ESMTPSA id ix2sm23446053pac.15.2015.12.05.05.19.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 05 Dec 2015 05:19:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation of the metainformation mark to nft.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_mark.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 7f8c995..5105bf9 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -102,6 +102,64 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 	print_mark(info->mark, info->mask);
 }
 
+static void
+print_mark_xlate(struct xt_buf *buf,
+		 unsigned int mark, unsigned int mask)
+{
+        if (mask != 0xffffffffU)
+                xt_buf_add(buf, " 0x%x/0x%x", mark, mask);
+        else
+                xt_buf_add(buf, " 0x%x", mark);
+}
+
+static void
+mark_mt_xlate_print(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	if (info->invert)      
+		xt_buf_add(buf, " !");
+	print_mark_xlate(buf, info->mark, info->mask);
+}
+
+static int
+mark_mt_xlate(const struct xt_entry_match *match,
+	      struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+        xt_buf_add(buf, "ct mark %s", info->invert ? " !" : "");
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
+       const struct xt_mark_info *info = (const void *)match->data;
+
+        if (info->invert)
+                xt_buf_add(buf, " !");
+        print_mark_xlate(buf, info->mark, info->mask);
+}
+
+static int
+mark_xlate(const struct xt_entry_match *match,
+	   struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_info *info = (const void *)match->data;
+
+	xt_buf_add(buf, "ct mark %s", info->invert ? " !" : "");
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

