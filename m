From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 2/2] extensions: libxt_comment: Add translation to nft
Date: Tue, 22 Dec 2015 15:48:34 +0530
Message-ID: <bfd658a271224fa7f3cbab52868300f3fbb1caa8.1450779140.git.shivanib134@gmail.com>
References: <cover.1450779140.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36280 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbbLVKSl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 05:18:41 -0500
Received: by mail-pa0-f42.google.com with SMTP id q3so94664784pav.3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 02:18:41 -0800 (PST)
Received: from gmail.com ([171.50.109.40])
        by smtp.gmail.com with ESMTPSA id dz6sm45018162pab.19.2015.12.22.02.18.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 02:18:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <cover.1450779140.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for comment module to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m comment --comment "random comment"
nft add rule ip filter INPUT counter comment \"random comment\"

$ sudo iptables-translate -A INPUT -i eth1 -m comment --comment "Local LAN"
nft add rule ip filter INPUT iifname eth1 counter comment \"Local LAN\"

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_comment.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 6ed2ff9..bbbd6cb 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -48,6 +48,18 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(commentinfo->comment);
 }
 
+static int
+comment_xlate(const struct xt_entry_match *match,
+	      struct xt_buf *buf, int numeric)
+{
+	struct xt_comment_info *commentinfo = (void *)match->data;
+
+	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
+	xt_buf_add(buf, "counter comment \\\"%s\\\" ", commentinfo->comment);
+
+	return 1;
+}
+
 static struct xtables_match comment_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "comment",
@@ -55,10 +67,11 @@ static struct xtables_match comment_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.help		= comment_help,
-	.print 		= comment_print,
-	.save 		= comment_save,
+	.print		= comment_print,
+	.save		= comment_save,
 	.x6_parse	= xtables_option_parse,
 	.x6_options	= comment_opts,
+	.xlate		= comment_xlate,
 };
 
 void _init(void)
-- 
1.9.1

