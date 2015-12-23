From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_helper: Add translation to nft
Date: Wed, 23 Dec 2015 15:23:47 +0530
Message-ID: <20151223095347.GA5866@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36721 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbbLWJxz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 04:53:55 -0500
Received: by mail-pf0-f170.google.com with SMTP id 65so5974396pff.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 01:53:54 -0800 (PST)
Received: from gmail.com ([106.203.193.102])
        by smtp.gmail.com with ESMTPSA id n26sm40530758pfb.39.2015.12.23.01.53.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 01:53:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for helper module to nftables.

Examples:

$ sudo iptables-translate -A FORWARD -m helper --helper sip
nft add rule ip filter FORWARD ct helper \"sip\" counter

$ sudo iptables-translate -A FORWARD -m helper ! --helper ftp
nft add rule ip filter FORWARD ct helper != \"ftp\" counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_helper.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index c9f9435..5f1d8b1 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -45,6 +45,19 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(info->name);
 }
 
+static int helper_xlate(const struct xt_entry_match *match,
+			struct xt_buf *buf, int numeric)
+{
+	const struct xt_helper_info *info = (const void *)match->data;
+
+	xt_buf_add(buf, "ct helper");
+
+	xt_buf_add(buf, "%s \\\"%s\\\" ",
+		   info->invert ? " !=" : "", info->name);
+
+	return 1;
+}
+
 static struct xtables_match helper_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "helper",
@@ -55,6 +68,7 @@ static struct xtables_match helper_match = {
 	.save		= helper_save,
 	.x6_parse	= helper_parse,
 	.x6_options	= helper_opts,
+	.xlate		= helper_xlate,
 };
 
 void _init(void)
-- 
1.9.1

