From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v3] extensions: libxt_mark: Add translation to nft
Date: Sat, 19 Dec 2015 12:46:31 +0530
Message-ID: <20151219071631.GA6338@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36657 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbLSHQi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 02:16:38 -0500
Received: by mail-pf0-f172.google.com with SMTP id o64so60407857pfb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 23:16:38 -0800 (PST)
Received: from gmail.com ([106.218.145.219])
        by smtp.gmail.com with ESMTPSA id n64sm21835676pfi.19.2015.12.18.23.16.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 18 Dec 2015 23:16:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for metainformation mark to nftables.

Examples:

$ sudo iptables-translate -I INPUT -m mark --mark 12
nft insert rule ip filter INPUT mark  & xc counter

$ sudo iptables-translate -A FORWARD -m mark --mark 22 -j ACCEPT
nft add rule ip filter FORWARD mark  & x16 counter accept

$ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m mark --mark 0x40
nft add rule ip mangle PREROUTING tcp dport 46000 mark  & x40 counter

$  sudo iptables-translate -A FORWARD -m mark -k 0x400/0x400 -j ACCEPT
nft add rule ip filter FORWARD mark  & x400 == x400 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v3:
	Fix indentation errors as shown by checkpatch
	Make commit message clearer by adding examples

 extensions/libxt_mark.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 7f8c995..5bef57d 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -75,7 +75,7 @@ mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 	if (info->invert)
 		printf(" !");
-	
+
 	print_mark(info->mark, info->mask);
 }
 
@@ -97,11 +97,67 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 
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
+		xt_buf_add(buf, " & x%x == x%x", mark, mask);
+	else
+		xt_buf_add(buf, " & x%x", mark);
+}
+
+static void
+mark_mt_print_xlate(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+
+	xt_buf_add(buf, "%s", info->invert ? " !=" : "");
+	print_mark_xlate(buf, info->mark, info->mask);
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
+static void
+mark_print_xlate(const struct xt_entry_match *match,
+		 struct xt_buf *buf, int numeric)
+{
+	const struct xt_mark_info *info = (const void *)match->data;
+
+	xt_buf_add(buf, "%s", info->invert ? " !=" : "");
+	print_mark_xlate(buf, info->mark, info->mask);
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
@@ -115,6 +171,7 @@ static struct xtables_match mark_mt_reg[] = {
 		.save          = mark_save,
 		.x6_parse      = mark_parse,
 		.x6_options    = mark_mt_opts,
+		.xlate	       = mark_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -128,6 +185,7 @@ static struct xtables_match mark_mt_reg[] = {
 		.save          = mark_mt_save,
 		.x6_parse      = mark_mt_parse,
 		.x6_options    = mark_mt_opts,
+		.xlate	       = mark_mt_xlate,
 	},
 };
 
-- 
1.9.1

