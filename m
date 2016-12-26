From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: [PATCH xtables-addons] build: support for Linux 4.9
Date: Mon, 26 Dec 2016 16:11:43 +0100
Message-ID: <1482765103-31863-1-git-send-email-ralph.sennhauser@gmail.com>
Cc: Ralph Sennhauser <ralph.sennhauser@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34115 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbcLZPMQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Dec 2016 10:12:16 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so15242213wmi.1
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Dec 2016 07:12:15 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit f330a7fdbe1611104622faff7e614a246a7d20f0 (netfilter: conntrack:
get rid of conntrack timer) replaces timer_list with an u32, use helper
from commit c8607e020014cf11a61601a0005270bad81cabdf (netfilter: nft_ct:
fix expiration getter).

Signed-off-by: Ralph Sennhauser <ralph.sennhauser@gmail.com>
---
 extensions/xt_LOGMARK.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/xt_LOGMARK.c b/extensions/xt_LOGMARK.c
index 271931b..7616962 100644
--- a/extensions/xt_LOGMARK.c
+++ b/extensions/xt_LOGMARK.c
@@ -58,8 +58,12 @@ static void logmark_ct(const struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 		printk("%s""ASSURED", prev++ ? "," : "");
 	if (ct->status & IPS_CONFIRMED)
 		printk("%s""CONFIRMED", prev++ ? "," : "");
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,9,0)
+	printk(" lifetime=%lus", nf_ct_expires(ct) / HZ);
+#else
 	printk(" lifetime=%lus",
 	       (jiffies - ct->timeout.expires) / HZ);
+#endif
 }
 
 static unsigned int
-- 
2.7.3

