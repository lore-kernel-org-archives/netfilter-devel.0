From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_NFLOG: Add translation to nft
Date: Mon, 21 Dec 2015 23:05:59 +0530
Message-ID: <20151221173559.GA8787@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34066 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbLURgH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Dec 2015 12:36:07 -0500
Received: by mail-pa0-f52.google.com with SMTP id wq6so102680762pac.1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2015 09:36:06 -0800 (PST)
Received: from gmail.com ([106.218.39.42])
        by smtp.gmail.com with ESMTPSA id i72sm16884540pfj.64.2015.12.21.09.36.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 21 Dec 2015 09:36:04 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for NF Logging to nftables.

Examples:

$ sudo iptables-translate -A OUTPUT -j NFLOG --nflog-group 30
nft add rule ip filter OUTPUT counter log group 30

$ sudo iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" log group 32

$ sudo iptables-translate -I INPUT -j NFLOG --nflog-range 256
nft insert rule ip filter INPUT counter log snaplen 256

$ sudo iptables-translate -I INPUT -j NFLOG --nflog-threshold 25
nft insert rule ip filter INPUT counter log queue-threshold 25

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_NFLOG.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 448576a..3d05ce0 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -72,7 +72,7 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 }
 
 static void NFLOG_print(const void *ip, const struct xt_entry_target *target,
-                        int numeric)
+			int numeric)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
 
@@ -86,6 +86,31 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 	nflog_print(info, "--");
 }
 
+static void nflog_print_xlate(const struct xt_nflog_info *info,
+			      char *prefix, struct xt_buf *buf)
+{
+	if (info->prefix[0] != '\0')
+		xt_buf_add(buf, "%slog prefix \\\"%s\\\" ",
+			   prefix, info->prefix);
+	if (info->group)
+		xt_buf_add(buf, "%slog group %u ", prefix, info->group);
+	if (info->len)
+		xt_buf_add(buf, "%slog snaplen %u ", prefix, info->len);
+	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
+		xt_buf_add(buf, "%slog queue-threshold %u ",
+			   prefix, info->threshold);
+}
+
+static int NFLOG_xlate(const struct xt_entry_target *target,
+		       struct xt_buf *buf, int numeric)
+{
+	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
+
+	nflog_print_xlate(info, "", buf);
+
+	return 1;
+}
+
 static struct xtables_target nflog_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "NFLOG",
@@ -98,6 +123,7 @@ static struct xtables_target nflog_target = {
 	.print		= NFLOG_print,
 	.save		= NFLOG_save,
 	.x6_options	= NFLOG_opts,
+	.xlate		= NFLOG_xlate,
 };
 
 void _init(void)
-- 
1.9.1

