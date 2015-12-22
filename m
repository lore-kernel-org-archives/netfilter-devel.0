From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_NFLOG: Add group_info and remove multiple
 keywords
Date: Wed, 23 Dec 2015 01:32:46 +0530
Message-ID: <20151222200246.GA11677@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34867 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbbLVUCx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 15:02:53 -0500
Received: by mail-pf0-f194.google.com with SMTP id e65so1777127pfe.2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 12:02:53 -0800 (PST)
Received: from gmail.com ([223.176.190.114])
        by smtp.gmail.com with ESMTPSA id p83sm43020228pfi.96.2015.12.22.12.02.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 12:02:52 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add group_info with every rule as it is mandatory to consider logging to
be same type as NFLOG.
Remove multiple log keywords to avoid loading multiple log expressions
at a time.

Examples:

$ sudo iptables-translate -I INPUT -j NFLOG --nflog-threshold 2
nft insert rule ip filter INPUT counter log queue-threshold 2 group 0

$ sudo iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" group 32

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_NFLOG.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 53976d2..e1c9f65 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -8,6 +8,8 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFLOG.h>
 
+#define DEFAULT_GROUP 0
+
 enum {
 	O_GROUP = 0,
 	O_PREFIX,
@@ -89,14 +91,17 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 static void nflog_print_xlate(const struct xt_nflog_info *info,
 			      struct xt_buf *buf)
 {
+	xt_buf_add(buf, "log ");
 	if (info->prefix[0] != '\0')
-		xt_buf_add(buf, "log prefix \\\"%s\\\" ", info->prefix);
-	if (info->group)
-		xt_buf_add(buf, "log group %u ", info->group);
+		xt_buf_add(buf, "prefix \\\"%s\\\" ", info->prefix);
 	if (info->len)
-		xt_buf_add(buf, "log snaplen %u ", info->len);
+		xt_buf_add(buf, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
-		xt_buf_add(buf, "log queue-threshold %u ", info->threshold);
+		xt_buf_add(buf, "queue-threshold %u ", info->threshold);
+	if (info->group)
+		xt_buf_add(buf, "group %u ", info->group);
+	else
+		xt_buf_add(buf, "group %u ", DEFAULT_GROUP);
 }
 
 static int NFLOG_xlate(const struct xt_entry_target *target,
-- 
1.9.1

