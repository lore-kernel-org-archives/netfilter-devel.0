From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_length: Add translation to nft
Date: Tue, 29 Dec 2015 23:54:25 +0530
Message-ID: <20151229182425.GA7400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:32987 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbL2SYc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 13:24:32 -0500
Received: by mail-pf0-f175.google.com with SMTP id q63so94625578pfb.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Dec 2015 10:24:32 -0800 (PST)
Received: from gmail.com ([106.204.198.143])
        by smtp.gmail.com with ESMTPSA id 3sm40339649pfn.61.2015.12.29.10.24.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 29 Dec 2015 10:24:30 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module length to nftables.

Examples:

$ sudo iptables-translate -A INPUT -p icmp -m length --length 86:0xffff -j DROP
nft add rule ip filter INPUT ip protocol icmp meta length 86-65535 counter drop

$ sudo iptables-translate -A INPUT -p udp -m length --length :400
nft add rule ip filter INPUT ip protocol udp meta length 0-400 counter

$ sudo iptables-translate -A INPUT -p udp -m length --length 40
nft add rule ip filter INPUT ip protocol udp meta length 40 counter

$ sudo iptables-translate -A INPUT -p udp -m length ! --length 40
nft add rule ip filter INPUT ip protocol udp meta length != 40 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Remove unneeded space character

 extensions/libxt_length.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 6ea7646..96dab0c 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -56,6 +56,21 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 		printf("%u:%u", info->min, info->max);
 }
 
+static int length_xlate(const struct xt_entry_match *match,
+			struct xt_buf *buf, int numeric)
+{
+	const struct xt_length_info *info = (void *)match->data;
+
+	xt_buf_add(buf, "meta length %s", info->invert ? "!= " : "");
+	if (info->min == info->max)
+		xt_buf_add(buf, "%u ", info->min);
+	else
+		xt_buf_add(buf, "%u-%u ", info->min, info->max);
+
+	return 1;
+}
+
+
 static struct xtables_match length_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "length",
@@ -67,6 +82,7 @@ static struct xtables_match length_match = {
 	.save		= length_save,
 	.x6_parse	= length_parse,
 	.x6_options	= length_opts,
+	.xlate		= length_xlate,
 };
 
 void _init(void)
-- 
1.9.1

