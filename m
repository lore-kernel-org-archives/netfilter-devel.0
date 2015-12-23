From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_mark: Fix inversion code
Date: Wed, 23 Dec 2015 19:43:19 +0530
Message-ID: <20151223141318.GA15560@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36025 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbbLWON0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 09:13:26 -0500
Received: by mail-pf0-f169.google.com with SMTP id 65so8924414pff.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 06:13:25 -0800 (PST)
Received: from gmail.com ([223.176.140.7])
        by smtp.gmail.com with ESMTPSA id n3sm48360586pfa.79.2015.12.23.06.13.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 06:13:24 -0800 (PST)
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
Changes in v2:
	Replace string with enum to make code look better

 extensions/libxt_mark.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 3b96a34..93d38d9 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -103,13 +103,15 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static void
-print_mark_xlate(struct xt_buf *buf,
-		 unsigned int mark, unsigned int mask)
+print_mark_xlate(struct xt_buf *buf, unsigned int mark,
+		 unsigned int mask, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_buf_add(buf, " and 0x%x == 0x%x ", mark, mask);
+		xt_buf_add(buf, " and 0x%x %s 0x%x ", mark,
+			   op == XT_OP_EQ ? "==" : "!=", mask);
 	else
-		xt_buf_add(buf, " 0x%x ", mark);
+		xt_buf_add(buf, " %s0x%x ",
+			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
 static int
@@ -117,9 +119,13 @@ mark_mt_xlate(const struct xt_entry_match *match,
 	      struct xt_buf *buf, int numeric)
 {
 	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+	enum xt_op op = XT_OP_EQ;
 
-	xt_buf_add(buf, "mark%s", info->invert ? " !=" : "");
-	print_mark_xlate(buf, info->mark, info->mask);
+	if (info->invert)
+		op = XT_OP_NEQ;
+
+	xt_buf_add(buf, "mark");
+	print_mark_xlate(buf, info->mark, info->mask, op);
 
 	return 1;
 }
@@ -129,9 +135,13 @@ mark_xlate(const struct xt_entry_match *match,
 	   struct xt_buf *buf, int numeric)
 {
 	const struct xt_mark_info *info = (const void *)match->data;
+	enum xt_op op = XT_OP_EQ;
+
+	if (info->invert)
+		op = XT_OP_NEQ;
 
-	xt_buf_add(buf, "mark%s", info->invert ? " !=" : "");
-	print_mark_xlate(buf, info->mark, info->mask);
+	xt_buf_add(buf, "mark");
+	print_mark_xlate(buf, info->mark, info->mask, op);
 
 	return 1;
 }
-- 
1.9.1

